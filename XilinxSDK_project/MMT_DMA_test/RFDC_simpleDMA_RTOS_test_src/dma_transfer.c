#include "dma_transfer.h"

static void PrintData(int Length)
{
	u64 *RxPacket;
	int Index = 0;
	RxPacket = (u64 *) RX_BUFFER_BASE;

	/* Invalidate the DestBuffer before receiving the data, in case the
	 * Data Cache is enabled
	 */
	Xil_DCacheInvalidateRange((u64)RX_BUFFER_BASE, Length);

	for(Index = 0; Index < Length; Index++) {
		if ((Index+1)%4 == 0){
			xil_printf("%016llx\n", RxPacket[Index]);
		} else {
			xil_printf("%016llx ", RxPacket[Index]);
		}
	}
	xil_printf("\n\n");
	return XST_SUCCESS;
}

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
static void RxIntrHandler(void *Callback)
{
	u32 IrqStatus;
	int TimeOut;
	XAxiDma *AxiDmaInst = (XAxiDma *)Callback;

	 u32 S2MM_Status;
	 S2MM_Status = XAxiDma_ReadReg(AxiDmaInst->RegBase + XAXIDMA_RX_OFFSET, XAXIDMA_SR_OFFSET);
	 xil_printf("RxIntrHandler called\n");
	 xil_printf("S2MM status: %x\n", S2MM_Status);

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

		/* Reset could fail and hang
		 * NEED a way to handle this or do not call it??
		 */
		XAxiDma_Reset(AxiDmaInst);

		TimeOut = RESET_TIMEOUT_COUNTER;

		while (TimeOut) {
			if(XAxiDma_ResetIsDone(AxiDmaInst)) {
				break;
			}

			TimeOut -= 1;
		}

		return;
	}

	/*
	 * If completion interrupt is asserted, then set RxDone flag
	 */
	if ((IrqStatus & XAXIDMA_IRQ_IOC_MASK)) {
		xil_printf("Rx done. S2MM Status: %x\n", S2MM_Status);
		RxDone = 1;
	}
}

/*****************************************************************************/
/*
*
* This function setups the interrupt system so interrupts can occur for the
* DMA, it assumes INTC component exists in the hardware system.
*
* @param	IntcInstancePtr is a pointer to the instance of the INTC.
* @param	AxiDmaPtr is a pointer to the instance of the DMA engine
* @param	RxIntrId is the RX channel Interrupt ID.
*
* @return
*		- XST_SUCCESS if successful,
*		- XST_FAILURE.if not succesful
*
* @note		None.
*
******************************************************************************/

int SetupIntrSystem(INTC * IntcInstancePtr,
			   XAxiDma * AxiDmaPtr, u16 RxIntrId)
{
	int Status;

#ifdef XPAR_INTC_0_DEVICE_ID

	/* Initialize the interrupt controller and connect the ISRs */
	Status = XIntc_Initialize(IntcInstancePtr, INTC_DEVICE_ID);
	if (Status != XST_SUCCESS) {

		xil_printf("Failed init intc\r\n");
		return XST_FAILURE;
	}

	Status = XIntc_Connect(IntcInstancePtr, RxIntrId,
			       (XInterruptHandler) RxIntrHandler, AxiDmaPtr);
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

	XScuGic_SetPriorityTriggerType(IntcInstancePtr, RxIntrId, 0xA0, 0x3);
	Status = XScuGic_Connect(IntcInstancePtr, RxIntrId,
				(Xil_InterruptHandler)RxIntrHandler,
				AxiDmaPtr);
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
				AxiDmaPtr);
	if (Status != XST_SUCCESS) {
		return Status;
	}

	XScuGic_Enable(IntcInstancePtr, RxIntrId);


#endif

#ifndef FREE_RTOS
	/* Enable interrupts from the hardware */

	Xil_ExceptionInit();
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT, (Xil_ExceptionHandler)INTC_HANDLER, (void *)IntcInstancePtr );
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
* @param	RxIntrId is interrupt ID associated w/ DMA RX channel
*
* @return	None.
*
* @note		None.
*
******************************************************************************/
static void DisableIntrSystem(INTC * IntcInstancePtr, u16 RxIntrId)
{
#ifdef XPAR_INTC_0_DEVICE_ID
	/* Disconnect the interrupts for the DMA TX and RX channels */
	XIntc_Disconnect(IntcInstancePtr, RxIntrId);
#else
	XScuGic_Disconnect(IntcInstancePtr, RxIntrId);
#endif
}

int axidma_setup(){
	int Status;
	XAxiDma_Config *DmaConfig;

    xil_printf("\n\nSetup AXI-DMA...\n");
	DmaConfig = XAxiDma_LookupConfig(DMA_DEV_ID);
	if (!DmaConfig) {
		xil_printf("\nNo config found for %d\n", DMA_DEV_ID);

		return XST_FAILURE;
	}

	/* Initialize DMA engine */
	Status = XAxiDma_CfgInitialize(&AxiDma, DmaConfig);
	if (Status != XST_SUCCESS) {
		xil_printf("Failed initialize config\r\n");
		return XST_FAILURE;
	}

	if(XAxiDma_HasSg(&AxiDma)){
		xil_printf("\nDevice configured as SG mode \n");
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

	xil_printf("\nInitialize DMA engine\n");
	/* Disable all interrupts before setup */
	XAxiDma_IntrDisable(&AxiDma, XAXIDMA_IRQ_ALL_MASK,
				XAXIDMA_DEVICE_TO_DMA);
	/* Enable all interrupts */
	XAxiDma_IntrEnable(&AxiDma, XAXIDMA_IRQ_ALL_MASK,
							XAXIDMA_DEVICE_TO_DMA);

	xil_printf("\nAXI-DMA Setup is done successfully.\n");
	return XST_SUCCESS;
}

int axidma_excute(int Tries){
    int Status;
	int Index;	
	u64 *RxBufferPtr;
	RxBufferPtr = (u64 *)RX_BUFFER_BASE;

    /* Initialize flags before start transfer test  */
	RxDone = 0;
	Error = 0;

	xil_printf("\nAXI-DMA Setup is done successfully. Now waiting DMA interrupt..\n");

	/*
	 * Wait RX done
	 */
	for(Index = 0; Index < Tries; Index ++) {
		Status = XAxiDma_SimpleTransfer(&AxiDma,(UINTPTR) RxBufferPtr,
					MAX_PKT_LEN, XAXIDMA_DEVICE_TO_DMA);
		if (Status != XST_SUCCESS) {
			xil_printf("Failed simple transfer\r\n");
			return XST_FAILURE;
		}
		/*
		 * Wait RX done
		 */
		int max_wait_time = 30;
		int time = 0;
		while (!RxDone && !Error) {
			if (time > max_wait_time){
				xil_printf("\nTime out\n");
			 	return XST_FAILURE;
			}
			sleep(1);
			xil_printf("%d sec\r\n", time);
			time++;
		}
		PrintData((int) MAX_PKT_LEN/8);
		if (Error) {
			xil_printf("Failed test receive%s done\r\n", RxDone? "":" not");
            return XST_FAILURE;
		}        
        RxDone = 0;
	}

	if (Error) {
		xil_printf("receive%s done\r\n",  RxDone? "":" not");
        return XST_FAILURE;
	}else {
		xil_printf("Successfully ran AXI DMA Simple interrupt Example\r\n");
	}
    return XST_SUCCESS;
}

void shutdown_dma(){
#ifndef FREE_RTOS
	DisableIntrSystem(&Intc, RX_INTR_ID);
#endif
}
