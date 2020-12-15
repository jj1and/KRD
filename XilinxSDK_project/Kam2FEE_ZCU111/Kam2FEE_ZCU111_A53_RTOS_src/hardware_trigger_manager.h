#ifndef __HARDWARE_TRIGGER_MANAGER_H__
#define __HARDWARE_TRIGGER_MANAGER_H__

#include "xgpio.h"

#define MAX_TRIGGER_LEN 14
/*
 * Buffer and Buffer Descriptor related constant definition
 * MAX_TRIGGER_LEN[CLK]x 16[Byte] + (2(HEADERS) + 1(FOOTER))x 8[Byte]
 */
#define MAX_PKT_LEN (MAX_TRIGGER_LEN * 16 + 4 * 8) * 8

#define COMBINED_ACQUIRE_MODE 0x1
#define NORMAL_ACQUIRE_MODE 0x0
#define DSP_NORMAL_ACQUIRE_MODE 0x2
#define DSP_COMBINED_ACQUIRE_MODE 0x3

#define HARDWARE_TRIGGER 0x0
#define EXTERNAL_TRIGGER 0x1

#define INTERNAL_ADC_BUFF_SIZE 2048 * 16
#define INTERNAL_HF_BUFF_DEPTH 256
#define EXTERNAL_FRAME_BUFF_SIZE 512 * 16
#define INTERNAL_BUFFER_FULL 3
#define LAST_FRAME 2

#define FEE_RUNNING 0
#define FEE_STOPPED 1

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

int checkData(u64 *dataptr, TriggerManager_Config fee_config, int print_enable, u64 *rcvd_frame_length);
int SetSwitchThreshold(short int upper_threshold, short int lower_threshold);
int HardwareTrigger_SetupDeviceId(u16 TriggerdeviceId, TriggerManager_Config TriggerManagerConfig);
int HardwareTrigger_StartDeviceId(u16 TriggerdeviceId);
int HardwareTrigger_StopDeviceId(u16 TriggerdeviceId);
int getFeeState();

#endif
