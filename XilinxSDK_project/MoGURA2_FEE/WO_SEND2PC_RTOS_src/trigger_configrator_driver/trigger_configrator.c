#include "trigger_configrator.h"

#include "trigger_configrator_hw.h"
#include "unistd.h"
#include "xil_printf.h"
#include "xstatus.h"

#define Trigger_BaseAddress(CfgPtr) ((CfgPtr)->BaseAddress)

#define Trigger_IsConfigState(CfgPtr) (((Trigger_ReadReg((CfgPtr)->BaseAddress, CONFIG_ADDR_OFFSET) & CONFIG_STATE_MASK) == CONFIG_STATE) ? TRUE : FALSE)

#define Trigger_IsStopState(CfgPtr, Channel) (((Trigger_ReadReg((CfgPtr)->BaseAddress, CONTROL_ADDR_OFFSET + Channel * CHANNEL_OFFSET) & CONTROL_STATE_MASK) == STOP_STATE) ? TRUE : FALSE)

#define Trigger_IsRunState(CfgPtr, Channel) (((Trigger_ReadReg((CfgPtr)->BaseAddress, CONTROL_ADDR_OFFSET + Channel * CHANNEL_OFFSET) & CONTROL_STATE_MASK) == RUN_STATE) ? TRUE : FALSE)

#define FEE_IsNomalAcquireMode(CfgPtr, Channel) (((Trigger_ReadReg((CfgPtr)->BaseAddress, CONTROL_ADDR_OFFSET + Channel * CHANNEL_OFFSET) & ACQUIRE_MODE_MASK) == NORMAL_MODE) ? TRUE : FALSE)

#define Trigger_IsCombinedAcquireMode(CfgPtr, Channel) (((Trigger_ReadReg((CfgPtr)->BaseAddress, CONTROL_ADDR_OFFSET + Channel * CHANNEL_OFFSET) & ACQUIRE_MODE_MASK) == COMBINED_MODE) ? TRUE : FALSE)

#define Trigger_MaxTriggerLength(CfgPtr) ((Trigger_ReadReg((CfgPtr)->BaseAddress, CONFIG_ADDR_OFFSET) & MAX_TRIGGER_LENGTH_MASK)

#define Trigger_RisingEdgeThreshold(CfgPtr, Channel) ((Trigger_ReadReg((CfgPtr)->BaseAddress, THRESHOLD_ADDR_OFFSET + Channel * CHANNEL_OFFSET) & RISE_THRE_MASK)
#define Trigger_FallingEdgeThreshold(CfgPtr, Channel) ((Trigger_ReadReg((CfgPtr)->BaseAddress, THRESHOLD_ADDR_OFFSET + Channel * CHANNEL_OFFSET) & FALL_THRE_MASK)

#define Trigger_PreAcquisition(CfgPtr, Channel) ((Trigger_ReadReg((CfgPtr)->BaseAddress, ACQUISITION_ADDR_OFFSET + Channel * CHANNEL_OFFSET) & PRE_ACQUI_LEN_MASK)
#define Trigger_PostAcquisition(CfgPtr, Channel) ((Trigger_ReadReg((CfgPtr)->BaseAddress, ACQUISITION_ADDR_OFFSET + Channel * CHANNEL_OFFSET) & POST_ACQUI_LEN_MASK)

#define Trigger_HgainBaseline(CfgPtr, Channel) ((Trigger_ReadReg((CfgPtr)->BaseAddress, BASELINE_ADDR_OFFSET + Channel * CHANNEL_OFFSET) & H_GAIN_BASELINE_MASK)
#define Trigger_LgainBaseline(CfgPtr, Channel) ((Trigger_ReadReg((CfgPtr)->BaseAddress, BASELINE_ADDR_OFFSET + Channel * CHANNEL_OFFSET) & L_GAIN_BASELINE_MASK)

