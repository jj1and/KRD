#ifndef __DF_EXTRACTOR__
#define __DF_EXTRACTOR__

#define FRAME_WIDTH 8  // dataframe width is  64bit = 8byte
#define SAMPLE_PER_LINE 4
#define BUS_WIDTH 8  // axi bus width is 128bit = 16byte

#define MAX_TRIGGER_LENGTH 14
#define MAX_SAMPLE_NUM MAX_TRIGGER_LENGTH * 2 * SAMPLE_PER_LINE

#define HEADER_ID 0xAA
#define FOOTER_ID 0x55

#define CH_ID_MASK 0x00FFF00000000000
#define FRAME_LENGTH_MASK 0x00000FFF00000000
#define FRAME_INFO_MASK 0x00000000F0000000
#define TRIGGER_TYPE_MASK 0x000000000F000000
#define HEADER_TIMESTAMP_MASK 0x0000000000FFFFFF

#define CHARGE_SUM_MASK 0x00FFFFFF00000000
#define RISE_THRE_MASK 0x00000000FFFF0000
#define FALL_THRE_MASK 0x000000000000FFFF

#define FOOTER_TIMESTAMP_MASK 0x00FFFFFF00000000
#define OBJECT_ID_MASK 0x00000000FFFFFFFF

#define HEADER_LINE_NUM 2
#define HEADER_SIZE HEADER_LINE_NUM *FRAME_WIDTH

#define FOOTER_LINE_NUM 1
#define FOOTER_SIZE FOOTER_LINE_NUM *FRAME_WIDTH

int GetFrameNum(unsigned long long *bin_data, int bin_data_depth);

void UnpackBinary(unsigned long long *bin_data, int bin_data_depth, int frame_num, unsigned int *ch_id_array, unsigned int *frame_len_array, unsigned int *frame_info_array,
                  unsigned int *trigger_type_array, int *charge_sum_array, int *rise_thre_array, int *fall_thre_array, unsigned int *object_id_array, unsigned long long *timestamp_array,
                  int *waveform_array, int *h_gain_only_waveform_array);

#endif  // __DF_EXTRACTOR__