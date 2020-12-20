#include "hardware_trigger_manager.h"

#include "trigger_configrator_driver/trigger_configrator.h"
#include "xil_cache.h"
#include "xil_printf.h"
#include "xstatus.h"

#define FEE_DEBUG

static XGpio Gpio_mode_switch_thre;
static int fee_state_flag = FEE_STOPPED;

u32 reverse_byte(u32 data) {
    u32 rdata = 0x00000000;

    for (int byte = 0; byte < sizeof(u32); byte++) {
        rdata = rdata | ((data & (0x000000FF << 8 * byte)) << 8 * (sizeof(u32) - 1 - byte));
    }

    return rdata;
}

static void printData(u64 *dataptr, u64 frame_size) {
    xil_printf("Rcvd : %016llx ", dataptr[0]);
    xil_printf("%016llx (Header)\n", dataptr[1]);
    for (int i = 2; i < frame_size - 1; i++) {
        for (int j = 0; j < 4; j++) {
            if (((i - 2) * 4 + j) % 8 == 0) {
                xil_printf("Rcvd : %04x ", (dataptr[i] >> (3 - j) * 16) & 0x000000000000FFFF);
            } else if (((i - 2) * 4 + j + 1) % 8 == 0) {
                xil_printf("%04x\n", (dataptr[i] >> (3 - j) * 16) & 0x000000000000FFFF);
            } else {
                xil_printf("%04x ", (dataptr[i] >> (3 - j) * 16) & 0x000000000000FFFF);
            }
        }
    }
    xil_printf("Rcvd : %016llx (Footer)\n", dataptr[frame_size - 1]);
    xil_printf("\r\n");
}

