#include "peripheral_manager.h"

#include "peripheral_controller_driver/peripheral_controller.h"
#include "unistd.h"
#include "xil_exception.h"

static volatile int SPI_LADC_TransferInProgress;
static int SPI_LADC_Error;

static volatile int SPI_BASEDAC_TransferInProgress;
static int SPI_BASEDAC_Error;

static XSpi SpiLadc;
static XSpi SpiBaseDac;

static u8 SpiBaseDacWrBuffer[BASEDAC_DAC_NUM * 2];
// static u8 SpiBaseDacRdBuffer[BASEDAC_DAC_NUM * 2];

static u8 SpiLadcWrBuffer[LADC_ADDR_NUM * 2];
static u8 SpiLadcRdBuffer[LADC_ADDR_NUM * 2];

static void SpiLadcIntrHandler(void *CallBackRef, u32 StatusEvent, u32 ByteCount) {
    BaseType_t xHigherPriorityTaskWoken = pdFALSE;
    /*
	 * Indicate the transfer on the SPI bus is no longer in progress
	 * regardless of the status event.
	 */

    SPI_LADC_TransferInProgress = FALSE;

    /*
	 * If the event was not transfer done, then track it as an error.
	 */
    if (StatusEvent != XST_SPI_TRANSFER_DONE) {
        SPI_LADC_Error++;
    }
#ifdef FREE_RTOS
    vTaskNotifyGiveFromISR(cmd_thread, &xHigherPriorityTaskWoken);
    portYIELD_FROM_ISR(xHigherPriorityTaskWoken);
#endif
    return;
}

static void SpiBaseDacIntrHandler(void *CallBackRef, u32 StatusEvent, u32 ByteCount) {
    BaseType_t xHigherPriorityTaskWoken = pdFALSE;
    /*
	 * Indicate the transfer on the SPI bus is no longer in progress
	 * regardless of the status event.
	 */
    SPI_BASEDAC_TransferInProgress = FALSE;

    /*
	 * If the event was not transfer done, then track it as an error.
	 */
    if (StatusEvent != XST_SPI_TRANSFER_DONE) {
        SPI_BASEDAC_Error++;
    }
#ifdef FREE_RTOS
    vTaskNotifyGiveFromISR(cmd_thread, &xHigherPriorityTaskWoken);
    portYIELD_FROM_ISR(xHigherPriorityTaskWoken);
#endif
    return;
}

int SetupSpiIntrSystem(INTC *IntcInstancePtr, u16 SpiIntrId) {
    int Status;
    XSpi *SpiInstancePtr;
    if (SpiIntrId == SPI_BASEDAC_INTR) {
        SpiInstancePtr = &SpiBaseDac;
    } else if (SpiIntrId == SPI_LADC_INTR) {
        SpiInstancePtr = &SpiLadc;
    } else {
        xil_printf("ERROR: No device matched with Intr ID: %d is found.\r\n", SpiIntrId);
        return XST_FAILURE;
    }

#ifdef XPAR_INTC_0_DEVICE_ID
    Status = XIntc_Connect(IntcInstancePtr, SpiIntrId, (XInterruptHandler)XSpi_InterruptHandler, SpiInstancePtr);
    if (Status != XST_SUCCESS) {
        xil_printf("Failed connect spi intc\r\n");
        return XST_FAILURE;
    }

    XIntc_Enable(IntcInstancePtr, SpiIntrId);

#elif defined(FREE_RTOS)
    XScuGic_SetPriorityTriggerType(IntcInstancePtr, SpiIntrId, 0xA1, 0x3);
    Status = XScuGic_Connect(IntcInstancePtr, SpiIntrId, (Xil_InterruptHandler)XSpi_InterruptHandler, SpiInstancePtr);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    XScuGic_Enable(IntcInstancePtr, SpiIntrId);
#else

    XScuGic_SetPriorityTriggerType(IntcInstancePtr, SpiIntrId, 0xA0, 0x3);
    /*
     * Connect the device driver handler that will be called when an
     * interrupt for the device occurs, the handler defined above performs
     * the specific interrupt processing for the device.
     */
    Status = XScuGic_Connect(IntcInstancePtr, SpiIntrId, (Xil_InterruptHandler)XSpi_InterruptHandler, SpiInstancePtr);
    if (Status != XST_SUCCESS) {
        return Status;
    }

    XScuGic_Enable(IntcInstancePtr, SpiIntrId);

#endif

#ifndef FREE_RTOS
    /* Enable interrupts from the hardware */

    Xil_ExceptionInit();
    Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT, (Xil_ExceptionHandler)INTC_HANDLER, (void *)IntcInstancePtr);
    Xil_ExceptionEnable();
