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
#include "xtime_l.h"

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

const TickType_t x1seconds = pdMS_TO_TICKS(DELAY_1_SECOND);
const TickType_t x10seconds = pdMS_TO_TICKS(DELAY_10_SECONDS);

const double refClkFreq_MHz = 250.00;
const double ADC_samplingRate_Msps = 2000.0;

const int RFDC_ADC_TILES[4] = {0, 1, 2, 3};
// const int RFDC_DAC_TILES[1] = {0};

AvailableAdcTiles AdcTile = {
    4,
    RFDC_ADC_TILES};

// AvailableDacTiles DacTile = {
//     0,
//     RFDC_DAC_TILES};

static Channel_Config ch_config_array[16];
static Channel_Config channel_0 = {0, ENABLE, NORMAL_ACQUIRE_MODE, EXTERNAL_TRIGGER, -256, FALLING_EDGE_THRESHOLD, PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH, H_GAIN_BASELINE, L_GAIN_BASELINE};
static Channel_Config channel_1 = {1, ENABLE, NORMAL_ACQUIRE_MODE, EXTERNAL_TRIGGER, -256, FALLING_EDGE_THRESHOLD, PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH, H_GAIN_BASELINE, L_GAIN_BASELINE};
static Channel_Config channel_2 = {2, ENABLE, NORMAL_ACQUIRE_MODE, EXTERNAL_TRIGGER, -256, FALLING_EDGE_THRESHOLD, PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH, H_GAIN_BASELINE, L_GAIN_BASELINE};
static Channel_Config channel_3 = {3, ENABLE, NORMAL_ACQUIRE_MODE, EXTERNAL_TRIGGER, -256, FALLING_EDGE_THRESHOLD, PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH, H_GAIN_BASELINE, L_GAIN_BASELINE};
static Channel_Config channel_4 = {4, ENABLE, NORMAL_ACQUIRE_MODE, EXTERNAL_TRIGGER, -256, FALLING_EDGE_THRESHOLD, PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH, H_GAIN_BASELINE, L_GAIN_BASELINE};
static Channel_Config channel_5 = {5, ENABLE, NORMAL_ACQUIRE_MODE, EXTERNAL_TRIGGER, -256, FALLING_EDGE_THRESHOLD, PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH, H_GAIN_BASELINE, L_GAIN_BASELINE};
static Channel_Config channel_6 = {6, ENABLE, NORMAL_ACQUIRE_MODE, EXTERNAL_TRIGGER, -256, FALLING_EDGE_THRESHOLD, PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH, H_GAIN_BASELINE, L_GAIN_BASELINE};
static Channel_Config channel_7 = {7, ENABLE, NORMAL_ACQUIRE_MODE, EXTERNAL_TRIGGER, -256, FALLING_EDGE_THRESHOLD, PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH, H_GAIN_BASELINE, L_GAIN_BASELINE};
static Channel_Config channel_8 = {8, ENABLE, NORMAL_ACQUIRE_MODE, EXTERNAL_TRIGGER, -256, FALLING_EDGE_THRESHOLD, PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH, H_GAIN_BASELINE, L_GAIN_BASELINE};
static Channel_Config channel_9 = {9, ENABLE, NORMAL_ACQUIRE_MODE, EXTERNAL_TRIGGER, -256, FALLING_EDGE_THRESHOLD, PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH, H_GAIN_BASELINE, L_GAIN_BASELINE};
static Channel_Config channel_10 = {10, ENABLE, NORMAL_ACQUIRE_MODE, EXTERNAL_TRIGGER, -256, FALLING_EDGE_THRESHOLD, PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH, H_GAIN_BASELINE, L_GAIN_BASELINE};
static Channel_Config channel_11 = {11, ENABLE, NORMAL_ACQUIRE_MODE, EXTERNAL_TRIGGER, -256, FALLING_EDGE_THRESHOLD, PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH, H_GAIN_BASELINE, L_GAIN_BASELINE};
static Channel_Config channel_12 = {12, ENABLE, NORMAL_ACQUIRE_MODE, EXTERNAL_TRIGGER, -256, FALLING_EDGE_THRESHOLD, PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH, H_GAIN_BASELINE, L_GAIN_BASELINE};
static Channel_Config channel_13 = {13, ENABLE, NORMAL_ACQUIRE_MODE, EXTERNAL_TRIGGER, -256, FALLING_EDGE_THRESHOLD, PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH, H_GAIN_BASELINE, L_GAIN_BASELINE};
static Channel_Config channel_14 = {14, ENABLE, NORMAL_ACQUIRE_MODE, EXTERNAL_TRIGGER, -256, FALLING_EDGE_THRESHOLD, PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH, H_GAIN_BASELINE, L_GAIN_BASELINE};
static Channel_Config channel_15 = {15, ENABLE, NORMAL_ACQUIRE_MODE, EXTERNAL_TRIGGER, -256, FALLING_EDGE_THRESHOLD, PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH, H_GAIN_BASELINE, L_GAIN_BASELINE};

