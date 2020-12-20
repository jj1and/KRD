#include "peripheral_controller.h"

#include "peripheral_controller_hw.h"
#include "xil_printf.h"
#include "xstatus.h"

#define Peripheral_BaseAddress(CfgPtr) ((CfgPtr)->BaseAddress)

static int Peripheral_SearchDevice(u16 DeviceId) {
    extern Peripheral_Config Peripheral_ConfigTable[];
    int device_index = -1;
    for (int i = 0; i < PERIPHERAL_CONTROLLER_NUM_INSTANCES; i++) {
        if (Peripheral_ConfigTable[i].DeviceId == DeviceId) {
            device_index = i;
            break;
        }
    }
    return device_index;
}

int Peripheral_Cdci6214Reset(u16 DeviceId) {
    extern Peripheral_Config Peripheral_ConfigTable[];
    Peripheral_Config *CfgPtr = NULL;
    int Index;

    Index = Peripheral_SearchDevice(DeviceId);
    if (Index < 0) {
        xil_printf("ERROR: Peripheral_Configrator device (Device ID:%d) is not found\r\n", DeviceId);
        return XST_FAILURE;
    } else {
        CfgPtr = &Peripheral_ConfigTable[Index];
    }

    if (CfgPtr == NULL) {
        xil_printf("ERROR: Peripheral_Configrator device (Device ID:%d) is NULL\r\n", DeviceId);
        return XST_FAILURE;
    } else {
        Peripheral_WriteReg(CfgPtr->BaseAddress, CDCI6214_GPIO_ADDR_OFFSET, (DEFAULT_CDCI6214_GPIO_CONFIG & ~CDCI6214_RESET_MASK) | CDCI6214_RESET);
        Peripheral_WriteReg(CfgPtr->BaseAddress, CDCI6214_GPIO_ADDR_OFFSET, (DEFAULT_CDCI6214_GPIO_CONFIG & ~CDCI6214_RESET_MASK) | CDCI6214_NORMAL);
    }
    return XST_SUCCESS;
}

int Peripheral_LadcReset(u16 DeviceId) {
    extern Peripheral_Config Peripheral_ConfigTable[];
    Peripheral_Config *CfgPtr = NULL;
    int Index;
    Index = Peripheral_SearchDevice(DeviceId);
    if (Index < 0) {
        xil_printf("ERROR: Peripheral_Configrator device (Device ID:%d) is not found\r\n", DeviceId);
        return XST_FAILURE;
    } else {
        CfgPtr = &Peripheral_ConfigTable[Index];
    }

    if (CfgPtr == NULL) {
        xil_printf("ERROR: Peripheral_Configrator device (Device ID:%d) is NULL\r\n", DeviceId);
        return XST_FAILURE;
    } else {
        Peripheral_WriteReg(CfgPtr->BaseAddress, LADC_RESET_ADDR_OFFSET, LADC_RESET);
        Peripheral_WriteReg(CfgPtr->BaseAddress, LADC_RESET_ADDR_OFFSET, LADC_NORMAL);
    }
    xil_printf("INFO: reset LADC\r\n");
    return XST_SUCCESS;
}

int Peripheral_LadcSenActive(u16 DeviceId, int LadcSel) {
    extern Peripheral_Config Peripheral_ConfigTable[];
    Peripheral_Config *CfgPtr = NULL;
    int Index;

    Index = Peripheral_SearchDevice(DeviceId);
    if (Index < 0) {
        xil_printf("ERROR: Peripheral_Configrator device (Device ID:%d) is not found\r\n", DeviceId);
        return XST_FAILURE;
    } else {
        CfgPtr = &Peripheral_ConfigTable[Index];
    }

    if (CfgPtr == NULL) {
        xil_printf("ERROR: Peripheral_Configrator device (Device ID:%d) is NULL\r\n", DeviceId);
        return XST_FAILURE;
    } else {
        xil_printf("INFO: select LADC[%d]\r\n", LadcSel);
        Peripheral_WriteReg(CfgPtr->BaseAddress, LADC_SEN_ADDR_OFFSET, (LADC_SEN_HIGH << LadcSel));
    }
    return XST_SUCCESS;
}

