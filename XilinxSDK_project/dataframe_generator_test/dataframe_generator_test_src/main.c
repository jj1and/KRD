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
#include "xgpio.h"
#include "platform_config.h"
#include "xil_printf.h"
#include "axidma_manager.h"

#define TIMER_ID	1
#define DELAY_10_SECONDS	10000UL
#define DELAY_1_SECOND		1000UL
#define FAIL_CNT_THRESHOLD 5

// GPIO related constants
#define CONFIG_GPIO_DEVICE_ID XPAR_CONFIG_GPIO_DEVICE_ID
#define SET_CONFIG_CH 1
#define MAX_TRIGGER_LENGTH_CH 2
#define SET_CONFIG_BITWIDTH 1
#define MAX_TRIGGER_LENGTH_BITWIDTH 12

TickType_t x10seconds = pdMS_TO_TICKS( DELAY_10_SECONDS );
TimerHandle_t xTimer = NULL;
XGpio GpioConfig;

int GpioSetUp(XGpio *GpioInstPtr, u16 DeviceId);
void SetConfig(u8 set_config);
void SetMaxTriggerLength(u16 max_trigger_length);
void prvDmaTask( void *pvParameters );
int vApplicationDaemonTxTaskStartupHook();
int vApplicationDaemonRxTaskStartupHook();
void vTimerCallback( TimerHandle_t pxTimer );

int main(){
	int Status;
	xil_printf("dataframe_generator test\r\n");
	
	XTime_StartTimer();
	Status = axidma_setup();
	if (Status != XST_SUCCESS)
		xil_printf("Failed to Setup AXI-DMA\r\n");

	Status = GpioSetUp(&GpioConfig, CONFIG_GPIO_DEVICE_ID);
	if (Status != XST_SUCCESS) {
		xil_printf("Failed to initialize config GPIO\r\n");
		return XST_FAILURE;
	}
	SetConfig(1);
	SetMaxTriggerLength(MAX_TRIGGER_LEN);
	SetConfig(0);

	xTaskCreate( prvDmaTask, ( const char *) "AXIDMA transfer", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY, &xDmaTask );
	vTaskStartScheduler();
	while(1);
	// never reached
	return 0;
}

int GpioSetUp(XGpio *GpioInstPtr, u16 DeviceId){
	int Status;
	Status = XGpio_Initialize(GpioInstPtr, DeviceId);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	XGpio_SetDataDirection(GpioInstPtr, 1, 0x0);
	if (DeviceId == CONFIG_GPIO_DEVICE_ID) {
		XGpio_SetDataDirection(GpioInstPtr, 2, 0x0);
	}
	return XST_SUCCESS;
}

void SetConfig(u8 set_config){
	XGpio_DiscreteWrite(&GpioConfig, SET_CONFIG_CH, set_config);
	xil_printf("Set Config: %1d\r\n", set_config);
}

void SetMaxTriggerLength(u16 max_trigger_length){
	XGpio_DiscreteWrite(&GpioConfig, MAX_TRIGGER_LENGTH_CH, max_trigger_length);
	xil_printf("Set Max Trigger Length: %d\r\n", max_trigger_length);
}

void printData(u64 *dataptr, int frame_size){
	for(int i=0; i<frame_size/8; i++) {
		if ((i+1)%2 == 0){
			xil_printf("%016llx\n", dataptr[i]);
		} else {
			xil_printf("Recived : %016llx ", dataptr[i]);
		}
	}
	xil_printf("\n\n");
	incr_rdptr_after_read();
}