int Trigger_SetConfigDefault(u16 DeviceId) {
    extern Trigger_Config Trigger_ConfigTable[];
    Trigger_Config *CfgPtr = NULL;
    int Index;

    for (Index = 0; Index < TRIGGER_CONFIGRATOR_NUM_INSTANCES; Index++) {
        if (Trigger_ConfigTable[Index].DeviceId == DeviceId) {
            CfgPtr = &Trigger_ConfigTable[Index];
            break;
        }
    }

    if (CfgPtr == NULL) {
        xil_printf("ERROR: Trigger_Configrator device (Device ID:%d) is not found\r\n", DeviceId);
        return XST_FAILURE;
    } else {
        for (int i = 0; i < CHANNEL_NUM; i++) {
            CfgPtr->ControlAddr[i] = DEFAULT_CONTROL_CONFIG;
            CfgPtr->ThresholdAddr[i] = DEFAULT_THRESHOLD_CONFIG;
            CfgPtr->AcquisitionAddr[i] = DEFAULT_ACQUISITION_CONFIG;
            CfgPtr->BaselineAddr[i] = DEFAULT_BASELINE_CONFIG;
        }
        CfgPtr->ConfigAddr = DEFAULT_CONFIG;
    }
    return XST_SUCCESS;
}

int Trigger_SetConfigDefaultBaseAddr(UINTPTR Baseaddr) {
    extern Trigger_Config Trigger_ConfigTable[];
    Trigger_Config *CfgPtr = NULL;
    int Index;

    for (Index = 0; Index < TRIGGER_CONFIGRATOR_NUM_INSTANCES; Index++) {
        if (Trigger_ConfigTable[Index].BaseAddress == Baseaddr) {
            CfgPtr = &Trigger_ConfigTable[Index];
            break;
        }
    }

    if (CfgPtr == NULL) {
        xil_printf("ERROR: Trigger_Configrator device (Base Address:%x) is not found\n The return will be NULL POINTER!!!!!!", Baseaddr);
        return XST_FAILURE;
    } else {
        for (int i = 0; i < CHANNEL_NUM; i++) {
            CfgPtr->ControlAddr[i] = DEFAULT_CONTROL_CONFIG;
            CfgPtr->ThresholdAddr[i] = DEFAULT_THRESHOLD_CONFIG;
            CfgPtr->AcquisitionAddr[i] = DEFAULT_ACQUISITION_CONFIG;
            CfgPtr->BaselineAddr[i] = DEFAULT_BASELINE_CONFIG;
        }
        CfgPtr->ConfigAddr = DEFAULT_CONFIG;
    }
    return XST_SUCCESS;
}

int Trigger_MaxLengthConfig(u16 DeviceId, u32 MaxTriggerLength) {
    extern Trigger_Config Trigger_ConfigTable[];
    Trigger_Config *CfgPtr = NULL;
    int Index;
    for (Index = 0; Index < TRIGGER_CONFIGRATOR_NUM_INSTANCES; Index++) {
        if (Trigger_ConfigTable[Index].DeviceId == DeviceId) {
            CfgPtr = &Trigger_ConfigTable[Index];
            break;
        }
    }
    if (CfgPtr == NULL) {
        xil_printf("ERROR: Trigger_Configrator device (Device ID:%d) is not found\n", DeviceId);
        return XST_FAILURE;
    } else {
        CfgPtr->ConfigAddr = (MaxTriggerLength & MAX_TRIGGER_LENGTH_MASK) | CONFIG_FIXED_STATE;
    }
    return XST_SUCCESS;
}

int Trigger_MaxLengthConfigBaseAddr(UINTPTR Baseaddr, u32 MaxTriggerLength) {
    extern Trigger_Config Trigger_ConfigTable[];
    Trigger_Config *CfgPtr = NULL;
    int Index;

    for (Index = 0; Index < TRIGGER_CONFIGRATOR_NUM_INSTANCES; Index++) {
        if (Trigger_ConfigTable[Index].BaseAddress == Baseaddr) {
            CfgPtr = &Trigger_ConfigTable[Index];
            break;
        }
    }
    if (CfgPtr == NULL) {
        xil_printf("ERROR: Trigger_Configrator device (Base Address:%x) is not found\n", Baseaddr);
        return XST_FAILURE;
    } else {
        CfgPtr->ConfigAddr = (MaxTriggerLength & MAX_TRIGGER_LENGTH_MASK) | CONFIG_FIXED_STATE;
    }
    return XST_SUCCESS;
}

