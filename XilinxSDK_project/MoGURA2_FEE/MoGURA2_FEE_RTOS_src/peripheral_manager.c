#include "peripheral_manager.h"

#include "peripheral_controller_driver/peripheral_controller.h"
#include "xil_exception.h"

static u8 SpiBaseDacWrBuffer[BASEDAC_DAC_NUM];
static u8 SpiBaseDacRdBuffer[BASEDAC_DAC_NUM];

static void SpiLadcIntrHandler(void *CallBackRef, u32 StatusEvent, u32 ByteCount) {
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
}

static void SpiBaseDacIntrHandler(void *CallBackRef, u32 StatusEvent, u32 ByteCount) {
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
}

int SetupSpiIntrSystem(INTC *IntcInstancePtr, XSpi *SpiInstancePtr, u16 SpiIntrId) {
    int Status;

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

// static int SetupCDCI6214Reg() {
//     int Status;
//     u32 cdci6214_status;
//     Status = XGpio_Initialize(&Cdci6214RegGpio, CDCI6214_REG_CONFIG_GPIO_DEVICE_ID);
//     if (Status != XST_SUCCESS) {
//         xil_printf("ERROR: Failed to initialize CDCI6214 Register GPIO\r\n");
//         return XST_FAILURE;
//     }
//     XGpio_SetDataDirection(&Cdci6214RegGpio, 1, 0x0);
//     XGpio_DiscreteWrite(&Cdci6214RegGpio, 1, CDCI6214_DEFAULT_REG);
//     xil_printf("INFO: Set CDCI6214 Register: %08x\r\n", CDCI6214_DEFAULT_REG);

//     XGpio_SetDataDirection(&Cdci6214RegGpio, 1, 0x1);
//     cdci6214_status = XGpio_DiscreteRead(&Cdci6214RegGpio, 1) & 0x00000002;
//     xil_printf("INFO: CDCI6214 Status is %08x\r\n", cdci6214_status);

//     return XST_SUCCESS;
// }

// static int SetupLADCReg() {
//     int Status;

//     Status = XGpio_Initialize(&LadcRegRSTGpio, CDCI6214_REG_CONFIG_GPIO_DEVICE_ID);
//     if (Status != XST_SUCCESS) {
//         xil_printf("ERROR: Failed to initialize LADC Reset Register GPIO\r\n");
//         return XST_FAILURE;
//     }

//     Status = XGpio_Initialize(&LadcRegCtrlGpio, CDCI6214_REG_CONFIG_GPIO_DEVICE_ID);
//     if (Status != XST_SUCCESS) {
//         xil_printf("ERROR: Failed to initialize LADC Ctrl Register GPIO\r\n");
//         return XST_FAILURE;
//     }

//     Status = XGpio_Initialize(&LadcRegSenGpio, CDCI6214_REG_CONFIG_GPIO_DEVICE_ID);
//     if (Status != XST_SUCCESS) {
//         xil_printf("ERROR: Failed to initialize LADC Sen Register GPIO\r\n");
//         return XST_FAILURE;
//     }

//     XGpio_SetDataDirection(&LadcRegRSTGpio, 1, 0x0);
//     XGpio_SetDataDirection(&LadcRegCtrlGpio, 1, 0x0);
//     XGpio_SetDataDirection(&LadcRegSenGpio, 1, 0x0);

//     XGpio_DiscreteWrite(&LadcRegRSTGpio, 1, LADC_RESET_DEFAULT_REG);
//     xil_printf("INFO: Set LADC RESET Register: %08x\r\n", LADC_RESET_DEFAULT_REG);

//     XGpio_DiscreteWrite(&LadcRegCtrlGpio, 1, LADC_CTRL_DEFAULT_REG);
//     xil_printf("INFO: Set LADC CTRL Register: %08x\r\n", LADC_CTRL_DEFAULT_REG);

//     XGpio_DiscreteWrite(&LadcRegSenGpio, 1, LADC_SEN_DEFAULT_REG);
//     xil_printf("INFO: Set LADC SEN Register: %08x\r\n", LADC_SEN_DEFAULT_REG);

//     return XST_SUCCESS;
// }

int setup_peripheral() {
    int Status;
    xil_printf("INFO: Peripheral setup");
    Peripheral_PrintAppliedCfg(PERIPHERAL_CONTROLLER_0_DEVICE_ID);
    // if (SetupCDCI6214Reg() != XST_SUCCESS) return XST_FAILURE;
    // if (SetupLADCReg() != XST_SUCCESS) return XST_FAILURE;
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
        SpiBaseDacWrBuffer[i * 2 + 0] = (inputword & 0xFF00) >> 8;  //  MSB
        SpiBaseDacWrBuffer[i * 2 + 1] = inputword & 0x00FF;         // LSB

        SpiBaseDacRdBuffer[i * 2 + 0] = 0x0000;
        SpiBaseDacRdBuffer[i * 2 + 1] = 0x0000;
    }

    return XST_SUCCESS;
}

