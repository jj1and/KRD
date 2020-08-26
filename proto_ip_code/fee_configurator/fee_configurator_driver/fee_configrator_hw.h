#ifndef __FEE_CONFIGRATOR_HW__
#define __FEE_CONFIGRATOR_HW__

#include "xdebug.h"
#include "xil_io.h"
#include "xil_types.h"

#define CHANNEL_NUM 1
#define CHANNEL_OFFSET 0x00000010
#define CHANNEL_MASK 0x0000000F

#define CONTROL_ADDR_OFFSET 0x00000000
#define THRESHOLD_ADDR_OFFSET 0x00000004
#define ACQUISITION_ADDR_OFFSET 0x0000008
#define BASELINE_ADDR_OFFSET 0x0000000C

#define CONTROL_STATE_MASK 0x00060000
#define CONFIG_MODE 0x00040000
#define STOP_MODE 0x00080000

#define ACQUIRE_MODE_MASK 0x00010000
#define NORMAL_MODE 0x00000000
#define COMBINED_MODE 0x00010000

#define MAX_TRIGGER_LENGTH_MASK 0x0000FFFF

#define RISE_THRE_MASK 0xFFFF0000
#define FALL_THRE_MASK 0x0000FFFF

#define PRE_ACQUI_LEN_MASK 0xFFFF0000
#define POST_ACQUI_LEN_MASK 0x0000FFFF

#define H_GAIN_BASELINE_MASK 0xFFFF0000
#define L_GAIN_BASELINE_MASK 0x0000FFFF

xdbg_stmnt(extern int indent_on);

#define FEEConfig_indent(RegOffset) ((indent_on && ((RegOffset) >= CONTROL_ADDR_OFFSET) && ((RegOffset) <= BASELINE_ADDR_OFFSET + (CHANNEL_NUM - 1) * CHANNEL_OFFSET)) ? "\t" : "")

#define FEEConfig_reg_name(RegOffset)                                                                \
    (((RegOffset & CHANNEL_MASK) == CONTROL_ADDR_OFFSET)                                             \
         ? "CONTROL_ADDR_OFFSET"                                                                     \
         : ((RegOffset & CHANNEL_MASK) == THRESHOLD_ADDR_OFFSET)                                     \
               ? "THRESHOLD_ADDR_OFFSET"                                                             \
               : ((RegOffset & CHANNEL_MASK) == ACQUISITION_ADDR_OFFSET) ? "ACQUISITION_ADDR_OFFSET" \
                                                                         : ((RegOffset & CHANNEL_MASK) == BASELINE_ADDR_OFFSET) ? "BASELINE_ADDR_OFFSET" : "unknown")

#define FEEConfig_print_reg_o(BaseAddress, RegOffset, Value) \
    xdbg_printf(XDBG_DEBUG_TEMAC_REG, "%s0x%0x -> %s(0x%0x)\n", FEEConfig_indent(RegOffset), (Value), FEEConfig_reg_name(RegOffset), (RegOffset))

#define FEEConfig_print_reg_i(BaseAddress, RegOffset, Value) \
    xdbg_printf(XDBG_DEBUG_TEMAC_REG, "%s%s(0x%0x) -> 0x%0x\n", FEEConfig_indent(RegOffset), FEEConfig_reg_name(RegOffset), (RegOffset), (Value))

#ifdef DEBUG
#define FEEConfig_ReadReg(BaseAddress, RegOffset)                 \
    ({                                                            \
        u32 value;                                                \
        value = Xil_In32(((BaseAddress) + (RegOffset)));          \
        FEEConfig_print_reg_i((BaseAddress), (RegOffset), value); \
    })
#else
#define FEEConfig_ReadReg(BaseAddress, RegOffset) (Xil_In32(((BaseAddress) + (RegOffset))))
#endif

#ifdef DEBUG
#define FEEConfig_WriteReg(BaseAddress, RegOffset, Data)           \
    ({                                                             \
        FEEConfig_print_reg_o((BaseAddress), (RegOffset), (Data)); \
        Xil_Out32(((BaseAddress) + (RegOffset)), (Data));          \
    })
#else
#define FEEConfig_WriteReg(BaseAddress, RegOffset, Data) Xil_Out32(((BaseAddress) + (RegOffset)), (Data))
#endif

#endif