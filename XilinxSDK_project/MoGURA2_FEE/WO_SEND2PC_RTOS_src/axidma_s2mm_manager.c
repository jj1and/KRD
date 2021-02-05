#include "axidma_s2mm_manager.h"

#include "hardware_trigger_manager.h"
#include "xdebug.h"
#include "xil_exception.h"

/*
 * Flags interrupt handlers use to notify the application context the events.
 */
static volatile int RxDone;
static volatile int Error;

// AXI-DMA related variables
static XAxiDma AxiDma;
static u64 *RxBufferWrPtr = (u64 *)RX_BUFFER_BASE;
static u64 *RxBufferRdPtr = (u64 *)RX_BUFFER_BASE;

/*****************************************************************************/
/*
 *
 * This is the DMA RX interrupt handler function
 *
 * It gets the interrupt status from the hardware, acknowledges it, and if any
 * error happens, it resets the hardware. Otherwise, if a completion interrupt
 * is present, then it sets the RxDone flag.
 *
 * @param	Callback is a pointer to RX channel of the DMA engine.
 *
 * @return	None.
 *
 * @note		None.
 *
 ******************************************************************************/
static void RxIntrHandler(void *Callback) {
    XAxiDma *AxiDmaInst = (XAxiDma *)Callback;
    BaseType_t xHigherPriorityTaskWoken = pdFALSE;
    u32 S2MM_Status;
    u32 IrqStatus;
    int TimeOut;

    /* Read pending interrupts */
    IrqStatus = XAxiDma_IntrGetIrq(AxiDmaInst, XAXIDMA_DEVICE_TO_DMA);
    /* Acknowledge pending interrupts */
    XAxiDma_IntrAckIrq(AxiDmaInst, IrqStatus, XAXIDMA_DEVICE_TO_DMA);

    /*
     * If no interrupt is asserted, we do not do anything
     */
    if (!(IrqStatus & XAXIDMA_IRQ_ALL_MASK)) {
        return;
    }

    /*
     * If error interrupt is asserted, raise error flag, reset the
     * hardware to recover from the error, and return with no further
     * processing.
     */
    if ((IrqStatus & XAXIDMA_IRQ_ERROR_MASK)) {
        Error = 1;
        S2MM_Status = XAxiDma_ReadReg(AxiDmaInst->RegBase + XAXIDMA_RX_OFFSET, XAXIDMA_SR_OFFSET);
        xil_printf("Error! S2MM status: %x\r\n", S2MM_Status);
        /* Reset could fail and hang
         * NEED a way to handle this or do not call it??
         */
        XAxiDma_Reset(AxiDmaInst);
        TimeOut = RESET_TIMEOUT_COUNTER;
        while (TimeOut) {
            if (XAxiDma_ResetIsDone(AxiDmaInst)) {
                break;
            }
            TimeOut -= 1;
        }
    }

    if ((IrqStatus & XAXIDMA_IRQ_IOC_MASK)) {
        RxDone = 1;
    }
    //	set_timing_ticks(TYPE_DMA_INTR_END);
    // } else if ((IrqStatus & XAXIDMA_IRQ_IOC_MASK)) {
    // 	vTaskNotifyGiveFromISR(xRxDmaTask, &xHigherPriorityTaskWoken_byNotify);
    // 	portYIELD_FROM_ISR(xHigherPriorityTaskWoken_byNotify);
    // }

#ifdef FREE_RTOS
    vTaskNotifyGiveFromISR(xDmaTask, &xHigherPriorityTaskWoken);
    portYIELD_FROM_ISR(xHigherPriorityTaskWoken);
#endif
    return;
}

int SetupRxIntrSystem(INTC *IntcInstancePtr, u16 RxIntrId) {
    int Status;

#ifdef XPAR_INTC_0_DEVICE_ID
    Status = XIntc_Connect(IntcInstancePtr, RxIntrId, (XInterruptHandler)RxIntrHandler, &AxiDma);
    if (Status != XST_SUCCESS) {
        xil_printf("Failed rx connect intc\r\n");
        return XST_FAILURE;
    }

    XIntc_Enable(IntcInstancePtr, RxIntrId);

#elif defined(FREE_RTOS)
    XScuGic_SetPriorityTriggerType(IntcInstancePtr, RxIntrId, 0xA1, 0x3);
    Status = XScuGic_Connect(IntcInstancePtr, RxIntrId, (Xil_InterruptHandler)RxIntrHandler, &AxiDma);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    XScuGic_Enable(IntcInstancePtr, RxIntrId);
#else

    XScuGic_SetPriorityTriggerType(IntcInstancePtr, RxIntrId, 0xA0, 0x3);
    /*
     * Connect the device driver handler that will be called when an
     * interrupt for the device occurs, the handler defined above performs
     * the specific interrupt processing for the device.
     */
    Status = XScuGic_Connect(IntcInstancePtr, RxIntrId, (Xil_InterruptHandler)RxIntrHandler, &AxiDma);
    if (Status != XST_SUCCESS) {
        return Status;
    }

    XScuGic_Enable(IntcInstancePtr, RxIntrId);

#endif

#ifndef FREE_RTOS
    /* Enable interrupts from the hardware */

    Xil_ExceptionInit();
    Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT, (Xil_ExceptionHandler)INTC_HANDLER, (void *)IntcInstancePtr);
    Xil_ExceptionEnable();
