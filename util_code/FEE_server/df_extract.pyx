# cython: language_level=3

import cython
import numpy as np
cimport numpy as cnp

cdef:
    DEF MAX_TRIGGER_LENGTH = 14
    DEF SAMPLE_NUM_PER_LINE = 4
    DEF MAX_SAMPLE_NUM = MAX_TRIGGER_LENGTH * 2 * SAMPLE_NUM_PER_LINE

cdef extern from "df_extractor.h":
    int GetFrameNum(unsigned long long *bin_data, int bin_data_size)
    int UnpackBinary(unsigned long long *bin_data, int bin_data_size, int frame_num, unsigned int *ch_id_array, unsigned int *frame_len_array, unsigned int *frame_info_array, unsigned int *trigger_type_array, int *charge_sum_array, int *rise_thre_array, int *fall_thre_array, unsigned int *object_id_array, unsigned long long *timestamp_array, int *waveform_array, int *h_gain_only_waveform_array)


def extract_df(cnp.ndarray[cnp.uint64_t, ndim=1] bin_data):

    cdef:   
        int cbin_data_size
        int cframe_num    

    cbin_data_size = len(bin_data)
    # print("INFO: data size:{:d}*8 byte".format(cbin_data_size))
    cframe_num = GetFrameNum(<unsigned long long*>bin_data.data, cbin_data_size)

    cdef:
        cnp.ndarray[unsigned int, ndim=1, mode="c"] ch_id_array = np.zeros(cframe_num, dtype='u4')
        cnp.ndarray[unsigned int, ndim=1, mode="c"] frame_len_array = np.zeros(cframe_num, dtype='u4')
        cnp.ndarray[unsigned int, ndim=1, mode="c"] frame_info_array = np.zeros(cframe_num, dtype='u4')
        cnp.ndarray[unsigned int, ndim=1, mode="c"] trigger_type_array = np.zeros(cframe_num, dtype='u4')
        cnp.ndarray[int, ndim=1, mode="c"] charge_sum_array = np.zeros(cframe_num, dtype='i4')
        cnp.ndarray[int, ndim=1, mode="c"] rise_thre_array = np.zeros(cframe_num, dtype='i4')
        cnp.ndarray[int, ndim=1, mode="c"] fall_thre_array = np.zeros(cframe_num, dtype='i4')
        cnp.ndarray[unsigned int, ndim=1, mode="c"] object_id_array = np.zeros(cframe_num, dtype='u4')
        cnp.ndarray[unsigned long long, ndim=1, mode="c"] timestamp_array = np.zeros(cframe_num, dtype='u8')
        cnp.ndarray[int, ndim=1, mode="c"] waveform_array = np.zeros(cframe_num*MAX_SAMPLE_NUM, dtype='i4') # high gain & low gain
        cnp.ndarray[int, ndim=2, mode="c"] reshaped_waveform_array 
        cnp.ndarray[int, ndim=1, mode="c"] h_gain_only_waveform_array = np.zeros(cframe_num*MAX_SAMPLE_NUM, dtype='i4') # high gain & averaged high gain
        cnp.ndarray[int, ndim=2, mode="c"] reshaped_h_gain_only_waveform_array       

    print("INFO: {:d} frames were acquired.".format(cframe_num))
    status = UnpackBinary(<unsigned long long*> bin_data.data, cbin_data_size, cframe_num, <unsigned int*>ch_id_array.data, <unsigned int*>frame_len_array.data, <unsigned int*>frame_info_array.data, <unsigned int*>trigger_type_array.data, <int*>charge_sum_array.data, <int*>rise_thre_array.data, <int*>fall_thre_array.data, <unsigned int*>object_id_array.data, <unsigned long long*>timestamp_array.data, <int*>waveform_array.data, <int*>h_gain_only_waveform_array.data)
    if status != 0:
        return status

    print("\rINFO: waveform array reshaping...", end='')
    reshaped_waveform_array = waveform_array.reshape([-1, MAX_SAMPLE_NUM])
    reshaped_h_gain_only_waveform_array = h_gain_only_waveform_array.reshape([-1, MAX_SAMPLE_NUM])
    print("\rINFO: waveform array reshaping...done!", end='\n')
    return ch_id_array, frame_len_array, frame_info_array, trigger_type_array, charge_sum_array, rise_thre_array, fall_thre_array, object_id_array, timestamp_array, reshaped_waveform_array, reshaped_h_gain_only_waveform_array
    

def combine_dfs(cnp.ndarray[cnp.uint32_t, ndim=1] frame_len_array, cnp.ndarray[cnp.int32_t, ndim=2] waveform_array):
    cdef:
        int frame_len_sum
        int last
        int stacked_sample_num = 0
        int sample_num
        cnp.ndarray[cnp.uint32_t, ndim=1] t
        cnp.ndarray[cnp.int32_t, ndim=1] wav

    frame_len_sum = np.sum(frame_len_array*SAMPLE_NUM_PER_LINE)
    last = len(frame_len_array)

    cdef:
        cnp.ndarray[cnp.int32_t, ndim=1] waves = np.zeros(frame_len_sum, dtype=np.int32)
        cnp.ndarray[cnp.uint32_t, ndim=1] times = np.zeros(frame_len_sum, dtype=np.uint32)

        progress = 0
    done = 0
    for df_index in range(last):
        if ((df_index+1) % 100 == 0):
            progress = int(10*(df_index+1)/last)
            print("\r #{0:d} / {1:d} frame is loaded".format(int(df_index+1), int(last)) + " [" + '='*progress + '>' + ' '*(9-progress) + "]", end='')
        if ((df_index+1 == last) & (done == 0)):
            print("\r #{0:d} / {1:d} frame is loaded".format(int(df_index+1), int(last)) + " [" + '='*10 + "] load done!", end='\n')
            done = 1

        sample_num = frame_len_array[df_index]*SAMPLE_NUM_PER_LINE
        t = np.arange(sample_num, dtype=np.uint32)
        wav = waveform_array[df_index, 0:sample_num]
    
        for i in range(sample_num):
            times[i+stacked_sample_num] = t[i]
            waves[i+stacked_sample_num] = wav[i]
        stacked_sample_num += sample_num

    return times, waves 


