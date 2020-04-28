import numpy as np
import pandas as pd
import pickle
import glob
import matplotlib.pyplot as plt

# plt.rcParams['xtick.direction'] = 'in'
# plt.rcParams['ytick.direction'] = 'in'
plt.rcParams['axes.grid'] = True

FILE_NAME = "util_code/data/recv_buff_20200427_02.bin"

COMPRESSION_TYPE = 'zip'
pickle_pddfs_name = FILE_NAME.replace('.bin', '_pddfs.pkl')+'.'+COMPRESSION_TYPE
pickle_pdkeys_name = FILE_NAME.replace('.bin', '_pdkeys.pkl')
pickle_pdsettings_name = FILE_NAME.replace('.bin', '_pdsettings.pkl')
pickle_perf_pddf_name = FILE_NAME.replace('.bin', '_perf_pddf.pkl')+'.'+COMPRESSION_TYPE

TIMESTAMP_CLK_Hz = 256*1E6
EFFECTIVE_ADC_CLK_Hz = 2.048*1E9
SAMPLE_PER_TIMESTAMP_CLK = int(EFFECTIVE_ADC_CLK_Hz/TIMESTAMP_CLK_Hz)
XPAR_CPU_CORTEXA53_0_TIMESTAMP_CLK_FREQ_Hz = 99999001

VALID_HEADER = np.uint16(0xAAAA)
ERR_HEADER = np.uint16(0xAAEE)
BOTH_HEADER = np.uint16(0xAA00)

BOTH_HEADER_FOOTER_BITMASK = np.uint16(0xFF00)


PERFORM_HEADER_BITMASK = np.uint64(0xFFFFFFFFFFFFFFF0)
# PERFORM_FOOTER_BITMASK = np.uint64(0x000000000000FFFF)

PERFORM_HEADER = np.uint64(0xAA78000000000000)
PERFORM_FOOTER = np.uint64(0xFFFFFFFFFFFF5578)

TYPE_DMA_START = np.uint64(0x000000000000000A)
TYPE_DMA_INTR_END = np.uint64(0x000000000000000B)
TYPE_DMA_END = np.uint64(0x000000000000000C)
TYPE_SEND2PC_END = np.uint64(0x000000000000000D)
TYPE_QUEUE_RECV = np.uint64(0x000000000000000E)

# CH_ID_BITMASK = np.uint64(0x0000F00000000000)
# FH_TIMESTAMP_BITMASK = np.uint64(0x00000FFFFFFFF000)
# FRAME_LEN_BITMASK = np.uint64(0x0000000000000FFF)

# BASELINE_BITMASK = np.uint64(0xFFFF000000000000)
# THRESHOLD_BITMASK = np.uint64(0x0000FFFF00000000)
# LH_TIMESTAMP_BITMASK = np.uint64(0x00000000FFFF0000)


VALID_FOOTER = np.uint16(0x5555)
ERR_FOOTER = np.uint16(0x55EE)
BOTH_FOOTER = np.uint16(0x5500)

HEX_BITSIZE = 4

def generate_pddfs(df_list):
    pd_setting_dict = {}
    pd_frame_list = []
    pd_frame_key_list = []
    done = 0
    last = len(df_list)
    for df_index, df in enumerate(df_list):
        if ((df_index+1) % 100 == 0):
            progress = int(10*(df_index+1)/last)
            print("\r #{0:d} / {1:d} Frame is loaded".format(int(df_index+1), int(last)) + " [" + '='*progress + '>' + ' '*(9-progress) + "]", end='')
        if ((df_index+1==last) & (done==0)):
            print("\r #{0:d} / {1:d} Frame is loaded".format(int(df_index+1), int(last)) + " [" + '='*10 + "] load done!", end='\n')
            done = 1
        if df[-1] == VALID_FOOTER:
            settings_dict = {}
            ch_id = np.uint16( np.uint16(df[1]) >> 12 )
            timestamp_31_20 = np.uint32(np.uint16(df[1]&0x0FFF) << 20)
            timestamp_19_4 = np.uint32(np.uint16(df[2]) << 4)
            timestamp_3_0 = np.uint32(np.uint16(df[3]) >> 12)
            timestamp_31_0 = np.uint32( timestamp_31_20|(timestamp_19_4|timestamp_3_0) )
            frame_len = np.uint16( np.uint16(df[3])&0x0FFF )

            baseline = np.int16(df[-4])
            threshold = np.int16(df[-3])
            timestamp_47_32 = np.uint32(np.uint16(df[-2]))

            timestamp = np.uint64( (timestamp_47_32 << 32)|timestamp_31_0 )

            settings_dict['ch_id'] = ch_id
            settings_dict['timestamp'] = timestamp
            settings_dict['frame_size'] = frame_len*4
            settings_dict['baseline'] = baseline
            settings_dict['threshold'] = threshold

            pd_frame_key = "Ch{0:04d}_{1:d}".format(ch_id, timestamp)
            

            t = np.arange(frame_len*4, dtype='uint64')
            df_contents = np.flip(df[4:-4].reshape(-1,4), axis=1).reshape(-1,1)
            df_contents.dtype = '>i2'

            pd_frame = pd.DataFrame(data=np.concatenate([np.full((frame_len*4, 1), ch_id), np.full((frame_len*4, 1), timestamp), t.reshape(-1, 1), df_contents.reshape(-1, 1)], axis=1), columns=['ch_id', 'timestamp[TIMESTAMP_CLK]', 'rela_time[EFF_ADC_CLK]', 'data[ADC]']).astype('int64').set_index(['ch_id', 'timestamp[TIMESTAMP_CLK]'], drop=True)
            pd_setting_dict[pd_frame_key] = settings_dict
            pd_frame_list.append(pd_frame)
            pd_frame_key_list.append(pd_frame_key)

            # print("Ch: {0:d} | Baseline: {1:d} | Threshold: {2:d} | Frame size: {3:d} | Timestamp: {4:d}".format(ch_id, baseline, threshold, frame_len*4, timestamp))
        else:
            print("Frame No.{0:d} has invalid footer. The contents is {1:04x}".format(df_index, df[-1]))
    pd_frames = pd.concat(pd_frame_list, sort=False)
    return pd_frame_key_list, pd_setting_dict, pd_frames

