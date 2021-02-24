import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import df_extract

FILE_NAME = "./data/Mog2fee_v0_"
DATE = "20210206_"
EXT = ".bin"

FILE_NAME_LIST = []
for i in range(0, 99):
    if i < 10:
        num = '0' + str(i)
    else:
        num = str(i)
    FILE_NAME_LIST.append(FILE_NAME + DATE + num + EXT)

COMPRESSION_TYPE = 'zip'
SAMPLE_NUM_PER_LINE = 4
EFFECTIVE_ADC_CLK_Hz = 0.983*1E9

if __name__ == "__main__":

    for fname in FILE_NAME_LIST:
        print("INFO: open file name: "+fname)
        with open(fname, "rb") as f:
            recv_buff = f.read()

        print("INFO: convert binary to numpy array")
        # '<u1' = 'little_endian(<)  unsigned_int64(u8)'
        bin_data = np.frombuffer(recv_buff, dtype='<u8')
        print("INFO: extract header & waveform...")
        ch_id_array, frame_len_array, frame_info_array, trigger_type_array, charge_sum_array, rise_thre_array, fall_thre_array, object_id_array, timestamp_array, waveform_array, hgain_only_waveform_array = df_extract.extract_df(
            bin_data)
        print("INFO: header & waveform is extracted!")
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

        print("INFO: create pandas data frame...", end='')
        pd_dfs = pd.DataFrame(df_summary)
        print("done!", end='\n')
        print(pd_dfs)

        print("INFO: save data frame as pickle & npz...", end='')
        pickle_pddfs_name = fname.replace(
            '.bin', '_pddfs.pkl')+'.'+COMPRESSION_TYPE
        npz_waveform_name = fname.replace('.bin', '_waveform.npz')
        pd_dfs.to_pickle(pickle_pddfs_name, compression=COMPRESSION_TYPE)
        np.savez_compressed(npz_waveform_name, waveform_array,
                            hgain_only_waveform_array)
    print("done!", end='\n')
