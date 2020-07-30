#include "rfdc_manager.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "sleep.h"
#include "xiicps.h"
#include "xrfdc.h"
#include "xrfdc_mts.h"
#include "xuartps.h"

#define MAX_FREQ 1

static XRFdc RFdcInst; /* RFdc driver instance */
XIicPs Iic;            /* Instance of the IIC Device */

// Designed by TI tool (TICS pro)
// [0]: clk_in: 122.88MHz (LMK04208), clkA_out : 245.76MHz, clkB_out : 245.76MHz, for Multi-Tile-Sync design
static XClockingLmx Lmx2594_config[1] = {
    {250000, {0x700000, 0x6F0000, 0x6E0000, 0x6D0000, 0x6C0000, 0x6B0000, 0x6A0000, 0x690021, 0x680000, 0x670000, 0x660000, 0x650011, 0x640000, 0x630000, 0x620000, 0x610888, 0x600000,
              0x5F0000, 0x5E0000, 0x5D0000, 0x5C0000, 0x5B0000, 0x5A0000, 0x590000, 0x580000, 0x570000, 0x560000, 0x550000, 0x540000, 0x530000, 0x520000, 0x510000, 0x500000, 0x4F0000,
              0x4E00E5, 0x4D0000, 0x4C000C, 0x4B09C0, 0x4A0000, 0x49003F, 0x480001, 0x470081, 0x46C350, 0x450000, 0x4403E8, 0x430000, 0x4201F4, 0x410000, 0x401388, 0x3F0000, 0x3E0322,
              0x3D00A8, 0x3C0000, 0x3B0001, 0x3A0001, 0x390020, 0x380000, 0x370000, 0x360000, 0x350000, 0x340820, 0x330080, 0x320000, 0x314180, 0x300300, 0x2F0300, 0x2E07FC, 0x2DC0D8,
              0x2C1821, 0x2B0000, 0x2A0000, 0x290000, 0x280000, 0x2703E8, 0x260000, 0x250104, 0x240020, 0x230004, 0x220000, 0x211E21, 0x200393, 0x1F43EC, 0x1E318C, 0x1D318C, 0x1C0488,
              0x1B0002, 0x1A0DB0, 0x190624, 0x18071A, 0x17007C, 0x160001, 0x150401, 0x14C848, 0x1327B7, 0x120064, 0x1101F4, 0x100080, 0x0F064F, 0x0E1E70, 0x0D4000, 0x0C5001, 0x0B0018,
              0x0A10D8, 0x091604, 0x082000, 0x0740B2, 0x06C802, 0x0500C8, 0x040C43, 0x030642, 0x020500, 0x010808, 0x00259C}}};

// Designed by TI tool (TICS pro)
// clk_in: 122.88MHz (External VCXO), clk1_out : 7.68MHz, clk3_out : 122.88MHz, clk4_out : 122.88MHz clk5_out : 7.68MHz
static unsigned int Lmk04208_config[1][LMK04208_count] = {{0x00160040, 0x80140300, 0x00143001, 0x80140302, 0x00140303, 0x00140304, 0x00143005, 0x01400006, 0x04400007,
                                                           0x08010008, 0x55555549, 0x9102440A, 0x0401100B, 0x130C006C, 0x2302820D, 0x0220000E, 0x8000800F, 0xC1550410,
                                                           0x00000058, 0x02C9C419, 0xAFA8001A, 0x1040009B, 0x0020011C, 0x0180019D, 0x0100019E, 0x003F001F}};

/****************************************************************************/
/**
 *
 * This function is used to configure LMK04208
 *
 * @param	XIicBus is the Controller Id/Bus number.
 *           - For Baremetal it is the I2C controller Id to which LMK04208
 *             deviceis connected.
 *           - For Linux it is the Bus Id to which LMK04208 device is connected.
 * @param	LMK04208_CKin is the configuration array to configure the LMK04208.
 *
 * @return
 *		- None
 *
 * @note   	None
 *
 ****************************************************************************/
