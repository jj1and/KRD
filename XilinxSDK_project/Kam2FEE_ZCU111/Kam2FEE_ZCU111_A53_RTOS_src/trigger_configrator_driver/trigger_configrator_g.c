#include "trigger_configrator.h"
#include "xparameters.h"

u32 DefaultControlAddr[CHANNEL_NUM];
u32 DefaultThresholdAddr[CHANNEL_NUM];
u32 DefaultAcquisitionAddr[CHANNEL_NUM];
u32 DefaultBaselineAddr[CHANNEL_NUM];

Trigger_Config Trigger_ConfigTable[] = {{TRIGGER_CONFIGRATOR_0_DEVICE_ID,
                                         XPAR_TRIGGER_CONFIGRATOR_0_BASEADDR,
                                         DefaultControlAddr,
                                         DefaultThresholdAddr,
                                         DefaultAcquisitionAddr,
                                         DefaultBaselineAddr,
                                         DEFAULT_CONFIG}};
