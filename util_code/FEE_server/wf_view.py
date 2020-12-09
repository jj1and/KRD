import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

BASE_FILE_NAME = "./data/recv_buff_v4_20201204_11.bin"
# BASE_FILE_NAME = "./dummy_data/sample01.bin"

COMPRESSION_TYPE = 'zip'
pickle_pddfs_name = BASE_FILE_NAME.replace(
    '.bin', '_pddfs.pkl')+'.'+COMPRESSION_TYPE
npz_waveform_name = BASE_FILE_NAME.replace('.bin', '_waveform.npz')

TIMESTAMP_CLK_Hz = 122.88*1E6
EFFECTIVE_ADC_CLK_Hz = TIMESTAMP_CLK_Hz*8
SAMPLE_PER_TIMESTAMP_CLK = int(EFFECTIVE_ADC_CLK_Hz/TIMESTAMP_CLK_Hz)

plot_color = {0: 'steelblue', 1: 'firebrick', 2: 'darkgreen'}

if __name__ == "__main__":
    print("INFO: open file name: "+BASE_FILE_NAME)
    pd_dfs = pd.read_pickle(pickle_pddfs_name,
                            compression=COMPRESSION_TYPE)
    waveform_array = np.load(npz_waveform_name)['arr_0']
    hgain_only_waveform_array = np.load(npz_waveform_name)['arr_1']
    # print(pd_dfs)

    fig, ax = plt.subplots()
    ax.set_title("Acquired data")
    ax.set_xlabel("Time[nsec]")
    ax.set_ylabel("ADC")

    t0 = pd_dfs['TIMESTAMP'][0]

    for i in (pd_dfs[(pd_dfs['OBJECT_ID'] < 10) & (pd_dfs['OBJECT_ID'] >= 0)].index[:]):
        sample_num = pd_dfs['FRAME_LEN'][i]
        wav = waveform_array[i, 0:sample_num]
        hgain_wav = hgain_only_waveform_array[i, 0:sample_num]

        t = (pd_dfs['TIMESTAMP'][i]-t0)/TIMESTAMP_CLK_Hz + \
            np.arange(sample_num)/EFFECTIVE_ADC_CLK_Hz
        # if (pd_dfs['CH_ID'][i] == 2):
        #     ax.plot(t*1E9, wav, color=plot_color[pd_dfs['CH_ID'][i]],
        #             linestyle='-', marker='s', markersize=5)
        # ax.plot(t*1E9, hgain_wav, color=plot_color[pd_dfs['CH_ID'][i]],
        #         linestyle='--', marker='o', markersize=5)
        ax.plot(t*1E9, hgain_wav, color=plot_color[pd_dfs['CH_ID'][i]],
                linestyle='-', marker='o', markersize=5)

    xmin, xmax = ax.get_xlim()
    ax.plot([xmin, xmax], [pd_dfs['RISE_THRE'][0], pd_dfs['RISE_THRE']
                           [0]], ls='-.', color='firebrick', label='rising_edge')
    ax.plot([xmin, xmax], [pd_dfs['FALL_THRE'][0], pd_dfs['FALL_THRE']
                           [0]], ls='-.', color='navy', label='falling_edge')
    ax.set_xlim(xmin, xmax)
    # ax.set_ylim(-200, 450)
    ax.legend()

    fig2, ax2 = plt.subplots()
    # ax2.set_xscale('log', basex=10)
    ax2_r = ax2.twinx()
    ax2.set_title("Total-hit & Hit-rate")

    obj_id = pd_dfs['OBJECT_ID'].values
    timestamp = (pd_dfs['TIMESTAMP'].values-t0)/TIMESTAMP_CLK_Hz
    obj_id_diff = np.append([1], obj_id[1:]-obj_id[0:-1])
    obj_begin_indices = np.where(obj_id_diff > 0)
    objs = obj_id[obj_begin_indices]
    objs_t = timestamp[obj_begin_indices]
    raw_hit_rate = 1e-6/(objs_t[1:]-objs_t[0:-1])

    # internal buffer full check
    # for recv_buff_v4
    full_obj = pd_dfs.iloc[np.where(
        (pd_dfs['FRAME_INFO'].values & 0b1100) == 0b1000)]

    # for recv_buff_v3 or recv_buff_v3b
    # full_obj = np.where((pd_dfs['FRAME_INFO'].values & 0b0110) == 0b0100)
    first_full_obj_id = -1
    skip_frame_num = 0

    charge_check = np.sum(waveform_array, axis=1)-pd_dfs['CHARGE_SUM']
    wrong_val_indices = np.where(charge_check != 0)
    if len(wrong_val_indices[0]) != 0:
        print("ERROR: CHARGE_SUM does't much with sum of waveform")
        print("_______________________________________________________________________________________________________")
        print(pd_dfs.iloc[wrong_val_indices[0]])
        print("_______________________________________________________________________________________________________\n")

    if (len(full_obj) == 0):
        pass
    else:
        first_full_obj_id = int(full_obj.iloc[0]['OBJECT_ID'])

    if len(np.where(obj_id_diff > 1)[0]) > 0:
        print("INFO: First frame skip occured at OBJECT_ID={0:d}".format(
            int(pd_dfs.iloc[np.min(np.where(obj_id_diff > 1)[0])]['OBJECT_ID'])))
        if pd_dfs.iloc[np.min(np.where(obj_id_diff > 1)[0])]['OBJECT_ID'] <= first_full_obj_id:
            print("INFO: frame is skipped before internal buffer full")

    if first_full_obj_id >= 0:
        first_full_obj = pd_dfs[pd_dfs['OBJECT_ID'] == first_full_obj_id]
        print("INFO: Internal buffer got full at OBJECT_ID={0:d}".format(
            first_full_obj_id))
        print("_______________________________________________________________________________________________________")
        print(pd_dfs[(pd_dfs['OBJECT_ID'] >= first_full_obj_id)
                     & (pd_dfs['OBJECT_ID'] < first_full_obj_id+3)])
        print("_______________________________________________________________________________________________________")
        full_obj_time = (
            first_full_obj.iloc[-1]['TIMESTAMP']-t0)/TIMESTAMP_CLK_Hz
        print("INFO: Time since first frame: {0:3.4f} msec".format(
            full_obj_time*1e3))
        full_acum_waveform_size = np.sum(
            pd_dfs[pd_dfs['OBJECT_ID'] <= first_full_obj_id]['FRAME_LEN'])*2
        print("INFO: Waveform data since first frame: {0:d} Byte".format(
            full_acum_waveform_size))
        print(
            "INFO: Header/Footer data since first frame: {0:d} Byte".format((first_full_obj.index[0]+1)*24))
        print("INFO: Input data rate until full (waveform only): {0:5.2f} MByte/s".format(
            full_acum_waveform_size/full_obj_time*1e-6))

        skip_frame_num = len(np.where(obj_id_diff > 1)[0])
        print("INFO: skipped frame num: {0:d}/{1:d}".format(
            skip_frame_num, int(pd_dfs.iloc[-1]['OBJECT_ID']+1)))
        print("INFO: skipped frame rate: {0:3.4f}".format(
            skip_frame_num/(pd_dfs.iloc[-1]['OBJECT_ID']+1)))
        print("INFO: frame len mean (before full): {0:4.2f} nsec".format(np.sum(
            pd_dfs[pd_dfs['OBJECT_ID'] <= first_full_obj_id]['FRAME_LEN'])/(first_full_obj_id+1)))
        print("INFO: frame len mean (after full): {0:4.2f} nsec".format(np.sum(
            pd_dfs[pd_dfs['OBJECT_ID'] > first_full_obj_id]['FRAME_LEN'])/(pd_dfs.iloc[-1]['OBJECT_ID']-first_full_obj_id)))
    else:
        print("INFO: Internal buffer hasn't get full")
    total_rcvd_waveform_size = np.sum(pd_dfs['FRAME_LEN'])*2
    total_rcvd_time = (pd_dfs.iloc[-1]['TIMESTAMP']-t0)/TIMESTAMP_CLK_Hz
    print("INFO: Input data rate: {0:5.2f} MByte/s".format(
        total_rcvd_waveform_size/total_rcvd_time*1e-6))
    print("INFO: frame len mean (all): {0:4.2f} nsec".format(
        np.sum(pd_dfs['FRAME_LEN'])/(pd_dfs.iloc[-1]['OBJECT_ID']+1-skip_frame_num)))

    ax2.set_xlabel("Time[msec]")
    ax2.set_ylabel("total hit")
    ax2.plot(objs_t*1e3, objs+1, label="Total-hit",
             color='steelblue', marker='.')
    ax2.set_yscale('log')

    ax2_r.set_xlabel("Time[msec]")
    ax2_r.set_ylabel("Hit-rate[MHz]")

    # smooth_num = 256
    # if len(pd_dfs) > smooth_num:
    #     smoother = np.ones(smooth_num)/smooth_num
    #     smoothed_hit_rate = np.convolve(raw_hit_rate, smoother, mode='valid')
    #     ax2_r.plot(objs_t[1:-smooth_num+1]*1e3,
    #                smoothed_hit_rate, label="Hit-rate", color='firebrick')
    # ax2_r.plot(objs_t[1:]*1e3,
    #            raw_hit_rate, label="Hit-rate", color='firebrick')
    ax2_r.set_ylim(0.1, 25)
    if first_full_obj_id > 0:
        ax2_r.plot([full_obj_time*1e3, full_obj_time*1e3],
                   [0.1, 50], label='Internal buffer Full', color='k', ls='-.')
    handler, label = ax2.get_legend_handles_labels()
    r_handler, r_label = ax2_r.get_legend_handles_labels()
    ax2.legend(handler+r_handler, label+r_label, loc='lower right')

    plt.show()
