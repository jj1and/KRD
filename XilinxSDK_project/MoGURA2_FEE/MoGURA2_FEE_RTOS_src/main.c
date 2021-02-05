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
#include "intr_manager.h"
#include "peripheral_manager.h"
#include "platform_config.h"
#include "rfdc_manager.h"
#include "send2pc.h"
#include "task.h"
#include "xil_printf.h"
#include "xparameters.h"

#define TIMER_ID 1
#define DELAY_10_SECONDS 10000UL
#define DELAY_1_SECOND 1000UL
#define FAIL_CNT_THRESHOLD 5
#define SEND_BUF_SIZE (TCP_SND_BUF - MAX_PKT_LEN)

#define MODE_SWITCH_UPPER_THRE 2047
#define MODE_SWITCH_LOWER_THRE -2048

#define H_GAIN_BASELINE 0
#define L_GAIN_BASELINE 0

#define RISING_EDGE_THRESHOLD 128
#define FALLING_EDGE_THRESHOLD 0

#define PRE_ACQUISITION_LENGTH 2
#define POST_ACQUISITION_LENGTH 1

static Channel_Config ch_config_array[16];
const Channel_Config channel_0 = {0, ENABLE, NORMAL_ACQUIRE_MODE, EXTERNAL_TRIGGER, -256, FALLING_EDGE_THRESHOLD, PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH, H_GAIN_BASELINE, L_GAIN_BASELINE};
const Channel_Config channel_1 = {1, ENABLE, DSP_NORMAL_ACQUIRE_MODE, EXTERNAL_TRIGGER, -256, FALLING_EDGE_THRESHOLD, PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH, H_GAIN_BASELINE, L_GAIN_BASELINE};
const Channel_Config channel_2 = {2, ENABLE, DSP_NORMAL_ACQUIRE_MODE, EXTERNAL_TRIGGER, -256, FALLING_EDGE_THRESHOLD, PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH, H_GAIN_BASELINE, L_GAIN_BASELINE};
const Channel_Config channel_3 = {3, ENABLE, DSP_NORMAL_ACQUIRE_MODE, EXTERNAL_TRIGGER, -256, FALLING_EDGE_THRESHOLD, PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH, H_GAIN_BASELINE, L_GAIN_BASELINE};
const Channel_Config channel_4 = {4, ENABLE, DSP_NORMAL_ACQUIRE_MODE, EXTERNAL_TRIGGER, -256, FALLING_EDGE_THRESHOLD, PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH, H_GAIN_BASELINE, L_GAIN_BASELINE};
const Channel_Config channel_5 = {5, ENABLE, DSP_NORMAL_ACQUIRE_MODE, EXTERNAL_TRIGGER, -256, FALLING_EDGE_THRESHOLD, PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH, H_GAIN_BASELINE, L_GAIN_BASELINE};
const Channel_Config channel_6 = {6, ENABLE, DSP_NORMAL_ACQUIRE_MODE, EXTERNAL_TRIGGER, -256, FALLING_EDGE_THRESHOLD, PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH, H_GAIN_BASELINE, L_GAIN_BASELINE};
const Channel_Config channel_7 = {7, ENABLE, DSP_NORMAL_ACQUIRE_MODE, EXTERNAL_TRIGGER, -256, FALLING_EDGE_THRESHOLD, PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH, H_GAIN_BASELINE, L_GAIN_BASELINE};
const Channel_Config channel_8 = {8, ENABLE, DSP_NORMAL_ACQUIRE_MODE, EXTERNAL_TRIGGER, -256, FALLING_EDGE_THRESHOLD, PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH, H_GAIN_BASELINE, L_GAIN_BASELINE};
const Channel_Config channel_9 = {9, ENABLE, NORMAL_ACQUIRE_MODE, EXTERNAL_TRIGGER, -256, FALLING_EDGE_THRESHOLD, PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH, H_GAIN_BASELINE, L_GAIN_BASELINE};
const Channel_Config channel_10 = {10, ENABLE, NORMAL_ACQUIRE_MODE, EXTERNAL_TRIGGER, -256, FALLING_EDGE_THRESHOLD, PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH, H_GAIN_BASELINE, L_GAIN_BASELINE};
const Channel_Config channel_11 = {11, ENABLE, NORMAL_ACQUIRE_MODE, EXTERNAL_TRIGGER, -256, FALLING_EDGE_THRESHOLD, PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH, H_GAIN_BASELINE, L_GAIN_BASELINE};
const Channel_Config channel_12 = {12, ENABLE, NORMAL_ACQUIRE_MODE, EXTERNAL_TRIGGER, -256, FALLING_EDGE_THRESHOLD, PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH, H_GAIN_BASELINE, L_GAIN_BASELINE};
const Channel_Config channel_13 = {13, ENABLE, NORMAL_ACQUIRE_MODE, EXTERNAL_TRIGGER, -256, FALLING_EDGE_THRESHOLD, PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH, H_GAIN_BASELINE, L_GAIN_BASELINE};
const Channel_Config channel_14 = {14, ENABLE, NORMAL_ACQUIRE_MODE, EXTERNAL_TRIGGER, -256, FALLING_EDGE_THRESHOLD, PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH, H_GAIN_BASELINE, L_GAIN_BASELINE};
const Channel_Config channel_15 = {15, ENABLE, NORMAL_ACQUIRE_MODE, EXTERNAL_TRIGGER, -256, FALLING_EDGE_THRESHOLD, PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH, H_GAIN_BASELINE, L_GAIN_BASELINE};

