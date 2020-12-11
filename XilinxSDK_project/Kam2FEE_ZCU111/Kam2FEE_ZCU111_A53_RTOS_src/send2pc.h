#ifndef __SEND2PC_H__
#define __SEND2PC_H__

#include "FreeRTOS.h"
#include "lwip/sockets.h"
#include "lwipopts.h"
#include "netif/xadapter.h"
#include "task.h"

#define THREAD_STACKSIZE 1024
#define RECV_BUF_SIZE 2048
#define TOTAL_SEND_SIZE 256000000
#define SOCKET_READY 2
#define SOCKET_OPEN 1
#define SOCKET_CLOSE 0

typedef struct send2pc_arg {
    int port;
    char *server_address;
    TickType_t xTicksToWait;
} app_arg;

struct netif myself_netif;
TaskHandle_t app_thread;
app_arg send2pc_setting;

void print_ip(char *msg, ip_addr_t *ip);
void print_ip_settings(ip_addr_t *ip, ip_addr_t *mask, ip_addr_t *gw);
void print_send2pc_app_header(char server_address[], int port);
void send2pc_application_thread(void *arg);
int getSend2pcTaskStauts();

#endif