#endif

    if (SpiIntrId == SPI_LADC_INTR) {
        XSpi_SetStatusHandler(&SpiLadc, &SpiLadc, (XSpi_StatusHandler)SpiLadcIntrHandler);
    } else {
        XSpi_SetStatusHandler(&SpiBaseDac, &SpiBaseDac, (XSpi_StatusHandler)SpiBaseDacIntrHandler);
    }

    return XST_SUCCESS;
}

int peripheral_setup() {
    int Status;
    xil_printf("INFO: Peripheral setup");
    // Peripheral_PrintAppliedCfg(PERIPHERAL_CONTROLLER_0_DEVICE_ID);
    // if (SetupCDCI6214Reg() != XST_SUCCESS) return XST_FAILURE;
    // if (SetupLADCReg() != XST_SUCCESS) return XST_FAILURE;
    Peripheral_LadcReset(PERIPHERAL_CONTROLLER_0_DEVICE_ID);

    if (Peripheral_SetConfigDefault(PERIPHERAL_CONTROLLER_0_DEVICE_ID) != XST_SUCCESS) return XST_FAILURE;
    Peripheral_PrintCfgPtr(PERIPHERAL_CONTROLLER_0_DEVICE_ID);
    if (Peripheral_ApplyCfg(PERIPHERAL_CONTROLLER_0_DEVICE_ID) != XST_SUCCESS) return XST_FAILURE;
    Peripheral_PrintAppliedCfg(PERIPHERAL_CONTROLLER_0_DEVICE_ID);

    // if (Peripheral_SetCdci6214Config(PERIPHERAL_CONTROLLER_0_DEVICE_ID, CDCI6214_EEPROM_PAGE0 | CDCI6214_OE_DISABLE | CDCI6214_REF_SEL_XIN) != XST_SUCCESS) return XST_FAILURE;
    // Peripheral_PrintCfgPtr(PERIPHERAL_CONTROLLER_0_DEVICE_ID);
    // if (Peripheral_ApplyCfg(PERIPHERAL_CONTROLLER_0_DEVICE_ID) != XST_SUCCESS) return XST_FAILURE;
    // Peripheral_PrintAppliedCfg(PERIPHERAL_CONTROLLER_0_DEVICE_ID);

    XSpi_Config *SPI_LADC_ConfigPtr;
    XSpi_Config *SPI_BASEDAC_ConfigPtr;

    // Low gain ADC SPI instance initialize
    SPI_LADC_ConfigPtr = XSpi_LookupConfig(SPI_LADC_DEVICE_ID);
    if (SPI_LADC_ConfigPtr == NULL) {
        xil_printf("ERROR: LADC SPI Device is not found.\r\n");
        return XST_DEVICE_NOT_FOUND;
    }
    Status = XSpi_CfgInitialize(&SpiLadc, SPI_LADC_ConfigPtr,
                                SPI_LADC_ConfigPtr->BaseAddress);
    if (Status != XST_SUCCESS) return XST_FAILURE;

    SpiLadcWrBuffer[0] = LADC_SPI_OUTPUTMODE_ADDR;
    SpiLadcWrBuffer[1] = LADC_NOMALMODE;
    SpiLadcRdBuffer[0] = 0x00;
    SpiLadcRdBuffer[1] = 0x00;

    // Baseline DAC SPI instance initialize
    SPI_BASEDAC_ConfigPtr = XSpi_LookupConfig(SPI_BASEDAC_DEVICE_ID);
    if (SPI_BASEDAC_ConfigPtr == NULL) {
        xil_printf("ERROR: Baseline DAC SPI Device is not found.\r\n");
        return XST_DEVICE_NOT_FOUND;
    }
    Status = XSpi_CfgInitialize(&SpiBaseDac, SPI_BASEDAC_ConfigPtr,
                                SPI_BASEDAC_ConfigPtr->BaseAddress);
    if (Status != XST_SUCCESS) return XST_FAILURE;

    for (u16 i = 0; i < BASEDAC_DAC_NUM; i++) {
        u16 dac_addr = i + 1;
        u16 inputword = ((dac_addr << 12) & 0xF000) | ((0x0233 & 0x0FFF) << 2);
        SpiBaseDacWrBuffer[i * 2 + 0] = (u8)((inputword & 0xFF00) >> 8);  //  MSB
        SpiBaseDacWrBuffer[i * 2 + 1] = (u8)(inputword & 0x00FF);         // LSB

        // SpiBaseDacRdBuffer[i * 2 + 0] = 0x0000;
        // SpiBaseDacRdBuffer[i * 2 + 1] = 0x0000;
    }

    return XST_SUCCESS;
}

