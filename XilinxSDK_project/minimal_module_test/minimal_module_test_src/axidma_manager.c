#include "axidma_manager.h"

#include "xdebug.h"
#include "xil_exception.h"

static u64 *RxBufferWrPtr = (u64 *)RX_BUFFER_BASE;
// static u8 RxBufferWrPtrLoop = 1;
// static u64 *RxBufferRdPtr = (u64 *)RX_BUFFER_BASE;
// static u8 RxBufferRdPtrLoop = 1;
static u16 *TxBufferPtr = (u16 *)TX_BUFFER_BASE;

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
    return;
}

/*****************************************************************************/
/*
*
* This is the DMA TX Interrupt handler function.
*
* It gets the interrupt status from the hardware, acknowledges it, and if any
* error happens, it resets the hardware. Otherwise, if a completion interrupt
* is present, then sets the TxDone.flag
*
* @param	Callback is a pointer to TX channel of the DMA engine.
*
* @return	None.
*
* @note		None.
*
******************************************************************************/
static void TxIntrHandler(void *Callback) {
    XAxiDma *AxiDmaInst = (XAxiDma *)Callback;
    u32 MM2S_Status;
    u32 IrqStatus;
    int TimeOut;

    /* Read pending interrupts */
    IrqStatus = XAxiDma_IntrGetIrq(AxiDmaInst, XAXIDMA_DMA_TO_DEVICE);

    /* Acknowledge pending interrupts */
    XAxiDma_IntrAckIrq(AxiDmaInst, IrqStatus, XAXIDMA_DMA_TO_DEVICE);

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
        MM2S_Status = XAxiDma_ReadReg(AxiDmaInst->RegBase + XAXIDMA_TX_OFFSET, XAXIDMA_SR_OFFSET);
        xil_printf("Error! MM2S status: %x\r\n", MM2S_Status);
        /*
		 * Reset should never fail for transmit channel
		 */
        XAxiDma_Reset(AxiDmaInst);
        TimeOut = RESET_TIMEOUT_COUNTER;
        while (TimeOut) {
            if (XAxiDma_ResetIsDone(AxiDmaInst)) {
                break;
            }
            TimeOut -= 1;
        }
        return;
    }

    /*
	 * If Completion interrupt is asserted, then set the TxDone flag
	 */
    if ((IrqStatus & XAXIDMA_IRQ_IOC_MASK)) {
        TxDone = 1;
    }
    return;
}

int InitIntrController(INTC *IntcInstancePtr) {
    int Status;
    XScuGic_Config *IntcConfig;

#ifdef XPAR_INTC_0_DEVICE_ID

    /* Initialize the interrupt controller and connect the ISRs */
    Status = XIntc_Initialize(IntcInstancePtr, INTC_DEVICE_ID);
    if (Status != XST_SUCCESS) {
        xil_printf("Failed init intc\r\n");
        return XST_FAILURE;
    }

#else
    /*
	 * Initialize the interrupt controller driver so that it is ready to
	 * use.
	 */
    IntcConfig = XScuGic_LookupConfig(INTC_DEVICE_ID);
    if (NULL == IntcConfig) {
        return XST_FAILURE;
    }

    Status = XScuGic_CfgInitialize(IntcInstancePtr, IntcConfig,
                                   IntcConfig->CpuBaseAddress);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

#endif
    return XST_SUCCESS;
}

int StartXIntc(INTC *IntcInstancePtr) {
#ifdef XPAR_INTC_0_DEVICE_ID
    int Status;
    /* Start the interrupt controller */
    Status = XIntc_Start(IntcInstancePtr, XIN_REAL_MODE);
    if (Status != XST_SUCCESS) {
        xil_printf("Failed to start intc\r\n");
        return XST_FAILURE;
    }
#else
    return XST_SUCCESS;
#endif
}

