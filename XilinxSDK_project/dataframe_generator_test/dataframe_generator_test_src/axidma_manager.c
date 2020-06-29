#include "axidma_manager.h"
#include "xil_exception.h"
#include "xdebug.h"

static u64 *RxBufferWrPtr = (u64 *)RX_BUFFER_BASE;
static u64 *RxBufferRdPtr = (u64 *)RX_BUFFER_BASE;
static u8 *TxBufferPtr = (u8 *)TX_BUFFER_BASE;
static int data_cnt;
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
	portBASE_TYPE xHigherPriorityTaskWoken_byNotify = pdFALSE;
	
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
	vTaskNotifyGiveFromISR(xRxDmaTask, &xHigherPriorityTaskWoken_byNotify);
	portYIELD_FROM_ISR(xHigherPriorityTaskWoken_byNotify);
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
		MM2S_Status = XAxiDma_ReadReg(AxiDmaInst->RegBase + XAXIDMA_RX_OFFSET, XAXIDMA_SR_OFFSET);
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
			   XAxiDma * AxiDmaPtr, u16 RxIntrId, u16 TxIntrId)
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

	Status = XIntc_Connect(IntcInstancePtr, TxIntrId,
			       (XInterruptHandler) TxIntrHandler, AxiDmaPtr);
	if (Status != XST_SUCCESS) {

		xil_printf("Failed tx connect intc\r\n");
		return XST_FAILURE;
	}	

	/* Start the interrupt controller */
	Status = XIntc_Start(IntcInstancePtr, XIN_REAL_MODE);
	if (Status != XST_SUCCESS) {

		xil_printf("Failed to start intc\r\n");
		return XST_FAILURE;
	}

	XIntc_Enable(IntcInstancePtr, RxIntrId);
	XIntc_Enable(IntcInstancePtr, TxIntrId);	


#elif defined(FREE_RTOS)

	XScuGic_SetPriorityTriggerType(IntcInstancePtr, TxIntrId, 0xA1, 0x3);
	XScuGic_SetPriorityTriggerType(IntcInstancePtr, RxIntrId, 0xA0, 0x3);

	Status = XScuGic_Connect(IntcInstancePtr, TxIntrId,
				(Xil_InterruptHandler)TxIntrHandler,
				AxiDmaPtr);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	Status = XScuGic_Connect(IntcInstancePtr, RxIntrId,
				(Xil_InterruptHandler)RxIntrHandler,
				AxiDmaPtr);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	XScuGic_Enable(IntcInstancePtr, RxIntrId);
	XScuGic_Enable(IntcInstancePtr, TxIntrId);
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

	XScuGic_SetPriorityTriggerType(IntcInstancePtr, TxIntrId, 0xA0, 0x3);
	XScuGic_SetPriorityTriggerType(IntcInstancePtr, RxIntrId, 0xA0, 0x3);
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
	Status = XScuGic_Connect(IntcInstancePtr, RxIntrId,
				(Xil_InterruptHandler)RxIntrHandler,
				AxiDmaPtr);
	if (Status != XST_SUCCESS) {
		return Status;
	}

	XScuGic_Enable(IntcInstancePtr, RxIntrId);
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


	data_cnt = 0;
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

int axidma_send_buff(u8 trigger_info, u64 timestamp_at_beginning, u16 baseline, u16 threshold, int tdata_length){
	int Status;
	int max_intr_wait = 10;
	TickType_t max_intr_wait_tick = pdMS_TO_TICKS(max_intr_wait*1000);	
	u16 adc_sample_ary[8] = {0, 1, 2, 3, 4, 5, 6, 7};
	u8 tdata[MAX_PKT_LEN/27][27];

	/* Initialize flags before start transfer test  */
	Error = 0;
	TxDone = 0;

	// prepare data to send
	if (tdata_length < MAX_PKT_LEN/27) {
		for (size_t i=0; i<tdata_length; i++) {
			
			assign_trigger_config(&tdata[i][0], baseline, threshold);
			assign_timestamp(&tdata[i][4], timestamp_at_beginning+i);
			tdata[i][10] = trigger_info;
			assign_adc_tdata(&tdata[i][11], adc_sample_ary);

			for (size_t j = 0; j < 8; j++) {
				adc_sample_ary[j]++;
			}
		}
	} else {
		xil_printf("Data length is larger than MAX_PKT_LEN/27\r\n");
		return XST_FAILURE;
	}

	// assign prepared data to TxBufferPtr
	for (size_t i = 0; i < tdata_length; i++) {
		for (size_t j = 0; j < 27; j++) {
			if (j==0) {
				xil_printf("Assign TxBufferPtr to %02x", tdata[i][j]);
			} else if (j==26) {
				xil_printf("%02x\r\n", tdata[i][j]);
			} else {
				xil_printf("%02x", tdata[i][j]);
			}
			TxBufferPtr[i*27+j] = tdata[i][j];
		}
	}
	Xil_DCacheFlushRange((UINTPTR)TxBufferPtr, MAX_PKT_LEN);

	Status = XAxiDma_SimpleTransfer(&AxiDma,(UINTPTR) TxBufferPtr, tdata_length*27, XAXIDMA_DMA_TO_DEVICE);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}


	while ((TxDone==0)&(Error==0)) {
		/* code */
	}	
	if(Error){
		xil_printf("Error in MM2S DMA transaction.\r\n");
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}

