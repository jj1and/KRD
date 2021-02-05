#ifndef __PERIPHERAL_CONTROLLER_HW__
#define __PERIPHERAL_CONTROLLER_HW__

#include "xdebug.h"
#include "xil_io.h"
#include "xil_types.h"

#define CDCI6214_GPIO_ADDR_OFFSET 0x00000000
#define GPO_ADDR_OFFSET 0x00000004
#define GPI_ADDR_OFFSET 0x00000008
#define LADC_CTRL_ADDR_OFFSET 0x0000000C
#define LADC_RESET_ADDR_OFFSET 0x00000010
#define LADC_SEN_ADDR_OFFSET 0x00000014
#define SFP1_GPIO_ADDR_OFFSET 0x000018
#define SFP2_GPIO_ADDR_OFFSET 0x00001C

#define Peripheral_indent(RegOffset) ((((RegOffset) >= CDCI6214_GPIO_ADDR_OFFSET) && ((RegOffset) <= SFP2_GPIO_ADDR_OFFSET)) ? "\t" : "")

#define Preipheral_reg_name(RegOffset)                                                \
    (((RegOffset) == CDCI6214_GPIO_ADDR_OFFSET)                                       \
         ? "CDCI6214_GPIO_ADDR_OFFSET"                                                \
         : ((RegOffset) == GPO_ADDR_OFFSET)                                           \
               ? "GPO_ADDR_OFFSET"                                                    \
               : ((RegOffset) == GPI_ADDR_OFFSET)                                     \
                     ? "GPI_ADDR_OFFSET"                                              \
                     : ((RegOffset) == LADC_CTRL_ADDR_OFFSET)                         \
                           ? "LADC_CTRL_ADDR_OFFSET"                                  \
                           : ((RegOffset) == LADC_RESET_ADDR_OFFSET)                  \
                                 ? "LADC_RESET_ADDR_OFFSET"                           \
                                 : ((RegOffset) == LADC_SEN_ADDR_OFFSET)              \
                                       ? "LADC_SEN_ADDR_OFFSET"                       \
                                       : ((RegOffset) == SFP1_GPIO_ADDR_OFFSET)       \
                                             ? "SFP1_GPIO_ADDR_OFFSET"                \
                                             : ((RegOffset) == SFP2_GPIO_ADDR_OFFSET) \
                                                   ? "SFP2_GPIO_ADDR_OFFSET"          \
                                                   : "unknown")

#define Peripheral_reg_o_print(BaseAddress, RegOffset, Value) \
    xdbg_printf(XDBG_DEBUG_GENERAL, "%s0x%0x -> %s(0x%0x)\n", Peripheral_indent(RegOffset), (Value), Preipheral_reg_name(RegOffset), (RegOffset))

#define Peripheral_reg_i_print(BaseAddress, RegOffset, Value) \
    xdbg_printf(XDBG_DEBUG_GENERAL, "%s%s(0x%0x) -> 0x%0x\n", Peripheral_indent(RegOffset), Preipheral_reg_name(RegOffset), (RegOffset), (Value))

#ifdef DEBUG
#define Peripheral_ReadReg(BaseAddress, RegOffset)                 \
    ({                                                             \
        u32 value;                                                 \
        value = Xil_In32(((BaseAddress) + (RegOffset)));           \
        Peripheral_reg_i_print((BaseAddress), (RegOffset), value); \
    })
#else
#define Peripheral_ReadReg(BaseAddress, RegOffset) (Xil_In32(((BaseAddress) + (RegOffset))))
#endif

#ifdef DEBUG
#define Peripheral_WriteReg(BaseAddress, RegOffset, Data)           \
    ({                                                              \
        Peripheral_reg_o_print((BaseAddress), (RegOffset), (Data)); \
        Xil_Out32(((BaseAddress) + (RegOffset)), (Data));           \
    })
#else
#define Peripheral_WriteReg(BaseAddress, RegOffset, Data) Xil_Out32(((BaseAddress) + (RegOffset)), (Data))
#endif

#endif  // !__PERIPHERAL_CONTROLLER_HW__
