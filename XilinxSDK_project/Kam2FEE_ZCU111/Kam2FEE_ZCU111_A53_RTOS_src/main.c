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
// #include "peripheral_manager.h"
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

#define MODE_SWITCH_UPPER_THRE 2047
#define MODE_SWITCH_LOWER_THRE -2048

#define H_GAIN_BASELINE 0
#define L_GAIN_BASELINE 0

#define RISING_EDGE_THRESHOLD 128
#define FALLING_EDGE_THRESHOLD 0

#define PRE_ACQUISITION_LENGTH 2
#define POST_ACQUISITION_LENGTH 1
#define SEND_BUF_SIZE (TCP_SND_BUF - MAX_PKT_LEN)

const Channel_Config channel_0 = {0, NORMAL_ACQUIRE_MODE, HARDWARE_TRIGGER, -256, FALLING_EDGE_THRESHOLD, PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH, H_GAIN_BASELINE, L_GAIN_BASELINE};
const Channel_Config channel_1 = {1, NORMAL_ACQUIRE_MODE, HARDWARE_TRIGGER, -256, FALLING_EDGE_THRESHOLD, PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH, H_GAIN_BASELINE, L_GAIN_BASELINE};
const Channel_Config channel_2 = {2, NORMAL_ACQUIRE_MODE, HARDWARE_TRIGGER, -256, FALLING_EDGE_THRESHOLD, PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH, H_GAIN_BASELINE, L_GAIN_BASELINE};

const TickType_t x1seconds = pdMS_TO_TICKS(DELAY_1_SECOND);
const TickType_t x10seconds = pdMS_TO_TICKS(DELAY_10_SECONDS);

const int RFDC_ADC_TILES[4] = {0, 1, 2, 3};
const int RFDC_DAC_TILES[1] = {0};

AvailableAdcTiles AdcTile = {
    4,
    RFDC_ADC_TILES};

AvailableDacTiles DacTile = {
    1,
    RFDC_DAC_TILES};

const int RFDC_DEBUG_ADC_TILES[1] = {0};
AvailableAdcTiles DebugAdcTile = {
    1,
    RFDC_DEBUG_ADC_TILES};

void network_thread(void *arg);

// void prvPeripheralSetupTask(void *pvParameters);
// int vAppDaemonPeripheralSetupTaskStartupHook();

void prvDmaTask(void *pvParameters);
int vAppDaemonDmaTaskStartupHook();

int main() {
    // LadcConfig.TestPattern1 = DEFAULT_LADC_TPN1;
    // LadcConfig.TestPattern2 = DEFAULT_LADC_TPN2;
    // LadcConfig.OperationMode = LADC_DOUBLETPNMODE;

    ch_config_array[0] = channel_0;
    ch_config_array[1] = channel_1;
    ch_config_array[2] = channel_2;
    fee.ChannelNum = 3;
    fee.ChanelConfigs = ch_config_array;
    fee.MaxTriggerLength = MAX_TRIGGER_LEN;

    send2pc_setting.port = 5001;
    send2pc_setting.server_address = "192.168.1.2";
    send2pc_setting.xTicksToWait = x10seconds;

    int Status;
    xil_printf("INFO: MoGURA2 Prototype TED Board debug\r\n");
    // Status = peripheral_setup();
    // if (Status != XST_SUCCESS) return XST_FAILURE;

    double refClkFreq_MHz = 250.00;
    double ADC_samplingRate_Msps = 2000.0;
    Status = rfdcADC_MTS_setup(RFDC_DEVICE_ID, refClkFreq_MHz, ADC_samplingRate_Msps, DebugAdcTile);
    if (Status != XST_SUCCESS) {
        xil_printf("ERROR: Failed to setup RF Data Converter ADC\r\n");
        return XST_FAILURE;
    }
    //    Status = rfdcSingle_setup(RFDC_DEVICE_ID, XRFDC_ADC_TILE, 0, refClkFreq_MHz, ADC_samplingRate_Msps);
    //    if (Status != XST_SUCCESS) {
    //        xil_printf("ERROR: Failed to setup RF Data Converter ADC in single\r\n");
    //        return XST_FAILURE;
    //    }

    //    double DAC_samplingRate_Msps = 983.04;
    //    Status = rfdcDAC_MTS_setup(RFDC_DEVICE_ID, refClkFreq_MHz, DAC_samplingRate_Msps, DacTile);
    //    Status = rfdcSingle_setup(RFDC_DEVICE_ID, XRFDC_DAC_TILE, 0, refClkFreq_MHz, DAC_samplingRate_Msps);
    //    if (Status != XST_SUCCESS) {
    //        xil_printf("ERROR: Failed to setup RF Data Converter DAC\r\n");
    //        return XST_FAILURE;
    //    }

    Status = SetSwitchThreshold(MODE_SWITCH_UPPER_THRE, MODE_SWITCH_LOWER_THRE);

    Status = HardwareTrigger_SetupDeviceId(0, fee);

    Status = axidma_setup();
    if (Status != XST_SUCCESS) xil_printf("ERROR: Failed to Setup AXI-DMA\r\n");

    // xTaskCreate(prvPeripheralSetupTask, (const char *)"Peripheral Setup", configMINIMAL_STACK_SIZE, NULL, DEFAULT_THREAD_PRIO + 2, &xPeripheralSetupTask);
    xTaskCreate(prvDmaTask, (const char *)"AXIDMA transfer", configMINIMAL_STACK_SIZE, NULL, DEFAULT_THREAD_PRIO + 1, &xDmaTask);
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
    sys_thread_new("xemacif_input_thread", (void (*)(void *))xemacif_input_thread, netif, THREAD_STACKSIZE, DEFAULT_THREAD_PRIO);
    app_thread = sys_thread_new("send2pcd", send2pc_application_thread, arg, THREAD_STACKSIZE, DEFAULT_THREAD_PRIO);
    vTaskDelete(NULL);
    return;
}

