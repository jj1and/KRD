/*
 * xrfdc_simple_dma_test.c
 *
 *  Created on: 2019/11/06
 *      Author: MoGURA
 *
 *  This is a bare-metal program for testing Minimum Trigger Logic with RFSoC.
 *
 *
 */
/***************************** Include Files ********************************/
#include <sys/syslimits.h>
#include "xparameters.h"
#include "xstatus.h"
#include "xgpio.h"
#include "xrfdc.h"
#include "xaxidma.h"
#include "xil_exception.h"
#include "xdebug.h"

#ifdef XPS_BOARD_ZCU111
 #include "xrfdc_clk.h"
#endif

#ifdef XPAR_INTC_0_DEVICE_ID
 #include "xintc.h"
#else
 #include "xscugic.h"
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

// AXI-DMA related constants
#define DMA_DEV_ID		XPAR_AXIDMA_0_DEVICE_ID

#ifdef XPAR_AXI_7SDDR_0_S_AXI_BASEADDR
#define DDR_BASE_ADDR		XPAR_AXI_7SDDR_0_S_AXI_BASEADDR
#elif defined (XPAR_MIG7SERIES_0_BASEADDR)
#define DDR_BASE_ADDR	XPAR_MIG7SERIES_0_BASEADDR
#elif defined (XPAR_MIG_0_BASEADDR)
#define DDR_BASE_ADDR	XPAR_MIG_0_BASEADDR
#elif defined (XPAR_PSU_DDR_1_S_AXI_BASEADDR)
#define DDR_BASE_ADDR	XPAR_PSU_DDR_1_S_AXI_BASEADDR
#elif defined (XPAR_PSU_DDR_0_S_AXI_BASEADDR)
#define DDR_BASE_ADDR	XPAR_PSU_DDR_0_S_AXI_BASEADDR
#endif

#ifndef DDR_BASE_ADDR
#warning CHECK FOR THE VALID DDR ADDRESS IN XPARAMETERS.H, \
			DEFAULT SET TO 0x01000000
#define MEM_BASE_ADDR		0x01000000
#else
#define MEM_BASE_ADDR		(DDR_BASE_ADDR + 0x1000000)
#endif

#ifdef XPAR_INTC_0_DEVICE_ID
#define RX_INTR_ID		XPAR_INTC_0_AXIDMA_0_VEC_ID
#else
#define RX_INTR_ID		XPAR_FABRIC_AXI_DMA_0_S2MM_INTROUT_INTR
#endif

#define RX_BUFFER_BASE		(MEM_BASE_ADDR + 0x00300000)
#define RX_BUFFER_HIGH		(MEM_BASE_ADDR + 0x004FFFFF)

#ifdef XPAR_INTC_0_DEVICE_ID
#define INTC_DEVICE_ID          XPAR_INTC_0_DEVICE_ID
#else
#define INTC_DEVICE_ID          XPAR_SCUGIC_SINGLE_DEVICE_ID
#endif

/* Timeout loop counter for reset
 */
#define RESET_TIMEOUT_COUNTER	10000

/*
 * Buffer and Buffer Descriptor related constant definition
 */
#define MAX_PKT_LEN	0x800

#define NUMBER_OF_TRANSFERS	2

/* The interrupt coalescing threshold and delay timer threshold
 * Valid range is 1 to 255
 *
 * We set the coalescing threshold to be the total number of packets.
 * The receive side will only get one completion interrupt for this example.
 */
#define COALESCING_COUNT		NUMBER_OF_PKTS_TO_TRANSFER
#define DELAY_TIMER_COUNT		100

#ifdef XPAR_INTC_0_DEVICE_ID
 #define INTC		XIntc
 #define INTC_HANDLER	XIntc_InterruptHandler
#else
 #define INTC		XScuGic
 #define INTC_HANDLER	XScuGic_InterruptHandler
#endif

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

/***************** Macros (Inline Functions) Definitions ********************/
#define printf xil_printf

/************************** Function Prototypes *****************************/

// RF Data Converter related functions
static int RFdcStartUp(u16 SysMonDeviceId);
int register_metal_device(void);

// AXI-DMA related functions
static void PrintData(int Length);
static void RxIntrHandler(void *Callback);

