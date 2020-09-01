#include "axidma_s2mm_sg_manager.h"

#include "xdebug.h"
#include "xil_exception.h"

static u64 *RxBufferWrPtr = (u64 *)RX_BUFFER_BASE;
static u64 *RxBufferRdPtr = (u64 *)RX_BUFFER_BASE;

/*****************************************************************************/
/*
*
* This is the DMA RX callback function called by the RX interrupt handler.
* This function handles finished BDs by hardware, attaches new buffers to those
* BDs, and give them back to hardware to receive more incoming packets
*
* @param	RxRingPtr is a pointer to RX channel of the DMA engine.
*
* @return	None.
*
* @note		None.
*
******************************************************************************/
static void RxCallBack(XAxiDma_BdRing *RxRingPtr) {
    int BdCount;
    XAxiDma_Bd *BdPtr;
    XAxiDma_Bd *BdCurPtr;
    u32 BdSts;
    int Index;

    /* Get finished BDs from hardware */
    BdCount = XAxiDma_BdRingFromHw(RxRingPtr, XAXIDMA_ALL_BDS, &BdPtr);

    BdCurPtr = BdPtr;
    for (Index = 0; Index < BdCount; Index++) {
        /*
		 * Check the flags set by the hardware for status
		 * If error happens, processing stops, because the DMA engine
		 * is halted after this BD.
		 */
        BdSts = XAxiDma_BdGetSts(BdCurPtr);
        if ((BdSts & XAXIDMA_BD_STS_ALL_ERR_MASK) ||
            (!(BdSts & XAXIDMA_BD_STS_COMPLETE_MASK))) {
            Error = 1;
            break;
        }

        /* Find the next processed BD */
        BdCurPtr = (XAxiDma_Bd *)XAxiDma_BdRingNext(RxRingPtr, BdCurPtr);
        RxDone += 1;
    }
}

/*****************************************************************************/
/*
*
* This is the DMA RX interrupt handler function
*
* It gets the interrupt status from the hardware, acknowledges it, and if any
* error happens, it resets the hardware. Otherwise, if a completion interrupt
* presents, then it calls the callback function.
*
* @param	Callback is a pointer to RX channel of the DMA engine.
*
* @return	None.
*
* @note		None.
*
******************************************************************************/
static void RxIntrHandler(void *Callback) {
    XAxiDma_BdRing *RxRingPtr = (XAxiDma_BdRing *)Callback;
    u32 S2MM_Status;
    u32 IrqStatus;
    int TimeOut;

    /* Read pending interrupts */
    IrqStatus = XAxiDma_BdRingGetIrq(RxRingPtr);

    /* Acknowledge pending interrupts */
    XAxiDma_BdRingAckIrq(RxRingPtr, IrqStatus);

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
        XAxiDma_BdRingDumpRegs(RxRingPtr);
        S2MM_Status = XAxiDma_ReadReg(AxiDma.RegBase + XAXIDMA_RX_OFFSET, XAXIDMA_SR_OFFSET);
        xil_printf("ERROR: S2MM status: %x\r\n", S2MM_Status);
        Error = 1;

        /* Reset could fail and hang
		 * NEED a way to handle this or do not call it??
		 */
        XAxiDma_Reset(&AxiDma);

        TimeOut = RESET_TIMEOUT_COUNTER;

        while (TimeOut) {
            if (XAxiDma_ResetIsDone(&AxiDma)) {
                break;
            }

            TimeOut -= 1;
        }

        return;
    }

    /*
	 * If completion interrupt is asserted, call RX call back function
	 * to handle the processed BDs and then raise the according flag.
	 */
    if ((IrqStatus & (XAXIDMA_IRQ_DELAY_MASK | XAXIDMA_IRQ_IOC_MASK))) {
        RxCallBack(RxRingPtr);
    }
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

    Status = XScuGic_CfgInitialize(IntcInstancePtr, IntcConfig, IntcConfig->CpuBaseAddress);
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

