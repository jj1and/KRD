# @tokoroten-lab 氏のコードを参考にしています
# https://qiita.com/tokoroten-lab/items/bb27351b393f087650a9
import time
import socket
import glob

IP_ADDR = '192.168.1.2'
# IP_ADDR = '127.0.0.1'
PACKET_HEADER_SIZE = 8

save_date = time.strftime("%Y%m%d", time.localtime())
SAVE_FILE_BASE_NAME = "./data/recv_buff_v3_"
SAVE_FILE_EXTENTION = ".bin"
# SAVE_FIG_EXTENTION = ".pkl"


def data_recv(sock):
    buff = bytes()
    while True:
        try:
            data = sock.recv(int(20E6))
            if(len(buff) == 0):
                start = time.perf_counter()
                print("rx start")
            if not data:
                end = time.perf_counter()
                print("rx end. socket is closed by client")
                break
            buff += data
        except KeyboardInterrupt:
            print('interrupted!')
            print("{0:d} byte remains in buffer".format(len(buff)))
            break
    return buff, start, end


if __name__ == "__main__":
    recv_buff = bytes()
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.bind((IP_ADDR, 5001))
        s.listen(1)
        print("Waiting connection from dummy FEE")
        conn, addr = s.accept()
        with conn:
            try:
                print("Connection from ", addr)

                recv_buff, recv_start, recv_end = data_recv(conn)
            finally:
                print("socket close ", addr)
                s.close()
                print("Receive size:{0:.2f}MBytes, Speed:{1:.2f} Mbps".format(
                    len(recv_buff)*1E-6, len(recv_buff)/(recv_end-recv_start)*8*1E-6))

    file_number = 0
    while file_number < 100:
        save_file_name = SAVE_FILE_BASE_NAME+save_date + \
            "_{0:02d}".format(file_number)+SAVE_FILE_EXTENTION
        if (glob.glob(save_file_name) == []):
            break
        else:
            file_number += 1
    with open(save_file_name, "wb") as fout:
        fout.write(recv_buff)
