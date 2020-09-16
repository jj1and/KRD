//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1.3 (win64) Build 2644227 Wed Sep  4 09:45:24 MDT 2019
//Date        : Sun Jul 26 18:46:51 2020
//Host        : Nakamura running 64-bit major release  (build 9200)
//Command     : generate_target fee_cfg_sim_wrapper.bd
//Design      : fee_cfg_sim_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module fee_cfg_sim_wrapper
   (ACQUIRE_MODE_0,
    CLK,
    EXT_RESET,
    FALLING_EDGE_THRESHOLD_0,
    H_GAIN_BASELINE_0,
    L_GAIN_BASELINE_0,
    MAX_TRIGGER_LENGTH_0,
    POST_ACQUISITION_LENGTH_0,
    PRE_ACQUISITION_LENGTH_0,
    RISING_EDGE_THRESHOLD_0,
    SET_CONFIG_0,
    STOP_0);
  output [0:0]ACQUIRE_MODE_0;
  input CLK;
  input EXT_RESET;
  output [15:0]FALLING_EDGE_THRESHOLD_0;
  output [12:0]H_GAIN_BASELINE_0;
  output [15:0]L_GAIN_BASELINE_0;
  output [15:0]MAX_TRIGGER_LENGTH_0;
  output [1:0]POST_ACQUISITION_LENGTH_0;
  output [1:0]PRE_ACQUISITION_LENGTH_0;
  output [15:0]RISING_EDGE_THRESHOLD_0;
  output [0:0]SET_CONFIG_0;
  output [0:0]STOP_0;

  wire [0:0]ACQUIRE_MODE_0;
  wire CLK;
  wire EXT_RESET;
  wire [15:0]FALLING_EDGE_THRESHOLD_0;
  wire [12:0]H_GAIN_BASELINE_0;
  wire [15:0]L_GAIN_BASELINE_0;
  wire [15:0]MAX_TRIGGER_LENGTH_0;
  wire [1:0]POST_ACQUISITION_LENGTH_0;
  wire [1:0]PRE_ACQUISITION_LENGTH_0;
  wire [15:0]RISING_EDGE_THRESHOLD_0;
  wire [0:0]SET_CONFIG_0;
  wire [0:0]STOP_0;

  fee_cfg_sim fee_cfg_sim_i
       (.ACQUIRE_MODE_0(ACQUIRE_MODE_0),
        .CLK(CLK),
        .EXT_RESET(EXT_RESET),
        .FALLING_EDGE_THRESHOLD_0(FALLING_EDGE_THRESHOLD_0),
        .H_GAIN_BASELINE_0(H_GAIN_BASELINE_0),
        .L_GAIN_BASELINE_0(L_GAIN_BASELINE_0),
        .MAX_TRIGGER_LENGTH_0(MAX_TRIGGER_LENGTH_0),
        .POST_ACQUISITION_LENGTH_0(POST_ACQUISITION_LENGTH_0),
        .PRE_ACQUISITION_LENGTH_0(PRE_ACQUISITION_LENGTH_0),
        .RISING_EDGE_THRESHOLD_0(RISING_EDGE_THRESHOLD_0),
        .SET_CONFIG_0(SET_CONFIG_0),
        .STOP_0(STOP_0));
endmodule