def decode_perf_df(perf_dfs):
    dma_start_header_indices = np.where(perf_dfs == np.uint64(PERFORM_HEADER+TYPE_DMA_START))[0]
    dma_intr_end_header_indices = np.where(perf_dfs == np.uint64(PERFORM_HEADER+TYPE_DMA_INTR_END))[0]
    dma_end_header_indices = np.where(perf_dfs == np.uint64(PERFORM_HEADER+TYPE_DMA_END))[0]
    send2pc_end_header_indices = np.where(perf_dfs == np.uint64(PERFORM_HEADER+TYPE_SEND2PC_END))[0]
    queue_recv_header_indices = np.where(perf_dfs == np.uint64(PERFORM_HEADER+TYPE_QUEUE_RECV))[0]
    common_footer_indices = np.where(perf_dfs == PERFORM_FOOTER)[0]
    
    dma_start_footer_indices = common_footer_indices[np.where( common_footer_indices<dma_intr_end_header_indices[0] )]
    dma_intr_end_footer_indices = common_footer_indices[np.where( (common_footer_indices<dma_end_header_indices[0]) & (common_footer_indices>dma_intr_end_header_indices[0]))]
    dma_end_footer_indices = common_footer_indices[np.where( (common_footer_indices<send2pc_end_header_indices[0]) & (common_footer_indices>dma_end_header_indices[0]))]
    send2pc_end_footer_indices = common_footer_indices[np.where( (common_footer_indices<queue_recv_header_indices[0]) & (common_footer_indices>send2pc_end_header_indices[0]) )]
    queue_recv_footer_indices = common_footer_indices[np.where( (common_footer_indices>queue_recv_header_indices[0]) )]
    
    dma_start_ticks = np.array(perf_dfs[dma_start_header_indices[0]:dma_start_footer_indices[-1]], dtype='uint64')
    dma_intr_end_ticks = np.array(perf_dfs[dma_intr_end_header_indices[0]:dma_intr_end_footer_indices[-1]], dtype='uint64')
    dma_end_ticks = np.array(perf_dfs[dma_end_header_indices[0]:dma_end_footer_indices[-1]], dtype='uint64')
    send2pc_end_ticks = np.array(perf_dfs[send2pc_end_header_indices[0]:send2pc_end_footer_indices[-1]], dtype='uint64')
    queue_recv_ticks = np.array(perf_dfs[queue_recv_header_indices[0]:queue_recv_footer_indices[-1]], dtype='uint64')

    dma_start_ticks = np.delete(dma_start_ticks, np.where((dma_start_ticks==np.uint64(PERFORM_HEADER+TYPE_DMA_START)) | (dma_start_ticks==PERFORM_FOOTER)))
    dma_intr_end_ticks = np.delete(dma_intr_end_ticks, np.where((dma_intr_end_ticks==np.uint64(PERFORM_HEADER+TYPE_DMA_INTR_END)) | (dma_intr_end_ticks==PERFORM_FOOTER)))
    dma_end_ticks = np.delete(dma_end_ticks, np.where((dma_end_ticks==np.uint64(PERFORM_HEADER+TYPE_DMA_END)) | (dma_end_ticks==PERFORM_FOOTER)))
    send2pc_end_ticks = np.delete(send2pc_end_ticks, np.where((send2pc_end_ticks==np.uint64(PERFORM_HEADER+TYPE_SEND2PC_END)) | (send2pc_end_ticks==PERFORM_FOOTER)))
    queue_recv_ticks = np.delete(queue_recv_ticks, np.where((queue_recv_ticks==np.uint64(PERFORM_HEADER+TYPE_QUEUE_RECV)) | (queue_recv_ticks==PERFORM_FOOTER)))
    return dma_start_ticks, dma_intr_end_ticks, dma_end_ticks, send2pc_end_ticks, queue_recv_ticks