int Peripheral_LadcSenDeactive(u16 DeviceId) {
    extern Peripheral_Config Peripheral_ConfigTable[];
    Peripheral_Config *CfgPtr = NULL;
    int Index;

    Index = Peripheral_SearchDevice(DeviceId);
    if (Index < 0) {
        xil_printf("ERROR: Peripheral_Configrator device (Device ID:%d) is not found\r\n", DeviceId);
        return XST_FAILURE;
    } else {
        CfgPtr = &Peripheral_ConfigTable[Index];
    }

    if (CfgPtr == NULL) {
        xil_printf("ERROR: Peripheral_Configrator device (Device ID:%d) is NULL\r\n", DeviceId);
        return XST_FAILURE;
    } else {
        Peripheral_WriteReg(CfgPtr->BaseAddress, LADC_SEN_ADDR_OFFSET, LADC_SEN_LOW);
    }
    return XST_SUCCESS;
}

int Peripheral_SetConfigDefault(u16 DeviceId) {
    extern Peripheral_Config Peripheral_ConfigTable[];
    Peripheral_Config *CfgPtr = NULL;
    int Index;

    Index = Peripheral_SearchDevice(DeviceId);
    if (Index < 0) {
        xil_printf("ERROR: Peripheral_Configrator device (Device ID:%d) is not found\r\n", DeviceId);
        return XST_FAILURE;
    } else {
        CfgPtr = &Peripheral_ConfigTable[Index];
    }

    if (CfgPtr == NULL) {
        xil_printf("ERROR: Peripheral_Configrator device (Device ID:%d) is NULL\r\n", DeviceId);
        return XST_FAILURE;
    } else {
        CfgPtr->CDCI6214GpioConfigAddr = DEFAULT_CDCI6214_GPIO_CONFIG;
        CfgPtr->GpoAddr = DEFALUT_GPO_CONFIG;
        CfgPtr->GpiAddr = Peripheral_ReadReg(CfgPtr->BaseAddress, GPI_ADDR_OFFSET);
        CfgPtr->LadcCtrlAddr = DEFAULT_LADC_CTRL_CONFIG;
        CfgPtr->Sfp1GpioAddr = DEFAULT_SFP_CONFIG;
        CfgPtr->Sfp2GpioAddr = DEFAULT_SFP_CONFIG;
    }
    return XST_SUCCESS;
}

int Peripheral_SetConfigDefaultBaseAddr(UINTPTR Baseaddr) {
    extern Peripheral_Config Peripheral_ConfigTable[];
    Peripheral_Config *CfgPtr = NULL;
    int Index;

    for (Index = 0; Index < PERIPHERAL_CONTROLLER_NUM_INSTANCES; Index++) {
        if (Peripheral_ConfigTable[Index].BaseAddress == Baseaddr) {
            CfgPtr = &Peripheral_ConfigTable[Index];
            break;
        }
    }

    if (CfgPtr == NULL) {
        xil_printf("ERROR: Peripheral_Configrator device (Base Address:%x) is not found\n The return will be NULL POINTER!!!!!!", Baseaddr);
        return XST_FAILURE;
    } else {
        CfgPtr->CDCI6214GpioConfigAddr = DEFAULT_CDCI6214_GPIO_CONFIG;
        CfgPtr->GpoAddr = DEFALUT_GPO_CONFIG;
        CfgPtr->GpiAddr = Peripheral_ReadReg(CfgPtr->BaseAddress, GPI_ADDR_OFFSET);
        CfgPtr->LadcCtrlAddr = DEFAULT_LADC_CTRL_CONFIG;
        CfgPtr->Sfp1GpioAddr = DEFAULT_SFP_CONFIG;
        CfgPtr->Sfp2GpioAddr = DEFAULT_SFP_CONFIG;
    }
    return XST_SUCCESS;
}

