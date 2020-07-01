#ifndef __PERFORM_MEASUREMENT_H__
#define __PERFORM_MEASUREMENT_H__

#include "FreeRTOS.h"

#define TYPE_DMA_START 0x000000000000000A
#define TYPE_DMA_INTR_END 0x000000000000000B
#define TYPE_DMA_END 0x000000000000000C
#define TYPE_SEND2PC_END 0x000000000000000D

#define MAX_LOOP_NUM 10000

void set_timing_ticks(u64 timing_type);
int get_timing_ticks(uint64_t *send_buff_ptr, u64 max_send_len);

#endif