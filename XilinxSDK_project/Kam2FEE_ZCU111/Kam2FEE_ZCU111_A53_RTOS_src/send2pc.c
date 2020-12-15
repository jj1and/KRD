#include "send2pc.h"

#include "axidma_s2mm_manager.h"
#include "hardware_trigger_manager.h"
#include "sleep.h"
#include "xil_printf.h"

static int total_data_size = TOTAL_SEND_SIZE;
static int total_send_size = 0;
static int socket_close_flag = SOCKET_READY;

void print_ip(char *msg, ip_addr_t *ip) {
    xil_printf(msg);
    xil_printf("%d.%d.%d.%d\n\r", ip4_addr1(ip), ip4_addr2(ip), ip4_addr3(ip), ip4_addr4(ip));
}

void print_ip_settings(ip_addr_t *ip, ip_addr_t *mask, ip_addr_t *gw) {
    print_ip("Board IP: ", ip);
    print_ip("Netmask : ", mask);
    print_ip("Gateway : ", gw);
}

void print_send2pc_app_header(char server_address[], int port) { xil_printf("Start Dummy FEE Connect to IP address:%s  Port:%d\r\n", server_address, port); }

void send2pc_application_thread(void *arg) {
    app_arg *argptr = (app_arg *)arg;
    struct sockaddr_in server_address;
    int connection_status = -1;
    int sock;
    u64 *dma_buff_ptr;
    int send_wrote;
    u64 send_len;
    u64 actual_frame_len;
    while (1) {
        if (xSemaphoreTake(xDma2Send2pcSemaphore, portMAX_DELAY)) {
            total_send_size = 0;
            connection_status = -1;

            if ((sock = lwip_socket(AF_INET, SOCK_STREAM, 0))) {
                server_address.sin_family = AF_INET;
                server_address.sin_port = htons(argptr->port);
                server_address.sin_addr.s_addr = inet_addr(argptr->server_address);

                xil_printf("INFO: Connecting to server...\r\n");

                while (socket_close_flag != SOCKET_OPEN) {
                    connection_status = connect(sock, (struct sockaddr *)&server_address, sizeof(server_address));

                    if (connection_status < 0) {
                        xil_printf("ERROR: Failed to connect sever IP:address:%s, Port:%d\r\n", argptr->server_address, argptr->port);
                        break;
                    } else {
                        socket_close_flag = SOCKET_OPEN;
                        xil_printf("INFO: Succeeded to connect sever IP:address:%s, Port:%d\r\n", argptr->server_address, argptr->port);
                        xil_printf("INFO: Resume dma exction\r\n");
                        vTaskResume(xDmaTask);
                        portYIELD();
                    }
                }
            } else {
                socket_close_flag = SOCKET_FAIL;
            }
        }

        while (socket_close_flag == SOCKET_OPEN & getFeeState() == FEE_RUNNING) {
            send_len = 0;
            if (!ulTaskNotifyTake(pdTRUE, portMAX_DELAY)) {
                xil_printf("INFO: Waiting DmaTask is Timeout\r\n");
                break;
            } else {
                do {
                    dma_buff_ptr = get_rdptr();
                    actual_frame_len = ((dma_buff_ptr[0] >> (24 + 8)) & 0x00000FFF) + 3;
                    if ((send_wrote = lwip_send(sock, dma_buff_ptr, actual_frame_len * sizeof(u64), 0)) < 0) {
                        xil_printf("%s: Failed to send data. written = %d\r\n", __FUNCTION__, send_wrote);
                        xil_printf("INFO: Closing socket %d\r\n", sock);
                        break;
                    }
                    if (incr_rdptr_after_read(actual_frame_len + 1) < 0) {
                        break;
                    };
                    send_len += actual_frame_len;
                } while (get_rdptr() < get_wrptr());
            }

            flush_ptr();
            if ((send_wrote < 0)) {
                xil_printf("ERROR: failed to send data\r\n");
                break;
            }

            total_send_size += send_len * sizeof(u64);
            if (total_send_size > total_data_size) {
                xil_printf("INFO: Send %d Bytes to server\r\n", total_send_size);
                break;
            }

            vTaskResume(xDmaTask);
            portYIELD();
        }

        if (socket_close_flag == SOCKET_FAIL) {
            xil_printf("ERROR: failed to get socket \r\n");
        } else {
            lwip_close(sock);
            socket_close_flag = SOCKET_CLOSE;
            xil_printf("INFO: Send2PC thread end\r\n");
        }

        vTaskResume(xDmaTask);
        portYIELD();
    }

    vTaskDelete(NULL);
    return;
}

