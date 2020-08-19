#ifndef __RFDC_MANAGER_H__
#define __RFDC_MANAGER_H__

/* This code for handling RF Data Conver on Baremetal or RTOS on ZCU111*/
#ifndef __BAREMETAL__
#define __BAREMETAL__
#endif

#ifndef XPS_BOARD_ZCU111
#define XPS_BOARD_ZCU111
#endif

#define LMK04208_count 26
#define LMX2594_A_count 113

#define BUS_NAME "generic"
#define I2C_BUS 1
#define XRFDC_BASE_ADDR XPAR_XRFDC_0_BASEADDR
#define RFDC_DEVICE_ID XPAR_XRFDC_0_DEVICE_ID
#define RFDC_DEV_NAME XPAR_XRFDC_0_DEV_NAME

#include "xil_printf.h"
#include "xparameters.h"

typedef struct {
    int XFrequency;
    unsigned int LMX2594_A[LMX2594_A_count];
} XClockingLmx;

int rfdcMTS_setup(u16 RFdcDeviceId, double ADC_refClkFreq_MHz, double ADC_samplingRate_Msps, double DAC_refClkFreq_MHz, double DAC_samplingRate_Msps);
int rfdcSingle_setup(u16 RFdcDeviceId, u32 Type, u32 Tile_id, double refClkFreq_MHz, double samplingRate_Msps);

#endif
