#include "perform_measurement.h"
#include "task.h"
#include "xtime_l.h"

#define COMMON_HEADER 0xAA78000000000000
#define FOOTER 0xFFFFFFFFFFFF5578
#define DMA_START_TICKS_HEADER (COMMON_HEADER+TYPE_DMA_START)
#define DMA_INTR_END_TICKS_HEADER (COMMON_HEADER+TYPE_DMA_INTR_END)
#define DMA_END_TICKS_HEADER (COMMON_HEADER+TYPE_DMA_END)
#define SEND2PC_END_TICKS_HEADER (COMMON_HEADER+TYPE_SEND2PC_END)
#define QUEUE_RECV_TICKS_HEADER (COMMON_HEADER+TYPE_QUEUE_RECV)

static uint64_t dma_task_start_ticks[MAX_LOOP_NUM];
static int dma_task_start_cnt = 0;

static uint64_t dma_intr_end_ticks[MAX_LOOP_NUM];
static int dma_intr_end_cnt = 0;

static uint64_t dma_task_end_ticks[MAX_LOOP_NUM];
static int dma_task_end_cnt = 0;

static uint64_t send2pc_end_ticks[MAX_LOOP_NUM];
static int send2pc_end_cnt = 0;

static uint64_t queue_recv_ticks[MAX_LOOP_NUM];
static int queue_recv_cnt = 0;

static u64 send_yet = TYPE_DMA_START;
static int send_cnt = 0;

void set_timing_ticks(u64 timing_type){
    switch (timing_type)
    {
    case TYPE_DMA_START:
        if(dma_task_start_cnt < MAX_LOOP_NUM){
            XTime_GetTime(&dma_task_start_ticks[dma_task_start_cnt]);
            // dma_task_start_ticks[dma_task_start_cnt] = xTaskGetTickCount();
            dma_task_start_cnt++;
        } else {
            xil_printf("loop num is larger than %d! Cannot hold timing info.\r\n", MAX_LOOP_NUM);
        }
        break;

    case TYPE_DMA_INTR_END:
        if(dma_intr_end_cnt < MAX_LOOP_NUM){
            XTime_GetTime(&dma_intr_end_ticks[dma_intr_end_cnt]);
            //dma_intr_end_ticks[dma_intr_end_cnt] = xTaskGetTickCountFromISR();
            dma_intr_end_cnt++;
        } else {
            xil_printf("loop num is larger than %d! Cannot hold timing info.\r\n", MAX_LOOP_NUM);
        }
        break;

    case TYPE_DMA_END:
        if(dma_task_end_cnt < MAX_LOOP_NUM){
            XTime_GetTime(&dma_task_end_ticks[dma_task_end_cnt]);
            // dma_task_end_ticks[dma_task_end_cnt] = xTaskGetTickCount();
            dma_task_end_cnt++;
        } else {
            xil_printf("loop num is larger than %d! Cannot hold timing info.\r\n", MAX_LOOP_NUM);
        }
        break;
    case TYPE_SEND2PC_END:
        if(send2pc_end_cnt < MAX_LOOP_NUM){
            XTime_GetTime(&send2pc_end_ticks[send2pc_end_cnt]);
            // send2pc_end_ticks[send2pc_end_cnt] = xTaskGetTickCount();
            send2pc_end_cnt++;
        } else {
            xil_printf("loop num is larger than %d! Cannot hold timing info.\r\n", MAX_LOOP_NUM);
        }
        break;
    case TYPE_QUEUE_RECV:
        if(queue_recv_cnt < MAX_LOOP_NUM){
            XTime_GetTime(&queue_recv_ticks[queue_recv_cnt]);
            // send2pc_end_ticks[send2pc_end_cnt] = xTaskGetTickCount();
            queue_recv_cnt++;
        } else {
            xil_printf("loop num is larger than %d! Cannot hold timing info.\r\n", MAX_LOOP_NUM);
        }
        break;        

    default:
        xil_printf("Any timing type matched to the argument: %04x.\r\n", timing_type);
        break;
    }
}

static int copy2buff(uint64_t *send_buff_ptr, uint64_t *timing_ticks, int timing_cnt, u64 max_send_len){
    for (int i = 1; i < max_send_len-1; i++)
    {
        if(send_cnt < timing_cnt) {
            send_buff_ptr[i] = timing_ticks[send_cnt];
            send_cnt++;            
        } else {
            send_cnt = 0;
            return i-1;
        }
    }
    return -1;
}

int get_timing_ticks(uint64_t *send_buff_ptr, u64 max_send_len){
    int copy_len = 0;
    switch (send_yet)
    {
    case TYPE_DMA_START:
        send_buff_ptr[0] = DMA_START_TICKS_HEADER;
        copy_len = copy2buff(send_buff_ptr, dma_task_start_ticks, dma_task_start_cnt, max_send_len);
        if (copy_len >= 0) {
            send_buff_ptr[copy_len+1] = FOOTER;
            send_yet++;
            return copy_len+2;
        } else if (copy_len == -1) {
            send_buff_ptr[max_send_len-1] = FOOTER;
            return max_send_len;
        }
        else
            send_yet = -1;
        break;

    case TYPE_DMA_INTR_END:
        send_buff_ptr[0] = DMA_INTR_END_TICKS_HEADER;
        copy_len = copy2buff(send_buff_ptr, dma_intr_end_ticks, dma_intr_end_cnt, max_send_len);
        if (copy_len >= 0) {
            send_buff_ptr[copy_len+1] = FOOTER;
            send_yet++;
            return copy_len+2;
        } else if (copy_len == -1) {
            send_buff_ptr[max_send_len-1] = FOOTER;
            return max_send_len;
        }
        else
            send_yet = -1;
        break;

    case TYPE_DMA_END:
        send_buff_ptr[0] = DMA_END_TICKS_HEADER;
        copy_len = copy2buff(send_buff_ptr, dma_task_end_ticks, dma_task_end_cnt, max_send_len);
        if (copy_len >= 0) {
            send_buff_ptr[copy_len+1] = FOOTER;
            send_yet++;
            return copy_len+2;
        } else if (copy_len == -1) {
            send_buff_ptr[max_send_len-1] = FOOTER;
            return max_send_len;
        }
        else
            send_yet = -1;
        break;

    case TYPE_SEND2PC_END:
        send_buff_ptr[0] = SEND2PC_END_TICKS_HEADER;
        copy_len = copy2buff(send_buff_ptr, send2pc_end_ticks, send2pc_end_cnt, max_send_len);
        if (copy_len >= 0) {
            send_buff_ptr[copy_len+1] = FOOTER;
            send_yet++;
            return copy_len+2;
        } else if (copy_len == -1) {
            send_buff_ptr[max_send_len-1] = FOOTER;
            return max_send_len;
        }
    case TYPE_QUEUE_RECV:
        send_buff_ptr[0] = QUEUE_RECV_TICKS_HEADER;
        copy_len = copy2buff(send_buff_ptr, queue_recv_ticks, queue_recv_cnt, max_send_len);
        if (copy_len >= 0) {
            send_buff_ptr[copy_len+1] = FOOTER;
            send_yet++;
            return copy_len+2;
        } else if (copy_len == -1) {
            send_buff_ptr[max_send_len-1] = FOOTER;
            return max_send_len;
        }    
        else
            send_yet = -1;
        break;

    case TYPE_QUEUE_RECV+1:
        xil_printf("All ticks data send done!\r\n");
        return 0;

    default:
        xil_printf("Error occured during copy\r\n");
        return -1;
    }
    xil_printf("Error occured during copy\r\n");
    return -1;
}