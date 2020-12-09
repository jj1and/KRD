#ifndef __HARDWARE_TRIGGER_MANAGER_H__
#define __HARDWARE_TRIGGER_MANAGER_H__

#include "xgpio.h"

#define COMBINED_ACQUIRE_MODE 0x1
#define NORMAL_ACQUIRE_MODE 0x0
#define DSP_NORMAL_ACQUIRE_MODE 0x2
#define DSP_COMBINED_ACQUIRE_MODE 0x3

#define HARDWARE_TRIGGER 0x0
#define EXTERNAL_TRIGGER 0x1

typedef struct Channel_Config {
    int channel;
    u32 AcquireMode;
    u32 TriggerType;
    int RisingEdgeThreshold;
    int FallingEdgeThreshold;
    u32 PreAcquisitionLength;
    u32 PostAcquisitionLength;
    int HgainBaseline;
    int LgainBaseline;
} Channel_Config;

typedef struct TriggerManager_Config {
    int ChannelNum;
    u32 MaxTriggerLength;
    Channel_Config *ChanelConfigs;
} TriggerManager_Config;

XGpio Gpio_mode_switch_thre;

int SetSwitchThreshold(short int upper_threshold, short int lower_threshold);
int HardwareTrigger_SetupDeviceId(u16 TriggerdeviceId, TriggerManager_Config TriggerManagerConfig);
int HardwareTrigger_StartDeviceId(u16 TriggerdeviceId);
int HardwareTrigger_StopDeviceId(u16 TriggerdeviceId);

#endif