static int SetupIntrSystem(INTC * IntcInstancePtr, XAxiDma * AxiDmaPtr, u16 RxIntrId);
static void DisableIntrSystem(INTC * IntcInstancePtr, u16 RxIntrId);

// GPIO related functions
int GpioSetUp(XGpio *GpioInstPtr, u16 DeviceId);
void PLReset();
void SetThreshold(int16_t threshold);
void SetBaseline(u16 baseline);
void SetPreAcquiLen(u8 pre_acqui_len);

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
struct metal_device *device;
struct metal_io_region *io;

const metal_phys_addr_t metal_phys[] = {
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


// AXI-DMA related variables
XAxiDma AxiDma;
static INTC Intc;	/* Instance of the Interrupt Controller */

/*
 * Flags interrupt handlers use to notify the application context the events.
 */
volatile int RxDone;
volatile int Error;

// GPIO related variables
XGpio GpioThresholdBaseline;
XGpio GpioPreAcquiLen;
XGpio GpioReset;

int main(void)
{

	int Status;
	XAxiDma_Config *DmaConfig;
	int Tries = NUMBER_OF_TRANSFERS;
	int Index;	
	u64 *RxBufferPtr;
	RxBufferPtr = (u64 *)RX_BUFFER_BASE;

	printf("RFdc MMtrigger Test...\n");
	printf("Start up RF Data Converter....\n");
	Status = RFdcStartUp(RFDC_DEVICE_ID);
	if (Status != XRFDC_SUCCESS) {
		printf("\nFailed to start up RFADC\n\n");
		return XRFDC_FAILURE;
	}
	printf("\nSuccessfully start up RFADC\n");
	
	printf("\n\nSetup GPIOs...\n");
	Status = GpioSetUp(&GpioThresholdBaseline, THRESHOLD_BASELINE_GPIO_DEVICE_ID);
	if (Status != XST_SUCCESS) {
		printf("\nFailed to initialize Threshold & Baseline config GPIO\n");
		return XST_FAILURE;
	}	
	Status = GpioSetUp(&GpioPreAcquiLen, PRE_ACQUI_DEVICE_ID);
	if (Status != XST_SUCCESS) {
		printf("\nFailed to initialize PreaAcuqi_len config GPIO\n");
		return XST_FAILURE;
	}

	Status = GpioSetUp(&GpioReset, RESET_DEVICE_ID);
	if (Status != XST_SUCCESS) {
		printf("\nFailed to initialize Reset config GPIO\n");
		return XST_FAILURE;
	}

	int16_t threshold = 256;
	u16 baseline = 0;
	u8 pre_acqui_len = 5;

	SetBaseline(baseline);
	SetThreshold(threshold);
	SetPreAcquiLen(pre_acqui_len);
	PLReset();

    printf("\n\nSetup AXI-DMA...\n");
	DmaConfig = XAxiDma_LookupConfig(DMA_DEV_ID);
	if (!DmaConfig) {
		xil_printf("\nNo config found for %d\n", DMA_DEV_ID);

		return XST_FAILURE;
	}

	/* Initialize DMA engine */
	Status = XAxiDma_CfgInitialize(&AxiDma, DmaConfig);

	if(XAxiDma_HasSg(&AxiDma)){
		xil_printf("\nDevice configured as SG mode \n");
		return XST_FAILURE;
	}	

	printf("\nSet up Interrupt system \n");
	/* Set up Interrupt system  */
	Status = SetupIntrSystem(&Intc, &AxiDma, RX_INTR_ID);

	if (Status != XST_SUCCESS) {
		xil_printf("Failed intr setup\r\n");
		return XST_FAILURE;
	}

	printf("\nInitialize DMA engine\n");
	/* Disable all interrupts before setup */
	XAxiDma_IntrDisable(&AxiDma, XAXIDMA_IRQ_ALL_MASK,
				XAXIDMA_DEVICE_TO_DMA);
	/* Enable all interrupts */
	XAxiDma_IntrEnable(&AxiDma, XAXIDMA_IRQ_ALL_MASK,
							XAXIDMA_DEVICE_TO_DMA);

	/* Initialize flags before start transfer test  */
	RxDone = 0;
	Error = 0;

	printf("\nAXI-DMA Setup is done successfully. Now waiting DMA interrupt..\n");

	/*
	 * Wait RX done
	 */
	for(Index = 0; Index < Tries; Index ++) {

		Status = XAxiDma_SimpleTransfer(&AxiDma,(UINTPTR) RxBufferPtr,
					MAX_PKT_LEN, XAXIDMA_DEVICE_TO_DMA);

		/*
		 * Wait TX done and RX done
		 */
		int max_wait_time = 30;
		int time = 0;
		while (!RxDone && !Error) {
			if (time > max_wait_time){
				 printf("\nTime out\n");
			 	return XST_FAILURE;
			}
			sleep(1);
//			u32 tmp_S2MM_Status;
//			tmp_S2MM_Status = XAxiDma_ReadReg(AxiDma.RegBase + XAXIDMA_RX_OFFSET, XAXIDMA_SR_OFFSET);
//			printf("S2MM status: %x\n", tmp_S2MM_Status);
//			u32 tmp_IrqStatus;
//			tmp_IrqStatus = XAxiDma_IntrGetIrq(&AxiDma, XAXIDMA_DEVICE_TO_DMA);
//			printf("Interrupt status: %x\n", tmp_IrqStatus);
			printf("%d sec\r\n", time);
			time++;
		}
		/*
		 * Test finished, check data
		 */
		PrintData((int) MAX_PKT_LEN/8);
		if (Error) {
			xil_printf("Failed test receive%s done\r\n", RxDone? "":" not");
			goto Done;
		}
		RxDone = 0;

	}

	if (Error) {
		xil_printf("receive%s done\r\n",  RxDone? "":" not");
	 	goto Done;
	}else {
		xil_printf("Successfully ran AXI DMA Simple interrupt Example\r\n");
	}

	/* Disable RX Ring interrupts and return success */
	DisableIntrSystem(&Intc, RX_INTR_ID);


Done:
	xil_printf("--- Exiting main() --- \r\n");
	cleanup_platform();
	return XST_SUCCESS;
}


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
int register_metal_device(void)
{
	unsigned int i;
	int ret;

	for (i = 0; i < 1; i++) {
		device = &metal_dev_table[i];
		xil_printf("registering: %d, name=%s\n", i, device->name);
		ret = metal_register_generic_device(device);
		if (ret)
			return ret;
	}
	return 0;
}


int RFdcStartUp(u16 RFdcDeviceId){

	init_platform();

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
		printf("\n ERROR: Failed to initialize metal");
		return XRFDC_FAILURE;
	}

	/* Initialize the RFdc driver */
    ConfigPtr = XRFdc_LookupConfig(RFdcDeviceId);
    if (ConfigPtr == NULL)
	{
		printf("\n RFdc driver could not find RFdcDeviceID: %d\n", RFdcDeviceId);
		return XRFDC_FAILURE;
	}
	
	Status = XRFdc_CfgInitialize(RFdcInstPtr, ConfigPtr);
	if (Status != XRFDC_SUCCESS)
	{
		printf("\n RFdc driver failed to call the driver instance.\n");
	}
	
	printf("\nThe board is ZCU111. Configuring the clock\n");
	LMK04208ClockConfig(1, LMK04208_CKin);
	LMX2594ClockConfig(1, 4096000);

    /* registring metal device and find RF data converter */
    int ret;
	ret = register_metal_device();
	if (ret)
	{
		printf("\n%s: failed to register devices: %d\n", __func__, ret);
		return ret;
	}
	ret = metal_device_open(BUS_NAME, RFDC_DEV_NAME, &device);
	if (ret)
	{
		printf("\nERROR: failed to open device usp_rf_data_converter\n");
	    return XRFDC_FAILURE;
	}

	/* Map RFDC device IO region */
	io = metal_device_io_region(device, 0);
	if(!io){
		printf("\nERROR: failed to map RFDC regIO for %s.\n", device->name);
		return XRFDC_FAILURE;
	}
	RFdcInstPtr->device = device;
	RFdcInstPtr->io = io;

    Tile = 0x0;

    /* checking RFdc ADC status */
	int NumOfEnableADCblock;
	NumOfEnableADCblock = XRFdc_GetNoOfADCBlocks(RFdcInstPtr, Tile);
	printf("\n%d blocks on Tile %x is enabled\n", NumOfEnableADCblock, Tile);

	int Enable4GSPS;
	Enable4GSPS = XRFdc_IsADC4GSPS(RFdcInstPtr);
	if (Enable4GSPS)
	{
		printf("\nRF-ADC sampling at more than 4GSPS\n");
	} else
	{
		printf("\nRF-ADC sampling at less than 4GSPS\n");
	}
	
    return XRFDC_SUCCESS;
}