// int LADC_Config(u8 Addr, u8 data) {
//     int Status;
//     Status = XSpi_SetOptions(&SpiLadc, XSP_MASTER_OPTION | XSP_MANUAL_SSELECT_OPTION);
//     if (Status != XST_SUCCESS) return XST_FAILURE;

//     Status = XSpi_SetSlaveSelect(&SpiLadc, 1);
//     if (Status != XST_SUCCESS) return XST_FAILURE;

//     XSpi_Start(&SpiLadc);

//     return Status;
// }

int BaselineDAC_Config(u16 baseline) {
    int Status;

    Status = XSpi_SetOptions(&SpiBaseDac, XSP_MASTER_OPTION | XSP_MANUAL_SSELECT_OPTION);
    if (Status != XST_SUCCESS) return XST_FAILURE;

    Status = XSpi_SetSlaveSelect(&SpiBaseDac, 1);
    if (Status != XST_SUCCESS) return XST_FAILURE;

    XSpi_Start(&SpiBaseDac);

    for (u16 i = 0; i < BASEDAC_DAC_NUM; i++) {
        u16 dac_addr = i + 1;
        u16 inputword = ((dac_addr << 12) & 0xF000) | ((baseline & 0x0FFF) << 2);
        SpiBaseDacWrBuffer[i * 2 + 0] = (inputword & 0xFF00) >> 8;  //  MSB
        SpiBaseDacWrBuffer[i * 2 + 1] = inputword & 0x00FF;         // LSB

        SpiBaseDacRdBuffer[i * 2 + 0] = 0x0000;
        SpiBaseDacRdBuffer[i * 2 + 1] = 0x0000;
    }

    int error_occured = 0;
    for (int i = 0; i < BASEDAC_DAC_NUM; i++) {
        SPI_BASEDAC_Error = 0;
        SPI_BASEDAC_TransferInProgress = TRUE;
        XSpi_Transfer(&SpiBaseDac, &SpiBaseDacWrBuffer[i * 2], SpiBaseDacRdBuffer[i * 2], 2);
        while (SPI_BASEDAC_TransferInProgress)
            ;
        xil_printf("INFO: Set Baseline DAC[%d]: %04x (Error count == %d)\r\n", i, ((u16)SpiBaseDacWrBuffer[i * 2] << 8) | (u16)SpiBaseDacWrBuffer[i * 2 + 1], SPI_BASEDAC_Error);
        if (SPI_BASEDAC_Error > 0) {
            error_occured = 1;
        }
    }

    if (error_occured == 0) {
        Status = XST_FAILURE;
    } else {
        Status = XST_SUCCESS;
    }

    return Status;
}

void BaselineDac_disableIntr() {
    xil_printf("INFO: disable baseline DAC Intr.\r\n");
#ifndef FREE_RTOS
    DisableIntrSystem(&Intc, RX_INTR_ID);
#else
    DisableIntrSystem(&xInterruptController, SPI_BASEDAC_INTR);
#endif
}