int getSend2pcTaskStauts() {
    return socket_close_flag;
}

static void flush_buff(char *buff) {
    for (size_t i = 0; i < RECV_BUF_SIZE; i++) {
        buff[i] = "";
    }
}

void cmdrecv_application_thread() {
    struct sockaddr_in myself, remote;
    int sock, sd, size, n, quit_flag;
    char recv_buf[RECV_BUF_SIZE];
    total_data_size = TOTAL_SEND_SIZE;
    quit_flag = 0;
    xCmdrcvd2DmaSemaphore = xSemaphoreCreateBinary();

    memset(&myself, 0, sizeof(myself));
    if ((sock = lwip_socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        xil_printf("ERROR: failed to get cmd socket.\r\n");
        vTaskSuspendAll();
    }

    myself.sin_family = AF_INET;
    myself.sin_port = htons(CMDRECV_PORT);
    myself.sin_addr.s_addr = INADDR_ANY;

    if (lwip_bind(sock, (struct sockaddr *)&myself, sizeof(myself)) < 0) {
        xil_printf("ERROR: failed to bind cmd socket.\r\n");
        vTaskSuspendAll();
    }

    lwip_listen(sock, 0);
    size = sizeof(remote);

    while (1) {
        if ((sd = lwip_accept(sock, (struct sockaddr *)&remote, (socklen_t *)&size)) < 0) {
            break;
        } else {
            while (1) {
                xil_printf("INFO: waiting new command...\r\n");
                if ((n = read(sd, recv_buf, RECV_BUF_SIZE)) < 0) {
                    xil_printf("%s: error reading from socket %d, closing socket\r\n", __FUNCTION__, sd);
                    break;
                }

                /* break if the recved message = "quit" */
                if (!strncmp(recv_buf, "quit", 4)) {
                    quit_flag = 1;
                    break;
                } else {
                    if (!strncmp(recv_buf, "size", 4)) {
                        xil_printf("INFO: Enter total send data size (unit is Byte)(0 < size < %d).\r\n", TOTAL_SEND_SIZE);
                        if ((n = read(sd, recv_buf, RECV_BUF_SIZE)) < 0) {
                            xil_printf("%s: error reading from socket %d, closing socket\r\n", __FUNCTION__, sd);
                            break;
                        }
                        total_data_size = atoi(recv_buf);
                        if ((total_data_size <= 0) | (total_data_size > TOTAL_SEND_SIZE)) {
                            xil_printf("ERROR: size must be larger than 0 & smaller than %d\r\n", TOTAL_SEND_SIZE);
                            total_data_size = TOTAL_SEND_SIZE;
                        } else {
                            xil_printf("INFO: set total send data size as %d Byte.\r\n", total_data_size);
                        }
                    } else if (!strncmp(recv_buf, "start", 5)) {
                        xil_printf("INFO: start command is rcvd.\r\n");
                        xSemaphoreGive(xCmdrcvd2DmaSemaphore);
                        vTaskSuspend(NULL);
                    } else {
                        xil_printf("INFO: unknown command\r\n");
                    }
                }
                flush_buff(recv_buf);
            }
            if (quit_flag > 0) {
                break;
            }
        }
    }

    vTaskSuspendAll();
    return;
}
