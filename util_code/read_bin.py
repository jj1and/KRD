import numpy as np
import pandas as pd
import pickle
import glob
import matplotlib.pyplot as plt

FILE_NAME = "util_code/recv_buff_20200421_01.bin"

COMPRESSION_TYPE = 'zip'
pickle_pddfs_name = FILE_NAME.replace('.bin', '_pddfs.pkl')+'.'+COMPRESSION_TYPE
pickle_pdkeys_name = FILE_NAME.replace('.bin', '_pdkeys.pkl')
pickle_pdsettings_name = FILE_NAME.replace('.bin', '_pdsettings.pkl')


TIMESTAMP_CLK_Hz = 256*1E6
EFFECTIVE_ADC_CLK_Hz = 2.048*1E9
SAMPLE_PER_TIMESTAMP_CLK = int(EFFECTIVE_ADC_CLK_Hz/TIMESTAMP_CLK_Hz)

VALID_HEADER = np.uint16(0xAAAA)
ERR_HEADER = np.uint16(0xAAEE)
BOTH_HEADER = np.uint16(0xAA00)

BOTH_HEADER_FOOTER_BITMASK = np.uint16(0xFF00)

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




if __name__ == "__main__":
    with open(FILE_NAME, "rb") as f:
        recv_buff = f.read()
    # '<u8' = 'little_endian(<)  unsigned_int64(u8)'
    dfs = np.frombuffer(recv_buff, dtype='<u8')

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

    hit_timeline = np.array([pdsettings[key]['timestamp'] for key in pdkeys ], dtype='uint64')/TIMESTAMP_CLK_Hz
    timeline_fig, timeline_ax = plt.subplots()
    timeline_ax.set_title('Hit timeline')
    timeline_ax.set_ylabel('Hit(Accumulation)')
    timeline_ax.set_xlabel('timeline[sec]')
    timeline_ax.plot(hit_timeline, np.arange(1, len(hit_timeline)+1))

    hist2d_fig, hist2d_ax = plt.subplots()
    hist2d_ax.set_title("Acquired data")
    hist2d_ax.set_xlabel("Time[nsec]")
    hist2d_ax.set_ylabel("ADC")
    hist2d_h, hist2d_xedges, hist2d_yedges, hist2d_im = hist2d_ax.hist2d(pddfs.iloc[:, 0]/EFFECTIVE_ADC_CLK_Hz*1E9, pddfs.iloc[:, 1], bins=[100, 2048], label="Entries;{0:d}".format(len(pdkeys)), cmin=0.01)
    hist2d_ax.set_ylim(-2049, 2049)
    plt.colorbar(hist2d_im, ax=hist2d_ax)

    print(pddfs[pddfs.iloc[:, 1]<-1000])
    # pddfs_low = pddfs.loc[(0, 3079603435)]
    # # print([format(i, '02x') for i in df_list[pdkeys.index('Ch0000_4645651952')]])
    pddfs_partial = pddfs.iloc[:200000, :]
    pddfs_timestamp = pddfs_partial.index.get_level_values(1)
    fig, ax = plt.subplots()
    ax.set_title("Acquired data")
    ax.set_xlabel("Time[nsec]")
    ax.set_ylabel("ADC")
    ax.set_ylim(-2049, 2049)
    ax.scatter((pddfs_timestamp-pddfs_timestamp[0])/TIMESTAMP_CLK_Hz*1E9+pddfs_partial.iloc[:, 0]/EFFECTIVE_ADC_CLK_Hz*1E9, pddfs_partial.iloc[:, 1], s=5)

    plt.show()