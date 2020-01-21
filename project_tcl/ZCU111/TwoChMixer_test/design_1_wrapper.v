//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
//Date        : Mon Jan 20 23:01:01 2020
//Host        : Akabeko running 64-bit major release  (build 9200)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (CLK_IN1_D_0_clk_n,
    CLK_IN1_D_0_clk_p,
    EXT_READY,
    EXT_RESET,
    LED_OUT_0,
    MIXER_VALID,
    adc0_clk_clk_n,
    adc0_clk_clk_p,
    locked_0,
    sysref_in_diff_n,
    sysref_in_diff_p,
    vin0_01_v_n,
    vin0_01_v_p,
    vin0_23_v_n,
    vin0_23_v_p);
  input CLK_IN1_D_0_clk_n;
  input CLK_IN1_D_0_clk_p;
  input EXT_READY;
  input EXT_RESET;
  output LED_OUT_0;
  output MIXER_VALID;
  input adc0_clk_clk_n;
  input adc0_clk_clk_p;
  output locked_0;
  input sysref_in_diff_n;
  input sysref_in_diff_p;
  input vin0_01_v_n;
  input vin0_01_v_p;
  input vin0_23_v_n;
  input vin0_23_v_p;

  wire CLK_IN1_D_0_clk_n;
  wire CLK_IN1_D_0_clk_p;
  wire EXT_READY;
  wire EXT_RESET;
  wire LED_OUT_0;
  wire MIXER_VALID;
  wire adc0_clk_clk_n;
  wire adc0_clk_clk_p;
  wire locked_0;
  wire sysref_in_diff_n;
  wire sysref_in_diff_p;
  wire vin0_01_v_n;
  wire vin0_01_v_p;
  wire vin0_23_v_n;
  wire vin0_23_v_p;

  design_1 design_1_i
       (.CLK_IN1_D_0_clk_n(CLK_IN1_D_0_clk_n),
        .CLK_IN1_D_0_clk_p(CLK_IN1_D_0_clk_p),
        .EXT_READY(EXT_READY),
        .EXT_RESET(EXT_RESET),
        .LED_OUT_0(LED_OUT_0),
        .MIXER_VALID(MIXER_VALID),
        .adc0_clk_clk_n(adc0_clk_clk_n),
        .adc0_clk_clk_p(adc0_clk_clk_p),
        .locked_0(locked_0),
        .sysref_in_diff_n(sysref_in_diff_n),
        .sysref_in_diff_p(sysref_in_diff_p),
        .vin0_01_v_n(vin0_01_v_n),
        .vin0_01_v_p(vin0_01_v_p),
        .vin0_23_v_n(vin0_23_v_n),
        .vin0_23_v_p(vin0_23_v_p));
endmodule