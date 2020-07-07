#include <string.h>
#include <stdio.h>
#include "lwipopts.h"
#include "lwip/sockets.h"
#include "netif/xadapter.h"
#include "xil_printf.h"
#include "axidma_manager.h"
#include "send2pc.h"

int socket_close_flag;
int dma_task_end_flag;

TaskHandle_t process_thread;
UBaseType_t uxDefaultSend2pcPriority = DEFAULT_THREAD_PRIO-2;

void PrintData(u64 *dataptr, int Length)
{
	int Index = 0;
	for(Index = 0; Index < Length; Index++) {
		if ((Index+1)%4 == 0){
			xil_printf("%016llx\n", dataptr[Index]);
		} else {
			xil_printf("%016llx ", dataptr[Index]);
		}
	}
	xil_printf("\n\n");
}

u16_t echo_port = 5001;

void print_send2pc_app_header()
{
    xil_printf("%20s %6d %s\r\n", "data server",
                        echo_port,
                        "$ telnet <board_ip> 5001");

}

/* thread spawned for each connection */
void process_send2pc(void *arg)
{
	process_arg *argptr = (process_arg *)arg;
	int sd = *(argptr->p);
	// int n;
	// char recv_buf[RECV_BUF_SIZE];
    u64 send_buf[SEND_BUF_SIZE];
	u64* dma_buff_ptr;
	int send_wrote; 
	u64 send_len;

	while (1) {
        if (!buff_is_empty()) {
			/* handle request */
			dma_buff_ptr = get_rdptr();
			send_len = ((dma_buff_ptr[0] & 0xFFF)+2);
			// xil_printf("sending packet. below\n");
			// PrintData(dma_buff_ptr, send_len);
			if ((send_wrote = lwip_send(sd, dma_buff_ptr, send_len*sizeof(u64), 0)) < 0) {
				xil_printf("%s: ERROR sending to client. written = %d\r\n", __FUNCTION__, send_wrote);
				xil_printf("Closing socket %d\r\n", sd);
				UBaseType_t uxDmaPriority = uxTaskPriorityGet(xDmaTask);
				vTaskPrioritySet(NULL, uxDmaPriority+1);
				break;
			}
			incr_rdptr_after_read();	
		} else {
			// xil_printf("Queue is empty. wait for reciving data\r\n");
			if(dma_task_end_flag == DMA_TASK_END){
					xil_printf("dma is end\r\n");
					break;
				}
			}
			portYIELD();
		}	
	}

	/* close connection */
    socket_close_flag = SOCKET_CLOSE;
	close(sd);
	xil_printf("socket closed.\r\n");
	vTaskDelete(NULL);
}

void send2pc_application_thread(void *arg)
{
	process_arg *argptr = (process_arg *)arg;
	int sock, new_sd;
	int size;

#if LWIP_IPV6==0
	struct sockaddr_in address, remote;

	memset(&address, 0, sizeof(address));

	if ((sock = lwip_socket(AF_INET, SOCK_STREAM, 0)) < 0)
		return;

	address.sin_family = AF_INET;
	address.sin_port = htons(echo_port);
	address.sin_addr.s_addr = INADDR_ANY;
#else
	struct sockaddr_in6 address, remote;

	memset(&address, 0, sizeof(address));

	address.sin6_len = sizeof(address);
	address.sin6_family = AF_INET6;
	address.sin6_port = htons(echo_port);

	memset(&(address.sin6_addr), 0, sizeof(address.sin6_addr));

	if ((sock = lwip_socket(AF_INET6, SOCK_STREAM, 0)) < 0)
		return;
#endif

	if (lwip_bind(sock, (struct sockaddr *)&address, sizeof (address)) < 0)
		return;

	lwip_listen(sock, 0);
	size = sizeof(remote);

	while (1) {
		if((dma_task_end_flag == DMA_TASK_END) && (socket_close_flag==SOCKET_CLOSE)) {
			break;
		} else if ((new_sd = lwip_accept(sock, (struct sockaddr *)&remote, (socklen_t *)&size)) > 0) {
			argptr->p = &new_sd;
			socket_close_flag = SOCKET_OPEN;
			xil_printf("Resume dma exction\r\n");
			vTaskResume(xDmaTask);
            process_thread = sys_thread_new("send2pc", process_send2pc,
				argptr,
				THREAD_STACKSIZE,
				uxDefaultSend2pcPriority);
		}
	}
	xil_printf("End socket connection.\r\n");
	vTaskDelete(NULL);
}