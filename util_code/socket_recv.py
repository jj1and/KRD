# @tokoroten-lab 氏のコードを参考にしています
# https://qiita.com/tokoroten-lab/items/bb27351b393f087650a9
import numpy as np
import time
import socket
import sys

IP_ADDR = '192.168.10.106'
#IP_ADDR = '127.0.0.1'
PACKET_HEADER_SIZE = 8
buff = bytes()



def data_recv(sock, buff):
    total_recieved_buff_size = 0
    first_df = True
    while True:
        try:
            # サーバからのデータをバッファに蓄積
            data = sock.recv(8*256)
            if(len(data)==0):
                print("\nrx end. socket is closed by server")
                break
            buff += data

            # 最新のパケットの先頭までシーク
            # バッファに溜まってるパケット全ての情報を取得
            packet_head = 0
            packets_info = list()
            while True:
                if len(buff) >= packet_head + PACKET_HEADER_SIZE:
                    binary_size = ((int.from_bytes(buff[packet_head:packet_head + PACKET_HEADER_SIZE], 'little')&0xFFF) + 1)*8
                    total_recieved_buff_size += (PACKET_HEADER_SIZE + binary_size)
                    if len(buff) >= packet_head + PACKET_HEADER_SIZE + binary_size:
                        packets_info.append((packet_head, binary_size))
                        packet_head += PACKET_HEADER_SIZE + binary_size
                    else:
                        break
                else:
                    break
            # バッファの中に完成したパケットがあれば、画像を更新
            if len(packets_info) > 0:
                # # 最新の完成したパケットの情報を取得
                # packet_head, binary_size = packets_info.pop()
                # # パケットからデータのバイナリを取得
                # df_bytes = buff[packet_head:packet_head + PACKET_HEADER_SIZE + binary_size]
                # # バッファから不要なバイナリを削除
                # buff = buff[packet_head + PACKET_HEADER_SIZE + binary_size:]
                # df = np.frombuffer(df_bytes, dtype=np.uint64)
                # print("\n", end='')
                # print("packet size is {0:d} * 8byte".format(int(binary_size/8)+1))
                # for i, ele in enumerate(df):
                #     if (i+1) % 4 ==0:
                #         print('{0:016x}\n'.format(ele), end='')
                #     else:
                #         print('{0:016x} '.format(ele), end='')
                if(first_df):
                    start_time = time.time()
                    print("rx start")
                    first_df = False
                tmp_end_time = time.time()
        except KeyboardInterrupt:
            print('interrupted!')
            print("{0:d} byte remains in buffer".format(len(buff)))
            break
    return total_recieved_buff_size, tmp_end_time - start_time


if __name__ == "__main__":
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.connect((IP_ADDR, 5001))
        total_rx_data_size, rx_time = data_recv(s, buff)
        s.close()
    data_rate = total_rx_data_size*8/rx_time
    print("{0:.2f} MByte recived : {1:.2f} sec : {2:.2f} Mbps".format(total_rx_data_size*1E-6, rx_time, data_rate*1E-6))
