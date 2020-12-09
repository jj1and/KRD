#ifndef __PERIPHERAL_CONTROLLER_H__
#define __PERIPHERAL_CONTROLLER_H__

#include "xil_types.h"
#include "xparameters.h"

#define PERIPHERAL_CONTROLLER_NUM_INSTANCES 1
#define PERIPHERAL_CONTROLLER_0_DEVICE_ID 0
#define XPAR_PERIPHERAL_CONTROLLER_0_BASEADDR XPAR_PERIPHERAL_CTRL_BLOCK_PERIPHERAL_CONTROLER_0_BASEADDR

#define CDCI6214_EEPROM_MASK 0x00000010
#define CDCI6214_RESET_MASK 0x00000008
#define CDCI6214_OE_CONFIG_MASK 0x00000004
#define CDCI6214_STATUS_MASK 0x00000002
#define CDCI6214_REF_SEL_MASK 0x00000001

#define CDCI6214_EEPROM_PAGE0 0x00000000
#define CDCI6214_EEPROM_PAGE1 0x00000010
#define CDCI6214_NORMAL 0x00000008  // CDCI reset is active low
#define CDCI6214_RESET 0x00000000   // CDCI reset is active low
#define CDCI6214_OE_ENABLE 0x00000004
#define CDCI6214_OE_DISABLE 0x00000000
#define CDCI6214_REF_SEL_XIN 0x00000000
#define CDCI6214_REF_SEL_REF 0x00000001

#define GPIO_MASK 0x0000000F

#define LADC_CTRL_CTRL1_MASK 0x0000000F
#define LADC_CTRL_CTRL2_MASK 0x000000F0
#define LADC_CTRL_ALLDEFAULT_OPERATION 0x00000000
#define LADC_CTRL_ALLPOWEROFF 0x0000FFFF

#define LADC_RESET_MASK 0x00000001
#define LADC_NORMAL 0x00000000
#define LADC_RESET 0x00000001

#define LADC_SEN_MASK 0x000000FF
#define LADC_SEN_HIGH 0x00000001
#define LADC_SEN_LOW 0x00000000

#define SFP_RS0_MASK 0x00000020
#define SFP_RS1_MASK 0x00000010
#define SFP_TX_DISABLE_MASK 0x00000002
#define SFP_TX_STATUS_MASK 0x0000000D

#define SFP_RS0_HIGH 0x00000020
#define SFP_RS1_HIGH 0x00000010
#define SFP_RS0_LOW 0x00000000
#define SFP_RS1_LOW 0x00000000
#define SFP_TX_DISABLE 0x00000000
#define SFP_TX_ENABLE 0x00000002

#define DEFAULT_CDCI6214_GPIO_CONFIG (CDCI6214_EEPROM_PAGE0 | CDCI6214_NORMAL | CDCI6214_OE_ENABLE | CDCI6214_REF_SEL_XIN)
#define DEFALUT_GPO_CONFIG (0x00000000 & GPIO_MASK)

#define DEFAULT_LADC_CTRL_CONFIG LADC_CTRL_ALLDEFAULT_OPERATION
#define DEFAULT_LADC_RESET_CONFIG LADC_NORMAL
#define DEFAULT_LADC_SEN_CONFIG LADC_SEN_HIGH

#define DEFAULT_SFP_CONFIG (SFP_RS0_LOW | SFP_RS1_LOW | SFP_TX_DISABLE)

typedef struct Peripheral_Config {
    u16 DeviceId;        /**< DeviceId is the unique ID  of the device */
    UINTPTR BaseAddress; /**< BaseAddress is the physical base address of the
                          *  device's registers
                          * */
    u32 CDCI6214GpioConfigAddr;
    u32 GpoAddr;
    u32 GpiAddr;
    u32 LadcCtrlAddr;
    u32 Sfp1GpioAddr;
    u32 Sfp2GpioAddr;
} Peripheral_Config;

int Peripheral_Cdci6214Reset(u16 DeviceId);
int Peripheral_LadcReset(u16 DeviceId);
int Peripheral_LadcSenActive(u16 DeviceId);
int Peripheral_LadcSenDeactive(u16 DeviceId);

int Peripheral_SetConfigDefault(u16 DeviceId);
int Peripheral_SetConfigDefaultBaseAddr(UINTPTR Baseaddr);
int Peripheral_SetCdci6214Config(u16 DeviceId, u32 Config);
int Peripheral_SetGpoConfig(u16 DeviceId, u32 Config);
int Peripheral_SetGpoConfig(u16 DeviceId, u32 Config);
int Peripheral_SetSfp1Config(u16 DeviceId, u32 Config);
int Peripheral_SetSfp2Config(u16 DeviceId, u32 Config);
void Peripheral_PrintCfgPtr(u16 DeviceId);
int Peripheral_ApplyCfg(u16 DeviceId);
void Peripheral_PrintAppliedCfg(u16 DeviceId);
int Peripheral_GetCdci6214Status(u16 DeviceId);
int Peripheral_GetGpiInput(u16 DeviceId);
int Peripheral_GetSfp1Status(u16 DeviceId);
int Peripheral_GetSfp2Status(u16 DeviceId);

#endif  // !__PERIPHERAL_CONTROLLER_H__
