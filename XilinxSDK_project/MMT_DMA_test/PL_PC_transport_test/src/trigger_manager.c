#include <sys/syslimits.h>
#include "xil_printf.h"
#include "xparameters.h"
#include "xstatus.h"
#include "xgpio.h"
#include "xrfdc.h"

#include "trigger_manager.h"

#ifdef XPS_BOARD_ZCU111
 #include "xrfdc_clk.h"
#endif

/************************** Constant Definitions ****************************/

/*
 * The following constants map to the XPAR parameters created in the
 * xparameters.h file. They are defined here such that a user can easily
 * change all the needed parameters in one place.
 */

// RF Data Converter related constants
#define BUS_NAME        "generic"
#define RFDC_DEV_NAME    XPAR_XRFDC_0_DEV_NAME
#define XRFDC_BASE_ADDR		XPAR_XRFDC_0_BASEADDR
#define RFDC_DEVICE_ID 	XPAR_XRFDC_0_DEVICE_ID

// GPIO related constants
#define THRESHOLD_BASELINE_GPIO_DEVICE_ID XPAR_THRESHOLD_BASLINE_GPIO_DEVICE_ID
#define THRESHOLD_CH 1
#define BASELINE_CH 2
#define THRESHOLD_BITWIDTH 13
#define BASELINE_BITWIDTH 12

#define PRE_ACQUI_DEVICE_ID XPAR_PRE_ACQUI_LEN_GPIO_DEVICE_ID
#define PRE_ACQUI_CH 1
#define PRE_ACQUI_BITWIDTH 5

#define RESET_DEVICE_ID XPAR_RESET_GPIO_DEVICE_ID
#define RESET_CH 1
#define RESET_BITWIDTH 1

/************************** Variable Definitions ****************************/

// RF Data Converter related variables
static XRFdc RFdcInst;      /* RFdc driver instance */

#ifdef XPS_BOARD_ZCU111
unsigned int LMK04208_CKin[1][26] = {
		{0x00160040,0x80140320,0x80140321,0x80140322,
		0xC0140023,0x40140024,0x80141E05,0x03300006,0x01300007,0x06010008,
		0x55555549,0x9102410A,0x0401100B,0x1B0C006C,0x2302886D,0x0200000E,
		0x8000800F,0xC1550410,0x00000058,0x02C9C419,0x8FA8001A,0x10001E1B,
		0x0021201C,0x0180033D,0x0200033E,0x003F001F }};
#endif

static struct metal_device *device;
static struct metal_io_region *io;

static const metal_phys_addr_t metal_phys[] = {
		XRFDC_BASE_ADDR
};

static struct metal_device metal_dev_table[] = {
	{
		/* RFdc device */
		.name = RFDC_DEV_NAME,
		.bus = NULL,
		.num_regions = 1,
		.regions = {
			{
				.virt = (void *)XRFDC_BASE_ADDR,
				.physmap = &metal_phys[0],
				.size = 0x40000,
				.page_shift = (unsigned)(-1),
				.page_mask = (unsigned)(-1),
				.mem_flags = 0x0,
				.ops = {NULL},
			}
		},
		.node = {NULL},
		.irq_num = 0,
		.irq_info = NULL,
	}
};

// GPIO related variables
static XGpio GpioThresholdBaseline;
static XGpio GpioPreAcquiLen;
static XGpio GpioReset;

/****************************************************************************/
/**
*
* This function registers devices to the libmetal generic bus.
* Before accessing the device with libmetal device operation,
* register the device to a libmetal supported bus. For non-Linux system,
* libmetal only supports "generic" bus to manage memory mapped devices.
*
* @param	None.
*
* @return
*		0 - succeeded, non-zero for failures.
*
* @note		None.
*
*****************************************************************************/
static int register_metal_device(void)
{
	unsigned int i;
	int ret;

	for (i = 0; i < 1; i++) {
		device = &metal_dev_table[i];
		xil_printf("registering: %d, name=%s\r\n", i, device->name);
		ret = metal_register_generic_device(device);
		if (ret)
			return ret;
	}
	return 0;
}

static int GpioSetUp(XGpio *GpioInstPtr, u16 DeviceId){
	int Status;

	Status = XGpio_Initialize(GpioInstPtr, DeviceId);
	if (Status != XST_SUCCESS)  {
		return XST_FAILURE;
	}
	XGpio_SetDataDirection(GpioInstPtr, 1, 0x0);
	if (DeviceId == THRESHOLD_BASELINE_GPIO_DEVICE_ID)
	{
		XGpio_SetDataDirection(GpioInstPtr, 2, 0x0);
	}

	return XST_SUCCESS;
}

static void PLReset(){
	unsigned int reset_len = 2;
	int reset_activate = 1;
	int reset_inactivate = 0;
	XGpio_DiscreteWrite(&GpioReset, RESET_CH, reset_activate);
	xil_printf("PL reset for %d sec\r\n", reset_len);
	sleep(reset_len);
	XGpio_DiscreteWrite(&GpioReset, RESET_CH, reset_inactivate);
	xil_printf("PL reset done. configuration has been updated.\r\n");
}