static void LMK04208ClockConfig(int XIicBus, unsigned int LMK04208_CKin[1][26]) {
    XIicPs_Config *Config_iic;
    int Status;
    u8 tx_array[10];
    u8 rx_array[10];
    u32 ClkRate = 100000;
    int Index;

    Config_iic = XIicPs_LookupConfig(XIicBus);
    if (NULL == Config_iic) {
        return;
    }

    Status = XIicPs_CfgInitialize(&Iic, Config_iic, Config_iic->BaseAddress);
    if (Status != XST_SUCCESS) {
        return;
    }

    Status = XIicPs_SetSClk(&Iic, ClkRate);
    if (Status != XST_SUCCESS) {
        return;
    }

    /*
     * 0x02-enable Super
     * clock module
     * 0x20- analog I2C
     * power module
     * slaves
     */
    tx_array[0] = 0x20;
    XIicPs_MasterSendPolled(&Iic, tx_array, 0x01, 0x74);
    while (XIicPs_BusIsBusy(&Iic))
        ;
    usleep(25000);

    /*
     * Receive the Data.
     */
    Status = XIicPs_MasterRecvPolled(&Iic, rx_array, 1, 0x74);
    if (Status != XST_SUCCESS) {
        return;
    }

    /*
     * Wait until bus is
     * idle to start
     * another transfer.
     */
    while (XIicPs_BusIsBusy(&Iic))
        ;

    /*
     * Function Id.
     */
    tx_array[0] = 0xF0;
    tx_array[1] = 0x02;
    XIicPs_MasterSendPolled(&Iic, tx_array, 0x02, 0x2F);
    while (XIicPs_BusIsBusy(&Iic))
        ;
    usleep(25000);

    /*
     * Receive the Data.
     */
    Status = XIicPs_MasterRecvPolled(&Iic, rx_array, 2, 0x2F);
    if (Status != XST_SUCCESS) {
        return;
    }

    /*
     * Wait until bus is
     * idle to start
     * another transfer.
     */
    while (XIicPs_BusIsBusy(&Iic))
        ;

    for (Index = 0; Index < LMK04208_count; Index++) {
        tx_array[0] = 0x02;
        tx_array[4] = (u8)(LMK04208_CKin[0][Index]) & (0xFF);
        tx_array[3] = (u8)(LMK04208_CKin[0][Index] >> 8) & (0xFF);
        tx_array[2] = (u8)(LMK04208_CKin[0][Index] >> 16) & (0xFF);
        tx_array[1] = (u8)(LMK04208_CKin[0][Index] >> 24) & (0xFF);
        Status = XIicPs_MasterSendPolled(&Iic, tx_array, 0x05, 0x2F);
        usleep(25000);
        while (XIicPs_BusIsBusy(&Iic))
            ;
    }

    sleep(2);

    xil_printf(
        "LMK04208 "
        "configuration "
        "write "
        "done\r\n");
}

/****************************************************************************/
/**
 *
 * This function is used to configure LMX2594
 *
 * @param	XIicBus is the Controller Id/Bus number.
 *           - For Baremetal it is the I2C controller Id to which LMX2594 device
 *             is connected.
 *           - For Linux it is the Bus Id to which LMX2594 device is connected.
 * @param	XFrequency is the frequency used to configure the LMX2594.
 *
 * @return
 *		- None
 *
 * @note   	None
 *
 ****************************************************************************/