int GpioSetUp(XGpio *GpioInstPtr, u16 DeviceId){
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

void PLReset(){
	unsigned int reset_len = 2;
	int reset_activate = 1;
	int reset_inactivate = 0;
	XGpio_DiscreteWrite(&GpioReset, RESET_CH, reset_activate);
	printf("\nPL reset for %d sec", reset_len);
	sleep(reset_len);
	XGpio_DiscreteWrite(&GpioReset, RESET_CH, reset_inactivate);
	printf("PL reset done. configuration has been updated.");
}

void SetThreshold(int16_t threshold){
	XGpio_DiscreteWrite(&GpioThresholdBaseline, THRESHOLD_CH, threshold);
	printf("\nSet Threshold: %d", threshold);
}

void SetBaseline(u16 baseline){
	XGpio_DiscreteWrite(&GpioThresholdBaseline, BASELINE_CH, baseline);
	printf("\nSet Baseline: %d", baseline);
}

void SetPreAcquiLen(u8 pre_acqui_len){
	XGpio_DiscreteWrite(&GpioPreAcquiLen, PRE_ACQUI_CH, pre_acqui_len);
	printf("\nSet Pre_acqui_len: %d \n", pre_acqui_len);
}

/*****************************************************************************/
/*
*
* This function checks data buffer after the DMA transfer is finished.
*
* We use the static tx/rx buffers.
*
* @param	Length is the length to check
* @param	StartValue is the starting value of the first byte
*
* @return	- XST_SUCCESS if validation is successful
*		- XST_FAILURE if validation fails.
*
* @note		None.
*
******************************************************************************/

static void PrintData(int Length)
{
	u64 *RxPacket;
	int Index = 0;
	RxPacket = (u64 *) RX_BUFFER_BASE;

	/* Invalidate the DestBuffer before receiving the data, in case the
	 * Data Cache is enabled
	 */
	Xil_DCacheInvalidateRange((u64)RX_BUFFER_BASE, Length*8);

	for(Index = 0; Index < Length; Index++) {
		if ((Index+1)%4 == 0){
			printf("%016llx\n", RxPacket[Index]);
		} else {
			printf("%016llx ", RxPacket[Index]);
		}
	}
	printf("\n\n");

	return XST_SUCCESS;
}

/*****************************************************************************/
/*
*
* This is the DMA RX interrupt handler function
*
* It gets the interrupt status from the hardware, acknowledges it, and if any
* error happens, it resets the hardware. Otherwise, if a completion interrupt
* is present, then it sets the RxDone flag.
*
* @param	Callback is a pointer to RX channel of the DMA engine.
*
* @return	None.
*
* @note		None.
*
******************************************************************************/
static void RxIntrHandler(void *Callback)
{
	u32 IrqStatus;
	int TimeOut;
	XAxiDma *AxiDmaInst = (XAxiDma *)Callback;

	 u32 S2MM_Status;
	 S2MM_Status = XAxiDma_ReadReg(AxiDmaInst->RegBase + XAXIDMA_RX_OFFSET, XAXIDMA_SR_OFFSET);
	 printf("RxIntrHandler called\n");
	 printf("S2MM status: %x\n", S2MM_Status);

	/* Read pending interrupts */
	IrqStatus = XAxiDma_IntrGetIrq(AxiDmaInst, XAXIDMA_DEVICE_TO_DMA);

	/* Acknowledge pending interrupts */
	XAxiDma_IntrAckIrq(AxiDmaInst, IrqStatus, XAXIDMA_DEVICE_TO_DMA);

	/*
	 * If no interrupt is asserted, we do not do anything
	 */
	if (!(IrqStatus & XAXIDMA_IRQ_ALL_MASK)) {
		return;
	}

	/*
	 * If error interrupt is asserted, raise error flag, reset the
	 * hardware to recover from the error, and return with no further
	 * processing.
	 */
	if ((IrqStatus & XAXIDMA_IRQ_ERROR_MASK)) {

		Error = 1;

		/* Reset could fail and hang
		 * NEED a way to handle this or do not call it??
		 */
		XAxiDma_Reset(AxiDmaInst);

		TimeOut = RESET_TIMEOUT_COUNTER;

		while (TimeOut) {
			if(XAxiDma_ResetIsDone(AxiDmaInst)) {
				break;
			}

			TimeOut -= 1;
		}

		return;
	}

	/*
	 * If completion interrupt is asserted, then set RxDone flag
	 */
	if ((IrqStatus & XAXIDMA_IRQ_IOC_MASK)) {
		printf("Rx done. S2MM Status: %x\n", S2MM_Status);
		RxDone = 1;
	}
}

/*****************************************************************************/
/*
*
* This function setups the interrupt system so interrupts can occur for the
* DMA, it assumes INTC component exists in the hardware system.
*
* @param	IntcInstancePtr is a pointer to the instance of the INTC.
* @param	AxiDmaPtr is a pointer to the instance of the DMA engine
* @param	RxIntrId is the RX channel Interrupt ID.
*
* @return
*		- XST_SUCCESS if successful,
*		- XST_FAILURE.if not succesful
*
* @note		None.
*
******************************************************************************/

static int SetupIntrSystem(INTC * IntcInstancePtr,
			   XAxiDma * AxiDmaPtr, u16 RxIntrId)
{
	int Status;

#ifdef XPAR_INTC_0_DEVICE_ID

	/* Initialize the interrupt controller and connect the ISRs */
	Status = XIntc_Initialize(IntcInstancePtr, INTC_DEVICE_ID);
	if (Status != XST_SUCCESS) {

		xil_printf("Failed init intc\r\n");
		return XST_FAILURE;
	}

	Status = XIntc_Connect(IntcInstancePtr, RxIntrId,
			       (XInterruptHandler) RxIntrHandler, AxiDmaPtr);
	if (Status != XST_SUCCESS) {

		xil_printf("Failed rx connect intc\r\n");
		return XST_FAILURE;
	}

	/* Start the interrupt controller */
	Status = XIntc_Start(IntcInstancePtr, XIN_REAL_MODE);
	if (Status != XST_SUCCESS) {

		xil_printf("Failed to start intc\r\n");
		return XST_FAILURE;
	}

	XIntc_Enable(IntcInstancePtr, RxIntrId);

#else

	XScuGic_Config *IntcConfig;


	/*
	 * Initialize the interrupt controller driver so that it is ready to
	 * use.
	 */
	IntcConfig = XScuGic_LookupConfig(INTC_DEVICE_ID);
	if (NULL == IntcConfig) {
		return XST_FAILURE;
	}

	Status = XScuGic_CfgInitialize(IntcInstancePtr, IntcConfig,
					IntcConfig->CpuBaseAddress);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	XScuGic_SetPriorityTriggerType(IntcInstancePtr, RxIntrId, 0xA0, 0x3);
	/*
	 * Connect the device driver handler that will be called when an
	 * interrupt for the device occurs, the handler defined above performs
	 * the specific interrupt processing for the device.
	 */
	Status = XScuGic_Connect(IntcInstancePtr, RxIntrId,
				(Xil_InterruptHandler)RxIntrHandler,
				AxiDmaPtr);
	if (Status != XST_SUCCESS) {
		return Status;
	}

	XScuGic_Enable(IntcInstancePtr, RxIntrId);


#endif

	/* Enable interrupts from the hardware */

	Xil_ExceptionInit();
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
			(Xil_ExceptionHandler)INTC_HANDLER,
			(void *)IntcInstancePtr);

	Xil_ExceptionEnable();

	return XST_SUCCESS;
}

/*****************************************************************************/
/**
*
* This function disables the interrupts for DMA engine.
*
* @param	IntcInstancePtr is the pointer to the INTC component instance
* @param	RxIntrId is interrupt ID associated w/ DMA RX channel
*
* @return	None.
*
* @note		None.
*
******************************************************************************/
static void DisableIntrSystem(INTC * IntcInstancePtr, u16 RxIntrId)
{
#ifdef XPAR_INTC_0_DEVICE_ID
	/* Disconnect the interrupts for the DMA TX and RX channels */
	XIntc_Disconnect(IntcInstancePtr, RxIntrId);
#else
	XScuGic_Disconnect(IntcInstancePtr, RxIntrId);
#endif
}
