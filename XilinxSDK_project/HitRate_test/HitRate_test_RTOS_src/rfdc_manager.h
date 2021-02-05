#ifndef __RFDC_MANAGER_H__
#define __RFDC_MANAGER_H__

/* This code for handling RF Data Conver on Baremetal or RTOS on ZCU111*/
#ifndef __BAREMETAL__
#define __BAREMETAL__
#endif

#include "platform_config.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "xrfdc.h"

#define LMK04208_count 26
#define LMX2594_A_count 113

#define BUS_NAME "generic"
#define I2C_BUS 1
#define XRFDC_BASE_ADDR XPAR_XRFDC_0_BASEADDR
#define RFDC_DEVICE_ID XPAR_XRFDC_0_DEVICE_ID
#define RFDC_DEV_NAME XPAR_XRFDC_0_DEV_NAME

#define RFDC_ADC_TILE XRFDC_ADC_TILE
#define RFDC_DAC_TILE XRFDC_DAC_TILE

typedef struct {
    int XFrequency;
    unsigned int LMX2594_A[LMX2594_A_count];
} XClockingLmx;

typedef struct AvailableAdcTiles {
    int NumOfAdcTiles;
    int *AdcTileIndex;
} AvailableAdcTiles;

typedef struct AvailableDacTiles {
    int NumOfDacTiles;
    int *DacTileIndex;
} AvailableDacTiles;

int rfdcADC_MTS_setup(u16 RFdcDeviceId, double ADC_refClkFreq_MHz, double ADC_samplingRate_Msps, AvailableAdcTiles AdcTiles);
int rfdcDAC_MTS_setup(u16 RFdcDeviceId, double DAC_refClkFreq_MHz, double DAC_samplingRate_Msps, AvailableDacTiles DacTiles);
int rfdcSingle_setup(u16 RFdcDeviceId, u32 Type, u32 Tile_id, double refClkFreq_MHz, double samplingRate_Msps);

#endif
