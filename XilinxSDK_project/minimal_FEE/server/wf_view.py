import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

BASE_FILE_NAME = "./data/recv_buff_v3_20200823_01.bin"

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