int internalbuffer_full_cnt;

static Ladc_Config LadcConfig;
static u16 baseline = 0x233;

const TickType_t x1seconds = pdMS_TO_TICKS(DELAY_1_SECOND);
const TickType_t x10seconds = pdMS_TO_TICKS(DELAY_10_SECONDS);

const int RFDC_ADC_TILES[4] = {0, 1, 2, 3};
// const int RFDC_DAC_TILES[1] = {0};

AvailableAdcTiles AdcTile = {
    4,
    RFDC_ADC_TILES};

// AvailableDacTiles DacTile = {
//     0,
//     RFDC_DAC_TILES};

struct netif myself_netif;
app_arg send2pc_setting;

void network_thread(void *arg);
void cmdrecv_application_thread(void *pvParameters);
void prvDmaTask(void *pvParameters);
void cleanup_tasks(void *pvParameters);
int vAppDaemonDmaTaskStartupHook();
int vAppDaemonPeripheralStartupHook();

static void flush_buff(char *buff) {
    for (size_t i = 0; i < RECV_BUF_SIZE; i++) {
        buff[i] = 'f';
    }
}

int main() {
    send2pc_setting.port = 5001;
    send2pc_setting.server_address = "192.168.1.2";
    send2pc_setting.xTicksToWait = x10seconds;

    int Status;
    xil_printf("INFO: MoGURA2 FEE RTOS for debug\r\n");
    Status = peripheral_setup();
    if (Status != XST_SUCCESS) return XST_FAILURE;

    double refClkFreq_MHz = 250.00;
    double ADC_samplingRate_Msps = 2000.0;
    Status = rfdcADC_MTS_setup(RFDC_DEVICE_ID, refClkFreq_MHz, ADC_samplingRate_Msps, AdcTile);
    if (Status != XST_SUCCESS) {
        xil_printf("ERROR: Failed to setup RF Data Converter ADC\r\n");
        return XST_FAILURE;
    }
    // Status = rfdcSingle_setup(RFDC_DEVICE_ID, 0, XRFDC_ADC_TILE, refClkFreq_MHz, ADC_samplingRate_Msps);
    // if (Status != XST_SUCCESS) {
    //     xil_printf("ERROR: Failed to setup RF Data Converter ADC in single\r\n");
    //     return XST_FAILURE;
    // }

    //    double DAC_samplingRate_Msps = 983.04;
    //    Status = rfdcDAC_MTS_setup(RFDC_DEVICE_ID, refClkFreq_MHz, DAC_samplingRate_Msps, DacTile);
    //    Status = rfdcSingle_setup(RFDC_DEVICE_ID, XRFDC_DAC_TILE, 0, refClkFreq_MHz, DAC_samplingRate_Msps);
    //    if (Status != XST_SUCCESS) {
    //        xil_printf("ERROR: Failed to setup RF Data Converter DAC\r\n");
    //        return XST_FAILURE;
    //    }

    Status = axidma_setup();
    if (Status != XST_SUCCESS) {
        xil_printf("ERROR: Failed to Setup AXI-DMA\r\n");
        return XST_FAILURE;
    }

    sys_thread_new("nw_thread", network_thread, &send2pc_setting, THREAD_STACKSIZE, DEFAULT_THREAD_PRIO);

    if (InitIntrController(&xInterruptController) != XST_SUCCESS) {
        xil_printf("ERROR: Failed to setup interrupt controller.\r\n");
    }
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
    xil_printf("----- FEE client setup ------\r\n");

    /* initliaze IP addresses to be used */
    IP4_ADDR(&ipaddr, 192, 168, 1, 7);
    IP4_ADDR(&netmask, 255, 255, 255, 0);
    IP4_ADDR(&gw, 192, 168, 1, 1);

    /* print out IP settings of the board */
    print_ip_settings(&ipaddr, &netmask, &gw);

    /* Add network interface to the netif_list, and set it as default */
    if (!xemac_add(netif, &ipaddr, &netmask, &gw, mac_ethernet_address, PLATFORM_EMAC_BASEADDR)) {
        xil_printf("ERROR: Error adding N/W interface\r\n");
        return;
    }

    netif_set_default(netif);
    /* specify that the network if is up */
    netif_set_up(netif);

    /* start packet receive thread - required for lwIP operation */
    sys_thread_new("xemacif_input_thread", (void (*)(void *))xemacif_input_thread, netif, THREAD_STACKSIZE, DEFAULT_THREAD_PRIO + 1);
    xTaskCreate(prvDmaTask, (const char *)"AXIDMA transfer", configMINIMAL_STACK_SIZE, NULL, DEFAULT_THREAD_PRIO, &xDmaTask);
    cmd_thread = sys_thread_new("cmdrcvdd", cmdrecv_application_thread, NULL, THREAD_STACKSIZE, DEFAULT_THREAD_PRIO + 1);
    app_thread = sys_thread_new("send2pcd", send2pc_application_thread, arg, THREAD_STACKSIZE, DEFAULT_THREAD_PRIO - 1);
    vTaskDelete(NULL);
    return;
}

