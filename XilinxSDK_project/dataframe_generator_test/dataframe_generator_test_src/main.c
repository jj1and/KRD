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

#define INTERNAL_ADC_BUFF_SIZE 2048*16
#define INTERNAL_HF_BUFF_DEPTH 256
#define EXTERNAL_FRAME_BUFF_SIZE 512*16
#define INTERNAL_BUFFER_FULL 3

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

void printData(u64 *dataptr, u64 frame_size){
	for(int i=0; i<frame_size; i++) {
		if ((i+1)%2 == 0){
			xil_printf("%016llx\n", dataptr[i]);
		} else {
			xil_printf("Recived : %016llx ", dataptr[i]);
		}
	}
	xil_printf("\r\n");
}

int checkData(u64 *dataptr, int *send_frame_len, int *read_frame_len, int *read_frame_len_exclude_HF, u64 timestamp_at_beginning, u8 trigger_info, u16 baseline, u16 threthold, int object_id, int print_enable){
	int Status = XST_SUCCESS;
	u8 read_header_id;
	u64 read_header_timestamp;
	u8 read_trigger_info;
	u16 read_frame_length;
	u16 read_baseline;
	u16 read_threthold;	
	u64 read_footer_timestamp;
	u32 read_object_id;
	u8 read_footer_id;
	int frame_len;

	u64 expected_header_timestamp;
	u8 expected_trigger_info;
	u64 expected_footer_timestamp;
	u32 expected_object_id = object_id;

	Xil_DCacheFlushRange((UINTPTR)dataptr, (MAX_TRIGGER_LEN*2+3)*sizeof(u64));
	read_header_timestamp = (dataptr[0] & 0x00FFFFFF);
	read_trigger_info = (dataptr[0] >> 24) & 0x000000FF;
	read_frame_length = (dataptr[0] >> (24+8)) & 0x00000FFF;
	read_header_id = (dataptr[0] >> (24+8+12+12)) & 0x000000FF;
	read_threthold = (dataptr[1] & 0x0000FFFF);
	read_baseline = (dataptr[1] >> 16) & 0x0000FFFF;
	incr_wrptr_after_write(read_frame_length+3);

	if (*send_frame_len<=(MAX_TRIGGER_LEN*2+3)) {
		frame_len = *send_frame_len;
		expected_header_timestamp = (timestamp_at_beginning & 0x00000000000FFFFFF);
		expected_footer_timestamp = (timestamp_at_beginning & 0x00000FFFFFF000000);
		expected_trigger_info = 0x0F & trigger_info; // {1'b0, TRIGGER_STATE[1:0], FRAME_CONTINUE[0], TRIGGER_TYPE[3:0]} = 8'b0000_1111 & trigger_info, TRIGGER_STATE is 01 if object_id==0, FRAME_CONTINUE is 1 if it's divided frame	
	} else {
		if ((*send_frame_len-*read_frame_len)>(MAX_TRIGGER_LEN*2+3)){
			frame_len = (MAX_TRIGGER_LEN*2+3);
			expected_header_timestamp = (timestamp_at_beginning+*read_frame_len_exclude_HF/2) & 0x00000000000FFFFFF;
			expected_footer_timestamp = (timestamp_at_beginning+*read_frame_len_exclude_HF/2) & 0x00000FFFFFF000000;
			expected_trigger_info = 0x1F & trigger_info; // {1'b0, TRIGGER_STATE[1:0], FRAME_CONTINUE[0], TRIGGER_TYPE[3:0]} = 8'b0001_1111 & trigger_info, TRIGGER_STATE is 01 if object_id==0, FRAME_CONTINUE is 1 if it's divided frame
		} else {
			frame_len = (*send_frame_len-*read_frame_len);
			expected_header_timestamp = (timestamp_at_beginning+*read_frame_len_exclude_HF/2) & 0x00000000000FFFFFF;
			expected_footer_timestamp = (timestamp_at_beginning+*read_frame_len_exclude_HF/2) & 0x00000FFFFFF000000;
			expected_trigger_info = 0x0F & trigger_info; // {1'b0, TRIGGER_STATE[1:0], FRAME_CONTINUE[0], TRIGGER_TYPE[3:0]} = 8'b0000_1111 & trigger_info, TRIGGER_STATE is 01 if object_id==0, FRAME_CONTINUE is 1 if it's divided frame
		}
	}
	*read_frame_len = *read_frame_len+read_frame_length+3;
	*read_frame_len_exclude_HF = *read_frame_len_exclude_HF + read_frame_length;
	read_footer_id = (dataptr[read_frame_length+3-1] >> 56 ) & 0x000000FF;
	read_object_id = dataptr[read_frame_length+3-1] & 0xFFFFFFFF;
	read_footer_timestamp = (dataptr[read_frame_length+3-1] >> 8 ) & 0x00000FFFFFF000000;

	xil_printf("Rcvd frame  trigger_length:%4d, timestamp:%5d, trigger_info:%2x, baseline:%4d, threshold:%4d, object_id:%4d\r\n", read_frame_length/2, read_footer_timestamp+read_header_timestamp, read_trigger_info, read_baseline, read_threthold, read_object_id);
	if (print_enable!=0) {
		printData(dataptr, read_frame_length+3);
	}

	if (read_header_id!=0xAA) {
		xil_printf("HEADER_ID missmatch Data: %2x Expected: %2x\r\n", read_header_id, 0xAA);
		Status = XST_FAILURE;
	} else if (read_threthold!=threthold) {
		xil_printf("threshold missmatch Data: %d Expected: %d\r\n", read_threthold, threthold);
		Status = XST_FAILURE;
	} else if (read_baseline!=baseline) {
		xil_printf("baseline missmatch Data: %d Expected: %d\r\n", read_baseline, baseline);
		Status = XST_FAILURE;
	}

	if (object_id==0) {
		// {1'b0, TRIGGER_STATE[1:0], FRAME_CONTINUE[0], TRIGGER_TYPE[3:0]} = expected_trigger_info | 8'0010_0000 *trigger state must be 2'b01 at first frame (expected_trigger_info= 8'b000X_1111 & trigger_info)
		expected_trigger_info = (expected_trigger_info | 0x20);
		if (read_trigger_info!=expected_trigger_info) {
			xil_printf("trigger_info missmatch Data: %2x Expected: %2x\r\n", read_trigger_info, expected_trigger_info);
			Status = XST_FAILURE;
		}
	} else {
		// {1'b0, TRIGGER_STATE[1:0], FRAME_CONTINUE[0], TRIGGER_TYPE[3:0]} = expected_trigger_info | 8'0101_0000 *trigger state = 2'b10 (halt) and frame continue means frame generator fifo is full
		if (read_trigger_info == (expected_trigger_info | 0x50)) {
			xil_printf("trigger_info indicates dataframe_generator internal buffer is full: %2x\r\n", read_trigger_info);
			Status = INTERNAL_BUFFER_FULL;
		}

		// {1'b0, TRIGGER_STATE[1:0], FRAME_CONTINUE[0], TRIGGER_TYPE[3:0]} = read_trigger_info & 8'0001_1111 *mask trigger_state because it is unknown
		if ((read_trigger_info & 0x1F)!= expected_trigger_info) {
			xil_printf("trigger_info missmatch Data: %2x Expected: %2x\r\n", (read_trigger_info & 0x1F), expected_trigger_info);
			Status = XST_FAILURE;
		}
	}

	if (read_footer_id!=0x55) {
		xil_printf("FOOTER_ID missmatch Data: %2x Expected: %2x\r\n", read_footer_id, 0x55);
		Status = XST_FAILURE;
	} else if ((read_frame_length+3)!=frame_len) {
		if (Status==INTERNAL_BUFFER_FULL) {
			xil_printf("frame_size missmatch because of fifo full. Data: %d Expected: %d\r\n", read_frame_length+3, frame_len);
		} else {
			xil_printf("frame_size missmatch Data: %d Expected: %d\r\n", read_frame_length+3, frame_len);
			Status = XST_FAILURE;
		}
	} else if (read_header_timestamp!=expected_header_timestamp) {
		xil_printf("header_timestamp missmatch Data: %d Expected: %d\r\n", read_header_timestamp, expected_header_timestamp);
		Status = XST_FAILURE;
	} else if (read_object_id!=expected_object_id) {
		if (expected_object_id==-1) {
			xil_printf("object_id check is manually disabled (Data: %d)\r\n", read_object_id);
		} else {
			xil_printf("object_id missmatch Data: %d Expected: %d\r\n", read_object_id, expected_object_id);
			Status = XST_FAILURE;
		}
	} else if (read_footer_timestamp!=expected_footer_timestamp) {
		xil_printf("footer_timestamp missmatch Data: %d Expected: %d\r\n", read_footer_timestamp, expected_footer_timestamp);
		Status = XST_FAILURE;
	}

	decr_wrptr_after_read(read_frame_length+3);
	return Status;
}

