#include "fee_configrator.h"

#include "xil_printf.h"
#include "xstatus.h"

int FEEConfig_SetConfigDefault(u16 DeviceId) {
    extern FEE_Config FEE_ConfigTable[];
    FEE_Config *CfgPtr = NULL;
    int Index;

    for (Index = 0; Index < FEE_CONFIGRATOR_NUM_INSTANCES; Index++) {
        if (FEE_ConfigTable[Index].DeviceId == DeviceId) {
            CfgPtr = &FEE_ConfigTable[Index];
            break;
        }
    }

    if (CfgPtr == NULL) {
        xil_printf("ERROR: FEE_Configrator device (Device ID:%d) is not found\r\n", DeviceId);
        return XST_FAILURE;
    } else {
        for (int i = 0; i < CHANNEL_NUM; i++) {
            CfgPtr->ControlAddr[i] = DEFAULT_CONTROL_CONFIG;
            CfgPtr->ThresholdAddr[i] = DEFAULT_THRESHOLD_CONFIG;
            CfgPtr->AcquisitionAddr[i] = DEFAULT_ACQUISITION_CONFIG;
            CfgPtr->BaselineAddr[i] = DEFAULT_BASELINE_CONFIG;
        }
    }
    return XST_SUCCESS;
}

int FEEConfig_SetConfigDefaultBaseAddr(UINTPTR Baseaddr) {
    extern FEE_Config FEE_ConfigTable[];
    FEE_Config *CfgPtr = NULL;
    int Index;

    for (Index = 0; Index < FEE_CONFIGRATOR_NUM_INSTANCES; Index++) {
        if (FEE_ConfigTable[Index].BaseAddress == Baseaddr) {
            CfgPtr = &FEE_ConfigTable[Index];
            break;
        }
    }

    if (CfgPtr == NULL) {
        xil_printf("ERROR: FEE_Configrator device (Base Address:%x) is not found\n The return will be NULL POINTER!!!!!!", Baseaddr);
        return XST_FAILURE;
    } else {
        for (int i = 0; i < CHANNEL_NUM; i++) {
            CfgPtr->ControlAddr[i] = DEFAULT_CONTROL_CONFIG;
            CfgPtr->ThresholdAddr[i] = DEFAULT_THRESHOLD_CONFIG;
            CfgPtr->AcquisitionAddr[i] = DEFAULT_ACQUISITION_CONFIG;
            CfgPtr->BaselineAddr[i] = DEFAULT_BASELINE_CONFIG;
        }
    }
    return XST_SUCCESS;
}

FEE_Config *FEEConfig_SetConfig(u16 DeviceId, u32 channel, u32 ControlAddr, u32 ThresholdAddr, u32 AcquisitionAddr, u32 BaselineAddr) {
    extern FEE_Config FEE_ConfigTable[];
    FEE_Config *CfgPtr = NULL;
    int Index;
    for (Index = 0; Index < FEE_CONFIGRATOR_NUM_INSTANCES; Index++) {
        if (FEE_ConfigTable[Index].DeviceId == DeviceId) {
            CfgPtr = &FEE_ConfigTable[Index];
            break;
        }
    }
    if (CfgPtr == NULL) {
        xil_printf("ERROR: FEE_Configrator device (Device ID:%d) is not found\n The return will be NULL POINTER!!!!!!", DeviceId);
    } else {
        int CfgChannel = -1;
        for (size_t i = 0; i < CHANNEL_NUM; i++) {
            if (channel == i) {
                CfgChannel = i;
                break;
            }
        }
        if (CfgChannel == -1) {
            xil_printf("ERROR: Ch %d in FEE is not found\r\n", channel);
            CfgChannel = 0;
        }

        CfgPtr->ControlAddr[CfgChannel] = ControlAddr;
        CfgPtr->ThresholdAddr[CfgChannel] = ThresholdAddr;
        CfgPtr->AcquisitionAddr[CfgChannel] = AcquisitionAddr;
        CfgPtr->BaselineAddr[CfgChannel] = BaselineAddr;
    }
    return (CfgPtr);
}

FEE_Config *FEEConfig_SetConfigBaseAddr(UINTPTR Baseaddr, u32 channel, u32 ControlAddr, u32 ThresholdAddr, u32 AcquisitionAddr, u32 BaselineAddr) {
    extern FEE_Config FEE_ConfigTable[];
    FEE_Config *CfgPtr = NULL;
    int Index;

    for (Index = 0; Index < FEE_CONFIGRATOR_NUM_INSTANCES; Index++) {
        if (FEE_ConfigTable[Index].BaseAddress == Baseaddr) {
            CfgPtr = &FEE_ConfigTable[Index];
            break;
        }
    }

    if (CfgPtr == NULL) {
        xil_printf("ERROR: FEE_Configrator device (Base Address:%x) is not found\n The return will be NULL POINTER!!!!!!", Baseaddr);
    } else {
        int CfgChannel = -1;
        for (size_t i = 0; i < CHANNEL_NUM; i++) {
            if (channel == i) {
                CfgChannel = i;
                break;
            }
        }
        if (CfgChannel == -1) {
            xil_printf("ERROR: Ch[%d] in FEE is not found\r\n", channel);
            CfgChannel = 0;
        }

        CfgPtr->ControlAddr[CfgChannel] = ControlAddr;
        CfgPtr->ThresholdAddr[CfgChannel] = ThresholdAddr;
        CfgPtr->AcquisitionAddr[CfgChannel] = AcquisitionAddr;
        CfgPtr->BaselineAddr[CfgChannel] = BaselineAddr;
    }
    return (CfgPtr);
}

