#include "df_extractor.h"

int GetFrameNum(unsigned long long *bin_data, int bin_data_depth) {
    int frame_num = 0;
    for (int i = 0; i < bin_data_depth; i++) {
        if ((int)(bin_data[i] >> 56) == HEADER_ID) {
            frame_num++;
        }
    }
    return frame_num;
}

void UnpackBinary(unsigned long long *bin_data, int bin_data_depth, int frame_num, unsigned int *ch_id_array, unsigned int *frame_len_array, unsigned int *frame_info_array,
                  unsigned int *trigger_type_array, int *charge_sum_array, int *rise_thre_array, int *fall_thre_array, unsigned int *object_id_array, unsigned long long *timestamp_array,
                  int *waveform_array) {
    int frame_index = 0;
    int i = 0;

    while (frame_index < frame_num) {
        if ((int)(bin_data[i] >> 56) == HEADER_ID) {
            ch_id_array[frame_index] = (unsigned int)((bin_data[i] & CH_ID_MASK) >> 48);

            unsigned int frame_len = (unsigned int)((bin_data[i] & FRAME_LENGTH_MASK) >> 32);
            frame_len_array[frame_index] = frame_len;

            frame_info_array[frame_index] = (unsigned int)((bin_data[i] & FRAME_INFO_MASK) >> 28);
            trigger_type_array[frame_index] = (unsigned int)((bin_data[i] & TRIGGER_TYPE_MASK) >> 24);
            unsigned long long header_timestamp = bin_data[i] & HEADER_TIMESTAMP_MASK;

            long long charge_sum = (long long)((bin_data[i + 1] & CHARGE_SUM_MASK) << 8) >> 40;
            charge_sum_array[frame_index] = (int)charge_sum;
            long long rise_thre = (long long)((bin_data[i + 1] & RISE_THRE_MASK) << 32) >> 48;
            rise_thre_array[frame_index] = (int)rise_thre;
            long long fall_thre = (long long)((bin_data[i + 1] & FALL_THRE_MASK) << 48) >> 48;
            fall_thre_array[frame_index] = (int)fall_thre;

            for (unsigned int j = 0; j < frame_len; j++) {
                long long sample_3 = (long long)(bin_data[i + 2 + j] & 0xFFFF000000000000) >> 48;
                long long sample_2 = (long long)((bin_data[i + 2 + j] & 0x0000FFFF00000000) << 16) >> 48;
                long long sample_1 = (long long)((bin_data[i + 2 + j] & 0x00000000FFFF0000) << 32) >> 48;
                long long sample_0 = (long long)((bin_data[i + 2 + j] & 0x000000000000FFFF) << 48) >> 48;

                waveform_array[frame_index * MAX_SAMPLE_NUM + j * SAMPLE_PER_LINE] = (int)sample_0;
                waveform_array[frame_index * MAX_SAMPLE_NUM + j * SAMPLE_PER_LINE + 1] = (int)sample_1;
                waveform_array[frame_index * MAX_SAMPLE_NUM + j * SAMPLE_PER_LINE + 2] = (int)sample_2;
                waveform_array[frame_index * MAX_SAMPLE_NUM + j * SAMPLE_PER_LINE + 3] = (int)sample_3;
            }

            unsigned long long footer_timestamp = bin_data[i + 2 + frame_len] & FOOTER_TIMESTAMP_MASK;
            timestamp_array[frame_index] = footer_timestamp | header_timestamp;
            object_id_array[frame_index] = bin_data[i + 2 + frame_len] & OBJECT_ID_MASK;

            int total_frame_len = HEADER_LINE_NUM + frame_len + FOOTER_LINE_NUM;
            i += total_frame_len + total_frame_len % (BUS_WIDTH / FRAME_WIDTH);
            if (i >= bin_data_depth) {
                // index over run
                break;
            }

            frame_index++;
        }
    }
};