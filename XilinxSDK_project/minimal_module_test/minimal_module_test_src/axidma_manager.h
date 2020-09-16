#ifndef __AXIDMA_MANAGER_H_
#define __AXIDMA_MANAGER_H_

#include "FreeRTOS.h"
#include "task.h"
#include "xaxidma.h"
#include "xparameters.h"

#ifdef XPAR_INTC_0_DEVICE_ID
#include "xintc.h"
#else
#include "xscugic.h"
#endif

#define FREE_RTOS

/************************** Constant Definitions ****************************/

/*
 * The following constants map to the XPAR parameters created in the
 * xparameters.h file. They are defined here such that a user can easily
 * change all the needed parameters in one place.
 */

// AXI-DMA related constants
#define DMA_DEV_ID XPAR_AXIDMA_0_DEVICE_ID

#ifdef XPAR_AXI_7SDDR_0_S_AXI_BASEADDR
#define DDR_BASE_ADDR XPAR_AXI_7SDDR_0_S_AXI_BASEADDR
#elif defined(XPAR_MIG7SERIES_0_BASEADDR)
#define DDR_BASE_ADDR XPAR_MIG7SERIES_0_BASEADDR
#elif defined(XPAR_MIG_0_BASEADDR)
#define DDR_BASE_ADDR XPAR_MIG_0_BASEADDR
// #elif defined (XPAR_PSU_DDR_1_S_AXI_BASEADDR)
// #define DDR_BASE_ADDR	XPAR_PSU_DDR_1_S_AXI_BASEADDR
#elif defined(XPAR_PSU_DDR_0_S_AXI_BASEADDR)
#define DDR_BASE_ADDR XPAR_PSU_DDR_0_S_AXI_BASEADDR
#endif

#ifndef DDR_BASE_ADDR
#warning CHECK FOR THE VALID DDR ADDRESS IN XPARAMETERS.H, \
			DEFAULT SET TO 0x01000000
#define MEM_BASE_ADDR 0x01000000
#else
#define MEM_BASE_ADDR (DDR_BASE_ADDR + 0x1000000)
#endif

#ifdef XPAR_INTC_0_DEVICE_ID
#define RX_INTR_ID XPAR_INTC_0_AXIDMA_0_VEC_ID
#define TX_INTR_ID XPAR_INTC_0_AXIDMA_0_MM2S_INTROUT_VEC_ID
#else
#define RX_INTR_ID XPAR_FABRIC_AXI_DMA_0_S2MM_INTROUT_INTR
#define TX_INTR_ID XPAR_FABRIC_AXI_DMA_0_MM2S_INTROUT_INTR
#endif

#define RX_BUFFER_BASE (MEM_BASE_ADDR + 0x00300000)
#define RX_BUFFER_HIGH (MEM_BASE_ADDR + 0x004FFFFF)

#define TX_BUFFER_BASE (MEM_BASE_ADDR + 0x00100000)

#ifdef XPAR_INTC_0_DEVICE_ID
#define INTC_DEVICE_ID XPAR_INTC_0_DEVICE_ID
#else
#define INTC_DEVICE_ID XPAR_SCUGIC_SINGLE_DEVICE_ID
#endif

/* Timeout loop counter for reset
 */
#define RESET_TIMEOUT_COUNTER 10000

/*
 * Buffer and Buffer Descriptor related constant definition
 */
#define MAX_GENERATBLE_TRIGGER_LEN 256
#define MAX_TRIGGER_LEN 16
#define MAX_PKT_LEN ((MAX_TRIGGER_LEN * 16 + 3 * 8) / 16 + 1) * 16  // MAX_TRIGGER_LEN[CLK]x 16[Byte] + (2(HEADERS) + 1(FOOTER))x 8[Byte]
#define RX_BUFFER_SIZE (RX_BUFFER_HIGH - RX_BUFFER_BASE)
#define AXIDMA_BUFF_SIZE 16384

/* The interrupt coalescing threshold and delay timer threshold
 * Valid range is 1 to 255
 *
 * We set the coalescing threshold to be the total number of packets.
 * The receive side will only get one completion interrupt for this example.
 */
#define COALESCING_COUNT NUMBER_OF_PKTS_TO_TRANSFER
#define DELAY_TIMER_COUNT 100

#ifdef XPAR_INTC_0_DEVICE_ID
#define INTC XIntc
#define INTC_HANDLER XIntc_InterruptHandler
#else
#define INTC XScuGic
#define INTC_HANDLER XScuGic_InterruptHandler
#endif

// AXI-DMA related variables
XAxiDma AxiDma;
#ifdef FREE_RTOS
extern INTC xInterruptController;
#else
INTC Intc; /* Instance of the Interrupt Controller */
#endif

/*
 * Flags interrupt handlers use to notify the application context the events.
 */
volatile int TxDone;
volatile int RxDone;
volatile int Error;

TaskHandle_t xDmaTask;

int axidma_setup();
int generate_signal(u16* tx_buff_ptr, int pre_time, int rise_time, int high_time, int fall_time, int post_time, int max_val, int baseline, int print_enable);
int axidma_send_buff(int pre_time, int rise_time, int high_time, int fall_time, int post_time, int max_val, int baseline, int print_enable);
int axidma_recv_buff();
int InitIntrController(INTC* IntcInstancePtr);
int StartXIntc(INTC* IntcInstancePtr);
int SetupTxIntrSystem(INTC* IntcInstancePtr, XAxiDma* AxiDmaPtr, u16 TxIntrId);
int SetupRxIntrSystem(INTC* IntcInstancePtr, XAxiDma* AxiDmaPtr, u16 RxIntrId);
void shutdown_dma();

int incr_wrptr_after_write(u64 size);
int decr_wrptr_after_read(u64 size);
// int incr_rdptr_after_read(u64 size);
int buff_will_be_empty(u64 size);
int buff_will_be_full(u64 size);
u64* get_wrptr();
// u64* get_rdptr();

#endif