int FEEConfig_ApplyCfg(FEE_Config *CfgPtr) {
    for (size_t i = 0; i < CHANNEL_NUM; i++) {
        FEEConfig_WriteReg(CfgPtr->BaseAddress, CONTROL_ADDR_OFFSET + i * CHANNEL_OFFSET, (CfgPtr->ControlAddr[i] & 0x003FFFFF) | CONFIG_STOP_STATE);
    }

    for (size_t i = 0; i < CHANNEL_NUM; i++) {
        if (FEEConfig_IsConfigState(CfgPtr, i)) {
            FEEConfig_WriteReg(CfgPtr->BaseAddress, CONTROL_ADDR_OFFSET + i * CHANNEL_OFFSET, (CfgPtr->ControlAddr[i] & 0x003FFFFF) | CONFIG_STOP_STATE);
            FEEConfig_WriteReg(CfgPtr->BaseAddress, THRESHOLD_ADDR_OFFSET + i * CHANNEL_OFFSET, CfgPtr->ThresholdAddr[i]);
            FEEConfig_WriteReg(CfgPtr->BaseAddress, ACQUISITION_ADDR_OFFSET + i * CHANNEL_OFFSET, CfgPtr->AcquisitionAddr[i]);
            FEEConfig_WriteReg(CfgPtr->BaseAddress, BASELINE_ADDR_OFFSET + i * CHANNEL_OFFSET, CfgPtr->BaselineAddr[i]);
        } else {
            xil_printf("ERROR: Failed to apply config to Ch[%d]\r\n", i);
            return XST_FAILURE;
        }
    }

    for (size_t i = 0; i < CHANNEL_NUM; i++) {
        FEEConfig_WriteReg(CfgPtr->BaseAddress, CONTROL_ADDR_OFFSET + i * CHANNEL_OFFSET, (CfgPtr->ControlAddr[i] & 0x003FFFFF) | STOP_STATE);
    }
    for (size_t i = 0; i < CHANNEL_NUM; i++) {
        if (!FEEConfig_IsStopState(CfgPtr, i)) {
            xil_printf("ERROR: Failed to stop Ch[%d]\r\n", i);
            return XST_FAILURE;
        }
    }
    return XST_SUCCESS;
}

int FEEConfig_Start(FEE_Config *CfgPtr) {
    for (size_t i = 0; i < CHANNEL_NUM; i++) {
        FEEConfig_WriteReg(CfgPtr->BaseAddress, CONTROL_ADDR_OFFSET + i * CHANNEL_OFFSET, (CfgPtr->ControlAddr[i] & 0x003FFFFF) | RUN_STATE);
    }
    for (size_t i = 0; i < CHANNEL_NUM; i++) {
        if (!FEEConfig_IsRunState(CfgPtr, i)) {
            xil_printf("ERROR: Failed to start Ch[%d]\r\n", i);
            return XST_FAILURE;
        }
    }
    return XST_SUCCESS;
}

int FEEConfig_Stop(FEE_Config *CfgPtr) {
    for (size_t i = 0; i < CHANNEL_NUM; i++) {
        FEEConfig_WriteReg(CfgPtr->BaseAddress, CONTROL_ADDR_OFFSET + i * CHANNEL_OFFSET, (CfgPtr->ControlAddr[i] & 0x003FFFFF) | STOP_STATE);
    }
    for (size_t i = 0; i < CHANNEL_NUM; i++) {
        if (!FEEConfig_IsStopState(CfgPtr, i)) {
            xil_printf("ERROR: Failed to stop Ch[%d]\r\n", i);
            return XST_FAILURE;
        }
    }
    return XST_SUCCESS;
}

FEE_Config *FEEConfig_LookupConfig(u16 DeviceId) {
    extern FEE_Config FEE_ConfigTable[];
    FEE_Config *CfgPtr = NULL;
    int Index;

    for (Index = 0; Index < FEE_CONFIGRATOR_NUM_INSTANCES; Index++) {
        if (FEE_ConfigTable[Index].DeviceId == DeviceId) {
            CfgPtr = &FEE_ConfigTable[Index];
            break;
        }
    }
    if (CfgPtr == NULL) {
        xil_printf("ERROR: FEE_Configrator device (Device ID:%d) is not found\n The return will be NULL POINTER!!!!!!", DeviceId);
    }
    return (CfgPtr);
}

FEE_Config *FEEConfig_LookupConfigBaseAddr(UINTPTR Baseaddr) {
    extern FEE_Config FEE_ConfigTable[];
    FEE_Config *CfgPtr = NULL;
    int Index;

    for (Index = 0; Index < FEE_CONFIGRATOR_NUM_INSTANCES; Index++) {
        if (FEE_ConfigTable[Index].BaseAddress == Baseaddr) {
            CfgPtr = &FEE_ConfigTable[Index];
            break;
        }
    }
    if (CfgPtr == NULL) {
        xil_printf("ERROR: FEE_Configrator device (Base Address:%x) is not found\n The return will be NULL POINTER!!!!!!", Baseaddr);
    }
    return (CfgPtr);
}