#endif

    return XST_SUCCESS;
}

int axidma_setup() {
    int Status;
    XAxiDma_Config *DmaConfig;

    xil_printf("\n\nSetup AXI-DMA...\r\n");
    DmaConfig = XAxiDma_LookupConfig(DMA_DEV_ID);
    if (!DmaConfig) {
        xil_printf("No config found for %d\r\n", DMA_DEV_ID);
        return XST_FAILURE;
    }

    /* Initialize DMA engine */
    Status = XAxiDma_CfgInitialize(&AxiDma, DmaConfig);
    if (Status != XST_SUCCESS) {
        xil_printf("Failed initialize config\r\n");
        return XST_FAILURE;
    }

    if (XAxiDma_HasSg(&AxiDma)) {
        xil_printf("Device configured as SG mode\r\n");
        return XST_FAILURE;
    }

#ifndef FREE_RTOS
    xil_printf("\nSet up Interrupt system \n");
    /* Set up Interrupt system  */
    Status = SetupIntrSystem(&Intc, &AxiDma, RX_INTR_ID);
    if (Status != XST_SUCCESS) {
        xil_printf("Failed intr setup\r\n");
        return XST_FAILURE;
    }
#endif

    xil_printf("\nInitialize DMA engine\r\n");
    /* Disable all interrupts before setup */
    XAxiDma_IntrDisable(&AxiDma, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DEVICE_TO_DMA);
    /* Enable all interrupts */
    XAxiDma_IntrEnable(&AxiDma, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DEVICE_TO_DMA);

    xil_printf("AXI-DMA Setup is done successfully.\r\n");
    return XST_SUCCESS;
}

int axidma_recv_buff() {
    int Status;
    /* Initialize flags before start transfer test  */
    Error = 0;
    RxDone = 0;

    if (!buff_will_be_full(MAX_PKT_LEN / sizeof(u64))) {
        Status = XAxiDma_SimpleTransfer(&AxiDma, (UINTPTR)RxBufferWrPtr, MAX_PKT_LEN, XAXIDMA_DEVICE_TO_DMA);
        if (Status == XST_FAILURE) {
            xil_printf("DMA internal buffer is empty.\r\n");
            return XST_FAILURE;
        } else if (Status == XST_INVALID_PARAM) {
            xil_printf("Simple transfer Failed because of parameter setting\r\n");
            return XST_FAILURE;
        }
    } else {
        xil_printf("RX buffer will be full.\r\n");
        return XST_FAILURE;
    }

    return XST_SUCCESS;
}

int axidma_stopDma() {
    int Status;
    Status = XAxiDma_Pause(&AxiDma);
    if (Status == XST_NOT_SGDMA) {
        xil_printf("ERROR: AXI Dma is not initialized");
        return XST_FAILURE;
    }
    return Status;
}

int incr_wrptr_after_write(u64 size) {
    u64 *expectedPtr;
    expectedPtr = (u64 *)RX_BUFFER_HIGH - MAX_PKT_LEN / sizeof(u64) - size;
    if (RxBufferWrPtr > expectedPtr) {
        xil_printf("Buffer is full\r\n");
        return -1;
    } else {
        RxBufferWrPtr = RxBufferWrPtr + size;
    }
    return 0;
}

int decr_wrptr_after_read(u64 size) {
    u64 *expectedPtr;
    expectedPtr = (u64 *)RX_BUFFER_BASE + size;
    if (RxBufferWrPtr < expectedPtr) {
        xil_printf("Buffer is empty\r\n");
        return -1;
    } else {
        RxBufferWrPtr = RxBufferWrPtr - size;
    }
    return 0;
}

int incr_rdptr_after_read(u64 size) {
    if (RxBufferRdPtr > RxBufferWrPtr) {
        xil_printf("Buffer is empty\r\n");
        RxBufferRdPtr = RxBufferWrPtr;
        return -1;
    } else {
        RxBufferRdPtr = RxBufferRdPtr + size;
    }
    return 0;
}

void flush_ptr() {
    RxBufferWrPtr = (u64 *)RX_BUFFER_BASE;
    RxBufferRdPtr = (u64 *)RX_BUFFER_BASE;
}

int buff_will_be_full(u64 size) { return (RxBufferWrPtr > (u64 *)RX_BUFFER_HIGH - size); }

int buff_will_be_empty(u64 size) { return (RxBufferWrPtr < (u64 *)RX_BUFFER_BASE + size); }

u64 *get_wrptr() { return RxBufferWrPtr; }
u64 *get_rdptr() { return RxBufferRdPtr; }

int getRxError() {
    return Error;
}

int getRxDone() {
    return RxDone;
}

void shutdown_dma() {
    xil_printf("INFO: End dma task...\r\n");
#ifndef FREE_RTOS
    DisableIntrSystem(&Intc, RX_INTR_ID);
#else
    DisableIntrSystem(&xInterruptController, RX_INTR_ID);
#endif
}
