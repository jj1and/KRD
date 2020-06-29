/*
 * main.c
 *
 *  Created on: 2020/06/29
 *      Author: jj1and
 */
#include "FreeRTOS.h"
#include "task.h"
#include "timers.h"

#include <stdio.h>
#include "xparameters.h"
#include "platform_config.h"
#include "xil_printf.h"
#include "axidma_manager.h"

#define TIMER_ID	1
#define DELAY_10_SECONDS	10000UL
#define DELAY_1_SECOND		1000UL
#define FAIL_CNT_THRESHOLD 5

int data_length = 16;

TickType_t x10seconds = pdMS_TO_TICKS( DELAY_10_SECONDS );
TimerHandle_t xTimer = NULL;

void prvRxDmaTask( void *pvParameters );
void prvTxDmaTask( void *pvParameters );
void vTimerCallback( TimerHandle_t pxTimer );
int vApplicationDaemonTaskStartupHook();

int main(){
	int Status;
	xil_printf("dataframe_generator test\r\n");
	
	XTime_StartTimer();
	Status = axidma_setup();
	if (Status != XST_SUCCESS)
		xil_printf("Failed to Setup AXI-DMA\r\n");

	xTaskCreate( prvTxDmaTask, ( const char *) "MM2S DMA transfer", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY+1, &xTxDmaTask );
	xTaskCreate( prvRxDmaTask, ( const char *) "S2MM DMA transfer", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY, &xRxDmaTask );

	xTimer = xTimerCreate( (const char *) "Timer", 18*x10seconds, pdFALSE, (void *) TIMER_ID, vTimerCallback);
	/* Check the timer was created. */
	configASSERT( xTimer );
	/* start the timer with a block time of 0 ticks. This means as soon
	   as the schedule starts the timer will start running and will expire after
	   10 seconds */
	xTimerStart( xTimer, 0 );
	vTaskStartScheduler();
	while(1);
	// never reached
	return 0;
}


void prvRxDmaTask( void *pvParameters )
{
	int dma_state = XST_SUCCESS;
	int wait_time = 5;
	u64 *dataptr;
	vApplicationDaemonTaskStartupHook();	
	while(1)
	{
		if ((dma_state == XST_FAILURE) || (Error == 1)) {
			xil_printf("dma failed. wait for %d sec.\r\n", wait_time);
			vTaskDelay(pdMS_TO_TICKS(wait_time*1000));
			dma_state = XST_SUCCESS;
			xil_printf("try again...\r\n");

		} else {
			dma_state = axidma_recv_buff();
			if (dma_state == XST_SUCCESS) {
				dataptr = get_rdptr();
				for(int i=0; i<data_length+3; i++) {
					if ((i+1)%2 == 0){
						xil_printf("%016llx\n", dataptr[i]);
					} else {
						xil_printf("Recived : %016llx ", dataptr[i]);
					}
				}
				xil_printf("\n\n");
				incr_rdptr_after_read();
			}
		}
	}
}

void prvTxDmaTask( void *pvParameters )
{
	int dma_state = XST_SUCCESS;
	int wait_time = 5;
	u64 timestamp_at_beginning = 255;
	u8 trigger_info = 16;
	u16 baseline = 0;
	u16 threthold = 15;
	while(1)
	{
		if ((dma_state == XST_FAILURE) || (Error == 1)) {
			xil_printf("dma failed. wait for %d sec.\r\n", wait_time);
			vTaskDelay(pdMS_TO_TICKS(wait_time*1000));
			dma_state = XST_SUCCESS;
			xil_printf("try again...\r\n");

		} else {
			dma_state = axidma_send_buff(trigger_info, timestamp_at_beginning, baseline, threthold, data_length);
		}
	}
}

int vApplicationDaemonTaskStartupHook(){
	int Status;
	xil_printf("\nSet up Interrupt system \n");
	Status = SetupIntrSystem(&xInterruptController, &AxiDma, RX_INTR_ID, TX_INTR_ID);
	if (Status != XST_SUCCESS) {
		xil_printf("Failed intr setup\r\n");
		return XST_FAILURE;
	}
	return XST_SUCCESS;
}

void vTimerCallback( TimerHandle_t pxTimer )
{
	long lTimerId;
	configASSERT( pxTimer );
	lTimerId = ( long ) pvTimerGetTimerID( pxTimer );
	if (lTimerId != TIMER_ID) {
		xil_printf("Failed to start timer.\r\n");
	}
	xil_printf("Timer called. DMA task will be finished.\r\n");
	shutdown_dma();
	vTaskDelete( xTxDmaTask );
	vTaskDelete( xRxDmaTask );
}
