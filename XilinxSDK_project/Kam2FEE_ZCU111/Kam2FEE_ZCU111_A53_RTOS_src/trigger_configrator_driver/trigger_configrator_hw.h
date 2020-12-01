#ifndef __TRIGGER_CONFIGRATOR_HW__
#define __TRIGGER_CONFIGRATOR_HW__

#include "xdebug.h"
#include "xil_io.h"
#include "xil_types.h"

#define TRIGGER_CONFIGRATOR_NUM_INSTANCES 1
#define TRIGGER_CONFIGRATOR_0_DEVICE_ID 0
#define XPAR_TRIGGER_CONFIGRATOR_0_BASEADDR XPAR_HARDWARE_TRIGGER_BLOCKS_TRIGGER_CONFIGRATOR_0_BASEADDR

#define CHANNEL_NUM 16
#define CHANNEL_OFFSET 0x00000010
#define CHANNEL_MASK 0x0000000F

#define CONTROL_ADDR_OFFSET 0x00000000
#define THRESHOLD_ADDR_OFFSET 0x00000004
#define ACQUISITION_ADDR_OFFSET 0x0000008
#define BASELINE_ADDR_OFFSET 0x0000000C
#define CONFIG_ADDR_OFFSET 0x00000100

#define CONTROL_STATE_MASK 0x00000040
#define RUN_STATE 0x00000000
#define STOP_STATE 0x00000040

#define ACQUIRE_MODE_MASK 0x00000030
#define NORMAL_MODE 0x00000000
#define COMBINED_MODE 0x00000010
#define DSP_NORMAL_MODE 0x00000020
#define DSP_COMBINED_MODE 0x00000030

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

#define Trigger_indent(RegOffset) ((((RegOffset) >= CONTROL_ADDR_OFFSET) && ((RegOffset) <= BASELINE_ADDR_OFFSET + (CHANNEL_NUM - 1) * CHANNEL_OFFSET)) ? "\t" : "")

#define Trigger_reg_name(RegOffset)                                                                  \
    (((RegOffset & CHANNEL_MASK) == CONTROL_ADDR_OFFSET)                                             \
         ? "CONTROL_ADDR_OFFSET"                                                                     \
         : ((RegOffset & CHANNEL_MASK) == THRESHOLD_ADDR_OFFSET)                                     \
               ? "THRESHOLD_ADDR_OFFSET"                                                             \
               : ((RegOffset & CHANNEL_MASK) == ACQUISITION_ADDR_OFFSET) ? "ACQUISITION_ADDR_OFFSET" \
                                                                         : ((RegOffset & CHANNEL_MASK) == BASELINE_ADDR_OFFSET) ? "BASELINE_ADDR_OFFSET" : "unknown")

#define Trigger_print_reg_o(BaseAddress, RegOffset, Value) \
    xdbg_printf(XDBG_DEBUG_GENERAL, "%s0x%0x -> %s(0x%0x)\n", Trigger_indent(RegOffset), (Value), Trigger_reg_name(RegOffset), (RegOffset))

#define Trigger_print_reg_i(BaseAddress, RegOffset, Value) \
    xdbg_printf(XDBG_DEBUG_GENERAL, "%s%s(0x%0x) -> 0x%0x\n", Trigger_indent(RegOffset), Trigger_reg_name(RegOffset), (RegOffset), (Value))

#ifdef DEBUG
#define Trigger_ReadReg(BaseAddress, RegOffset)                 \
    ({                                                          \
        u32 value;                                              \
        value = Xil_In32(((BaseAddress) + (RegOffset)));        \
        Trigger_print_reg_i((BaseAddress), (RegOffset), value); \
    })
#else
#define Trigger_ReadReg(BaseAddress, RegOffset) (Xil_In32(((BaseAddress) + (RegOffset))))
#endif

#ifdef DEBUG
#define Trigger_WriteReg(BaseAddress, RegOffset, Data)           \
    ({                                                           \
        Trigger_print_reg_o((BaseAddress), (RegOffset), (Data)); \
        Xil_Out32(((BaseAddress) + (RegOffset)), (Data));        \
    })
#else
#define Trigger_WriteReg(BaseAddress, RegOffset, Data) Xil_Out32(((BaseAddress) + (RegOffset)), (Data))
#endif

#endif
