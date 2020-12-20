#ifndef __INTR_MANAGER__
#define __INTR_MANAGER__

#include "platform_config.h"

#ifdef XPAR_INTC_0_DEVICE_ID
#include "xintc.h"
#define INTC_DEVICE_ID XPAR_INTC_0_DEVICE_ID
#define INTC XIntc
#define INTC_HANDLER XIntc_InterruptHandler
#else
#include "xscugic.h"
#define INTC_DEVICE_ID XPAR_SCUGIC_SINGLE_DEVICE_ID
#define INTC XScuGic
#define INTC_HANDLER XScuGic_InterruptHandler
#endif

#ifdef FREE_RTOS
extern INTC xInterruptController;
#else
INTC Intc; /* Instance of the Interrupt Controller */
#endif

int InitIntrController(INTC* IntcInstancePtr);
int StartXIntc(INTC* IntcInstancePtr);
void DisableIntrSystem(INTC* IntcInstancePtr, u16 IntrId);

#endif  // !__INTR_MANAGER__