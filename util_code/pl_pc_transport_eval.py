import pickle
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

BASE_FILE_NAME = "util_code/recv_buff_20200423_01.bin"

COMPRESSION_TYPE = 'zip'
pickle_pddfs_name = BASE_FILE_NAME.replace('.bin', '_pddfs.pkl')+'.'+COMPRESSION_TYPE
pickle_pdkeys_name = BASE_FILE_NAME.replace('.bin', '_pdkeys.pkl')
pickle_pdsettings_name = BASE_FILE_NAME.replace('.bin', '_pdsettings.pkl')
pickle_perf_pddf_name = BASE_FILE_NAME.replace('.bin', '_perf_pddf.pkl')+'.'+COMPRESSION_TYPE

TIMESTAMP_CLK_Hz = 256*1E6
EFFECTIVE_ADC_CLK_Hz = 2.048*1E9
SAMPLE_PER_TIMESTAMP_CLK = int(EFFECTIVE_ADC_CLK_Hz/TIMESTAMP_CLK_Hz)
XPAR_CPU_CORTEXA53_0_TIMESTAMP_CLK_FREQ_Hz = 99999001

if __name__ == "__main__":
    pdkeys = []
    pdsettings = {}
    perf_pddf = pd.read_pickle(pickle_perf_pddf_name, compression=COMPRESSION_TYPE)
    pddfs = pd.read_pickle(pickle_pddfs_name, compression=COMPRESSION_TYPE)
    with open(pickle_pdkeys_name, mode='rb') as fpdkeys:
        pdkeys = pickle.load(fpdkeys)
    with open(pickle_pdsettings_name, mode='rb') as fpdsettings:
        pdsettings = pickle.load(fpdsettings)

    perf_fig, perf_ax = plt.subplots()
    perf_ax.set(title="PS process performace", xlabel="Frame Number", ylabel="Interval[usec]")
    dma_start2dma_inter_end = (perf_pddf.iloc[1:-1,1]-perf_pddf.iloc[1:-1,0])/XPAR_CPU_CORTEXA53_0_TIMESTAMP_CLK_FREQ_Hz*1E6
    dma_start2dma_end = (perf_pddf.iloc[1:-1,2]-perf_pddf.iloc[1:-1,0])/XPAR_CPU_CORTEXA53_0_TIMESTAMP_CLK_FREQ_Hz*1E6
    dma_inter_end2dma_end = (perf_pddf.iloc[1:-1,2]-perf_pddf.iloc[1:-1,1])/XPAR_CPU_CORTEXA53_0_TIMESTAMP_CLK_FREQ_Hz*1E6
    dma_end2send2pc_end = (perf_pddf.iloc[1:-1,3]-perf_pddf.iloc[1:-1,2])/XPAR_CPU_CORTEXA53_0_TIMESTAMP_CLK_FREQ_Hz*1E6
    # print(perf_pddf.loc[1:-1,:][dma_start2dma_end<0]/XPAR_CPU_CORTEXA53_0_TIMESTAMP_CLK_FREQ_Hz)
    # perf_ax.stackplot(perf_pddf.index.values[1:-1], dma_start2dma_inter_end, dma_inter_end2dma_end, dma_end2send2pc_end, labels=["dma start -> dma intr end", "dma intr end -> dma end", "dma end -> send2pc end"])
    perf_ax.stackplot(perf_pddf.index.values[1:-1], dma_start2dma_end, dma_end2send2pc_end, labels=["dma start -> dma end", "dma end -> send2pc end"])
    perf_ax.legend()
    
    # size of frame = (frame_size + header + footer) * 16bit
    frame_sizes = np.array([(pdsettings[key]['frame_size']+2)*16 for key in pdkeys])
    effective_speed_Mbps = frame_sizes[1:]/(dma_start2dma_end+dma_end2send2pc_end)
    speed_fig, speed_ax = plt.subplots()
    size_ax = speed_ax.twinx()
    speed_ax.set(title="PS-PC transport performace (DMA + TCP/IP)", xlabel="Frame Number", ylabel="Speed[Mbps]")
    speed_ax.plot(perf_pddf.index.values[1:-1],effective_speed_Mbps, color='firebrick', label="Speed", zorder=1)
    size_ax.set(ylabel="Size[Byte]")
    size_ax.scatter(perf_pddf.index.values[1:-1], frame_sizes[1:]/8, color='green', label="Frame size", zorder=2)
    handler1, label1 = speed_ax.get_legend_handles_labels()
    handler2, label2 = size_ax.get_legend_handles_labels()
    speed_ax.legend(handler1 + handler2, label1 + label2, loc='lower right')

    hit_timeline = np.array([pdsettings[key]['timestamp'] for key in pdkeys ], dtype='uint64')/TIMESTAMP_CLK_Hz
    timeline_fig, timeline_ax = plt.subplots()
    timeline_ax.set(title='Hit interval', xlabel='Frame Number', ylabel='Interval(Frame[i]-Frame[i-1];i>0) [usec]', yscale='log')
    timeline_ax.plot(perf_pddf.index.values[1:-1], (hit_timeline[1:]-hit_timeline[0:-1])*1E6)
    
    plt.show()