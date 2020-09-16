/*
 * main.c
 *
 *  Created on: 2020/06/29
 *      Author: jj1and
 */
#include "FreeRTOS.h"
#include "axidma_manager.h"
#include "platform_config.h"
#include "send2pc.h"
#include "task.h"
#include "timers.h"
#include "xgpio.h"
#include "xil_printf.h"
#include "xparameters.h"

#define TIMER_ID 1
#define DELAY_10_SECONDS 10000UL
#define DELAY_1_SECOND 1000UL
#define FAIL_CNT_THRESHOLD 5

// GPIO related constants
#define CONFIG_GPIO_DEVICE_ID XPAR_CONFIG_GPIO_DEVICE_ID
#define SET_CONFIG_CH 1
#define MAX_TRIGGER_LENGTH_CH 2
#define SET_CONFIG_BITWIDTH 1
#define MAX_TRIGGER_LENGTH_BITWIDTH 12

static struct netif myself_netif;

const TickType_t x10seconds = pdMS_TO_TICKS(DELAY_10_SECONDS);
XGpio GpioConfig;

TaskHandle_t app_thread;
app_arg send2pc_setting = {5001, "192.168.1.19", x10seconds};

int GpioSetUp(XGpio *GpioInstPtr, u16 DeviceId);
void SetConfig(u8 set_config);
void SetMaxTriggerLength(u16 max_trigger_length);

void network_thread(void *arg);
void prvDmaTask(void *pvParameters);
int vApplicationDaemonTxTaskStartupHook();
int vApplicationDaemonRxTaskStartupHook();
void vTimerCallback(TimerHandle_t pxTimer);

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
    xil_printf("dataframe_generator test\r\n");

    Status = axidma_setup();
    if (Status != XST_SUCCESS) xil_printf("Failed to Setup AXI-DMA\r\n");

    Status = GpioSetUp(&GpioConfig, CONFIG_GPIO_DEVICE_ID);
    if (Status != XST_SUCCESS) {
        xil_printf("Failed to initialize config GPIO\r\n");
        return XST_FAILURE;
    }
    SetConfig(1);
    SetMaxTriggerLength(MAX_TRIGGER_LEN);
    SetConfig(0);

    xTaskCreate(prvDmaTask, (const char *)"AXIDMA transfer", configMINIMAL_STACK_SIZE, NULL, DEFAULT_THREAD_PRIO + 1, &xDmaTask);
    sys_thread_new("nw_thread", network_thread, &send2pc_setting, THREAD_STACKSIZE, DEFAULT_THREAD_PRIO);
    vTaskStartScheduler();
    while (1)
        ;
    // never reached
    return 0;
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

int GpioSetUp(XGpio *GpioInstPtr, u16 DeviceId) {
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

void SetConfig(u8 set_config) {
    XGpio_DiscreteWrite(&GpioConfig, SET_CONFIG_CH, set_config);
    xil_printf("Set Config: %1d\r\n", set_config);
}

void SetMaxTriggerLength(u16 max_trigger_length) {
    XGpio_DiscreteWrite(&GpioConfig, MAX_TRIGGER_LENGTH_CH, max_trigger_length);
    xil_printf("Set Max Trigger Length: %d\r\n", max_trigger_length);
}

static void printData(u64 *dataptr, u64 frame_size) {
    for (int i = 0; i < frame_size; i++) {
        if ((i + 1) % 2 == 0) {
            xil_printf("%016llx\n", dataptr[i]);
        } else {
            xil_printf("Recived : %016llx ", dataptr[i]);
        }
    }
    xil_printf("\r\n");
}

void prvDmaTask(void *pvParameters) {
    int mm2s_dma_state = XST_SUCCESS;
    int s2mm_dma_state = XST_SUCCESS;
    int data_length = 8;
    dma_task_end_flag = DMA_TASK_READY;

    int send_frame_len = 0;
    int read_frame_len = 0;
    u32 frame_len;

    u64 timestamp_at_beginning = 255;
    u8 trigger_info = 16;
    u16 baseline = 0;
    u16 threthold = 15;
    u32 object_id = -1;

    u64 dump_recv_size = 0;

    u64 *dataptr;
    if (InitIntrController(&xInterruptController) != XST_SUCCESS) {
        xil_printf("Failed to setup interrupt controller.\r\n");
    }

    vApplicationDaemonRxTaskStartupHook();
    vApplicationDaemonTxTaskStartupHook();

    xil_printf("Dmatask start up done\r\n");
    xil_printf("Waiting Send2PC task start\r\n");
    vTaskSuspend(NULL);

    while (TRUE) {
        dma_task_end_flag = DMA_TASK_RUN;

        if (read_frame_len < send_frame_len || read_frame_len == 0) s2mm_dma_state = axidma_recv_buff();

        if (s2mm_dma_state == XST_SUCCESS) {
            if (read_frame_len == send_frame_len) send_frame_len = 0;
            while (send_frame_len * sizeof(u64) + MAX_PKT_LEN < AXIDMA_BUFF_SIZE) {
                mm2s_dma_state = axidma_send_buff(trigger_info, timestamp_at_beginning, baseline, threthold, data_length, 0);
                if (mm2s_dma_state != XST_SUCCESS) {
                    xil_printf("MM2S Dma failed. \r\n");
                    break;
                }
                while (!TxDone && !Error) {
                    /* code */
                }
                if (!Error) {
                    send_frame_len += (data_length * 2) + 3;
                    object_id++;
                    if (object_id % 1000 == 0) {
                        xil_printf("\nSend frame  trigger_length:%4d, timestamp:%5d, trigger_info:%2x, baseline:%4d, threshold:%4d, object_id:%4d\r\n", data_length, timestamp_at_beginning,
                                   trigger_info, baseline, threthold, object_id);
                    }
                } else {
                    xil_printf("Error interrupt asserted.\r\n");
                    break;
                }
            }

            while (!RxDone && !Error) {
                /* code */
            }
            if (!Error) {
                dataptr = get_wrptr();
                Xil_DCacheFlushRange((UINTPTR)dataptr, MAX_PKT_LEN);
                frame_len = ((dataptr[0] >> (24 + 8)) & 0x00000FFF);
//                printData(dataptr, frame_len + 3);
                read_frame_len += frame_len + 3;
                dump_recv_size += (frame_len + 3) * sizeof(u64);
                incr_wrptr_after_write(frame_len + 3);
            } else {
                xil_printf("Error interrupt asserted.\r\n");
                break;
            }
        } else if (buff_will_be_full(MAX_PKT_LEN / sizeof(u64))) {
            xil_printf("S2MM Dma buffer is full. \r\n");
        } else {
            xil_printf("S2MM Dma failed beacuse of internal error. \r\n");
            break;
        }

        if (dump_recv_size > SEND_BUF_SIZE) {
            dump_recv_size = 0;
            xTaskNotifyGive(app_thread);
            vTaskSuspend(NULL);
        }

        if (socket_close_flag == SOCKET_CLOSE) {
            break;
        }
    }

    shutdown_dma();
    xil_printf("Dmatask end\r\n");
    dma_task_end_flag = DMA_TASK_END;
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