static void LADC_DataSend(u8 *SpiLadcData, int ladc_sel, int *Status) {
    SPI_LADC_Error = 0;
    XSpi_Start(&SpiLadc);
    XSpi_SetSlaveSelect(&SpiLadc, 1);
    XSpi_Transfer(&SpiLadc, &SpiLadcWrBuffer[0], &SpiLadcRdBuffer[0], 2);
    XSpi_SetSlaveSelect(&SpiLadc, 0);
    if (!ulTaskNotifyTake(pdTRUE, pdMS_TO_TICKS(2000))) {
        xil_printf("INFO: Set LADC[%d] Addr: %04x Data: %04x (Transaction time out)\r\n", ladc_sel, (u16)SpiLadcWrBuffer[0], (u16)SpiLadcWrBuffer[1], SPI_LADC_Error);
        *Status = XST_FAILURE;
    } else {
        xil_printf("INFO: Set LADC[%d] Addr: %04x Data: %04x (Error count == %d)\r\n", ladc_sel, (u16)SpiLadcWrBuffer[0], (u16)SpiLadcWrBuffer[1], SPI_LADC_Error);
        if (SPI_BASEDAC_Error > 0) {
            *Status = XST_FAILURE;
        }
    }
    XSpi_Stop(&SpiLadc);
    return;
}

int LADC_ApplyConfig(Ladc_Config *LadcCfgPtr) {
    int Status = XST_SUCCESS;

    Status = XSpi_SetOptions(&SpiLadc, XSP_MASTER_OPTION | XSP_MANUAL_SSELECT_OPTION);
    if (Status != XST_SUCCESS) return Status;

    for (u16 i = 0; i < LADC_ADC_NUM; i++) {
        Peripheral_LadcSenActive(PERIPHERAL_CONTROLLER_0_DEVICE_ID, i);

        SpiLadcWrBuffer[0] = LADC_SPI_CUSTMPTN1MSB_ADDR;
        SpiLadcWrBuffer[1] = LadcCfgPtr->TestPattern1 >> 8;
        LADC_DataSend(&SpiLadcWrBuffer[0], i, &Status);

        SpiLadcWrBuffer[0] = LADC_SPI_CUSTMPTN1LSB_ADDR;
        SpiLadcWrBuffer[1] = LadcCfgPtr->TestPattern1 & 0x00FF;
        LADC_DataSend(&SpiLadcWrBuffer[0], i, &Status);

        SpiLadcWrBuffer[0] = LADC_SPI_CUSTMPTN2MSB_ADDR;
        SpiLadcWrBuffer[1] = LadcCfgPtr->TestPattern2 >> 8;
        LADC_DataSend(&SpiLadcWrBuffer[0], i, &Status);

        SpiLadcWrBuffer[0] = LADC_SPI_CUSTMPTN2LSB_ADDR;
        SpiLadcWrBuffer[1] = LadcCfgPtr->TestPattern2 & 0x00FF;
        LADC_DataSend(&SpiLadcWrBuffer[0], i, &Status);

        SpiLadcWrBuffer[0] = LADC_SPI_OUTPUTMODE_ADDR;
        SpiLadcWrBuffer[1] = LadcCfgPtr->OperationMode;
        LADC_DataSend(&SpiLadcWrBuffer[0], i, &Status);
    }
    return Status;
}

