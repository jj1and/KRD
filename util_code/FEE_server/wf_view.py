import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# BASE_FILE_NAME = "./data/recv_buff_v4_20201204_11.bin"
BASE_FILE_NAME = "./data/Mog2fee_v0_20201221_05.bin"
# BASE_FILE_NAME = "./dummy_data/sample01.bin"

COMPRESSION_TYPE = 'zip'
pickle_pddfs_name = BASE_FILE_NAME.replace(
    '.bin', '_pddfs.pkl')+'.'+COMPRESSION_TYPE
npz_waveform_name = BASE_FILE_NAME.replace('.bin', '_waveform.npz')

TIMESTAMP_CLK_Hz = 122.88*1E6
EFFECTIVE_ADC_CLK_Hz = TIMESTAMP_CLK_Hz*8
SAMPLE_PER_TIMESTAMP_CLK = int(EFFECTIVE_ADC_CLK_Hz/TIMESTAMP_CLK_Hz)

plot_color = {
    0: 'steelblue', 1: 'firebrick', 2: 'darkgreen', 3: 'purple',
    4: 'dodgerblue', 5: 'orangered', 6: 'limegreen', 7: 'mediumvioletred',
    8: 'navy', 9: 'saddlebrown', 10: 'darkolivegreen', 11: 'crimson',
    12: 'blue', 13: 'red', 14: 'yellowgreen', 15: 'orchid'}