int SetupRxIntrSystem(INTC *IntcInstancePtr,
                      XAxiDma *AxiDmaPtr, u16 RxIntrId) {
    XAxiDma_BdRing *RxRingPtr = XAxiDma_GetRxRing(AxiDmaPtr);
    int Status;

#ifdef XPAR_INTC_0_DEVICE_ID

    /* Initialize the interrupt controller and connect the ISRs */
    Status = XIntc_Initialize(IntcInstancePtr, INTC_DEVICE_ID);
    if (Status != XST_SUCCESS) {
        xil_printf("Failed init intc\r\n");
        return XST_FAILURE;
    }

    Status = XIntc_Connect(IntcInstancePtr, RxIntrId,
                           (XInterruptHandler)RxIntrHandler, RxRingPtr);
    if (Status != XST_SUCCESS) {
        xil_printf("Failed rx connect intc\r\n");
        return XST_FAILURE;
    }

    /* Start the interrupt controller */
    Status = XIntc_Start(IntcInstancePtr, XIN_REAL_MODE);
    if (Status != XST_SUCCESS) {
        xil_printf("Failed to start intc\r\n");
        return XST_FAILURE;
    }

    XIntc_Enable(IntcInstancePtr, RxIntrId);

#elif defined(FREE_RTOS)
    XScuGic_SetPriorityTriggerType(IntcInstancePtr, RxIntrId, 0xA1, 0x3);
    Status = XScuGic_Connect(IntcInstancePtr, RxIntrId, (Xil_InterruptHandler)RxIntrHandler, RxRingPtr);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    XScuGic_Enable(IntcInstancePtr, RxIntrId);
#else

    XScuGic_Config *IntcConfig;

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

    XScuGic_SetPriorityTriggerType(IntcInstancePtr, RxIntrId, 0xA0, 0x3);
    /*
	 * Connect the device driver handler that will be called when an
	 * interrupt for the device occurs, the handler defined above performs
	 * the specific interrupt processing for the device.
	 */
    Status = XScuGic_Connect(IntcInstancePtr, RxIntrId,
                             (Xil_InterruptHandler)RxIntrHandler,
                             RxRingPtr);
    if (Status != XST_SUCCESS) {
        return Status;
    }

    XScuGic_Enable(IntcInstancePtr, RxIntrId);
#endif

#ifndef FREE_RTOS
    /* Enable interrupts from the hardware */

    Xil_ExceptionInit();
    Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
                                 (Xil_ExceptionHandler)INTC_HANDLER,
                                 (void *)IntcInstancePtr);

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
* @param	TxIntrId is interrupt ID associated w/ DMA TX channel
* @param	RxIntrId is interrupt ID associated w/ DMA RX channel
*
* @return	None.
*
* @note		None.
*
******************************************************************************/
static void DisableIntrSystem(INTC *IntcInstancePtr, u16 RxIntrId) {
#ifdef XPAR_INTC_0_DEVICE_ID
    /* Disconnect the interrupts for the DMA TX and RX channels */
    XIntc_Disconnect(IntcInstancePtr, TxIntrId);
    XIntc_Disconnect(IntcInstancePtr, RxIntrId);
#else
    XScuGic_Disconnect(IntcInstancePtr, RxIntrId);
#endif
}

