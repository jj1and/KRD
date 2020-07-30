/*
 * main.c
 *
 *  Created on: 2020/06/29
 *      Author: jj1and
 */
#include <stdio.h>

#include "FreeRTOS.h"
#include "platform_config.h"
#include "rfdc_manager.h"
#include "task.h"
#include "timers.h"
#include "xil_printf.h"
#include "xparameters.h"

#define TIMER_ID 1
#define DELAY_10_SECONDS 10000UL
#define DELAY_1_SECOND 1000UL

static TickType_t x10seconds = pdMS_TO_TICKS(DELAY_10_SECONDS);
static TimerHandle_t xTimer = NULL;
static TaskHandle_t xRFdcSetupTask;

static void prvRFdcSetupTask(void *pvParameters);
static void vTimerCallback(TimerHandle_t pxTimer);

int main() {
    int Status;
    xil_printf("RF Data Converter Latency Check\r\n");

    xTaskCreate(prvRFdcSetupTask,               /* The function that implements the task. */
                (const char *)"RFdc_MTS_setup", /* Text name for the task, provided to assist debugging only. */
                512,                            /* The stack allocated to the task. */
                NULL,                           /* The task parameter is not used, so set to NULL. */
                tskIDLE_PRIORITY,               /* The task runs at the idle priority. */
                &xRFdcSetupTask);

    xTimer = xTimerCreate((const char *)"Timer", 3 * x10seconds, pdFALSE, (void *)TIMER_ID, vTimerCallback);
    /* Check the timer was created. */
    configASSERT(xTimer);

    /* start the timer with a block time of 0 ticks. This means as soon
       as the schedule starts the timer will start running and will expire after
       10 seconds */
    xTimerStart(xTimer, 0);
    vTaskStartScheduler();
    while (1) {
    };
    // never reached
    return 0;
}

static void prvRFdcSetupTask(void *pvParameters) {
    double ADC_refClkFreq_MHz = 250;
    double ADC_samplingRate_Msps = 2000;
    double DAC_refClkFreq_MHz = 250;
    double DAC_samplingRate_Msps = 1000;

    rfdcMTS_setup(RFDC_DEVICE_ID, ADC_refClkFreq_MHz, ADC_samplingRate_Msps, DAC_refClkFreq_MHz, DAC_samplingRate_Msps);
    while (1) {
    };
}

static void vTimerCallback(TimerHandle_t pxTimer) {
    long lTimerId;
    configASSERT(pxTimer);

    lTimerId = (long)pvTimerGetTimerID(pxTimer);
    xil_printf("Time up. Stop all tasks\r\n");
    if (lTimerId != TIMER_ID) {
        xil_printf("Another Timer is called\r\n");
    }
    vTaskDelete(xRFdcSetupTask);
}