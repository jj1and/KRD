import glob
import sys
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

plt.rcParams['xtick.direction'] = 'in'
plt.rcParams['ytick.direction'] = 'in'
plt.rcParams['axes.grid'] = True

def convert_complement_on_two_into_decimal(bits):
    return -int(bits[0]) << len(bits) | int(bits, 2)

vcd_file_path = "c:/Users/MoGURA/KRD/project_tcl/ZCU111/MinimumTrigger_test/ILA_Data/iladata_20200110.vcd"

if __name__ == "__main__":
    
    vcd_file_path_csv = vcd_file_path.split('.')[0]+".csv"

    if (glob.glob(vcd_file_path_csv)!=[]):
        dframe = pd.read_csv(vcd_file_path_csv, header=0, index_col=0)
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
        clock = 0
        temp_data = []
        for n, line in enumerate(lines):
            elements = line.split(" ")
            if (elements[0]=="$var"):
                # add variable name to columns 
                dframe[elements[4]] = 0
                # add space when delimiter is " or b
                if (elements[3]=="\"")|(elements[3]=="b"):
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
                        if (line.split(column_info[column]["delimiter"])[0][0]=="b"):
                            temp_data[i] = "0"*(column_info[column]["len"]-len(line.split(column_info[column]["delimiter"])[0][1:])) + line.split(column_info[column]["delimiter"])[0][1:]
                        else:
                            temp_data[i] = line.split(column_info[column]["delimiter"])[0]
                        break
                    else:
                        temp_data[i] = temp_data[i]
        dframe.loc[str(clock)] = temp_data
        dframe.to_csv(vcd_file_path_csv)       
    

    """ data frame search """
    search_column = 1 # you must decidecheck manually by reading .vcd
    if (type(dframe.iloc[0, search_column]) is not str):
        print("your selected column is not ADC output (str). the column data type is " + str(type(dframe.iloc[0, search_column])))
        sys.exit()        
    if (len(dframe.iloc[0, search_column])<64):
        print("your selected column is not ADC output (64bit width). the column data width is {0:d}bit".format(len(dframe.iloc[0, search_column].values)))
        sys.exit()

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

    """ convert bit string to int16. generate x-array """
    y = np.array([[convert_complement_on_two_into_decimal(bits[48:64]), convert_complement_on_two_into_decimal(bits[32:48]), convert_complement_on_two_into_decimal(bits[16:32]), convert_complement_on_two_into_decimal(bits[0:16])] for bits in dframe.iloc[:, search_column].values], dtype='int16').reshape(-1,) 
    x = np.arange(0, len(dframe)*4)

    fig = plt.figure()
    ax = fig.add_subplot(111)
    ax.set_title("typical waveform, ADC:1V pk-pk/4096")
    ax.set_xlabel("Time [nsec]")
    ax.set_ylabel("Amp. [mV]")
    for i in range(frame_num):
        # 1clock = 4nsec / 1clock contains 4 word
        ax.plot((x[(header_list[i]+1)*4:(footer_list[i]-1)*4]-(header_list[i]+1)*4)/4, (y[(header_list[i]+1)*4:(footer_list[i]-1)*4]+2048)/4095 -0.5, label="{0:1.2f}nsec - {1:1.2f}nsec".format((header_list[i]+1)*4/4, (footer_list[i]-1)*4/4))
        ax.legend()
    plt.show()
    