static void LMX2594ClockConfig(int XIicBus, int XFrequency) {
    XIicPs_Config *Config_iic;
    int Status;
    u8 tx_array[10];
    u8 rx_array[10];
    u32 ClkRate = 100000;
    int Index;
    int freq_index = 0;
    int XFreqIndex;

    for (XFreqIndex = 0; XFreqIndex < MAX_FREQ; XFreqIndex++) {
        if (Lmx2594_config[XFreqIndex].XFrequency == XFrequency) {
            freq_index = XFreqIndex;
            xil_printf("LMX configured to frequency %d \n", XFrequency);
        }
    }

    Config_iic = XIicPs_LookupConfig(XIicBus);
    if (NULL == Config_iic) {
        return;
    }

    Status = XIicPs_CfgInitialize(&Iic, Config_iic, Config_iic->BaseAddress);
    if (Status != XST_SUCCESS) {
        return;
    }

    Status = XIicPs_SetSClk(&Iic, ClkRate);
    if (Status != XST_SUCCESS) {
        return;
    }

    /*
     * 0x02-enable Super
     * clock module
     * 0x20- analog I2C
     * power module
     * slaves
     */
    tx_array[0] = 0x20;
    XIicPs_MasterSendPolled(&Iic, tx_array, 0x01, 0x74);
    while (XIicPs_BusIsBusy(&Iic))
        ;
    usleep(25000);

    /*
     * Receive the Data.
     */
    Status = XIicPs_MasterRecvPolled(&Iic, rx_array, 1, 0x74);
    if (Status != XST_SUCCESS) {
        return;
    }

    /*
     * Wait until bus is
     * idle to start
     * another transfer.
     */
    while (XIicPs_BusIsBusy(&Iic))
        ;

    /*
     * Function Id.
     */
    tx_array[0] = 0xF0;
    tx_array[1] = 0x02;
    XIicPs_MasterSendPolled(&Iic, tx_array, 0x02, 0x2F);
    while (XIicPs_BusIsBusy(&Iic))
        ;
    usleep(25000);

    /*
     * Receive the Data.
     */
    Status = XIicPs_MasterRecvPolled(&Iic, rx_array, 2, 0x2F);
    if (Status != XST_SUCCESS) {
        return;
    }

    /*
     * Wait until bus is
     * idle to start
     * another transfer.
     */
    while (XIicPs_BusIsBusy(&Iic))
        ;

    tx_array[0] = 0x08;
    tx_array[3] = (u8)(0x00);
    tx_array[2] = (u8)(0x00);
    tx_array[1] = (u8)(0x20);
    Status = XIicPs_MasterSendPolled(&Iic, tx_array, 0x04, 0x2F);
    while (XIicPs_BusIsBusy(&Iic))
        ;

    sleep(2);

    tx_array[0] = 0x08;
    tx_array[3] = (u8)(0x00);
    tx_array[2] = (u8)(0x00);
    tx_array[1] = (u8)(0x00);
    Status = XIicPs_MasterSendPolled(&Iic, tx_array, 0x04, 0x2F);
    while (XIicPs_BusIsBusy(&Iic))
        ;

    sleep(2);
    for (Index = 0; Index < LMX2594_A_count; Index++) {
        tx_array[0] = 0x08;
        tx_array[3] = (u8)(Lmx2594_config[freq_index].LMX2594_A[Index]) & (0xFF);
        tx_array[2] = (u8)(Lmx2594_config[freq_index].LMX2594_A[Index] >> 8) & (0xFF);
        tx_array[1] = (u8)(Lmx2594_config[freq_index].LMX2594_A[Index] >> 16) & (0xFF);
        Status = XIicPs_MasterSendPolled(&Iic, tx_array, 0x04, 0x2F);
        while (XIicPs_BusIsBusy(&Iic))
            ;
        usleep(25000);
    }

    tx_array[0] = 0x08;
    tx_array[3] = (u8)(Lmx2594_config[freq_index].LMX2594_A[112]) & (0xFF);
    tx_array[2] = (u8)(Lmx2594_config[freq_index].LMX2594_A[112] >> 8) & (0xFF);
    tx_array[1] = (u8)(Lmx2594_config[freq_index].LMX2594_A[112] >> 16) & (0xFF);
    Status = XIicPs_MasterSendPolled(&Iic, tx_array, 0x04, 0x2F);
    while (XIicPs_BusIsBusy(&Iic))
        ;
    usleep(25000);

    tx_array[0] = 0x04;
    tx_array[3] = (u8)(0x00);
    tx_array[2] = (u8)(0x00);
    tx_array[1] = (u8)(0x02);
    Status = XIicPs_MasterSendPolled(&Iic, tx_array, 0x04, 0x2F);
    while (XIicPs_BusIsBusy(&Iic))
        ;

    sleep(2);
    tx_array[0] = 0x04;
    tx_array[3] = (u8)(0x00);
    tx_array[2] = (u8)(0x00);
    tx_array[1] = (u8)(0x00);
    Status = XIicPs_MasterSendPolled(&Iic, tx_array, 0x04, 0x2F);
    while (XIicPs_BusIsBusy(&Iic))
        ;

    sleep(2);
    for (Index = 0; Index < LMX2594_A_count; Index++) {
        tx_array[0] = 0x04;
        tx_array[3] = (u8)(Lmx2594_config[freq_index].LMX2594_A[Index]) & (0xFF);
        tx_array[2] = (u8)(Lmx2594_config[freq_index].LMX2594_A[Index] >> 8) & (0xFF);
        tx_array[1] = (u8)(Lmx2594_config[freq_index].LMX2594_A[Index] >> 16) & (0xFF);
        Status = XIicPs_MasterSendPolled(&Iic, tx_array, 0x04, 0x2F);
        while (XIicPs_BusIsBusy(&Iic))
            ;
        usleep(25000);
    }

    tx_array[0] = 0x04;
    tx_array[3] = (u8)(Lmx2594_config[freq_index].LMX2594_A[112]) & (0xFF);
    tx_array[2] = (u8)(Lmx2594_config[freq_index].LMX2594_A[112] >> 8) & (0xFF);
    tx_array[1] = (u8)(Lmx2594_config[freq_index].LMX2594_A[112] >> 16) & (0xFF);
    Status = XIicPs_MasterSendPolled(&Iic, tx_array, 0x04, 0x2F);
    while (XIicPs_BusIsBusy(&Iic))
        ;
    usleep(25000);

    tx_array[0] = 0x01;
    tx_array[3] = (u8)(0x00);
    tx_array[2] = (u8)(0x00);
    tx_array[1] = (u8)(0x02);
    Status = XIicPs_MasterSendPolled(&Iic, tx_array, 0x04, 0x2F);
    while (XIicPs_BusIsBusy(&Iic))
        ;
    sleep(2);

    tx_array[0] = 0x01;
    tx_array[3] = (u8)(0x00);
    tx_array[2] = (u8)(0x00);
    tx_array[1] = (u8)(0x00);
    Status = XIicPs_MasterSendPolled(&Iic, tx_array, 0x04, 0x2F);
    while (XIicPs_BusIsBusy(&Iic))
        ;
    sleep(2);

    for (Index = 0; Index < LMX2594_A_count; Index++) {
        tx_array[0] = 0x01;
        tx_array[3] = (u8)(Lmx2594_config[freq_index].LMX2594_A[Index]) & (0xFF);
        tx_array[2] = (u8)(Lmx2594_config[freq_index].LMX2594_A[Index] >> 8) & (0xFF);
        tx_array[1] = (u8)(Lmx2594_config[freq_index].LMX2594_A[Index] >> 16) & (0xFF);
        Status = XIicPs_MasterSendPolled(&Iic, tx_array, 0x04, 0x2F);
        while (XIicPs_BusIsBusy(&Iic))
            ;
        usleep(25000);
    }

    tx_array[0] = 0x01;
    tx_array[3] = (u8)(Lmx2594_config[freq_index].LMX2594_A[112]) & (0xFF);
    tx_array[2] = (u8)(Lmx2594_config[freq_index].LMX2594_A[112] >> 8) & (0xFF);
    tx_array[1] = (u8)(Lmx2594_config[freq_index].LMX2594_A[112] >> 16) & (0xFF);
    Status = XIicPs_MasterSendPolled(&Iic, tx_array, 0x04, 0x2F);
    while (XIicPs_BusIsBusy(&Iic))
        ;
    usleep(25000);
    xil_printf("I2c1 I2CTOSPI LMX2594 PLL configuration done\r\n");
}