int Peripheral_SetCdci6214Config(u16 DeviceId, u32 Config) {
    extern Peripheral_Config Peripheral_ConfigTable[];
    Peripheral_Config *CfgPtr = NULL;
    int Index;

    Index = Peripheral_SearchDevice(DeviceId);
    if (Index < 0) {
        xil_printf("ERROR: Peripheral_Configrator device (Device ID:%d) is not found\r\n", DeviceId);
        return XST_FAILURE;
    } else {
        CfgPtr = &Peripheral_ConfigTable[Index];
    }

    if (CfgPtr == NULL) {
        xil_printf("ERROR: Peripheral_Configrator device (Device ID:%d) is NULL\r\n", DeviceId);
        return XST_FAILURE;
    } else {
        CfgPtr->CDCI6214GpioConfigAddr = Config & (CDCI6214_EEPROM_MASK | CDCI6214_OE_CONFIG_MASK | CDCI6214_REF_SEL_MASK);
    }
    return XST_SUCCESS;
}

int Peripheral_SetGPO(u16 DeviceId, u32 Config) {
    extern Peripheral_Config Peripheral_ConfigTable[];
    Peripheral_Config *CfgPtr = NULL;
    int Index;

    Index = Peripheral_SearchDevice(DeviceId);
    if (Index < 0) {
        xil_printf("ERROR: Peripheral_Configrator device (Device ID:%d) is not found\r\n", DeviceId);
        return XST_FAILURE;
    } else {
        CfgPtr = &Peripheral_ConfigTable[Index];
    }

    if (CfgPtr == NULL) {
        xil_printf("ERROR: Peripheral_Configrator device (Device ID:%d) is NULL\r\n", DeviceId);
        return XST_FAILURE;
    } else {
        CfgPtr->GpoAddr = Config & GPIO_MASK;
    }
    Peripheral_WriteReg(CfgPtr->BaseAddress, GPO_ADDR_OFFSET, CfgPtr->GpoAddr);
    xil_printf("INFO: Set GPO Reg: 0x%08x\r\n", CfgPtr->GpoAddr);
    return XST_SUCCESS;
}

int Peripheral_SetLadcCtrlConfig(u16 DeviceId, u32 Config) {
    extern Peripheral_Config Peripheral_ConfigTable[];
    Peripheral_Config *CfgPtr = NULL;
    int Index;

    Index = Peripheral_SearchDevice(DeviceId);
    if (Index < 0) {
        xil_printf("ERROR: Peripheral_Configrator device (Device ID:%d) is not found\r\n", DeviceId);
        return XST_FAILURE;
    } else {
        CfgPtr = &Peripheral_ConfigTable[Index];
    }

    if (CfgPtr == NULL) {
        xil_printf("ERROR: Peripheral_Configrator device (Device ID:%d) is NULL\r\n", DeviceId);
        return XST_FAILURE;
    } else {
        CfgPtr->LadcCtrlAddr = Config & (LADC_CTRL_CTRL1_MASK | LADC_CTRL_CTRL2_MASK);
    }
    return XST_SUCCESS;
}

int Peripheral_SetSfp1Config(u16 DeviceId, u32 Config) {
    extern Peripheral_Config Peripheral_ConfigTable[];
    Peripheral_Config *CfgPtr = NULL;
    int Index;

    Index = Peripheral_SearchDevice(DeviceId);
    if (Index < 0) {
        xil_printf("ERROR: Peripheral_Configrator device (Device ID:%d) is not found\r\n", DeviceId);
        return XST_FAILURE;
    } else {
        CfgPtr = &Peripheral_ConfigTable[Index];
    }

    if (CfgPtr == NULL) {
        xil_printf("ERROR: Peripheral_Configrator device (Device ID:%d) is NULL\r\n", DeviceId);
        return XST_FAILURE;
    } else {
        CfgPtr->Sfp1GpioAddr = Config & (SFP_RS0_MASK | SFP_RS1_MASK | SFP_TX_DISABLE_MASK);
    }
    return XST_SUCCESS;
}

int Peripheral_SetSfp2Config(u16 DeviceId, u32 Config) {
    extern Peripheral_Config Peripheral_ConfigTable[];
    Peripheral_Config *CfgPtr = NULL;
    int Index;

    Index = Peripheral_SearchDevice(DeviceId);
    if (Index < 0) {
        xil_printf("ERROR: Peripheral_Configrator device (Device ID:%d) is not found\r\n", DeviceId);
        return XST_FAILURE;
    } else {
        CfgPtr = &Peripheral_ConfigTable[Index];
    }

    if (CfgPtr == NULL) {
        xil_printf("ERROR: Peripheral_Configrator device (Device ID:%d) is NULL\r\n", DeviceId);
        return XST_FAILURE;
    } else {
        CfgPtr->Sfp2GpioAddr = Config & (SFP_RS0_MASK | SFP_RS1_MASK | SFP_TX_DISABLE_MASK);
    }
    return XST_SUCCESS;
}

