#include "fee_configrator.h"
#include "xil_printf.h"
#include "xstatus.h"

int FEEConfig_SetConfigDefault(u16 DeviceId) {
    extern FEE_Config FEE_ConfigTable[];
    FEE_ConfigTable *CfgPtr = NULL;
    int Index;

    for (Index = 0; Index < XPAR_FEE_CONFIGRATOR_NUM_INSTANCES; Index++) {
        if (FEE_ConfigTable[Index].DeviceId == DeviceId) {
            CfgPtr = &FEE_ConfigTable[Index];
            break;
        }
    }

    if (CfgPtr == NULL) {
        xil_printf("FEE_Configrator device (Device ID:%d) is not found\r\n", DeviceId);
        return XST_FAILURE;
    } else {
        for (int i = 0; i < CHANNEL_NUM; i++) {
            CfgPtr->ControlAddr[i] = DEFAULT_CONTROL_ADDR;
            CfgPtr->ThresholdAddr[i] = DEFAULT_THRESHOLD_ADDR;
            CfgPtr->AcquisitionAddr[i] = DEFAULT_ACQUISITION_ADDR;
            CfgPtr->BaselineAddr[i] = DEFAULT_BASELINE_ADDR;
        }
    }
    return XST_SUCCESS;
}

int FEEConfig_SetConfigDefaultBaseAddr(UINTPTR Baseaddr) {
    extern FEE_Config FEE_ConfigTable[];
    FEE_ConfigTable *CfgPtr = NULL;
    int Index;

    for (Index = 0; Index < XPAR_FEE_CONFIGRATOR_NUM_INSTANCES; Index++) {
        if (FEE_ConfigTable[Index].BaseAddress == Baseaddr) {
            CfgPtr = &FEE_ConfigTable[Index];
            break;
        }
    }

    if (CfgPtr == NULL) {
        xil_printf("FEE_Configrator device (Device ID:%d) is not found\r\n", DeviceId);
        return XST_FAILURE;
    } else {
        for (int i = 0; i < CHANNEL_NUM; i++) {
            CfgPtr->ControlAddr[i] = DEFAULT_CONTROL_ADDR;
            CfgPtr->ThresholdAddr[i] = DEFAULT_THRESHOLD_ADDR;
            CfgPtr->AcquisitionAddr[i] = DEFAULT_ACQUISITION_ADDR;
            CfgPtr->BaselineAddr[i] = DEFAULT_BASELINE_ADDR;
        }
    }
    return XST_SUCCESS;
}

FEE_Config *FEEConfig_SetConfig(u16 DeviceId, u32 channel, u32 ControlAddr, u32 ThresholdAddr, u32 AcquisitionAddr, u32 BaselineAddr) {
    extern FEE_Config FEE_ConfigTable[];
    FEE_ConfigTable *CfgPtr = NULL;
    int Index;
    for (Index = 0; Index < XPAR_FEE_CONFIGRATOR_NUM_INSTANCES; Index++) {
        if (FEE_ConfigTable[Index].DeviceId == DeviceId) {
            CfgPtr = &FEE_ConfigTable[Index];
            break;
        }
    }
    if (CfgPtr == NULL) {
        xil_printf("FEE_Configrator device (Device ID:%d) is not found\n The return will be NULL POINTER!!!!!!", DeviceId);
    } else {
        if ()
            CfgPtr->ControlAddr = ControlAddr;
        CfgPtr->ThresholdAddr = ThresholdAddr;
        CfgPtr->AcquisitionAddr = AcquisitionAddr;
        CfgPtr->BaselineAddr = BaselineAddr;
    }
    return (CfgPtr);
}

FEE_Config *FEEConfig_SetConfigBaseAddr(UINTPTR Baseaddr, u32 channel, u32 ControlAddr, u32 ThresholdAddr, u32 AcquisitionAddr, u32 BaselineAddr) {
    extern FEE_Config FEE_ConfigTable[];
    FEE_ConfigTable *CfgPtr = NULL;
    int Index;

    for (Index = 0; Index < XPAR_FEE_CONFIGRATOR_NUM_INSTANCES; Index++) {
        if (FEE_ConfigTable[Index].BaseAddress == Baseaddr) {
            CfgPtr = &FEE_ConfigTable[Index];
            break;
        }
    }

    if (CfgPtr == NULL) {
        xil_printf("FEE_Configrator device (Base Address:%x) is not found\n The return will be NULL POINTER!!!!!!", Baseaddr);
    } else {
        CfgPtr->ControlAddr = ControlAddr;
        CfgPtr->ThresholdAddr = ThresholdAddr;
        CfgPtr->AcquisitionAddr = AcquisitionAddr;
        CfgPtr->BaselineAddr = BaselineAddr;
    }
    return (CfgPtr);
}

int EtherframeGen_ApplyCfg(EtherframeGen_Config *CfgPtr) {
    EtherframeGen_WriteReg(CfgPtr->BaseAddress, SET_MODE_OFFSET, CONFIG_MODE_MASK);
    if (EtherframeGen_IsConfigMode(CfgPtr)) {
        EtherframeGen_WriteReg(CfgPtr->BaseAddress, CONTROL_ADDR_OFFSET, CfgPtr->DestMacAddr);
        EtherframeGen_WriteReg(CfgPtr->BaseAddress, THRESHOLD_ADDR_OFFSET, CfgPtr->SrcMacAddr);
        EtherframeGen_WriteReg(CfgPtr->BaseAddress, ETHERTYPE_OFFSET, CfgPtr->EtherType);
        return XST_SUCCESS;
    }
    xil_printf("Failed to apply config");
    return XST_FAILURE;
}

int EtherframeGen_Start(EtherframeGen_Config *CfgPtr) {
    FEEConfig_WriteReg(CfgPtr->BaseAddress, SET_MODE_OFFSET, RUN_MODE_MASK);
    if (EtherframeGen_IsRunMode(CfgPtr))
        return XST_SUCCESS;
    return XST_FAILURE;
}

int EtherframeGen_Stop(EtherframeGen_Config *CfgPtr) {
    FEEConfig_WriteReg(CfgPtr->BaseAddress, SET_MODE_OFFSET, STOP_MODE_MASK);
    if (EtherframeGen_IsStopMode(CfgPtr))
        return XST_SUCCESS;
    return XST_FAILURE;
}

EtherframeGen_Config *EtherframeGen_LookupConfig(u16 DeviceId) {
    extern EtherframeGen_Config EtherframeGen_ConfigTable[];
    EtherframeGen_Config *CfgPtr = NULL;
    int Index;

    for (Index = 0; Index < XPAR_ETHERNET_FRAME_GEN_NUM_INSTANCES; Index++) {
        if (EtherframeGen_ConfigTable[Index].DeviceId == DeviceId) {
            CfgPtr = &EtherframeGen_ConfigTable[Index];
            break;
        }
    }

    return (CfgPtr);
}

EtherframeGen_Config *EtherframeGen_LookupConfigBaseAddr(UINTPTR Baseaddr) {
    extern EtherframeGen_Config EtherframeGen_ConfigTable[];
    EtherframeGen_Config *CfgPtr = NULL;
    int Index;

    for (Index = 0; Index < XPAR_ETHERNET_FRAME_GEN_NUM_INSTANCES; Index++) {
        if (EtherframeGen_ConfigTable[Index].BaseAddress == Baseaddr) {
            CfgPtr = &EtherframeGen_ConfigTable[Index];
            break;
        }
    }

    return (CfgPtr);
}
