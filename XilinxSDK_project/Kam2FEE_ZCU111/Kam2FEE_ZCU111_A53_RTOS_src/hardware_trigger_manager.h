#ifndef __HARDWARE_TRIGGER_MANAGER_H__
#define __HARDWARE_TRIGGER_MANAGER_H__

#include "xil_printf.h"
#include "xstatus.h"

typedef struct Channel_Config {
    int channel;
    u32 AcquireMode;
    u32 MaxTriggerLength;
    int RisingEdgeThreshold;
    int FallingEdgeThreshold;
    u32 PreAcquisitionLength;
    u32 PostAcquisitionLength;
    int HgainBaseline;
    int LgainBaseline;
} Channel_Config;

typedef struct Trigger_Config {
    int ChannelNum;
    Channel_Config *ChanelConfigs;
} Trigger_Config;

int HardwareTrigger_SetupDeviceId(u16 FEEdeviceId, Trigger_Config TriggerConfig);
int HardwareTrigger_StartDeviceId(u16 FEEdeviceId);
int HardwareTrigger_StopDeviceId(u16 FEEdeviceId);

#endif