void Peripheral_PrintCfgPtr(u16 DeviceId) {
    extern Peripheral_Config Peripheral_ConfigTable[];
    Peripheral_Config *CfgPtr = NULL;
    int Index;

    Index = Peripheral_SearchDevice(DeviceId);
    if (Index < 0) {
        xil_printf("\nERROR: Peripheral_Configrator device (Device ID:%d) is not found\r\n", DeviceId);
        return XST_FAILURE;
    } else {
        CfgPtr = &Peripheral_ConfigTable[Index];
    }
    xil_printf("\nINFO: Print peripheral Peripheral_ConfigTable[%d] settings... \r\n", DeviceId);
    xil_printf("INFO: CDCI6214 GPIO Reg: 0x%08x\r\n", CfgPtr->CDCI6214GpioConfigAddr);
    xil_printf("INFO: LADC CTRL Reg: 0x%08x\r\n", CfgPtr->LadcCtrlAddr);
    xil_printf("INFO: SFP1 GPIO Reg: 0x%08x\r\n", CfgPtr->Sfp1GpioAddr);
    xil_printf("INFO: SFP2 GPIO Reg: 0x%08x\r\n", CfgPtr->Sfp2GpioAddr);
}

int Peripheral_ApplyCfg(u16 DeviceId) {
    extern Peripheral_Config Peripheral_ConfigTable[];
    Peripheral_Config *CfgPtr = NULL;
    int Index;

    Index = Peripheral_SearchDevice(DeviceId);
    if (Index < 0) {
        xil_printf("ERROR: Peripheral_Configrator device (Device ID:%d) is not found\r\n", DeviceId);
        return XST_FAILURE;
    } else {
        CfgPtr = &Peripheral_ConfigTable[Index];
    }

    Peripheral_WriteReg(CfgPtr->BaseAddress, CDCI6214_GPIO_ADDR_OFFSET, CfgPtr->CDCI6214GpioConfigAddr);
    Peripheral_WriteReg(CfgPtr->BaseAddress, LADC_CTRL_ADDR_OFFSET, CfgPtr->LadcCtrlAddr);
    Peripheral_WriteReg(CfgPtr->BaseAddress, SFP1_GPIO_ADDR_OFFSET, CfgPtr->Sfp1GpioAddr);
    Peripheral_WriteReg(CfgPtr->BaseAddress, SFP2_GPIO_ADDR_OFFSET, CfgPtr->Sfp2GpioAddr);
    return XST_SUCCESS;
}

void Peripheral_PrintAppliedCfg(u16 DeviceId) {
    extern Peripheral_Config Peripheral_ConfigTable[];
    Peripheral_Config *CfgPtr = NULL;
    int Index;

    Index = Peripheral_SearchDevice(DeviceId);
    if (Index < 0) {
        xil_printf("\nERROR: Peripheral_Configrator device (Device ID:%d) is not found\r\n", DeviceId);
        return XST_FAILURE;
    } else {
        CfgPtr = &Peripheral_ConfigTable[Index];
    }
    xil_printf("\nINFO: print peripheral APPLIED config settings of Device ID:%d ... \r\n", DeviceId);
    xil_printf("INFO: CDCI6214 GPIO Reg: 0x%08x\r\n", Peripheral_ReadReg(CfgPtr->BaseAddress, CDCI6214_GPIO_ADDR_OFFSET));
    xil_printf("INFO: LADC CTRL Reg: 0x%08x\r\n", Peripheral_ReadReg(CfgPtr->BaseAddress, LADC_CTRL_ADDR_OFFSET));
    xil_printf("INFO: LADC RESET Reg: 0x%08x\r\n", Peripheral_ReadReg(CfgPtr->BaseAddress, LADC_RESET_ADDR_OFFSET));
    xil_printf("INFO: LADC SEN Reg: 0x%08x\r\n", Peripheral_ReadReg(CfgPtr->BaseAddress, LADC_SEN_ADDR_OFFSET));
    xil_printf("INFO: SFP1 GPIO Reg: 0x%08x\r\n", Peripheral_ReadReg(CfgPtr->BaseAddress, SFP1_GPIO_ADDR_OFFSET));
    xil_printf("INFO: SFP2 GPIO Reg: 0x%08x\r\n", Peripheral_ReadReg(CfgPtr->BaseAddress, SFP2_GPIO_ADDR_OFFSET));
}