if __name__ == "__main__":
    with open(FILE_NAME, "rb") as f:
        recv_buff = f.read()
    # '<u8' = 'little_endian(<)  unsigned_int64(u8)'
    all_dfs = np.frombuffer(recv_buff, dtype='<u8')
    perf_header_indices = np.where(all_dfs&PERFORM_HEADER_BITMASK == PERFORM_HEADER)
    perf_footer_indices = np.where(all_dfs == PERFORM_FOOTER)
    if (len(perf_footer_indices[0])!=0) & (len(perf_header_indices[0])!=0):
        if (glob.glob(pickle_perf_pddf_name)!=[]):
            perf_pddf = pd.read_pickle(pickle_perf_pddf_name, compression=COMPRESSION_TYPE)     
        else:
            perf_dfs = all_dfs[perf_header_indices[0][0]:]
            dma_start_ticks, dma_intr_end_ticks, dma_end_ticks, send2pc_end_ticks, queue_recv_ticks = decode_perf_df(perf_dfs)
            # before 20200423_01.bin : send2pc_end_ticks.reshape(-1, 1)
            perf_pddf = pd.DataFrame(data=np.concatenate([dma_start_ticks.reshape(-1,1), np.append(dma_intr_end_ticks, [np.nan]).reshape(-1,1), dma_end_ticks.reshape(-1, 1), np.append(send2pc_end_ticks, [np.nan]).reshape(-1, 1), np.append(queue_recv_ticks, [np.nan]).reshape(-1, 1)], axis=1), columns=['dma_start[CPU_CLK]', 'dma_intr_end[CPU_CLK]', 'dma_end[CPU_CLK]', 'send2pc_end[CPU_CLK]', 'queue_recv[CPU_CLK]'])
            perf_pddf.to_pickle(pickle_perf_pddf_name, compression=COMPRESSION_TYPE)
        dfs = all_dfs[:perf_header_indices[0][0]]
    else:
        dfs = all_dfs

    # litte -> big endian
    dfs = np.array([(dfs[i].byteswap()).newbyteorder('B')  for i in range(len(dfs))], dtype='>u8')
    # uint64 -> int16 *4
    dfs.dtype = '>u2'

    valid_header_indices = np.where(dfs == VALID_HEADER)
    err_header_indices = np.where(dfs == ERR_HEADER)

    valid_footer_indices = np.where(dfs == VALID_FOOTER)  
    err_footer_indices = np.where(dfs == ERR_FOOTER)    
    
    print("VALID HEADER NUM: {0:5d} | VALID FOOTER NUM: {1:5d}".format(len(valid_header_indices[0]), len(valid_footer_indices[0])))
    print("ERROR HEADER NUM: {0:5d} | ERROR FOOTER NUM: {1:5d}".format(len(err_header_indices[0]), len(err_footer_indices[0])))
    print("TOTAL HEADER NUM: {0:5d} | TOTAL FOOTER NUM: {1:5d}".format(len(valid_header_indices[0])+len(err_header_indices[0]), len(valid_footer_indices[0])+len(err_footer_indices[0])))\

    tmp_headers = np.append(valid_header_indices[0], [None])
    df_list = [ dfs[tmp_headers[i]:tmp_headers[i+1]] for i in range(len(valid_header_indices[0])) ]
    print("VALID HEADER INDEX:", valid_header_indices[0])
    print("VALID FOOTER INDEX:", valid_footer_indices[0])

    # pdkeys, pdsettings, pddfs = generate_pddfs(df_list)
    if (glob.glob(pickle_pdkeys_name)!=[]):
        with open(pickle_pdkeys_name, mode='rb') as fpdkeys:
            pdkeys = pickle.load(fpdkeys)
        with open(pickle_pdsettings_name, mode='rb') as fpdsettings:
            pdsettings = pickle.load(fpdsettings)
        pddfs = pd.read_pickle(pickle_pddfs_name, compression=COMPRESSION_TYPE)     
    else:
        pdkeys, pdsettings, pddfs = generate_pddfs(df_list)
        with open(pickle_pdkeys_name, mode='wb') as fpdkeys:
            pickle.dump(pdkeys, fpdkeys)
        with open(pickle_pdsettings_name, mode='wb') as fpdsettings:
            pickle.dump(pdsettings, fpdsettings)
        pddfs.to_pickle(pickle_pddfs_name, compression=COMPRESSION_TYPE)

    hist2d_fig, hist2d_ax = plt.subplots()
    hist2d_ax.set_title("Acquired data")
    hist2d_ax.set_xlabel("Time[nsec]")
    hist2d_ax.set_ylabel("ADC")
    hist2d_h, hist2d_xedges, hist2d_yedges, hist2d_im = hist2d_ax.hist2d(pddfs.iloc[:, 0]/EFFECTIVE_ADC_CLK_Hz*1E9, pddfs.iloc[:, 1], bins=[100, 2048], label="Entries;{0:d}".format(len(pdkeys)), cmin=0.01)
    hist2d_ax.set_ylim(-2049, 2049)
    plt.colorbar(hist2d_im, ax=hist2d_ax)
    
    plt.show()