static int axidma_setup() {
    XAxiDma_Config *DmaConfig;
    XAxiDma_BdRing *RxRingPtr;
    int Status;
    XAxiDma_Bd BdTemplate;
    XAxiDma_Bd *BdPtr;
    XAxiDma_Bd *BdCurPtr;
    int BdCount;
    int FreeBdCount;
    int Index;

    DmaConfig = XAxiDma_LookupConfig(DMA_DEV_ID);
    if (!DmaConfig) {
        xil_printf("No config found for %d\r\n", DMA_DEV_ID);

        return XST_FAILURE;
    }

    /* Initialize DMA engine */
    XAxiDma_CfgInitialize(&AxiDma, DmaConfig);

    if (!XAxiDma_HasSg(&AxiDma)) {
        xil_printf("Device configured as Simple mode \r\n");
        return XST_FAILURE;
    }

    RxRingPtr = XAxiDma_GetRxRing(&AxiDma);

    /* Disable all RX interrupts before RxBD space setup */
    XAxiDma_BdRingIntDisable(RxRingPtr, XAXIDMA_IRQ_ALL_MASK);

    /* Setup Rx BD space */
    BdCount = XAxiDma_BdRingCntCalc(XAXIDMA_BD_MINIMUM_ALIGNMENT,
                                    RX_BD_SPACE_HIGH - RX_BD_SPACE_BASE + 1);

    Status = XAxiDma_BdRingCreate(RxRingPtr, RX_BD_SPACE_BASE,
                                  RX_BD_SPACE_BASE,
                                  XAXIDMA_BD_MINIMUM_ALIGNMENT, BdCount);
    if (Status != XST_SUCCESS) {
        xil_printf("ERROR: Rx bd create failed with %d\r\n", Status);
        return XST_FAILURE;
    }

    /*
	 * Setup a BD template for the Rx channel. Then copy it to every RX BD.
	 */
    XAxiDma_BdClear(&BdTemplate);
    Status = XAxiDma_BdRingClone(RxRingPtr, &BdTemplate);
    if (Status != XST_SUCCESS) {
        xil_printf("ERROR: Rx bd clone failed with %d\r\n", Status);
        return XST_FAILURE;
    }

    /* Attach buffers to RxBD ring so we are ready to receive packets */
    FreeBdCount = XAxiDma_BdRingGetFreeCnt(RxRingPtr);

    Status = XAxiDma_BdRingAlloc(RxRingPtr, FreeBdCount, &BdPtr);
    if (Status != XST_SUCCESS) {
        xil_printf("ERROR: Rx bd alloc failed with %d\r\n", Status);
        return XST_FAILURE;
    }

    BdCurPtr = BdPtr;
    RxBufferWrPtr = RX_BUFFER_BASE;

    for (Index = 0; Index < FreeBdCount; Index++) {
        Status = XAxiDma_BdSetBufAddr(BdCurPtr, RxBufferWrPtr);
        if (Status != XST_SUCCESS) {
            xil_printf("ERROR: Rx set buffer addr %x on BD %x failed %d\r\n",
                       (unsigned int)RxBufferWrPtr,
                       (UINTPTR)BdCurPtr, Status);

            return XST_FAILURE;
        }

        Status = XAxiDma_BdSetLength(BdCurPtr, MAX_PKT_LEN,
                                     RxRingPtr->MaxTransferLen);
        if (Status != XST_SUCCESS) {
            xil_printf("ERROR:  Rx set length %d on BD %x failed %d\r\n",
                       MAX_PKT_LEN, (UINTPTR)BdCurPtr, Status);

            return XST_FAILURE;
        }

        /* Receive BDs do not need to set anything for the control
		 * The hardware will set the SOF/EOF bits per stream status
		 */
        XAxiDma_BdSetCtrl(BdCurPtr, 0);

        XAxiDma_BdSetId(BdCurPtr, RxBufferWrPtr);

        RxBufferWrPtr += MAX_PKT_LEN;
        BdCurPtr = (XAxiDma_Bd *)XAxiDma_BdRingNext(RxRingPtr, BdCurPtr);
    }

    /*
	 * Set the coalescing threshold, so only one receive interrupt
	 * occurs for this example
	 *
	 * If you would like to have multiple interrupts to happen, change
	 * the COALESCING_COUNT to be a smaller value
	 */
    Status = XAxiDma_BdRingSetCoalesce(RxRingPtr, COALESCING_COUNT,
                                       DELAY_TIMER_COUNT);
    if (Status != XST_SUCCESS) {
        xil_printf("ERROR: Rx set coalesce failed with %d\r\n", Status);
        return XST_FAILURE;
    }

    Status = XAxiDma_BdRingToHw(RxRingPtr, FreeBdCount, BdPtr);
    if (Status != XST_SUCCESS) {
        xil_printf("ERROR: Rx ToHw failed with %d\r\n", Status);
        return XST_FAILURE;
    }

    /* Enable all RX interrupts */
    XAxiDma_BdRingIntEnable(RxRingPtr, XAXIDMA_IRQ_ALL_MASK);

    return XST_SUCCESS;
}

int axidma_recv_buff() {
    int Status;
    XAxiDma_BdRing *RxRingPtr;
    RxRingPtr = XAxiDma_GetRxRing(&AxiDma);
    Status = XAxiDma_BdRingStart(RxRingPtr);
    if (Status != XST_SUCCESS) {
        xil_printf("ERROR: Rx start BD ring failed with %d\r\n", Status);
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
    return 0;
}

int buff_will_be_full(u64 size) { return (RxBufferWrPtr > (u64 *)RX_BUFFER_HIGH - size); }

int buff_will_be_empty(u64 size) { return (RxBufferWrPtr < (u64 *)RX_BUFFER_BASE + size); }

u64 *get_wrptr() { return RxBufferWrPtr; }
u64 *get_rdptr() { return RxBufferRdPtr; }

void shutdown_dma() {
    xil_printf("End dma task...\r\n");
#ifndef FREE_RTOS
    DisableIntrSystem(&Intc, RX_INTR_ID);
#else
    DisableIntrSystem(&xInterruptController, RX_INTR_ID);
#endif
}