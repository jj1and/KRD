//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1.3 (win64) Build 2644227 Wed Sep  4 09:45:24 MDT 2019
//Date        : Thu Oct 22 12:59:45 2020
//Host        : AKABEKO03 running 64-bit major release  (build 9200)
//Command     : generate_target fee_cfg_sim_wrapper.bd
//Design      : fee_cfg_sim_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module fee_cfg_sim_wrapper
   (CH0_CONTROL_0_acquire_mode,
    CH0_CONTROL_0_falling_edge_threshold,
    CH0_CONTROL_0_h_gain_baseline,
    CH0_CONTROL_0_l_gain_baseline,
    CH0_CONTROL_0_max_trigger_length,
    CH0_CONTROL_0_post_acquisition_length,
    CH0_CONTROL_0_pre_acquisition_length,
    CH0_CONTROL_0_rising_edge_threshold,
    CH0_CONTROL_0_set_config,
    CH0_CONTROL_0_stop,
    CH0_CONTROL_0_trigger_type,
    CH10_CONTROL_0_acquire_mode,
    CH10_CONTROL_0_falling_edge_threshold,
    CH10_CONTROL_0_h_gain_baseline,
    CH10_CONTROL_0_l_gain_baseline,
    CH10_CONTROL_0_max_trigger_length,
    CH10_CONTROL_0_post_acquisition_length,
    CH10_CONTROL_0_pre_acquisition_length,
    CH10_CONTROL_0_rising_edge_threshold,
    CH10_CONTROL_0_set_config,
    CH10_CONTROL_0_stop,
    CH10_CONTROL_0_trigger_type,
    CH11_CONTROL_0_acquire_mode,
    CH11_CONTROL_0_falling_edge_threshold,
    CH11_CONTROL_0_h_gain_baseline,
    CH11_CONTROL_0_l_gain_baseline,
    CH11_CONTROL_0_max_trigger_length,
    CH11_CONTROL_0_post_acquisition_length,
    CH11_CONTROL_0_pre_acquisition_length,
    CH11_CONTROL_0_rising_edge_threshold,
    CH11_CONTROL_0_set_config,
    CH11_CONTROL_0_stop,
    CH11_CONTROL_0_trigger_type,
    CH12_CONTROL_0_acquire_mode,
    CH12_CONTROL_0_falling_edge_threshold,
    CH12_CONTROL_0_h_gain_baseline,
    CH12_CONTROL_0_l_gain_baseline,
    CH12_CONTROL_0_max_trigger_length,
    CH12_CONTROL_0_post_acquisition_length,
    CH12_CONTROL_0_pre_acquisition_length,
    CH12_CONTROL_0_rising_edge_threshold,
    CH12_CONTROL_0_set_config,
    CH12_CONTROL_0_stop,
    CH12_CONTROL_0_trigger_type,
    CH13_CONTROL_0_acquire_mode,
    CH13_CONTROL_0_falling_edge_threshold,
    CH13_CONTROL_0_h_gain_baseline,
    CH13_CONTROL_0_l_gain_baseline,
    CH13_CONTROL_0_max_trigger_length,
    CH13_CONTROL_0_post_acquisition_length,
    CH13_CONTROL_0_pre_acquisition_length,
    CH13_CONTROL_0_rising_edge_threshold,
    CH13_CONTROL_0_set_config,
    CH13_CONTROL_0_stop,
    CH13_CONTROL_0_trigger_type,
    CH14_CONTROL_0_acquire_mode,
    CH14_CONTROL_0_falling_edge_threshold,
    CH14_CONTROL_0_h_gain_baseline,
    CH14_CONTROL_0_l_gain_baseline,
    CH14_CONTROL_0_max_trigger_length,
    CH14_CONTROL_0_post_acquisition_length,
    CH14_CONTROL_0_pre_acquisition_length,
    CH14_CONTROL_0_rising_edge_threshold,
    CH14_CONTROL_0_set_config,
    CH14_CONTROL_0_stop,
    CH14_CONTROL_0_trigger_type,
    CH15_CONTROL_0_acquire_mode,
    CH15_CONTROL_0_falling_edge_threshold,
    CH15_CONTROL_0_h_gain_baseline,
    CH15_CONTROL_0_l_gain_baseline,
    CH15_CONTROL_0_max_trigger_length,
    CH15_CONTROL_0_post_acquisition_length,
    CH15_CONTROL_0_pre_acquisition_length,
    CH15_CONTROL_0_rising_edge_threshold,
    CH15_CONTROL_0_set_config,
    CH15_CONTROL_0_stop,
    CH15_CONTROL_0_trigger_type,
    CH1_CONTROL_0_acquire_mode,
    CH1_CONTROL_0_falling_edge_threshold,
    CH1_CONTROL_0_h_gain_baseline,
    CH1_CONTROL_0_l_gain_baseline,
    CH1_CONTROL_0_max_trigger_length,
    CH1_CONTROL_0_post_acquisition_length,
    CH1_CONTROL_0_pre_acquisition_length,
    CH1_CONTROL_0_rising_edge_threshold,
    CH1_CONTROL_0_set_config,
    CH1_CONTROL_0_stop,
    CH1_CONTROL_0_trigger_type,
    CH2_CONTROL_0_acquire_mode,
    CH2_CONTROL_0_falling_edge_threshold,
    CH2_CONTROL_0_h_gain_baseline,
    CH2_CONTROL_0_l_gain_baseline,
    CH2_CONTROL_0_max_trigger_length,
    CH2_CONTROL_0_post_acquisition_length,
    CH2_CONTROL_0_pre_acquisition_length,
    CH2_CONTROL_0_rising_edge_threshold,
    CH2_CONTROL_0_set_config,
    CH2_CONTROL_0_stop,
    CH2_CONTROL_0_trigger_type,
    CH3_CONTROL_0_acquire_mode,
    CH3_CONTROL_0_falling_edge_threshold,
    CH3_CONTROL_0_h_gain_baseline,
    CH3_CONTROL_0_l_gain_baseline,
    CH3_CONTROL_0_max_trigger_length,
    CH3_CONTROL_0_post_acquisition_length,
    CH3_CONTROL_0_pre_acquisition_length,
    CH3_CONTROL_0_rising_edge_threshold,
    CH3_CONTROL_0_set_config,
    CH3_CONTROL_0_stop,
    CH3_CONTROL_0_trigger_type,
    CH4_CONTROL_0_acquire_mode,
    CH4_CONTROL_0_falling_edge_threshold,
    CH4_CONTROL_0_h_gain_baseline,
    CH4_CONTROL_0_l_gain_baseline,
    CH4_CONTROL_0_max_trigger_length,
    CH4_CONTROL_0_post_acquisition_length,
    CH4_CONTROL_0_pre_acquisition_length,
    CH4_CONTROL_0_rising_edge_threshold,
    CH4_CONTROL_0_set_config,
    CH4_CONTROL_0_stop,
    CH4_CONTROL_0_trigger_type,
    CH5_CONTROL_0_acquire_mode,
    CH5_CONTROL_0_falling_edge_threshold,
    CH5_CONTROL_0_h_gain_baseline,
    CH5_CONTROL_0_l_gain_baseline,
    CH5_CONTROL_0_max_trigger_length,
    CH5_CONTROL_0_post_acquisition_length,
    CH5_CONTROL_0_pre_acquisition_length,
    CH5_CONTROL_0_rising_edge_threshold,
    CH5_CONTROL_0_set_config,
    CH5_CONTROL_0_stop,
    CH5_CONTROL_0_trigger_type,
    CH6_CONTROL_0_acquire_mode,
    CH6_CONTROL_0_falling_edge_threshold,
    CH6_CONTROL_0_h_gain_baseline,
    CH6_CONTROL_0_l_gain_baseline,
    CH6_CONTROL_0_max_trigger_length,
    CH6_CONTROL_0_post_acquisition_length,
    CH6_CONTROL_0_pre_acquisition_length,
    CH6_CONTROL_0_rising_edge_threshold,
    CH6_CONTROL_0_set_config,
    CH6_CONTROL_0_stop,
    CH6_CONTROL_0_trigger_type,
    CH7_CONTROL_0_acquire_mode,
    CH7_CONTROL_0_falling_edge_threshold,
    CH7_CONTROL_0_h_gain_baseline,
    CH7_CONTROL_0_l_gain_baseline,
    CH7_CONTROL_0_max_trigger_length,
    CH7_CONTROL_0_post_acquisition_length,
    CH7_CONTROL_0_pre_acquisition_length,
    CH7_CONTROL_0_rising_edge_threshold,
    CH7_CONTROL_0_set_config,
    CH7_CONTROL_0_stop,
    CH7_CONTROL_0_trigger_type,
    CH8_CONTROL_0_acquire_mode,
    CH8_CONTROL_0_falling_edge_threshold,
    CH8_CONTROL_0_h_gain_baseline,
    CH8_CONTROL_0_l_gain_baseline,
    CH8_CONTROL_0_max_trigger_length,
    CH8_CONTROL_0_post_acquisition_length,
    CH8_CONTROL_0_pre_acquisition_length,
    CH8_CONTROL_0_rising_edge_threshold,
    CH8_CONTROL_0_set_config,
    CH8_CONTROL_0_stop,
    CH8_CONTROL_0_trigger_type,
    CH9_CONTROL_0_acquire_mode,
    CH9_CONTROL_0_falling_edge_threshold,
    CH9_CONTROL_0_h_gain_baseline,
    CH9_CONTROL_0_l_gain_baseline,
    CH9_CONTROL_0_max_trigger_length,
    CH9_CONTROL_0_post_acquisition_length,
    CH9_CONTROL_0_pre_acquisition_length,
    CH9_CONTROL_0_rising_edge_threshold,
    CH9_CONTROL_0_set_config,
    CH9_CONTROL_0_stop,
    CH9_CONTROL_0_trigger_type,
    CLK,
    EXT_RESET);
  output [1:0]CH0_CONTROL_0_acquire_mode;
  output [15:0]CH0_CONTROL_0_falling_edge_threshold;
  output [12:0]CH0_CONTROL_0_h_gain_baseline;
  output [15:0]CH0_CONTROL_0_l_gain_baseline;
  output [15:0]CH0_CONTROL_0_max_trigger_length;
  output [1:0]CH0_CONTROL_0_post_acquisition_length;
  output [1:0]CH0_CONTROL_0_pre_acquisition_length;
  output [15:0]CH0_CONTROL_0_rising_edge_threshold;
  output CH0_CONTROL_0_set_config;
  output CH0_CONTROL_0_stop;
  output [3:0]CH0_CONTROL_0_trigger_type;
  output [1:0]CH10_CONTROL_0_acquire_mode;
  output [15:0]CH10_CONTROL_0_falling_edge_threshold;
  output [12:0]CH10_CONTROL_0_h_gain_baseline;
  output [15:0]CH10_CONTROL_0_l_gain_baseline;
  output [15:0]CH10_CONTROL_0_max_trigger_length;
  output [1:0]CH10_CONTROL_0_post_acquisition_length;
  output [1:0]CH10_CONTROL_0_pre_acquisition_length;
  output [15:0]CH10_CONTROL_0_rising_edge_threshold;
  output CH10_CONTROL_0_set_config;
  output CH10_CONTROL_0_stop;
  output [3:0]CH10_CONTROL_0_trigger_type;
  output [1:0]CH11_CONTROL_0_acquire_mode;
  output [15:0]CH11_CONTROL_0_falling_edge_threshold;
  output [12:0]CH11_CONTROL_0_h_gain_baseline;
  output [15:0]CH11_CONTROL_0_l_gain_baseline;
  output [15:0]CH11_CONTROL_0_max_trigger_length;
  output [1:0]CH11_CONTROL_0_post_acquisition_length;
  output [1:0]CH11_CONTROL_0_pre_acquisition_length;
  output [15:0]CH11_CONTROL_0_rising_edge_threshold;
  output CH11_CONTROL_0_set_config;
  output CH11_CONTROL_0_stop;
  output [3:0]CH11_CONTROL_0_trigger_type;
  output [1:0]CH12_CONTROL_0_acquire_mode;
  output [15:0]CH12_CONTROL_0_falling_edge_threshold;
  output [12:0]CH12_CONTROL_0_h_gain_baseline;
  output [15:0]CH12_CONTROL_0_l_gain_baseline;
  output [15:0]CH12_CONTROL_0_max_trigger_length;
  output [1:0]CH12_CONTROL_0_post_acquisition_length;
  output [1:0]CH12_CONTROL_0_pre_acquisition_length;
  output [15:0]CH12_CONTROL_0_rising_edge_threshold;
  output CH12_CONTROL_0_set_config;
  output CH12_CONTROL_0_stop;
  output [3:0]CH12_CONTROL_0_trigger_type;
  output [1:0]CH13_CONTROL_0_acquire_mode;
  output [15:0]CH13_CONTROL_0_falling_edge_threshold;
  output [12:0]CH13_CONTROL_0_h_gain_baseline;
  output [15:0]CH13_CONTROL_0_l_gain_baseline;
  output [15:0]CH13_CONTROL_0_max_trigger_length;
  output [1:0]CH13_CONTROL_0_post_acquisition_length;
  output [1:0]CH13_CONTROL_0_pre_acquisition_length;
  output [15:0]CH13_CONTROL_0_rising_edge_threshold;
  output CH13_CONTROL_0_set_config;
  output CH13_CONTROL_0_stop;
  output [3:0]CH13_CONTROL_0_trigger_type;
  output [1:0]CH14_CONTROL_0_acquire_mode;
  output [15:0]CH14_CONTROL_0_falling_edge_threshold;
  output [12:0]CH14_CONTROL_0_h_gain_baseline;
  output [15:0]CH14_CONTROL_0_l_gain_baseline;
  output [15:0]CH14_CONTROL_0_max_trigger_length;
  output [1:0]CH14_CONTROL_0_post_acquisition_length;
  output [1:0]CH14_CONTROL_0_pre_acquisition_length;
  output [15:0]CH14_CONTROL_0_rising_edge_threshold;
  output CH14_CONTROL_0_set_config;
  output CH14_CONTROL_0_stop;
  output [3:0]CH14_CONTROL_0_trigger_type;
  output [1:0]CH15_CONTROL_0_acquire_mode;
  output [15:0]CH15_CONTROL_0_falling_edge_threshold;
  output [12:0]CH15_CONTROL_0_h_gain_baseline;
  output [15:0]CH15_CONTROL_0_l_gain_baseline;
  output [15:0]CH15_CONTROL_0_max_trigger_length;
  output [1:0]CH15_CONTROL_0_post_acquisition_length;
  output [1:0]CH15_CONTROL_0_pre_acquisition_length;
  output [15:0]CH15_CONTROL_0_rising_edge_threshold;
  output CH15_CONTROL_0_set_config;
  output CH15_CONTROL_0_stop;
  output [3:0]CH15_CONTROL_0_trigger_type;
  output [1:0]CH1_CONTROL_0_acquire_mode;
  output [15:0]CH1_CONTROL_0_falling_edge_threshold;
  output [12:0]CH1_CONTROL_0_h_gain_baseline;
  output [15:0]CH1_CONTROL_0_l_gain_baseline;
  output [15:0]CH1_CONTROL_0_max_trigger_length;
  output [1:0]CH1_CONTROL_0_post_acquisition_length;
  output [1:0]CH1_CONTROL_0_pre_acquisition_length;
  output [15:0]CH1_CONTROL_0_rising_edge_threshold;
  output CH1_CONTROL_0_set_config;
  output CH1_CONTROL_0_stop;
  output [3:0]CH1_CONTROL_0_trigger_type;
  output [1:0]CH2_CONTROL_0_acquire_mode;
  output [15:0]CH2_CONTROL_0_falling_edge_threshold;
  output [12:0]CH2_CONTROL_0_h_gain_baseline;
  output [15:0]CH2_CONTROL_0_l_gain_baseline;
  output [15:0]CH2_CONTROL_0_max_trigger_length;
  output [1:0]CH2_CONTROL_0_post_acquisition_length;
  output [1:0]CH2_CONTROL_0_pre_acquisition_length;
  output [15:0]CH2_CONTROL_0_rising_edge_threshold;
  output CH2_CONTROL_0_set_config;
  output CH2_CONTROL_0_stop;
  output [3:0]CH2_CONTROL_0_trigger_type;
  output [1:0]CH3_CONTROL_0_acquire_mode;
  output [15:0]CH3_CONTROL_0_falling_edge_threshold;
  output [12:0]CH3_CONTROL_0_h_gain_baseline;
  output [15:0]CH3_CONTROL_0_l_gain_baseline;
  output [15:0]CH3_CONTROL_0_max_trigger_length;
  output [1:0]CH3_CONTROL_0_post_acquisition_length;
  output [1:0]CH3_CONTROL_0_pre_acquisition_length;
  output [15:0]CH3_CONTROL_0_rising_edge_threshold;
  output CH3_CONTROL_0_set_config;
  output CH3_CONTROL_0_stop;
  output [3:0]CH3_CONTROL_0_trigger_type;
  output [1:0]CH4_CONTROL_0_acquire_mode;
  output [15:0]CH4_CONTROL_0_falling_edge_threshold;
  output [12:0]CH4_CONTROL_0_h_gain_baseline;
  output [15:0]CH4_CONTROL_0_l_gain_baseline;
  output [15:0]CH4_CONTROL_0_max_trigger_length;
  output [1:0]CH4_CONTROL_0_post_acquisition_length;
  output [1:0]CH4_CONTROL_0_pre_acquisition_length;
  output [15:0]CH4_CONTROL_0_rising_edge_threshold;
  output CH4_CONTROL_0_set_config;
  output CH4_CONTROL_0_stop;
  output [3:0]CH4_CONTROL_0_trigger_type;
  output [1:0]CH5_CONTROL_0_acquire_mode;
  output [15:0]CH5_CONTROL_0_falling_edge_threshold;
  output [12:0]CH5_CONTROL_0_h_gain_baseline;
  output [15:0]CH5_CONTROL_0_l_gain_baseline;
  output [15:0]CH5_CONTROL_0_max_trigger_length;
  output [1:0]CH5_CONTROL_0_post_acquisition_length;
  output [1:0]CH5_CONTROL_0_pre_acquisition_length;
  output [15:0]CH5_CONTROL_0_rising_edge_threshold;
  output CH5_CONTROL_0_set_config;
  output CH5_CONTROL_0_stop;
  output [3:0]CH5_CONTROL_0_trigger_type;
  output [1:0]CH6_CONTROL_0_acquire_mode;
  output [15:0]CH6_CONTROL_0_falling_edge_threshold;
  output [12:0]CH6_CONTROL_0_h_gain_baseline;
  output [15:0]CH6_CONTROL_0_l_gain_baseline;
  output [15:0]CH6_CONTROL_0_max_trigger_length;
  output [1:0]CH6_CONTROL_0_post_acquisition_length;
  output [1:0]CH6_CONTROL_0_pre_acquisition_length;
  output [15:0]CH6_CONTROL_0_rising_edge_threshold;
  output CH6_CONTROL_0_set_config;
  output CH6_CONTROL_0_stop;
  output [3:0]CH6_CONTROL_0_trigger_type;
  output [1:0]CH7_CONTROL_0_acquire_mode;
  output [15:0]CH7_CONTROL_0_falling_edge_threshold;
  output [12:0]CH7_CONTROL_0_h_gain_baseline;
  output [15:0]CH7_CONTROL_0_l_gain_baseline;
  output [15:0]CH7_CONTROL_0_max_trigger_length;
  output [1:0]CH7_CONTROL_0_post_acquisition_length;
  output [1:0]CH7_CONTROL_0_pre_acquisition_length;
  output [15:0]CH7_CONTROL_0_rising_edge_threshold;
  output CH7_CONTROL_0_set_config;
  output CH7_CONTROL_0_stop;
  output [3:0]CH7_CONTROL_0_trigger_type;
  output [1:0]CH8_CONTROL_0_acquire_mode;
  output [15:0]CH8_CONTROL_0_falling_edge_threshold;
  output [12:0]CH8_CONTROL_0_h_gain_baseline;
  output [15:0]CH8_CONTROL_0_l_gain_baseline;
  output [15:0]CH8_CONTROL_0_max_trigger_length;
  output [1:0]CH8_CONTROL_0_post_acquisition_length;
  output [1:0]CH8_CONTROL_0_pre_acquisition_length;
  output [15:0]CH8_CONTROL_0_rising_edge_threshold;
  output CH8_CONTROL_0_set_config;
  output CH8_CONTROL_0_stop;
  output [3:0]CH8_CONTROL_0_trigger_type;
  output [1:0]CH9_CONTROL_0_acquire_mode;
  output [15:0]CH9_CONTROL_0_falling_edge_threshold;
  output [12:0]CH9_CONTROL_0_h_gain_baseline;
  output [15:0]CH9_CONTROL_0_l_gain_baseline;
  output [15:0]CH9_CONTROL_0_max_trigger_length;
  output [1:0]CH9_CONTROL_0_post_acquisition_length;
  output [1:0]CH9_CONTROL_0_pre_acquisition_length;
  output [15:0]CH9_CONTROL_0_rising_edge_threshold;
  output CH9_CONTROL_0_set_config;
  output CH9_CONTROL_0_stop;
  output [3:0]CH9_CONTROL_0_trigger_type;
  input CLK;
  input EXT_RESET;

  wire [1:0]CH0_CONTROL_0_acquire_mode;
  wire [15:0]CH0_CONTROL_0_falling_edge_threshold;
  wire [12:0]CH0_CONTROL_0_h_gain_baseline;
  wire [15:0]CH0_CONTROL_0_l_gain_baseline;
  wire [15:0]CH0_CONTROL_0_max_trigger_length;
  wire [1:0]CH0_CONTROL_0_post_acquisition_length;
  wire [1:0]CH0_CONTROL_0_pre_acquisition_length;
  wire [15:0]CH0_CONTROL_0_rising_edge_threshold;
  wire CH0_CONTROL_0_set_config;
  wire CH0_CONTROL_0_stop;
  wire [3:0]CH0_CONTROL_0_trigger_type;
  wire [1:0]CH10_CONTROL_0_acquire_mode;
  wire [15:0]CH10_CONTROL_0_falling_edge_threshold;
  wire [12:0]CH10_CONTROL_0_h_gain_baseline;
  wire [15:0]CH10_CONTROL_0_l_gain_baseline;
  wire [15:0]CH10_CONTROL_0_max_trigger_length;
  wire [1:0]CH10_CONTROL_0_post_acquisition_length;
  wire [1:0]CH10_CONTROL_0_pre_acquisition_length;
  wire [15:0]CH10_CONTROL_0_rising_edge_threshold;
  wire CH10_CONTROL_0_set_config;
  wire CH10_CONTROL_0_stop;
  wire [3:0]CH10_CONTROL_0_trigger_type;
  wire [1:0]CH11_CONTROL_0_acquire_mode;
  wire [15:0]CH11_CONTROL_0_falling_edge_threshold;
  wire [12:0]CH11_CONTROL_0_h_gain_baseline;
  wire [15:0]CH11_CONTROL_0_l_gain_baseline;
  wire [15:0]CH11_CONTROL_0_max_trigger_length;
  wire [1:0]CH11_CONTROL_0_post_acquisition_length;
  wire [1:0]CH11_CONTROL_0_pre_acquisition_length;
  wire [15:0]CH11_CONTROL_0_rising_edge_threshold;
  wire CH11_CONTROL_0_set_config;
  wire CH11_CONTROL_0_stop;
  wire [3:0]CH11_CONTROL_0_trigger_type;
  wire [1:0]CH12_CONTROL_0_acquire_mode;
  wire [15:0]CH12_CONTROL_0_falling_edge_threshold;
  wire [12:0]CH12_CONTROL_0_h_gain_baseline;
  wire [15:0]CH12_CONTROL_0_l_gain_baseline;
  wire [15:0]CH12_CONTROL_0_max_trigger_length;
  wire [1:0]CH12_CONTROL_0_post_acquisition_length;
  wire [1:0]CH12_CONTROL_0_pre_acquisition_length;
  wire [15:0]CH12_CONTROL_0_rising_edge_threshold;
  wire CH12_CONTROL_0_set_config;
  wire CH12_CONTROL_0_stop;
  wire [3:0]CH12_CONTROL_0_trigger_type;
  wire [1:0]CH13_CONTROL_0_acquire_mode;
  wire [15:0]CH13_CONTROL_0_falling_edge_threshold;
  wire [12:0]CH13_CONTROL_0_h_gain_baseline;
  wire [15:0]CH13_CONTROL_0_l_gain_baseline;
  wire [15:0]CH13_CONTROL_0_max_trigger_length;
  wire [1:0]CH13_CONTROL_0_post_acquisition_length;
  wire [1:0]CH13_CONTROL_0_pre_acquisition_length;
  wire [15:0]CH13_CONTROL_0_rising_edge_threshold;
  wire CH13_CONTROL_0_set_config;
  wire CH13_CONTROL_0_stop;
  wire [3:0]CH13_CONTROL_0_trigger_type;
  wire [1:0]CH14_CONTROL_0_acquire_mode;
  wire [15:0]CH14_CONTROL_0_falling_edge_threshold;
  wire [12:0]CH14_CONTROL_0_h_gain_baseline;
  wire [15:0]CH14_CONTROL_0_l_gain_baseline;
  wire [15:0]CH14_CONTROL_0_max_trigger_length;
  wire [1:0]CH14_CONTROL_0_post_acquisition_length;
  wire [1:0]CH14_CONTROL_0_pre_acquisition_length;
  wire [15:0]CH14_CONTROL_0_rising_edge_threshold;
  wire CH14_CONTROL_0_set_config;
  wire CH14_CONTROL_0_stop;
  wire [3:0]CH14_CONTROL_0_trigger_type;
  wire [1:0]CH15_CONTROL_0_acquire_mode;
  wire [15:0]CH15_CONTROL_0_falling_edge_threshold;
  wire [12:0]CH15_CONTROL_0_h_gain_baseline;
  wire [15:0]CH15_CONTROL_0_l_gain_baseline;
  wire [15:0]CH15_CONTROL_0_max_trigger_length;
  wire [1:0]CH15_CONTROL_0_post_acquisition_length;
  wire [1:0]CH15_CONTROL_0_pre_acquisition_length;
  wire [15:0]CH15_CONTROL_0_rising_edge_threshold;
  wire CH15_CONTROL_0_set_config;
  wire CH15_CONTROL_0_stop;
  wire [3:0]CH15_CONTROL_0_trigger_type;
  wire [1:0]CH1_CONTROL_0_acquire_mode;
  wire [15:0]CH1_CONTROL_0_falling_edge_threshold;
  wire [12:0]CH1_CONTROL_0_h_gain_baseline;
  wire [15:0]CH1_CONTROL_0_l_gain_baseline;
  wire [15:0]CH1_CONTROL_0_max_trigger_length;
  wire [1:0]CH1_CONTROL_0_post_acquisition_length;
  wire [1:0]CH1_CONTROL_0_pre_acquisition_length;
  wire [15:0]CH1_CONTROL_0_rising_edge_threshold;
  wire CH1_CONTROL_0_set_config;
  wire CH1_CONTROL_0_stop;
  wire [3:0]CH1_CONTROL_0_trigger_type;
  wire [1:0]CH2_CONTROL_0_acquire_mode;
  wire [15:0]CH2_CONTROL_0_falling_edge_threshold;
  wire [12:0]CH2_CONTROL_0_h_gain_baseline;
  wire [15:0]CH2_CONTROL_0_l_gain_baseline;
  wire [15:0]CH2_CONTROL_0_max_trigger_length;
  wire [1:0]CH2_CONTROL_0_post_acquisition_length;
  wire [1:0]CH2_CONTROL_0_pre_acquisition_length;
  wire [15:0]CH2_CONTROL_0_rising_edge_threshold;
  wire CH2_CONTROL_0_set_config;
  wire CH2_CONTROL_0_stop;
  wire [3:0]CH2_CONTROL_0_trigger_type;
  wire [1:0]CH3_CONTROL_0_acquire_mode;
  wire [15:0]CH3_CONTROL_0_falling_edge_threshold;
  wire [12:0]CH3_CONTROL_0_h_gain_baseline;
  wire [15:0]CH3_CONTROL_0_l_gain_baseline;
  wire [15:0]CH3_CONTROL_0_max_trigger_length;
  wire [1:0]CH3_CONTROL_0_post_acquisition_length;
  wire [1:0]CH3_CONTROL_0_pre_acquisition_length;
  wire [15:0]CH3_CONTROL_0_rising_edge_threshold;
  wire CH3_CONTROL_0_set_config;
  wire CH3_CONTROL_0_stop;
  wire [3:0]CH3_CONTROL_0_trigger_type;
  wire [1:0]CH4_CONTROL_0_acquire_mode;
  wire [15:0]CH4_CONTROL_0_falling_edge_threshold;
  wire [12:0]CH4_CONTROL_0_h_gain_baseline;
  wire [15:0]CH4_CONTROL_0_l_gain_baseline;
  wire [15:0]CH4_CONTROL_0_max_trigger_length;
  wire [1:0]CH4_CONTROL_0_post_acquisition_length;
  wire [1:0]CH4_CONTROL_0_pre_acquisition_length;
  wire [15:0]CH4_CONTROL_0_rising_edge_threshold;
  wire CH4_CONTROL_0_set_config;
  wire CH4_CONTROL_0_stop;
  wire [3:0]CH4_CONTROL_0_trigger_type;
  wire [1:0]CH5_CONTROL_0_acquire_mode;
  wire [15:0]CH5_CONTROL_0_falling_edge_threshold;
  wire [12:0]CH5_CONTROL_0_h_gain_baseline;
  wire [15:0]CH5_CONTROL_0_l_gain_baseline;
  wire [15:0]CH5_CONTROL_0_max_trigger_length;
  wire [1:0]CH5_CONTROL_0_post_acquisition_length;
  wire [1:0]CH5_CONTROL_0_pre_acquisition_length;
  wire [15:0]CH5_CONTROL_0_rising_edge_threshold;
  wire CH5_CONTROL_0_set_config;
  wire CH5_CONTROL_0_stop;
  wire [3:0]CH5_CONTROL_0_trigger_type;
  wire [1:0]CH6_CONTROL_0_acquire_mode;
  wire [15:0]CH6_CONTROL_0_falling_edge_threshold;
  wire [12:0]CH6_CONTROL_0_h_gain_baseline;
  wire [15:0]CH6_CONTROL_0_l_gain_baseline;
  wire [15:0]CH6_CONTROL_0_max_trigger_length;
  wire [1:0]CH6_CONTROL_0_post_acquisition_length;
  wire [1:0]CH6_CONTROL_0_pre_acquisition_length;
  wire [15:0]CH6_CONTROL_0_rising_edge_threshold;
  wire CH6_CONTROL_0_set_config;
  wire CH6_CONTROL_0_stop;
  wire [3:0]CH6_CONTROL_0_trigger_type;
  wire [1:0]CH7_CONTROL_0_acquire_mode;
  wire [15:0]CH7_CONTROL_0_falling_edge_threshold;
  wire [12:0]CH7_CONTROL_0_h_gain_baseline;
  wire [15:0]CH7_CONTROL_0_l_gain_baseline;
  wire [15:0]CH7_CONTROL_0_max_trigger_length;
  wire [1:0]CH7_CONTROL_0_post_acquisition_length;
  wire [1:0]CH7_CONTROL_0_pre_acquisition_length;
  wire [15:0]CH7_CONTROL_0_rising_edge_threshold;
  wire CH7_CONTROL_0_set_config;
  wire CH7_CONTROL_0_stop;
  wire [3:0]CH7_CONTROL_0_trigger_type;
  wire [1:0]CH8_CONTROL_0_acquire_mode;
  wire [15:0]CH8_CONTROL_0_falling_edge_threshold;
  wire [12:0]CH8_CONTROL_0_h_gain_baseline;
  wire [15:0]CH8_CONTROL_0_l_gain_baseline;
  wire [15:0]CH8_CONTROL_0_max_trigger_length;
  wire [1:0]CH8_CONTROL_0_post_acquisition_length;
  wire [1:0]CH8_CONTROL_0_pre_acquisition_length;
  wire [15:0]CH8_CONTROL_0_rising_edge_threshold;
  wire CH8_CONTROL_0_set_config;
  wire CH8_CONTROL_0_stop;
  wire [3:0]CH8_CONTROL_0_trigger_type;
  wire [1:0]CH9_CONTROL_0_acquire_mode;
  wire [15:0]CH9_CONTROL_0_falling_edge_threshold;
  wire [12:0]CH9_CONTROL_0_h_gain_baseline;
  wire [15:0]CH9_CONTROL_0_l_gain_baseline;
  wire [15:0]CH9_CONTROL_0_max_trigger_length;
  wire [1:0]CH9_CONTROL_0_post_acquisition_length;
  wire [1:0]CH9_CONTROL_0_pre_acquisition_length;
  wire [15:0]CH9_CONTROL_0_rising_edge_threshold;
  wire CH9_CONTROL_0_set_config;
  wire CH9_CONTROL_0_stop;
  wire [3:0]CH9_CONTROL_0_trigger_type;
  wire CLK;
  wire EXT_RESET;

  fee_cfg_sim fee_cfg_sim_i
       (.CH0_CONTROL_0_acquire_mode(CH0_CONTROL_0_acquire_mode),
        .CH0_CONTROL_0_falling_edge_threshold(CH0_CONTROL_0_falling_edge_threshold),
        .CH0_CONTROL_0_h_gain_baseline(CH0_CONTROL_0_h_gain_baseline),
        .CH0_CONTROL_0_l_gain_baseline(CH0_CONTROL_0_l_gain_baseline),
        .CH0_CONTROL_0_max_trigger_length(CH0_CONTROL_0_max_trigger_length),
        .CH0_CONTROL_0_post_acquisition_length(CH0_CONTROL_0_post_acquisition_length),
        .CH0_CONTROL_0_pre_acquisition_length(CH0_CONTROL_0_pre_acquisition_length),
        .CH0_CONTROL_0_rising_edge_threshold(CH0_CONTROL_0_rising_edge_threshold),
        .CH0_CONTROL_0_set_config(CH0_CONTROL_0_set_config),
        .CH0_CONTROL_0_stop(CH0_CONTROL_0_stop),
        .CH0_CONTROL_0_trigger_type(CH0_CONTROL_0_trigger_type),
        .CH10_CONTROL_0_acquire_mode(CH10_CONTROL_0_acquire_mode),
        .CH10_CONTROL_0_falling_edge_threshold(CH10_CONTROL_0_falling_edge_threshold),
        .CH10_CONTROL_0_h_gain_baseline(CH10_CONTROL_0_h_gain_baseline),
        .CH10_CONTROL_0_l_gain_baseline(CH10_CONTROL_0_l_gain_baseline),
        .CH10_CONTROL_0_max_trigger_length(CH10_CONTROL_0_max_trigger_length),
        .CH10_CONTROL_0_post_acquisition_length(CH10_CONTROL_0_post_acquisition_length),
        .CH10_CONTROL_0_pre_acquisition_length(CH10_CONTROL_0_pre_acquisition_length),
        .CH10_CONTROL_0_rising_edge_threshold(CH10_CONTROL_0_rising_edge_threshold),
        .CH10_CONTROL_0_set_config(CH10_CONTROL_0_set_config),
        .CH10_CONTROL_0_stop(CH10_CONTROL_0_stop),
        .CH10_CONTROL_0_trigger_type(CH10_CONTROL_0_trigger_type),
        .CH11_CONTROL_0_acquire_mode(CH11_CONTROL_0_acquire_mode),
        .CH11_CONTROL_0_falling_edge_threshold(CH11_CONTROL_0_falling_edge_threshold),
        .CH11_CONTROL_0_h_gain_baseline(CH11_CONTROL_0_h_gain_baseline),
        .CH11_CONTROL_0_l_gain_baseline(CH11_CONTROL_0_l_gain_baseline),
        .CH11_CONTROL_0_max_trigger_length(CH11_CONTROL_0_max_trigger_length),
        .CH11_CONTROL_0_post_acquisition_length(CH11_CONTROL_0_post_acquisition_length),
        .CH11_CONTROL_0_pre_acquisition_length(CH11_CONTROL_0_pre_acquisition_length),
        .CH11_CONTROL_0_rising_edge_threshold(CH11_CONTROL_0_rising_edge_threshold),
        .CH11_CONTROL_0_set_config(CH11_CONTROL_0_set_config),
        .CH11_CONTROL_0_stop(CH11_CONTROL_0_stop),
        .CH11_CONTROL_0_trigger_type(CH11_CONTROL_0_trigger_type),
        .CH12_CONTROL_0_acquire_mode(CH12_CONTROL_0_acquire_mode),
        .CH12_CONTROL_0_falling_edge_threshold(CH12_CONTROL_0_falling_edge_threshold),
        .CH12_CONTROL_0_h_gain_baseline(CH12_CONTROL_0_h_gain_baseline),
        .CH12_CONTROL_0_l_gain_baseline(CH12_CONTROL_0_l_gain_baseline),
        .CH12_CONTROL_0_max_trigger_length(CH12_CONTROL_0_max_trigger_length),
        .CH12_CONTROL_0_post_acquisition_length(CH12_CONTROL_0_post_acquisition_length),
        .CH12_CONTROL_0_pre_acquisition_length(CH12_CONTROL_0_pre_acquisition_length),
        .CH12_CONTROL_0_rising_edge_threshold(CH12_CONTROL_0_rising_edge_threshold),
        .CH12_CONTROL_0_set_config(CH12_CONTROL_0_set_config),
        .CH12_CONTROL_0_stop(CH12_CONTROL_0_stop),
        .CH12_CONTROL_0_trigger_type(CH12_CONTROL_0_trigger_type),
        .CH13_CONTROL_0_acquire_mode(CH13_CONTROL_0_acquire_mode),
        .CH13_CONTROL_0_falling_edge_threshold(CH13_CONTROL_0_falling_edge_threshold),
        .CH13_CONTROL_0_h_gain_baseline(CH13_CONTROL_0_h_gain_baseline),
        .CH13_CONTROL_0_l_gain_baseline(CH13_CONTROL_0_l_gain_baseline),
        .CH13_CONTROL_0_max_trigger_length(CH13_CONTROL_0_max_trigger_length),
        .CH13_CONTROL_0_post_acquisition_length(CH13_CONTROL_0_post_acquisition_length),
        .CH13_CONTROL_0_pre_acquisition_length(CH13_CONTROL_0_pre_acquisition_length),
        .CH13_CONTROL_0_rising_edge_threshold(CH13_CONTROL_0_rising_edge_threshold),
        .CH13_CONTROL_0_set_config(CH13_CONTROL_0_set_config),
        .CH13_CONTROL_0_stop(CH13_CONTROL_0_stop),
        .CH13_CONTROL_0_trigger_type(CH13_CONTROL_0_trigger_type),
        .CH14_CONTROL_0_acquire_mode(CH14_CONTROL_0_acquire_mode),
        .CH14_CONTROL_0_falling_edge_threshold(CH14_CONTROL_0_falling_edge_threshold),
        .CH14_CONTROL_0_h_gain_baseline(CH14_CONTROL_0_h_gain_baseline),
        .CH14_CONTROL_0_l_gain_baseline(CH14_CONTROL_0_l_gain_baseline),
        .CH14_CONTROL_0_max_trigger_length(CH14_CONTROL_0_max_trigger_length),
        .CH14_CONTROL_0_post_acquisition_length(CH14_CONTROL_0_post_acquisition_length),
        .CH14_CONTROL_0_pre_acquisition_length(CH14_CONTROL_0_pre_acquisition_length),
        .CH14_CONTROL_0_rising_edge_threshold(CH14_CONTROL_0_rising_edge_threshold),
        .CH14_CONTROL_0_set_config(CH14_CONTROL_0_set_config),
        .CH14_CONTROL_0_stop(CH14_CONTROL_0_stop),
        .CH14_CONTROL_0_trigger_type(CH14_CONTROL_0_trigger_type),
        .CH15_CONTROL_0_acquire_mode(CH15_CONTROL_0_acquire_mode),
        .CH15_CONTROL_0_falling_edge_threshold(CH15_CONTROL_0_falling_edge_threshold),
        .CH15_CONTROL_0_h_gain_baseline(CH15_CONTROL_0_h_gain_baseline),
        .CH15_CONTROL_0_l_gain_baseline(CH15_CONTROL_0_l_gain_baseline),
        .CH15_CONTROL_0_max_trigger_length(CH15_CONTROL_0_max_trigger_length),
        .CH15_CONTROL_0_post_acquisition_length(CH15_CONTROL_0_post_acquisition_length),
        .CH15_CONTROL_0_pre_acquisition_length(CH15_CONTROL_0_pre_acquisition_length),
        .CH15_CONTROL_0_rising_edge_threshold(CH15_CONTROL_0_rising_edge_threshold),
        .CH15_CONTROL_0_set_config(CH15_CONTROL_0_set_config),
        .CH15_CONTROL_0_stop(CH15_CONTROL_0_stop),
        .CH15_CONTROL_0_trigger_type(CH15_CONTROL_0_trigger_type),
        .CH1_CONTROL_0_acquire_mode(CH1_CONTROL_0_acquire_mode),
        .CH1_CONTROL_0_falling_edge_threshold(CH1_CONTROL_0_falling_edge_threshold),
        .CH1_CONTROL_0_h_gain_baseline(CH1_CONTROL_0_h_gain_baseline),
        .CH1_CONTROL_0_l_gain_baseline(CH1_CONTROL_0_l_gain_baseline),
        .CH1_CONTROL_0_max_trigger_length(CH1_CONTROL_0_max_trigger_length),
        .CH1_CONTROL_0_post_acquisition_length(CH1_CONTROL_0_post_acquisition_length),
        .CH1_CONTROL_0_pre_acquisition_length(CH1_CONTROL_0_pre_acquisition_length),
        .CH1_CONTROL_0_rising_edge_threshold(CH1_CONTROL_0_rising_edge_threshold),
        .CH1_CONTROL_0_set_config(CH1_CONTROL_0_set_config),
        .CH1_CONTROL_0_stop(CH1_CONTROL_0_stop),
        .CH1_CONTROL_0_trigger_type(CH1_CONTROL_0_trigger_type),
        .CH2_CONTROL_0_acquire_mode(CH2_CONTROL_0_acquire_mode),
        .CH2_CONTROL_0_falling_edge_threshold(CH2_CONTROL_0_falling_edge_threshold),
        .CH2_CONTROL_0_h_gain_baseline(CH2_CONTROL_0_h_gain_baseline),
        .CH2_CONTROL_0_l_gain_baseline(CH2_CONTROL_0_l_gain_baseline),
        .CH2_CONTROL_0_max_trigger_length(CH2_CONTROL_0_max_trigger_length),
        .CH2_CONTROL_0_post_acquisition_length(CH2_CONTROL_0_post_acquisition_length),
        .CH2_CONTROL_0_pre_acquisition_length(CH2_CONTROL_0_pre_acquisition_length),
        .CH2_CONTROL_0_rising_edge_threshold(CH2_CONTROL_0_rising_edge_threshold),
        .CH2_CONTROL_0_set_config(CH2_CONTROL_0_set_config),
        .CH2_CONTROL_0_stop(CH2_CONTROL_0_stop),
        .CH2_CONTROL_0_trigger_type(CH2_CONTROL_0_trigger_type),
        .CH3_CONTROL_0_acquire_mode(CH3_CONTROL_0_acquire_mode),
        .CH3_CONTROL_0_falling_edge_threshold(CH3_CONTROL_0_falling_edge_threshold),
        .CH3_CONTROL_0_h_gain_baseline(CH3_CONTROL_0_h_gain_baseline),
        .CH3_CONTROL_0_l_gain_baseline(CH3_CONTROL_0_l_gain_baseline),
        .CH3_CONTROL_0_max_trigger_length(CH3_CONTROL_0_max_trigger_length),
        .CH3_CONTROL_0_post_acquisition_length(CH3_CONTROL_0_post_acquisition_length),
        .CH3_CONTROL_0_pre_acquisition_length(CH3_CONTROL_0_pre_acquisition_length),
        .CH3_CONTROL_0_rising_edge_threshold(CH3_CONTROL_0_rising_edge_threshold),
        .CH3_CONTROL_0_set_config(CH3_CONTROL_0_set_config),
        .CH3_CONTROL_0_stop(CH3_CONTROL_0_stop),
        .CH3_CONTROL_0_trigger_type(CH3_CONTROL_0_trigger_type),
        .CH4_CONTROL_0_acquire_mode(CH4_CONTROL_0_acquire_mode),
        .CH4_CONTROL_0_falling_edge_threshold(CH4_CONTROL_0_falling_edge_threshold),
        .CH4_CONTROL_0_h_gain_baseline(CH4_CONTROL_0_h_gain_baseline),
        .CH4_CONTROL_0_l_gain_baseline(CH4_CONTROL_0_l_gain_baseline),
        .CH4_CONTROL_0_max_trigger_length(CH4_CONTROL_0_max_trigger_length),
        .CH4_CONTROL_0_post_acquisition_length(CH4_CONTROL_0_post_acquisition_length),
        .CH4_CONTROL_0_pre_acquisition_length(CH4_CONTROL_0_pre_acquisition_length),
        .CH4_CONTROL_0_rising_edge_threshold(CH4_CONTROL_0_rising_edge_threshold),
        .CH4_CONTROL_0_set_config(CH4_CONTROL_0_set_config),
        .CH4_CONTROL_0_stop(CH4_CONTROL_0_stop),
        .CH4_CONTROL_0_trigger_type(CH4_CONTROL_0_trigger_type),
        .CH5_CONTROL_0_acquire_mode(CH5_CONTROL_0_acquire_mode),
        .CH5_CONTROL_0_falling_edge_threshold(CH5_CONTROL_0_falling_edge_threshold),
        .CH5_CONTROL_0_h_gain_baseline(CH5_CONTROL_0_h_gain_baseline),
        .CH5_CONTROL_0_l_gain_baseline(CH5_CONTROL_0_l_gain_baseline),
        .CH5_CONTROL_0_max_trigger_length(CH5_CONTROL_0_max_trigger_length),
        .CH5_CONTROL_0_post_acquisition_length(CH5_CONTROL_0_post_acquisition_length),
        .CH5_CONTROL_0_pre_acquisition_length(CH5_CONTROL_0_pre_acquisition_length),
        .CH5_CONTROL_0_rising_edge_threshold(CH5_CONTROL_0_rising_edge_threshold),
        .CH5_CONTROL_0_set_config(CH5_CONTROL_0_set_config),
        .CH5_CONTROL_0_stop(CH5_CONTROL_0_stop),
        .CH5_CONTROL_0_trigger_type(CH5_CONTROL_0_trigger_type),
        .CH6_CONTROL_0_acquire_mode(CH6_CONTROL_0_acquire_mode),
        .CH6_CONTROL_0_falling_edge_threshold(CH6_CONTROL_0_falling_edge_threshold),
        .CH6_CONTROL_0_h_gain_baseline(CH6_CONTROL_0_h_gain_baseline),
        .CH6_CONTROL_0_l_gain_baseline(CH6_CONTROL_0_l_gain_baseline),
        .CH6_CONTROL_0_max_trigger_length(CH6_CONTROL_0_max_trigger_length),
        .CH6_CONTROL_0_post_acquisition_length(CH6_CONTROL_0_post_acquisition_length),
        .CH6_CONTROL_0_pre_acquisition_length(CH6_CONTROL_0_pre_acquisition_length),
        .CH6_CONTROL_0_rising_edge_threshold(CH6_CONTROL_0_rising_edge_threshold),
        .CH6_CONTROL_0_set_config(CH6_CONTROL_0_set_config),
        .CH6_CONTROL_0_stop(CH6_CONTROL_0_stop),
        .CH6_CONTROL_0_trigger_type(CH6_CONTROL_0_trigger_type),
        .CH7_CONTROL_0_acquire_mode(CH7_CONTROL_0_acquire_mode),
        .CH7_CONTROL_0_falling_edge_threshold(CH7_CONTROL_0_falling_edge_threshold),
        .CH7_CONTROL_0_h_gain_baseline(CH7_CONTROL_0_h_gain_baseline),
        .CH7_CONTROL_0_l_gain_baseline(CH7_CONTROL_0_l_gain_baseline),
        .CH7_CONTROL_0_max_trigger_length(CH7_CONTROL_0_max_trigger_length),
        .CH7_CONTROL_0_post_acquisition_length(CH7_CONTROL_0_post_acquisition_length),
        .CH7_CONTROL_0_pre_acquisition_length(CH7_CONTROL_0_pre_acquisition_length),
        .CH7_CONTROL_0_rising_edge_threshold(CH7_CONTROL_0_rising_edge_threshold),
        .CH7_CONTROL_0_set_config(CH7_CONTROL_0_set_config),
        .CH7_CONTROL_0_stop(CH7_CONTROL_0_stop),
        .CH7_CONTROL_0_trigger_type(CH7_CONTROL_0_trigger_type),
        .CH8_CONTROL_0_acquire_mode(CH8_CONTROL_0_acquire_mode),
        .CH8_CONTROL_0_falling_edge_threshold(CH8_CONTROL_0_falling_edge_threshold),
        .CH8_CONTROL_0_h_gain_baseline(CH8_CONTROL_0_h_gain_baseline),
        .CH8_CONTROL_0_l_gain_baseline(CH8_CONTROL_0_l_gain_baseline),
        .CH8_CONTROL_0_max_trigger_length(CH8_CONTROL_0_max_trigger_length),
        .CH8_CONTROL_0_post_acquisition_length(CH8_CONTROL_0_post_acquisition_length),
        .CH8_CONTROL_0_pre_acquisition_length(CH8_CONTROL_0_pre_acquisition_length),
        .CH8_CONTROL_0_rising_edge_threshold(CH8_CONTROL_0_rising_edge_threshold),
        .CH8_CONTROL_0_set_config(CH8_CONTROL_0_set_config),
        .CH8_CONTROL_0_stop(CH8_CONTROL_0_stop),
        .CH8_CONTROL_0_trigger_type(CH8_CONTROL_0_trigger_type),
        .CH9_CONTROL_0_acquire_mode(CH9_CONTROL_0_acquire_mode),
        .CH9_CONTROL_0_falling_edge_threshold(CH9_CONTROL_0_falling_edge_threshold),
        .CH9_CONTROL_0_h_gain_baseline(CH9_CONTROL_0_h_gain_baseline),
        .CH9_CONTROL_0_l_gain_baseline(CH9_CONTROL_0_l_gain_baseline),
        .CH9_CONTROL_0_max_trigger_length(CH9_CONTROL_0_max_trigger_length),
        .CH9_CONTROL_0_post_acquisition_length(CH9_CONTROL_0_post_acquisition_length),
        .CH9_CONTROL_0_pre_acquisition_length(CH9_CONTROL_0_pre_acquisition_length),
        .CH9_CONTROL_0_rising_edge_threshold(CH9_CONTROL_0_rising_edge_threshold),
        .CH9_CONTROL_0_set_config(CH9_CONTROL_0_set_config),
        .CH9_CONTROL_0_stop(CH9_CONTROL_0_stop),
        .CH9_CONTROL_0_trigger_type(CH9_CONTROL_0_trigger_type),
        .CLK(CLK),
        .EXT_RESET(EXT_RESET));
endmodule
