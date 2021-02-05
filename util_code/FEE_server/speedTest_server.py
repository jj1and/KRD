import time
import socket

IP_ADDR = '192.168.1.2'
# IP_ADDR = '127.0.0.1'


def size_recv(sock):
    buff_size = 0
    while True:
        try:
            data = sock.recv(int(20E6))
            end = time.perf_counter()
            if (buff_size == 0):
                start = time.perf_counter()
                print("rx start")
            elif not data:
                print("rx end. socket is closed by client")
                break
            buff_size += len(data)
        except KeyboardInterrupt:
            print('interrupted!')
            print("{0:d} byte remains in buffer".format(buff_size))
            break
    return buff_size, start, end


if __name__ == "__main__":
    recv_buff_size = 0
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.bind((IP_ADDR, 5001))
        s.listen(1)
        print("Waiting connection from dummy FEE")
        conn, addr = s.accept()
        with conn:
            try:
                print("Connection from ", addr)

                recv_buff_size, recv_start, recv_end = size_recv(conn)
            finally:
                print("socket close ", addr)
                s.close()
                print("Receive size:{0:.2f}MBytes, Speed:{1:.2f} Mbps".format(
                    recv_buff_size*1E-6, recv_buff_size/(recv_end-recv_start)*8*1E-6))
