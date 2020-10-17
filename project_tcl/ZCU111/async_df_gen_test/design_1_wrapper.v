//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1.3 (win64) Build 2644227 Wed Sep  4 09:45:24 MDT 2019
//Date        : Thu Oct 15 13:07:23 2020
//Host        : AKABEKO03 running 64-bit major release  (build 9200)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (CLK_IN1_D_0_clk_n,
    CLK_IN1_D_0_clk_p,
    CLK_LOCKED_LED,
    CLK_LOCKED_LED1,
    DATAFRAME_GEN_ERROR_0,
    EXT_RESET,
    RESET_LED,
    default_sysclk1_300mhz_clk_n,
    default_sysclk1_300mhz_clk_p);
  input CLK_IN1_D_0_clk_n;
  input CLK_IN1_D_0_clk_p;
  output CLK_LOCKED_LED;
  output CLK_LOCKED_LED1;
  output DATAFRAME_GEN_ERROR_0;
  input EXT_RESET;
  output [0:0]RESET_LED;
  input default_sysclk1_300mhz_clk_n;
  input default_sysclk1_300mhz_clk_p;

  wire CLK_IN1_D_0_clk_n;
  wire CLK_IN1_D_0_clk_p;
  wire CLK_LOCKED_LED;
  wire CLK_LOCKED_LED1;
  wire DATAFRAME_GEN_ERROR_0;
  wire EXT_RESET;
  wire [0:0]RESET_LED;
  wire default_sysclk1_300mhz_clk_n;
  wire default_sysclk1_300mhz_clk_p;

  design_1 design_1_i
       (.CLK_IN1_D_0_clk_n(CLK_IN1_D_0_clk_n),
        .CLK_IN1_D_0_clk_p(CLK_IN1_D_0_clk_p),
        .CLK_LOCKED_LED(CLK_LOCKED_LED),
        .CLK_LOCKED_LED1(CLK_LOCKED_LED1),
        .DATAFRAME_GEN_ERROR_0(DATAFRAME_GEN_ERROR_0),
        .EXT_RESET(EXT_RESET),
        .RESET_LED(RESET_LED),
        .default_sysclk1_300mhz_clk_n(default_sysclk1_300mhz_clk_n),
        .default_sysclk1_300mhz_clk_p(default_sysclk1_300mhz_clk_p));
endmodule
