/*
 * main.c
 *
 *  Created on: 2020/06/29
 *      Author: jj1and
 */
#include <stdio.h>

#include "FreeRTOS.h"
#include "hardware_trigger_manager.h"
#include "intr_manager.h"
#include "lwip/sockets.h"
#include "lwipopts.h"
#include "netif/xadapter.h"
#include "peripheral_manager.h"
#include "platform_config.h"
#include "rfdc_manager.h"
#include "task.h"
#include "xil_printf.h"
#include "xparameters.h"

#define CMDRECV_PORT 5002
#define RECV_BUF_SIZE 2048
#define THREAD_STACKSIZE 1024

#define TYPE_SIZE 0
#define TYPE_TIME 1

#define TIMER_ID 1
#define DELAY_10_SECONDS 10000UL
#define DELAY_1_SECOND 1000UL

#define MODE_SWITCH_UPPER_THRE 2047
#define MODE_SWITCH_LOWER_THRE -2048

#define H_GAIN_BASELINE 0
#define L_GAIN_BASELINE 0

#define RISING_EDGE_THRESHOLD 128
#define FALLING_EDGE_THRESHOLD 0

#define PRE_ACQUISITION_LENGTH 2
#define POST_ACQUISITION_LENGTH 1

extern TaskHandle_t cleanup_thread;
extern TaskHandle_t cmd_thread;
extern TaskHandle_t xPeripheralSetupTask;
extern TaskHandle_t xFeeCtrlTask;
extern TaskHandle_t xResetTask;

extern SemaphoreHandle_t xCmdrcvd2FeeCtrlSemaphore;
extern SemaphoreHandle_t xALL2ResetTaskSemaphore;
extern SemaphoreHandle_t xResetTask2ALLFeeCtrlSemaphore;

extern TriggerManager_Config fee;

const TickType_t x1seconds = pdMS_TO_TICKS(DELAY_1_SECOND);
const TickType_t x10seconds = pdMS_TO_TICKS(DELAY_10_SECONDS);

const double refClkFreq_MHz = 250.00;
const double ADC_samplingRate_Msps = 2000.0;

#define TRY_TIMES 10

const int RFDC_ADC_TILES[4] = {0, 1, 2, 3};
// const int RFDC_DAC_TILES[1] = {0};

AvailableAdcTiles AdcTile = {
    4,
    RFDC_ADC_TILES};

// AvailableDacTiles DacTile = {
//     0,
//     RFDC_DAC_TILES};

static unsigned long long test_size = 256000000;
static unsigned long test_time = 120;
static int test_type = TYPE_SIZE;

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

static Ladc_Config LadcConfig;
static u16 baseline = 0x233;

struct netif myself_netif;
static struct sockaddr_in myself, remote;
static int sock, sd, size, n;
static char mesgbuff[2048];

XGpio SizeGpio;
XGpio TimeGpio;

void network_thread(void *arg);
void cmdrecv_application_thread(void *pvParameters);
void prvFeeCtrlTask(void *pvParameters);
void prvResetTask(void *pvParameters);
void cleanup_tasks(void *pvParameters);
void resetFEE();
int vAppDaemonPeripheralStartupHook();

static void print_ip(char *msg, ip_addr_t *ip) {
    xil_printf(msg);
    xil_printf("%d.%d.%d.%d\n\r", ip4_addr1(ip), ip4_addr2(ip), ip4_addr3(ip), ip4_addr4(ip));
}

static void print_ip_settings(ip_addr_t *ip, ip_addr_t *mask, ip_addr_t *gw) {
    print_ip("Board IP: ", ip);
    print_ip("Netmask : ", mask);
    print_ip("Gateway : ", gw);
}

static void flush_buff(char *buff) {
    for (size_t i = 0; i < RECV_BUF_SIZE; i++) {
        buff[i] = 'f';
    }
}

int main() {
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
    xTaskCreate(prvFeeCtrlTask, (const char *)"FEE Ctrl", THREAD_STACKSIZE, NULL, DEFAULT_THREAD_PRIO, &xFeeCtrlTask);
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
    vTaskDelete(xFeeCtrlTask);
    vTaskDelete(xResetTask);
    vTaskDelete(cmd_thread);
    vTaskDelete(NULL);
    exit(0);
    return;
}

