/*
    Copyright (C) 2017 Amazon.com, Inc. or its affiliates.  All Rights Reserved.
    Copyright (C) 2012 - 2018 Xilinx, Inc. All Rights Reserved.

    Permission is hereby granted, free of charge, to any person obtaining a copy of
    this software and associated documentation files (the "Software"), to deal in
    the Software without restriction, including without limitation the rights to
    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
    the Software, and to permit persons to whom the Software is furnished to do so,
    subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software. If you wish to use our Amazon
    FreeRTOS name, please do so in a fair use way that does not cause confusion.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

    http://www.FreeRTOS.org
    http://aws.amazon.com/freertos


    1 tab == 4 spaces!
*/

/* FreeRTOS includes. */
#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"
#include "timers.h"
/* Xilinx includes. */
#include "xil_printf.h"
#include "xparameters.h"
/* User includes */
#include "trigger_manager.h"
#include "dma_transfer.h"

#define TIMER_ID	1
#define DELAY_10_SECONDS	10000UL
#define DELAY_1_SECOND		1000UL

/*-----------------------------------------------------------*/

/* The Tx and Rx tasks as described at the top of this file. */
static void prvDmaTask( void *pvParameters );
static void vTimerCallback( TimerHandle_t pxTimer );
int vApplicationDaemonTaskStartupHook();
/*-----------------------------------------------------------*/

/* The queue used by the Tx and Rx tasks, as described at the top of this
file. */
static TaskHandle_t xDmaTask;
static TimerHandle_t xTimer = NULL;

int main( void )
{
	const TickType_t x10seconds = pdMS_TO_TICKS( DELAY_10_SECONDS );

	xil_printf( "RFDC + DMA test on FreeRTOS\r\n" );
	int16_t threshold = 256;
	u16 baseline = 0;
	u8 pre_acqui_len = 5;
	trigger_setup(threshold, baseline, pre_acqui_len);
	axidma_setup();

	xTaskCreate( prvDmaTask, ( const char *) "DMA_excution", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY, &xDmaTask );

	/* Create a timer with a timer expiry of 10 seconds. The timer would expire
	 after 10 seconds and the timer call back would get called. In the timer call back
	 checks are done to ensure that the tasks have been running properly till then.
	 The tasks are deleted in the timer call back and a message is printed to convey that
	 the example has run successfully.
	 The timer expiry is set to 10 seconds and the timer set to not auto reload. */
	xTimer = xTimerCreate( (const char *) "Timer",
							6*x10seconds,
							pdFALSE,
							(void *) TIMER_ID,
							vTimerCallback);
	/* Check the timer was created. */
	configASSERT( xTimer );

	/* start the timer with a block time of 0 ticks. This means as soon
	   as the schedule starts the timer will start running and will expire after
	   10 seconds */
	xTimerStart( xTimer, 0 );

	/* Start the tasks and timer running. */
	vTaskStartScheduler();
}

/*-----------------------------------------------------------*/
static void prvDmaTask( void *pvParameters )
{
	int Tries = 2;
	vApplicationDaemonTaskStartupHook();
	for( ;; )
	{
		axidma_excute(Tries);
	}
}

/*-----------------------------------------------------------*/
static void vTimerCallback( TimerHandle_t pxTimer )
{
	long lTimerId;
	configASSERT( pxTimer );

	lTimerId = ( long ) pvTimerGetTimerID( pxTimer );

	if (lTimerId != TIMER_ID) {
		xil_printf("\nRFDC+DMA on RTOS test FAILED\n");
	}

	xil_printf("\nRFDC+DMA on RTOS test passed.\n");
	vTaskDelete( xDmaTask );
}

/*-----------------------------------------------------------*/
int vApplicationDaemonTaskStartupHook(){
	int Status;
	xil_printf("\nSet up Interrupt system \n");
	Status = SetupIntrSystem(&xInterruptController, &AxiDma, RX_INTR_ID);
	if (Status != XST_SUCCESS) {
		xil_printf("Failed intr setup\r\n");
		return XST_FAILURE;
	}
	return XST_SUCCESS;
}
