#ifndef __PERIPHERAL_MANAGER__
#define __PERIPHERAL_MANAGER__

#include "intr_manager.h"
#include "platform_config.h"
// #include "xgpio.h"
#include "xparameters.h"
#include "xspi.h"

#ifdef FREE_RTOS
#include "FreeRTOS.h"
#include "task.h"
#endif  // FREE_RTOS

#define BASEDAC_DAC_NUM 8

#define LADC_ADC_NUM 8

#define LADC_ADDR_NUM 18
// See ADS42LB49, ADS42LB69 Technical Docment (ads42lb69.pdf, page 47, Table 10)
#define LADC_SPI_CLKDIV_ADDR 0x06
#define LADC_SPI_SYNCDELAY_ADDR 0x07
#define LADC_SPI_CTRL_ADDR 0x08
#define LADC_SPI_CHAGAIN_ADDR 0x0B
#define LADC_SPI_CHBGAIN_ADDR 0x0C
#define LADC_SPI_FASTOVER_ADDR 0x0D
#define LADC_SPI_OUTPUTMODE_ADDR 0x0F
#define LADC_SPI_CUSTMPTN1MSB_ADDR 0x10
#define LADC_SPI_CUSTMPTN1LSB_ADDR 0x11
#define LADC_SPI_CUSTMPTN2MSB_ADDR 0x12
#define LADC_SPI_CUSTMPTN2LSB_ADDR 0x13
#define LADC_SPI_OUTPUTCFG_ADDR 0x14
#define LADC_SPI_LVDSMODE_ADDR 0x15
#define LADC_SPI_DDRMODECFG_ADDR 0x16
#define LADC_SPI_QDRMODECFG1_ADDR 0x17
#define LADC_SPI_QDRMODECFG2_ADDR 0x18
#define LADC_SPI_FASTOVRTHR_ADDR 0x1F
#define LADC_SPI_CTRLPINMODE_ADDR 0x20

#define DEFAULT_LADC_TPN1 0x00FF
#define DEFAULT_LADC_TPN2 0x0F00

/* 0x77 means assign 0b0111 to Channel A and 0b0111 to Channel B
0b0111 : Double pattern: In the ADS42LB69, data alternate between
CUSTOM PATTERN 1[15:0] and CUSTOM PATTERN 2[15:0].
In the ADS42LB49 data alternate between CUSTOM PATTERN 1[15:2]
and CUSTOM PATTERN 2[15:2]. */
#define LADC_DOUBLETPNMODE 0x77
#define LADC_NOMALMODE 0x00

#define SPI_LADC_DEVICE_ID XPAR_SPI_0_DEVICE_ID
#define SPI_LADC_INTR XPAR_FABRIC_SPI_0_VEC_ID

#define SPI_BASEDAC_DEVICE_ID XPAR_SPI_1_DEVICE_ID
#define SPI_BASEDAC_INTR XPAR_FABRIC_SPI_1_VEC_ID

TaskHandle_t xPeripheralSetupTask;

volatile int SPI_LADC_TransferInProgress;
int SPI_LADC_Error;

volatile int SPI_BASEDAC_TransferInProgress;
int SPI_BASEDAC_Error;

XSpi SpiLadc;
XSpi SpiBaseDac;

#define IIC_CDCI6214_DEVICE_ID XPAR_IIC_0_DEVICE_ID
#define IIC_CDCI6214_INTR XPAR_FABRIC_IIC_0_VEC_ID

#define IIC_SFP1_DEVICE_ID XPAR_IIC_1_DEVICE_ID
#define IIC_SFP1_INTR XPAR_FABRIC_IIC_1_VEC_ID

#define IIC_SFP2_DEVICE_ID XPAR_IIC_2_DEVICE_ID
#define IIC_SFP2_INTR XPAR_FABRIC_IIC_2_VEC_ID

typedef struct Ladc_Config {
    u16 TestPattern1;
    u16 TestPattern2;
    u8 OperationMode;
} Ladc_Config;

Ladc_Config LadcConfig;

int SetupSpiIntrSystem(INTC *IntcInstancePtr, XSpi *SpiInstancePtr, u16 SpiIntrId);
int peripheral_setup();
int BaselineDAC_ApplyConfig(u16 baseline);
int LADC_ApplyConfig();

#endif  // !__PERIPHERAL_MANAGER__
