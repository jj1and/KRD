/*
 * main.c
 *
 *  Created on: 2020/06/29
 *      Author: jj1and
 */
#include <stdio.h>

#include "FreeRTOS.h"
#include "axidma_s2mm_manager.h"
#include "hardware_trigger_manager.h"
#include "platform_config.h"
#include "rfdc_manager.h"
#include "send2pc.h"
#include "task.h"
#include "xgpio.h"
#include "xil_printf.h"
#include "xparameters.h"

#define TIMER_ID 1
#define DELAY_10_SECONDS 10000UL
#define DELAY_1_SECOND 1000UL
#define FAIL_CNT_THRESHOLD 5

// GPIO related constant
#define GAIN_SWITCH_CONFIG_GPIO_DEVICE_ID XPAR_AXI_GPIO_0_DEVICE_ID

#define MODE_SWITCH_UPPER_THRE_CH 1
#define MODE_SWITCH_LOWER_THRE_CH 2
#define MODE_SWITCH_UPPER_THRE 2047
#define MODE_SWITCH_LOWER_THRE -2048

#define INTERNAL_ADC_BUFF_SIZE 2048 * 16
#define INTERNAL_HF_BUFF_DEPTH 256
#define EXTERNAL_FRAME_BUFF_SIZE 512 * 16
#define INTERNAL_BUFFER_FULL 3
#define LAST_FRAME 2

#define COMBINED_ACQUIRE_MODE 0x1
#define NORMAL_ACQUIRE_MODE 0x0

#define H_GAIN_BASELINE 0
#define L_GAIN_BASELINE 0

const u32 ACQUIRE_MODE = NORMAL_ACQUIRE_MODE;
const int RISING_EDGE_THRESHOLD = 32;
const int FALLING_EDGE_THRESHOLD = 0;
const u32 PRE_ACQUISITION_LENGTH = 1;
const u32 POST_ACQUISITION_LENGTH = 1;

const Channel_Config channel_0 = { 0, ACQUIRE_MODE, MAX_TRIGGER_LEN, RISING_EDGE_THRESHOLD, FALLING_EDGE_THRESHOLD, PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH, H_GAIN_BASELINE, L_GAIN_BASELINE };
Channel_Config ch_config_array[1] = {channel_0};

Trigger_Config fee = {
    1,
	ch_config_array};

const TickType_t x10seconds = pdMS_TO_TICKS(DELAY_10_SECONDS);

XGpio Gpio_mode_switch_thre;

int GpioSetUp(XGpio *GpioInstPtr, u16 DeviceId);
int SetSwitchThreshold(short int upper_threshold, short int lower_threshold);

static struct netif myself_netif;
TaskHandle_t app_thread;
app_arg send2pc_setting = {
    5001,
    "192.168.1.2",
    x10seconds};


int RFDC_ADC_TILES = {0};

AvailableAdcTiles AdcTile = {
    1,
	&RFDC_ADC_TILES};

void network_thread(void *arg);

void prvDmaTask(void *pvParameters);
int vApplicationDaemonRxTaskStartupHook();

void print_ip(char *msg, ip_addr_t *ip) {
    xil_printf(msg);
    xil_printf("%d.%d.%d.%d\n\r", ip4_addr1(ip), ip4_addr2(ip), ip4_addr3(ip), ip4_addr4(ip));
}

void print_ip_settings(ip_addr_t *ip, ip_addr_t *mask, ip_addr_t *gw) {
    print_ip("Board IP: ", ip);
    print_ip("Netmask : ", mask);
    print_ip("Gateway : ", gw);
}

int main() {
    int Status;
    xil_printf("minimal FEE Start\r\n");
    double refClkFreq_MHz = 245.76;
    double samplingRate_Msps = 1966.08;
    Status = rfdcADC_MTS_setup(RFDC_DEVICE_ID, refClkFreq_MHz, samplingRate_Msps, AdcTile);
    if (Status != XST_SUCCESS) {
        xil_printf("Failed to setup RF Data Converter\r\n");
        return XST_FAILURE;
    }

    Status = GpioSetUp(&Gpio_mode_switch_thre, GAIN_SWITCH_CONFIG_GPIO_DEVICE_ID);
    if (Status != XST_SUCCESS) {
        xil_printf("ERROR: Failed to initialize gain switch setting GPIO\r\n");
        return XST_FAILURE;
    }
    Status = SetSwitchThreshold(MODE_SWITCH_UPPER_THRE, MODE_SWITCH_LOWER_THRE);

    Status = HardwareTrigger_SetupDeviceId(0, fee);

    Status = axidma_setup();
    if (Status != XST_SUCCESS) xil_printf("Failed to Setup AXI-DMA\r\n");

    xTaskCreate(prvDmaTask, (const char *)"AXIDMA transfer", configMINIMAL_STACK_SIZE, NULL, DEFAULT_THREAD_PRIO + 1, &xDmaTask);
    sys_thread_new("nw_thread", network_thread, &send2pc_setting, THREAD_STACKSIZE, DEFAULT_THREAD_PRIO);
    vTaskStartScheduler();
    while (1)
        ;
    // never reached
    return 0;
}