static int test_size = 256000000;
XTime start_time;
XTime end_time;

static Ladc_Config LadcConfig;
static u16 baseline = 0x233;

struct netif myself_netif;

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
    XTime_StartTimer();
    DmaTaskState = DMATASK_READY;

    int Status;
    xil_printf("INFO: MoGURA2 FEE RTOS for debug\r\n");
    Status = peripheral_setup();
    if (Status != XST_SUCCESS) return XST_FAILURE;

    sys_thread_new("nw_thread", network_thread, NULL, THREAD_STACKSIZE, DEFAULT_THREAD_PRIO);

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
    GPO_TriggerReset();
    sleep(1);

    if (rfdcADC_MTS_setup(RFDC_DEVICE_ID, refClkFreq_MHz, ADC_samplingRate_Msps, AdcTile) != XST_SUCCESS) {
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

    SetSwitchThreshold(MODE_SWITCH_UPPER_THRE, MODE_SWITCH_LOWER_THRE);
    HardwareTrigger_SetupDeviceId(0, &fee);
    status = axidma_setup();
    if (status != XST_SUCCESS) {
        xil_printf("ERROR: Failed to Setup AXI-DMA\r\n");
        return XST_FAILURE;
    }
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
                        sprintf(mesgbuff, "test_size       : total send size to PC\r\n");
                        write(sd, mesgbuff, strlen(mesgbuff));
                        sprintf(mesgbuff, "baseline   : baseline \r\n");
                        write(sd, mesgbuff, strlen(mesgbuff));
                        sprintf(mesgbuff, "channel    : Enter enable channel with hex.\r\n");
                        write(sd, mesgbuff, strlen(mesgbuff));
                        sprintf(mesgbuff, "start      : start data acquisition\r\n");
                        write(sd, mesgbuff, strlen(mesgbuff));
                        sprintf(mesgbuff, "reset      : reset hardware trigger\r\n");
                        write(sd, mesgbuff, strlen(mesgbuff));
                        sprintf(mesgbuff, "quit       : shutdown FEE and disconnect\r\n");
                        write(sd, mesgbuff, strlen(mesgbuff));
                    } else if (!strncmp(recv_buf, "test_size", 9)) {
                        sprintf(mesgbuff, "INFO: Enter total test data size (unit is Byte).\r\n");
                        xil_printf(mesgbuff);
                        write(sd, mesgbuff, strlen(mesgbuff));
                        if ((n = read(sd, recv_buf, RECV_BUF_SIZE)) < 0) {
                            xil_printf("%s: error reading from socket %d, closing socket\r\n", __FUNCTION__, sd);
                            break;
                        }
                        test_size = atoi(recv_buf);
                        sprintf(mesgbuff, "INFO: set test data size as %d Byte.\r\n", test_size);
                        write(sd, mesgbuff, strlen(mesgbuff));
                    } else if (!strncmp(recv_buf, "baseline", 8)) {
                        sprintf(mesgbuff, "INFO: Enter baseline (%d <= baseline <= %d).\r\n", 0x000, 0x2ff);
                        xil_printf(mesgbuff);
                        write(sd, mesgbuff, strlen(mesgbuff));
                        if ((n = read(sd, recv_buf, RECV_BUF_SIZE)) < 0) {
                            xil_printf("%s: error reading from socket %d, closing socket\r\n", __FUNCTION__, sd);
                            break;
                        }
                        int temp_baseline = atoi(recv_buf);
                        if ((baseline < 0) | (baseline > 767)) {
                            sprintf(mesgbuff, "ERROR: baseline must be larger than %d & smaller than %d\r\n", 0x000, 0x2ff);
                            xil_printf(mesgbuff);
                            write(sd, mesgbuff, strlen(mesgbuff));
                        } else {
                            baseline = temp_baseline;
                            sprintf(mesgbuff, "INFO: set baseline as %d.\r\n", baseline);
                            xil_printf(mesgbuff);
                            write(sd, mesgbuff, strlen(mesgbuff));
                        }
                    } else if (!strncmp(recv_buf, "channel", 7)) {
                        sprintf(mesgbuff, "INFO: Enter enable channel with hex.\r\n");
                        xil_printf(mesgbuff);
                        write(sd, mesgbuff, strlen(mesgbuff));
                        if ((n = read(sd, recv_buf, RECV_BUF_SIZE)) < 0) {
                            xil_printf("%s: error reading from socket %d, closing socket\r\n", __FUNCTION__, sd);
                            break;
                        }
                        u16 en_ch = atoi(recv_buf);
                        if ((en_ch < 0) | (en_ch > 0xFFFF)) {
                            sprintf(mesgbuff, "ERROR: channel must be (%04x < channel < %04x)) %d\r\n", 0x0000, 0xFFFF);
                            xil_printf(mesgbuff);
                            write(sd, mesgbuff, strlen(mesgbuff));
                        } else {
                            sprintf(mesgbuff, "INFO: set enable channel as %x.\r\n", en_ch);
                            xil_printf(mesgbuff);
                            write(sd, mesgbuff, strlen(mesgbuff));
                            for (size_t i = 0; i < 16; i++) {
                                fee.ChanelConfigs[i].enable = (en_ch >> i) & 0x0001;
                            }
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
                        GPO_TriggerReset();
                        sleep(1);
                        rfdcADC_MTS_setup(RFDC_DEVICE_ID, refClkFreq_MHz, ADC_samplingRate_Msps, AdcTile);
                        SetSwitchThreshold(MODE_SWITCH_UPPER_THRE, MODE_SWITCH_LOWER_THRE);
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

    u64 rcvd_frame_len;
    int dump_recv_size = 0;

    u64 *dataptr;

    vAppDaemonDmaTaskStartupHook();
    xil_printf("INFO: Start Dma task\r\n");
    xDma2Send2pcSemaphore = xSemaphoreCreateBinary();

    while (1) {
        timeout_flag = 0;
        dump_recv_size = 0;
        DmaTaskState = DMATASK_READY;
        if (xSemaphoreTake(xCmdrcvd2DmaSemaphore, portMAX_DELAY)) {
            //        fee_status = HardwareTrigger_StartDeviceIdAllCh(0);
            for (u16 i = 0; i < 16; i++) {
                if (ch_config_array[i].enable == ENABLE) {
                    fee_status = HardwareTrigger_StartDeviceId(0, i);
                    if (fee_status != XST_SUCCESS) {
                        return fee_status;
                    }
                }
            }

        } else {
            xil_printf("INFO: Waiting Cmdrcvd is Timeout\r\n");
            break;
        }

        printf("INFO: Run start\r\n");
        while (fee_status == XST_SUCCESS) {
            if (dump_recv_size == 0) {
                XTime_GetTime(&start_time);
            }
            s2mm_dma_state = axidma_recv_buff();
            DmaTaskState = DMATASK_RUNNING;
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
                Xil_DCacheFlushRange((UINTPTR)dataptr, (MAX_TRIGGER_LEN * 2 + 4) * sizeof(u64));
                u8 read_trigger_length = (dataptr[0] >> (24 + 8)) & 0x00000FFF;
                u8 read_trigger_info = (dataptr[0] >> 24) & 0x000000FF;
                if ((read_trigger_info & 0xC0) == 0x80) {
                    // read_trigger_info = {TRIGGER_STATE[1:0], FRAME_BEGIN[0], FRAME_CONTINUE[0], TRIGGER_TYPE[3:0]}
                    // read_trigger_info & 8'b1100_0000 == 8'b1000_0000
                    // left: mask except frame_continure
                    // right: trigger state = 2'b10 (halt) and frame continue means frame generator fifo is full
                    // printData(dataptr, read_trigger_length + 3);
                    check_result = INTERNAL_BUFFER_FULL;
                } else {
                    check_result = XST_SUCCESS;
                }
                incr_wrptr_after_write(read_trigger_length + 4);
                dump_recv_size += (read_trigger_length + 3) * sizeof(u64);
                incr_rdptr_after_read(rcvd_frame_len * sizeof(u64));
                flush_ptr();
            }

            if (check_result == INTERNAL_BUFFER_FULL) {
                xil_printf("INFO: Internal buffer full detected. Stop fee.\r\n");
                fee_status = HardwareTrigger_StopDeviceIdAllCh(0);
                if (fee_status != XST_SUCCESS) {
                    xil_printf("ERROR: failed to stop fee\r\n");
                }
                break;
            }

            if (dump_recv_size > test_size) {
                xil_printf("INFO: reach target size\r\n");
                break;
            }
        }
        XTime_GetTime(&end_time);
        printf("INFO: Run end\r\n");

        double dma_time_sec = (end_time - start_time) / COUNTS_PER_SECOND;
        double rcvd_data_size_MB = dump_recv_size * 1E-6;
        double dma_speed_Mbps = rcvd_data_size_MB * 8 / dma_time_sec;
        printf("INFO: Rcvd %f MBytes @ %f Mbps\r\n", rcvd_data_size_MB, dma_speed_Mbps);

        if (getFeeState() == FEE_RUNNING) {
            if (HardwareTrigger_StopDeviceIdAllCh(0) != XST_SUCCESS) {
                xil_printf("ERROR: failed to stop fee. Recomend to reset fee.\r\n");
            }
        }
        DmaTaskState = DMATASK_END;
        xil_printf("INFO: Run end.\r\n");
        if (axidma_stopDma() != XST_SUCCESS) {
            xil_printf("ERROR: failed to stop dma.\r\n");
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