void prvDmaTask( void *pvParameters ) {
	int mm2s_dma_state = XST_SUCCESS;
	int s2mm_dma_state = XST_SUCCESS;

	int test_max_trigger_len = 32;

	int data_length = 25;
	int send_frame_size = 0;
	int read_frame_size = 0;
	u64 timestamp_at_beginning = 255;
	u8 trigger_info = 16;
	u16 baseline = 0;
	u16 threthold = 15;	

	u64 *dataptr;
	if (InitIntrController(&xInterruptController)!=XST_SUCCESS){
		xil_printf("Failed to setup interrupt controller.\r\n");
	}
	
	vApplicationDaemonRxTaskStartupHook();	
	vApplicationDaemonTxTaskStartupHook();

	while(TRUE) {
		
		s2mm_dma_state = axidma_recv_buff();
		if (s2mm_dma_state == XST_SUCCESS) {
			if (read_frame_size==send_frame_size) {
				xil_printf("Send trigger length: %d\r\n", data_length);
				mm2s_dma_state = axidma_send_buff(trigger_info, timestamp_at_beginning, baseline, threthold, data_length);
				if (mm2s_dma_state != XST_SUCCESS) {
					xil_printf("MM2S Dma failed. \r\n");
					break;
				}				
				while (!TxDone && !Error) {
					/* code */
				}
				if (!Error) {
					send_frame_size = data_length*16;
					read_frame_size = 0;
					data_length++;		
				} else {
					xil_printf("Error interrupt asserted.\r\n");
					break;					
				}
				
			}
			while (!RxDone && !Error) {
				/* code */
			}	
			if (!Error) {
				incr_wrptr_after_write();
			} else {
				xil_printf("Error interrupt asserted.\r\n");
				break;					
			}
		} else if (buff_is_full()) {
			xil_printf("S2MM Dma buffer is full. \r\n");
		} else {
			xil_printf("S2MM Dma failed beacuse of internal error. \r\n");
			break;
		}

		if ((s2mm_dma_state==XST_SUCCESS)||buff_is_full()) {
			dataptr = get_rdptr();	
			if (send_frame_size<=(MAX_TRIGGER_LEN*16)) {
				printData(dataptr, send_frame_size+3*8);
				read_frame_size = send_frame_size;	
			} else {
				if ((send_frame_size-read_frame_size)>(MAX_TRIGGER_LEN*16)){
					printData(dataptr, (MAX_TRIGGER_LEN*16+3*8));
					read_frame_size = read_frame_size+MAX_TRIGGER_LEN*16;
				} else {
					printData(dataptr, (send_frame_size-read_frame_size)+3*8);
					read_frame_size = send_frame_size;
				}
			}
		}

		if (data_length>test_max_trigger_len && read_frame_size==send_frame_size) {
			xil_printf("all test frame sent&read!\r\n");
			break;
		}
	}
	xil_printf("Test exit!\r\n");
	shutdown_dma();
	vTaskDelete(NULL);

	// while(TRUE) {
		
	// 	if (read_frame_size<=(data_length*16+3*8)+send_frame_size) {
	// 		s2mm_dma_state = axidma_recv_buff();
	// 		if (s2mm_dma_state!=XST_SUCCESS) {
	// 			xil_printf("S2MM Dma failed.\r\n");
	// 			break;
	// 		}
	// 	}

	// 	if (data_length<=test_max_trigger_len) {
	// 		mm2s_dma_state = axidma_send_buff(trigger_info, timestamp_at_beginning, baseline, threthold, data_length);
	// 		if (mm2s_dma_state!=XST_SUCCESS) {
	// 			xil_printf("MM2S Dma failed.\r\n");
	// 			break;
	// 		}
	// 	}

	// 	while (!TxDone && !Error) {
	// 		/* code */
	// 	}
	// 	if (TxDone && !Error) {
	// 		send_frame_size = send_frame_size+(data_length*16+3*8);
	// 	} else {
	// 		xil_printf("Error interrupt asserted.\r\n");
	// 		break;
	// 	}

	// 	while (!RxDone && !Error)
	// 	{
	// 		/* code */
	// 	}
	// 	if (RxDone && !Error) {
	// 		incr_wrptr_after_write();
	// 		dataptr = get_rdptr();
	// 		if (send_frame_size-read_frame_size<=MAX_PKT_LEN) {
	// 			printData(dataptr, send_frame_size-read_frame_size);
	// 			read_frame_size = send_frame_size;
	// 		} else {
	// 			printData(dataptr, MAX_PKT_LEN);
	// 			read_frame_size = read_frame_size+MAX_PKT_LEN;
	// 		}
	// 		incr_rdptr_after_read();


	// 		if (data_length<test_max_trigger_len) {
	// 			data_length++;
	// 		} else {
	// 			xil_printf("All test frame sent&read!\r\n");
	// 			break;
	// 		}
	// 	} else {
	// 		xil_printf("Error interrupt asserted.\r\n");
	// 		break;
	// 	}
	// }
	// xil_printf("Test exit!\r\n");
	// shutdown_dma();
	// vTaskDelete(NULL);
}

int vApplicationDaemonTxTaskStartupHook() {
	int Status;
	xil_printf("\nSet up AXIDMA Tx Interrupt system \n");
	Status = SetupTxIntrSystem(&xInterruptController, &AxiDma, TX_INTR_ID);
	if (Status != XST_SUCCESS) {
		xil_printf("Failed intr setup\r\n");
		return XST_FAILURE;
	}
	return XST_SUCCESS;
}

int vApplicationDaemonRxTaskStartupHook() {
	int Status;
	xil_printf("\nSet up AXIDMA Rx Interrupt system \n");
	Status = SetupRxIntrSystem(&xInterruptController, &AxiDma, RX_INTR_ID);
	if (Status != XST_SUCCESS) {
		xil_printf("Failed intr setup\r\n");
		return XST_FAILURE;
	}
	return XST_SUCCESS;
}