static void SetThreshold(int16_t threshold){
	XGpio_DiscreteWrite(&GpioThresholdBaseline, THRESHOLD_CH, threshold);
	xil_printf("Set Threshold: %d\r\n", threshold);
}

static void SetBaseline(u16 baseline){
	XGpio_DiscreteWrite(&GpioThresholdBaseline, BASELINE_CH, baseline);
	xil_printf("Set Baseline: %d\r\n", baseline);
}

static void SetPreAcquiLen(u8 pre_acqui_len){
	XGpio_DiscreteWrite(&GpioPreAcquiLen, PRE_ACQUI_CH, pre_acqui_len);
	xil_printf("Set Pre_acqui_len: %d\r\n", pre_acqui_len);
}

static int RFdcStartUp(u16 RFdcDeviceId){
	int Status;
	u16 Tile;
	u16 Block;
	XRFdc_Config *ConfigPtr;
	XRFdc *RFdcInstPtr = &RFdcInst;
	u32 ADCSetFabricRate[4];
	u32 GetFabricRate;
	char DeviceName[NAME_MAX];
	
	/* Initialize the metal deveice */ 
	struct metal_init_params init_param = METAL_INIT_DEFAULTS;
	if (metal_init(&init_param))
	{
		xil_printf("ERROR: Failed to initialize metal\r\n");
		return XRFDC_FAILURE;
	}

	/* Initialize the RFdc driver */
    ConfigPtr = XRFdc_LookupConfig(RFdcDeviceId);
    if (ConfigPtr == NULL)
	{
		xil_printf("RFdc driver could not find RFdcDeviceID: %d\r\n", RFdcDeviceId);
		return XRFDC_FAILURE;
	}
	
	Status = XRFdc_CfgInitialize(RFdcInstPtr, ConfigPtr);
	if (Status != XRFDC_SUCCESS)
	{
		xil_printf("RFdc driver failed to call the driver instance.\r\n");
	}
	
	xil_printf("\nThe board is ZCU111. Configuring the clock\r\n");
	LMK04208ClockConfig(1, LMK04208_CKin);
	LMX2594ClockConfig(1, 4096000);

    /* registring metal device and find RF data converter */
    int ret;
	ret = register_metal_device();
	if (ret)
	{
		xil_printf("%s: failed to register devices: %d\r\n", __func__, ret);
		return ret;
	}
	ret = metal_device_open(BUS_NAME, RFDC_DEV_NAME, &device);
	if (ret)
	{
		xil_printf("ERROR: failed to open device usp_rf_data_converter\r\n");
	    return XRFDC_FAILURE;
	}

	/* Map RFDC device IO region */
	io = metal_device_io_region(device, 0);
	if(!io){
		xil_printf("ERROR: failed to map RFDC regIO for %s.\r\n", device->name);
		return XRFDC_FAILURE;
	}
	RFdcInstPtr->device = device;
	RFdcInstPtr->io = io;

    Tile = 0x0;

    /* checking RFdc ADC status */
	int NumOfEnableADCblock;
	NumOfEnableADCblock = XRFdc_GetNoOfADCBlocks(RFdcInstPtr, Tile);
	xil_printf("\n%d blocks on Tile %x is enabled\r\n", NumOfEnableADCblock, Tile);

	int Enable4GSPS;
	Enable4GSPS = XRFdc_IsADC4GSPS(RFdcInstPtr);
	if (Enable4GSPS)
	{
		xil_printf("RF-ADC sampling at more than 4GSPS\r\n");
	} else
	{
		xil_printf("RF-ADC sampling at less than 4GSPS\r\n");
	}
	
    return XRFDC_SUCCESS;
}

int trigger_setup(int16_t threshold, u16 baseline, u8 pre_acqui_len){
    int Status;

	xil_printf("\nStart up RF Data Converter....\r\n");
	Status = RFdcStartUp(RFDC_DEVICE_ID);
	if (Status != XRFDC_SUCCESS) {
		xil_printf("Failed to start up RFADC\r\n");
		return XRFDC_FAILURE;
	}
	xil_printf("Successfully start up RFADC\r\n");

	xil_printf("\n\nSetup GPIOs...\r\n");
	Status = GpioSetUp(&GpioThresholdBaseline, THRESHOLD_BASELINE_GPIO_DEVICE_ID);
	if (Status != XST_SUCCESS) {
		xil_printf("Failed to initialize Threshold & Baseline config GPIO\r\n");
		return XST_FAILURE;
	}	
	Status = GpioSetUp(&GpioPreAcquiLen, PRE_ACQUI_DEVICE_ID);
	if (Status != XST_SUCCESS) {
		xil_printf("Failed to initialize PreaAcuqi_len config GPIO\r\n");
		return XST_FAILURE;
	}

	Status = GpioSetUp(&GpioReset, RESET_DEVICE_ID);
	if (Status != XST_SUCCESS) {
		xil_printf("Failed to initialize Reset config GPIO\r\n");
		return XST_FAILURE;
	}

	SetBaseline(baseline);
	SetThreshold(threshold);
	SetPreAcquiLen(pre_acqui_len);
	PLReset();    
    return XST_SUCCESS;
};