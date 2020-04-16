#ifndef __SEND2PC_H__
#define __SEND2PC_H__

#include "semphr.h"

#define THREAD_STACKSIZE 1024
#define RECV_BUF_SIZE 2048
#define SEND_BUF_SIZE 256
#define SOCKET_READY 2
#define SOCKET_OPEN 1
#define SOCKET_CLOSE 0
#define DMA_TASK_END 1
#define DMA_TASK_READY 2
#define DMA_TASK_RUN 0

typedef struct send2pc_arg {
    int *p;
    TickType_t xTicksToWait;
} process_arg;


extern int socket_close_flag;
extern int dma_task_end_flag;
extern TaskHandle_t xDmaTask;
extern QueueHandle_t xDmaQueue;
extern TaskHandle_t process_thread;
extern UBaseType_t uxDefaultSend2pcPriority;
// extern SemaphoreHandle_t SemaphoneFromSend2pc;

void print_send2pc_app_header();
void process_send2pc(void *arg);
void send2pc_application_thread();

#endif