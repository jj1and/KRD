import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import df_extract


FILE_NAME = "./data/recv_buff_v4_20201008_11.bin"
# FILE_NAME = "./dummy_data/sample01.bin"
COMPRESSION_TYPE = 'zip'

pickle_pddfs_name = FILE_NAME.replace(
    '.bin', '_pddfs.pkl')+'.'+COMPRESSION_TYPE
npz_waveform_name = FILE_NAME.replace('.bin', '_waveform.npz')

SAMPLE_NUM_PER_LINE = 4
EFFECTIVE_ADC_CLK_Hz = 0.983*1E9

if __name__ == "__main__":
    with open(FILE_NAME, "rb") as f:
        recv_buff = f.read()

    # '<u1' = 'little_endian(<)  unsigned_int64(u8)'
    bin_data = np.frombuffer(recv_buff, dtype='<u8')

    ch_id_array, frame_len_array, frame_info_array, trigger_type_array, charge_sum_array, rise_thre_array, fall_thre_array, object_id_array, timestamp_array, waveform_array, hgain_only_waveform_array = df_extract.extract_df(
        bin_data)

    df_summary = {
        'CH_ID': ch_id_array,
        'TIMESTAMP': timestamp_array,
        'CHARGE_SUM': charge_sum_array,
        'FRAME_LEN': frame_len_array*SAMPLE_NUM_PER_LINE,
        'FRAME_INFO': frame_info_array,
        'TRIG_TYPE': trigger_type_array,
        'RISE_THRE': rise_thre_array,
        'FALL_THRE': fall_thre_array,
        'OBJECT_ID': object_id_array
    }

    pd_dfs = pd.DataFrame(df_summary)
    pd_dfs.to_pickle(pickle_pddfs_name, compression=COMPRESSION_TYPE)
    np.savez_compressed(npz_waveform_name, waveform_array,
                        hgain_only_waveform_array)

    print(pd_dfs)
    times, waves = df_extract.combine_dfs(frame_len_array, waveform_array)

    # xbin_num = np.max(times)-np.min(times)
    ybin_num = np.max(waves)-np.min(waves)

    hist2d_fig, hist2d_ax = plt.subplots()
    hist2d_ax.set_title("Acquired data")
    hist2d_ax.set_xlabel("Time[nsec]")
    hist2d_ax.set_ylabel("ADC")
    hist2d_h, hist2d_xedges, hist2d_yedges, hist2d_im = hist2d_ax.hist2d(
        times/EFFECTIVE_ADC_CLK_Hz*1E9, waves, bins=[50, ybin_num], label="Entries;{0:d}".format(len(pd_dfs)), cmin=0.01)
    plt.colorbar(hist2d_im, ax=hist2d_ax)
    plt.show()
