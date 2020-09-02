import sys
import itertools
import re
import glob
import numpy as np
from scipy.fftpack import fftfreq, fft
from lmfit import minimize, Parameters, report_fit
import pandas as pd
import matplotlib.pyplot as plt

plt.rcParams['xtick.direction'] = 'in'
plt.rcParams['ytick.direction'] = 'in'
plt.rcParams['axes.grid'] = True

def bin2dec(bits):
    return -int(bits[0]) << len(bits) | int(bits, 2)

def func(params, x):
    area = params['area']
    mean = params['mean']
    sigma = params['sigma']
    y = area/(np.sqrt(2*np.pi)*sigma)*np.exp(-((x-mean)/sigma)**2/2)
    return y

def residual(params, x, data, eps_data):
    y = func(params, x)
    return (data - y)/eps_data

file_base_name = "C:/Users/MoGURA/KRD/project_tcl/ZCU111/TwoChMixer_test/ILA_Data/noise_eval3/"
file_list = [
    file_base_name + "20200204_noise3.csv", 
    file_base_name + "20200204_noise3_2.csv",
    file_base_name + "20200204_noise3_3.csv",
    file_base_name + "20200204_noise3_4.csv",
    file_base_name + "20200204_noise3_5.csv"    
]
# file_list = [
#     file_base_name + "20200130_noise2.csv", 
#     file_base_name + "20200130_noise2_2.csv",
#     file_base_name + "20200130_noise2_3.csv",
#     file_base_name + "20200130_noise2_4.csv",
#     file_base_name + "20200130_noise2_5.csv"    
# ]
# file_list = [
#     file_base_name + "20200130_noise.csv", 
#     file_base_name + "20200130_noise_2.csv",
#     file_base_name + "20200130_noise_3.csv",
#     file_base_name + "20200130_noise_4.csv",
#     file_base_name + "20200130_noise_5.csv",
#     file_base_name + "20200130_noise_6.csv", 
#     file_base_name + "20200130_noise_7.csv",
#     file_base_name + "20200130_noise_8.csv",
#     file_base_name + "20200130_noise_9.csv",
#     file_base_name + "20200130_noise_10.csv"        
# ]
search_column = 1 # you must decidecheck manually by reading .vcd
valid_enable = True
valid_column = 33

channel_select = True
channel_number = 0

fit_suppress = False
raw_adc_val = False

bin_num = 10

if __name__ == "__main__":

    data_set = {}
    for csv_file_path in file_list: 
        print("\n----------- loading " + csv_file_path + " -----------")
        dframe = pd.read_csv(csv_file_path, header=0, index_col=0)
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

        tmp_dict = {"header_list":header_list, "footer_list":footer_list, "frame_num":frame_num, "dframe":dframe}
        data_set[csv_file_path] = tmp_dict

    ys = np.array([])
    for keys in data_set.keys():
        tmp_df = data_set[keys]["dframe"]
        tmp_header_list = data_set[keys]["header_list"]
        tmp_footer_list = data_set[keys]["footer_list"]
        tmp_frame_num = data_set[keys]["frame_num"]
        y = np.array([[bin2dec(bits[48:64]), bin2dec(bits[32:48]), bin2dec(bits[16:32]), bin2dec(bits[0:16])] for bits in tmp_df.iloc[:, search_column].values], dtype='int16').reshape(-1,)
        for i in range(tmp_frame_num):         
            # plt.title("FFT result:"+keys.split('/')[-1]+", frame_num:{0:d}".format(i))
            # plt.xlabel("Freq [MHz]")
            if (raw_adc_val):
                tmp_y =  y[(tmp_header_list[i]+1)*4:(tmp_footer_list[i]-1)*4]
            else:
                tmp_y =  ((y[(tmp_header_list[i]+1)*4:(tmp_footer_list[i]-1)*4]+2048)/4095-0.5)*1E3
            if (channel_select):
                if (int(tmp_df.at[tmp_header_list[i], search_column_name][16:20])==channel_number):
                    ys = np.hstack((ys, tmp_y))
                else:
                    pass
            else:            
                ys = np.hstack((ys, tmp_y))
            # tmp_freq = fftfreq(len(tmp_y), d=1.0/(2.048*1E9))
            # tmp_std_freq_index =  np.argmin(tmp_freq-50*1E6)
            # plt.ylabel("Amp. [dB] (50MHz = 0dB)")
            # tmp_fft = fft(tmp_y)/(len(tmp_y)/2)
            # tmp_fft_dB = 10*np.log10(np.abs(tmp_fft)/np.abs(tmp_fft[tmp_std_freq_index]))
            # plt.xlim([0, max(tmp_freq)/1E6])
            # plt.plot(tmp_freq[np.where(tmp_freq>0)]/1E6, tmp_fft_dB[np.where(tmp_freq>0)])
            # plt.savefig(file_base_name + "FFT_result_"+keys.split('/')[-1].replace(".csv", "")+"_frame_num_{0:d}.png".format(i))
            # plt.close()



    fig = plt.figure()
    ax = fig.add_subplot(111)
    ax.set_title("Noise distribution, Entries:{0:d} ({1:1.2f}nsec)".format(len(ys), len(ys)/2.048))
    if (raw_adc_val):
        ax.set_xlabel("ADC")
    else:
        ax.set_xlabel("ADC [mV]")
    ax.set_ylabel("Events/bin")
    n, bins, patches = ax.hist(ys, bins=bin_num)

    if (fit_suppress):
        pass
    else:
        y_data = n
        x_data = (bins[1:] + bins[0:-1]) / 2

        init_param = Parameters()
        init_param.add("area", value=1E3)
        init_param.add("mean", value=0.0)
        init_param.add("sigma", value=0.24)

        fit_result = minimize(residual, init_param, args=(x_data, y_data, np.sqrt(y_data)))
        print("\n----------- Show fit reasult -----------")
        report_fit(fit_result)
        fit_mean = fit_result.params.valuesdict()["mean"]
        fit_mean_err = np.sqrt(fit_result.covar.diagonal()[1])
        fit_sigma = fit_result.params.valuesdict()["sigma"]
        fit_sigma_err = np.sqrt(fit_result.covar.diagonal()[2])

        plot_x = np.linspace(x_data[0], x_data[-1], 100)
        ax.plot(plot_x, func(fit_result.params, plot_x), label="fit result (mean:{0:1.2f}+/-{1:1.2f}[mV], sigma:{2:1.2f}+/-{3:1.2f}[mV])".format(fit_mean, fit_mean_err, fit_sigma, fit_sigma_err), color='orange')
        ax.legend()

    plt.show()
