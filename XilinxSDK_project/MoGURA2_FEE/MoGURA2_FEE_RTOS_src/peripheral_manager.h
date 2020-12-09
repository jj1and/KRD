#ifndef __PERIPHERAL_MANAGER__
#define __PERIPHERAL_MANAGER__

#include "intr_manager.h"
#include "platform_config.h"
// #include "xgpio.h"
#include "xparameters.h"
#include "xspi.h"

// #define CDCI6214_DEFAULT_REG 0x00000C

// #define LADC_CTRL_DEFAULT_REG 0x00000000
// #define LADC_CTRL_ALLPOWEROFF_REG 0x0000FFFF

// #define LADC_RESET_DEFAULT_REG 0x00000000
// #define LADC_RESET_RESET_REG 0x00000001

// #define LADC_SEN_DEFAULT_REG 0x00000001

#define BASEDAC_DAC_NUM 8

// #define CDCI6214_REG_CONFIG_GPIO_DEVICE_ID XPAR_GPIO_1_DEVICE_ID
// #define PERIPHERAL_GPIO_DEVICE_ID XPAR_GPIO_2_DEVICE_ID
// #define LADC_REG_CTRL_GPIO_DEVICE_ID XPAR_GPIO_3_DEVICE_ID
// #define LADC_REG_RESET_GPIO_DEVICE_ID XPAR_GPIO_4_DEVICE_ID
// #define LADC_REG_SEN_GPIO_DEVICE_ID XPAR_GPIO_5_DEVICE_ID
// #define SFP1_REG_CONFIG_GPIO_DEVICE_ID XPAR_GPIO_6_DEVICE_ID
// #define SFP2_REG_CONFIG_GPIO_DEVICE_ID XPAR_GPIO_7_DEVICE_ID

// XGpio Cdci6214RegGpio;
// XGpio LadcRegCtrlGpio;
// XGpio LadcRegRSTGpio;
// XGpio LadcRegSenGpio;

#define SPI_LADC_DEVICE_ID XPAR_SPI_0_DEVICE_ID
#define SPI_LADC_INTR XPAR_FABRIC_SPI_0_VEC_ID

#define SPI_BASEDAC_DEVICE_ID XPAR_SPI_1_DEVICE_ID
#define SPI_BASEDAC_INTR XPAR_FABRIC_SPI_1_VEC_ID

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

int SetupSpiIntrSystem(INTC *IntcInstancePtr, XSpi *SpiInstancePtr, u16 SpiIntrId);
int setup_peripheral();
int BaselineDAC_Config(u16 baseline);
void BaselineDac_disableIntr();

#endif  // !__PERIPHERAL_MANAGER__
