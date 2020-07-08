#include "axidma_manager.h"
#include "xil_exception.h"
#include "xdebug.h"

static u64 *RxBufferWrPtr = (u64 *)RX_BUFFER_BASE;
// static u8 RxBufferWrPtrLoop = 1;
// static u64 *RxBufferRdPtr = (u64 *)RX_BUFFER_BASE;
// static u8 RxBufferRdPtrLoop = 1;
static u8 *TxBufferPtr = (u8 *)TX_BUFFER_BASE;
static int MAX_DATA_NUM = RX_BUFFER_SIZE/MAX_PKT_LEN;


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
			if(XAxiDma_ResetIsDone(AxiDmaInst)) {
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
static void TxIntrHandler(void *Callback)
{

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


int InitIntrController(INTC * IntcInstancePtr){
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

int StartXIntc(INTC * IntcInstancePtr) {

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

int SetupTxIntrSystem(INTC * IntcInstancePtr,
			   XAxiDma * AxiDmaPtr, u16 TxIntrId)
{
	int Status;

#ifdef XPAR_INTC_0_DEVICE_ID

	Status = XIntc_Connect(IntcInstancePtr, TxIntrId,
			       (XInterruptHandler) TxIntrHandler, AxiDmaPtr);
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
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT, (Xil_ExceptionHandler)INTC_HANDLER, (void *)IntcInstancePtr );
	Xil_ExceptionEnable();
#endif
	return XST_SUCCESS;
}

int SetupRxIntrSystem(INTC * IntcInstancePtr,
			   XAxiDma * AxiDmaPtr, u16 RxIntrId)
{
	int Status;

#ifdef XPAR_INTC_0_DEVICE_ID
	Status = XIntc_Connect(IntcInstancePtr, RxIntrId,
			       (XInterruptHandler) RxIntrHandler, AxiDmaPtr);
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
* @param	IntrId is interrupt ID associated w/ DMA RX channel
*
* @return	None.
*
* @note		None.
*
******************************************************************************/
static void DisableIntrSystem(INTC * IntcInstancePtr, u16 IntrId)
{
#ifdef XPAR_INTC_0_DEVICE_ID
	/* Disconnect the interrupts for the DMA TX and RX channels */
	XIntc_Disconnect(IntcInstancePtr, IntrId);
#else
	XScuGic_Disconnect(IntcInstancePtr, IntrId);
#endif
}

int axidma_setup(){
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

	if(XAxiDma_HasSg(&AxiDma)){
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

static void assign_adc_tdata(u8 *u8_adc_tdata, u16 *u16_adc_sample){
	for (size_t i = 0; i < 8; i++) {
		for (size_t j = 0; j < 2; j++) {
			u8_adc_tdata[i*2+j] = (u16_adc_sample[i] >> j*8) & 0x00FF; 
		}		
	}
}

static void assign_timestamp(u8 *u8_timestamp, u64 u64_timestamp){
	for (size_t i = 0; i < 6; i++) {
		u8_timestamp[i] = (u64_timestamp >> i*8) & 0x000000FF;
	}
}

static void assign_trigger_config(u8 *u8_trigger_config, u16 baseline, u16 threshold){
	for (size_t i = 0; i < 2; i++) {
		u8_trigger_config[i] = (threshold >> i*8) & 0x00FF;
		u8_trigger_config[i+2] = (baseline >> i*8) & 0x00FF;
	}
}

int axidma_send_buff(u8 trigger_info, u64 timestamp_at_beginning, u16 baseline, u16 threshold, int tdata_length, int gain_change){
	int Status;
	int max_intr_wait = 20;
	TickType_t max_intr_wait_tick = pdMS_TO_TICKS(max_intr_wait*1000);	
	u16 adc_sample_ary[8] = {0, 1, 2, 3, 4, 5, 6, 7};
	u8 gain_inverted_trigger_info;
	gain_inverted_trigger_info = ~((trigger_info >> 4) << 4) | (trigger_info &0x0F );

	/* Initialize flags before start transfer test  */
	Error = 0;
	TxDone = 0;

	if (tdata_length <= MAX_GENERATBLE_TRIGGER_LEN) {
		// assign data to TxBufferPtr
		for (u64 i = 0; i < tdata_length; i++) {
			assign_trigger_config(&TxBufferPtr[i*27+0], baseline, threshold);
			assign_timestamp(&TxBufferPtr[i*27+4], timestamp_at_beginning+i);
			if (gain_change==1 && i>tdata_length/2) {
				TxBufferPtr[i*27+10] = gain_inverted_trigger_info;
			} else {
				TxBufferPtr[i*27+10] = trigger_info;
			}
			assign_adc_tdata(&TxBufferPtr[i*27+11], adc_sample_ary);
			for (size_t j = 0; j < 8; j++) {
				adc_sample_ary[j]++;
			}	
			// for (size_t j = 0; j < 27 ; j++) {
			// 	if (j==0) {
			// 		xil_printf("Send: %02x", TxBufferPtr[i*27+26-j]);
			// 	} else if (j==26) {
			// 		xil_printf("%02x\r\n", TxBufferPtr[i*27+26-j]);
			// 	} else {
			// 		xil_printf("%02x", TxBufferPtr[i*27+26-j]);
			// 	}
			// }
		}
	} else {
		xil_printf("Data length is larger than MAX_TRIGGER_LEN\r\n");
		return XST_FAILURE;
	}
	Xil_DCacheFlushRange((UINTPTR)TxBufferPtr, tdata_length*27);

	Status = XAxiDma_SimpleTransfer(&AxiDma,(UINTPTR) TxBufferPtr, tdata_length*27, XAXIDMA_DMA_TO_DEVICE);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}

int axidma_recv_buff(){
    int Status;
	int S2MM_Status;
	int max_intr_wait = 10;
	TickType_t max_intr_wait_tick = pdMS_TO_TICKS(max_intr_wait*1000);
    /* Initialize flags before start transfer test  */
	Error = 0;
	RxDone = 0;

	if (!buff_will_be_full(MAX_PKT_LEN)) {
		Status = XAxiDma_SimpleTransfer(&AxiDma,(UINTPTR) RxBufferWrPtr,
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
	u64 word_size = size/sizeof(u64);
	u64 margin_word_size = MAX_PKT_LEN/sizeof(u64);
	if (RxBufferWrPtr > (u64 *)RX_BUFFER_HIGH-margin_word_size-word_size) {
			xil_printf("Buffer is full\r\n");
			return -1;
	} else {
		RxBufferWrPtr = RxBufferWrPtr + word_size;
	}
	return 0;
}

int decr_wrptr_after_read(u64 size) {
	u64 word_size = size/sizeof(u64);
	u64 margin_word_size = MAX_PKT_LEN/sizeof(u64);
	if (RxBufferWrPtr < (u64 *)RX_BUFFER_BASE + word_size) {
			xil_printf("Buffer is empty\r\n");
			return -1;
	} else {
		RxBufferWrPtr = RxBufferWrPtr - word_size;
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
	u64 word_size = size/sizeof(u64);
	return (RxBufferWrPtr > (u64 *)RX_BUFFER_HIGH-word_size);
}

int buff_will_be_empty(u64 size) {
	u64 word_size = size/sizeof(u64);
	return (RxBufferWrPtr < (u64 *)RX_BUFFER_BASE + word_size);
}

u64* get_wrptr(){
	return RxBufferWrPtr;
}

// u64* get_rdptr(){
// 	return RxBufferRdPtr;
// }

void shutdown_dma(){
	xil_printf("End dma task...\r\n");
#ifndef FREE_RTOS
	DisableIntrSystem(&Intc, TX_INTR_ID);
	DisableIntrSystem(&Intc, RX_INTR_ID);
#else
	DisableIntrSystem(&xInterruptController, TX_INTR_ID);
	DisableIntrSystem(&xInterruptController, RX_INTR_ID);
#endif
}