int GpioSetUp(XGpio *GpioInstPtr, u16 DeviceId) {
    int Status;
    Status = XGpio_Initialize(GpioInstPtr, DeviceId);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }
    XGpio_SetDataDirection(GpioInstPtr, 1, 0x0);
    XGpio_SetDataDirection(GpioInstPtr, 2, 0x0);
    return XST_SUCCESS;
}

int SetSwitchThreshold(short int upper_threshold, short int lower_threshold) {
    if ((upper_threshold > 2047) | (lower_threshold < -2048)) {
        xil_printf("ERROR: Invalid gain switch upper threshold: %d\r\n", upper_threshold);
        return XST_INVALID_PARAM;
    } else {
        XGpio_DiscreteWrite(&Gpio_mode_switch_thre, MODE_SWITCH_UPPER_THRE_CH, upper_threshold);
        xil_printf("INFO: Set gain switch upper threshold: %d\r\n", upper_threshold);
    }
    if ((lower_threshold > upper_threshold) | (lower_threshold < -2048)) {
        xil_printf("ERROR: Invalid gain switch lower threshold: %d\r\n", lower_threshold);
        return XST_INVALID_PARAM;
    } else {
        XGpio_DiscreteWrite(&Gpio_mode_switch_thre, MODE_SWITCH_LOWER_THRE_CH, lower_threshold);
        xil_printf("INFO: Set gain switch lower threshold: %d\r\n", lower_threshold);
    }
    return XST_SUCCESS;
}

void network_thread(void *arg) {
    lwip_init();

    struct netif *netif;
    /* the mac address of the board. this should be unique per board */
    unsigned char mac_ethernet_address[] = {0x00, 0x0a, 0x35, 0x00, 0x01, 0x02};

    ip_addr_t ipaddr, netmask, gw;
    netif = &myself_netif;

    xil_printf("\r\n\r\n");
    xil_printf("-----Dummy FEE client ------\r\n");

    /* initliaze IP addresses to be used */
    IP4_ADDR(&ipaddr, 192, 168, 1, 7);
    IP4_ADDR(&netmask, 255, 255, 255, 0);
    IP4_ADDR(&gw, 192, 168, 1, 1);

    /* print out IP settings of the board */
    print_ip_settings(&ipaddr, &netmask, &gw);

    /* Add network interface to the netif_list, and set it as default */
    if (!xemac_add(netif, &ipaddr, &netmask, &gw, mac_ethernet_address, PLATFORM_EMAC_BASEADDR)) {
        xil_printf("Error adding N/W interface\r\n");
        return;
    }

    netif_set_default(netif);
    /* specify that the network if is up */
    netif_set_up(netif);

    /* start packet receive thread - required for lwIP operation */
    sys_thread_new("xemacif_input_thread", (void (*)(void *))xemacif_input_thread, netif, THREAD_STACKSIZE, DEFAULT_THREAD_PRIO);
    app_thread = sys_thread_new("send2pcd", send2pc_application_thread, arg, THREAD_STACKSIZE, DEFAULT_THREAD_PRIO);
    vTaskDelete(NULL);
}

void printData(u64 *dataptr, u64 frame_size) {
    xil_printf("Rcvd : %016llx ", dataptr[0]);
    xil_printf("%016llx (Header)\n", dataptr[1]);
    for (int i = 2; i < frame_size - 1; i++) {
        for (int j = 0; j < 4; j++) {
            if (((i - 2) * 4 + j) % 8 == 0) {
                xil_printf("Rcvd : %04x ", (dataptr[i] >> (3 - j) * 16) & 0x000000000000FFFF);
            } else if (((i - 2) * 4 + j + 1) % 8 == 0) {
                xil_printf("%04x\n", (dataptr[i] >> (3 - j) * 16) & 0x000000000000FFFF);
            } else {
                xil_printf("%04x ", (dataptr[i] >> (3 - j) * 16) & 0x000000000000FFFF);
            }
        }
    }
    xil_printf("Rcvd : %016llx (Footer)\n", dataptr[frame_size - 1]);
    xil_printf("\r\n");
}

