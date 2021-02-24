#ifndef __SEND2PC_H__
#define __SEND2PC_H__

#include "FreeRTOS.h"
#include "hardware_trigger_manager.h"
#include "lwip/sockets.h"
#include "lwipopts.h"
#include "netif/xadapter.h"
#include "task.h"

#define DP83867IR_BMCR 0x0000U
#define DP83867IR_REGCR 0x000DU
#define DP83867IR_ADDAR 0x000EU
#define DP83867IR_REGCR_INIT 0x001FU
#define DP83867IR_REGCR_NOPOSTINCRMODE 0x401FU

#define TEDBOARD_ETHERNET_CUSTOM_REG_ADDR 0x0031U
#define TEDBOARD_ETHERNET_CUSTOM_DATA 0x1030U

#define THREAD_STACKSIZE 1024
#define RECV_BUF_SIZE 2048
#define TOTAL_SEND_SIZE 256000000
#define SOCKET_READY 2
#define SOCKET_OPEN 1
#define SOCKET_CLOSE 0
#define SOCKET_FAIL -1

#define DMATASK_RUNNING 0
#define DMATASK_END 1
#define DMATASK_READY 2

#define CMDRECV_PORT 5002

typedef struct send2pc_arg {
    int port;
    char *server_address;
    TickType_t xTicksToWait;
} app_arg;

extern TriggerManager_Config fee;
extern TaskHandle_t cleanup_thread;
extern TaskHandle_t cmd_thread;
extern TaskHandle_t app_thread;
extern SemaphoreHandle_t xCmdrcvd2DmaSemaphore;
extern SemaphoreHandle_t xDma2Send2pcSemaphore;
extern int DmaTaskState;

void print_ip(char *msg, ip_addr_t *ip);
void print_ip_settings(ip_addr_t *ip, ip_addr_t *mask, ip_addr_t *gw);
void print_send2pc_app_header(char server_address[], int port);
void send2pc_application_thread(void *arg);
void cmdrecv_application_thread();
int getSend2pcTaskStauts();

void setTotalSendDataSize(int size);
int getTotalSendDatasize();

#endif