if __name__ == "__main__":
    print("INFO: open file name: "+BASE_FILE_NAME)
    pd_dfs = pd.read_pickle(pickle_pddfs_name,
                            compression=COMPRESSION_TYPE)
    waveform_array = np.load(npz_waveform_name)['arr_0']
    hgain_only_waveform_array = np.load(npz_waveform_name)['arr_1']
    # print(pd_dfs)

    select_pds = pd_dfs[(pd_dfs['OBJECT_ID'] <= 10000) &
                        (pd_dfs['OBJECT_ID'] >= 0)]

    acuqired_channels = np.unique(select_pds['CH_ID'])
    if len(acuqired_channels) == 1:
        fig, ax = plt.subplots(
            len(acuqired_channels), 1, sharex=True)
        axes = [ax]
    else:
        fig, axes = plt.subplots(
            len(acuqired_channels), 1, sharex=True)
    axes[0].set_title("Acquired data")
    axes[-1].set_xlabel("Time[nsec]")

    for i, ch in enumerate(acuqired_channels):
        axes[i].set_ylabel("Ch{}".format(ch))

    # fig, axes = plt.subplots(2, 1, sharex=True)
    # axes[0].set_title("Acquired data")
    # axes[-1].set_xlabel("Time[nsec]")

    sel_channels = np.array([1, 3])
    sel_ch_label = {
        1: "Ch1 DSP disabled",
        3: "Ch3 DSP enabled"}
    sel_label_plotted = np.zeros(len(sel_channels))
    sel_fig, sel_ax = plt.subplots(1, 1, sharex=True)
    sel_ax.set_ylabel("ADC")

    t0 = min(pd_dfs['TIMESTAMP'])
    for i in (select_pds.index[:]):
        sample_num = pd_dfs['FRAME_LEN'][i]
        wav = waveform_array[i, 0:sample_num]
        hgain_wav = hgain_only_waveform_array[i, 0:sample_num]

        t = (pd_dfs['TIMESTAMP'][i]-t0)/TIMESTAMP_CLK_Hz + \
            np.arange(sample_num)/EFFECTIVE_ADC_CLK_Hz
        # if (pd_dfs['CH_ID'][i] == 14) | (pd_dfs['CH_ID'][i] == 15):
        #     axes[pd_dfs['CH_ID'][i]-14].plot(t*1E9, hgain_wav, color=plot_color[pd_dfs['CH_ID'][i]],
        #                                      linestyle='-', marker='s', markersize=5)
        # ax.plot(t*1E9, hgain_wav, color=plot_color[pd_dfs['CH_ID'][i]],
        #         linestyle='--', marker='o', markersize=5)
        axes[np.where(acuqired_channels == pd_dfs['CH_ID'][i])[0][0]].plot(t*1E9, wav, color=plot_color[pd_dfs['CH_ID'][i]],
                                                                           linestyle='-', marker='o', markersize=5)

        search_sel_ch = np.where(sel_channels == pd_dfs['CH_ID'][i])[0]
        if len(search_sel_ch) > 0:
            if sel_label_plotted[search_sel_ch[0]] == 0:
                sel_label_plotted[search_sel_ch[0]] = 1
                sel_ax.plot(
                    t*1E9, wav, color=plot_color[pd_dfs['CH_ID'][i]], linestyle='-', marker='o', markersize=5, label=sel_ch_label[pd_dfs['CH_ID'][i]])
            else:
                sel_ax.plot(
                    t*1E9, wav, color=plot_color[pd_dfs['CH_ID'][i]], linestyle='-', marker='o', markersize=5)
    sel_ax.legend()
    # xmin, xmax=ax.get_xlim()
    # ax.plot([xmin, xmax], [pd_dfs['RISE_THRE'][0], pd_dfs['RISE_THRE']
    #                        [0]], ls = '-.', color = 'firebrick', label = 'rising_edge')
    # ax.plot([xmin, xmax], [pd_dfs['FALL_THRE'][0], pd_dfs['FALL_THRE']
    #                        [0]], ls = '-.', color = 'navy', label = 'falling_edge')
    # ax.set_xlim(xmin, xmax)
    # ax.set_ylim(-200, 450)
    # ax.legend()

    fig2, ax2 = plt.subplots()
    # ax2.set_xscale('log', basex=10)
    ax2_r = ax2.twinx()
    ax2.set_title("Total-hit & Hit-rate")

    charge_check = np.sum(waveform_array, axis=1)-pd_dfs['CHARGE_SUM']
    wrong_val_indices = np.where(charge_check != 0)
    if len(wrong_val_indices[0]) != 0:
        print("ERROR: CHARGE_SUM does't much with sum of waveform")
        print("_______________________________________________________________________________________________________")
        print(pd_dfs.iloc[wrong_val_indices[0]])
        print("_______________________________________________________________________________________________________\n")

    for i, ch in enumerate(acuqired_channels):
        ch_pd_dfs = pd_dfs[pd_dfs['CH_ID'] == ch]
        obj_id = ch_pd_dfs['OBJECT_ID'].values
        timestamp = (ch_pd_dfs['TIMESTAMP'].values-t0)/TIMESTAMP_CLK_Hz

        obj_id_diff = np.append([1], obj_id[1:]-obj_id[0:-1])
        obj_begin_indices = np.where(obj_id_diff > 0)
        objs = obj_id[obj_begin_indices]
        objs_t = timestamp[obj_begin_indices]
        raw_hit_rate = 1e-6/(objs_t[1:]-objs_t[0:-1])

        # internal buffer full check
        # for recv_buff_v4
        full_obj = ch_pd_dfs.iloc[np.where(
            (ch_pd_dfs['FRAME_INFO'].values & 0b1100) == 0b1000)]

        # for recv_buff_v3 or recv_buff_v3b
        # full_obj = np.where((ch_pd_dfs['FRAME_INFO'].values & 0b0110) == 0b0100)
        first_full_obj_id = -1
        skip_frame_num = 0

        if (len(full_obj) == 0):
            pass
        else:
            first_full_obj_id = int(full_obj.iloc[0]['OBJECT_ID'])

        if len(np.where(obj_id_diff > 1)[0]) > 0:
            print("INFO: First frame skip occured at OBJECT_ID={0:d}".format(
                int(ch_pd_dfs.iloc[np.min(np.where(obj_id_diff > 1)[0])]['OBJECT_ID'])))
            if ch_pd_dfs.iloc[np.min(np.where(obj_id_diff > 1)[0])]['OBJECT_ID'] <= first_full_obj_id:
                print("INFO: frame is skipped before internal buffer full")

        if first_full_obj_id >= 0:
            first_full_obj = ch_pd_dfs[ch_pd_dfs['OBJECT_ID']
                                       == first_full_obj_id]
            print("INFO: Internal buffer got full at OBJECT_ID={0:d}".format(
                first_full_obj_id))
            print("_______________________________________________________________________________________________________")
            print(ch_pd_dfs[(ch_pd_dfs['OBJECT_ID'] >= first_full_obj_id)
                            & (ch_pd_dfs['OBJECT_ID'] < first_full_obj_id+3)])
            print("_______________________________________________________________________________________________________")
            full_obj_time = (
                first_full_obj.iloc[-1]['TIMESTAMP']-t0)/TIMESTAMP_CLK_Hz
            print("INFO: Time since first frame: {0:3.4f} msec".format(
                full_obj_time*1e3))
            full_acum_waveform_size = np.sum(
                ch_pd_dfs[ch_pd_dfs['OBJECT_ID'] <= first_full_obj_id]['FRAME_LEN'])*2
            print("INFO: Waveform data since first frame: {0:d} Byte".format(
                full_acum_waveform_size))
            print(
                "INFO: Header/Footer data since first frame: {0:d} Byte".format((first_full_obj.index[0]+1)*24))
            print("INFO: Input data rate until full (waveform only): {0:5.2f} MByte/s".format(
                full_acum_waveform_size/full_obj_time*1e-6))

            skip_frame_num = len(np.where(obj_id_diff > 1)[0])
            print("INFO: skipped frame num: {0:d}/{1:d}".format(
                skip_frame_num, int(ch_pd_dfs.iloc[-1]['OBJECT_ID']+1)))
            print("INFO: skipped frame rate: {0:3.4f}".format(
                skip_frame_num/(ch_pd_dfs.iloc[-1]['OBJECT_ID']+1)))
            print("INFO: frame len mean (before full): {0:4.2f} nsec".format(np.sum(
                ch_pd_dfs[ch_pd_dfs['OBJECT_ID'] <= first_full_obj_id]['FRAME_LEN'])/(first_full_obj_id+1)))
            print("INFO: frame len mean (after full): {0:4.2f} nsec".format(np.sum(
                ch_pd_dfs[ch_pd_dfs['OBJECT_ID'] > first_full_obj_id]['FRAME_LEN'])/(ch_pd_dfs.iloc[-1]['OBJECT_ID']-first_full_obj_id)))
        else:
            print("INFO: Internal buffer hasn't get full")
        total_rcvd_waveform_size = np.sum(ch_pd_dfs['FRAME_LEN'])*2
        total_rcvd_time = (ch_pd_dfs.iloc[-1]['TIMESTAMP']-t0)/TIMESTAMP_CLK_Hz
        print("INFO: Input data rate: {0:5.2f} MByte/s".format(
            total_rcvd_waveform_size/total_rcvd_time*1e-6))
        print("INFO: frame len mean (all): {0:4.2f} nsec".format(
            np.sum(ch_pd_dfs['FRAME_LEN'])/(ch_pd_dfs.iloc[-1]['OBJECT_ID']+1-skip_frame_num)))

        ax2.set_xlabel("Time[msec]")
        ax2.set_ylabel("total hit")
        ax2.plot(objs_t*1e3, objs+1, label="Total-hit", marker='.')

        # smooth_num = 256
        # if len(ch_pd_dfs) > smooth_num:
        #     smoother = np.ones(smooth_num)/smooth_num
        #     smoothed_hit_rate = np.convolve(raw_hit_rate, smoother, mode='valid')
        #     ax2_r.plot(objs_t[1:-smooth_num+1]*1e3,
        #                smoothed_hit_rate, label="Hit-rate", color='firebrick')
        # ax2_r.plot(objs_t[1:]*1e3,
        #            raw_hit_rate, label="Hit-rate", color='firebrick')

    ax2.set_yscale('log')

    ax2_r.set_xlabel("Time[msec]")
    ax2_r.set_ylabel("Hit-rate[MHz]")

    ax2_r.set_ylim(0.1, 25)
    if first_full_obj_id > 0:
        ax2_r.plot([full_obj_time*1e3, full_obj_time*1e3],
                   [0.1, 50], label='Internal buffer Full', color='k', ls='-.')
    handler, label = ax2.get_legend_handles_labels()
    r_handler, r_label = ax2_r.get_legend_handles_labels()
    ax2.legend(handler+r_handler, label+r_label, loc='lower right')

    plt.show()