int checkData(u64 *dataptr, u16 rise_thre, u16 fall_thre, int print_enable, u64 *rcvd_frame_length) {
    int Status = XST_SUCCESS;
    u8 read_header_id;
    u64 read_header_timestamp;
    u8 read_trigger_info;
    u16 read_trigger_length;
    int read_raw_charge_sum;
    int read_charge_sum;
    u16 read_fall_thre;
    u16 read_rise_thre;
    u64 read_footer_timestamp;
    u32 read_object_id;
    u8 read_footer_id;

    Xil_DCacheFlushRange((UINTPTR)dataptr, (MAX_TRIGGER_LEN*2 + 4) * sizeof(u64));
    read_header_timestamp = (dataptr[0] & 0x00FFFFFF);
    read_trigger_info = (dataptr[0] >> 24) & 0x000000FF;
    read_trigger_length = (dataptr[0] >> (24 + 8)) & 0x00000FFF;
    read_header_id = (dataptr[0] >> (24 + 8 + 12 + 12)) & 0x000000FF;
    read_raw_charge_sum = (dataptr[1] >> 32) & 0x00FFFFFF;
    read_charge_sum = (read_raw_charge_sum << 8) >> 8;  // sign extention
    read_fall_thre = (dataptr[1] & 0x0000FFFF);
    read_rise_thre = (dataptr[1] >> 16) & 0x0000FFFF;

    read_footer_id = (dataptr[read_trigger_length + 3 - 1] >> 56) & 0x000000FF;
    read_object_id = dataptr[read_trigger_length + 3 - 1] & 0xFFFFFFFF;
    read_footer_timestamp = ((dataptr[read_trigger_length + 3 - 1] & 0x00FFFFFF00000000) >> 8) & 0x00000FFFFFF000000;

    if (print_enable > 1) {
        printData(dataptr, read_trigger_length + 3);
    }
    if (print_enable > 0){
    xil_printf("Rcvd frame  signal_length:%4u, timestamp:%5u, trigger_info:%2x, falling_edge_threshold:%4d, rising_edge_threshold:%4d, object_id:%4u\r\n", read_trigger_length * 4,
               read_footer_timestamp + read_header_timestamp, read_trigger_info, read_fall_thre, read_rise_thre, read_object_id);
    }
    if (read_object_id == 0) {
        // read_trigger_info = {1'b0, TRIGGER_STATE[1:0], FRAME_CONTINUE[0], TRIGGER_TYPE[3:0]}
        // read_trigger_info & 8'b0110_0000 == 8'b0010_0000
        // left: mask except trigger state
        // right: trigger state must be 2'b01 at first frame
    	if ((read_trigger_info & 0xC0) == 0xC0) {
            	xil_printf("trigger_info invalid Data: %2x Valid: %2x or %2x\r\n", read_trigger_info & 0x40, 0x40, 0xC0);
            	Status = XST_FAILURE;
        } else if ((read_trigger_info & 0x10) == 0x00) {
            // read_trigger_info = {1'b0, TRIGGER_STATE[1:0], FRAME_CONTINUE[0], TRIGGER_TYPE[3:0]}
            // read_trigger_info & 8'b0001_0000 == 8'b0000_0000
            // left: mask except frame_continure
            // right: trigger state = 2'b10 (halt) and frame continue means frame generator fifo is full
//            xil_printf("trigger_info indicates this is last frame\r\n", read_trigger_info);
            Status = LAST_FRAME;
        }

    } else if ((read_trigger_info & 0x10) == 0x00) {
            // read_trigger_info = {1'b0, TRIGGER_STATE[1:0], FRAME_CONTINUE[0], TRIGGER_TYPE[3:0]}
            // read_trigger_info & 8'b0001_0000 == 8'b0000_0000
            // left: mask except frame_continure
            // right: trigger state = 2'b10 (halt) and frame continue means frame generator fifo is full
//            xil_printf("trigger_info indicates this is last frame\r\n", read_trigger_info);
            Status = LAST_FRAME;
    }

    if ((read_trigger_info & 0xC0) == 0x80) {
                // read_trigger_info = {1'b0, TRIGGER_STATE[1:0], FRAME_CONTINUE[0], TRIGGER_TYPE[3:0]}
                // read_trigger_info & 8'b0001_0000 == 8'b0000_0000
                // left: mask except frame_continure
                // right: trigger state = 2'b10 (halt) and frame continue means frame generator fifo is full
    //            xil_printf("trigger_info indicates this is last frame\r\n", read_trigger_info);
                Status = INTERNAL_BUFFER_FULL;
    }

    if (read_header_id != 0xAA) {
        xil_printf("HEADER_ID mismatch Data: %2x Expected: %2x\r\n", read_header_id, 0xAA);
        Status = XST_FAILURE;
    } else if (read_rise_thre != rise_thre) {
        xil_printf("threshold mismatch Data: %d Expected: %d\r\n", read_rise_thre, rise_thre);
        Status = XST_FAILURE;
    } else if (read_fall_thre != fall_thre) {
        xil_printf("fall_thre mismatch Data: %d Expected: %d\r\n", read_fall_thre, fall_thre);
        Status = XST_FAILURE;
    }

    if (read_footer_id != 0x55) {
        xil_printf("FOOTER_ID mismatch Data: %2x Expected: %2x\r\n", read_footer_id, 0x55);
        printData(dataptr, read_trigger_length + 3);
        Status = XST_FAILURE;
    }

    *rcvd_frame_length = read_trigger_length + 4;
    incr_wrptr_after_write(read_trigger_length + 4);
//    xil_printf("\n");
    return Status;
}

