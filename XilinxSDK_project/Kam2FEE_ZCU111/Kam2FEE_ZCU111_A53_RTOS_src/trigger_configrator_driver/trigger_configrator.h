#ifndef __TRIGGER_CONFIGRATOR__
#define __TRIGGER_CONFIGRATOR__

#include "trigger_configrator_hw.h"

/* register map for "CHANNEL_ID" Ch
        CONTROL_CONFIG : {25'b0, STOP, ACQUIRE_MODE[1:0], TRIGGER_TYPE[3:0]}
        THRESHOLD_ADDR : {RISING_EDGE_THRESHOLD, FALLIG_EDGE_THRESHOLD}
        ACQUISITION_ADDR : {{16-$clog2(MAX_PRE_ACQUISITION_LENGTH){1'b0}}, PRE_ACQUISITION_LENGTH, {16-$clog2(MAX_POST_ACQUISITION_LENGTH){1'b0}}, POST_ACQUISITION_LENGTH}
        BASELINE_ADDR : {3'b0, H_GAIN_BASELINE, L_GAIN_BASELINE}
        CONFIG_ADDR : {15'b0, SET_CONFIG, MAX_TRIGGER_LENGTH}
 */

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

#define Trigger_BaseAddress(CfgPtr) ((CfgPtr)->BaseAddress)

#define Trigger_IsConfigState(CfgPtr) (((Trigger_ReadReg((CfgPtr)->BaseAddress, CONFIG_ADDR_OFFSET) & CONFIG_STATE_MASK) == CONFIG_STATE) ? TRUE : FALSE)

#define Trigger_IsStopState(CfgPtr, Channel) (((Trigger_ReadReg((CfgPtr)->BaseAddress, CONTROL_ADDR_OFFSET + Channel * CHANNEL_OFFSET) & CONTROL_STATE_MASK) == STOP_STATE) ? TRUE : FALSE)

#define Trigger_IsRunState(CfgPtr, Channel) (((Trigger_ReadReg((CfgPtr)->BaseAddress, CONTROL_ADDR_OFFSET + Channel * CHANNEL_OFFSET) & CONTROL_STATE_MASK) == RUN_STATE) ? TRUE : FALSE)

#define FEE_IsNomalAcquireMode(CfgPtr, Channel) (((Trigger_ReadReg((CfgPtr)->BaseAddress, CONTROL_ADDR_OFFSET + Channel * CHANNEL_OFFSET) & ACQUIRE_MODE_MASK) == NORMAL_MODE) ? TRUE : FALSE)

#define Trigger_IsCombinedAcquireMode(CfgPtr, Channel) (((Trigger_ReadReg((CfgPtr)->BaseAddress, CONTROL_ADDR_OFFSET + Channel * CHANNEL_OFFSET) & ACQUIRE_MODE_MASK) == COMBINED_MODE) ? TRUE : FALSE)

#define Trigger_MaxTriggerLength(CfgPtr) ((Trigger_ReadReg((CfgPtr)->BaseAddress, CONFIG_ADDR_OFFSET) & MAX_TRIGGER_LENGTH_MASK)

#define Trigger_RisingEdgeThreshold(CfgPtr, Channel) ((Trigger_ReadReg((CfgPtr)->BaseAddress, THRESHOLD_ADDR_OFFSET + Channel * CHANNEL_OFFSET) & RISE_THRE_MASK)
#define Trigger_FallingEdgeThreshold(CfgPtr, Channel) ((Trigger_ReadReg((CfgPtr)->BaseAddress, THRESHOLD_ADDR_OFFSET + Channel * CHANNEL_OFFSET) & FALL_THRE_MASK)

#define Trigger_PreAcquisition(CfgPtr, Channel) ((Trigger_ReadReg((CfgPtr)->BaseAddress, ACQUISITION_ADDR_OFFSET + Channel * CHANNEL_OFFSET) & PRE_ACQUI_LEN_MASK)
#define Trigger_PostAcquisition(CfgPtr, Channel) ((Trigger_ReadReg((CfgPtr)->BaseAddress, ACQUISITION_ADDR_OFFSET + Channel * CHANNEL_OFFSET) & POST_ACQUI_LEN_MASK)

#define Trigger_HgainBaseline(CfgPtr, Channel) ((Trigger_ReadReg((CfgPtr)->BaseAddress, BASELINE_ADDR_OFFSET + Channel * CHANNEL_OFFSET) & H_GAIN_BASELINE_MASK)
#define Trigger_LgainBaseline(CfgPtr, Channel) ((Trigger_ReadReg((CfgPtr)->BaseAddress, BASELINE_ADDR_OFFSET + Channel * CHANNEL_OFFSET) & L_GAIN_BASELINE_MASK)

int Trigger_SetConfigDefault(u16 DeviceId);
int Trigger_SetConfigDefaultBaseAddr(UINTPTR Baseaddr);
int Trigger_MaxLengthConfig(u16 DeviceId, u32 MaxTriggerLength);
int Trigger_MaxLengthConfigBaseAddr(UINTPTR Baseaddr, u32 MaxTriggerLength);
Trigger_Config *Trigger_ChannelConfig(u16 DeviceId, u32 channel, u32 ControlAddr, u32 ThresholdAddr, u32 AcquisitionAddr, u32 BaselineAddr);
Trigger_Config *Trigger_ChannelConfigBaseAddr(UINTPTR Baseaddr, u32 channel, u32 ControlAddr, u32 ThresholdAddr, u32 AcquisitionAddr, u32 BaselineAddr);

int Trigger_ApplyCfg(Trigger_Config *CfgPtr);
int Trigger_Start(Trigger_Config *CfgPtr);
int Trigger_Stop(Trigger_Config *CfgPtr);

Trigger_Config *Trigger_LookupConfig(u16 DeviceId);
Trigger_Config *Trigger_LookupConfigBaseAddr(UINTPTR Baseaddr);

#endif