int axidma_recv_buff(){
    int Status;
	int max_intr_wait = 10;
	TickType_t max_intr_wait_tick = pdMS_TO_TICKS(max_intr_wait*1000);
    /* Initialize flags before start transfer test  */
	Error = 0;
	RxDone = 0;

	if (!buff_is_full()) {
		Status = XAxiDma_SimpleTransfer(&AxiDma,(UINTPTR) RxBufferWrPtr,
					MAX_PKT_LEN, XAXIDMA_DEVICE_TO_DMA);
		if (Status == XST_FAILURE) {
			xil_printf("DMA internal buffer is empty.\r\n");
			return XST_FAILURE;
		} else if (Status == XST_INVALID_PARAM) {
			xil_printf("Simple transfer Failed because of parameter setting\r\n");
			return XST_FAILURE;
		} else {
			/* Wait RX done */
//			set_timing_ticks(TYPE_DMA_START);
			if (ulTaskNotifyTake( pdTRUE, max_intr_wait_tick ) > 0){
				if(Error){
					xil_printf("Error in S2MM DMA transaction.\r\n");
					return XST_FAILURE;
				} else {
//					Xil_DCacheInvalidateRange((u64) RxBufferWrPtr, MAX_PKT_LEN);
//					set_timing_ticks(TYPE_DMA_END);
					// xil_printf("Wrote Data\r\n");
					// PrintData(RxBufferWrPtr, ((RxBufferWrPtr[0] & 0xFFF)+2));
					incr_wrptr_after_write();
					// xTaskNotifyGive(process_thread);
				}	
			} else {
//				set_timing_ticks(TYPE_DMA_INTR_END);
//				set_timing_ticks(TYPE_DMA_END);
				xil_printf("S2MM interrupt wait is timeout.\r\n");				
			}
		}
		return XST_SUCCESS;
	} else {
		xil_printf("RX buffer is full.\r\n");
		return XST_FAILURE;
	}
}

void incr_wrptr_after_write(){
	if (data_cnt<MAX_DATA_NUM){
		data_cnt++;
		if (RxBufferWrPtr >= (u64 *)RX_BUFFER_HIGH - (int)MAX_PKT_LEN/sizeof(RxBufferWrPtr))
			RxBufferWrPtr = (u64 *)RX_BUFFER_BASE;
		else
			RxBufferWrPtr = RxBufferWrPtr + (int)MAX_PKT_LEN/sizeof(RxBufferWrPtr);
	}
}

void incr_rdptr_after_read(){
	if (data_cnt>0) {
		data_cnt--;
		if (RxBufferRdPtr >= (u64 *)RX_BUFFER_HIGH - (int)MAX_PKT_LEN/sizeof(RxBufferRdPtr))
			RxBufferRdPtr = (u64 *)RX_BUFFER_BASE;
		else
			RxBufferRdPtr = RxBufferRdPtr + (int)MAX_PKT_LEN/sizeof(RxBufferRdPtr);
	}
}

int buff_is_empty() {
	return (data_cnt <= 0);
}

int buff_is_full(){
	return (data_cnt >= MAX_DATA_NUM);
}

u64* get_wrptr(){
	return RxBufferWrPtr;
}

u64* get_rdptr(){
	return RxBufferRdPtr;
}

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