Trigger_Config *Trigger_ChannelConfig(u16 DeviceId, u32 channel, u32 ControlAddr, u32 ThresholdAddr, u32 AcquisitionAddr, u32 BaselineAddr) {
    extern Trigger_Config Trigger_ConfigTable[];
    Trigger_Config *CfgPtr = NULL;
    int Index;
    for (Index = 0; Index < TRIGGER_CONFIGRATOR_NUM_INSTANCES; Index++) {
        if (Trigger_ConfigTable[Index].DeviceId == DeviceId) {
            CfgPtr = &Trigger_ConfigTable[Index];
            break;
        }
    }
    if (CfgPtr == NULL) {
        xil_printf("ERROR: Trigger_Configrator device (Device ID:%d) is not found\n The return will be NULL POINTER!!!!!!", DeviceId);
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

Trigger_Config *Trigger_ChannelConfigBaseAddr(UINTPTR Baseaddr, u32 channel, u32 ControlAddr, u32 ThresholdAddr, u32 AcquisitionAddr, u32 BaselineAddr) {
    extern Trigger_Config Trigger_ConfigTable[];
    Trigger_Config *CfgPtr = NULL;
    int Index;

    for (Index = 0; Index < TRIGGER_CONFIGRATOR_NUM_INSTANCES; Index++) {
        if (Trigger_ConfigTable[Index].BaseAddress == Baseaddr) {
            CfgPtr = &Trigger_ConfigTable[Index];
            break;
        }
    }

    if (CfgPtr == NULL) {
        xil_printf("ERROR: Trigger_Configrator device (Base Address:%x) is not found\n The return will be NULL POINTER!!!!!!", Baseaddr);
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

int Trigger_ApplyCfg(Trigger_Config *CfgPtr) {
    for (size_t i = 0; i < CHANNEL_NUM; i++) {
        Trigger_WriteReg(CfgPtr->BaseAddress, CONTROL_ADDR_OFFSET + i * CHANNEL_OFFSET, (CfgPtr->ControlAddr[i] & (ACQUIRE_MODE_MASK | TRIGGER_TYPE_MASK)) | STOP_STATE);
    }
    Trigger_WriteReg(CfgPtr->BaseAddress, CONFIG_ADDR_OFFSET, (CfgPtr->ConfigAddr & MAX_TRIGGER_LENGTH_MASK) | CONFIG_STATE);

    for (size_t i = 0; i < CHANNEL_NUM; i++) {
        if (Trigger_IsConfigState(CfgPtr)) {
            Trigger_WriteReg(CfgPtr->BaseAddress, CONTROL_ADDR_OFFSET + i * CHANNEL_OFFSET, (CfgPtr->ControlAddr[i] & (ACQUIRE_MODE_MASK | TRIGGER_TYPE_MASK)) | STOP_STATE);
            Trigger_WriteReg(CfgPtr->BaseAddress, THRESHOLD_ADDR_OFFSET + i * CHANNEL_OFFSET, CfgPtr->ThresholdAddr[i]);
            Trigger_WriteReg(CfgPtr->BaseAddress, ACQUISITION_ADDR_OFFSET + i * CHANNEL_OFFSET, CfgPtr->AcquisitionAddr[i]);
            Trigger_WriteReg(CfgPtr->BaseAddress, BASELINE_ADDR_OFFSET + i * CHANNEL_OFFSET, CfgPtr->BaselineAddr[i]);
            Trigger_WriteReg(CfgPtr->BaseAddress, CONFIG_ADDR_OFFSET, (CfgPtr->ConfigAddr & MAX_TRIGGER_LENGTH_MASK) | CONFIG_STATE);
        } else {
            xil_printf("ERROR: Failed to apply config to Ch[%d]\r\n", i);
            return XST_FAILURE;
        }
    }
    // sleep(1);
    Trigger_WriteReg(CfgPtr->BaseAddress, CONFIG_ADDR_OFFSET, (CfgPtr->ConfigAddr & MAX_TRIGGER_LENGTH_MASK) | CONFIG_FIXED_STATE);
    if (Trigger_IsConfigState(CfgPtr)) {
        xil_printf("ERROR: Failed to save config\r\n");
        return XST_FAILURE;
    }
    return XST_SUCCESS;
}

int Trigger_Start(Trigger_Config *CfgPtr, u16 ch) {
    if ((ch < 0) || (ch >= CHANNEL_NUM)) {
        xil_printf("ERROR: Selected channel is out of range.\r\n");
        return XST_FAILURE;
    }
    Trigger_WriteReg(CfgPtr->BaseAddress, CONFIG_ADDR_OFFSET, (CfgPtr->ConfigAddr & MAX_TRIGGER_LENGTH_MASK) | CONFIG_FIXED_STATE);
    Trigger_WriteReg(CfgPtr->BaseAddress, CONTROL_ADDR_OFFSET + ch * CHANNEL_OFFSET, (CfgPtr->ControlAddr[ch] & (ACQUIRE_MODE_MASK | TRIGGER_TYPE_MASK)) | RUN_STATE);
    if (Trigger_IsConfigState(CfgPtr)) {
        xil_printf("ERROR: Currentlly in Config state. Cannot start run\r\n");
        return XST_FAILURE;
    }
    if (!Trigger_IsRunState(CfgPtr, ch)) {
        xil_printf("ERROR: Failed to start Ch[%d]\r\n", ch);
        return XST_FAILURE;
    }

    return XST_SUCCESS;
}

int Trigger_StartAllCh(Trigger_Config *CfgPtr) {
    int Status;
    for (u16 i = 0; i < CHANNEL_NUM; i++) {
        Status = Trigger_Start(CfgPtr, i);
        if (Status != XST_SUCCESS) {
            break;
        }
    }
    return Status;
}

int Trigger_Stop(Trigger_Config *CfgPtr, u16 ch) {
    if ((ch < 0) || (ch >= CHANNEL_NUM)) {
        xil_printf("ERROR: Selected channel is out of range.\r\n");
        return XST_FAILURE;
    }
    Trigger_WriteReg(CfgPtr->BaseAddress, CONTROL_ADDR_OFFSET + ch * CHANNEL_OFFSET, (CfgPtr->ControlAddr[ch] & (ACQUIRE_MODE_MASK | TRIGGER_TYPE_MASK)) | STOP_STATE);
    if (!Trigger_IsStopState(CfgPtr, ch)) {
        xil_printf("ERROR: Failed to stop Ch[%d]\r\n", ch);
        return XST_FAILURE;
    }
    if (Trigger_IsConfigState(CfgPtr)) {
        xil_printf("WARNING: Currentlly in Config state.\r\n");
    }
    return XST_SUCCESS;
}

int Trigger_StopAllCh(Trigger_Config *CfgPtr) {
    int Status;
    for (u16 i = 0; i < CHANNEL_NUM; i++) {
        Status = Trigger_Stop(CfgPtr, i);
        if (Status != XST_SUCCESS) {
            break;
        }
    }
    return Status;
}

Trigger_Config *Trigger_LookupConfig(u16 DeviceId) {
    extern Trigger_Config Trigger_ConfigTable[];
    Trigger_Config *CfgPtr = NULL;
    int Index;

    for (Index = 0; Index < TRIGGER_CONFIGRATOR_NUM_INSTANCES; Index++) {
        if (Trigger_ConfigTable[Index].DeviceId == DeviceId) {
            CfgPtr = &Trigger_ConfigTable[Index];
            break;
        }
    }
    if (CfgPtr == NULL) {
        xil_printf("ERROR: Trigger_Configrator device (Device ID:%d) is not found\n The return will be NULL POINTER!!!!!!", DeviceId);
    }
    return (CfgPtr);
}

Trigger_Config *Trigger_LookupConfigBaseAddr(UINTPTR Baseaddr) {
    extern Trigger_Config Trigger_ConfigTable[];
    Trigger_Config *CfgPtr = NULL;
    int Index;

    for (Index = 0; Index < TRIGGER_CONFIGRATOR_NUM_INSTANCES; Index++) {
        if (Trigger_ConfigTable[Index].BaseAddress == Baseaddr) {
            CfgPtr = &Trigger_ConfigTable[Index];
            break;
        }
    }
    if (CfgPtr == NULL) {
        xil_printf("ERROR: Trigger_Configrator device (Base Address:%x) is not found\n The return will be NULL POINTER!!!!!!", Baseaddr);
    }
    return (CfgPtr);
}
