import pickle
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# plt.rcParams['xtick.direction'] = 'in'
# plt.rcParams['ytick.direction'] = 'in'
plt.rcParams['axes.grid'] = True

BASE_FILE_NAME = "util_code/recv_buff_20200427_02.bin"

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
    perf_ax.set(title="processing time/frame(cycle) ", xlabel="Frame Number", ylabel="Interval[usec]")
    dma_start2dma_inter_end = (perf_pddf.iloc[1:-1,1]-perf_pddf.iloc[1:-1,0])/XPAR_CPU_CORTEXA53_0_TIMESTAMP_CLK_FREQ_Hz*1E6
    dma_start2dma_end = (perf_pddf.iloc[1:-1,2]-perf_pddf.iloc[1:-1,0])/XPAR_CPU_CORTEXA53_0_TIMESTAMP_CLK_FREQ_Hz*1E6
    dma_inter_end2dma_end = (perf_pddf.iloc[1:-1,2]-perf_pddf.iloc[1:-1,1])/XPAR_CPU_CORTEXA53_0_TIMESTAMP_CLK_FREQ_Hz*1E6
    dma_end2queue_recv = (perf_pddf.iloc[1:-1,4]-perf_pddf.iloc[1:-1,2])/XPAR_CPU_CORTEXA53_0_TIMESTAMP_CLK_FREQ_Hz*1E6
    queue_recv2send2pc_end = (perf_pddf.iloc[1:-1,3]-perf_pddf.iloc[1:-1,4])/XPAR_CPU_CORTEXA53_0_TIMESTAMP_CLK_FREQ_Hz*1E6
    # print(perf_pddf.loc[1:-1,:][dma_start2dma_end<0]/XPAR_CPU_CORTEXA53_0_TIMESTAMP_CLK_FREQ_Hz)
    # perf_ax.stackplot(perf_pddf.index.values[1:-1], dma_start2dma_inter_end, dma_inter_end2dma_end, dma_end2send2pc_end, labels=["dma start -> dma intr end", "dma intr end -> dma end", "dma end -> send2pc end"])
    perf_ax.stackplot(perf_pddf.index.values[1:-1], dma_start2dma_end, dma_end2queue_recv, queue_recv2send2pc_end, labels=["DMA start -> DMA end", "DMA end -> Queue recived", "Queue recieved -> TCP/IP-task end"], colors=['steelblue', 'green', 'darkorange'])
    perf_ax.legend()
    
    # size of frame = (frame_size + header*4 + footer*4) * 16bit
    frame_sizes = np.array([(pdsettings[key]['frame_size']+2*4)*16 for key in pdkeys])
    effective_speed_Mbps = frame_sizes[1:]/(dma_start2dma_end+dma_end2queue_recv+queue_recv2send2pc_end)
    hit_timeline = np.array([pdsettings[key]['timestamp'] for key in pdkeys ], dtype='uint64')/TIMESTAMP_CLK_Hz
    speed_fig, (speed_ax, timeline_ax) = plt.subplots(2,1)
    # timeline_ax = speed_ax.twinx()
    speed_ax.set(title="PS-PC transport speed (DMA start -> TCP/IP-task end)", xlabel="Frame Number", ylabel="Speed[Mbps]", yscale='log', xlim=[0,len(perf_pddf)+1])
    speed_ax.plot(perf_pddf.index.values[1:-1], effective_speed_Mbps, color='firebrick', label="effective speed", zorder=3)
    timeline_ax.set(title="Hit period",xlabel='Frame number', ylabel='Interval ( Frame[i] - Frame[i-1]; i>0 ) [usec]', yscale='log', xlim=[0,len(perf_pddf)+1])
    timeline_ax.plot(perf_pddf.index.values[1:-1], (hit_timeline[1:]-hit_timeline[0:-1])*1E6, zorder=2, color='darkblue', label='hit interval')
    timeline_ax.plot([-1,10000],[1, 1], color='red')
    # handler1, label1 = speed_ax.get_legend_handles_labels()
    # handler2, label2 = timeline_ax.get_legend_handles_labels()


    compare_speed_fig, compare_speed_ax = plt.subplots()
    compare_speed_ax.set(title="PS-PC transport speed", xlabel="Frame Number", ylabel="Speed[Mbps]", yscale='log')
    compare_speed_ax.plot(perf_pddf.index.values[1:-1], frame_sizes[1:]/dma_start2dma_end, color='steelblue', zorder=3, label='DMA start -> DMA end')
    compare_speed_ax.plot(perf_pddf.index.values[1:-1], frame_sizes[1:]/dma_end2queue_recv, color='green', zorder=2, label='DMA end -> Queue recv')
    compare_speed_ax.plot(perf_pddf.index.values[1:-1], frame_sizes[1:]/queue_recv2send2pc_end, color='darkorange', zorder=1, label='Queue recv -> TCP/IP-task end')
    compare_speed_ax.legend()

    print(pddfs[pddfs.iloc[:, 1]<-1000])
    pddfs_partial = pddfs.loc[(0, [pdsettings[pdkeys[i]]['timestamp'] for i in range(0, 60)]), :]
    pddfs_timestamp = pddfs_partial.index.get_level_values(1)
    fig, ax = plt.subplots()
    ax.set_title("Acquired data")
    ax.set_xlabel("Time[nsec]")
    ax.set_ylabel("ADC")
    ax.set_ylim(-2049, 2049)
    ax.plot((pddfs_timestamp-pddfs_timestamp[0])/TIMESTAMP_CLK_Hz*1E9+pddfs_partial.iloc[:, 0]/EFFECTIVE_ADC_CLK_Hz*1E9, pddfs_partial.iloc[:, 1])
    
    plt.show()