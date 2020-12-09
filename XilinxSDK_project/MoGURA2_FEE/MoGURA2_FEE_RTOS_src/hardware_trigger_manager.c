#include "hardware_trigger_manager.h"

#include "trigger_configrator_driver/trigger_configrator.h"
#include "xil_printf.h"
#include "xstatus.h"

#define FEE_DEBUG

u32 reverse_byte(u32 data) {
    u32 rdata = 0x00000000;

    for (int byte = 0; byte < sizeof(u32); byte++) {
        rdata = rdata | ((data & (0x000000FF << 8 * byte)) << 8 * (sizeof(u32) - 1 - byte));
    }

    return rdata;
}

int SetSwitchThreshold(short int upper_threshold, short int lower_threshold) {
    int Status;
    Status = XGpio_Initialize(&Gpio_mode_switch_thre, GAIN_SWITCH_CONFIG_GPIO_DEVICE_ID);
    if (Status != XST_SUCCESS) {
        xil_printf("ERROR: Failed to initialize gain switch setting GPIO\r\n");
        return XST_FAILURE;
    }
    XGpio_SetDataDirection(&Gpio_mode_switch_thre, 1, 0x0);
    XGpio_SetDataDirection(&Gpio_mode_switch_thre, 2, 0x0);
    if ((upper_threshold > 2047) | (lower_threshold < -2048)) {
        xil_printf("ERROR: Invalid gain switch upper threshold: %d\r\n", upper_threshold);
        return XST_INVALID_PARAM;
    } else {
        XGpio_DiscreteWrite(&Gpio_mode_switch_thre, MODE_SWITCH_UPPER_THRE_CH, upper_threshold);
        xil_printf("INFO: Set gain switch upper threshold: %d\r\n", upper_threshold);
    }
    if ((lower_threshold > upper_threshold) | (lower_threshold < -2048)) {
        xil_printf("ERROR: Invalid gain switch lower threshold: %d\r\n", lower_threshold);
        return XST_INVALID_PARAM;
    } else {
        XGpio_DiscreteWrite(&Gpio_mode_switch_thre, MODE_SWITCH_LOWER_THRE_CH, lower_threshold);
        xil_printf("INFO: Set gain switch lower threshold: %d\r\n", lower_threshold);
    }
    return XST_SUCCESS;
}

int HardwareTrigger_SetupDeviceId(u16 TriggerdeviceId, TriggerManager_Config TriggerManagerConfig) {
    Trigger_Config *CfgPtr = NULL;
    int Status;

    Status = Trigger_SetConfigDefault(TriggerdeviceId);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    Channel_Config ChannelConfig;
    u32 ControlAddr;
    u32 ThresholdAddr;
    u32 AcquisitionAddr;
    u32 BaselineAddr;

    for (size_t i = 0; i < TriggerManagerConfig.ChannelNum; i++) {
        ChannelConfig = TriggerManagerConfig.ChanelConfigs[i];
        ControlAddr = ((ChannelConfig.AcquireMode << 4) & ACQUIRE_MODE_MASK) | (ChannelConfig.TriggerType & TRIGGER_TYPE_MASK) | STOP_STATE;
        ThresholdAddr = ((ChannelConfig.RisingEdgeThreshold << 16) & 0xFFFF0000) | (ChannelConfig.FallingEdgeThreshold & 0x0000FFFF);
        AcquisitionAddr = ((ChannelConfig.PreAcquisitionLength << 16) & 0xFFFF0000) | (ChannelConfig.PostAcquisitionLength & 0x0000FFFF);
        BaselineAddr = ((ChannelConfig.HgainBaseline << 16) & 0xFFFF0000) | (ChannelConfig.LgainBaseline & 0x0000FFFF);

#ifdef FEE_DEBUG
        xil_printf("INFO: Channel[%d]\r\n", ChannelConfig.channel);
        xil_printf("INFO: ControlReg: 0x%08x\r\n", ControlAddr);
        xil_printf("INFO: ThresholdReg: 0x%08x\r\n", ThresholdAddr);
        xil_printf("INFO: AcquisitionReg: 0x%08x\r\n", AcquisitionAddr);
        xil_printf("INFO: BaselineReg: 0x%08x\r\n", BaselineAddr);
#endif

        CfgPtr = Trigger_ChannelConfig(TriggerdeviceId, ChannelConfig.channel, ControlAddr, ThresholdAddr, AcquisitionAddr, BaselineAddr);
    }

    if (Trigger_MaxLengthConfig(TriggerdeviceId, TriggerManagerConfig.MaxTriggerLength) != XST_SUCCESS) return XST_FAILURE;
#ifdef FEE_DEBUG
    xil_printf("INFO: ConfigAddrReg: 0x%08x\r\n", CfgPtr->ConfigAddr);
#endif

    return Trigger_ApplyCfg(CfgPtr);
}

int HardwareTrigger_StartDeviceId(u16 TriggerdeviceId) {
    Trigger_Config *CfgPtr = NULL;
    CfgPtr = Trigger_LookupConfig(TriggerdeviceId);
    if (CfgPtr == NULL)
        return XST_FAILURE;
    return Trigger_Start(CfgPtr);
}

int HardwareTrigger_StopDeviceId(u16 TriggerdeviceId) {
    Trigger_Config *CfgPtr = NULL;
    CfgPtr = Trigger_LookupConfig(TriggerdeviceId);
    if (CfgPtr == NULL)
        return XST_FAILURE;
    return Trigger_Stop(CfgPtr);
}
