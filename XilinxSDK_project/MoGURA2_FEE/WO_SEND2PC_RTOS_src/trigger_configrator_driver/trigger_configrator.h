#ifndef __TRIGGER_CONFIGRATOR__
#define __TRIGGER_CONFIGRATOR__

#include "xil_types.h"
#include "xparameters.h"

#define TRIGGER_CONFIGRATOR_NUM_INSTANCES 1
#define TRIGGER_CONFIGRATOR_0_DEVICE_ID 0
#define XPAR_TRIGGER_CONFIGRATOR_0_BASEADDR XPAR_HARDWARE_TRIGGER_BLOCKS_TRIGGER_CONFIGRATOR_0_BASEADDR

// GPIO related constant
#define GAIN_SWITCH_CONFIG_GPIO_DEVICE_ID XPAR_AXI_GPIO_0_DEVICE_ID
#define MODE_SWITCH_UPPER_THRE_CH 1
#define MODE_SWITCH_LOWER_THRE_CH 2

#define CONTROL_STATE_MASK 0x00000040
#define RUN_STATE 0x00000000
#define STOP_STATE 0x00000040

#define ACQUIRE_MODE_MASK 0x00000030

#define TRIGGER_TYPE_MASK 0x0000000F

#define MAX_TRIGGER_LENGTH_MASK 0x0000FFFF
#define CONFIG_STATE_MASK 0x00010000
#define CONFIG_STATE 0x00010000
#define CONFIG_FIXED_STATE 0x00000000

#define RISE_THRE_MASK 0xFFFF0000
#define FALL_THRE_MASK 0x0000FFFF

#define PRE_ACQUI_LEN_MASK 0xFFFF0000
#define POST_ACQUI_LEN_MASK 0x0000FFFF

#define H_GAIN_BASELINE_MASK 0xFFFF0000
#define L_GAIN_BASELINE_MASK 0x0000FFFF

#define DEFAULT_CONTROL_CONFIG 0x00000040
#define DEFAULT_THRESHOLD_CONFIG 0x01000000
#define DEFAULT_ACQUISITION_CONFIG 0x00010001
#define DEFAULT_BASELINE_CONFIG 0x00000000
#define DEFAULT_CONFIG 0x00000010

typedef struct Trigger_Config {
    u16 DeviceId;        /**< DeviceId is the unique ID  of the device */
    UINTPTR BaseAddress; /**< BaseAddress is the physical base address of the
                          *  device's registers
                          * */
    u32 *ControlAddr;
    u32 *ThresholdAddr;
    u32 *AcquisitionAddr;
    u32 *BaselineAddr;
    u32 ConfigAddr;
} Trigger_Config;

int Trigger_SetConfigDefault(u16 DeviceId);
int Trigger_SetConfigDefaultBaseAddr(UINTPTR Baseaddr);
int Trigger_MaxLengthConfig(u16 DeviceId, u32 MaxTriggerLength);
int Trigger_MaxLengthConfigBaseAddr(UINTPTR Baseaddr, u32 MaxTriggerLength);
Trigger_Config *Trigger_ChannelConfig(u16 DeviceId, u32 channel, u32 ControlAddr, u32 ThresholdAddr, u32 AcquisitionAddr, u32 BaselineAddr);
Trigger_Config *Trigger_ChannelConfigBaseAddr(UINTPTR Baseaddr, u32 channel, u32 ControlAddr, u32 ThresholdAddr, u32 AcquisitionAddr, u32 BaselineAddr);

int Trigger_ApplyCfg(Trigger_Config *CfgPtr);
int Trigger_Start(Trigger_Config *CfgPtr, u16 ch);
int Trigger_Stop(Trigger_Config *CfgPtr, u16 ch);
int Trigger_StartAllCh(Trigger_Config *CfgPtr);
int Trigger_StopAllCh(Trigger_Config *CfgPtr);

Trigger_Config *Trigger_LookupConfig(u16 DeviceId);
Trigger_Config *Trigger_LookupConfigBaseAddr(UINTPTR Baseaddr);

#endif