void prvResetTask(void *pvParameters) {
    while (1) {
        if (xSemaphoreTake(xALL2ResetTaskSemaphore, portMAX_DELAY)) {
            printf("INFO: reset fee\r\n");
            GPO_TriggerReset();
            sleep(1);
            rfdcADC_MTS_setup(RFDC_DEVICE_ID, refClkFreq_MHz, ADC_samplingRate_Msps, AdcTile);
            SetSwitchThreshold(MODE_SWITCH_UPPER_THRE, MODE_SWITCH_LOWER_THRE);
            HardwareTrigger_SetupDeviceId(0, &fee);
        }
        xSemaphoreGive(xResetTask2ALLFeeCtrlSemaphore);
        portYIELD();
    }
}

void cmdrecv_application_thread(void *pvParameters) {
    int status;
    int quit_flag = 0;
    char recv_buf[RECV_BUF_SIZE];

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

    test_size = 256000000;
    baseline = 0x233;
    LadcConfig.TestPattern1 = DEFAULT_LADC_TPN1;
    LadcConfig.TestPattern2 = DEFAULT_LADC_TPN2;
    LadcConfig.OperationMode = LADC_DOUBLETPNMODE;

    xCmdrcvd2FeeCtrlSemaphore = xSemaphoreCreateBinary();
    xALL2ResetTaskSemaphore = xSemaphoreCreateBinary();
    xResetTask2ALLFeeCtrlSemaphore = xSemaphoreCreateBinary();
    xTaskCreate(prvResetTask, (const char *)"FEE Reset", THREAD_STACKSIZE, NULL, DEFAULT_THREAD_PRIO, &xResetTask);
    xSemaphoreGive(xALL2ResetTaskSemaphore);
    if (xSemaphoreTake(xResetTask2ALLFeeCtrlSemaphore, portMAX_DELAY)) {
        xil_printf("INFO: reset FEE done.");
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
                        sprintf(mesgbuff, "test_size       : total size of receiveing data\r\n");
                        write(sd, mesgbuff, strlen(mesgbuff));
                        sprintf(mesgbuff, "test_time       : total time of test\r\n");
                        write(sd, mesgbuff, strlen(mesgbuff));
                        sprintf(mesgbuff, "test_type       : type of test\r\n");
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
                    } else if (!strncmp(recv_buf, "test_type", 9)) {
                        sprintf(mesgbuff, "INFO: Enter type of test (size or time).\r\n");
                        xil_printf(mesgbuff);
                        write(sd, mesgbuff, strlen(mesgbuff));
                        if ((n = read(sd, recv_buf, RECV_BUF_SIZE)) < 0) {
                            xil_printf("%s: error reading from socket %d, closing socket\r\n", __FUNCTION__, sd);
                            break;
                        }
                        if (!strncmp(recv_buf, "size", 4)) {
                            test_type = TYPE_SIZE;
                            sprintf(mesgbuff, "INFO: set test type as size.\r\n");
                            write(sd, mesgbuff, strlen(mesgbuff));
                        } else if (!strncmp(recv_buf, "time", 4)) {
                            test_type = TYPE_TIME;
                            sprintf(mesgbuff, "INFO: set test type as time.\r\n");
                            write(sd, mesgbuff, strlen(mesgbuff));
                        } else {
                            sprintf(mesgbuff, "INFO: unknown type\r\n");
                            write(sd, mesgbuff, strlen(mesgbuff));
                        }
                    } else if (!strncmp(recv_buf, "test_size", 9)) {
                        sprintf(mesgbuff, "INFO: Enter total test data size (unit is Byte).\r\n");
                        xil_printf(mesgbuff);
                        write(sd, mesgbuff, strlen(mesgbuff));
                        if ((n = read(sd, recv_buf, RECV_BUF_SIZE)) < 0) {
                            xil_printf("%s: error reading from socket %d, closing socket\r\n", __FUNCTION__, sd);
                            break;
                        }
                        test_size = strtoull(recv_buf, NULL, 10);
                        sprintf(mesgbuff, "INFO: set test data size as %llu Byte.\r\n", test_size);
                        write(sd, mesgbuff, strlen(mesgbuff));
                    } else if (!strncmp(recv_buf, "test_time", 9)) {
                        sprintf(mesgbuff, "INFO: Enter total test time (unit is sec).\r\n");
                        xil_printf(mesgbuff);
                        write(sd, mesgbuff, strlen(mesgbuff));
                        if ((n = read(sd, recv_buf, RECV_BUF_SIZE)) < 0) {
                            xil_printf("%s: error reading from socket %d, closing socket\r\n", __FUNCTION__, sd);
                            break;
                        }
                        test_time = strtoul(recv_buf, NULL, 10);
                        sprintf(mesgbuff, "INFO: set test time as %lu sec.\r\n", test_time);
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

                        xSemaphoreGive(xCmdrcvd2FeeCtrlSemaphore);
                        vTaskSuspend(NULL);
                    } else if (!strncmp(recv_buf, "reset", 5)) {
                        xSemaphoreGive(xALL2ResetTaskSemaphore);
                        if (xSemaphoreTake(xResetTask2ALLFeeCtrlSemaphore, portMAX_DELAY)) {
                            sprintf(mesgbuff, "INFO: reset FEE done.\r\n");
                            print(mesgbuff);
                            write(sd, mesgbuff, strlen(mesgbuff));
                        }
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

void prvFeeCtrlTask(void *pvParameters) {
    int fee_status;
    u64 dump_recv_size[TRY_TIMES];
    double passed_time;
    int passed_10min_times = 0;
    u64 other_info;
    u8 full_flag = 0;
    u32 hit_count = 0;
    u64 time_since_start[TRY_TIMES];
    u64 time_since_start_MSB = 0;
    u64 time_since_start_LSB = 0;

    xil_printf("INFO: Start FEE Ctrl task\r\n");

    while (1) {
        if (xSemaphoreTake(xCmdrcvd2FeeCtrlSemaphore, portMAX_DELAY)) {
            sprintf(mesgbuff, "INFO: Test start\r\n");
            printf(mesgbuff);
            write(sd, mesgbuff, strlen(mesgbuff));
        } else {
            sprintf(mesgbuff, "INFO: Waiting Cmdrcvd is Timeout\r\n");
            printf(mesgbuff);
            write(sd, mesgbuff, strlen(mesgbuff));
            break;
        }

        fee_status = XGpio_Initialize(&SizeGpio, XPAR_DUMMY_RECEIVER_BLOCK_AXI_GPIO_1_DEVICE_ID);
        if (fee_status != XST_SUCCESS) {
            sprintf(mesgbuff, "ERROR: Failed to dummy_receiver Size GPIO\r\n");
            printf(mesgbuff);
            write(sd, mesgbuff, strlen(mesgbuff));
            return;
        }
        XGpio_SetDataDirection(&SizeGpio, 1, 0x1);
        XGpio_SetDataDirection(&SizeGpio, 2, 0x1);

        fee_status = XGpio_Initialize(&TimeGpio, XPAR_DUMMY_RECEIVER_BLOCK_AXI_GPIO_2_DEVICE_ID);
        if (fee_status != XST_SUCCESS) {
            sprintf(mesgbuff, "ERROR: Failed to dummy_receiver Time GPIO\r\n");
            printf(mesgbuff);
            write(sd, mesgbuff, strlen(mesgbuff));
            return;
        }
        XGpio_SetDataDirection(&TimeGpio, 1, 0x1);
        XGpio_SetDataDirection(&TimeGpio, 2, 0x1);

        for (size_t i = 0; i < TRY_TIMES; i++) {
            xSemaphoreGive(xALL2ResetTaskSemaphore);
            if (xSemaphoreTake(xResetTask2ALLFeeCtrlSemaphore, portMAX_DELAY)) {
                sprintf(mesgbuff, "INFO: reset FEE done.\r\n");
                print(mesgbuff);
                write(sd, mesgbuff, strlen(mesgbuff));
            }
            dump_recv_size[i] = 0;
            passed_time = 0;
            passed_10min_times = 0;
            time_since_start[i] = 0;
            sprintf(mesgbuff, "INFO: Run[%d] start\r\n", i);
            printf(mesgbuff);
            write(sd, mesgbuff, strlen(mesgbuff));
            //        fee_status = HardwareTrigger_StartDeviceIdAllCh(0);
            for (u16 i = 0; i < 16; i++) {
                if (ch_config_array[i].enable == ENABLE) {
                    fee_status = HardwareTrigger_StartDeviceId(0, i);
                    if (fee_status != XST_SUCCESS) {
                        sprintf(mesgbuff, "ERROR: Failed to start FEE\r\n");
                        printf(mesgbuff);
                        write(sd, mesgbuff, strlen(mesgbuff));
                        return;
                    }
                }
            }

            if (test_type == TYPE_TIME) {
                while ((passed_time < (double)test_time) && (full_flag == 0)) {
                    dump_recv_size[i] = ((u64)XGpio_DiscreteRead(&SizeGpio, 2)) * 8;
                    other_info = XGpio_DiscreteRead(&SizeGpio, 1);
                    hit_count = (other_info >> 1) & 0x7FFFFFFF;
                    full_flag = (other_info & 0x1);

                    time_since_start_LSB = (u64)XGpio_DiscreteRead(&TimeGpio, 1);
                    time_since_start_MSB = (u64)XGpio_DiscreteRead(&TimeGpio, 2);
                    time_since_start[i] = ((time_since_start_MSB << 32) & 0xFFFF00000000) | (time_since_start_LSB & 0xFFFFFFFF);

                    passed_time = time_since_start[i] * 5 * 1E-9;
                    if ((int)(passed_time / 600) > passed_10min_times) {
                        sprintf(mesgbuff, "INFO: %d minutes passed. Received %.2f MBytes\r\n", (int)(passed_time / 60), (double)(dump_recv_size[i] * 1E-6));
                        printf(mesgbuff);
                        write(sd, mesgbuff, strlen(mesgbuff));
                        passed_10min_times = (int)(passed_time / 600);
                    }
                }
            } else {
                while ((dump_recv_size[i] < test_size) && (full_flag == 0)) {
                    dump_recv_size[i] = ((u64)XGpio_DiscreteRead(&SizeGpio, 2)) * 8;
                    other_info = XGpio_DiscreteRead(&SizeGpio, 1);
                    hit_count = (other_info >> 1) & 0x7FFFFFFF;
                    full_flag = (other_info & 0x1);

                    time_since_start_LSB = (u64)XGpio_DiscreteRead(&TimeGpio, 1);
                    time_since_start_MSB = (u64)XGpio_DiscreteRead(&TimeGpio, 2);
                    time_since_start[i] = ((time_since_start_MSB << 32) & 0xFFFF00000000) | (time_since_start_LSB & 0xFFFFFFFF);
                }
            }
            if (full_flag != 0) {
                sprintf(mesgbuff, "INFO: Full flag detected.\r\n");
                printf(mesgbuff);
                write(sd, mesgbuff, strlen(mesgbuff));
                full_flag = 0;
            }
            if (getFeeState() == FEE_RUNNING) {
                if (HardwareTrigger_StopDeviceIdAllCh(0) != XST_SUCCESS) {
                    sprintf(mesgbuff, "ERROR: failed to stop fee. Recomend to reset fee.\r\n");
                    printf(mesgbuff);
                    write(sd, mesgbuff, strlen(mesgbuff));
                }
            }
            sprintf(mesgbuff, "INFO: Run[%d] end.\r\n", i);
            printf(mesgbuff);
            write(sd, mesgbuff, strlen(mesgbuff));
        }

        for (size_t i = 0; i < TRY_TIMES; i++) {
            double rcvd_time_sec = time_since_start[i] * 5 * 1E-9;
            double rcvd_data_size_MB = dump_recv_size[i] * 1E-6;
            double read_speed_Mbps = rcvd_data_size_MB * 8 / rcvd_time_sec;
            sprintf(mesgbuff, "INFO: Run[%d]: Rcvd %f MBytes for %f sec -> %f Mbps\r\n", i, rcvd_data_size_MB, rcvd_time_sec, read_speed_Mbps);
            printf(mesgbuff);
            write(sd, mesgbuff, strlen(mesgbuff));
        }

        vTaskResume(cmd_thread);
    }

    return;
}