int SetupTxIntrSystem(INTC *IntcInstancePtr,
                      XAxiDma *AxiDmaPtr, u16 TxIntrId) {
    int Status;

#ifdef XPAR_INTC_0_DEVICE_ID

    Status = XIntc_Connect(IntcInstancePtr, TxIntrId,
                           (XInterruptHandler)TxIntrHandler, AxiDmaPtr);
    if (Status != XST_SUCCESS) {
        xil_printf("Failed tx connect intc\r\n");
        return XST_FAILURE;
    }

    XIntc_Enable(IntcInstancePtr, TxIntrId);

#elif defined(FREE_RTOS)

    XScuGic_SetPriorityTriggerType(IntcInstancePtr, TxIntrId, 0xA0, 0x3);

    Status = XScuGic_Connect(IntcInstancePtr, TxIntrId,
                             (Xil_InterruptHandler)TxIntrHandler,
                             AxiDmaPtr);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    XScuGic_Enable(IntcInstancePtr, TxIntrId);
#else

    XScuGic_SetPriorityTriggerType(IntcInstancePtr, TxIntrId, 0xA0, 0x3);
    /*
	 * Connect the device driver handler that will be called when an
	 * interrupt for the device occurs, the handler defined above performs
	 * the specific interrupt processing for the device.
	 */
    Status = XScuGic_Connect(IntcInstancePtr, TxIntrId,
                             (Xil_InterruptHandler)TxIntrHandler,
                             AxiDmaPtr);
    if (Status != XST_SUCCESS) {
        return Status;
    }

    XScuGic_Enable(IntcInstancePtr, TxIntrId);

#endif

#ifndef FREE_RTOS
    /* Enable interrupts from the hardware */

    Xil_ExceptionInit();
    Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT, (Xil_ExceptionHandler)INTC_HANDLER, (void *)IntcInstancePtr);
    Xil_ExceptionEnable();
#endif
    return XST_SUCCESS;
}

int SetupRxIntrSystem(INTC *IntcInstancePtr,
                      XAxiDma *AxiDmaPtr, u16 RxIntrId) {
    int Status;

#ifdef XPAR_INTC_0_DEVICE_ID
    Status = XIntc_Connect(IntcInstancePtr, RxIntrId,
                           (XInterruptHandler)RxIntrHandler, AxiDmaPtr);
    if (Status != XST_SUCCESS) {
        xil_printf("Failed rx connect intc\r\n");
        return XST_FAILURE;
    }

    XIntc_Enable(IntcInstancePtr, RxIntrId);

#elif defined(FREE_RTOS)
    XScuGic_SetPriorityTriggerType(IntcInstancePtr, RxIntrId, 0xA1, 0x3);
    Status = XScuGic_Connect(IntcInstancePtr, RxIntrId,
                             (Xil_InterruptHandler)RxIntrHandler,
                             AxiDmaPtr);
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
    Status = XScuGic_Connect(IntcInstancePtr, RxIntrId,
                             (Xil_InterruptHandler)RxIntrHandler,
                             AxiDmaPtr);
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

/*****************************************************************************/
/**
*
* This function disables the interrupts for DMA engine.
*
* @param	IntcInstancePtr is the pointer to the INTC component instance
* @param	IntrId is interrupt ID associated w/ DMA RX channel
*
* @return	None.
*
* @note		None.
*
******************************************************************************/
static void DisableIntrSystem(INTC *IntcInstancePtr, u16 IntrId) {
#ifdef XPAR_INTC_0_DEVICE_ID
    /* Disconnect the interrupts for the DMA TX and RX channels */
    XIntc_Disconnect(IntcInstancePtr, IntrId);
#else
    XScuGic_Disconnect(IntcInstancePtr, IntrId);
#endif
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
    XAxiDma_IntrDisable(&AxiDma, XAXIDMA_IRQ_ALL_MASK,
                        XAXIDMA_DMA_TO_DEVICE);
    XAxiDma_IntrDisable(&AxiDma, XAXIDMA_IRQ_ALL_MASK,
                        XAXIDMA_DEVICE_TO_DMA);
    /* Enable all interrupts */
    XAxiDma_IntrEnable(&AxiDma, XAXIDMA_IRQ_ALL_MASK,
                       XAXIDMA_DMA_TO_DEVICE);
    XAxiDma_IntrEnable(&AxiDma, XAXIDMA_IRQ_ALL_MASK,
                       XAXIDMA_DEVICE_TO_DMA);

    xil_printf("AXI-DMA Setup is done successfully.\r\n");
    return XST_SUCCESS;
}

static void assign_adc_sample(u16 *tx_buff_ptr, short int adc_sample) {
    if (adc_sample > 2046) {
        adc_sample = 2047;
    } else if (adc_sample < -2047) {
        adc_sample = -2048;
    }

    *tx_buff_ptr = (adc_sample & 0x8000) | (adc_sample << 4);
}

int generate_signal(u16 *tx_buff_ptr, int pre_time, int rise_time, int high_time, int fall_time, int post_time, int max_val, int baseline, int print_enable) {
    int signal_length = pre_time + rise_time + high_time + fall_time + post_time;
    int remain = signal_length % 8;
    short int sample;
    if (signal_length + remain <= MAX_GENERATBLE_TRIGGER_LEN) {
        // assign data to TxBufferPtr
        for (int i = 0; i < signal_length + remain; i++) {
            if (i < pre_time) {
                sample = baseline;
            } else if ((i >= pre_time) & (i < pre_time + rise_time)) {
                sample = (i - pre_time) * (max_val - baseline) / rise_time + baseline;
            } else if ((i >= pre_time + rise_time) & (i < pre_time + rise_time + high_time)) {
                sample = max_val;
            } else if ((i >= pre_time + rise_time + high_time) & (i < pre_time + rise_time + high_time + fall_time)) {
                sample = max_val - (i - (pre_time + rise_time + high_time)) * (max_val - baseline) / fall_time;
            } else if ((i >= pre_time + rise_time + high_time + fall_time) & (i < pre_time + rise_time + high_time + fall_time + post_time + remain)) {
                sample = baseline;
            }
            assign_adc_sample(&tx_buff_ptr[i], sample);
            if (print_enable != 0) {
                if (i % 8 == 0) {
                    xil_printf("Send : %04x ", tx_buff_ptr[i]);
                } else if ((i + 1) % 8 == 0) {
                    xil_printf("%04x\n", tx_buff_ptr[i]);
                } else {
                    xil_printf("%04x ", tx_buff_ptr[i]);
                }
            }
        }
    } else {
        xil_printf("Data length is larger than MAX_TRIGGER_LEN\r\n");
        return XST_FAILURE;
    }
    return XST_SUCCESS;
}

int axidma_send_buff(int pre_time, int rise_time, int high_time, int fall_time, int post_time, int max_val, int baseline, int print_enable) {
    int Status;
    int signal_length = pre_time + rise_time + high_time + fall_time + post_time;
    int remain = signal_length % 8;
    /* Initialize flags before start transfer test  */
    Error = 0;
    TxDone = 0;

    Status = generate_signal(TxBufferPtr, pre_time, rise_time, high_time, fall_time, post_time, max_val, baseline, print_enable);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }
    Xil_DCacheFlushRange((UINTPTR)TxBufferPtr, (signal_length + remain) * 2);

    Status = XAxiDma_SimpleTransfer(&AxiDma, (UINTPTR)TxBufferPtr, (signal_length + remain) * 2, XAXIDMA_DMA_TO_DEVICE);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }
    return XST_SUCCESS;
}

