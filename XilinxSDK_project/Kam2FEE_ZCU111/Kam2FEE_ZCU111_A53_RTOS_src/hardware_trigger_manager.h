#ifndef __HARDWARE_TRIGGER_MANAGER_H__
#define __HARDWARE_TRIGGER_MANAGER_H__

#include "xil_printf.h"
#include "xstatus.h"

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

int HardwareTrigger_SetupDeviceId(u16 TriggerdeviceId, TriggerManager_Config TriggerManagerConfig);
int HardwareTrigger_StartDeviceId(u16 TriggerdeviceId);
int HardwareTrigger_StopDeviceId(u16 TriggerdeviceId);

#endif