int checkData(u64 *dataptr, TriggerManager_Config fee_config, int print_enable, u64 *rcvd_frame_length) {
    int Status = XST_SUCCESS;
    u8 read_channel_id;
    u8 read_header_id;
    u64 read_header_timestamp;
    u8 read_trigger_info;
    u16 read_trigger_length;
    int read_raw_charge_sum;
    int read_charge_sum;
    short int read_fall_thre;
    short int read_rise_thre;
    u64 read_footer_timestamp;
    u32 read_object_id;
    u8 read_footer_id;

    Xil_DCacheFlushRange((UINTPTR)dataptr, (MAX_TRIGGER_LEN * 2 + 4) * sizeof(u64));
    read_header_timestamp = (dataptr[0] & 0x00FFFFFF);
    read_trigger_info = (dataptr[0] >> 24) & 0x000000FF;
    read_trigger_length = (dataptr[0] >> (24 + 8)) & 0x00000FFF;
    read_channel_id = (dataptr[0] >> (24 + 8 + 12)) & 0x00000FFF;
    read_header_id = (dataptr[0] >> (24 + 8 + 12 + 12)) & 0x000000FF;
    read_raw_charge_sum = (dataptr[1] >> 32) & 0x00FFFFFF;
    read_charge_sum = (read_raw_charge_sum << 8) >> 8;  // sign extention
    read_fall_thre = (dataptr[1] & 0x0000FFFF);
    read_rise_thre = (dataptr[1] >> 16) & 0x0000FFFF;

    read_footer_id = (dataptr[read_trigger_length + 3 - 1] >> 56) & 0x000000FF;
    read_object_id = dataptr[read_trigger_length + 3 - 1] & 0xFFFFFFFF;
    read_footer_timestamp = ((dataptr[read_trigger_length + 3 - 1] & 0x00FFFFFF00000000) >> 8) & 0x00000FFFFFF000000;

    if (print_enable > 1) {
        printData(dataptr, read_trigger_length + 3);
    }
    if (print_enable > 0) {
        xil_printf("Rcvd frame  signal_length:%4u, timestamp:%5u, trigger_info:%2x, falling_edge_threshold:%4d, rising_edge_threshold:%4d, object_id:%4u\r\n", read_trigger_length * 4,
                   read_footer_timestamp + read_header_timestamp, read_trigger_info, read_fall_thre, read_rise_thre, read_object_id);
    }
    if (read_object_id == 0) {
        // read_trigger_info = {TRIGGER_STATE[1:0], FRAME_BEGIN[0], FRAME_CONTINUE[0], TRIGGER_TYPE[3:0]}
        // read_trigger_info & 8'b1100_0000 == 8'b1100_0000
        // left: mask except trigger state
        // right: trigger state must be 2'b01 at first frame
        if ((read_trigger_info & 0xC0) == 0xC0) {
            xil_printf("trigger_info invalid Data: %2x Valid: %2x or %2x\r\n", read_trigger_info & 0x40, 0x40, 0xC0);
            Status = XST_FAILURE;
        } else if ((read_trigger_info & 0x10) == 0x00) {
            // read_trigger_info = {TRIGGER_STATE[1:0], FRAME_BEGIN[0], FRAME_CONTINUE[0], TRIGGER_TYPE[3:0]}
            // read_trigger_info & 8'b0001_0000 == 8'b0000_0000
            // left: mask except frame_continure
            // right: trigger state = 2'b10 (halt) and frame continue means frame generator fifo is full
            //            xil_printf("trigger_info indicates this is last frame\r\n", read_trigger_info);
            Status = LAST_FRAME;
        }

    } else if ((read_trigger_info & 0x10) == 0x00) {
        // read_trigger_info = {TRIGGER_STATE[1:0], FRAME_BEGIN[0], FRAME_CONTINUE[0], TRIGGER_TYPE[3:0]}
        // read_trigger_info & 8'b0001_0000 == 8'b0000_0000
        // left: mask except frame_continure
        // right: trigger state = 2'b10 (halt) and frame continue means frame generator fifo is full
        //            xil_printf("trigger_info indicates this is last frame\r\n", read_trigger_info);
        Status = LAST_FRAME;
    }

    if ((read_trigger_info & 0xC0) == 0x80) {
        // read_trigger_info = {TRIGGER_STATE[1:0], FRAME_BEGIN[0], FRAME_CONTINUE[0], TRIGGER_TYPE[3:0]}
        // read_trigger_info & 8'b1100_0000 == 8'b1000_0000
        // left: mask except frame_continure
        // right: trigger state = 2'b10 (halt) and frame continue means frame generator fifo is full
        // printData(dataptr, read_trigger_length + 3);
        Status = INTERNAL_BUFFER_FULL;
    }

    if (read_header_id != 0xAA) {
        xil_printf("HEADER_ID mismatch Data: %2x Expected: %2x\r\n", read_header_id, 0xAA);
        Status = XST_FAILURE;
    }

    if (read_channel_id >= 16) {
        xil_printf("CHANNEL_ID invalid: Channel ID must be smaller than 16 Data :%2x\r\n", read_channel_id);
    } else {
        if (read_rise_thre != fee_config.ChanelConfigs[read_channel_id].RisingEdgeThreshold) {
            xil_printf("threshold mismatch Data: %d Expected: %d\r\n", read_rise_thre, fee_config.ChanelConfigs[read_channel_id].RisingEdgeThreshold);
            Status = XST_FAILURE;
        }

        if (read_fall_thre != fee_config.ChanelConfigs[read_channel_id].FallingEdgeThreshold) {
            xil_printf("fall_thre mismatch Data: %d Expected: %d\r\n", read_fall_thre, fee_config.ChanelConfigs[read_channel_id].FallingEdgeThreshold);
            Status = XST_FAILURE;
        }
    }

    if (read_footer_id != 0x55) {
        xil_printf("FOOTER_ID mismatch Data: %2x Expected: %2x\r\n", read_footer_id, 0x55);
        printData(dataptr, read_trigger_length + 3);
        Status = XST_FAILURE;
    }

    *rcvd_frame_length = read_trigger_length + 4;
    incr_wrptr_after_write(read_trigger_length + 4);
    //    xil_printf("\n");
    return Status;
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

int HardwareTrigger_SetupDeviceId(u16 TriggerdeviceId, TriggerManager_Config *TMCfgPtr) {
    Trigger_Config *CfgPtr = NULL;
    int Status;

    if (TMCfgPtr == NULL) {
        xil_printf("ERROR: got Trigger Manager Config pointer in argument\r\n");
        return XST_FAILURE;
    }

    Status = Trigger_SetConfigDefault(TriggerdeviceId);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    Channel_Config ChannelConfig;
    u32 ControlAddr;
    u32 ThresholdAddr;
    u32 AcquisitionAddr;
    u32 BaselineAddr;

    for (size_t i = 0; i < TMCfgPtr->ChannelNum; i++) {
        ChannelConfig = TMCfgPtr->ChanelConfigs[i];
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
        if (CfgPtr == NULL) {
            xil_printf("ERROR: failed to get Trigger Config pointer\r\n");
            return XST_FAILURE;
        }
    }

    if (Trigger_MaxLengthConfig(TriggerdeviceId, TMCfgPtr->MaxTriggerLength) != XST_SUCCESS) return XST_FAILURE;
#ifdef FEE_DEBUG
    xil_printf("INFO: ConfigAddrReg: 0x%08x\r\n", CfgPtr->ConfigAddr);
#endif

    return Trigger_ApplyCfg(CfgPtr);
}

int HardwareTrigger_StartDeviceId(u16 TriggerdeviceId, u16 ch) {
    Trigger_Config *CfgPtr = NULL;
    CfgPtr = Trigger_LookupConfig(TriggerdeviceId);
    if (CfgPtr == NULL)
        return XST_FAILURE;
    // when any channel runs, the state is defined as RUNNIG
    fee_state_flag = FEE_RUNNING;
    return Trigger_Start(CfgPtr, ch);
}

int HardwareTrigger_StopDeviceId(u16 TriggerdeviceId, u16 ch) {
    Trigger_Config *CfgPtr = NULL;
    CfgPtr = Trigger_LookupConfig(TriggerdeviceId);
    if (CfgPtr == NULL)
        return XST_FAILURE;
    fee_state_flag = FEE_STOPPED;
    return Trigger_Stop(CfgPtr, ch);
}

int HardwareTrigger_StartDeviceIdAllCh(u16 TriggerdeviceId) {
    Trigger_Config *CfgPtr = NULL;
    CfgPtr = Trigger_LookupConfig(TriggerdeviceId);
    if (CfgPtr == NULL)
        return XST_FAILURE;
    fee_state_flag = FEE_RUNNING;
    return Trigger_StartAllCh(CfgPtr);
}

int HardwareTrigger_StopDeviceIdAllCh(u16 TriggerdeviceId) {
    Trigger_Config *CfgPtr = NULL;
    CfgPtr = Trigger_LookupConfig(TriggerdeviceId);
    if (CfgPtr == NULL)
        return XST_FAILURE;
    fee_state_flag = FEE_STOPPED;
    return Trigger_StopAllCh(CfgPtr);
}

int getFeeState() {
    return fee_state_flag;
}
