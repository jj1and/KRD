import sys
import itertools
import re
import glob
import numpy as np
from lmfit import minimize, Parameters, report_fit
import pandas as pd
import matplotlib.pyplot as plt

plt.rcParams['xtick.direction'] = 'in'
plt.rcParams['ytick.direction'] = 'in'
plt.rcParams['axes.grid'] = True

def bin2dec(bits):
    return -int(bits[0]) << len(bits) | int(bits, 2)

def func(params, x):
    amp = params['amp']
    phase = params['phase']
    freq = params['freq']
    base = params['base']
    y = amp*np.sin(2*np.pi*freq*x+phase) + base
    return y

def residual(params, x, data, eps_data):
    y = func(params, x)
    return (data - y)/eps_data

def line_func(params, x):
    raw_att = params['raw_att']
    adc_offset = params['adc_offset']
    y = raw_att*x + adc_offset
    return y

def line_residual(params, x, data, eps_data):
    y = line_func(params, x)
    return (data - y)/eps_data

osc_measure_dict = {
    '0.05Vpp':26.2,
    '0.10Vpp':51.5,
    '0.15Vpp':75.3,
    '0.20Vpp':103,
    '0.25Vpp':127,
    '0.30Vpp':151,
    '0.35Vpp':174,
    '0.40Vpp':198,
    '0.45Vpp':222,
    '0.50Vpp':246,
    '0.55Vpp':278,
    '0.60Vpp':302,
    '0.65Vpp':326,
    '0.70Vpp':351,
    '0.75Vpp':374,
    '0.80Vpp':398,
    '0.85Vpp':422,
    '0.90Vpp':447,
    '0.95Vpp':471,
    '1.00Vpp':495,
    '1.05Vpp':533,
    '1.10Vpp':558,
    '1.15Vpp':579,
    '1.20Vpp':605
}

file_base_name = "C:/Users/MoGURA/KRD/project_tcl/ZCU111/TwoChMixer_test/ILA_Data/Linerity_eval2/20200129_50MHz_"
file_end_name = "Vpp_2.csv"

search_column = 1 # you must decidecheck manually by reading .vcd
valid_enable = True
valid_column = 33

if __name__ == "__main__":

    param_dframe_csv = "C:/Users/MoGURA/KRD/project_tcl/ZCU111/TwoChMixer_test/ILA_Data/Linerity_eval2/fit_results.csv"
    if (glob.glob(param_dframe_csv)!=[]):
        pass
    else:
        param_dframe = pd.DataFrame({'amp':[], 'amp_err':[], 'freq':[], 'freq_err':[], 'phase':[], 'phase_err':[], 'base':[], 'base_err':[]}, index=[])
        for i in np.linspace(0.050, 1.20, 24, endpoint=True):
            vcd_file_path_csv = file_base_name+'{0:1.2f}'.format(i)+file_end_name
            print("loading "+vcd_file_path_csv)
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

            """ convert bit string to int16. generate x-array """
            tmp_y = np.array([[bin2dec(bits[48:64]), bin2dec(bits[32:48]), bin2dec(bits[16:32]), bin2dec(bits[0:16])] for bits in dframe.iloc[:, search_column].values], dtype='int16').reshape(-1,)
            tmp_x = np.arange(0, len(dframe)*4)

            fit_params = Parameters()
            fit_params.add('amp', value=i)
            fit_params.add('freq', value=50*1E-3)
            fit_params.add('phase', value=0)
            fit_params.add('base', value=0)
            fit_x = (tmp_x[(header_list[-1]+1)*4:(footer_list[-1]-1)*4]-(header_list[-1]+1)*4)/2.048
            fit_y = (tmp_y[(header_list[-1]+1)*4:(footer_list[-1]-1)*4]+2048)/4095 -0.5
            # eps_data = 1000*1E-6*np.ones(len(fit_y)) #1000 micro volt
            eps_data = 1.27*1E-3*np.ones(len(fit_y)) #measured result            

            fit_result = minimize(residual, fit_params, args=(fit_x, fit_y, eps_data))
            report_fit(fit_result)

            tmp_param_array = [[fit_result.params.valuesdict()[key], np.sqrt(fit_result.covar.diagonal()[j]) ] for j, key in enumerate(fit_result.params.valuesdict().keys())]
            param_dframe.loc["{0:1.2f}Vpp".format(i)] = list(itertools.chain.from_iterable(tmp_param_array))

            plot_x = np.linspace(min(fit_x), max(fit_x), 1000)
            plt.title("Input:{0:1.2f}Vpp".format(i))
            plt.xlabel("Time [nsec]")
            plt.ylabel("Voltage [V]")
            plt.scatter(fit_x, fit_y, label="data")
            plt.plot(plot_x, func(fit_result.params, plot_x), label="fit result", color='orange')
            plt.legend()
            plt.savefig("C:/Users/MoGURA/KRD/project_tcl/ZCU111/TwoChMixer_test/ILA_Data/Linerity_eval2/"+"fit_result_{0:1.2f}Vpp.png".format(i))
            plt.close()
        param_dframe.to_csv(param_dframe_csv)

    param_dframe = pd.read_csv(param_dframe_csv, header=0, index_col=0)
    osc_measure_array = np.array([osc_measure_dict[key] for key in osc_measure_dict.keys()])

    amp_array = np.abs(param_dframe['amp'])*1E3
    amp_err_array = param_dframe['amp_err']*1E3

    linear_params = Parameters()
    linear_params.add('raw_att', value=1.0)
    linear_params.add('adc_offset', value=0.0)
    linear_fit_result = minimize(line_residual, linear_params, args=(osc_measure_array, amp_array, amp_err_array))
    print("\n---------------------- Show linearity evaluation result ----------------------")
    report_fit(linear_fit_result)

    loss = -20*np.log10(linear_fit_result.params.valuesdict()['raw_att'])
    adc_offset = linear_fit_result.params.valuesdict()['adc_offset']
    adc_offset_err = np.sqrt(linear_fit_result.covar.diagonal()[1])

    plt.title("RF-ADC Linearity Evaluation (Input:50MHz Sine wave)")
    plt.xlabel("measured result (oscilloscope) [mV]")
    plt.ylabel("ADC output [mV]")

    plt.plot(osc_measure_array, line_func(linear_fit_result.params, osc_measure_array), label='fit result ( Loss:{0:1.2f}[dB], Offset:{1:1.2f}+/-{2:1.2f}[mV] )'.format(loss, adc_offset, adc_offset_err), color='orange')
    plt.errorbar(osc_measure_array, amp_array, yerr=amp_err_array, fmt='o', markersize=3, label='data')
    plt.legend()
    plt.show()