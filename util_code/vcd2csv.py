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

vcd_file_path = "C:/Users/MoGURA/KRD/project_tcl/ZCU111/MinimumTrigger_test/ILA_Data/iladata_20200128_Dummy_ila2.vcd"
search_column = 0 # you must decidecheck manually by reading .vcd
valid_enable = False
valid_column = 36

graph_type_continue = True

if __name__ == "__main__":
    
    vcd_file_path_csv = vcd_file_path.split('.')[0]+".csv"

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
    if (len(dframe.iloc[0, search_column])<96):
        print("your selected column is not ADC output (96bit width). the column data width is {0:d}bit".format(len(dframe.iloc[0, search_column])))
        sys.exit()

    """ convert bit string to int16. generate x-array """
    y = np.array([[bin2dec(bits[84:96]), bin2dec(bits[72:84]), bin2dec(bits[60:72]), bin2dec(bits[48:60]), bin2dec(bits[36:48]), bin2dec(bits[24:36]), bin2dec(bits[12:24]), bin2dec(bits[0:12])] for bits in dframe.iloc[:, search_column].values], dtype='int16').reshape(-1,)
    x = np.arange(0, len(dframe)*8)

    fig = plt.figure()
    ax = fig.add_subplot(111)
    ax.set_title("ILA Data")
    ax.set_xlabel("Time [nsec]")
    ax.set_ylabel("Amp. [mV]")

    ax.scatter(x, (y+2048)/4095 -0.5)
        
    plt.show()