# @tokoroten-lab 氏のコードを参考にしています
# https://qiita.com/tokoroten-lab/items/bb27351b393f087650a9
import numpy as np
import matplotlib.pyplot as plt
import pickle
import time
import socket
import sys
import glob

# plt.rcParams['xtick.direction'] = 'in'
# plt.rcParams['ytick.direction'] = 'in'
plt.rcParams['axes.grid'] = True

IP_ADDR = '192.168.10.106'
# IP_ADDR = '127.0.0.1'
PACKET_HEADER_SIZE = 8

save_date = time.strftime("%Y%m%d", time.localtime())
SAVE_FILE_BASE_NAME = "./util_code/data/recv_buff_"
SAVE_FILE_EXTENTION = ".bin"
SAVE_FIG_EXTENTION = ".pkl"



def data_recv(sock):
    buff = bytes()
    packets_recv_info = list()
    while True:
        try:
            # サーバからのデータをバッファに蓄積
            tmp_stime = time.perf_counter()          
            data = sock.recv(8*256)
            if(len(buff)==0):
                print("rx start")
                stime = tmp_stime
            etime = time.perf_counter()
            packets_recv_info.append((tmp_stime, etime, len(buff), len(data)))
            if(len(data)==0):
                print("rx end. socket is closed by server")
                break
            buff += data

            # # 最新のパケットの先頭までシーク
            # # バッファに溜まってるパケット全ての情報を取得
            # packet_head = 0
            # packets_info = list()
            # while True:
            #     if len(buff) >= packet_head + PACKET_HEADER_SIZE:
            #         binary_size = ((int.from_bytes(buff[packet_head:packet_head + PACKET_HEADER_SIZE], 'little')&0xFFF) + 1)*8
            #         if len(buff) >= packet_head + PACKET_HEADER_SIZE + binary_size:
            #             packets_info.append((packet_head, binary_size))
            #             packet_head += PACKET_HEADER_SIZE + binary_size
            #         else:
            #             break
            #     else:
            #         break
            # # バッファの中に完成したパケットがあれば、画像を更新
            # if len(packets_info) > 0:
            #     # 最新の完成したパケットの情報を取得
            #     packet_head, binary_size = packets_info.pop()
            #     # # パケットからデータのバイナリを取得
            #     df_bytes = buff[packet_head:packet_head + PACKET_HEADER_SIZE + binary_size]
            #     # バッファから不要なバイナリを削除
            #     buff = buff[packet_head + PACKET_HEADER_SIZE + binary_size:]
            #     df = np.frombuffer(df_bytes, dtype=np.uint64)
            #     print("\n", end='')
            #     print("packet size is {0:d} * 8byte".format(int(binary_size/8)+1))
            #     for i, ele in enumerate(df):
            #         if (i+1) % 4 ==0:
            #             print('{0:016x}\n'.format(ele), end='')
            #         else:
            #             print('{0:016x} '.format(ele), end='')
        except KeyboardInterrupt:
            print('interrupted!')
            print("{0:d} byte remains in buffer".format(len(buff)))
            break
    return buff, stime, packets_recv_info


if __name__ == "__main__":
    recv_buff = bytes()
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.connect((IP_ADDR, 5001))
        recv_buff, start_time, recv_info = data_recv(s)
        s.close()

    file_number = 0
    while file_number < 100:
        save_file_name = SAVE_FILE_BASE_NAME+save_date+"_{0:02d}".format(file_number)+SAVE_FILE_EXTENTION
        if (glob.glob(save_file_name)==[]):
            break
        else:
            file_number += 1
    with open(save_file_name, "wb") as fout:
        fout.write(recv_buff)
    
    x = np.array([])
    delta_arry = np.array([])
    y = np.array([])
    for i, ele in enumerate(recv_info):
        rela_stime = ele[0]-start_time
        rela_etime = ele[1]-start_time
        delta = ele[1]-ele[0]
        byte_size = ele[2]
        x = np.append(x, [rela_etime])
        delta_arry = np.append(delta_arry, [delta])
        y = np.append(y, [byte_size])
        if (delta>0):
            Mbps_speed = (ele[2]*8/rela_etime)*1E-6
        else:
            Mbps_speed = -1
        # print("Loop No.:{0:4d} | Start:{1:10.5f} sec | End:{2:10.5f} sec | Delta:{3:15.5f} msec | Size:{4:3.2f} MByte | Speed:{5:5.2f} Mbps".format(i, rela_stime, rela_etime, delta*1E3, byte_size*1E-6, Mbps_speed))
    
    valid_data_index = np.where((delta_arry*1E3)<5000)
    valid_x = x[valid_data_index]
    valid_y = y[valid_data_index]

    MEAN_NUM = 50
    smooth_ary = np.ones(MEAN_NUM)/MEAN_NUM
    smoothed_valid_y = np.convolve(valid_y, smooth_ary, mode='valid')
    smoothed_valid_x = np.convolve(valid_x, smooth_ary, mode='valid')

    fig, ax1 = plt.subplots()
    ax2 = ax1.twinx()

    ax1.set_title("Receiving speed time variation")
    ax1.set_xlabel("Time [msec]")
    ax1.set_ylabel("Buffer size(Accumulation) [MByte]")
    ax2.set_ylabel("Speed [Mbps]")

    ax2.plot(smoothed_valid_x*1E3, np.gradient(smoothed_valid_y, smoothed_valid_x)*8*1E-6, label="Speed", color='darkorange', marker='.', markersize=8, zorder=0)
    ax1.plot(valid_x*1E3, valid_y*1E-6, label="Buffer size", color='steelblue', marker='.', markersize=8, zorder=10)

    handler1, label1 = ax1.get_legend_handles_labels()
    handler2, label2 = ax2.get_legend_handles_labels()
    ax1.legend(handler1 + handler2, label1 + label2, loc='lower right')

    save_fig_name = SAVE_FILE_BASE_NAME+save_date+"_{0:02d}".format(file_number)+SAVE_FIG_EXTENTION
    with open(save_fig_name, mode='wb') as figout:
        pickle.dump(fig, figout)

    plt.show()