int vAppDaemonPeripheralStartupHook() {
    int Status;
    xil_printf("\nINFO: Set up AXI Quad SPI Controller Interrupt systems\n");
    Status = SetupSpiIntrSystem(&xInterruptController, SPI_BASEDAC_INTR);
    if (Status != XST_SUCCESS) {
        xil_printf("ERROR: Failed to set up Baseline DAC AXI Quad SPI Controller Interrupt system\r\n");
        return XST_FAILURE;
    }

    Status = SetupSpiIntrSystem(&xInterruptController, SPI_LADC_INTR);
    if (Status != XST_SUCCESS) {
        xil_printf("ERROR: Failed to set up LADC AXI Quad SPI Controller Interrupt system\r\n");
        return XST_FAILURE;
    }
    return XST_SUCCESS;
}

void cleanup_tasks(void *pvParameters) {
    DisableIntrSystem(&xInterruptController, SPI_BASEDAC_INTR);
    DisableIntrSystem(&xInterruptController, SPI_LADC_INTR);
    DisableIntrSystem(&xInterruptController, RX_INTR_ID);

    vTaskDelete(xDmaTask);
    vTaskDelete(app_thread);
    vTaskDelete(cmd_thread);
    vTaskDelete(NULL);
    exit(0);
    return;
}

