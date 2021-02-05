#include "intr_manager.h"

#include "xil_exception.h"

int InitIntrController(INTC *IntcInstancePtr) {
    int Status;
    XScuGic_Config *IntcConfig;

#ifdef XPAR_INTC_0_DEVICE_ID

    /* Initialize the interrupt controller and connect the ISRs */
    Status = XIntc_Initialize(IntcInstancePtr, INTC_DEVICE_ID);
    if (Status != XST_SUCCESS) {
        xil_printf("Failed init intc\r\n");
        return XST_FAILURE;
    }

#else
    /*
     * Initialize the interrupt controller driver so that it is ready to
     * use.
     */
    IntcConfig = XScuGic_LookupConfig(INTC_DEVICE_ID);
    if (NULL == IntcConfig) {
        return XST_FAILURE;
    }

    Status = XScuGic_CfgInitialize(IntcInstancePtr, IntcConfig, IntcConfig->CpuBaseAddress);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

#endif
    return XST_SUCCESS;
}

int StartXIntc(INTC *IntcInstancePtr) {
#ifdef XPAR_INTC_0_DEVICE_ID
    int Status;
    /* Start the interrupt controller */
    Status = XIntc_Start(IntcInstancePtr, XIN_REAL_MODE);
    if (Status != XST_SUCCESS) {
        xil_printf("Failed to start intc\r\n");
        return XST_FAILURE;
    }
#else
    return XST_SUCCESS;
#endif
}

void DisableIntrSystem(INTC *IntcInstancePtr, u16 IntrId) {
#ifdef XPAR_INTC_0_DEVICE_ID
    /* Disconnect the interrupts for the DMA TX and RX channels */
    XIntc_Disconnect(IntcInstancePtr, IntrId);
#else
    XScuGic_Disconnect(IntcInstancePtr, IntrId);
#endif
}