int axidma_recv_buff() {
    int Status;
    /* Initialize flags before start transfer test  */
    Error = 0;
    RxDone = 0;

    if (!buff_will_be_full(MAX_PKT_LEN / sizeof(u64))) {
        Status = XAxiDma_SimpleTransfer(&AxiDma, (UINTPTR)RxBufferWrPtr,
                                        MAX_PKT_LEN, XAXIDMA_DEVICE_TO_DMA);
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

// int incr_rdptr_after_read(u64 size){
// 	u64 word_size = size/sizeof(u64);
// 	if (RxBufferRdPtr > (u64 *)RX_BUFFER_HIGH - word_size) {
// 		if ((RxBufferRdPtr+word_size-(u64 *)RX_BUFFER_HIGH+(u64 *)RX_BUFFER_BASE > RxBufferWrPtr)&&(RxBufferRdPtrLoop!=RxBufferWrPtrLoop)) {
// 			xil_printf("Buffer is empty\r\n");
// 			return -1;
// 		} else {
// 			RxBufferRdPtr = RxBufferRdPtr+word_size-(u64 *)RX_BUFFER_HIGH+(u64 *)RX_BUFFER_BASE;
// 			RxBufferRdPtrLoop = ~RxBufferRdPtrLoop;
// 		}
// 	} else {
// 		if ((RxBufferRdPtr+word_size>RxBufferWrPtr)&&(RxBufferRdPtrLoop==RxBufferWrPtrLoop)) {
// 			xil_printf("Buffer is empty\r\n");
// 			return -1;
// 		} else {
// 			RxBufferRdPtr = RxBufferRdPtr + word_size;
// 		}
// 	}
// 	return 0;
// }

int buff_will_be_full(u64 size) {
    return (RxBufferWrPtr > (u64 *)RX_BUFFER_HIGH - size);
}

int buff_will_be_empty(u64 size) {
    return (RxBufferWrPtr < (u64 *)RX_BUFFER_BASE + size);
}

u64 *get_wrptr() {
    return RxBufferWrPtr;
}

// u64* get_rdptr(){
// 	return RxBufferRdPtr;
// }

void shutdown_dma() {
    xil_printf("End dma task...\r\n");
#ifndef FREE_RTOS
    DisableIntrSystem(&Intc, TX_INTR_ID);
    DisableIntrSystem(&Intc, RX_INTR_ID);
#else
    DisableIntrSystem(&xInterruptController, TX_INTR_ID);
    DisableIntrSystem(&xInterruptController, RX_INTR_ID);
#endif
}
