#ifndef __SEND2PC_H__
#define __SEND2PC_H__

#include "FreeRTOS.h"
#include "axidma_s2mm_manager.h"
#include "lwip/sockets.h"
#include "lwipopts.h"
#include "netif/xadapter.h"
#include "task.h"

#define THREAD_STACKSIZE 1024
#define RECV_BUF_SIZE 2048
#define SEND_BUF_SIZE (TCP_SND_BUF - MAX_PKT_LEN)
#define TOTAL_SEND_SIZE 256000000
#define SOCKET_READY 2
#define SOCKET_OPEN 1
#define SOCKET_CLOSE 0
#define DMA_TASK_READY 2
#define DMA_TASK_RUN 1
#define DMA_TASK_END 0

typedef struct send2pc_arg {
    int port;
    char *server_address;
    TickType_t xTicksToWait;
} app_arg;

extern int socket_close_flag;
extern int dma_task_end_flag;
extern TaskHandle_t xDmaTask;
extern TaskHandle_t app_thread;

void print_send2pc_app_header(char server_address[], int port);
void send2pc_application_thread(void *arg);

#endif
