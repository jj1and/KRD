#include "send2pc.h"

#include "sleep.h"
#include "xil_printf.h"

static int total_send_size = 0;
int socket_close_flag;
int dma_task_end_flag;

void print_send2pc_app_header(char server_address[], int port) { xil_printf("INFO: Start Dummy FEE Connect to IP address:%s  Port:%d\r\n", server_address, port); }

void send2pc_application_thread(void *arg) {
    total_send_size = 0;
    app_arg *argptr = (app_arg *)arg;
    struct sockaddr_in server_address;
    int connection_status = -1;
    int sock, new_sd;

    if ((sock = lwip_socket(AF_INET, SOCK_STREAM, 0)) < 0) return;

    server_address.sin_family = AF_INET;
    server_address.sin_port = htons(argptr->port);
    server_address.sin_addr.s_addr = inet_addr(argptr->server_address);

    xil_printf("INFO: Connecting to server...\r\n");
    connection_status = lwip_connect(sock, (struct sockaddr *)&server_address, sizeof(server_address));

    if (connection_status < 0) {
        xil_printf("ERROR: Failed to connect sever IP:address:%s, Port:%d\r\n", argptr->server_address, argptr->port);
        lwip_close(sock);
        socket_close_flag = SOCKET_CLOSE;
        xil_printf("INFO: Send2PC thread end\r\n");
        vTaskResume(xDmaTask);
        vTaskDelete(NULL);
    } else {
        socket_close_flag = SOCKET_OPEN;
        xil_printf("INFO: Succeeded to connect sever IP:address:%s, Port:%d\r\n", argptr->server_address, argptr->port);
        xil_printf("INFO: Resume dma exction\r\n");
        vTaskResume(xDmaTask);
        portYIELD();
    }

    u64 *dma_buff_ptr;
    int send_wrote = 0;
    u64 send_len = 0;
    u64 actual_frame_len = 0;

    while (1) {
        if (!buff_will_be_empty(SEND_BUF_SIZE / sizeof(u64))) {
            /* handle request */

            send_len = 0;

            if (!ulTaskNotifyTake(pdTRUE, argptr->xTicksToWait)) {
                xil_printf("Waiting DmaTask is Timeout\r\n");
                break;
            } else {
                do {
                	dma_buff_ptr = get_rdptr();
                    actual_frame_len = ((dma_buff_ptr[0] >> (24 + 8)) & 0x00000FFF) + 3;
                    if ((send_wrote = lwip_send(sock, dma_buff_ptr, actual_frame_len * sizeof(u64), 0)) < 0) {
                        xil_printf("%s: Failed to send data. written = %d\r\n", __FUNCTION__, send_wrote);
                        xil_printf("Closing socket %d\r\n", sock);
                        break;
                    }
                    if (incr_rdptr_after_read(actual_frame_len+1) < 0) {
                        break;
                    };
                    send_len += actual_frame_len;
                } while (get_rdptr() < get_wrptr());
            }
            if (send_wrote<0) {
                UBaseType_t uxDmaPriority = uxTaskPriorityGet(xDmaTask);
                vTaskPrioritySet(NULL, uxDmaPriority + 1);
            	break;
            } else if (total_send_size + send_len * sizeof(u64) > TOTAL_SEND_SIZE) {
				total_send_size += send_len * sizeof(u64);
				xil_printf("Send %d Bytes to server\r\n", total_send_size);
				UBaseType_t uxDmaPriority = uxTaskPriorityGet(xDmaTask);
				vTaskPrioritySet(NULL, uxDmaPriority + 1);
				vTaskResume(xDmaTask);
				break;
			}
            total_send_size += send_len * sizeof(u64);
            flush_ptr();
            vTaskResume(xDmaTask);
        } else {
            if (dma_task_end_flag == DMA_TASK_END) {
                xil_printf("INFO: dma is end\r\n");
                break;
            }
        }
        portYIELD();
    }
    lwip_close(sock);
    socket_close_flag = SOCKET_CLOSE;
    xil_printf("INFO: Send2PC thread end\r\n");
    vTaskDelete(NULL);
}