void Peripheral_PrintGPIO(u16 DeviceId) {
    extern Peripheral_Config Peripheral_ConfigTable[];
    Peripheral_Config *CfgPtr = NULL;
    int Index;

    Index = Peripheral_SearchDevice(DeviceId);
    if (Index < 0) {
        xil_printf("\nERROR: Peripheral_Configrator device (Device ID:%d) is not found\r\n", DeviceId);
        return XST_FAILURE;
    } else {
        CfgPtr = &Peripheral_ConfigTable[Index];
    }
    xil_printf("INFO: GPO Reg: 0x%08x\r\n", Peripheral_ReadReg(CfgPtr->BaseAddress, GPO_ADDR_OFFSET));
    xil_printf("INFO: GPI Reg: 0x%08x\r\n", Peripheral_ReadReg(CfgPtr->BaseAddress, GPI_ADDR_OFFSET));
}

int Peripheral_GetCdci6214Status(u16 DeviceId) {
    extern Peripheral_Config Peripheral_ConfigTable[];
    Peripheral_Config *CfgPtr = NULL;
    int Index;

    Index = Peripheral_SearchDevice(DeviceId);
    if (Index < 0) {
        xil_printf("ERROR: Peripheral_Configrator device (Device ID:%d) is not found\r\n", DeviceId);
        return XST_FAILURE;
    } else {
        CfgPtr = &Peripheral_ConfigTable[Index];
    }
    CfgPtr->CDCI6214GpioConfigAddr = Peripheral_ReadReg(CfgPtr->BaseAddress, CDCI6214_GPIO_ADDR_OFFSET);
    return (CfgPtr->CDCI6214GpioConfigAddr) & CDCI6214_STATUS_MASK;
}

int Peripheral_GetGPI(u16 DeviceId) {
    extern Peripheral_Config Peripheral_ConfigTable[];
    Peripheral_Config *CfgPtr = NULL;
    int Index;

    Index = Peripheral_SearchDevice(DeviceId);
    if (Index < 0) {
        xil_printf("ERROR: Peripheral_Configrator device (Device ID:%d) is not found\r\n", DeviceId);
        return XST_FAILURE;
    } else {
        CfgPtr = &Peripheral_ConfigTable[Index];
    }
    CfgPtr->GpiAddr = Peripheral_ReadReg(CfgPtr->BaseAddress, GPI_ADDR_OFFSET);
    return (CfgPtr->GpiAddr) & GPIO_MASK;
}

int Peripheral_GetSfp1Status(u16 DeviceId) {
    extern Peripheral_Config Peripheral_ConfigTable[];
    Peripheral_Config *CfgPtr = NULL;
    int Index;

    Index = Peripheral_SearchDevice(DeviceId);
    if (Index < 0) {
        xil_printf("ERROR: Peripheral_Configrator device (Device ID:%d) is not found\r\n", DeviceId);
        return XST_FAILURE;
    } else {
        CfgPtr = &Peripheral_ConfigTable[Index];
    }
    return Peripheral_ReadReg(CfgPtr->BaseAddress, SFP1_GPIO_ADDR_OFFSET) & SFP_TX_STATUS_MASK;
}

int Peripheral_GetSfp2Status(u16 DeviceId) {
    extern Peripheral_Config Peripheral_ConfigTable[];
    Peripheral_Config *CfgPtr = NULL;
    int Index;

    Index = Peripheral_SearchDevice(DeviceId);
    if (Index < 0) {
        xil_printf("ERROR: Peripheral_Configrator device (Device ID:%d) is not found\r\n", DeviceId);
        return XST_FAILURE;
    } else {
        CfgPtr = &Peripheral_ConfigTable[Index];
    }
    return Peripheral_ReadReg(CfgPtr->BaseAddress, SFP2_GPIO_ADDR_OFFSET) & SFP_TX_STATUS_MASK;
}
