	/* This module is based on Xilinx AXI peripheral IP preset */
	`timescale 1 ps / 1 ps
	`include "trigger_config.vh"

	module trigger_configrator # (
		// Users to add parameters here
		parameter integer MAX_PRE_ACQUISITION_LENGTH = 2,
		parameter integer MAX_POST_ACQUISITION_LENGTH = 2,
		// User parameters ends

		// Width of ID for for write address, write data, read address and read data
		parameter integer C_S_AXI_ID_WIDTH	= 1,
		// Width of S_AXI data bus
		parameter integer C_S_AXI_DATA_WIDTH	= 32,
		// Width of S_AXI address bus
		parameter integer C_S_AXI_ADDR_WIDTH	= 32,
		// Width of optional user defined signal in write address channel
		parameter integer C_S_AXI_AWUSER_WIDTH	= 0,
		// Width of optional user defined signal in read address channel
		parameter integer C_S_AXI_ARUSER_WIDTH	= 0,
		// Width of optional user defined signal in write data channel
		parameter integer C_S_AXI_WUSER_WIDTH	= 0,
		// Width of optional user defined signal in read data channel
		parameter integer C_S_AXI_RUSER_WIDTH	= 0,
		// Width of optional user defined signal in write response channel
		parameter integer C_S_AXI_BUSER_WIDTH	= 0

	)(

		output wire [16-1:0] MAX_TRIGGER_LENGTH,
		output wire SET_CONFIG,
		output wire RUNNING,
		// Users to add ports here
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH0_CONTROL STOP" *)
		output wire STOP_0,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH0_CONTROL ACQUIRE_MODE" *)
		output wire [2-1:0] ACQUIRE_MODE_0,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH0_CONTROL TRIGGER_TYPE" *)
		output wire [4-1:0] TRIGGER_TYPE_0,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH0_CONTROL RISING_EDGE_THRESHOLD" *)
		output wire signed [`SAMPLE_WIDTH-1:0] RISING_EDGE_THRESHOLD_0,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH0_CONTROL FALLING_EDGE_THRESHOLD" *)
		output wire signed [`SAMPLE_WIDTH-1:0] FALLING_EDGE_THRESHOLD_0,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH0_CONTROL H_GAIN_BASELINE" *)
		output wire signed [(`ADC_RESOLUTION_WIDTH+1)-1:0] H_GAIN_BASELINE_0,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH0_CONTROL L_GAIN_BASELINE" *)
		output wire signed [`SAMPLE_WIDTH-1:0] L_GAIN_BASELINE_0,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH0_CONTROL PRE_ACQUISITION_LENGTH" *)
		output wire [($clog2(MAX_PRE_ACQUISITION_LENGTH)+1)-1:0] PRE_ACQUISITION_LENGTH_0,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH0_CONTROL POST_ACQUISITION_LENGTH" *)
		output wire [($clog2(MAX_POST_ACQUISITION_LENGTH)+1)-1:0] POST_ACQUISITION_LENGTH_0,


		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH1_CONTROL STOP" *)
		output wire STOP_1,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH1_CONTROL ACQUIRE_MODE" *)
		output wire [2-1:0] ACQUIRE_MODE_1,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH1_CONTROL TRIGGER_TYPE" *)
		output wire [4-1:0] TRIGGER_TYPE_1,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH1_CONTROL RISING_EDGE_THRESHOLD" *)
		output wire signed [`SAMPLE_WIDTH-1:0] RISING_EDGE_THRESHOLD_1,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH1_CONTROL FALLING_EDGE_THRESHOLD" *)
		output wire signed [`SAMPLE_WIDTH-1:0] FALLING_EDGE_THRESHOLD_1,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH1_CONTROL H_GAIN_BASELINE" *)
		output wire signed [(`ADC_RESOLUTION_WIDTH+1)-1:0] H_GAIN_BASELINE_1,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH1_CONTROL L_GAIN_BASELINE" *)
		output wire signed [`SAMPLE_WIDTH-1:0] L_GAIN_BASELINE_1,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH1_CONTROL PRE_ACQUISITION_LENGTH" *)
		output wire [($clog2(MAX_PRE_ACQUISITION_LENGTH)+1)-1:0] PRE_ACQUISITION_LENGTH_1,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH1_CONTROL POST_ACQUISITION_LENGTH" *)
		output wire [($clog2(MAX_POST_ACQUISITION_LENGTH)+1)-1:0] POST_ACQUISITION_LENGTH_1,

		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH2_CONTROL STOP" *)
		output wire STOP_2,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH2_CONTROL ACQUIRE_MODE" *)
		output wire [2-1:0] ACQUIRE_MODE_2,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH2_CONTROL TRIGGER_TYPE" *)
		output wire [4-1:0] TRIGGER_TYPE_2,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH2_CONTROL RISING_EDGE_THRESHOLD" *)
		output wire signed [`SAMPLE_WIDTH-1:0] RISING_EDGE_THRESHOLD_2,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH2_CONTROL FALLING_EDGE_THRESHOLD" *)
		output wire signed [`SAMPLE_WIDTH-1:0] FALLING_EDGE_THRESHOLD_2,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH2_CONTROL H_GAIN_BASELINE" *)
		output wire signed [(`ADC_RESOLUTION_WIDTH+1)-1:0] H_GAIN_BASELINE_2,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH2_CONTROL L_GAIN_BASELINE" *)
		output wire signed [`SAMPLE_WIDTH-1:0] L_GAIN_BASELINE_2,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH2_CONTROL PRE_ACQUISITION_LENGTH" *)
		output wire [($clog2(MAX_PRE_ACQUISITION_LENGTH)+1)-1:0] PRE_ACQUISITION_LENGTH_2,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH2_CONTROL POST_ACQUISITION_LENGTH" *)
		output wire [($clog2(MAX_POST_ACQUISITION_LENGTH)+1)-1:0] POST_ACQUISITION_LENGTH_2,
  
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH3_CONTROL STOP" *)
		output wire STOP_3,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH3_CONTROL ACQUIRE_MODE" *)
		output wire [2-1:0] ACQUIRE_MODE_3,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH3_CONTROL TRIGGER_TYPE" *)
		output wire [4-1:0] TRIGGER_TYPE_3,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH3_CONTROL RISING_EDGE_THRESHOLD" *)
		output wire signed [`SAMPLE_WIDTH-1:0] RISING_EDGE_THRESHOLD_3,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH3_CONTROL FALLING_EDGE_THRESHOLD" *)
		output wire signed [`SAMPLE_WIDTH-1:0] FALLING_EDGE_THRESHOLD_3,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH3_CONTROL H_GAIN_BASELINE" *)
		output wire signed [(`ADC_RESOLUTION_WIDTH+1)-1:0] H_GAIN_BASELINE_3,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH3_CONTROL L_GAIN_BASELINE" *)
		output wire signed [`SAMPLE_WIDTH-1:0] L_GAIN_BASELINE_3,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH3_CONTROL PRE_ACQUISITION_LENGTH" *)
		output wire [($clog2(MAX_PRE_ACQUISITION_LENGTH)+1)-1:0] PRE_ACQUISITION_LENGTH_3,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH3_CONTROL POST_ACQUISITION_LENGTH" *)
		output wire [($clog2(MAX_POST_ACQUISITION_LENGTH)+1)-1:0] POST_ACQUISITION_LENGTH_3,

		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH4_CONTROL STOP" *)
		output wire STOP_4,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH4_CONTROL ACQUIRE_MODE" *)
		output wire [2-1:0] ACQUIRE_MODE_4,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH4_CONTROL TRIGGER_TYPE" *)
		output wire [4-1:0] TRIGGER_TYPE_4,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH4_CONTROL RISING_EDGE_THRESHOLD" *)
		output wire signed [`SAMPLE_WIDTH-1:0] RISING_EDGE_THRESHOLD_4,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH4_CONTROL FALLING_EDGE_THRESHOLD" *)
		output wire signed [`SAMPLE_WIDTH-1:0] FALLING_EDGE_THRESHOLD_4,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH4_CONTROL H_GAIN_BASELINE" *)
		output wire signed [(`ADC_RESOLUTION_WIDTH+1)-1:0] H_GAIN_BASELINE_4,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH4_CONTROL L_GAIN_BASELINE" *)
		output wire signed [`SAMPLE_WIDTH-1:0] L_GAIN_BASELINE_4,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH4_CONTROL PRE_ACQUISITION_LENGTH" *)
		output wire [($clog2(MAX_PRE_ACQUISITION_LENGTH)+1)-1:0] PRE_ACQUISITION_LENGTH_4,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH4_CONTROL POST_ACQUISITION_LENGTH" *)
		output wire [($clog2(MAX_POST_ACQUISITION_LENGTH)+1)-1:0] POST_ACQUISITION_LENGTH_4,

		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH5_CONTROL STOP" *)
		output wire STOP_5,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH5_CONTROL ACQUIRE_MODE" *)
		output wire [2-1:0] ACQUIRE_MODE_5,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH5_CONTROL TRIGGER_TYPE" *)
		output wire [4-1:0] TRIGGER_TYPE_5,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH5_CONTROL RISING_EDGE_THRESHOLD" *)
		output wire signed [`SAMPLE_WIDTH-1:0] RISING_EDGE_THRESHOLD_5,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH5_CONTROL FALLING_EDGE_THRESHOLD" *)
		output wire signed [`SAMPLE_WIDTH-1:0] FALLING_EDGE_THRESHOLD_5,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH5_CONTROL H_GAIN_BASELINE" *)
		output wire signed [(`ADC_RESOLUTION_WIDTH+1)-1:0] H_GAIN_BASELINE_5,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH5_CONTROL L_GAIN_BASELINE" *)
		output wire signed [`SAMPLE_WIDTH-1:0] L_GAIN_BASELINE_5,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH5_CONTROL PRE_ACQUISITION_LENGTH" *)
		output wire [($clog2(MAX_PRE_ACQUISITION_LENGTH)+1)-1:0] PRE_ACQUISITION_LENGTH_5,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH5_CONTROL POST_ACQUISITION_LENGTH" *)
		output wire [($clog2(MAX_POST_ACQUISITION_LENGTH)+1)-1:0] POST_ACQUISITION_LENGTH_5,

		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH6_CONTROL STOP" *)
		output wire STOP_6,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH6_CONTROL ACQUIRE_MODE" *)
		output wire [2-1:0] ACQUIRE_MODE_6,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH6_CONTROL TRIGGER_TYPE" *)
		output wire [4-1:0] TRIGGER_TYPE_6,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH6_CONTROL RISING_EDGE_THRESHOLD" *)
		output wire signed [`SAMPLE_WIDTH-1:0] RISING_EDGE_THRESHOLD_6,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH6_CONTROL FALLING_EDGE_THRESHOLD" *)
		output wire signed [`SAMPLE_WIDTH-1:0] FALLING_EDGE_THRESHOLD_6,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH6_CONTROL H_GAIN_BASELINE" *)
		output wire signed [(`ADC_RESOLUTION_WIDTH+1)-1:0] H_GAIN_BASELINE_6,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH6_CONTROL L_GAIN_BASELINE" *)
		output wire signed [`SAMPLE_WIDTH-1:0] L_GAIN_BASELINE_6,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH6_CONTROL PRE_ACQUISITION_LENGTH" *)
		output wire [($clog2(MAX_PRE_ACQUISITION_LENGTH)+1)-1:0] PRE_ACQUISITION_LENGTH_6,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH6_CONTROL POST_ACQUISITION_LENGTH" *)
		output wire [($clog2(MAX_POST_ACQUISITION_LENGTH)+1)-1:0] POST_ACQUISITION_LENGTH_6,

		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH7_CONTROL STOP" *)
		output wire STOP_7,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH7_CONTROL ACQUIRE_MODE" *)
		output wire [2-1:0] ACQUIRE_MODE_7,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH7_CONTROL TRIGGER_TYPE" *)
		output wire [4-1:0] TRIGGER_TYPE_7,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH7_CONTROL RISING_EDGE_THRESHOLD" *)
		output wire signed [`SAMPLE_WIDTH-1:0] RISING_EDGE_THRESHOLD_7,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH7_CONTROL FALLING_EDGE_THRESHOLD" *)
		output wire signed [`SAMPLE_WIDTH-1:0] FALLING_EDGE_THRESHOLD_7,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH7_CONTROL H_GAIN_BASELINE" *)
		output wire signed [(`ADC_RESOLUTION_WIDTH+1)-1:0] H_GAIN_BASELINE_7,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH7_CONTROL L_GAIN_BASELINE" *)
		output wire signed [`SAMPLE_WIDTH-1:0] L_GAIN_BASELINE_7,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH7_CONTROL PRE_ACQUISITION_LENGTH" *)
		output wire [($clog2(MAX_PRE_ACQUISITION_LENGTH)+1)-1:0] PRE_ACQUISITION_LENGTH_7,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH7_CONTROL POST_ACQUISITION_LENGTH" *)
		output wire [($clog2(MAX_POST_ACQUISITION_LENGTH)+1)-1:0] POST_ACQUISITION_LENGTH_7,                         

		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH8_CONTROL STOP" *)
		output wire STOP_8,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH8_CONTROL ACQUIRE_MODE" *)
		output wire [2-1:0] ACQUIRE_MODE_8,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH8_CONTROL TRIGGER_TYPE" *)
		output wire [4-1:0] TRIGGER_TYPE_8,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH8_CONTROL RISING_EDGE_THRESHOLD" *)
		output wire signed [`SAMPLE_WIDTH-1:0] RISING_EDGE_THRESHOLD_8,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH8_CONTROL FALLING_EDGE_THRESHOLD" *)
		output wire signed [`SAMPLE_WIDTH-1:0] FALLING_EDGE_THRESHOLD_8,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH8_CONTROL H_GAIN_BASELINE" *)
		output wire signed [(`ADC_RESOLUTION_WIDTH+1)-1:0] H_GAIN_BASELINE_8,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH8_CONTROL L_GAIN_BASELINE" *)
		output wire signed [`SAMPLE_WIDTH-1:0] L_GAIN_BASELINE_8,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH8_CONTROL PRE_ACQUISITION_LENGTH" *)
		output wire [($clog2(MAX_PRE_ACQUISITION_LENGTH)+1)-1:0] PRE_ACQUISITION_LENGTH_8,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH8_CONTROL POST_ACQUISITION_LENGTH" *)
		output wire [($clog2(MAX_POST_ACQUISITION_LENGTH)+1)-1:0] POST_ACQUISITION_LENGTH_8,

		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH9_CONTROL STOP" *)
		output wire STOP_9,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH9_CONTROL ACQUIRE_MODE" *)
		output wire [2-1:0] ACQUIRE_MODE_9,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH9_CONTROL TRIGGER_TYPE" *)
		output wire [4-1:0] TRIGGER_TYPE_9,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH9_CONTROL RISING_EDGE_THRESHOLD" *)
		output wire signed [`SAMPLE_WIDTH-1:0] RISING_EDGE_THRESHOLD_9,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH9_CONTROL FALLING_EDGE_THRESHOLD" *)
		output wire signed [`SAMPLE_WIDTH-1:0] FALLING_EDGE_THRESHOLD_9,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH9_CONTROL H_GAIN_BASELINE" *)
		output wire signed [(`ADC_RESOLUTION_WIDTH+1)-1:0] H_GAIN_BASELINE_9,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH9_CONTROL L_GAIN_BASELINE" *)
		output wire signed [`SAMPLE_WIDTH-1:0] L_GAIN_BASELINE_9,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH9_CONTROL PRE_ACQUISITION_LENGTH" *)
		output wire [($clog2(MAX_PRE_ACQUISITION_LENGTH)+1)-1:0] PRE_ACQUISITION_LENGTH_9,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH9_CONTROL POST_ACQUISITION_LENGTH" *)
		output wire [($clog2(MAX_POST_ACQUISITION_LENGTH)+1)-1:0] POST_ACQUISITION_LENGTH_9,   

		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH10_CONTROL STOP" *)
		output wire STOP_10,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH10_CONTROL ACQUIRE_MODE" *)
		output wire [2-1:0] ACQUIRE_MODE_10,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH10_CONTROL TRIGGER_TYPE" *)
		output wire [4-1:0] TRIGGER_TYPE_10,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH10_CONTROL RISING_EDGE_THRESHOLD" *)
		output wire signed [`SAMPLE_WIDTH-1:0] RISING_EDGE_THRESHOLD_10,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH10_CONTROL FALLING_EDGE_THRESHOLD" *)
		output wire signed [`SAMPLE_WIDTH-1:0] FALLING_EDGE_THRESHOLD_10,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH10_CONTROL H_GAIN_BASELINE" *)
		output wire signed [(`ADC_RESOLUTION_WIDTH+1)-1:0] H_GAIN_BASELINE_10,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH10_CONTROL L_GAIN_BASELINE" *)
		output wire signed [`SAMPLE_WIDTH-1:0] L_GAIN_BASELINE_10,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH10_CONTROL PRE_ACQUISITION_LENGTH" *)
		output wire [($clog2(MAX_PRE_ACQUISITION_LENGTH)+1)-1:0] PRE_ACQUISITION_LENGTH_10,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH10_CONTROL POST_ACQUISITION_LENGTH" *)
		output wire [($clog2(MAX_POST_ACQUISITION_LENGTH)+1)-1:0] POST_ACQUISITION_LENGTH_10,

		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH11_CONTROL STOP" *)
		output wire STOP_11,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH11_CONTROL ACQUIRE_MODE" *)
		output wire [2-1:0] ACQUIRE_MODE_11,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH11_CONTROL TRIGGER_TYPE" *)
		output wire [4-1:0] TRIGGER_TYPE_11,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH11_CONTROL RISING_EDGE_THRESHOLD" *)
		output wire signed [`SAMPLE_WIDTH-1:0] RISING_EDGE_THRESHOLD_11,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH11_CONTROL FALLING_EDGE_THRESHOLD" *)
		output wire signed [`SAMPLE_WIDTH-1:0] FALLING_EDGE_THRESHOLD_11,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH11_CONTROL H_GAIN_BASELINE" *)
		output wire signed [(`ADC_RESOLUTION_WIDTH+1)-1:0] H_GAIN_BASELINE_11,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH11_CONTROL L_GAIN_BASELINE" *)
		output wire signed [`SAMPLE_WIDTH-1:0] L_GAIN_BASELINE_11,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH11_CONTROL PRE_ACQUISITION_LENGTH" *)
		output wire [($clog2(MAX_PRE_ACQUISITION_LENGTH)+1)-1:0] PRE_ACQUISITION_LENGTH_11,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH11_CONTROL POST_ACQUISITION_LENGTH" *)
		output wire [($clog2(MAX_POST_ACQUISITION_LENGTH)+1)-1:0] POST_ACQUISITION_LENGTH_11,
     

		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH12_CONTROL STOP" *)
		output wire STOP_12,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH12_CONTROL ACQUIRE_MODE" *)
		output wire [2-1:0] ACQUIRE_MODE_12,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH12_CONTROL TRIGGER_TYPE" *)
		output wire [4-1:0] TRIGGER_TYPE_12,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH12_CONTROL RISING_EDGE_THRESHOLD" *)
		output wire signed [`SAMPLE_WIDTH-1:0] RISING_EDGE_THRESHOLD_12,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH12_CONTROL FALLING_EDGE_THRESHOLD" *)
		output wire signed [`SAMPLE_WIDTH-1:0] FALLING_EDGE_THRESHOLD_12,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH12_CONTROL H_GAIN_BASELINE" *)
		output wire signed [(`ADC_RESOLUTION_WIDTH+1)-1:0] H_GAIN_BASELINE_12,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH12_CONTROL L_GAIN_BASELINE" *)
		output wire signed [`SAMPLE_WIDTH-1:0] L_GAIN_BASELINE_12,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH12_CONTROL PRE_ACQUISITION_LENGTH" *)
		output wire [($clog2(MAX_PRE_ACQUISITION_LENGTH)+1)-1:0] PRE_ACQUISITION_LENGTH_12,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH12_CONTROL POST_ACQUISITION_LENGTH" *)
		output wire [($clog2(MAX_POST_ACQUISITION_LENGTH)+1)-1:0] POST_ACQUISITION_LENGTH_12,

		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH13_CONTROL STOP" *)
		output wire STOP_13,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH13_CONTROL ACQUIRE_MODE" *)
		output wire [2-1:0] ACQUIRE_MODE_13,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH13_CONTROL TRIGGER_TYPE" *)
		output wire [4-1:0] TRIGGER_TYPE_13,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH13_CONTROL RISING_EDGE_THRESHOLD" *)
		output wire signed [`SAMPLE_WIDTH-1:0] RISING_EDGE_THRESHOLD_13,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH13_CONTROL FALLING_EDGE_THRESHOLD" *)
		output wire signed [`SAMPLE_WIDTH-1:0] FALLING_EDGE_THRESHOLD_13,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH13_CONTROL H_GAIN_BASELINE" *)
		output wire signed [(`ADC_RESOLUTION_WIDTH+1)-1:0] H_GAIN_BASELINE_13,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH13_CONTROL L_GAIN_BASELINE" *)
		output wire signed [`SAMPLE_WIDTH-1:0] L_GAIN_BASELINE_13,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH13_CONTROL PRE_ACQUISITION_LENGTH" *)
		output wire [($clog2(MAX_PRE_ACQUISITION_LENGTH)+1)-1:0] PRE_ACQUISITION_LENGTH_13,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH13_CONTROL POST_ACQUISITION_LENGTH" *)
		output wire [($clog2(MAX_POST_ACQUISITION_LENGTH)+1)-1:0] POST_ACQUISITION_LENGTH_13,    

		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH14_CONTROL STOP" *)
		output wire STOP_14,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH14_CONTROL ACQUIRE_MODE" *)
		output wire [2-1:0] ACQUIRE_MODE_14,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH14_CONTROL TRIGGER_TYPE" *)
		output wire [4-1:0] TRIGGER_TYPE_14,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH14_CONTROL RISING_EDGE_THRESHOLD" *)
		output wire signed [`SAMPLE_WIDTH-1:0] RISING_EDGE_THRESHOLD_14,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH14_CONTROL FALLING_EDGE_THRESHOLD" *)
		output wire signed [`SAMPLE_WIDTH-1:0] FALLING_EDGE_THRESHOLD_14,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH14_CONTROL H_GAIN_BASELINE" *)
		output wire signed [(`ADC_RESOLUTION_WIDTH+1)-1:0] H_GAIN_BASELINE_14,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH14_CONTROL L_GAIN_BASELINE" *)
		output wire signed [`SAMPLE_WIDTH-1:0] L_GAIN_BASELINE_14,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH14_CONTROL PRE_ACQUISITION_LENGTH" *)
		output wire [($clog2(MAX_PRE_ACQUISITION_LENGTH)+1)-1:0] PRE_ACQUISITION_LENGTH_14,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH14_CONTROL POST_ACQUISITION_LENGTH" *)
		output wire [($clog2(MAX_POST_ACQUISITION_LENGTH)+1)-1:0] POST_ACQUISITION_LENGTH_14,

		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH15_CONTROL STOP" *)
		output wire STOP_15,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH15_CONTROL ACQUIRE_MODE" *)
		output wire [2-1:0] ACQUIRE_MODE_15,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH15_CONTROL TRIGGER_TYPE" *)
		output wire [4-1:0] TRIGGER_TYPE_15,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH15_CONTROL RISING_EDGE_THRESHOLD" *)
		output wire signed [`SAMPLE_WIDTH-1:0] RISING_EDGE_THRESHOLD_15,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH15_CONTROL FALLING_EDGE_THRESHOLD" *)
		output wire signed [`SAMPLE_WIDTH-1:0] FALLING_EDGE_THRESHOLD_15,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH15_CONTROL H_GAIN_BASELINE" *)
		output wire signed [(`ADC_RESOLUTION_WIDTH+1)-1:0] H_GAIN_BASELINE_15,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH15_CONTROL L_GAIN_BASELINE" *)
		output wire signed [`SAMPLE_WIDTH-1:0] L_GAIN_BASELINE_15,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH15_CONTROL PRE_ACQUISITION_LENGTH" *)
		output wire [($clog2(MAX_PRE_ACQUISITION_LENGTH)+1)-1:0] PRE_ACQUISITION_LENGTH_15,
		(* X_INTERFACE_INFO = "awa.tohoku.ac.jp:mogura2:trigger_control:1.1 CH15_CONTROL POST_ACQUISITION_LENGTH" *)
		output wire [($clog2(MAX_POST_ACQUISITION_LENGTH)+1)-1:0] POST_ACQUISITION_LENGTH_15,
        

		// User ports ends
		// Do not modify the ports beyond this line

		// Global Clock Signal
		input wire  S_AXI_ACLK,
		// Global Reset Signal. This Signal is Active LOW
		input wire  S_AXI_ARESETN,
		// Write Address ID
		input wire [C_S_AXI_ID_WIDTH-1 : 0] S_AXI_AWID,
		// Write address
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
		// Burst length. The burst length gives the exact number of transfers in a burst
		input wire [7 : 0] S_AXI_AWLEN,
		// Burst size. This signal indicates the size of each transfer in the burst
		input wire [2 : 0] S_AXI_AWSIZE,
		// Burst type. The burst type and the size information, 
		// determine how the address for each transfer within the burst is calculated.
		input wire [1 : 0] S_AXI_AWBURST,
		// Lock type. Provides additional information about the
		// atomic characteristics of the transfer.
		input wire  S_AXI_AWLOCK,
		// Memory type. This signal indicates how transactions
		// are required to progress through a system.
		input wire [3 : 0] S_AXI_AWCACHE,
		// Protection type. This signal indicates the privilege
		// and security level of the transaction, and whether
		// the transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_AWPROT,
		// Quality of Service, QoS identifier sent for each
		// write transaction.
		input wire [3 : 0] S_AXI_AWQOS,
		// Region identifier. Permits a single physical interface
		// on a slave to be used for multiple logical interfaces.
		input wire [3 : 0] S_AXI_AWREGION,
		// Optional User-defined signal in the write address channel.
		input wire [C_S_AXI_AWUSER_WIDTH-1 : 0] S_AXI_AWUSER,
		// Write address valid. This signal indicates that
		// the channel is signaling valid write address and
		// control information.
		input wire  S_AXI_AWVALID,
		// Write address ready. This signal indicates that
		// the slave is ready to accept an address and associated
		// control signals.
		output wire  S_AXI_AWREADY,
		// Write Data
		input wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
		// Write strobes. This signal indicates which byte
		// lanes hold valid data. There is one write strobe
		// bit for each eight bits of the write data bus.
		input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
		// Write last. This signal indicates the last transfer
		// in a write burst.
		input wire  S_AXI_WLAST,
		// Optional User-defined signal in the write data channel.
		input wire [C_S_AXI_WUSER_WIDTH-1 : 0] S_AXI_WUSER,
		// Write valid. This signal indicates that valid write
		// data and strobes are available.
		input wire  S_AXI_WVALID,
		// Write ready. This signal indicates that the slave
		// can accept the write data.
		output wire  S_AXI_WREADY,
		// Response ID tag. This signal is the ID tag of the
		// write response.
		output wire [C_S_AXI_ID_WIDTH-1 : 0] S_AXI_BID,
		// Write response. This signal indicates the status
		// of the write transaction.
		output wire [1 : 0] S_AXI_BRESP,
		// Optional User-defined signal in the write response channel.
		output wire [C_S_AXI_BUSER_WIDTH-1 : 0] S_AXI_BUSER,
		// Write response valid. This signal indicates that the
		// channel is signaling a valid write response.
		output wire  S_AXI_BVALID,
		// Response ready. This signal indicates that the master
		// can accept a write response.
		input wire  S_AXI_BREADY,
		// Read address ID. This signal is the identification
		// tag for the read address group of signals.
		input wire [C_S_AXI_ID_WIDTH-1 : 0] S_AXI_ARID,
		// Read address. This signal indicates the initial
		// address of a read burst transaction.
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
		// Burst length. The burst length gives the exact number of transfers in a burst
		input wire [7 : 0] S_AXI_ARLEN,
		// Burst size. This signal indicates the size of each transfer in the burst
		input wire [2 : 0] S_AXI_ARSIZE,
		// Burst type. The burst type and the size information, 
		// determine how the address for each transfer within the burst is calculated.
		input wire [1 : 0] S_AXI_ARBURST,
		// Lock type. Provides additional information about the
		// atomic characteristics of the transfer.
		input wire  S_AXI_ARLOCK,
		// Memory type. This signal indicates how transactions
		// are required to progress through a system.
		input wire [3 : 0] S_AXI_ARCACHE,
		// Protection type. This signal indicates the privilege
		// and security level of the transaction, and whether
		// the transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_ARPROT,
		// Quality of Service, QoS identifier sent for each
		// read transaction.
		input wire [3 : 0] S_AXI_ARQOS,
		// Region identifier. Permits a single physical interface
		// on a slave to be used for multiple logical interfaces.
		input wire [3 : 0] S_AXI_ARREGION,
		// Optional User-defined signal in the read address channel.
		input wire [C_S_AXI_ARUSER_WIDTH-1 : 0] S_AXI_ARUSER,
		// Write address valid. This signal indicates that
		// the channel is signaling valid read address and
		// control information.
		input wire  S_AXI_ARVALID,
		// Read address ready. This signal indicates that
		// the slave is ready to accept an address and associated
		// control signals.
		output wire  S_AXI_ARREADY,
		// Read ID tag. This signal is the identification tag
		// for the read data group of signals generated by the slave.
		output wire [C_S_AXI_ID_WIDTH-1 : 0] S_AXI_RID,
		// Read Data
		output wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
		// Read response. This signal indicates the status of
		// the read transfer.
		output wire [1 : 0] S_AXI_RRESP,
		// Read last. This signal indicates the last transfer
		// in a read burst.
		output wire  S_AXI_RLAST,
		// Optional User-defined signal in the read address channel.
		output wire [C_S_AXI_RUSER_WIDTH-1 : 0] S_AXI_RUSER,
		// Read valid. This signal indicates that the channel
		// is signaling the required read data.
		output wire  S_AXI_RVALID,
		// Read ready. This signal indicates that the master can
		// accept the read data and response information.
		input wire  S_AXI_RREADY
	);

    wire [16-1:0] STOP;
    wire [16*2-1:0] ACQUIRE_MODE;
    wire [16*4-1:0] TRIGGER_TYPE;
    wire signed [16*`SAMPLE_WIDTH-1:0] RISING_EDGE_THRESHOLD;
    wire signed [16*`SAMPLE_WIDTH-1:0] FALLING_EDGE_THRESHOLD;
    wire signed [16*(`ADC_RESOLUTION_WIDTH+1)-1:0] H_GAIN_BASELINE;
    wire signed [16*`SAMPLE_WIDTH-1:0] L_GAIN_BASELINE;
    wire [($clog2(MAX_PRE_ACQUISITION_LENGTH)+1)*16-1:0] PRE_ACQUISITION_LENGTH;
    wire [($clog2(MAX_POST_ACQUISITION_LENGTH)+1)*16-1:0] POST_ACQUISITION_LENGTH;

	assign RUNNING = ~&STOP;

    assign STOP_0 = STOP[(0+1)*1-1];
    assign ACQUIRE_MODE_0 = ACQUIRE_MODE[(0+1)*2-1:0];
    assign TRIGGER_TYPE_0 = TRIGGER_TYPE[(0+1)*4-1:0];
    assign RISING_EDGE_THRESHOLD_0 = RISING_EDGE_THRESHOLD[(0+1)*`SAMPLE_WIDTH-1:0];
    assign FALLING_EDGE_THRESHOLD_0 = FALLING_EDGE_THRESHOLD[(0+1)*`SAMPLE_WIDTH-1:0] ;
    assign H_GAIN_BASELINE_0 = H_GAIN_BASELINE[(0+1)*(`ADC_RESOLUTION_WIDTH+1)-1:0];
    assign L_GAIN_BASELINE_0 = L_GAIN_BASELINE[(0+1)*`SAMPLE_WIDTH-1:0] ;
    assign PRE_ACQUISITION_LENGTH_0 = PRE_ACQUISITION_LENGTH[(0+1)*($clog2(MAX_PRE_ACQUISITION_LENGTH)+1)-1:0] ;
    assign POST_ACQUISITION_LENGTH_0 = POST_ACQUISITION_LENGTH[(0+1)*($clog2(MAX_POST_ACQUISITION_LENGTH)+1)-1:0] ;

    assign STOP_1 = STOP[(1+1)*1-1];
    assign ACQUIRE_MODE_1 = ACQUIRE_MODE[(1+1)*2-1 -:2];
    assign TRIGGER_TYPE_1 = TRIGGER_TYPE[(1+1)*4-1 -:4];
    assign RISING_EDGE_THRESHOLD_1 = RISING_EDGE_THRESHOLD[(1+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH];
    assign FALLING_EDGE_THRESHOLD_1 = FALLING_EDGE_THRESHOLD[(1+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH] ;
    assign H_GAIN_BASELINE_1 = H_GAIN_BASELINE[(1+1)*(`ADC_RESOLUTION_WIDTH+1)-1 -:`ADC_RESOLUTION_WIDTH+1];
    assign L_GAIN_BASELINE_1 = L_GAIN_BASELINE[(1+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH] ;
    assign PRE_ACQUISITION_LENGTH_1 = PRE_ACQUISITION_LENGTH[(1+1)*($clog2(MAX_PRE_ACQUISITION_LENGTH)+1)-1 -:$clog2(MAX_PRE_ACQUISITION_LENGTH)+1] ;
    assign POST_ACQUISITION_LENGTH_1 = POST_ACQUISITION_LENGTH[(1+1)*($clog2(MAX_POST_ACQUISITION_LENGTH)+1)-1 -:$clog2(MAX_POST_ACQUISITION_LENGTH)+1] ;

    assign STOP_2 = STOP[(2+1)*1-1];
    assign ACQUIRE_MODE_2 = ACQUIRE_MODE[(2+1)*2-1 -:2];
    assign TRIGGER_TYPE_2 = TRIGGER_TYPE[(2+1)*4-1 -:4];
    assign RISING_EDGE_THRESHOLD_2 = RISING_EDGE_THRESHOLD[(2+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH];
    assign FALLING_EDGE_THRESHOLD_2 = FALLING_EDGE_THRESHOLD[(2+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH] ;
    assign H_GAIN_BASELINE_2 = H_GAIN_BASELINE[(2+1)*(`ADC_RESOLUTION_WIDTH+1)-1 -:`ADC_RESOLUTION_WIDTH+1];
    assign L_GAIN_BASELINE_2 = L_GAIN_BASELINE[(2+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH] ;
    assign PRE_ACQUISITION_LENGTH_2 = PRE_ACQUISITION_LENGTH[(2+1)*($clog2(MAX_PRE_ACQUISITION_LENGTH)+1)-1 -:$clog2(MAX_PRE_ACQUISITION_LENGTH)+1] ;
    assign POST_ACQUISITION_LENGTH_2 = POST_ACQUISITION_LENGTH[(2+1)*($clog2(MAX_POST_ACQUISITION_LENGTH)+1)-1 -:$clog2(MAX_POST_ACQUISITION_LENGTH)+1] ;

    assign STOP_3 = STOP[(3+1)*1-1];
    assign ACQUIRE_MODE_3 = ACQUIRE_MODE[(3+1)*2-1 -:2];
    assign TRIGGER_TYPE_3 = TRIGGER_TYPE[(3+1)*4-1 -:4];
    assign RISING_EDGE_THRESHOLD_3 = RISING_EDGE_THRESHOLD[(3+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH];
    assign FALLING_EDGE_THRESHOLD_3 = FALLING_EDGE_THRESHOLD[(3+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH] ;
    assign H_GAIN_BASELINE_3 = H_GAIN_BASELINE[(3+1)*(`ADC_RESOLUTION_WIDTH+1)-1 -:`ADC_RESOLUTION_WIDTH+1];
    assign L_GAIN_BASELINE_3 = L_GAIN_BASELINE[(3+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH] ;
    assign PRE_ACQUISITION_LENGTH_3 = PRE_ACQUISITION_LENGTH[(3+1)*($clog2(MAX_PRE_ACQUISITION_LENGTH)+1)-1 -:$clog2(MAX_PRE_ACQUISITION_LENGTH)+1] ;
    assign POST_ACQUISITION_LENGTH_3 = POST_ACQUISITION_LENGTH[(3+1)*($clog2(MAX_POST_ACQUISITION_LENGTH)+1)-1 -:$clog2(MAX_POST_ACQUISITION_LENGTH)+1] ;

    assign STOP_4 = STOP[(4+1)*1-1];
    assign ACQUIRE_MODE_4 = ACQUIRE_MODE[(4+1)*2-1 -:2];
    assign TRIGGER_TYPE_4 = TRIGGER_TYPE[(4+1)*4-1 -:4];
    assign RISING_EDGE_THRESHOLD_4 = RISING_EDGE_THRESHOLD[(4+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH];
    assign FALLING_EDGE_THRESHOLD_4 = FALLING_EDGE_THRESHOLD[(4+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH] ;
    assign H_GAIN_BASELINE_4 = H_GAIN_BASELINE[(4+1)*(`ADC_RESOLUTION_WIDTH+1)-1 -:`ADC_RESOLUTION_WIDTH+1];
    assign L_GAIN_BASELINE_4 = L_GAIN_BASELINE[(4+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH] ;
    assign PRE_ACQUISITION_LENGTH_4 = PRE_ACQUISITION_LENGTH[(4+1)*($clog2(MAX_PRE_ACQUISITION_LENGTH)+1)-1 -:$clog2(MAX_PRE_ACQUISITION_LENGTH)+1] ;
    assign POST_ACQUISITION_LENGTH_4 = POST_ACQUISITION_LENGTH[(4+1)*($clog2(MAX_POST_ACQUISITION_LENGTH)+1)-1 -:$clog2(MAX_POST_ACQUISITION_LENGTH)+1] ;

    assign STOP_5 = STOP[(5+1)*1-1];
    assign ACQUIRE_MODE_5 = ACQUIRE_MODE[(5+1)*2-1 -:2];
    assign TRIGGER_TYPE_5 = TRIGGER_TYPE[(5+1)*4-1 -:4];
    assign RISING_EDGE_THRESHOLD_5 = RISING_EDGE_THRESHOLD[(5+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH];
    assign FALLING_EDGE_THRESHOLD_5 = FALLING_EDGE_THRESHOLD[(5+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH] ;
    assign H_GAIN_BASELINE_5 = H_GAIN_BASELINE[(5+1)*(`ADC_RESOLUTION_WIDTH+1)-1 -:`ADC_RESOLUTION_WIDTH+1];
    assign L_GAIN_BASELINE_5 = L_GAIN_BASELINE[(5+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH] ;
    assign PRE_ACQUISITION_LENGTH_5 = PRE_ACQUISITION_LENGTH[(5+1)*($clog2(MAX_PRE_ACQUISITION_LENGTH)+1)-1 -:$clog2(MAX_PRE_ACQUISITION_LENGTH)+1] ;
    assign POST_ACQUISITION_LENGTH_5 = POST_ACQUISITION_LENGTH[(5+1)*($clog2(MAX_POST_ACQUISITION_LENGTH)+1)-1 -:$clog2(MAX_POST_ACQUISITION_LENGTH)+1] ;

    assign STOP_6 = STOP[(6+1)*1-1];
    assign ACQUIRE_MODE_6 = ACQUIRE_MODE[(6+1)*2-1 -:2];
    assign TRIGGER_TYPE_6 = TRIGGER_TYPE[(6+1)*4-1 -:4];
    assign RISING_EDGE_THRESHOLD_6 = RISING_EDGE_THRESHOLD[(6+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH];
    assign FALLING_EDGE_THRESHOLD_6 = FALLING_EDGE_THRESHOLD[(6+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH] ;
    assign H_GAIN_BASELINE_6 = H_GAIN_BASELINE[(6+1)*(`ADC_RESOLUTION_WIDTH+1)-1 -:`ADC_RESOLUTION_WIDTH+1];
    assign L_GAIN_BASELINE_6 = L_GAIN_BASELINE[(6+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH] ;
    assign PRE_ACQUISITION_LENGTH_6 = PRE_ACQUISITION_LENGTH[(6+1)*($clog2(MAX_PRE_ACQUISITION_LENGTH)+1)-1 -:$clog2(MAX_PRE_ACQUISITION_LENGTH)+1] ;
    assign POST_ACQUISITION_LENGTH_6 = POST_ACQUISITION_LENGTH[(6+1)*($clog2(MAX_POST_ACQUISITION_LENGTH)+1)-1 -:$clog2(MAX_POST_ACQUISITION_LENGTH)+1] ;

    assign STOP_7 = STOP[(7+1)*1-1];
    assign ACQUIRE_MODE_7 = ACQUIRE_MODE[(7+1)*2-1 -:2];
    assign TRIGGER_TYPE_7 = TRIGGER_TYPE[(7+1)*4-1 -:4];
    assign RISING_EDGE_THRESHOLD_7 = RISING_EDGE_THRESHOLD[(7+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH];
    assign FALLING_EDGE_THRESHOLD_7 = FALLING_EDGE_THRESHOLD[(7+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH] ;
    assign H_GAIN_BASELINE_7 = H_GAIN_BASELINE[(7+1)*(`ADC_RESOLUTION_WIDTH+1)-1 -:`ADC_RESOLUTION_WIDTH+1];
    assign L_GAIN_BASELINE_7 = L_GAIN_BASELINE[(7+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH] ;
    assign PRE_ACQUISITION_LENGTH_7 = PRE_ACQUISITION_LENGTH[(7+1)*($clog2(MAX_PRE_ACQUISITION_LENGTH)+1)-1 -:$clog2(MAX_PRE_ACQUISITION_LENGTH)+1] ;
    assign POST_ACQUISITION_LENGTH_7 = POST_ACQUISITION_LENGTH[(7+1)*($clog2(MAX_POST_ACQUISITION_LENGTH)+1)-1 -:$clog2(MAX_POST_ACQUISITION_LENGTH)+1] ;

    assign STOP_8 = STOP[(8+1)*1-1];
    assign ACQUIRE_MODE_8 = ACQUIRE_MODE[(8+1)*2-1 -:2];
    assign TRIGGER_TYPE_8 = TRIGGER_TYPE[(8+1)*4-1 -:4];
    assign RISING_EDGE_THRESHOLD_8 = RISING_EDGE_THRESHOLD[(8+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH];
    assign FALLING_EDGE_THRESHOLD_8 = FALLING_EDGE_THRESHOLD[(8+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH] ;
    assign H_GAIN_BASELINE_8 = H_GAIN_BASELINE[(8+1)*(`ADC_RESOLUTION_WIDTH+1)-1 -:`ADC_RESOLUTION_WIDTH+1];
    assign L_GAIN_BASELINE_8 = L_GAIN_BASELINE[(8+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH] ;
    assign PRE_ACQUISITION_LENGTH_8 = PRE_ACQUISITION_LENGTH[(8+1)*($clog2(MAX_PRE_ACQUISITION_LENGTH)+1)-1 -:$clog2(MAX_PRE_ACQUISITION_LENGTH)+1] ;
    assign POST_ACQUISITION_LENGTH_8 = POST_ACQUISITION_LENGTH[(8+1)*($clog2(MAX_POST_ACQUISITION_LENGTH)+1)-1 -:$clog2(MAX_POST_ACQUISITION_LENGTH)+1] ;

    assign STOP_9 = STOP[(9+1)*1-1];
    assign ACQUIRE_MODE_9 = ACQUIRE_MODE[(9+1)*2-1 -:2];
    assign TRIGGER_TYPE_9 = TRIGGER_TYPE[(9+1)*4-1 -:4];
    assign RISING_EDGE_THRESHOLD_9 = RISING_EDGE_THRESHOLD[(9+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH];
    assign FALLING_EDGE_THRESHOLD_9 = FALLING_EDGE_THRESHOLD[(9+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH] ;
    assign H_GAIN_BASELINE_9 = H_GAIN_BASELINE[(9+1)*(`ADC_RESOLUTION_WIDTH+1)-1 -:`ADC_RESOLUTION_WIDTH+1];
    assign L_GAIN_BASELINE_9 = L_GAIN_BASELINE[(9+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH] ;
    assign PRE_ACQUISITION_LENGTH_9 = PRE_ACQUISITION_LENGTH[(9+1)*($clog2(MAX_PRE_ACQUISITION_LENGTH)+1)-1 -:$clog2(MAX_PRE_ACQUISITION_LENGTH)+1] ;
    assign POST_ACQUISITION_LENGTH_9 = POST_ACQUISITION_LENGTH[(9+1)*($clog2(MAX_POST_ACQUISITION_LENGTH)+1)-1 -:$clog2(MAX_POST_ACQUISITION_LENGTH)+1] ;

    assign STOP_10 = STOP[(10+1)*1-1];
    assign ACQUIRE_MODE_10 = ACQUIRE_MODE[(10+1)*2-1 -:2];
    assign TRIGGER_TYPE_10 = TRIGGER_TYPE[(10+1)*4-1 -:4];
    assign RISING_EDGE_THRESHOLD_10 = RISING_EDGE_THRESHOLD[(10+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH];
    assign FALLING_EDGE_THRESHOLD_10 = FALLING_EDGE_THRESHOLD[(10+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH] ;
    assign H_GAIN_BASELINE_10 = H_GAIN_BASELINE[(10+1)*(`ADC_RESOLUTION_WIDTH+1)-1 -:`ADC_RESOLUTION_WIDTH+1];
    assign L_GAIN_BASELINE_10 = L_GAIN_BASELINE[(10+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH] ;
    assign PRE_ACQUISITION_LENGTH_10 = PRE_ACQUISITION_LENGTH[(10+1)*($clog2(MAX_PRE_ACQUISITION_LENGTH)+1)-1 -:$clog2(MAX_PRE_ACQUISITION_LENGTH)+1] ;
    assign POST_ACQUISITION_LENGTH_10 = POST_ACQUISITION_LENGTH[(10+1)*($clog2(MAX_POST_ACQUISITION_LENGTH)+1)-1 -:$clog2(MAX_POST_ACQUISITION_LENGTH)+1] ;
 
    assign STOP_11 = STOP[(11+1)*1-1];
    assign ACQUIRE_MODE_11 = ACQUIRE_MODE[(11+1)*2-1 -:2];
    assign TRIGGER_TYPE_11 = TRIGGER_TYPE[(11+1)*4-1 -:4];
    assign RISING_EDGE_THRESHOLD_11 = RISING_EDGE_THRESHOLD[(11+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH];
    assign FALLING_EDGE_THRESHOLD_11 = FALLING_EDGE_THRESHOLD[(11+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH] ;
    assign H_GAIN_BASELINE_11 = H_GAIN_BASELINE[(11+1)*(`ADC_RESOLUTION_WIDTH+1)-1 -:`ADC_RESOLUTION_WIDTH+1];
    assign L_GAIN_BASELINE_11 = L_GAIN_BASELINE[(11+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH] ;
    assign PRE_ACQUISITION_LENGTH_11 = PRE_ACQUISITION_LENGTH[(11+1)*($clog2(MAX_PRE_ACQUISITION_LENGTH)+1)-1 -:$clog2(MAX_PRE_ACQUISITION_LENGTH)+1] ;
    assign POST_ACQUISITION_LENGTH_11 = POST_ACQUISITION_LENGTH[(11+1)*($clog2(MAX_POST_ACQUISITION_LENGTH)+1)-1 -:$clog2(MAX_POST_ACQUISITION_LENGTH)+1] ;

    assign STOP_12 = STOP[(12+1)*1-1];
    assign ACQUIRE_MODE_12 = ACQUIRE_MODE[(12+1)*2-1 -:2];
    assign TRIGGER_TYPE_12 = TRIGGER_TYPE[(12+1)*4-1 -:4];
    assign RISING_EDGE_THRESHOLD_12 = RISING_EDGE_THRESHOLD[(12+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH];
    assign FALLING_EDGE_THRESHOLD_12 = FALLING_EDGE_THRESHOLD[(12+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH] ;
    assign H_GAIN_BASELINE_12 = H_GAIN_BASELINE[(12+1)*(`ADC_RESOLUTION_WIDTH+1)-1 -:`ADC_RESOLUTION_WIDTH+1];
    assign L_GAIN_BASELINE_12 = L_GAIN_BASELINE[(12+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH] ;
    assign PRE_ACQUISITION_LENGTH_12 = PRE_ACQUISITION_LENGTH[(12+1)*($clog2(MAX_PRE_ACQUISITION_LENGTH)+1)-1 -:$clog2(MAX_PRE_ACQUISITION_LENGTH)+1] ;
    assign POST_ACQUISITION_LENGTH_12 = POST_ACQUISITION_LENGTH[(12+1)*($clog2(MAX_POST_ACQUISITION_LENGTH)+1)-1 -:$clog2(MAX_POST_ACQUISITION_LENGTH)+1] ;

    assign STOP_13 = STOP[(13+1)*1-1];
    assign ACQUIRE_MODE_13 = ACQUIRE_MODE[(13+1)*2-1 -:2];
    assign TRIGGER_TYPE_13 = TRIGGER_TYPE[(13+1)*4-1 -:4];
    assign RISING_EDGE_THRESHOLD_13 = RISING_EDGE_THRESHOLD[(13+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH];
    assign FALLING_EDGE_THRESHOLD_13 = FALLING_EDGE_THRESHOLD[(13+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH] ;
    assign H_GAIN_BASELINE_13 = H_GAIN_BASELINE[(13+1)*(`ADC_RESOLUTION_WIDTH+1)-1 -:`ADC_RESOLUTION_WIDTH+1];
    assign L_GAIN_BASELINE_13 = L_GAIN_BASELINE[(13+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH] ;
    assign PRE_ACQUISITION_LENGTH_13 = PRE_ACQUISITION_LENGTH[(13+1)*($clog2(MAX_PRE_ACQUISITION_LENGTH)+1)-1 -:$clog2(MAX_PRE_ACQUISITION_LENGTH)+1] ;
    assign POST_ACQUISITION_LENGTH_13 = POST_ACQUISITION_LENGTH[(13+1)*($clog2(MAX_POST_ACQUISITION_LENGTH)+1)-1 -:$clog2(MAX_POST_ACQUISITION_LENGTH)+1] ;

    assign STOP_14 = STOP[(14+1)*1-1];
    assign ACQUIRE_MODE_14 = ACQUIRE_MODE[(14+1)*2-1 -:2];
    assign TRIGGER_TYPE_14 = TRIGGER_TYPE[(14+1)*4-1 -:4];
    assign RISING_EDGE_THRESHOLD_14 = RISING_EDGE_THRESHOLD[(14+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH];
    assign FALLING_EDGE_THRESHOLD_14 = FALLING_EDGE_THRESHOLD[(14+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH] ;
    assign H_GAIN_BASELINE_14 = H_GAIN_BASELINE[(14+1)*(`ADC_RESOLUTION_WIDTH+1)-1 -:`ADC_RESOLUTION_WIDTH+1];
    assign L_GAIN_BASELINE_14 = L_GAIN_BASELINE[(14+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH] ;
    assign PRE_ACQUISITION_LENGTH_14 = PRE_ACQUISITION_LENGTH[(14+1)*($clog2(MAX_PRE_ACQUISITION_LENGTH)+1)-1 -:$clog2(MAX_PRE_ACQUISITION_LENGTH)+1] ;
    assign POST_ACQUISITION_LENGTH_14 = POST_ACQUISITION_LENGTH[(14+1)*($clog2(MAX_POST_ACQUISITION_LENGTH)+1)-1 -:$clog2(MAX_POST_ACQUISITION_LENGTH)+1] ;

    assign STOP_15 = STOP[(15+1)*1-1];
    assign ACQUIRE_MODE_15 = ACQUIRE_MODE[(15+1)*2-1 -:2];
    assign TRIGGER_TYPE_15 = TRIGGER_TYPE[(15+1)*4-1 -:4];
    assign RISING_EDGE_THRESHOLD_15 = RISING_EDGE_THRESHOLD[(15+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH];
    assign FALLING_EDGE_THRESHOLD_15 = FALLING_EDGE_THRESHOLD[(15+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH] ;
    assign H_GAIN_BASELINE_15 = H_GAIN_BASELINE[(15+1)*(`ADC_RESOLUTION_WIDTH+1)-1 -:`ADC_RESOLUTION_WIDTH+1];
    assign L_GAIN_BASELINE_15 = L_GAIN_BASELINE[(15+1)*`SAMPLE_WIDTH-1 -:`SAMPLE_WIDTH] ;
    assign PRE_ACQUISITION_LENGTH_15 = PRE_ACQUISITION_LENGTH[(15+1)*($clog2(MAX_PRE_ACQUISITION_LENGTH)+1)-1 -:$clog2(MAX_PRE_ACQUISITION_LENGTH)+1] ;
    assign POST_ACQUISITION_LENGTH_15 = POST_ACQUISITION_LENGTH[(15+1)*($clog2(MAX_POST_ACQUISITION_LENGTH)+1)-1 -:$clog2(MAX_POST_ACQUISITION_LENGTH)+1] ;

    trigger_configrator_core #(
        .CHANNEL_NUM(16),
        .MAX_PRE_ACQUISITION_LENGTH(MAX_PRE_ACQUISITION_LENGTH),
        .MAX_POST_ACQUISITION_LENGTH(MAX_POST_ACQUISITION_LENGTH),
        .C_S_AXI_ID_WIDTH(C_S_AXI_ID_WIDTH),
        .C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH),
        .C_S_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH),
        .C_S_AXI_AWUSER_WIDTH(C_S_AXI_AWUSER_WIDTH),
        .C_S_AXI_ARUSER_WIDTH(C_S_AXI_ARUSER_WIDTH),
        .C_S_AXI_WUSER_WIDTH(C_S_AXI_WUSER_WIDTH),
        .C_S_AXI_RUSER_WIDTH(C_S_AXI_RUSER_WIDTH),
        .C_S_AXI_BUSER_WIDTH(C_S_AXI_BUSER_WIDTH)
    ) inst (
        .SET_CONFIG(SET_CONFIG),
        .STOP(STOP),
        .ACQUIRE_MODE(ACQUIRE_MODE),
        .TRIGGER_TYPE(TRIGGER_TYPE),
        .RISING_EDGE_THRESHOLD(RISING_EDGE_THRESHOLD),
        .FALLING_EDGE_THRESHOLD(FALLING_EDGE_THRESHOLD),
        .H_GAIN_BASELINE(H_GAIN_BASELINE),
        .L_GAIN_BASELINE(L_GAIN_BASELINE),
        .PRE_ACQUISITION_LENGTH(PRE_ACQUISITION_LENGTH),
        .POST_ACQUISITION_LENGTH(POST_ACQUISITION_LENGTH),
        .MAX_TRIGGER_LENGTH(MAX_TRIGGER_LENGTH),
        .S_AXI_ACLK(S_AXI_ACLK),
        .S_AXI_ARESETN(S_AXI_ARESETN),
        .S_AXI_AWID(S_AXI_AWID),
        .S_AXI_AWADDR(S_AXI_AWADDR),
        .S_AXI_AWLEN(S_AXI_AWLEN),
        .S_AXI_AWSIZE(S_AXI_AWSIZE),
        .S_AXI_AWBURST(S_AXI_AWBURST),
        .S_AXI_AWLOCK(S_AXI_AWLOCK),
        .S_AXI_AWCACHE(S_AXI_AWCACHE),
        .S_AXI_AWPROT(S_AXI_AWPROT),
        .S_AXI_AWQOS(S_AXI_AWQOS),
        .S_AXI_AWREGION(S_AXI_AWREGION),
        .S_AXI_AWUSER(S_AXI_AWUSER),
        .S_AXI_AWVALID(S_AXI_AWVALID),
        .S_AXI_AWREADY(S_AXI_AWREADY),
        .S_AXI_WDATA(S_AXI_WDATA),
        .S_AXI_WSTRB(S_AXI_WSTRB),
        .S_AXI_WLAST(S_AXI_WLAST),
        .S_AXI_WUSER(S_AXI_WUSER),
        .S_AXI_WVALID(S_AXI_WVALID),
        .S_AXI_WREADY(S_AXI_WREADY),
        .S_AXI_BID(S_AXI_BID),
        .S_AXI_BRESP(S_AXI_BRESP),
        .S_AXI_BUSER(S_AXI_BUSER),
        .S_AXI_BVALID(S_AXI_BVALID),
        .S_AXI_BREADY(S_AXI_BREADY),
        .S_AXI_ARID(S_AXI_ARID),
        .S_AXI_ARADDR(S_AXI_ARADDR),
        .S_AXI_ARLEN(S_AXI_ARLEN),
        .S_AXI_ARSIZE(S_AXI_ARSIZE),
        .S_AXI_ARBURST(S_AXI_ARBURST),
        .S_AXI_ARLOCK(S_AXI_ARLOCK),
        .S_AXI_ARCACHE(S_AXI_ARCACHE),
        .S_AXI_ARPROT(S_AXI_ARPROT),
        .S_AXI_ARQOS(S_AXI_ARQOS),
        .S_AXI_ARREGION(S_AXI_ARREGION),
        .S_AXI_ARUSER(S_AXI_ARUSER),
        .S_AXI_ARVALID(S_AXI_ARVALID),
        .S_AXI_ARREADY(S_AXI_ARREADY),
        .S_AXI_RID(S_AXI_RID),
        .S_AXI_RDATA(S_AXI_RDATA),
        .S_AXI_RRESP(S_AXI_RRESP),
        .S_AXI_RLAST(S_AXI_RLAST),
        .S_AXI_RUSER(S_AXI_RUSER),
        .S_AXI_RVALID(S_AXI_RVALID),
        .S_AXI_RREADY(S_AXI_RREADY)
    );

endmodule