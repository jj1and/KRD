#include "FreeRTOS.h"
#include "queue.h"
#include "send2pc.h"
#include "xil_exception.h"
#include "xdebug.h"
#include "dma_queue_transfer.h"

XAxiDma AxiDma;
TaskHandle_t xDmaTask;
QueueHandle_t xDmaQueue;
/*
 * Flags interrupt handlers use to notify the application context the events.
 */
volatile int Error;
static u64 *RxBufferPtr = (u64 *)RX_BUFFER_BASE;

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
	vTaskNotifyGiveFromISR(xDmaTask, &xHigherPriorityTaskWoken_byNotify);
	portYIELD_FROM_ISR(xHigherPriorityTaskWoken_byNotify);
	// } else if ((IrqStatus & XAXIDMA_IRQ_IOC_MASK)) {
	// 	vTaskNotifyGiveFromISR(xDmaTask, &xHigherPriorityTaskWoken_byNotify);
	// 	portYIELD_FROM_ISR(xHigherPriorityTaskWoken_byNotify);
	// }
	return;
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
				XAXIDMA_DEVICE_TO_DMA);
	/* Enable all interrupts */
	XAxiDma_IntrEnable(&AxiDma, XAXIDMA_IRQ_ALL_MASK,
							XAXIDMA_DEVICE_TO_DMA);

	xil_printf("AXI-DMA Setup is done successfully.\r\n");
	return XST_SUCCESS;
}

int axidma_excute(){
    int Status;
	int max_frame_num = 10;
	int frame_num;
	int max_intr_wait = 10;
	TickType_t max_intr_wait_tick = pdMS_TO_TICKS(max_intr_wait*1000);
	int max_send2pc_wait = 5;
	TickType_t max_send2pc_wait_tick = pdMS_TO_TICKS(max_send2pc_wait*1000);
    /* Initialize flags before start transfer test  */
	Error = 0;
	// xil_printf("Excute dma. Max interrupt wait time is %d sec.\r\n", max_intr_wait);
	for (frame_num = 0; frame_num < max_frame_num; frame_num++)
	{
		Status = XAxiDma_SimpleTransfer(&AxiDma,(UINTPTR) RxBufferPtr,
					MAX_PKT_LEN, XAXIDMA_DEVICE_TO_DMA);
		if (Status == XST_FAILURE) {
			xil_printf("DMA internal buffer is empty.\r\n");
			if (frame_num == 0) 
				return XST_FAILURE;
			else 
				break;
		} else if (Status == XST_INVALID_PARAM) {
			xil_printf("Simple transfer Failed because of parameter setting\r\n");
			return XST_FAILURE;
		} else {
			/* Wait RX done */
			ulTaskNotifyTake( pdTRUE, max_intr_wait_tick );
			if(Error){
				xil_printf("error in dma transaction.\r\n");
				break;
			} else {
				Xil_DCacheInvalidateRange((u64)RX_BUFFER_BASE, MAX_PKT_LEN);
				if(xQueueSend( xDmaQueue, RxBufferPtr, max_send2pc_wait_tick)){
					// xil_printf("send data to the queue\r\n");
				} else {
					xil_printf("queue is full.\r\n");
					Error = 1;
					break;
				}		
			}	
		}
	}
	// xil_printf("Waiting socket transaction end. Max wait time is %d sec.\r\n", max_send2pc_wait);
	// if(xSemaphoreTake(SemaphoneFromSend2pc, max_send2pc_wait_tick) == pdFALSE)
	// 	xil_printf("Time out. excute next dma transfer.\r\n");
    return XST_SUCCESS;
}

void shutdown_dma(){
	xil_printf("End dma task...\r\n");
#ifndef FREE_RTOS
	DisableIntrSystem(&Intc, RX_INTR_ID);
#else
	DisableIntrSystem(&xInterruptController, RX_INTR_ID);
#endif
}