int BaselineDAC_ApplyConfig(u16 baseline) {
    int Status = XST_SUCCESS;

    Status = XSpi_SetOptions(&SpiBaseDac, XSP_MASTER_OPTION | XSP_MANUAL_SSELECT_OPTION);
    if (Status != XST_SUCCESS) return Status;

    for (u16 i = 0; i < BASEDAC_DAC_NUM; i++) {
        u16 dac_addr = i + 1;
        u16 inputword = ((dac_addr << 12) & 0xF000) | (((baseline & 0x0FFF) << 2) & 0x0FFC);
        xil_printf("INFO: Input word %04x\r\n", inputword);
        SpiBaseDacWrBuffer[i * 2 + 0] = (u8)((inputword & 0xFF00) >> 8);  //  MSB
        SpiBaseDacWrBuffer[i * 2 + 1] = (u8)(inputword & 0x00FF);         // LSB

        // SpiBaseDacRdBuffer[i * 2 + 0] = 0x0000;
        // SpiBaseDacRdBuffer[i * 2 + 1] = 0x0000;
    }

    for (int i = 0; i < BASEDAC_DAC_NUM; i++) {
        // for (int j = 0; j < 4; j++) {
        SPI_BASEDAC_Error = 0;
        XSpi_Start(&SpiBaseDac);
        XSpi_SetSlaveSelect(&SpiBaseDac, 1);
        XSpi_Transfer(&SpiBaseDac, &SpiBaseDacWrBuffer[i * 2], NULL, 2);
        XSpi_SetSlaveSelect(&SpiBaseDac, 0);
        if (!ulTaskNotifyTake(pdTRUE, pdMS_TO_TICKS(2000))) {
            xil_printf("INFO: Set Baseline DAC[%d]: Transaction time out\r\n", i);
            Status = XST_FAILURE;
        } else {
            // ad0,ad1,ad2,ad3,d0,d1,d2,d3 |,d4,d5,d6,d7,d8,d9,0,0
            xil_printf("INFO: Set Baseline DAC: Addr:%02x Data:%03x (Error count == %d)\r\n", ((u16)SpiBaseDacWrBuffer[i * 2] >> 4), (((u16)SpiBaseDacWrBuffer[i * 2] & 0x0F) << 6) | ((u16)SpiBaseDacWrBuffer[i * 2 + 1] >> 2), SPI_BASEDAC_Error);
            if (SPI_BASEDAC_Error > 0) {
                Status = XST_FAILURE;
            }
        }
        XSpi_Stop(&SpiBaseDac);
        // }
    }

    return Status;
}

int GPO_TriggerReset() {
    if (Peripheral_SetGPO(PERIPHERAL_CONTROLLER_0_DEVICE_ID, 0x00000001) != XST_SUCCESS) {
        xil_printf("ERROR: Failed to reset PL\r\n");
        return XST_FAILURE;
    }
    sleep(1);
    if (Peripheral_SetGPO(PERIPHERAL_CONTROLLER_0_DEVICE_ID, 0x00000000) != XST_SUCCESS) {
        xil_printf("ERROR: Failed to release reset PL\r\n");
        return XST_FAILURE;
    }
    return XST_SUCCESS;
}