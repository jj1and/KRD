/*
 * main.c
 *
 *  Created on: 2020/06/29
 *      Author: jj1and
 */
#include <stdio.h>

#include "FreeRTOS.h"
#include "axidma_manager.h"
#include "platform_config.h"
#include "task.h"
#include "timers.h"
#include "xgpio.h"
#include "xil_printf.h"
#include "xparameters.h"

#define TIMER_ID 1
#define DELAY_10_SECONDS 10000UL
#define DELAY_1_SECOND 1000UL
#define FAIL_CNT_THRESHOLD 5

// GPIO related constant
#define ACQUI_LEN_GPIO_DEVICE_ID XPAR_ACQUI_LEN_GPIO_DEVICE_ID
#define MODE_TRIGGER_LEN_GPIO_DEVICE_ID XPAR_MODE_TRIGGER_LEN_GPIO_DEVICE_ID
#define THRESHOLD_GPIO_DEVICE_ID XPAR_THRESHOLD_GPIO_DEVICE_ID

#define MODE_CH 1
#define MAX_TRIGGER_LENGTH_CH 2
#define MODE_BITWIDTH 3
#define MAX_TRIGGER_LENGTH_BITWIDTH 16

#define PRE_ACQUISITON_LEN_CH 1
#define POST_ACQUISITON_LEN_CH 2
#define PRE_ACQUISITON_LEN_BITWIDTH 2
#define POST_ACQUISITON_LEN_BITWIDTH 2

#define RISING_THRESHOLD_CH 1
#define FALLING_THRESHOLD_CH 2
#define RISING_THRESHOLD_BITWIDTH 16
#define FALLING_THRESHOLD_BITWIDTH 16

#define INTERNAL_ADC_BUFF_SIZE 2048 * 16
#define INTERNAL_HF_BUFF_DEPTH 256
#define EXTERNAL_FRAME_BUFF_SIZE 512 * 16
#define INTERNAL_BUFFER_FULL 3
#define LAST_FRAME 2

#define CONFIG_MODE 3            // 3'b011 {ACQUIRE_MODE, STOP, SET_CONFIG }
#define STOP_MODE 2              // 3'b001
#define COMBINED_ACQUIRE_MODE 4  // 3'b100
#define NORMAL_ACQUIRE_MODE 0    // 3'b000

#define H_GAIN_BASELINE 0
#define L_GAIN_BASELINE -2048
#define L_GAIN_CORRECTION 3

const u8 PRE_ACQUISITION_LENGTH = 1;
const u8 POST_ACQUISITION_LENGTH = 1;
const short int RISING_EDGE_THRESHOLD = 1024;
const short int FALLING_EDGE_THRESHOLD = 512;

TickType_t x10seconds = pdMS_TO_TICKS(DELAY_10_SECONDS);
TimerHandle_t xTimer = NULL;
XGpio Gpio_acqui_len;
XGpio Gpio_mode_trigger_len;
XGpio Gpio_threshold;

int GpioSetUp(XGpio *GpioInstPtr, u16 DeviceId);
int SetMode(u8 mode);
int SetMaxTriggerLength(u16 max_trigger_length);
int SetAcquisitionLength(u8 pre_acquisition_length, u8 post_acquisition_length);
int SetThreshold(short int rising_threshold, short int falling_threshold);

void prvDmaTask(void *pvParameters);
int vApplicationDaemonTxTaskStartupHook();
int vApplicationDaemonRxTaskStartupHook();
void vTimerCallback(TimerHandle_t pxTimer);

