# @tokoroten-lab 氏のコードを参考にしています
# https://qiita.com/tokoroten-lab/items/bb27351b393f087650a9
import numpy as np
import matplotlib.pyplot as plt
import pickle
import time
import socket
import sys
import glob
import time

# plt.rcParams['xtick.direction'] = 'in'
# plt.rcParams['ytick.direction'] = 'in'
plt.rcParams['axes.grid'] = True

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
            if(len(buff)==0):
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
                print("Receive size:{0:.2f}MBytes, Speed:{1:.2f} Mbps".format(len(recv_buff)*1E-6, len(recv_buff)/(recv_end-recv_start)*8*1E-6))


    file_number = 0
    while file_number < 100:
        save_file_name = SAVE_FILE_BASE_NAME+save_date+"_{0:02d}".format(file_number)+SAVE_FILE_EXTENTION
        if (glob.glob(save_file_name)==[]):
            break
        else:
            file_number += 1
    with open(save_file_name, "wb") as fout:
        fout.write(recv_buff)
    
    # x = np.array([])
    # delta_arry = np.array([])
    # y = np.array([])
    # for i, ele in enumerate(recv_info):
    #     rela_stime = ele[0]-start_time
    #     rela_etime = ele[1]-start_time
    #     delta = ele[1]-ele[0]
    #     byte_size = ele[2]
    #     x = np.append(x, [rela_etime])
    #     delta_arry = np.append(delta_arry, [delta])
    #     y = np.append(y, [byte_size])
    #     if (delta>0):
    #         Mbps_speed = (ele[2]*8/rela_etime)*1E-6
    #     else:
    #         Mbps_speed = -1
        # print("Loop No.:{0:4d} | Start:{1:10.5f} sec | End:{2:10.5f} sec | Delta:{3:15.5f} msec | Size:{4:3.2f} MByte | Speed:{5:5.2f} Mbps".format(i, rela_stime, rela_etime, delta*1E3, byte_size*1E-6, Mbps_speed))
    
    # valid_data_index = np.where((delta_arry*1E3)<5000)
    # valid_x = x[valid_data_index]
    # valid_y = y[valid_data_index]

    # MEAN_NUM = 10
    # smooth_ary = np.ones(MEAN_NUM)/MEAN_NUM
    # smoothed_valid_y = np.convolve(valid_y, smooth_ary, mode='valid')
    # smoothed_valid_x = np.convolve(valid_x, smooth_ary, mode='valid')

    # fig, ax1 = plt.subplots()
    # ax2 = ax1.twinx()

    # ax1.set_title("Receiving speed time variation")
    # ax1.set_xlabel("Time [msec]")
    # ax1.set_ylabel("Buffer size(Accumulation) [MByte]")
    # ax2.set_ylabel("Speed [Mbps]")

    # ax2.plot(smoothed_valid_x*1E3, np.gradient(smoothed_valid_y, smoothed_valid_x)*8*1E-6, label="Speed", color='darkorange', marker='.', markersize=8, zorder=0)
    # ax1.plot(valid_x*1E3, valid_y*1E-6, label="Buffer size", color='steelblue', marker='.', markersize=8, zorder=10)

    # handler1, label1 = ax1.get_legend_handles_labels()
    # handler2, label2 = ax2.get_legend_handles_labels()
    # ax1.legend(handler1 + handler2, label1 + label2, loc='lower right')

    # save_fig_name = SAVE_FILE_BASE_NAME+save_date+"_{0:02d}".format(file_number)+SAVE_FIG_EXTENTION
    # with open(save_fig_name, mode='wb') as figout:
    #     pickle.dump(fig, figout)

    plt.show()