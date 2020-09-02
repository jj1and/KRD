import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

BASE_FILE_NAME = "./data/recv_buff_v3_20200902_03.bin"

COMPRESSION_TYPE = 'zip'
pickle_pddfs_name = BASE_FILE_NAME.replace(
    '.bin', '_pddfs.pkl')+'.'+COMPRESSION_TYPE
npz_waveform_name = BASE_FILE_NAME.replace('.bin', '_waveform.npz')

TIMESTAMP_CLK_Hz = 122.88*1E6
EFFECTIVE_ADC_CLK_Hz = TIMESTAMP_CLK_Hz*8
SAMPLE_PER_TIMESTAMP_CLK = int(EFFECTIVE_ADC_CLK_Hz/TIMESTAMP_CLK_Hz)

plot_color = {0: 'steelblue', 1: 'firebrick'}

if __name__ == "__main__":
    pd_dfs = pd.read_pickle(pickle_pddfs_name,
                            compression=COMPRESSION_TYPE)
    waveform_array = np.load(npz_waveform_name)['arr_0']
    print(pd_dfs)

    fig, ax = plt.subplots()
    ax.set_title("Acquired data")
    ax.set_xlabel("Time[nsec]")
    ax.set_ylabel("ADC")

    t0 = pd_dfs['TIMESTAMP'][0]

    for i in (pd_dfs[(pd_dfs['OBJECT_ID'] < 100) & (pd_dfs['OBJECT_ID'] >= 0)].index):
        sample_num = pd_dfs['FRAME_LEN'][i]
        wav = waveform_array[i, 0:sample_num]
        t = (pd_dfs['TIMESTAMP'][i]-t0)/TIMESTAMP_CLK_Hz + \
            np.arange(sample_num)/EFFECTIVE_ADC_CLK_Hz
        ax.plot(t*1E9, wav, color=plot_color[pd_dfs['CH_ID'][i]],
                linestyle='-', marker='o', markersize=5)

    xmin, xmax = ax.get_xlim()
    ax.plot([xmin, xmax], [pd_dfs['RISE_THRE'][0], pd_dfs['RISE_THRE']
                           [0]], ls='-.', color='firebrick', label='rising_edge')
    ax.plot([xmin, xmax], [pd_dfs['FALL_THRE'][0], pd_dfs['FALL_THRE']
                           [0]], ls='-.', color='navy', label='falling_edge')
    ax.set_xlim(xmin, xmax)
    ax.legend()

    fig2, ax2 = plt.subplots()
    ax2.set_xscale('symlog')
    ax2_r = ax2.twinx()
    ax2.set_title("Hit & Hit-rate")

    ax2.set_xlabel("Time[msec]")
    ax2.set_ylabel("total hit num")
    ax2.plot((pd_dfs['TIMESTAMP']-t0)/TIMESTAMP_CLK_Hz*1e3,
             pd_dfs['OBJECT_ID'], label="hit", color='steelblue')
    ax2.set_yscale('log')

    ax2_r.set_xlabel("Time[msec]")
    ax2_r.set_ylabel("Hit-rate[MHz]")

    smooth_num = 128
    smoother = np.ones(smooth_num)/smooth_num
    smoothed_hit = np.convolve(pd_dfs['OBJECT_ID'], smoother, mode='same')
    smoothed_t = np.convolve(
        (pd_dfs['TIMESTAMP']-t0)/TIMESTAMP_CLK_Hz, smoother, mode='same')
    ax2_r.plot((pd_dfs['TIMESTAMP']-t0)/TIMESTAMP_CLK_Hz*1e3,
               np.gradient(smoothed_hit, smoothed_t)*1e-6, label="Hit-rate", color='firebrick')

    handler, label = ax2.get_legend_handles_labels()
    r_handler, r_label = ax2_r.get_legend_handles_labels()
    ax2.legend(handler+r_handler, label+r_label)

    plt.show()
