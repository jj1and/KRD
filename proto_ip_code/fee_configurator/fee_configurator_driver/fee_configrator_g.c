#include "fee_configrator.h"
#include "xparameters.h"

FEE_Config FEE_ConfigTable[] = {{XPAR_FEE_CONFIGRATOR_0_DEVICE_ID,
                                 XPAR_FEE_CONFIGRATOR_0_S_AXI_CONFIG_BASEADDR,
                                 {DEFAULT_CONTROL_ADDR},
                                 {DEFAULT_THRESHOLD_ADDR},
                                 {DEFAULT_ACQUISITION_ADDR},
                                 {DEFAULT_BASELINE_ADDR}}};