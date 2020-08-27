import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

BASE_FILE_NAME = "./data/recv_buff_v3_20200827_08.bin"

COMPRESSION_TYPE = 'zip'
pickle_pddfs_name = BASE_FILE_NAME.replace(
    '.bin', '_pddfs.pkl')+'.'+COMPRESSION_TYPE
npz_waveform_name = BASE_FILE_NAME.replace('.bin', '_waveform.npz')

TIMESTAMP_CLK_Hz = 122.88*1E6
EFFECTIVE_ADC_CLK_Hz = 0.983*1E9
SAMPLE_PER_TIMESTAMP_CLK = int(EFFECTIVE_ADC_CLK_Hz/TIMESTAMP_CLK_Hz)

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

    for i in np.arange(1000, 1200):
        sample_num = pd_dfs['FRAME_LEN'][i]
        wav = waveform_array[i, 0:sample_num]
        t = (pd_dfs['TIMESTAMP'][i]-t0)/TIMESTAMP_CLK_Hz + \
            np.arange(sample_num)/EFFECTIVE_ADC_CLK_Hz
        ax.plot(t*1E9, wav, color='steelblue',
                linestyle='-', marker='o', markersize=5)

    xmin, xmax = ax.get_xlim()
    ax.plot([xmin, xmax], [pd_dfs['RISE_THRE'][0], pd_dfs['RISE_THRE']
                           [0]], ls='-.', color='firebrick', label='rising_edge')
    ax.plot([xmin, xmax], [pd_dfs['FALL_THRE'][0], pd_dfs['FALL_THRE']
                           [0]], ls='-.', color='navy', label='falling_edge')
    ax.set_xlim(xmin, xmax)
    ax.legend()

    fig2, ax2 = plt.subplots()
    ax2.set_title("Hit")
    ax2.set_xlabel("Time[msec]")
    ax2.set_ylabel("total hit num")
    ax2.plot((pd_dfs['TIMESTAMP']-t0)/TIMESTAMP_CLK_Hz*1e3, pd_dfs.index)

    plt.show()