// void prvPeripheralSetupTask(void *pvParameters) {
//     int Status;
//     vAppDaemonPeripheralSetupTaskStartupHook();

//     Status = XSpi_SetOptions(&SpiBaseDac, XSP_MASTER_OPTION | XSP_MANUAL_SSELECT_OPTION);
//     if (Status != XST_SUCCESS) return;
//     Status = XSpi_SetSlaveSelect(&SpiBaseDac, 1);
//     if (Status != XST_SUCCESS) return;
//     XSpi_Start(&SpiBaseDac);

//     Status = XSpi_SetOptions(&SpiLadc, XSP_MASTER_OPTION | XSP_MANUAL_SSELECT_OPTION);
//     if (Status != XST_SUCCESS) return;
//     Status = XSpi_SetSlaveSelect(&SpiLadc, 1);
//     if (Status != XST_SUCCESS) return;
//     XSpi_Start(&SpiLadc);

//     Status = BaselineDAC_ApplyConfig((u16)0x233);
//     if (Status != XST_SUCCESS) return;

//     Status = LADC_ApplyConfig();
//     if (Status != XST_SUCCESS) return;

//     DisableIntrSystem(&xInterruptController, SPI_BASEDAC_INTR);
//     DisableIntrSystem(&xInterruptController, SPI_LADC_INTR);
//     vTaskDelete(NULL);
//     return;
// }

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
    xil_printf("INFO: Waiting Send2PC task start\r\n");
    vTaskSuspend(NULL);

    xil_printf("INFO: Run start\r\n");
    fee_status = HardwareTrigger_StartDeviceId(0);

    while (fee_status == XST_SUCCESS) {
        s2mm_dma_state = axidma_recv_buff();
        if (s2mm_dma_state == XST_SUCCESS) {
            if (ulTaskNotifyTake(pdTRUE, 10 * x1seconds)) {
                if (Error) {
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

        //        if (send_frame_count > test_send_frame_count && check_result == LAST_FRAME) {
        //            xil_printf("Total recieved frame count reached the target number!\r\n");
        //            break;
        //        }

        if ((dump_recv_size > SEND_BUF_SIZE)) {
            dump_recv_size = 0;
            xTaskNotifyGive(app_thread);
            vTaskSuspend(NULL);
        }

        if ((getSend2pcTaskStauts() == SOCKET_CLOSE) || (timeout_flag == 1) || (check_result == INTERNAL_BUFFER_FULL)) {
            break;
        }
    }

    shutdown_dma();
    dump_recv_size = 0;
    xTaskNotifyGive(app_thread);
    vTaskSuspend(NULL);

    xil_printf("INFO: FEE shutdown.\r\n");
    fee_status = HardwareTrigger_StopDeviceId(0);
    vTaskDelete(NULL);
    return;
}

// int vAppDaemonPeripheralSetupTaskStartupHook() {
//     int Status;
//     xil_printf("\nINFO: Set up AXI Quad SPI Controller Interrupt systems\n");
//     Status = SetupSpiIntrSystem(&xInterruptController, &SpiBaseDac, SPI_BASEDAC_INTR);
//     if (Status != XST_SUCCESS) {
//         xil_printf("ERROR: Failed to set up Baseline DAC AXI Quad SPI Controller Interrupt system\r\n");
//         return XST_FAILURE;
//     }

//     Status = SetupSpiIntrSystem(&xInterruptController, &SpiLadc, SPI_LADC_INTR);
//     if (Status != XST_SUCCESS) {
//         xil_printf("ERROR: Failed to set up LADC AXI Quad SPI Controller Interrupt system\r\n");
//         return XST_FAILURE;
//     }
//     return XST_SUCCESS;
// }

int vAppDaemonDmaTaskStartupHook() {
    int Status;
    xil_printf("\nINFO: Set up AXIDMA Rx Interrupt system\n");
    Status = SetupRxIntrSystem(&xInterruptController, &AxiDma, RX_INTR_ID);
    if (Status != XST_SUCCESS) {
        xil_printf("ERROR: Failed to set up AXIDMA Rx Interrupt system\r\n");
        return XST_FAILURE;
    }
    return XST_SUCCESS;
}