int rfdcMTS_setup(u16 RFdcDeviceId, double ADC_refClkFreq_MHz, double ADC_samplingRate_Msps, double DAC_refClkFreq_MHz, double DAC_samplingRate_Msps) {
    int status, status_adc, status_dac, i;
    u32 factor;
    XRFdc_Config *ConfigPtr;
    XRFdc *RFdcInstPtr = &RFdcInst;

    struct metal_init_params init_param = METAL_INIT_DEFAULTS;

    xil_printf("Start up RF Data Conver @Multi-Tile-Sync mode\r\n");

    xil_printf("Configuring clock on ZCU111\r\n");
    LMK04208ClockConfig(I2C_BUS, Lmk04208_config);
    LMX2594ClockConfig(I2C_BUS, 250000);

    if (metal_init(&init_param)) {
        printf("ERROR: Failed to run metal initialization\r\n");
        return XRFDC_FAILURE;
    }
    metal_set_log_level(METAL_LOG_DEBUG);
    ConfigPtr = XRFdc_LookupConfig(RFdcDeviceId);
    if (ConfigPtr == NULL) {
        return XRFDC_FAILURE;
    }

    status = XRFdc_CfgInitialize(RFdcInstPtr, ConfigPtr);
    if (status != XRFDC_SUCCESS) {
        xil_printf("ERROR: RFdc Init Failure\n\r");
    }

    /*Setting Frequency & Sample Rate to Appropriate Values for MTS*/
    printf("Configuring Clock Frequency and Sampling Rate\r\n");
    status = XRFdc_DynamicPLLConfig(RFdcInstPtr, XRFDC_DAC_TILE, 0, XRFDC_EXTERNAL_CLK, DAC_refClkFreq_MHz, DAC_samplingRate_Msps);
    if (status != XRFDC_SUCCESS) {
        xil_printf("ERROR: Could not configure PLL For DAC 0\r\n");
        return XRFDC_FAILURE;
    }
    status = XRFdc_DynamicPLLConfig(RFdcInstPtr, XRFDC_DAC_TILE, 1, XRFDC_EXTERNAL_CLK, DAC_refClkFreq_MHz, DAC_samplingRate_Msps);
    if (status != XRFDC_SUCCESS) {
        xil_printf("ERROR: Could not configure PLL For DAC 1\r\n");
        return XRFDC_FAILURE;
    }
    status = XRFdc_DynamicPLLConfig(RFdcInstPtr, XRFDC_ADC_TILE, 0, XRFDC_EXTERNAL_CLK, ADC_refClkFreq_MHz, ADC_samplingRate_Msps);
    if (status != XRFDC_SUCCESS) {
        xil_printf("ERROR: Could not configure PLL For ADC 0\r\n");
        return XRFDC_FAILURE;
    }
    status = XRFdc_DynamicPLLConfig(RFdcInstPtr, XRFDC_ADC_TILE, 1, XRFDC_EXTERNAL_CLK, ADC_refClkFreq_MHz, ADC_samplingRate_Msps);
    if (status != XRFDC_SUCCESS) {
        xil_printf("ERROR: Could not configure PLL For ADC 1\r\n");
        return XRFDC_FAILURE;
    }
    status = XRFdc_DynamicPLLConfig(RFdcInstPtr, XRFDC_ADC_TILE, 2, XRFDC_EXTERNAL_CLK, ADC_refClkFreq_MHz, ADC_samplingRate_Msps);
    if (status != XRFDC_SUCCESS) {
        xil_printf("ERROR: Could not configure PLL For ADC 2\r\n");
        return XRFDC_FAILURE;
    }
    status = XRFdc_DynamicPLLConfig(RFdcInstPtr, XRFDC_ADC_TILE, 3, XRFDC_EXTERNAL_CLK, ADC_refClkFreq_MHz, ADC_samplingRate_Msps);
    if (status != XRFDC_SUCCESS) {
        xil_printf("ERROR: Could not configure PLL For ADC 3\r\n");
        return XRFDC_FAILURE;
    }

    xil_printf("=== RFdc Initialized - Running Multi-tile Sync ===\n");

    /* ADC MTS Settings */
    XRFdc_MultiConverter_Sync_Config ADC_Sync_Config;

    /* DAC MTS Settings */
    XRFdc_MultiConverter_Sync_Config DAC_Sync_Config;

    /* Run MTS for the ADC & DAC */
    xil_printf("\n=== Run DAC Sync ===\n");

    /* Initialize DAC MTS Settings */
    XRFdc_MultiConverter_Init(&DAC_Sync_Config, 0, 0);
    DAC_Sync_Config.Tiles = 0x3; /* Sync DAC tiles 0 and 1 */

    status_dac = XRFdc_MultiConverter_Sync(RFdcInstPtr, XRFDC_DAC_TILE, &DAC_Sync_Config);
    if (status_dac == XRFDC_MTS_OK) {
        xil_printf("INFO : DAC Multi-Tile-Sync completed successfully\r\n");
    } else {
        xil_printf("ERROR : DAC Multi-Tile-Sync did not complete successfully. Error code is %u \r\n", status_dac);
        return status_dac;
    }

    xil_printf("\n=== Run ADC Sync ===\n");

    /* Initialize ADC MTS Settings */
    XRFdc_MultiConverter_Init(&ADC_Sync_Config, 0, 0);
    ADC_Sync_Config.Tiles = 0x5; /* Sync ADC tiles 0, 2 */

    status_adc = XRFdc_MultiConverter_Sync(RFdcInstPtr, XRFDC_ADC_TILE, &ADC_Sync_Config);
    if (status_adc == XRFDC_MTS_OK) {
        xil_printf("INFO : ADC Multi-Tile-Sync completed successfully\r\n");
    } else {
        xil_printf("ERROR : ADC Multi-Tile-Sync did not complete successfully. Error code is %u \r\n", status_adc);
        return status_adc;
    }

    /*
     * Report Overall Latency in T1 (Sample Clocks) and
     * Offsets (in terms of PL words) added to each FIFO
     */
    xil_printf("\n\n=== Multi-Tile Sync Report ===\n");
    for (i = 0; i < 4; i++) {
        if ((1 << i) & DAC_Sync_Config.Tiles) {
            XRFdc_GetInterpolationFactor(RFdcInstPtr, i, 0, &factor);
            xil_printf(
                "DAC%d: Latency(T1) =%3d, Adjusted Delay"
                "Offset(T%d) =%3d\r\n",
                i, DAC_Sync_Config.Latency[i], factor, DAC_Sync_Config.Offset[i]);
        }
    }
    for (i = 0; i < 4; i++) {
        if ((1 << i) & ADC_Sync_Config.Tiles) {
            XRFdc_GetDecimationFactor(RFdcInstPtr, i, 0, &factor);
            xil_printf(
                "ADC%d: Latency(T1) =%3d, Adjusted Delay"
                "Offset(T%d) =%3d\r\n",
                i, ADC_Sync_Config.Latency[i], factor, ADC_Sync_Config.Offset[i]);
        }
    }

    return XRFDC_MTS_OK;
}
