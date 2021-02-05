#ifndef __TRIGGER_CONFIGRATOR_HW__
#define __TRIGGER_CONFIGRATOR_HW__

#include "xdebug.h"
#include "xil_io.h"
#include "xil_types.h"

/* register map for "CHANNEL_ID" Ch
        CONTROL_CONFIG : {25'b0, STOP, ACQUIRE_MODE[1:0], TRIGGER_TYPE[3:0]}
        THRESHOLD_ADDR : {RISING_EDGE_THRESHOLD, FALLIG_EDGE_THRESHOLD}
        ACQUISITION_ADDR : {{16-$clog2(MAX_PRE_ACQUISITION_LENGTH){1'b0}}, PRE_ACQUISITION_LENGTH, {16-$clog2(MAX_POST_ACQUISITION_LENGTH){1'b0}}, POST_ACQUISITION_LENGTH}
        BASELINE_ADDR : {3'b0, H_GAIN_BASELINE, L_GAIN_BASELINE}
        CONFIG_ADDR : {15'b0, SET_CONFIG, MAX_TRIGGER_LENGTH}
 */

#define CHANNEL_NUM 16
#define CHANNEL_OFFSET 0x00000010
#define CHANNEL_MASK 0x0000000F

#define CONTROL_ADDR_OFFSET 0x00000000
#define THRESHOLD_ADDR_OFFSET 0x00000004
#define ACQUISITION_ADDR_OFFSET 0x0000008
#define BASELINE_ADDR_OFFSET 0x0000000C
#define CONFIG_ADDR_OFFSET 0x00000100

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
