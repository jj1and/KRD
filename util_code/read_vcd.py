import sys
import re
import glob
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

plt.rcParams['xtick.direction'] = 'in'
plt.rcParams['ytick.direction'] = 'in'
plt.rcParams['axes.grid'] = True

def bin2dec(bits):
    return -int(bits[0]) << len(bits) | int(bits, 2)

vcd_file_path = "C:/Users/MoGURA/KRD/project_tcl/ZCU111/TwoChMixer_test/ILA_Data/noise_eval3/20200204_noise3.vcd"
# vcd_file_path = "C:/Users/MoGURA/KRD/project_tcl/ZCU111/TwoChMixer_test/ILA_Data/20200128_mixer_12MHz.vcd"
search_column = 1 # you must decidecheck manually by reading .vcd
valid_enable = True
valid_column = 33
channel_select = True
channel_number = 0
# search_column = 0 # you must decidecheck manually by reading .vcd
# valid_enable = True
# valid_column = 11


graph_type_continue = False

if __name__ == "__main__":
    
    vcd_file_path_csv = vcd_file_path.replace('.vcd', '.csv')

    if (glob.glob(vcd_file_path_csv)!=[]):
        pass
    else:
        """ convert .vcd file to .csv """
        data = ""
        # each columns' info: len, delimiter
        column_info = {}
        dframe = pd.DataFrame()
        lines = []

        with open(vcd_file_path) as f:
            data = f.read()
        
        lines = data.split("\n")
        last = int(re.split("\n#", data)[-1].split("\n")[0])
        done = 0
        clock = 0
        temp_data = []
        for n, line in enumerate(lines):
            if (clock % 100 == 0):
                progress = int(10*clock/last)
                print("\r #{0:d} / {1:d} clock is loaded".format(int(clock), int(last)) + " [" + '='*progress + '>' + ' '*(9-progress) + "]", end='')
            if ((clock==last) & (done==0)):
                print("\r #{0:d} / {1:d} clock is loaded".format(int(clock), int(last)) + " [" + '='*10 + "] load done!", end='\n')
                done = 1
            elements = line.split(" ")
            if (elements[0]=="$var"):
                # add variable name to columns 
                dframe[elements[4]] = 0
                # add space when delimiter is " or b
                if (int(elements[2])>1):
                    elements[3] = " " + elements[3]
                temp_dict = {"len":int(elements[2]), "delimiter":elements[3]}
                column_info[elements[4]] = temp_dict
                temp_data = [0 for i in dframe.columns.values] 
            if (line.startswith("#")):
                old_clock = clock
                clock = int(line.split("#")[1])
                if (clock==old_clock+1):
                    dframe.loc[str(old_clock)] = temp_data
                    continue
                else:
                    temp_df = pd.DataFrame([temp_data for j in range(old_clock, clock)], index=[j for j in range(old_clock, clock)], columns=dframe.columns.values)
                    dframe = dframe.append(temp_df)
            elif (line.startswith("$")==False):
                for i, column in enumerate(dframe.columns.values):
                    if (line.endswith(column_info[column]["delimiter"])):
                        if (line.startswith('b')):
                            temp_data[i] = "0"*(column_info[column]["len"]-len(line.split(column_info[column]["delimiter"])[0][1:])) + line.split(column_info[column]["delimiter"])[0][1:]
                        else:
                            temp_data[i] = line.split(column_info[column]["delimiter"])[0]
                        break
                    else:
                        temp_data[i] = temp_data[i]
        dframe.loc[str(clock)] = temp_data
        dframe.to_csv(vcd_file_path_csv)
    
    dframe = pd.read_csv(vcd_file_path_csv, header=0, index_col=0)       

    """ data frame search """
    search_column_name = dframe.columns.values[search_column]
    print("your search_column name is " + search_column_name)
    if valid_enable:
        valid_column_name = dframe.columns.values[valid_column]
        print("your valid_column name is " + valid_column_name)


    if (type(dframe.iloc[0, search_column]) is not str):
        print("your selected column is not ADC output (str). the column data type is " + str(type(dframe.iloc[0, search_column])))
        sys.exit()        
    if (len(dframe.iloc[0, search_column])<64):
        print("your selected column is not ADC output (64bit width). the column data width is {0:d}bit".format(len(dframe.iloc[0, search_column])))
        sys.exit()

    if (valid_enable):
        header_df = dframe[dframe.iloc[:, search_column].str.startswith("1010101010101010") & dframe.iloc[:, valid_column]==1] # starts with "AAAA"
        if (list(header_df.index)==[]):
            print("Any data frame were not found.")
            sys.exit(0)
        footer_df = dframe.iloc[list(header_df.index)[0]:, :] # search footer for dframe[index > first index of header]
        footer_df = footer_df[footer_df.iloc[:, search_column].str.endswith("0101010101010101") & footer_df.iloc[:, valid_column]==1] # end with "5555"
        if (list(footer_df.index)==[]):
            print("all footer were missing.")
            sys.exit(0)        
    else:
        header_df = dframe[dframe.iloc[:, search_column].str.startswith("1010101010101010")] # starts with "AAAA"
        if (list(header_df.index)==[]):
            print("Any data frame were not found.")
            sys.exit(0)
        footer_df = dframe.iloc[list(header_df.index)[0]:, :] # search footer for dframe[index > first index of header]
        footer_df = footer_df[footer_df.iloc[:, search_column].str.endswith("0101010101010101")] # end with "5555"
        if (list(footer_df.index)==[]):
            print("all footer were missing.")
            sys.exit(0)

    frame_num = min([len(header_df), len(footer_df)])
    header_list = [ele for ele in header_df.index][0:frame_num]
    footer_list = [ele for ele in footer_df.index][0:frame_num]
    
    if ((len(header_list)-len(footer_list))**2 > 4):
        print("header or footer is too many. Please check you need VALID signal.")
    print("found header is below.")
    print(header_list)
    print("found footer is below.")
    print(footer_list)    

    """ convert bit string to int16. generate x-array """
    y = np.array([[bin2dec(bits[48:64]), bin2dec(bits[32:48]), bin2dec(bits[16:32]), bin2dec(bits[0:16])] for bits in dframe.iloc[:, search_column].values], dtype='int16').reshape(-1,)
    x = np.arange(0, len(dframe)*4)

    fig = plt.figure()
    ax = fig.add_subplot(111)
    ax.set_title("typical waveform, ADC:1V pk-pk/4096, Input waveform:sine wave")
    ax.set_xlabel("Time [nsec]")
    ax.set_ylabel("Amp. [V]")


    first_df_timestamp_nsec = bin2dec('0' + dframe.at[footer_list[0], search_column_name][32:48] + dframe.at[header_list[0], search_column_name][20:52])*2
    if (graph_type_continue):
        for i in range(frame_num):
            timestamp_lower_bits = dframe.at[header_list[i], search_column_name][20:52]
            timestamp_higher_bits = dframe.at[footer_list[i], search_column_name][32:48]
            timestamp_nsec = bin2dec('0'+timestamp_higher_bits+timestamp_lower_bits)*2
            # 1clock = 4nsec / 1clock contains 4 word
            if (channel_select):
                if (int(dframe.at[header_list[i], search_column_name][16:20])==channel_number):
                    ax.plot((x[(header_list[i]+1)*4:(footer_list[i]-1)*4])/2.048 + timestamp_nsec-first_df_timestamp_nsec, (y[(header_list[i]+1)*4:(footer_list[i]-1)*4]+2048)/4095-0.5, label="{0:.0f} nsec".format(timestamp_nsec-first_df_timestamp_nsec))
                    ax.legend()
                else:
                    pass
            else:
                ax.plot((x[(header_list[i]+1)*4:(footer_list[i]-1)*4])/2.048 + timestamp_nsec-first_df_timestamp_nsec, (y[(header_list[i]+1)*4:(footer_list[i]-1)*4]+2048)/4095-0.5, label="{0:.0f} nsec".format(timestamp_nsec-first_df_timestamp_nsec))
                ax.legend()                
      
    else:
        # for i in range(frame_num):
        for i in [1]:
            timestamp_lower_bits = dframe.at[header_list[i], search_column_name][20:52]
            timestamp_higher_bits = dframe.at[footer_list[i], search_column_name][32:48]
            timestamp_nsec = bin2dec('0'+timestamp_higher_bits+timestamp_lower_bits)*2
            # 1clock = 4nsec / 1clock contains 4 word
            if (channel_select):
                if (int(dframe.at[header_list[i], search_column_name][16:20])==channel_number):
                    ax.plot((x[(header_list[i]+1)*4:(footer_list[i]-1)*4]-(header_list[i]+1)*4)/2.048, (y[(header_list[i]+1)*4:(footer_list[i]-1)*4]+2048)/4095-0.5, label="{0:.0f} nsec".format(timestamp_nsec-first_df_timestamp_nsec))
                    ax.legend()
                else:
                    pass
            else:            
                ax.plot((x[(header_list[i]+1)*4:(footer_list[i]-1)*4]-(header_list[i]+1)*4)/2.048, (y[(header_list[i]+1)*4:(footer_list[i]-1)*4]+2048)/4095-0.5, label="{0:.0f} nsec".format(timestamp_nsec-first_df_timestamp_nsec))
                ax.legend()

        # tmp_x = (x[(header_list[2]+1)*4:(footer_list[2]-1)*4]-(header_list[2]+1)*4)/2.048
        # tmp_y = (y[(header_list[2]+1)*4:(footer_list[2]-1)*4]+2048)/4095 -0.5
        # tmp_data = np.hstack((tmp_x.reshape(-1,1), tmp_y.reshape(-1,1)))
        # np.savetxt("./project_tcl/ZCU111/TwoChMixer_test/ILA_Data/2048Msps_12MHz.dat", tmp_data)

    
        
    plt.show()