void prvDmaTask( void *pvParameters ) {
	int mm2s_dma_state = XST_SUCCESS;
	int s2mm_dma_state = XST_SUCCESS;
	int test_result;
	int test_max_trigger_len = 128;
	int data_length = 1;
	int divide_frame_num = 0;

	int send_frame_len = 0;
	int read_frame_len = 0;
	int read_frame_len_exclude_HF = 0;
	u64 timestamp_at_beginning = 255;
	u8 trigger_info = 0x10;
	u16 baseline = 0;
	u16 threthold = 15;
	int object_id = -1;	

	u64 *dataptr;
	if (InitIntrController(&xInterruptController)!=XST_SUCCESS){
		xil_printf("Failed to setup interrupt controller.\r\n");
	}
	
	vApplicationDaemonRxTaskStartupHook();	
	vApplicationDaemonTxTaskStartupHook();

	xil_printf("sequential sending test\r\n");
	while(TRUE) {
		
		s2mm_dma_state = axidma_recv_buff();
		if (s2mm_dma_state == XST_SUCCESS) {
			if (read_frame_len==send_frame_len) {
				mm2s_dma_state = axidma_send_buff(trigger_info, timestamp_at_beginning, baseline, threthold, data_length, 1);
				if (mm2s_dma_state != XST_SUCCESS) {
					xil_printf("MM2S Dma failed. \r\n");
					break;
				}				
				while (!TxDone && !Error) {
					/* code */
				}
				if (!Error) {
					if (data_length%MAX_TRIGGER_LEN>0) {
						divide_frame_num = ((data_length-data_length%MAX_TRIGGER_LEN)/MAX_TRIGGER_LEN + 1);
					} else {
						divide_frame_num = (data_length/MAX_TRIGGER_LEN);

					}
					send_frame_len = data_length*2+divide_frame_num*3;
					read_frame_len = 0;
					read_frame_len_exclude_HF = 0;
					object_id++;
					xil_printf("\nSend frame  trigger_length:%4d, timestamp:%5d, trigger_info:%2x, baseline:%4d, threshold:%4d, object_id:%4d\r\n", data_length, timestamp_at_beginning, trigger_info, baseline, threthold, object_id);
					data_length++;		
				} else {
					xil_printf("Error interrupt asserted.\r\n");
					break;					
				}
				
			}
			while (!RxDone && !Error) {
				/* code */
			}	
			if (Error) {
				xil_printf("Error interrupt asserted.\r\n");
				break;					
			}
		} else if (buff_will_be_full( MAX_PKT_LEN/sizeof(u64) )) {
			xil_printf("S2MM Dma buffer is full. \r\n");
		} else {
			xil_printf("S2MM Dma failed beacuse of internal error. \r\n");
			break;
		}

		if ((s2mm_dma_state==XST_SUCCESS)||buff_will_be_full( MAX_PKT_LEN/sizeof(u64) )) {
			dataptr = get_wrptr();	
			test_result = checkData(dataptr, &send_frame_len, &read_frame_len, &read_frame_len_exclude_HF, timestamp_at_beginning, trigger_info, baseline, threthold, object_id, 0);
			if (test_result!=XST_SUCCESS) {
				break;
			}		
		}
		if (data_length>test_max_trigger_len && read_frame_len==send_frame_len) {
			xil_printf("sequential sending test passed!\r\n");
			break;
		}
	}

	const int fixed_data_length = 100;
	if (fixed_data_length%MAX_TRIGGER_LEN>0) {
		divide_frame_num = ((fixed_data_length-fixed_data_length%MAX_TRIGGER_LEN)/MAX_TRIGGER_LEN + 1);

	} else {
		divide_frame_num = (fixed_data_length/MAX_TRIGGER_LEN);
	}
	send_frame_len = fixed_data_length*2+divide_frame_num*3;

	int total_send_frame_len = 0;
	int total_read_frame_len = 0;
	read_frame_len = 0;
	read_frame_len_exclude_HF = 0;

	xil_printf("backpressure sending test\r\n");
	while (total_send_frame_len*sizeof(u64) < AXIDMA_BUFF_SIZE+INTERNAL_ADC_BUFF_SIZE+EXTERNAL_FRAME_BUFF_SIZE+send_frame_len*sizeof(u64)) {
		mm2s_dma_state = axidma_send_buff(trigger_info, timestamp_at_beginning, baseline, threthold, fixed_data_length, 1);
		if (mm2s_dma_state != XST_SUCCESS) {
			xil_printf("MM2S Dma failed. \r\n");
			break;
		}				
		while (!TxDone && !Error) {
			/* code */
		}
		if (!Error) {
			total_send_frame_len += send_frame_len;
			object_id++;
			xil_printf("\nSend frame  trigger_length:%4d, timestamp:%5d, trigger_info:%2x, baseline:%4d, threshold:%4d, object_id:%4d\r\n", fixed_data_length, timestamp_at_beginning, trigger_info, baseline, threthold, object_id);
		} else {
			xil_printf("Error interrupt asserted.\r\n");
			break;					
		}			
	}
	
	while (total_read_frame_len<total_send_frame_len) {
		s2mm_dma_state = axidma_recv_buff();
		if (s2mm_dma_state == XST_SUCCESS) {
			while (!RxDone && !Error) {
				/* code */
			}	
			if (Error) {
				xil_printf("Error interrupt asserted.\r\n");
				break;					
			}
		} else if (buff_will_be_full( MAX_PKT_LEN/sizeof(u64) )) {
			xil_printf("S2MM Dma buffer is full. \r\n");
		} else {
			xil_printf("S2MM Dma failed beacuse of internal error. \r\n");
			break;
		}
		if ((s2mm_dma_state==XST_SUCCESS)||buff_will_be_full( MAX_PKT_LEN/sizeof(u64) )) {
			dataptr = get_wrptr();	
			test_result = checkData(dataptr, &send_frame_len, &read_frame_len, &read_frame_len_exclude_HF, timestamp_at_beginning, trigger_info, baseline, threthold, -1, 0);
			if (test_result==XST_FAILURE) {
				break;
			} else if (test_result==INTERNAL_BUFFER_FULL) {
				xil_printf("backpressure sending test finished!\r\n");
				break;					
			}

			if (send_frame_len == read_frame_len) {
				total_read_frame_len += read_frame_len;
				read_frame_len = 0;
				read_frame_len_exclude_HF = 0;
			}
		}
	}

	data_length = 1;
	trigger_info = 0x1F;
	read_frame_len = 0;
	send_frame_len = 0;
	read_frame_len_exclude_HF = 0;

	xil_printf("sequential sending test\r\n");
	while(TRUE) {

		s2mm_dma_state = axidma_recv_buff();
		if (s2mm_dma_state == XST_SUCCESS) {
			if (read_frame_len==send_frame_len) {
				mm2s_dma_state = axidma_send_buff(trigger_info, timestamp_at_beginning, baseline, threthold, data_length, 1);
				if (mm2s_dma_state != XST_SUCCESS) {
					xil_printf("MM2S Dma failed. \r\n");
					break;
				}
				while (!TxDone && !Error) {
					/* code */
				}
				if (!Error) {
					if (data_length%MAX_TRIGGER_LEN>0) {
						divide_frame_num = ((data_length-data_length%MAX_TRIGGER_LEN)/MAX_TRIGGER_LEN + 1);
					} else {
						divide_frame_num = (data_length/MAX_TRIGGER_LEN);

					}
					send_frame_len = data_length*2+divide_frame_num*3;
					read_frame_len = 0;
					read_frame_len_exclude_HF = 0;
					object_id++;
					xil_printf("\nSend frame  trigger_length:%4d, timestamp:%5d, trigger_info:%2x, baseline:%4d, threshold:%4d, object_id:%4d\r\n", data_length, timestamp_at_beginning, trigger_info, baseline, threthold, object_id);
					data_length++;
				} else {
					xil_printf("Error interrupt asserted.\r\n");
					break;
				}

			}
			while (!RxDone && !Error) {
				/* code */
			}
			if (Error) {
				xil_printf("Error interrupt asserted.\r\n");
				break;
			}
		} else if (buff_will_be_full( MAX_PKT_LEN/sizeof(u64) )) {
			xil_printf("S2MM Dma buffer is full. \r\n");
		} else {
			xil_printf("S2MM Dma failed beacuse of internal error. \r\n");
			break;
		}

		if ((s2mm_dma_state==XST_SUCCESS)||buff_will_be_full( MAX_PKT_LEN/sizeof(u64) )) {
			dataptr = get_wrptr();
			test_result = checkData(dataptr, &send_frame_len, &read_frame_len, &read_frame_len_exclude_HF, timestamp_at_beginning, trigger_info, baseline, threthold, -1, 0);
			if (test_result!=XST_SUCCESS) {
				break;
			}
		}
		if (data_length>test_max_trigger_len && read_frame_len==send_frame_len) {
			xil_printf("sequential sending test passed!\r\n");
			break;
		}
	}

	xil_printf("Test exit!\r\n");
	shutdown_dma();
	vTaskDelete(NULL);
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
