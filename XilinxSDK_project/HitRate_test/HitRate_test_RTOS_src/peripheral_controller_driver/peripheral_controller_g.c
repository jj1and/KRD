#include "peripheral_controller.h"
#include "peripheral_controller_hw.h"
#include "xparameters.h"

Peripheral_Config Peripheral_ConfigTable[] = {{PERIPHERAL_CONTROLLER_0_DEVICE_ID,
                                               XPAR_PERIPHERAL_CTRL_BLOCK_PERIPHERAL_CONTROLER_0_BASEADDR,
                                               DEFAULT_CDCI6214_GPIO_CONFIG,
                                               DEFALUT_GPO_CONFIG,
                                               0,
                                               DEFAULT_LADC_CTRL_CONFIG,
                                               DEFAULT_SFP_CONFIG,
                                               DEFAULT_SFP_CONFIG}};