void cmdrecv_application_thread(void *pvParameters) {
    int status;
    struct sockaddr_in myself, remote;
    int sock, sd, size, n;
    int quit_flag = 0;
    char recv_buf[RECV_BUF_SIZE];
    int mesglen;
    char mesgbuff[2048];

    ch_config_array[0] = channel_0;
    ch_config_array[1] = channel_1;
    ch_config_array[2] = channel_2;
    ch_config_array[3] = channel_3;
    ch_config_array[4] = channel_4;
    ch_config_array[5] = channel_5;
    ch_config_array[6] = channel_6;
    ch_config_array[7] = channel_7;
    ch_config_array[8] = channel_8;
    ch_config_array[9] = channel_9;
    ch_config_array[10] = channel_10;
    ch_config_array[11] = channel_11;
    ch_config_array[12] = channel_12;
    ch_config_array[13] = channel_13;
    ch_config_array[14] = channel_14;
    ch_config_array[15] = channel_15;
    fee.ChannelNum = 16;
    fee.ChanelConfigs = ch_config_array;
    fee.MaxTriggerLength = MAX_TRIGGER_LEN;

    baseline = 0x233;
    LadcConfig.TestPattern1 = DEFAULT_LADC_TPN1;
    LadcConfig.TestPattern2 = DEFAULT_LADC_TPN2;
    LadcConfig.OperationMode = LADC_DOUBLETPNMODE;

    xCmdrcvd2DmaSemaphore = xSemaphoreCreateBinary();

    SetSwitchThreshold(MODE_SWITCH_UPPER_THRE, MODE_SWITCH_LOWER_THRE);
    HardwareTrigger_SetupDeviceId(0, &fee);

    vAppDaemonPeripheralStartupHook();

    memset(&myself, 0, sizeof(myself));
    if ((sock = lwip_socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        xil_printf("ERROR: failed to get cmd socket.\r\n");
        vTaskSuspendAll();
    }

    myself.sin_family = AF_INET;
    myself.sin_port = htons(CMDRECV_PORT);
    myself.sin_addr.s_addr = INADDR_ANY;

    if (lwip_bind(sock, (struct sockaddr *)&myself, sizeof(myself)) < 0) {
        xil_printf("ERROR: failed to bind cmd socket.\r\n");
        vTaskSuspendAll();
    }

    lwip_listen(sock, 0);
    size = sizeof(remote);

    while (1) {
        if ((sd = lwip_accept(sock, (struct sockaddr *)&remote, (socklen_t *)&size)) < 0) {
            break;
        } else {
            while (1) {
                xil_printf("INFO: waiting new command...\r\n");
                sprintf(mesgbuff, "INFO: \'help\' to show avaiable command.\r\n");
                write(sd, mesgbuff, strlen(mesgbuff));
                if ((n = read(sd, recv_buf, RECV_BUF_SIZE)) < 0) {
                    xil_printf("%s: error reading from socket %d, closing socket\r\n", __FUNCTION__, sd);
                    break;
                }
                /* break if the recved message = "quit" */
                if (!strncmp(recv_buf, "quit", 4)) {
                    sprintf(mesgbuff, "INFO: shutdown fee\r\n");
                    xil_printf(mesgbuff);
                    write(sd, mesgbuff, strlen(mesgbuff));
                    quit_flag = 1;
                    break;
                } else {
                    if (!strncmp(recv_buf, "help", 4)) {
                        sprintf(mesgbuff, "\r\n");
                        write(sd, mesgbuff, strlen(mesgbuff));
                        sprintf(mesgbuff, "****************************************\r\n");
                        write(sd, mesgbuff, strlen(mesgbuff));
                        sprintf(mesgbuff, "**          simple FEE OS menu        **\r\n");
                        write(sd, mesgbuff, strlen(mesgbuff));
                        sprintf(mesgbuff, "****************************************\r\n");
                        write(sd, mesgbuff, strlen(mesgbuff));
                        sprintf(mesgbuff, "help       : show avairable command\r\n");
                        write(sd, mesgbuff, strlen(mesgbuff));
                        sprintf(mesgbuff, "size       : total send size to PC\r\n");
                        write(sd, mesgbuff, strlen(mesgbuff));
                        sprintf(mesgbuff, "baseline   : baseline \r\n");
                        write(sd, mesgbuff, strlen(mesgbuff));
                        sprintf(mesgbuff, "start      : start data acquisition\r\n");
                        write(sd, mesgbuff, strlen(mesgbuff));
                        sprintf(mesgbuff, "reset      : reset hardware trigger\r\n");
                        write(sd, mesgbuff, strlen(mesgbuff));
                        sprintf(mesgbuff, "quit       : shutdown FEE and disconnect\r\n");
                        write(sd, mesgbuff, strlen(mesgbuff));
                    } else if (!strncmp(recv_buf, "size", 4)) {
                        sprintf(mesgbuff, "INFO: Enter total send data size (unit is Byte)(0 < size < %d).\r\n", TOTAL_SEND_SIZE);
                        xil_printf(mesgbuff);
                        write(sd, mesgbuff, strlen(mesgbuff));
                        if ((n = read(sd, recv_buf, RECV_BUF_SIZE)) < 0) {
                            xil_printf("%s: error reading from socket %d, closing socket\r\n", __FUNCTION__, sd);
                            break;
                        }
                        int temp_total_data_size = atoi(recv_buf);
                        setTotalSendDataSize(temp_total_data_size);
                        sprintf(mesgbuff, "INFO: set total send data size as %d Byte.\r\n", getTotalSendDatasize());
                        write(sd, mesgbuff, strlen(mesgbuff));
                    } else if (!strncmp(recv_buf, "baseline", 8)) {
                        sprintf(mesgbuff, "INFO: Enter baseline (%d <= baseline <= %d).\r\n", 0x000, 0x2ff);
                        xil_printf(mesgbuff);
                        write(sd, mesgbuff, strlen(mesgbuff));
                        if ((n = read(sd, recv_buf, RECV_BUF_SIZE)) < 0) {
                            xil_printf("%s: error reading from socket %d, closing socket\r\n", __FUNCTION__, sd);
                            break;
                        }
                        baseline = atoi(recv_buf);
                        if ((baseline < 0) | (baseline > 767)) {
                            sprintf(mesgbuff, "ERROR: baseline must be larger than %d & smaller than %d\r\n", 0x000, 0x2ff);
                            xil_printf(mesgbuff);
                            write(sd, mesgbuff, strlen(mesgbuff));
                            baseline = 563;
                        } else {
                            sprintf(mesgbuff, "INFO: set baseline as %d.\r\n", baseline);
                            xil_printf(mesgbuff);
                            write(sd, mesgbuff, strlen(mesgbuff));
                        }
                    } else if (!strncmp(recv_buf, "start", 5)) {
                        sprintf(mesgbuff, "INFO: start command is rcvd.\r\n");
                        xil_printf(mesgbuff);
                        write(sd, mesgbuff, strlen(mesgbuff));
                        status = BaselineDAC_ApplyConfig(baseline);
                        if (status != XST_SUCCESS) return;

                        status = LADC_ApplyConfig(&LadcConfig);
                        if (status != XST_SUCCESS) return;

                        xSemaphoreGive(xCmdrcvd2DmaSemaphore);
                        vTaskSuspend(NULL);
                    } else if (!strncmp(recv_buf, "reset", 5)) {
                        sprintf(mesgbuff, "INFO: reset fee\r\n");
                        write(sd, mesgbuff, strlen(mesgbuff));
                        HardwareTrigger_SetupDeviceId(0, &fee);
                        axidma_setup();
                    } else {
                        sprintf(mesgbuff, "INFO: unknown command\r\n");
                        xil_printf(mesgbuff);
                        write(sd, mesgbuff, strlen(mesgbuff));
                    }
                }
                flush_buff(recv_buf);
            }
            if (quit_flag > 0) {
                break;
            }
        }
    }
    close(sd);
    cleanup_thread = sys_thread_new("cleanupd", cleanup_tasks, NULL, THREAD_STACKSIZE, DEFAULT_THREAD_PRIO + 2);
    vTaskSuspend(NULL);
    // exit(0);
    return;
}

void prvDmaTask(void *pvParameters) {
    int fee_status;
    int s2mm_dma_state = XST_SUCCESS;
    int check_result = LAST_FRAME;
    int timeout_flag = 0;

    int test_send_frame_count = 2048;
    int send_frame_count = 0;

    u64 rcvd_frame_len;
    u64 dump_recv_size = 0;

    u64 *dataptr;

    vAppDaemonDmaTaskStartupHook();
    xil_printf("INFO: Start Dma task\r\n");
    xDma2Send2pcSemaphore = xSemaphoreCreateBinary();

    while (1) {
        internalbuffer_full_cnt = 0;
        timeout_flag = 0;
        if (xSemaphoreTake(xCmdrcvd2DmaSemaphore, portMAX_DELAY)) {
            xil_printf("INFO: Waiting Send2PC task start\r\n");
            xSemaphoreGive(xDma2Send2pcSemaphore);
            vTaskSuspend(NULL);
        } else {
            xil_printf("INFO: Waiting Cmdrcvd is Timeout\r\n");
            break;
        }

        xil_printf("INFO: Run start\r\n");
        fee_status = HardwareTrigger_StartDeviceIdAllCh(0);
        // for (u16 i = 0; i < 16; i++) {
        //     if (ch_config_array[i].enable == ENABLE) {
        //         fee_status = HardwareTrigger_StartDeviceId(0, i);
        //         if (fee_status != XST_SUCCESS) {
        //             return fee_status;
        //         }
        //     }
        // }

        while (fee_status == XST_SUCCESS) {
            s2mm_dma_state = axidma_recv_buff();
            if (s2mm_dma_state == XST_SUCCESS) {
                if (ulTaskNotifyTake(pdTRUE, 10 * x1seconds)) {
                    if (getRxError()) {
                        xil_printf("ERROR: Error interrupt asserted.\r\n");
                        break;
                    }
                } else {
                    xil_printf("INFO: DMA execution is timeout.\r\n");
                    timeout_flag = 1;
                    break;
                }
            } else if (buff_will_be_full(MAX_PKT_LEN / sizeof(u64))) {
                xil_printf("INFO: S2MM Dma buffer is full. \r\n");
            } else {
                xil_printf("ERROR: S2MM Dma failed beacuse of internal error. \r\n");
                break;
            }

            if ((s2mm_dma_state == XST_SUCCESS) || buff_will_be_full(MAX_PKT_LEN / sizeof(u64))) {
                dataptr = get_wrptr();
                check_result = checkData(dataptr, fee, 0, &rcvd_frame_len);
                if (check_result == XST_FAILURE) {
                    break;
                }
                //            rcvd_frame_len = ((dataptr[0] >> (24 + 8)) & 0x00000FFF) + 4;
                //            incr_wrptr_after_write(rcvd_frame_len);
                dump_recv_size += rcvd_frame_len * sizeof(u64);
                send_frame_count++;
            }

            if (check_result == INTERNAL_BUFFER_FULL) {
                internalbuffer_full_cnt++;
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

            if (internalbuffer_full_cnt == fee.ChannelNum) {
                xil_printf("INFO: internal buffer gets full for %d times\r\n", internalbuffer_full_cnt);
                xil_printf("INFO: stop fee\r\n");
                fee_status = HardwareTrigger_StopDeviceIdAllCh(0);
                if (fee_status != XST_SUCCESS) {
                    xil_printf("ERROR: failed to stop fee\r\n");
                    break;
                }
            }

            if ((getSend2pcTaskStauts() == SOCKET_CLOSE) || (timeout_flag == 1)) {
                xil_printf("INFO: Run end.\r\n");
                fee_status = HardwareTrigger_StopDeviceIdAllCh(0);
                break;
            }
        }
        if (getSend2pcTaskStauts() != SOCKET_CLOSE) {
            dump_recv_size = 0;
            xTaskNotifyGive(app_thread);
            vTaskSuspend(NULL);
        }
        vTaskResume(cmd_thread);
    }

    return;
}

int vAppDaemonDmaTaskStartupHook() {
    int Status;
    xil_printf("\nINFO: Set up AXIDMA Rx Interrupt system\n");
    Status = SetupRxIntrSystem(&xInterruptController, RX_INTR_ID);
    if (Status != XST_SUCCESS) {
        xil_printf("ERROR: Failed to set up AXIDMA Rx Interrupt system\r\n");
        return XST_FAILURE;
    }
    return XST_SUCCESS;
}