int main() {
    int Status;
    xil_printf("data_trigger test\r\n");

    XTime_StartTimer();
    Status = axidma_setup();
    if (Status != XST_SUCCESS)
        xil_printf("Failed to Setup AXI-DMA\r\n");

    Status = GpioSetUp(&Gpio_acqui_len, ACQUI_LEN_GPIO_DEVICE_ID);
    if (Status != XST_SUCCESS) {
        xil_printf("Failed to initialize Pre/Post acquision length GPIO\r\n");
        return XST_FAILURE;
    }

    Status = GpioSetUp(&Gpio_mode_trigger_len, MODE_TRIGGER_LEN_GPIO_DEVICE_ID);
    if (Status != XST_SUCCESS) {
        xil_printf("Failed to initialize State & Max trigger length GPIO\r\n");
        return XST_FAILURE;
    }

    Status = GpioSetUp(&Gpio_threshold, THRESHOLD_GPIO_DEVICE_ID);
    if (Status != XST_SUCCESS) {
        xil_printf("Failed to initialize Threshold setting GPIO\r\n");
        return XST_FAILURE;
    }

    Status = SetMode(CONFIG_MODE);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    Status = SetMaxTriggerLength(MAX_TRIGGER_LEN);
    Status = SetAcquisitionLength(PRE_ACQUISITION_LENGTH, POST_ACQUISITION_LENGTH);
    Status = SetThreshold(RISING_EDGE_THRESHOLD, FALLING_EDGE_THRESHOLD);

    Status = SetMode(NORMAL_ACQUIRE_MODE);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    xTaskCreate(prvDmaTask, (const char *)"AXIDMA transfer", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY, &xDmaTask);
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

int SetMode(u8 mode) {
    switch (mode) {
        case CONFIG_MODE:
            xil_printf("Config mode\r\n");
            break;
        case STOP_MODE:
            xil_printf("Stop mode\r\n");
            break;
        case COMBINED_ACQUIRE_MODE:
            xil_printf("Combined acquire mode\r\n");
            break;

        case NORMAL_ACQUIRE_MODE:
            xil_printf("Normal acquire mode\r\n");
            break;
        default:
            xil_printf("No matched mode %d\r\n", mode);
            return XST_INVALID_PARAM;
    }
    XGpio_DiscreteWrite(&Gpio_mode_trigger_len, MODE_CH, mode);
    return XST_SUCCESS;
}

int SetMaxTriggerLength(u16 max_trigger_length) {
    if (max_trigger_length <= 0) {
        xil_printf("Invalid Max Trigger Length: %d\r\n", max_trigger_length);
        return XST_INVALID_PARAM;
    } else {
        XGpio_DiscreteWrite(&Gpio_mode_trigger_len, MAX_TRIGGER_LENGTH_CH, max_trigger_length);
        xil_printf("Set Max Trigger Length: %d\r\n", max_trigger_length);
    }
    return XST_SUCCESS;
}

int SetAcquisitionLength(u8 pre_acquisition_length, u8 post_acquisition_length) {
    if (pre_acquisition_length <= 0) {
        xil_printf("Invalid pre acquisition length: %d\r\n", pre_acquisition_length);
        return XST_INVALID_PARAM;
    } else {
        XGpio_DiscreteWrite(&Gpio_acqui_len, PRE_ACQUISITON_LEN_CH, pre_acquisition_length);
        xil_printf("Set Max pre acquisition length: %d\r\n", pre_acquisition_length);
    }
    if (post_acquisition_length <= 0) {
        xil_printf("Invalid pre acquisition length: %d\r\n", post_acquisition_length);
        return XST_INVALID_PARAM;
    } else {
        XGpio_DiscreteWrite(&Gpio_acqui_len, POST_ACQUISITON_LEN_CH, post_acquisition_length);
        xil_printf("Set Max post acquisition length: %d\r\n", post_acquisition_length);
    }
    return XST_SUCCESS;
}

int SetThreshold(short int rising_threshold, short int falling_threshold) {
    if ((rising_threshold >= H_GAIN_BASELINE + 2047) | (rising_threshold <= H_GAIN_BASELINE - 2048)) {
        xil_printf("Invalid rising edge threshold: %d\r\n", rising_threshold);
        return XST_INVALID_PARAM;
    } else {
        XGpio_DiscreteWrite(&Gpio_threshold, RISING_THRESHOLD_CH, rising_threshold);
        xil_printf("Set rising edge threshold: %d\r\n", rising_threshold);
    }
    if ((falling_threshold > rising_threshold) | (falling_threshold <= H_GAIN_BASELINE - 2048)) {
        xil_printf("Invalid falling edge threshold: %d\r\n", rising_threshold);
        return XST_INVALID_PARAM;
    } else {
        XGpio_DiscreteWrite(&Gpio_threshold, FALLING_THRESHOLD_CH, falling_threshold);
        xil_printf("Set falling edge threshold: %d\r\n", falling_threshold);
    }
    return XST_SUCCESS;
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

int checkData(u64 *dataptr, int pre_time, int rise_time, int high_time, int fall_time, int post_time, int max_val, int baseline, u16 rise_thre, u16 fall_thre, int print_enable) {
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

    u16 *expected_sample;
    int expected_charge_sum = 0;
    int signal_length;
    int remain;
    int total_signal_length;
    int shift;
    int matched = 0;

    Xil_DCacheFlushRange((UINTPTR)dataptr, (MAX_TRIGGER_LEN * 2 + 3) * sizeof(u64));
    read_header_timestamp = (dataptr[0] & 0x00FFFFFF);
    read_trigger_info = (dataptr[0] >> 24) & 0x000000FF;
    read_trigger_length = (dataptr[0] >> (24 + 8)) & 0x00000FFF;
    read_header_id = (dataptr[0] >> (24 + 8 + 12 + 12)) & 0x000000FF;
    read_raw_charge_sum = (dataptr[1] >> 32) & 0x00FFFFFF;
    read_charge_sum = (read_raw_charge_sum << 8) >> 8;  // sign extention
    read_fall_thre = (dataptr[1] & 0x0000FFFF);
    read_rise_thre = (dataptr[1] >> 16) & 0x0000FFFF;
    incr_wrptr_after_write(read_trigger_length + 3);

    read_footer_id = (dataptr[read_trigger_length + 3 - 1] >> 56) & 0x000000FF;
    read_object_id = dataptr[read_trigger_length + 3 - 1] & 0xFFFFFFFF;
    read_footer_timestamp = (dataptr[read_trigger_length + 3 - 1] >> 8) & 0x00000FFFFFF000000;

    if (print_enable != 0) {
        printData(dataptr, read_trigger_length + 3);
    }
    xil_printf("Rcvd frame  signal_length:%4u, timestamp:%5u, trigger_info:%2x, falling_edge_threshold:%4d, rising_edge_threshold:%4d, object_id:%4u\r\n", read_trigger_length * 4, read_footer_timestamp + read_header_timestamp, read_trigger_info, read_fall_thre, read_rise_thre, read_object_id);

    if (read_object_id == 0) {
        // read_trigger_info = {1'b0, TRIGGER_STATE[1:0], FRAME_CONTINUE[0], TRIGGER_TYPE[3:0]}
        // read_trigger_info & 8'b0110_0000 == 8'b0010_0000
        // left: mask except trigger state
        // right: trigger state must be 2'b01 at first frame
        if ((read_trigger_info & 0x60) != 0x20) {
            xil_printf("trigger_info mismatch Data: %2x Expected: %2x\r\n", read_trigger_info & 0x60, 0x20);
            Status = XST_FAILURE;
        } else if ((read_trigger_info & 0x10) == 0x00) {
            // read_trigger_info = {1'b0, TRIGGER_STATE[1:0], FRAME_CONTINUE[0], TRIGGER_TYPE[3:0]}
            // read_trigger_info & 8'b0001_0000 == 8'b0000_0000
            // left: mask except frame_continure
            // right: trigger state = 2'b10 (halt) and frame continue means frame generator fifo is full
            xil_printf("trigger_info indicates this is last frame\r\n", read_trigger_info);
            Status = LAST_FRAME;
        }

    } else {
        // read_trigger_info = {1'b0, TRIGGER_STATE[1:0], FRAME_CONTINUE[0], TRIGGER_TYPE[3:0]}
        // read_trigger_info & 8'b0111_0000 == 8'b0101_0000
        // left: mask except trigger state and frame_continue
        // right: trigger state = 2'b10 (halt) and frame continue means frame generator fifo is full
        if ((read_trigger_info & 0x70) == 0x50) {
            xil_printf("trigger_info indicates dataframe_generator internal buffer is full: %2x\r\n", read_trigger_info);
            Status = INTERNAL_BUFFER_FULL;
        } else if ((read_trigger_info & 0x10) == 0x00) {
            // read_trigger_info = {1'b0, TRIGGER_STATE[1:0], FRAME_CONTINUE[0], TRIGGER_TYPE[3:0]}
            // read_trigger_info & 8'b0001_0000 == 8'b0000_0000
            // left: mask except frame_continure
            // right: trigger state = 2'b10 (halt) and frame continue means frame generator fifo is full
            xil_printf("trigger_info indicates this is last frame\r\n", read_trigger_info);
            Status = LAST_FRAME;
        }
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

    // ---------------------------- matching read samples and send samples ----------------------------
    signal_length = pre_time + rise_time + high_time + fall_time + post_time;
    remain = signal_length % 8;
    total_signal_length = signal_length + remain;
    expected_sample = (u16 *)malloc(total_signal_length);
    u64 tmp_expected_data = 0;
    short int tmp_expected_sample_sum;
    short int tmp_expected_l_gain_bl_subtracted;
    if (expected_sample == NULL) {
        xil_printf("Failed to allocate memory for preparing expected_samples\r\n");
        return XST_FAILURE;
    }

    // assign sent data to expected_sample
    if (generate_signal(expected_sample, pre_time, rise_time, high_time, fall_time, post_time, max_val, baseline, 0) == XST_FAILURE) {
        return XST_FAILURE;
    }

    //matching expected and read
    for (int i = 0; i <= ((total_signal_length / 4) - read_trigger_length); i++) {
        xil_printf("\nShift[%d]\r\n", i);
        matched = 1;
        for (int j = 0; j < read_trigger_length; j++) {
            tmp_expected_data = 0;
            if ((dataptr[j + 2] & 0xFFFF000000000000) == 0xCC00000000000000) {
                tmp_expected_data = 0xCC00000000000000;

                tmp_expected_sample_sum = ((short int)expected_sample[(i + j) * 4 + 2] >> 4) + ((short int)expected_sample[(i + j) * 4 + 3] >> 4);
                tmp_expected_data = tmp_expected_data | (u64)(tmp_expected_sample_sum >> 1 & 0x000000000000FFFF) << 32;

                tmp_expected_sample_sum = ((short int)expected_sample[(i + j) * 4 + 1] >> 4) + ((short int)expected_sample[(i + j) * 4 + 0] >> 4);
                tmp_expected_data = tmp_expected_data | (u64)(tmp_expected_sample_sum >> 1 & 0x000000000000FFFF) << 16;

                tmp_expected_l_gain_bl_subtracted = ((short int)expected_sample[(i + j) * 4] >> (L_GAIN_CORRECTION + 4)) - (short int)L_GAIN_BASELINE;
                tmp_expected_data = tmp_expected_data | (u64)(tmp_expected_l_gain_bl_subtracted & 0x000000000000FFFF);
                //debug
                // xil_printf("expected combined data[%d] %016llx\r\n", j, tmp_expected_data);
            } else {
                for (int k = 0; k < 4; k++) {
                    tmp_expected_data = tmp_expected_data | (u64)((short int)expected_sample[(i + j) * 4 + k] >> 4 & 0x000000000000FFFF) << (k * 16);
                    //debug
                    // xil_printf("expected sample[%d] %04x\r\n", (i + j) * 4 + k, expected_sample[(i + j) * 4 + k] >> 4);
                }
            }
            // debug
            xil_printf("Expected[%d] %016llx : Read[%d] %016llx\r\n", j, tmp_expected_data, j, dataptr[j + 2]);

            if (dataptr[j + 2] == tmp_expected_data) {
                matched = matched * 1;
            } else {
                matched = 0;
                xil_printf("mismatch data found. increment shift\r\n");
                break;
            }
        }
        if (matched == 1) {
            // debug
            xil_printf("expected data matched with read samples\r\n");
            shift = i * 4;
            break;
        }
    }
    // if any sequence doesn't match with read data -> Status failed
    if (matched == 0) {
        xil_printf("Any sequence in send data doesn't match with read samples\r\n");
        Status = XST_FAILURE;
    }

    for (int i = 0; i < read_trigger_length * 4; i++) {
        expected_charge_sum += (short int)expected_sample[i + shift] >> 4;
        // debug
        // if ((i + 1) % 8 == 0) {
        //     xil_printf("%4x\r\n", (short int)expected_sample[i + shift] >> 4);
        // } else {
        //     xil_printf("%04x ", (short int)expected_sample[i + shift] >> 4);
        // }
    }
    if (read_charge_sum != expected_charge_sum) {
        xil_printf("charge_sim mismatch Data:%d Expected:%d\r\n", read_charge_sum, expected_charge_sum);
        Status = XST_FAILURE;
    }

    free(expected_sample);
    // ---------------------------- ---------------------------- ----------------------------

    if (read_footer_id != 0x55) {
        xil_printf("FOOTER_ID mismatch Data: %2x Expected: %2x\r\n", read_footer_id, 0x55);
        Status = XST_FAILURE;
    }

    decr_wrptr_after_read(read_trigger_length + 3);
    xil_printf("\n");
    return Status;
}

void prvDmaTask(void *pvParameters) {
    int mm2s_dma_state = XST_SUCCESS;
    int s2mm_dma_state = XST_SUCCESS;
    int test_result = LAST_FRAME;

    int pre_time = (PRE_ACQUISITION_LENGTH + 1) * 8;
    int rise_time = 8;
    int high_time = 16;
    int fall_time = 32;
    int post_time = (POST_ACQUISITION_LENGTH + 1) * 8;

    int signal_length;
    int remain;

    int test_max_val = 2050;
    int max_val = 2040;
    int baseline = -100;

    u64 *dataptr;
    if (InitIntrController(&xInterruptController) != XST_SUCCESS) {
        xil_printf("Failed to setup interrupt controller.\r\n");
    }

    vApplicationDaemonRxTaskStartupHook();
    vApplicationDaemonTxTaskStartupHook();

    xil_printf("sequential sending test\r\n");
    while (TRUE) {
        s2mm_dma_state = axidma_recv_buff();
        if (s2mm_dma_state == XST_SUCCESS) {
            if (test_result == LAST_FRAME) {
                mm2s_dma_state = axidma_send_buff(pre_time, rise_time, high_time, fall_time, post_time, max_val, baseline, 1);
                if (mm2s_dma_state != XST_SUCCESS) {
                    xil_printf("MM2S Dma failed. \r\n");
                    break;
                }
                while (!TxDone && !Error) {
                    /* code */
                }
                if (!Error) {
                    signal_length = pre_time + rise_time + high_time + fall_time + post_time;
                    remain = signal_length % 8;
                    xil_printf("Send frame  Signal length:%4d, Max:%4d, Min:%4d\r\n\n", signal_length + remain, max_val, baseline);
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
        } else if (buff_will_be_full(MAX_PKT_LEN / sizeof(u64))) {
            xil_printf("S2MM Dma buffer is full. \r\n");
        } else {
            xil_printf("S2MM Dma failed beacuse of internal error. \r\n");
            break;
        }

        if ((s2mm_dma_state == XST_SUCCESS) || buff_will_be_full(MAX_PKT_LEN / sizeof(u64))) {
            dataptr = get_wrptr();
            test_result = checkData(dataptr, pre_time, rise_time, high_time, fall_time, post_time, max_val, baseline, RISING_EDGE_THRESHOLD, FALLING_EDGE_THRESHOLD, 1);
            if (test_result == XST_FAILURE) {
                break;
            }
            max_val++;
        }

        if (max_val > test_max_val && test_result == LAST_FRAME) {
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
