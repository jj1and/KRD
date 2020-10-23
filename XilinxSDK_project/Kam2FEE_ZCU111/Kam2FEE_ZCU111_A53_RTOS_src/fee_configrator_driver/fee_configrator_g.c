#include "fee_configrator.h"
#include "xparameters.h"

u32 DefaultControlAddr[CHANNEL_NUM];
u32 DefaultThresholdAddr[CHANNEL_NUM];
u32 DefaultAcquisitionAddr[CHANNEL_NUM];
u32 DefaultBaselineAddr[CHANNEL_NUM];

FEE_Config FEE_ConfigTable[] = {{FEE_CONFIGRATOR_0_DEVICE_ID,
                                 XPAR_FEE_CONFIGRATOR_0_BASEADDR,
                                 DefaultControlAddr,
                                 DefaultThresholdAddr,
                                 DefaultAcquisitionAddr,
                                 DefaultBaselineAddr}};