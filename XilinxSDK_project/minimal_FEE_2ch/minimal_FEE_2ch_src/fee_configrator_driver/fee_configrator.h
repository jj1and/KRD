#ifndef __FEE_CONFIGRATOR__
#define __FEE_CONFIGRATOR__

#include "fee_configrator_hw.h"

/* register map for "CHANNEL_ID" Ch
        DEFAULT_CONTROL_ADDR : {8'b0, 5'b0, SET_CONFIG, STOP, ACQUIRE_MODE, MAX_TRIGGER_LENGTH}
        THRESHOLD_ADDR : {RISING_EDGE_THRESHOLD, FALLIG_EDGE_THRESHOLD}
        ACQUISITION_ADDR : {{16-$clog2(MAX_PRE_ACQUISITION_LENGTH){1'b0}}, PRE_ACQUISITION_LENGTH, {16-$clog2(MAX_POST_ACQUISITION_LENGTH){1'b0}}, POST_ACQUISITION_LENGTH}
        BASELINE_ADDR : {3'b0, H_GAIN_BASELINE, L_GAIN_BASELINE}
 */

#define DEFAULT_CONTROL_ADDR 0x00020010
#define DEFAULT_THRESHOLD_ADDR 0x01000000
#define DEFAULT_ACQUISITION_ADDR 0x00010001
#define DEFAULT_BASELINE_ADDR 0x00000000

typedef struct FEE_Config {
    u16 DeviceId;        /**< DeviceId is the unique ID  of the device */
    UINTPTR BaseAddress; /**< BaseAddress is the physical base address of the
                          *  device's registers
                          * */

    u32 *ControlAddr;
    u32 *ThresholdAddr;
    u32 *AcquisitionAddr;
    u32 *BaselineAddr;
} FEE_Config;

#define FEEConfig_BaseAddress(CfgPtr) ((CfgPtr)->BaseAddress)

#define FEEConfig_IsConfigState(CfgPtr, Channel) (((FEEConfig_ReadReg((CfgPtr)->BaseAddress, CONTROL_ADDR_OFFSET + Channel * CHANNEL_OFFSET) & CONTROL_STATE_MASK) == CONFIG_STOP_STATE) ? TRUE : FALSE)

#define FEEConfig_IsStopState(CfgPtr, Channel) (((FEEConfig_ReadReg((CfgPtr)->BaseAddress, CONTROL_ADDR_OFFSET + Channel * CHANNEL_OFFSET) & CONTROL_STATE_MASK) == STOP_STATE) ? TRUE : FALSE)

#define FEEConfig_IsRunState(CfgPtr, Channel) (((FEEConfig_ReadReg((CfgPtr)->BaseAddress, CONTROL_ADDR_OFFSET + Channel * CHANNEL_OFFSET) & CONTROL_STATE_MASK) == RUN_STATE) ? TRUE : FALSE)

#define FEE_IsNomalAcquireMode(CfgPtr, Channel) (((FEEConfig_ReadReg((CfgPtr)->BaseAddress, CONTROL_ADDR_OFFSET + Channel * CHANNEL_OFFSET) & ACQUIRE_MODE_MASK) == NORMAL_MODE) ? TRUE : FALSE)

#define FEEConfig_IsCombinedAcquireMode(CfgPtr, Channel) (((FEEConfig_ReadReg((CfgPtr)->BaseAddress, CONTROL_ADDR_OFFSET + Channel * CHANNEL_OFFSET) & ACQUIRE_MODE_MASK) == COMBINED_MODE) ? TRUE : FALSE)

#define FEEConfig_MaxTriggerLength(CfgPtr, Channel) ((FEEConfig_ReadReg((CfgPtr)->BaseAddress, CONTROL_ADDR_OFFSET + Channel * CHANNEL_OFFSET) & MAX_TRIGGER_LENGTH_MASK)

#define FEEConfig_RisingEdgeThreshold(CfgPtr, Channel) ((FEEConfig_ReadReg((CfgPtr)->BaseAddress, THRESHOLD_ADDR_OFFSET + Channel * CHANNEL_OFFSET) & RISE_THRE_MASK)
#define FEEConfig_FallingEdgeThreshold(CfgPtr, Channel) ((FEEConfig_ReadReg((CfgPtr)->BaseAddress, THRESHOLD_ADDR_OFFSET + Channel * CHANNEL_OFFSET) & FALL_THRE_MASK)

#define FEEConfig_RisingEdgeThreshold(CfgPtr, Channel) ((FEEConfig_ReadReg((CfgPtr)->BaseAddress, ACQUISITION_ADDR_OFFSET + Channel * CHANNEL_OFFSET) & PRE_ACQUI_LEN_MASK)
#define FEEConfig_FallingEdgeThreshold(CfgPtr, Channel) ((FEEConfig_ReadReg((CfgPtr)->BaseAddress, ACQUISITION_ADDR_OFFSET + Channel * CHANNEL_OFFSET) & POST_ACQUI_LEN_MASK)

#define FEEConfig_HgainBaseline(CfgPtr, Channel) ((FEEConfig_ReadReg((CfgPtr)->BaseAddress, BASELINE_ADDR_OFFSET + Channel * CHANNEL_OFFSET) & H_GAIN_BASELINE_MASK)
#define FEEConfig_LgainBaseline(CfgPtr, Channel) ((FEEConfig_ReadReg((CfgPtr)->BaseAddress, BASELINE_ADDR_OFFSET + Channel * CHANNEL_OFFSET) & L_GAIN_BASELINE_MASK)

int FEEConfig_SetConfigDefault(u16 DeviceId);
int FEEConfig_SetConfigDefaultBaseAddr(UINTPTR Baseaddr);
FEE_Config *FEEConfig_SetConfig(u16 DeviceId, u32 channel, u32 ControlAddr, u32 ThresholdAddr, u32 AcquisitionAddr, u32 BaselineAddr);
FEE_Config *FEEConfig_SetConfigBaseAddr(UINTPTR Baseaddr, u32 channel, u32 ControlAddr, u32 ThresholdAddr, u32 AcquisitionAddr, u32 BaselineAddr);

int FEEConfig_ApplyCfg(FEE_Config *CfgPtr);
int FEEConfig_Start(FEE_Config *CfgPtr);
int FEEConfig_Stop(FEE_Config *CfgPtr);

FEE_Config *FEEConfig_LookupConfig(u16 DeviceId);
FEE_Config *FEEConfig_LookupConfigBaseAddr(UINTPTR Baseaddr);

#endif