void prvDmaTask(void *pvParameters) {
	int fee_status;
	int s2mm_dma_state = XST_SUCCESS;
	int check_result = LAST_FRAME;
	dma_task_end_flag = DMA_TASK_READY;

	int test_send_frame_count = 2048;
	int send_frame_count = 0;

	u64 rcvd_frame_len;
	u64 dump_recv_size = 0;

	u64 *dataptr;
	if (InitIntrController(&xInterruptController) != XST_SUCCESS) {
		xil_printf("Failed to setup interrupt controller.\r\n");
	}

    vApplicationDaemonRxTaskStartupHook();
    xil_printf("Dmatask start up done\r\n");
	xil_printf("Waiting Send2PC task start\r\n");
	vTaskSuspend(NULL);

    xil_printf("FEE start\r\n");
    fee_status = HardwareTrigger_StartDeviceId(0);

    while (fee_status == XST_SUCCESS) {
        s2mm_dma_state = axidma_recv_buff();
        if (s2mm_dma_state == XST_SUCCESS) {
            while (!RxDone && !Error) {
                /* code */
            }
            if (Error) {
                xil_printf("Error interrupt asserted.\r\n");
                break;
            }
        } else if (buff_will_be_full(MAX_PKT_LEN / sizeof(u64))) {
            xil_printf("S2MM Dma buffer is full. \r\n");
        } else {
            xil_printf("S2MM Dma failed beacuse of internal error. \r\n");
            break;
        }

        if ((s2mm_dma_state == XST_SUCCESS) || buff_will_be_full(MAX_PKT_LEN / sizeof(u64))) {
            dataptr = get_wrptr();
            check_result = checkData(dataptr, RISING_EDGE_THRESHOLD, FALLING_EDGE_THRESHOLD, 0, &rcvd_frame_len);
            if (check_result == XST_FAILURE) {
                break;
            }
//            rcvd_frame_len = ((dataptr[0] >> (24 + 8)) & 0x00000FFF) + 4;
//            incr_wrptr_after_write(rcvd_frame_len);
            dump_recv_size += rcvd_frame_len * sizeof(u64);
            send_frame_count++;
        }

//        if (send_frame_count > test_send_frame_count && check_result == LAST_FRAME) {
//            xil_printf("Total recieved frame count reached the target number!\r\n");
//            break;
//        }

        if ((dump_recv_size > SEND_BUF_SIZE)) {
            dump_recv_size = 0;
            xTaskNotifyGive(app_thread);
            vTaskSuspend(NULL);
        }
//        else if (check_result==INTERNAL_BUFFER_FULL) {
//        	break;
//        }

        if (socket_close_flag == SOCKET_CLOSE) {
            break;
        }
    }

    xil_printf("FEE shutdown.\r\n");
    fee_status = HardwareTrigger_StopDeviceId(0);
    shutdown_dma();
    dma_task_end_flag = DMA_TASK_END;
    vTaskDelete(NULL);
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
