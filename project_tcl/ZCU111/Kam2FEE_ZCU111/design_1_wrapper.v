//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1.3 (win64) Build 2644227 Wed Sep  4 09:45:24 MDT 2019
//Date        : Fri Oct 23 12:06:47 2020
//Host        : AKABEKO03 running 64-bit major release  (build 9200)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (DATAMOVER_ERROR_LED,
    DF_GEN_ERROR_LED,
    EXTERNAL_TRIGGER_0,
    EXTERNAL_TRIGGER_1,
    EXTERNAL_TRIGGER_2,
    EXT_RESET,
    PL_CLK_in_0_clk_n,
    PL_CLK_in_0_clk_p,
    PL_SYSREF_CLK_in_0_clk_n,
    PL_SYSREF_CLK_in_0_clk_p,
    adc0_clk_clk_n,
    adc0_clk_clk_p,
    adc1_clk_clk_n,
    adc1_clk_clk_p,
    adc2_clk_clk_n,
    adc2_clk_clk_p,
    adc3_clk_clk_n,
    adc3_clk_clk_p,
    dac0_clk_clk_n,
    dac0_clk_clk_p,
    ddr4_sdram_act_n,
    ddr4_sdram_adr,
    ddr4_sdram_ba,
    ddr4_sdram_bg,
    ddr4_sdram_ck_c,
    ddr4_sdram_ck_t,
    ddr4_sdram_cke,
    ddr4_sdram_cs_n,
    ddr4_sdram_dm_n,
    ddr4_sdram_dq,
    ddr4_sdram_dqs_c,
    ddr4_sdram_dqs_t,
    ddr4_sdram_odt,
    ddr4_sdram_reset_n,
    default_sysclk1_300mhz_clk_n,
    default_sysclk1_300mhz_clk_p,
    sysref_in_diff_n,
    sysref_in_diff_p,
    vin0_01_v_n,
    vin0_01_v_p,
    vin1_01_v_n,
    vin1_01_v_p,
    vin2_01_v_n,
    vin2_01_v_p,
    vin2_23_v_n,
    vin2_23_v_p,
    vin3_01_v_n,
    vin3_01_v_p,
    vin3_23_v_n,
    vin3_23_v_p,
    vout00_v_n,
    vout00_v_p,
    vout01_v_n,
    vout01_v_p,
    vout02_v_n,
    vout02_v_p,
    vout03_v_n,
    vout03_v_p);
  output DATAMOVER_ERROR_LED;
  output DF_GEN_ERROR_LED;
  input EXTERNAL_TRIGGER_0;
  input EXTERNAL_TRIGGER_1;
  input EXTERNAL_TRIGGER_2;
  input EXT_RESET;
  input [0:0]PL_CLK_in_0_clk_n;
  input [0:0]PL_CLK_in_0_clk_p;
  input [0:0]PL_SYSREF_CLK_in_0_clk_n;
  input [0:0]PL_SYSREF_CLK_in_0_clk_p;
  input adc0_clk_clk_n;
  input adc0_clk_clk_p;
  input adc1_clk_clk_n;
  input adc1_clk_clk_p;
  input adc2_clk_clk_n;
  input adc2_clk_clk_p;
  input adc3_clk_clk_n;
  input adc3_clk_clk_p;
  input dac0_clk_clk_n;
  input dac0_clk_clk_p;
  output ddr4_sdram_act_n;
  output [16:0]ddr4_sdram_adr;
  output [1:0]ddr4_sdram_ba;
  output ddr4_sdram_bg;
  output ddr4_sdram_ck_c;
  output ddr4_sdram_ck_t;
  output ddr4_sdram_cke;
  output ddr4_sdram_cs_n;
  inout [7:0]ddr4_sdram_dm_n;
  inout [63:0]ddr4_sdram_dq;
  inout [7:0]ddr4_sdram_dqs_c;
  inout [7:0]ddr4_sdram_dqs_t;
  output ddr4_sdram_odt;
  output ddr4_sdram_reset_n;
  input default_sysclk1_300mhz_clk_n;
  input default_sysclk1_300mhz_clk_p;
  input sysref_in_diff_n;
  input sysref_in_diff_p;
  input vin0_01_v_n;
  input vin0_01_v_p;
  input vin1_01_v_n;
  input vin1_01_v_p;
  input vin2_01_v_n;
  input vin2_01_v_p;
  input vin2_23_v_n;
  input vin2_23_v_p;
  input vin3_01_v_n;
  input vin3_01_v_p;
  input vin3_23_v_n;
  input vin3_23_v_p;
  output vout00_v_n;
  output vout00_v_p;
  output vout01_v_n;
  output vout01_v_p;
  output vout02_v_n;
  output vout02_v_p;
  output vout03_v_n;
  output vout03_v_p;

  wire DATAMOVER_ERROR_LED;
  wire DF_GEN_ERROR_LED;
  wire EXTERNAL_TRIGGER_0;
  wire EXTERNAL_TRIGGER_1;
  wire EXTERNAL_TRIGGER_2;
  wire EXT_RESET;
  wire [0:0]PL_CLK_in_0_clk_n;
  wire [0:0]PL_CLK_in_0_clk_p;
  wire [0:0]PL_SYSREF_CLK_in_0_clk_n;
  wire [0:0]PL_SYSREF_CLK_in_0_clk_p;
  wire adc0_clk_clk_n;
  wire adc0_clk_clk_p;
  wire adc1_clk_clk_n;
  wire adc1_clk_clk_p;
  wire adc2_clk_clk_n;
  wire adc2_clk_clk_p;
  wire adc3_clk_clk_n;
  wire adc3_clk_clk_p;
  wire dac0_clk_clk_n;
  wire dac0_clk_clk_p;
  wire ddr4_sdram_act_n;
  wire [16:0]ddr4_sdram_adr;
  wire [1:0]ddr4_sdram_ba;
  wire ddr4_sdram_bg;
  wire ddr4_sdram_ck_c;
  wire ddr4_sdram_ck_t;
  wire ddr4_sdram_cke;
  wire ddr4_sdram_cs_n;
  wire [7:0]ddr4_sdram_dm_n;
  wire [63:0]ddr4_sdram_dq;
  wire [7:0]ddr4_sdram_dqs_c;
  wire [7:0]ddr4_sdram_dqs_t;
  wire ddr4_sdram_odt;
  wire ddr4_sdram_reset_n;
  wire default_sysclk1_300mhz_clk_n;
  wire default_sysclk1_300mhz_clk_p;
  wire sysref_in_diff_n;
  wire sysref_in_diff_p;
  wire vin0_01_v_n;
  wire vin0_01_v_p;
  wire vin1_01_v_n;
  wire vin1_01_v_p;
  wire vin2_01_v_n;
  wire vin2_01_v_p;
  wire vin2_23_v_n;
  wire vin2_23_v_p;
  wire vin3_01_v_n;
  wire vin3_01_v_p;
  wire vin3_23_v_n;
  wire vin3_23_v_p;
  wire vout00_v_n;
  wire vout00_v_p;
  wire vout01_v_n;
  wire vout01_v_p;
  wire vout02_v_n;
  wire vout02_v_p;
  wire vout03_v_n;
  wire vout03_v_p;

  design_1 design_1_i
       (.DATAMOVER_ERROR_LED(DATAMOVER_ERROR_LED),
        .DF_GEN_ERROR_LED(DF_GEN_ERROR_LED),
        .EXTERNAL_TRIGGER_0(EXTERNAL_TRIGGER_0),
        .EXTERNAL_TRIGGER_1(EXTERNAL_TRIGGER_1),
        .EXTERNAL_TRIGGER_2(EXTERNAL_TRIGGER_2),
        .EXT_RESET(EXT_RESET),
        .PL_CLK_in_0_clk_n(PL_CLK_in_0_clk_n),
        .PL_CLK_in_0_clk_p(PL_CLK_in_0_clk_p),
        .PL_SYSREF_CLK_in_0_clk_n(PL_SYSREF_CLK_in_0_clk_n),
        .PL_SYSREF_CLK_in_0_clk_p(PL_SYSREF_CLK_in_0_clk_p),
        .adc0_clk_clk_n(adc0_clk_clk_n),
        .adc0_clk_clk_p(adc0_clk_clk_p),
        .adc1_clk_clk_n(adc1_clk_clk_n),
        .adc1_clk_clk_p(adc1_clk_clk_p),
        .adc2_clk_clk_n(adc2_clk_clk_n),
        .adc2_clk_clk_p(adc2_clk_clk_p),
        .adc3_clk_clk_n(adc3_clk_clk_n),
        .adc3_clk_clk_p(adc3_clk_clk_p),
        .dac0_clk_clk_n(dac0_clk_clk_n),
        .dac0_clk_clk_p(dac0_clk_clk_p),
        .ddr4_sdram_act_n(ddr4_sdram_act_n),
        .ddr4_sdram_adr(ddr4_sdram_adr),
        .ddr4_sdram_ba(ddr4_sdram_ba),
        .ddr4_sdram_bg(ddr4_sdram_bg),
        .ddr4_sdram_ck_c(ddr4_sdram_ck_c),
        .ddr4_sdram_ck_t(ddr4_sdram_ck_t),
        .ddr4_sdram_cke(ddr4_sdram_cke),
        .ddr4_sdram_cs_n(ddr4_sdram_cs_n),
        .ddr4_sdram_dm_n(ddr4_sdram_dm_n),
        .ddr4_sdram_dq(ddr4_sdram_dq),
        .ddr4_sdram_dqs_c(ddr4_sdram_dqs_c),
        .ddr4_sdram_dqs_t(ddr4_sdram_dqs_t),
        .ddr4_sdram_odt(ddr4_sdram_odt),
        .ddr4_sdram_reset_n(ddr4_sdram_reset_n),
        .default_sysclk1_300mhz_clk_n(default_sysclk1_300mhz_clk_n),
        .default_sysclk1_300mhz_clk_p(default_sysclk1_300mhz_clk_p),
        .sysref_in_diff_n(sysref_in_diff_n),
        .sysref_in_diff_p(sysref_in_diff_p),
        .vin0_01_v_n(vin0_01_v_n),
        .vin0_01_v_p(vin0_01_v_p),
        .vin1_01_v_n(vin1_01_v_n),
        .vin1_01_v_p(vin1_01_v_p),
        .vin2_01_v_n(vin2_01_v_n),
        .vin2_01_v_p(vin2_01_v_p),
        .vin2_23_v_n(vin2_23_v_n),
        .vin2_23_v_p(vin2_23_v_p),
        .vin3_01_v_n(vin3_01_v_n),
        .vin3_01_v_p(vin3_01_v_p),
        .vin3_23_v_n(vin3_23_v_n),
        .vin3_23_v_p(vin3_23_v_p),
        .vout00_v_n(vout00_v_n),
        .vout00_v_p(vout00_v_p),
        .vout01_v_n(vout01_v_n),
        .vout01_v_p(vout01_v_p),
        .vout02_v_n(vout02_v_n),
        .vout02_v_p(vout02_v_p),
        .vout03_v_n(vout03_v_n),
        .vout03_v_p(vout03_v_p));
endmodule
