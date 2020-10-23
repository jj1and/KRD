//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1.3 (win64) Build 2644227 Wed Sep  4 09:45:24 MDT 2019
//Date        : Mon Oct 19 13:53:01 2020
//Host        : AKABEKO03 running 64-bit major release  (build 9200)
//Command     : generate_target mogura2_fee_wrapper.bd
//Design      : mogura2_fee_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module mogura2_fee_wrapper
   (C0_SYS_CLK_0_clk_n,
    C0_SYS_CLK_0_clk_p,
    CDCI6214_EEPROM_SEL_0,
    CDCI6214_OE_0,
    CDCI6214_REF_SEL_0,
    CDCI6214_RESETN_0,
    CDCI6214_STATUS_0,
    GPI_0,
    GPO_0,
    IIC_CDCI6214_0_scl_io,
    IIC_CDCI6214_0_sda_io,
    IIC_SFP1_0_scl_io,
    IIC_SFP1_0_sda_io,
    IIC_SFP2_0_scl_io,
    IIC_SFP2_0_sda_io,
    LADC_CTRL1_0,
    LADC_CTRL2_0,
    LADC_RESET_0,
    LADC_SEN_0,
    LEMO,
    PL_SYSREF_clk_n,
    PL_SYSREF_clk_p,
    PL_SYSTEM_CLK_clk_n,
    PL_SYSTEM_CLK_clk_p,
    SFP1_MOD_ABS_0,
    SFP1_RS0_0,
    SFP1_RS1_0,
    SFP1_RX_LOS_0,
    SFP1_TX_DISABLE_0,
    SFP1_TX_FAULT_0,
    SFP2_MOD_ABS_0,
    SFP2_RS0_0,
    SFP2_RS1_0,
    SFP2_RX_LOS_0,
    SFP2_TX_DISABLE_0,
    SFP2_TX_FAULT_0,
    SPI_BASEDAC_0_io0_io,
    SPI_BASEDAC_0_io1_io,
    SPI_BASEDAC_0_sck_io,
    SPI_BASEDAC_0_ss_io,
    SPI_LADC_0_io0_io,
    SPI_LADC_0_io1_io,
    SPI_LADC_0_sck_io,
    SPI_LADC_0_ss_io,
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
    dac1_clk_clk_n,
    dac1_clk_clk_p,
    dac2_clk_clk_n,
    dac2_clk_clk_p,
    dac3_clk_clk_n,
    dac3_clk_clk_p,
    ddr4_rtl_0_act_n,
    ddr4_rtl_0_adr,
    ddr4_rtl_0_ba,
    ddr4_rtl_0_bg,
    ddr4_rtl_0_ck_c,
    ddr4_rtl_0_ck_t,
    ddr4_rtl_0_cke,
    ddr4_rtl_0_cs_n,
    ddr4_rtl_0_dm_n,
    ddr4_rtl_0_dq,
    ddr4_rtl_0_dqs_c,
    ddr4_rtl_0_dqs_t,
    ddr4_rtl_0_odt,
    ddr4_rtl_0_reset_n,
    sys_rst_0,
    sysref_in_diff_n,
    sysref_in_diff_p,
    vin00_v_n,
    vin00_v_p,
    vin01_v_n,
    vin01_v_p,
    vin02_v_n,
    vin02_v_p,
    vin03_v_n,
    vin03_v_p,
    vin10_v_n,
    vin10_v_p,
    vin11_v_n,
    vin11_v_p,
    vin12_v_n,
    vin12_v_p,
    vin13_v_n,
    vin13_v_p,
    vin20_v_n,
    vin20_v_p,
    vin21_v_n,
    vin21_v_p,
    vin22_v_n,
    vin22_v_p,
    vin23_v_n,
    vin23_v_p,
    vin30_v_n,
    vin30_v_p,
    vin31_v_n,
    vin31_v_p,
    vin32_v_n,
    vin32_v_p,
    vin33_v_n,
    vin33_v_p,
    vout00_v_n,
    vout00_v_p,
    vout01_v_n,
    vout01_v_p,
    vout02_v_n,
    vout02_v_p,
    vout03_v_n,
    vout03_v_p,
    vout10_v_n,
    vout10_v_p,
    vout11_v_n,
    vout11_v_p,
    vout12_v_n,
    vout12_v_p,
    vout13_v_n,
    vout13_v_p,
    vout20_v_n,
    vout20_v_p,
    vout21_v_n,
    vout21_v_p,
    vout22_v_n,
    vout22_v_p,
    vout23_v_n,
    vout23_v_p,
    vout30_v_n,
    vout30_v_p,
    vout31_v_n,
    vout31_v_p,
    vout32_v_n,
    vout32_v_p,
    vout33_v_n,
    vout33_v_p,
    xiphy_rx_pins_0_pin0,
    xiphy_rx_pins_0_pin1,
    xiphy_rx_pins_0_pin10,
    xiphy_rx_pins_0_pin11,
    xiphy_rx_pins_0_pin13,
    xiphy_rx_pins_0_pin14,
    xiphy_rx_pins_0_pin15,
    xiphy_rx_pins_0_pin16,
    xiphy_rx_pins_0_pin17,
    xiphy_rx_pins_0_pin18,
    xiphy_rx_pins_0_pin19,
    xiphy_rx_pins_0_pin2,
    xiphy_rx_pins_0_pin20,
    xiphy_rx_pins_0_pin21,
    xiphy_rx_pins_0_pin22,
    xiphy_rx_pins_0_pin23,
    xiphy_rx_pins_0_pin24,
    xiphy_rx_pins_0_pin26,
    xiphy_rx_pins_0_pin27,
    xiphy_rx_pins_0_pin28,
    xiphy_rx_pins_0_pin29,
    xiphy_rx_pins_0_pin3,
    xiphy_rx_pins_0_pin30,
    xiphy_rx_pins_0_pin31,
    xiphy_rx_pins_0_pin32,
    xiphy_rx_pins_0_pin33,
    xiphy_rx_pins_0_pin34,
    xiphy_rx_pins_0_pin35,
    xiphy_rx_pins_0_pin36,
    xiphy_rx_pins_0_pin37,
    xiphy_rx_pins_0_pin39,
    xiphy_rx_pins_0_pin4,
    xiphy_rx_pins_0_pin40,
    xiphy_rx_pins_0_pin41,
    xiphy_rx_pins_0_pin42,
    xiphy_rx_pins_0_pin43,
    xiphy_rx_pins_0_pin44,
    xiphy_rx_pins_0_pin45,
    xiphy_rx_pins_0_pin46,
    xiphy_rx_pins_0_pin47,
    xiphy_rx_pins_0_pin48,
    xiphy_rx_pins_0_pin49,
    xiphy_rx_pins_0_pin5,
    xiphy_rx_pins_0_pin50,
    xiphy_rx_pins_0_pin6,
    xiphy_rx_pins_0_pin7,
    xiphy_rx_pins_0_pin8,
    xiphy_rx_pins_0_pin9,
    xiphy_rx_pins_1_pin0,
    xiphy_rx_pins_1_pin1,
    xiphy_rx_pins_1_pin10,
    xiphy_rx_pins_1_pin11,
    xiphy_rx_pins_1_pin13,
    xiphy_rx_pins_1_pin14,
    xiphy_rx_pins_1_pin15,
    xiphy_rx_pins_1_pin16,
    xiphy_rx_pins_1_pin17,
    xiphy_rx_pins_1_pin18,
    xiphy_rx_pins_1_pin19,
    xiphy_rx_pins_1_pin2,
    xiphy_rx_pins_1_pin20,
    xiphy_rx_pins_1_pin21,
    xiphy_rx_pins_1_pin22,
    xiphy_rx_pins_1_pin23,
    xiphy_rx_pins_1_pin24,
    xiphy_rx_pins_1_pin26,
    xiphy_rx_pins_1_pin27,
    xiphy_rx_pins_1_pin28,
    xiphy_rx_pins_1_pin29,
    xiphy_rx_pins_1_pin3,
    xiphy_rx_pins_1_pin30,
    xiphy_rx_pins_1_pin31,
    xiphy_rx_pins_1_pin32,
    xiphy_rx_pins_1_pin33,
    xiphy_rx_pins_1_pin34,
    xiphy_rx_pins_1_pin35,
    xiphy_rx_pins_1_pin36,
    xiphy_rx_pins_1_pin37,
    xiphy_rx_pins_1_pin39,
    xiphy_rx_pins_1_pin4,
    xiphy_rx_pins_1_pin40,
    xiphy_rx_pins_1_pin41,
    xiphy_rx_pins_1_pin42,
    xiphy_rx_pins_1_pin43,
    xiphy_rx_pins_1_pin44,
    xiphy_rx_pins_1_pin45,
    xiphy_rx_pins_1_pin46,
    xiphy_rx_pins_1_pin47,
    xiphy_rx_pins_1_pin48,
    xiphy_rx_pins_1_pin49,
    xiphy_rx_pins_1_pin5,
    xiphy_rx_pins_1_pin50,
    xiphy_rx_pins_1_pin6,
    xiphy_rx_pins_1_pin7,
    xiphy_rx_pins_1_pin8,
    xiphy_rx_pins_1_pin9,
    xiphy_rx_pins_2_pin0,
    xiphy_rx_pins_2_pin1,
    xiphy_rx_pins_2_pin10,
    xiphy_rx_pins_2_pin11,
    xiphy_rx_pins_2_pin13,
    xiphy_rx_pins_2_pin14,
    xiphy_rx_pins_2_pin15,
    xiphy_rx_pins_2_pin16,
    xiphy_rx_pins_2_pin17,
    xiphy_rx_pins_2_pin18,
    xiphy_rx_pins_2_pin19,
    xiphy_rx_pins_2_pin2,
    xiphy_rx_pins_2_pin20,
    xiphy_rx_pins_2_pin21,
    xiphy_rx_pins_2_pin22,
    xiphy_rx_pins_2_pin23,
    xiphy_rx_pins_2_pin24,
    xiphy_rx_pins_2_pin26,
    xiphy_rx_pins_2_pin27,
    xiphy_rx_pins_2_pin28,
    xiphy_rx_pins_2_pin29,
    xiphy_rx_pins_2_pin3,
    xiphy_rx_pins_2_pin30,
    xiphy_rx_pins_2_pin31,
    xiphy_rx_pins_2_pin32,
    xiphy_rx_pins_2_pin33,
    xiphy_rx_pins_2_pin34,
    xiphy_rx_pins_2_pin35,
    xiphy_rx_pins_2_pin36,
    xiphy_rx_pins_2_pin37,
    xiphy_rx_pins_2_pin39,
    xiphy_rx_pins_2_pin4,
    xiphy_rx_pins_2_pin40,
    xiphy_rx_pins_2_pin41,
    xiphy_rx_pins_2_pin42,
    xiphy_rx_pins_2_pin43,
    xiphy_rx_pins_2_pin44,
    xiphy_rx_pins_2_pin45,
    xiphy_rx_pins_2_pin46,
    xiphy_rx_pins_2_pin47,
    xiphy_rx_pins_2_pin48,
    xiphy_rx_pins_2_pin49,
    xiphy_rx_pins_2_pin5,
    xiphy_rx_pins_2_pin50,
    xiphy_rx_pins_2_pin6,
    xiphy_rx_pins_2_pin7,
    xiphy_rx_pins_2_pin8,
    xiphy_rx_pins_2_pin9,
    xiphy_rx_pins_3_pin0,
    xiphy_rx_pins_3_pin1,
    xiphy_rx_pins_3_pin10,
    xiphy_rx_pins_3_pin11,
    xiphy_rx_pins_3_pin13,
    xiphy_rx_pins_3_pin14,
    xiphy_rx_pins_3_pin15,
    xiphy_rx_pins_3_pin16,
    xiphy_rx_pins_3_pin17,
    xiphy_rx_pins_3_pin18,
    xiphy_rx_pins_3_pin19,
    xiphy_rx_pins_3_pin2,
    xiphy_rx_pins_3_pin20,
    xiphy_rx_pins_3_pin21,
    xiphy_rx_pins_3_pin22,
    xiphy_rx_pins_3_pin23,
    xiphy_rx_pins_3_pin24,
    xiphy_rx_pins_3_pin26,
    xiphy_rx_pins_3_pin27,
    xiphy_rx_pins_3_pin28,
    xiphy_rx_pins_3_pin29,
    xiphy_rx_pins_3_pin3,
    xiphy_rx_pins_3_pin30,
    xiphy_rx_pins_3_pin31,
    xiphy_rx_pins_3_pin32,
    xiphy_rx_pins_3_pin33,
    xiphy_rx_pins_3_pin34,
    xiphy_rx_pins_3_pin35,
    xiphy_rx_pins_3_pin36,
    xiphy_rx_pins_3_pin37,
    xiphy_rx_pins_3_pin39,
    xiphy_rx_pins_3_pin4,
    xiphy_rx_pins_3_pin40,
    xiphy_rx_pins_3_pin41,
    xiphy_rx_pins_3_pin42,
    xiphy_rx_pins_3_pin43,
    xiphy_rx_pins_3_pin44,
    xiphy_rx_pins_3_pin45,
    xiphy_rx_pins_3_pin46,
    xiphy_rx_pins_3_pin47,
    xiphy_rx_pins_3_pin48,
    xiphy_rx_pins_3_pin49,
    xiphy_rx_pins_3_pin5,
    xiphy_rx_pins_3_pin50,
    xiphy_rx_pins_3_pin6,
    xiphy_rx_pins_3_pin7,
    xiphy_rx_pins_3_pin8,
    xiphy_rx_pins_3_pin9);
  input C0_SYS_CLK_0_clk_n;
  input C0_SYS_CLK_0_clk_p;
  output [0:0]CDCI6214_EEPROM_SEL_0;
  output [0:0]CDCI6214_OE_0;
  output [0:0]CDCI6214_REF_SEL_0;
  output [0:0]CDCI6214_RESETN_0;
  input CDCI6214_STATUS_0;
  input [3:0]GPI_0;
  output [3:0]GPO_0;
  inout IIC_CDCI6214_0_scl_io;
  inout IIC_CDCI6214_0_sda_io;
  inout IIC_SFP1_0_scl_io;
  inout IIC_SFP1_0_sda_io;
  inout IIC_SFP2_0_scl_io;
  inout IIC_SFP2_0_sda_io;
  output [7:0]LADC_CTRL1_0;
  output [7:0]LADC_CTRL2_0;
  output [0:0]LADC_RESET_0;
  output [7:0]LADC_SEN_0;
  input [1:0]LEMO;
  input [0:0]PL_SYSREF_clk_n;
  input [0:0]PL_SYSREF_clk_p;
  input [0:0]PL_SYSTEM_CLK_clk_n;
  input [0:0]PL_SYSTEM_CLK_clk_p;
  input SFP1_MOD_ABS_0;
  output [0:0]SFP1_RS0_0;
  output [0:0]SFP1_RS1_0;
  input SFP1_RX_LOS_0;
  output [0:0]SFP1_TX_DISABLE_0;
  input SFP1_TX_FAULT_0;
  input SFP2_MOD_ABS_0;
  output [0:0]SFP2_RS0_0;
  output [0:0]SFP2_RS1_0;
  input SFP2_RX_LOS_0;
  output [0:0]SFP2_TX_DISABLE_0;
  input SFP2_TX_FAULT_0;
  inout SPI_BASEDAC_0_io0_io;
  inout SPI_BASEDAC_0_io1_io;
  inout SPI_BASEDAC_0_sck_io;
  inout [0:0]SPI_BASEDAC_0_ss_io;
  inout SPI_LADC_0_io0_io;
  inout SPI_LADC_0_io1_io;
  inout SPI_LADC_0_sck_io;
  inout [0:0]SPI_LADC_0_ss_io;
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
  input dac1_clk_clk_n;
  input dac1_clk_clk_p;
  input dac2_clk_clk_n;
  input dac2_clk_clk_p;
  input dac3_clk_clk_n;
  input dac3_clk_clk_p;
  output ddr4_rtl_0_act_n;
  output [16:0]ddr4_rtl_0_adr;
  output [1:0]ddr4_rtl_0_ba;
  output [1:0]ddr4_rtl_0_bg;
  output [0:0]ddr4_rtl_0_ck_c;
  output [0:0]ddr4_rtl_0_ck_t;
  output [0:0]ddr4_rtl_0_cke;
  output [0:0]ddr4_rtl_0_cs_n;
  inout [3:0]ddr4_rtl_0_dm_n;
  inout [31:0]ddr4_rtl_0_dq;
  inout [3:0]ddr4_rtl_0_dqs_c;
  inout [3:0]ddr4_rtl_0_dqs_t;
  output [0:0]ddr4_rtl_0_odt;
  output ddr4_rtl_0_reset_n;
  input sys_rst_0;
  input sysref_in_diff_n;
  input sysref_in_diff_p;
  input vin00_v_n;
  input vin00_v_p;
  input vin01_v_n;
  input vin01_v_p;
  input vin02_v_n;
  input vin02_v_p;
  input vin03_v_n;
  input vin03_v_p;
  input vin10_v_n;
  input vin10_v_p;
  input vin11_v_n;
  input vin11_v_p;
  input vin12_v_n;
  input vin12_v_p;
  input vin13_v_n;
  input vin13_v_p;
  input vin20_v_n;
  input vin20_v_p;
  input vin21_v_n;
  input vin21_v_p;
  input vin22_v_n;
  input vin22_v_p;
  input vin23_v_n;
  input vin23_v_p;
  input vin30_v_n;
  input vin30_v_p;
  input vin31_v_n;
  input vin31_v_p;
  input vin32_v_n;
  input vin32_v_p;
  input vin33_v_n;
  input vin33_v_p;
  output vout00_v_n;
  output vout00_v_p;
  output vout01_v_n;
  output vout01_v_p;
  output vout02_v_n;
  output vout02_v_p;
  output vout03_v_n;
  output vout03_v_p;
  output vout10_v_n;
  output vout10_v_p;
  output vout11_v_n;
  output vout11_v_p;
  output vout12_v_n;
  output vout12_v_p;
  output vout13_v_n;
  output vout13_v_p;
  output vout20_v_n;
  output vout20_v_p;
  output vout21_v_n;
  output vout21_v_p;
  output vout22_v_n;
  output vout22_v_p;
  output vout23_v_n;
  output vout23_v_p;
  output vout30_v_n;
  output vout30_v_p;
  output vout31_v_n;
  output vout31_v_p;
  output vout32_v_n;
  output vout32_v_p;
  output vout33_v_n;
  output vout33_v_p;
  input xiphy_rx_pins_0_pin0;
  input xiphy_rx_pins_0_pin1;
  input xiphy_rx_pins_0_pin10;
  input xiphy_rx_pins_0_pin11;
  input xiphy_rx_pins_0_pin13;
  input xiphy_rx_pins_0_pin14;
  input xiphy_rx_pins_0_pin15;
  input xiphy_rx_pins_0_pin16;
  input xiphy_rx_pins_0_pin17;
  input xiphy_rx_pins_0_pin18;
  input xiphy_rx_pins_0_pin19;
  input xiphy_rx_pins_0_pin2;
  input xiphy_rx_pins_0_pin20;
  input xiphy_rx_pins_0_pin21;
  input xiphy_rx_pins_0_pin22;
  input xiphy_rx_pins_0_pin23;
  input xiphy_rx_pins_0_pin24;
  input xiphy_rx_pins_0_pin26;
  input xiphy_rx_pins_0_pin27;
  input xiphy_rx_pins_0_pin28;
  input xiphy_rx_pins_0_pin29;
  input xiphy_rx_pins_0_pin3;
  input xiphy_rx_pins_0_pin30;
  input xiphy_rx_pins_0_pin31;
  input xiphy_rx_pins_0_pin32;
  input xiphy_rx_pins_0_pin33;
  input xiphy_rx_pins_0_pin34;
  input xiphy_rx_pins_0_pin35;
  input xiphy_rx_pins_0_pin36;
  input xiphy_rx_pins_0_pin37;
  input xiphy_rx_pins_0_pin39;
  input xiphy_rx_pins_0_pin4;
  input xiphy_rx_pins_0_pin40;
  input xiphy_rx_pins_0_pin41;
  input xiphy_rx_pins_0_pin42;
  input xiphy_rx_pins_0_pin43;
  input xiphy_rx_pins_0_pin44;
  input xiphy_rx_pins_0_pin45;
  input xiphy_rx_pins_0_pin46;
  input xiphy_rx_pins_0_pin47;
  input xiphy_rx_pins_0_pin48;
  input xiphy_rx_pins_0_pin49;
  input xiphy_rx_pins_0_pin5;
  input xiphy_rx_pins_0_pin50;
  input xiphy_rx_pins_0_pin6;
  input xiphy_rx_pins_0_pin7;
  input xiphy_rx_pins_0_pin8;
  input xiphy_rx_pins_0_pin9;
  input xiphy_rx_pins_1_pin0;
  input xiphy_rx_pins_1_pin1;
  input xiphy_rx_pins_1_pin10;
  input xiphy_rx_pins_1_pin11;
  input xiphy_rx_pins_1_pin13;
  input xiphy_rx_pins_1_pin14;
  input xiphy_rx_pins_1_pin15;
  input xiphy_rx_pins_1_pin16;
  input xiphy_rx_pins_1_pin17;
  input xiphy_rx_pins_1_pin18;
  input xiphy_rx_pins_1_pin19;
  input xiphy_rx_pins_1_pin2;
  input xiphy_rx_pins_1_pin20;
  input xiphy_rx_pins_1_pin21;
  input xiphy_rx_pins_1_pin22;
  input xiphy_rx_pins_1_pin23;
  input xiphy_rx_pins_1_pin24;
  input xiphy_rx_pins_1_pin26;
  input xiphy_rx_pins_1_pin27;
  input xiphy_rx_pins_1_pin28;
  input xiphy_rx_pins_1_pin29;
  input xiphy_rx_pins_1_pin3;
  input xiphy_rx_pins_1_pin30;
  input xiphy_rx_pins_1_pin31;
  input xiphy_rx_pins_1_pin32;
  input xiphy_rx_pins_1_pin33;
  input xiphy_rx_pins_1_pin34;
  input xiphy_rx_pins_1_pin35;
  input xiphy_rx_pins_1_pin36;
  input xiphy_rx_pins_1_pin37;
  input xiphy_rx_pins_1_pin39;
  input xiphy_rx_pins_1_pin4;
  input xiphy_rx_pins_1_pin40;
  input xiphy_rx_pins_1_pin41;
  input xiphy_rx_pins_1_pin42;
  input xiphy_rx_pins_1_pin43;
  input xiphy_rx_pins_1_pin44;
  input xiphy_rx_pins_1_pin45;
  input xiphy_rx_pins_1_pin46;
  input xiphy_rx_pins_1_pin47;
  input xiphy_rx_pins_1_pin48;
  input xiphy_rx_pins_1_pin49;
  input xiphy_rx_pins_1_pin5;
  input xiphy_rx_pins_1_pin50;
  input xiphy_rx_pins_1_pin6;
  input xiphy_rx_pins_1_pin7;
  input xiphy_rx_pins_1_pin8;
  input xiphy_rx_pins_1_pin9;
  input xiphy_rx_pins_2_pin0;
  input xiphy_rx_pins_2_pin1;
  input xiphy_rx_pins_2_pin10;
  input xiphy_rx_pins_2_pin11;
  input xiphy_rx_pins_2_pin13;
  input xiphy_rx_pins_2_pin14;
  input xiphy_rx_pins_2_pin15;
  input xiphy_rx_pins_2_pin16;
  input xiphy_rx_pins_2_pin17;
  input xiphy_rx_pins_2_pin18;
  input xiphy_rx_pins_2_pin19;
  input xiphy_rx_pins_2_pin2;
  input xiphy_rx_pins_2_pin20;
  input xiphy_rx_pins_2_pin21;
  input xiphy_rx_pins_2_pin22;
  input xiphy_rx_pins_2_pin23;
  input xiphy_rx_pins_2_pin24;
  input xiphy_rx_pins_2_pin26;
  input xiphy_rx_pins_2_pin27;
  input xiphy_rx_pins_2_pin28;
  input xiphy_rx_pins_2_pin29;
  input xiphy_rx_pins_2_pin3;
  input xiphy_rx_pins_2_pin30;
  input xiphy_rx_pins_2_pin31;
  input xiphy_rx_pins_2_pin32;
  input xiphy_rx_pins_2_pin33;
  input xiphy_rx_pins_2_pin34;
  input xiphy_rx_pins_2_pin35;
  input xiphy_rx_pins_2_pin36;
  input xiphy_rx_pins_2_pin37;
  input xiphy_rx_pins_2_pin39;
  input xiphy_rx_pins_2_pin4;
  input xiphy_rx_pins_2_pin40;
  input xiphy_rx_pins_2_pin41;
  input xiphy_rx_pins_2_pin42;
  input xiphy_rx_pins_2_pin43;
  input xiphy_rx_pins_2_pin44;
  input xiphy_rx_pins_2_pin45;
  input xiphy_rx_pins_2_pin46;
  input xiphy_rx_pins_2_pin47;
  input xiphy_rx_pins_2_pin48;
  input xiphy_rx_pins_2_pin49;
  input xiphy_rx_pins_2_pin5;
  input xiphy_rx_pins_2_pin50;
  input xiphy_rx_pins_2_pin6;
  input xiphy_rx_pins_2_pin7;
  input xiphy_rx_pins_2_pin8;
  input xiphy_rx_pins_2_pin9;
  input xiphy_rx_pins_3_pin0;
  input xiphy_rx_pins_3_pin1;
  input xiphy_rx_pins_3_pin10;
  input xiphy_rx_pins_3_pin11;
  input xiphy_rx_pins_3_pin13;
  input xiphy_rx_pins_3_pin14;
  input xiphy_rx_pins_3_pin15;
  input xiphy_rx_pins_3_pin16;
  input xiphy_rx_pins_3_pin17;
  input xiphy_rx_pins_3_pin18;
  input xiphy_rx_pins_3_pin19;
  input xiphy_rx_pins_3_pin2;
  input xiphy_rx_pins_3_pin20;
  input xiphy_rx_pins_3_pin21;
  input xiphy_rx_pins_3_pin22;
  input xiphy_rx_pins_3_pin23;
  input xiphy_rx_pins_3_pin24;
  input xiphy_rx_pins_3_pin26;
  input xiphy_rx_pins_3_pin27;
  input xiphy_rx_pins_3_pin28;
  input xiphy_rx_pins_3_pin29;
  input xiphy_rx_pins_3_pin3;
  input xiphy_rx_pins_3_pin30;
  input xiphy_rx_pins_3_pin31;
  input xiphy_rx_pins_3_pin32;
  input xiphy_rx_pins_3_pin33;
  input xiphy_rx_pins_3_pin34;
  input xiphy_rx_pins_3_pin35;
  input xiphy_rx_pins_3_pin36;
  input xiphy_rx_pins_3_pin37;
  input xiphy_rx_pins_3_pin39;
  input xiphy_rx_pins_3_pin4;
  input xiphy_rx_pins_3_pin40;
  input xiphy_rx_pins_3_pin41;
  input xiphy_rx_pins_3_pin42;
  input xiphy_rx_pins_3_pin43;
  input xiphy_rx_pins_3_pin44;
  input xiphy_rx_pins_3_pin45;
  input xiphy_rx_pins_3_pin46;
  input xiphy_rx_pins_3_pin47;
  input xiphy_rx_pins_3_pin48;
  input xiphy_rx_pins_3_pin49;
  input xiphy_rx_pins_3_pin5;
  input xiphy_rx_pins_3_pin50;
  input xiphy_rx_pins_3_pin6;
  input xiphy_rx_pins_3_pin7;
  input xiphy_rx_pins_3_pin8;
  input xiphy_rx_pins_3_pin9;

  wire C0_SYS_CLK_0_clk_n;
  wire C0_SYS_CLK_0_clk_p;
  wire [0:0]CDCI6214_EEPROM_SEL_0;
  wire [0:0]CDCI6214_OE_0;
  wire [0:0]CDCI6214_REF_SEL_0;
  wire [0:0]CDCI6214_RESETN_0;
  wire CDCI6214_STATUS_0;
  wire [3:0]GPI_0;
  wire [3:0]GPO_0;
  wire IIC_CDCI6214_0_scl_i;
  wire IIC_CDCI6214_0_scl_io;
  wire IIC_CDCI6214_0_scl_o;
  wire IIC_CDCI6214_0_scl_t;
  wire IIC_CDCI6214_0_sda_i;
  wire IIC_CDCI6214_0_sda_io;
  wire IIC_CDCI6214_0_sda_o;
  wire IIC_CDCI6214_0_sda_t;
  wire IIC_SFP1_0_scl_i;
  wire IIC_SFP1_0_scl_io;
  wire IIC_SFP1_0_scl_o;
  wire IIC_SFP1_0_scl_t;
  wire IIC_SFP1_0_sda_i;
  wire IIC_SFP1_0_sda_io;
  wire IIC_SFP1_0_sda_o;
  wire IIC_SFP1_0_sda_t;
  wire IIC_SFP2_0_scl_i;
  wire IIC_SFP2_0_scl_io;
  wire IIC_SFP2_0_scl_o;
  wire IIC_SFP2_0_scl_t;
  wire IIC_SFP2_0_sda_i;
  wire IIC_SFP2_0_sda_io;
  wire IIC_SFP2_0_sda_o;
  wire IIC_SFP2_0_sda_t;
  wire [7:0]LADC_CTRL1_0;
  wire [7:0]LADC_CTRL2_0;
  wire [0:0]LADC_RESET_0;
  wire [7:0]LADC_SEN_0;
  wire [1:0]LEMO;
  wire [0:0]PL_SYSREF_clk_n;
  wire [0:0]PL_SYSREF_clk_p;
  wire [0:0]PL_SYSTEM_CLK_clk_n;
  wire [0:0]PL_SYSTEM_CLK_clk_p;
  wire SFP1_MOD_ABS_0;
  wire [0:0]SFP1_RS0_0;
  wire [0:0]SFP1_RS1_0;
  wire SFP1_RX_LOS_0;
  wire [0:0]SFP1_TX_DISABLE_0;
  wire SFP1_TX_FAULT_0;
  wire SFP2_MOD_ABS_0;
  wire [0:0]SFP2_RS0_0;
  wire [0:0]SFP2_RS1_0;
  wire SFP2_RX_LOS_0;
  wire [0:0]SFP2_TX_DISABLE_0;
  wire SFP2_TX_FAULT_0;
  wire SPI_BASEDAC_0_io0_i;
  wire SPI_BASEDAC_0_io0_io;
  wire SPI_BASEDAC_0_io0_o;
  wire SPI_BASEDAC_0_io0_t;
  wire SPI_BASEDAC_0_io1_i;
  wire SPI_BASEDAC_0_io1_io;
  wire SPI_BASEDAC_0_io1_o;
  wire SPI_BASEDAC_0_io1_t;
  wire SPI_BASEDAC_0_sck_i;
  wire SPI_BASEDAC_0_sck_io;
  wire SPI_BASEDAC_0_sck_o;
  wire SPI_BASEDAC_0_sck_t;
  wire [0:0]SPI_BASEDAC_0_ss_i_0;
  wire [0:0]SPI_BASEDAC_0_ss_io_0;
  wire [0:0]SPI_BASEDAC_0_ss_o_0;
  wire SPI_BASEDAC_0_ss_t;
  wire SPI_LADC_0_io0_i;
  wire SPI_LADC_0_io0_io;
  wire SPI_LADC_0_io0_o;
  wire SPI_LADC_0_io0_t;
  wire SPI_LADC_0_io1_i;
  wire SPI_LADC_0_io1_io;
  wire SPI_LADC_0_io1_o;
  wire SPI_LADC_0_io1_t;
  wire SPI_LADC_0_sck_i;
  wire SPI_LADC_0_sck_io;
  wire SPI_LADC_0_sck_o;
  wire SPI_LADC_0_sck_t;
  wire [0:0]SPI_LADC_0_ss_i_0;
  wire [0:0]SPI_LADC_0_ss_io_0;
  wire [0:0]SPI_LADC_0_ss_o_0;
  wire SPI_LADC_0_ss_t;
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
  wire dac1_clk_clk_n;
  wire dac1_clk_clk_p;
  wire dac2_clk_clk_n;
  wire dac2_clk_clk_p;
  wire dac3_clk_clk_n;
  wire dac3_clk_clk_p;
  wire ddr4_rtl_0_act_n;
  wire [16:0]ddr4_rtl_0_adr;
  wire [1:0]ddr4_rtl_0_ba;
  wire [1:0]ddr4_rtl_0_bg;
  wire [0:0]ddr4_rtl_0_ck_c;
  wire [0:0]ddr4_rtl_0_ck_t;
  wire [0:0]ddr4_rtl_0_cke;
  wire [0:0]ddr4_rtl_0_cs_n;
  wire [3:0]ddr4_rtl_0_dm_n;
  wire [31:0]ddr4_rtl_0_dq;
  wire [3:0]ddr4_rtl_0_dqs_c;
  wire [3:0]ddr4_rtl_0_dqs_t;
  wire [0:0]ddr4_rtl_0_odt;
  wire ddr4_rtl_0_reset_n;
  wire sys_rst_0;
  wire sysref_in_diff_n;
  wire sysref_in_diff_p;
  wire vin00_v_n;
  wire vin00_v_p;
  wire vin01_v_n;
  wire vin01_v_p;
  wire vin02_v_n;
  wire vin02_v_p;
  wire vin03_v_n;
  wire vin03_v_p;
  wire vin10_v_n;
  wire vin10_v_p;
  wire vin11_v_n;
  wire vin11_v_p;
  wire vin12_v_n;
  wire vin12_v_p;
  wire vin13_v_n;
  wire vin13_v_p;
  wire vin20_v_n;
  wire vin20_v_p;
  wire vin21_v_n;
  wire vin21_v_p;
  wire vin22_v_n;
  wire vin22_v_p;
  wire vin23_v_n;
  wire vin23_v_p;
  wire vin30_v_n;
  wire vin30_v_p;
  wire vin31_v_n;
  wire vin31_v_p;
  wire vin32_v_n;
  wire vin32_v_p;
  wire vin33_v_n;
  wire vin33_v_p;
  wire vout00_v_n;
  wire vout00_v_p;
  wire vout01_v_n;
  wire vout01_v_p;
  wire vout02_v_n;
  wire vout02_v_p;
  wire vout03_v_n;
  wire vout03_v_p;
  wire vout10_v_n;
  wire vout10_v_p;
  wire vout11_v_n;
  wire vout11_v_p;
  wire vout12_v_n;
  wire vout12_v_p;
  wire vout13_v_n;
  wire vout13_v_p;
  wire vout20_v_n;
  wire vout20_v_p;
  wire vout21_v_n;
  wire vout21_v_p;
  wire vout22_v_n;
  wire vout22_v_p;
  wire vout23_v_n;
  wire vout23_v_p;
  wire vout30_v_n;
  wire vout30_v_p;
  wire vout31_v_n;
  wire vout31_v_p;
  wire vout32_v_n;
  wire vout32_v_p;
  wire vout33_v_n;
  wire vout33_v_p;
  wire xiphy_rx_pins_0_pin0;
  wire xiphy_rx_pins_0_pin1;
  wire xiphy_rx_pins_0_pin10;
  wire xiphy_rx_pins_0_pin11;
  wire xiphy_rx_pins_0_pin13;
  wire xiphy_rx_pins_0_pin14;
  wire xiphy_rx_pins_0_pin15;
  wire xiphy_rx_pins_0_pin16;
  wire xiphy_rx_pins_0_pin17;
  wire xiphy_rx_pins_0_pin18;
  wire xiphy_rx_pins_0_pin19;
  wire xiphy_rx_pins_0_pin2;
  wire xiphy_rx_pins_0_pin20;
  wire xiphy_rx_pins_0_pin21;
  wire xiphy_rx_pins_0_pin22;
  wire xiphy_rx_pins_0_pin23;
  wire xiphy_rx_pins_0_pin24;
  wire xiphy_rx_pins_0_pin26;
  wire xiphy_rx_pins_0_pin27;
  wire xiphy_rx_pins_0_pin28;
  wire xiphy_rx_pins_0_pin29;
  wire xiphy_rx_pins_0_pin3;
  wire xiphy_rx_pins_0_pin30;
  wire xiphy_rx_pins_0_pin31;
  wire xiphy_rx_pins_0_pin32;
  wire xiphy_rx_pins_0_pin33;
  wire xiphy_rx_pins_0_pin34;
  wire xiphy_rx_pins_0_pin35;
  wire xiphy_rx_pins_0_pin36;
  wire xiphy_rx_pins_0_pin37;
  wire xiphy_rx_pins_0_pin39;
  wire xiphy_rx_pins_0_pin4;
  wire xiphy_rx_pins_0_pin40;
  wire xiphy_rx_pins_0_pin41;
  wire xiphy_rx_pins_0_pin42;
  wire xiphy_rx_pins_0_pin43;
  wire xiphy_rx_pins_0_pin44;
  wire xiphy_rx_pins_0_pin45;
  wire xiphy_rx_pins_0_pin46;
  wire xiphy_rx_pins_0_pin47;
  wire xiphy_rx_pins_0_pin48;
  wire xiphy_rx_pins_0_pin49;
  wire xiphy_rx_pins_0_pin5;
  wire xiphy_rx_pins_0_pin50;
  wire xiphy_rx_pins_0_pin6;
  wire xiphy_rx_pins_0_pin7;
  wire xiphy_rx_pins_0_pin8;
  wire xiphy_rx_pins_0_pin9;
  wire xiphy_rx_pins_1_pin0;
  wire xiphy_rx_pins_1_pin1;
  wire xiphy_rx_pins_1_pin10;
  wire xiphy_rx_pins_1_pin11;
  wire xiphy_rx_pins_1_pin13;
  wire xiphy_rx_pins_1_pin14;
  wire xiphy_rx_pins_1_pin15;
  wire xiphy_rx_pins_1_pin16;
  wire xiphy_rx_pins_1_pin17;
  wire xiphy_rx_pins_1_pin18;
  wire xiphy_rx_pins_1_pin19;
  wire xiphy_rx_pins_1_pin2;
  wire xiphy_rx_pins_1_pin20;
  wire xiphy_rx_pins_1_pin21;
  wire xiphy_rx_pins_1_pin22;
  wire xiphy_rx_pins_1_pin23;
  wire xiphy_rx_pins_1_pin24;
  wire xiphy_rx_pins_1_pin26;
  wire xiphy_rx_pins_1_pin27;
  wire xiphy_rx_pins_1_pin28;
  wire xiphy_rx_pins_1_pin29;
  wire xiphy_rx_pins_1_pin3;
  wire xiphy_rx_pins_1_pin30;
  wire xiphy_rx_pins_1_pin31;
  wire xiphy_rx_pins_1_pin32;
  wire xiphy_rx_pins_1_pin33;
  wire xiphy_rx_pins_1_pin34;
  wire xiphy_rx_pins_1_pin35;
  wire xiphy_rx_pins_1_pin36;
  wire xiphy_rx_pins_1_pin37;
  wire xiphy_rx_pins_1_pin39;
  wire xiphy_rx_pins_1_pin4;
  wire xiphy_rx_pins_1_pin40;
  wire xiphy_rx_pins_1_pin41;
  wire xiphy_rx_pins_1_pin42;
  wire xiphy_rx_pins_1_pin43;
  wire xiphy_rx_pins_1_pin44;
  wire xiphy_rx_pins_1_pin45;
  wire xiphy_rx_pins_1_pin46;
  wire xiphy_rx_pins_1_pin47;
  wire xiphy_rx_pins_1_pin48;
  wire xiphy_rx_pins_1_pin49;
  wire xiphy_rx_pins_1_pin5;
  wire xiphy_rx_pins_1_pin50;
  wire xiphy_rx_pins_1_pin6;
  wire xiphy_rx_pins_1_pin7;
  wire xiphy_rx_pins_1_pin8;
  wire xiphy_rx_pins_1_pin9;
  wire xiphy_rx_pins_2_pin0;
  wire xiphy_rx_pins_2_pin1;
  wire xiphy_rx_pins_2_pin10;
  wire xiphy_rx_pins_2_pin11;
  wire xiphy_rx_pins_2_pin13;
  wire xiphy_rx_pins_2_pin14;
  wire xiphy_rx_pins_2_pin15;
  wire xiphy_rx_pins_2_pin16;
  wire xiphy_rx_pins_2_pin17;
  wire xiphy_rx_pins_2_pin18;
  wire xiphy_rx_pins_2_pin19;
  wire xiphy_rx_pins_2_pin2;
  wire xiphy_rx_pins_2_pin20;
  wire xiphy_rx_pins_2_pin21;
  wire xiphy_rx_pins_2_pin22;
  wire xiphy_rx_pins_2_pin23;
  wire xiphy_rx_pins_2_pin24;
  wire xiphy_rx_pins_2_pin26;
  wire xiphy_rx_pins_2_pin27;
  wire xiphy_rx_pins_2_pin28;
  wire xiphy_rx_pins_2_pin29;
  wire xiphy_rx_pins_2_pin3;
  wire xiphy_rx_pins_2_pin30;
  wire xiphy_rx_pins_2_pin31;
  wire xiphy_rx_pins_2_pin32;
  wire xiphy_rx_pins_2_pin33;
  wire xiphy_rx_pins_2_pin34;
  wire xiphy_rx_pins_2_pin35;
  wire xiphy_rx_pins_2_pin36;
  wire xiphy_rx_pins_2_pin37;
  wire xiphy_rx_pins_2_pin39;
  wire xiphy_rx_pins_2_pin4;
  wire xiphy_rx_pins_2_pin40;
  wire xiphy_rx_pins_2_pin41;
  wire xiphy_rx_pins_2_pin42;
  wire xiphy_rx_pins_2_pin43;
  wire xiphy_rx_pins_2_pin44;
  wire xiphy_rx_pins_2_pin45;
  wire xiphy_rx_pins_2_pin46;
  wire xiphy_rx_pins_2_pin47;
  wire xiphy_rx_pins_2_pin48;
  wire xiphy_rx_pins_2_pin49;
  wire xiphy_rx_pins_2_pin5;
  wire xiphy_rx_pins_2_pin50;
  wire xiphy_rx_pins_2_pin6;
  wire xiphy_rx_pins_2_pin7;
  wire xiphy_rx_pins_2_pin8;
  wire xiphy_rx_pins_2_pin9;
  wire xiphy_rx_pins_3_pin0;
  wire xiphy_rx_pins_3_pin1;
  wire xiphy_rx_pins_3_pin10;
  wire xiphy_rx_pins_3_pin11;
  wire xiphy_rx_pins_3_pin13;
  wire xiphy_rx_pins_3_pin14;
  wire xiphy_rx_pins_3_pin15;
  wire xiphy_rx_pins_3_pin16;
  wire xiphy_rx_pins_3_pin17;
  wire xiphy_rx_pins_3_pin18;
  wire xiphy_rx_pins_3_pin19;
  wire xiphy_rx_pins_3_pin2;
  wire xiphy_rx_pins_3_pin20;
  wire xiphy_rx_pins_3_pin21;
  wire xiphy_rx_pins_3_pin22;
  wire xiphy_rx_pins_3_pin23;
  wire xiphy_rx_pins_3_pin24;
  wire xiphy_rx_pins_3_pin26;
  wire xiphy_rx_pins_3_pin27;
  wire xiphy_rx_pins_3_pin28;
  wire xiphy_rx_pins_3_pin29;
  wire xiphy_rx_pins_3_pin3;
  wire xiphy_rx_pins_3_pin30;
  wire xiphy_rx_pins_3_pin31;
  wire xiphy_rx_pins_3_pin32;
  wire xiphy_rx_pins_3_pin33;
  wire xiphy_rx_pins_3_pin34;
  wire xiphy_rx_pins_3_pin35;
  wire xiphy_rx_pins_3_pin36;
  wire xiphy_rx_pins_3_pin37;
  wire xiphy_rx_pins_3_pin39;
  wire xiphy_rx_pins_3_pin4;
  wire xiphy_rx_pins_3_pin40;
  wire xiphy_rx_pins_3_pin41;
  wire xiphy_rx_pins_3_pin42;
  wire xiphy_rx_pins_3_pin43;
  wire xiphy_rx_pins_3_pin44;
  wire xiphy_rx_pins_3_pin45;
  wire xiphy_rx_pins_3_pin46;
  wire xiphy_rx_pins_3_pin47;
  wire xiphy_rx_pins_3_pin48;
  wire xiphy_rx_pins_3_pin49;
  wire xiphy_rx_pins_3_pin5;
  wire xiphy_rx_pins_3_pin50;
  wire xiphy_rx_pins_3_pin6;
  wire xiphy_rx_pins_3_pin7;
  wire xiphy_rx_pins_3_pin8;
  wire xiphy_rx_pins_3_pin9;

  IOBUF IIC_CDCI6214_0_scl_iobuf
       (.I(IIC_CDCI6214_0_scl_o),
        .IO(IIC_CDCI6214_0_scl_io),
        .O(IIC_CDCI6214_0_scl_i),
        .T(IIC_CDCI6214_0_scl_t));
  IOBUF IIC_CDCI6214_0_sda_iobuf
       (.I(IIC_CDCI6214_0_sda_o),
        .IO(IIC_CDCI6214_0_sda_io),
        .O(IIC_CDCI6214_0_sda_i),
        .T(IIC_CDCI6214_0_sda_t));
  IOBUF IIC_SFP1_0_scl_iobuf
       (.I(IIC_SFP1_0_scl_o),
        .IO(IIC_SFP1_0_scl_io),
        .O(IIC_SFP1_0_scl_i),
        .T(IIC_SFP1_0_scl_t));
  IOBUF IIC_SFP1_0_sda_iobuf
       (.I(IIC_SFP1_0_sda_o),
        .IO(IIC_SFP1_0_sda_io),
        .O(IIC_SFP1_0_sda_i),
        .T(IIC_SFP1_0_sda_t));
  IOBUF IIC_SFP2_0_scl_iobuf
       (.I(IIC_SFP2_0_scl_o),
        .IO(IIC_SFP2_0_scl_io),
        .O(IIC_SFP2_0_scl_i),
        .T(IIC_SFP2_0_scl_t));
  IOBUF IIC_SFP2_0_sda_iobuf
       (.I(IIC_SFP2_0_sda_o),
        .IO(IIC_SFP2_0_sda_io),
        .O(IIC_SFP2_0_sda_i),
        .T(IIC_SFP2_0_sda_t));
  IOBUF SPI_BASEDAC_0_io0_iobuf
       (.I(SPI_BASEDAC_0_io0_o),
        .IO(SPI_BASEDAC_0_io0_io),
        .O(SPI_BASEDAC_0_io0_i),
        .T(SPI_BASEDAC_0_io0_t));
  IOBUF SPI_BASEDAC_0_io1_iobuf
       (.I(SPI_BASEDAC_0_io1_o),
        .IO(SPI_BASEDAC_0_io1_io),
        .O(SPI_BASEDAC_0_io1_i),
        .T(SPI_BASEDAC_0_io1_t));
  IOBUF SPI_BASEDAC_0_sck_iobuf
       (.I(SPI_BASEDAC_0_sck_o),
        .IO(SPI_BASEDAC_0_sck_io),
        .O(SPI_BASEDAC_0_sck_i),
        .T(SPI_BASEDAC_0_sck_t));
  IOBUF SPI_BASEDAC_0_ss_iobuf_0
       (.I(SPI_BASEDAC_0_ss_o_0),
        .IO(SPI_BASEDAC_0_ss_io[0]),
        .O(SPI_BASEDAC_0_ss_i_0),
        .T(SPI_BASEDAC_0_ss_t));
  IOBUF SPI_LADC_0_io0_iobuf
       (.I(SPI_LADC_0_io0_o),
        .IO(SPI_LADC_0_io0_io),
        .O(SPI_LADC_0_io0_i),
        .T(SPI_LADC_0_io0_t));
  IOBUF SPI_LADC_0_io1_iobuf
       (.I(SPI_LADC_0_io1_o),
        .IO(SPI_LADC_0_io1_io),
        .O(SPI_LADC_0_io1_i),
        .T(SPI_LADC_0_io1_t));
  IOBUF SPI_LADC_0_sck_iobuf
       (.I(SPI_LADC_0_sck_o),
        .IO(SPI_LADC_0_sck_io),
        .O(SPI_LADC_0_sck_i),
        .T(SPI_LADC_0_sck_t));
  IOBUF SPI_LADC_0_ss_iobuf_0
       (.I(SPI_LADC_0_ss_o_0),
        .IO(SPI_LADC_0_ss_io[0]),
        .O(SPI_LADC_0_ss_i_0),
        .T(SPI_LADC_0_ss_t));
  mogura2_fee mogura2_fee_i
       (.C0_SYS_CLK_0_clk_n(C0_SYS_CLK_0_clk_n),
        .C0_SYS_CLK_0_clk_p(C0_SYS_CLK_0_clk_p),
        .CDCI6214_EEPROM_SEL_0(CDCI6214_EEPROM_SEL_0),
        .CDCI6214_OE_0(CDCI6214_OE_0),
        .CDCI6214_REF_SEL_0(CDCI6214_REF_SEL_0),
        .CDCI6214_RESETN_0(CDCI6214_RESETN_0),
        .CDCI6214_STATUS_0(CDCI6214_STATUS_0),
        .GPI_0(GPI_0),
        .GPO_0(GPO_0),
        .IIC_CDCI6214_0_scl_i(IIC_CDCI6214_0_scl_i),
        .IIC_CDCI6214_0_scl_o(IIC_CDCI6214_0_scl_o),
        .IIC_CDCI6214_0_scl_t(IIC_CDCI6214_0_scl_t),
        .IIC_CDCI6214_0_sda_i(IIC_CDCI6214_0_sda_i),
        .IIC_CDCI6214_0_sda_o(IIC_CDCI6214_0_sda_o),
        .IIC_CDCI6214_0_sda_t(IIC_CDCI6214_0_sda_t),
        .IIC_SFP1_0_scl_i(IIC_SFP1_0_scl_i),
        .IIC_SFP1_0_scl_o(IIC_SFP1_0_scl_o),
        .IIC_SFP1_0_scl_t(IIC_SFP1_0_scl_t),
        .IIC_SFP1_0_sda_i(IIC_SFP1_0_sda_i),
        .IIC_SFP1_0_sda_o(IIC_SFP1_0_sda_o),
        .IIC_SFP1_0_sda_t(IIC_SFP1_0_sda_t),
        .IIC_SFP2_0_scl_i(IIC_SFP2_0_scl_i),
        .IIC_SFP2_0_scl_o(IIC_SFP2_0_scl_o),
        .IIC_SFP2_0_scl_t(IIC_SFP2_0_scl_t),
        .IIC_SFP2_0_sda_i(IIC_SFP2_0_sda_i),
        .IIC_SFP2_0_sda_o(IIC_SFP2_0_sda_o),
        .IIC_SFP2_0_sda_t(IIC_SFP2_0_sda_t),
        .LADC_CTRL1_0(LADC_CTRL1_0),
        .LADC_CTRL2_0(LADC_CTRL2_0),
        .LADC_RESET_0(LADC_RESET_0),
        .LADC_SEN_0(LADC_SEN_0),
        .LEMO(LEMO),
        .PL_SYSREF_clk_n(PL_SYSREF_clk_n),
        .PL_SYSREF_clk_p(PL_SYSREF_clk_p),
        .PL_SYSTEM_CLK_clk_n(PL_SYSTEM_CLK_clk_n),
        .PL_SYSTEM_CLK_clk_p(PL_SYSTEM_CLK_clk_p),
        .SFP1_MOD_ABS_0(SFP1_MOD_ABS_0),
        .SFP1_RS0_0(SFP1_RS0_0),
        .SFP1_RS1_0(SFP1_RS1_0),
        .SFP1_RX_LOS_0(SFP1_RX_LOS_0),
        .SFP1_TX_DISABLE_0(SFP1_TX_DISABLE_0),
        .SFP1_TX_FAULT_0(SFP1_TX_FAULT_0),
        .SFP2_MOD_ABS_0(SFP2_MOD_ABS_0),
        .SFP2_RS0_0(SFP2_RS0_0),
        .SFP2_RS1_0(SFP2_RS1_0),
        .SFP2_RX_LOS_0(SFP2_RX_LOS_0),
        .SFP2_TX_DISABLE_0(SFP2_TX_DISABLE_0),
        .SFP2_TX_FAULT_0(SFP2_TX_FAULT_0),
        .SPI_BASEDAC_0_io0_i(SPI_BASEDAC_0_io0_i),
        .SPI_BASEDAC_0_io0_o(SPI_BASEDAC_0_io0_o),
        .SPI_BASEDAC_0_io0_t(SPI_BASEDAC_0_io0_t),
        .SPI_BASEDAC_0_io1_i(SPI_BASEDAC_0_io1_i),
        .SPI_BASEDAC_0_io1_o(SPI_BASEDAC_0_io1_o),
        .SPI_BASEDAC_0_io1_t(SPI_BASEDAC_0_io1_t),
        .SPI_BASEDAC_0_sck_i(SPI_BASEDAC_0_sck_i),
        .SPI_BASEDAC_0_sck_o(SPI_BASEDAC_0_sck_o),
        .SPI_BASEDAC_0_sck_t(SPI_BASEDAC_0_sck_t),
        .SPI_BASEDAC_0_ss_i(SPI_BASEDAC_0_ss_i_0),
        .SPI_BASEDAC_0_ss_o(SPI_BASEDAC_0_ss_o_0),
        .SPI_BASEDAC_0_ss_t(SPI_BASEDAC_0_ss_t),
        .SPI_LADC_0_io0_i(SPI_LADC_0_io0_i),
        .SPI_LADC_0_io0_o(SPI_LADC_0_io0_o),
        .SPI_LADC_0_io0_t(SPI_LADC_0_io0_t),
        .SPI_LADC_0_io1_i(SPI_LADC_0_io1_i),
        .SPI_LADC_0_io1_o(SPI_LADC_0_io1_o),
        .SPI_LADC_0_io1_t(SPI_LADC_0_io1_t),
        .SPI_LADC_0_sck_i(SPI_LADC_0_sck_i),
        .SPI_LADC_0_sck_o(SPI_LADC_0_sck_o),
        .SPI_LADC_0_sck_t(SPI_LADC_0_sck_t),
        .SPI_LADC_0_ss_i(SPI_LADC_0_ss_i_0),
        .SPI_LADC_0_ss_o(SPI_LADC_0_ss_o_0),
        .SPI_LADC_0_ss_t(SPI_LADC_0_ss_t),
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
        .dac1_clk_clk_n(dac1_clk_clk_n),
        .dac1_clk_clk_p(dac1_clk_clk_p),
        .dac2_clk_clk_n(dac2_clk_clk_n),
        .dac2_clk_clk_p(dac2_clk_clk_p),
        .dac3_clk_clk_n(dac3_clk_clk_n),
        .dac3_clk_clk_p(dac3_clk_clk_p),
        .ddr4_rtl_0_act_n(ddr4_rtl_0_act_n),
        .ddr4_rtl_0_adr(ddr4_rtl_0_adr),
        .ddr4_rtl_0_ba(ddr4_rtl_0_ba),
        .ddr4_rtl_0_bg(ddr4_rtl_0_bg),
        .ddr4_rtl_0_ck_c(ddr4_rtl_0_ck_c),
        .ddr4_rtl_0_ck_t(ddr4_rtl_0_ck_t),
        .ddr4_rtl_0_cke(ddr4_rtl_0_cke),
        .ddr4_rtl_0_cs_n(ddr4_rtl_0_cs_n),
        .ddr4_rtl_0_dm_n(ddr4_rtl_0_dm_n),
        .ddr4_rtl_0_dq(ddr4_rtl_0_dq),
        .ddr4_rtl_0_dqs_c(ddr4_rtl_0_dqs_c),
        .ddr4_rtl_0_dqs_t(ddr4_rtl_0_dqs_t),
        .ddr4_rtl_0_odt(ddr4_rtl_0_odt),
        .ddr4_rtl_0_reset_n(ddr4_rtl_0_reset_n),
        .sys_rst_0(sys_rst_0),
        .sysref_in_diff_n(sysref_in_diff_n),
        .sysref_in_diff_p(sysref_in_diff_p),
        .vin00_v_n(vin00_v_n),
        .vin00_v_p(vin00_v_p),
        .vin01_v_n(vin01_v_n),
        .vin01_v_p(vin01_v_p),
        .vin02_v_n(vin02_v_n),
        .vin02_v_p(vin02_v_p),
        .vin03_v_n(vin03_v_n),
        .vin03_v_p(vin03_v_p),
        .vin10_v_n(vin10_v_n),
        .vin10_v_p(vin10_v_p),
        .vin11_v_n(vin11_v_n),
        .vin11_v_p(vin11_v_p),
        .vin12_v_n(vin12_v_n),
        .vin12_v_p(vin12_v_p),
        .vin13_v_n(vin13_v_n),
        .vin13_v_p(vin13_v_p),
        .vin20_v_n(vin20_v_n),
        .vin20_v_p(vin20_v_p),
        .vin21_v_n(vin21_v_n),
        .vin21_v_p(vin21_v_p),
        .vin22_v_n(vin22_v_n),
        .vin22_v_p(vin22_v_p),
        .vin23_v_n(vin23_v_n),
        .vin23_v_p(vin23_v_p),
        .vin30_v_n(vin30_v_n),
        .vin30_v_p(vin30_v_p),
        .vin31_v_n(vin31_v_n),
        .vin31_v_p(vin31_v_p),
        .vin32_v_n(vin32_v_n),
        .vin32_v_p(vin32_v_p),
        .vin33_v_n(vin33_v_n),
        .vin33_v_p(vin33_v_p),
        .vout00_v_n(vout00_v_n),
        .vout00_v_p(vout00_v_p),
        .vout01_v_n(vout01_v_n),
        .vout01_v_p(vout01_v_p),
        .vout02_v_n(vout02_v_n),
        .vout02_v_p(vout02_v_p),
        .vout03_v_n(vout03_v_n),
        .vout03_v_p(vout03_v_p),
        .vout10_v_n(vout10_v_n),
        .vout10_v_p(vout10_v_p),
        .vout11_v_n(vout11_v_n),
        .vout11_v_p(vout11_v_p),
        .vout12_v_n(vout12_v_n),
        .vout12_v_p(vout12_v_p),
        .vout13_v_n(vout13_v_n),
        .vout13_v_p(vout13_v_p),
        .vout20_v_n(vout20_v_n),
        .vout20_v_p(vout20_v_p),
        .vout21_v_n(vout21_v_n),
        .vout21_v_p(vout21_v_p),
        .vout22_v_n(vout22_v_n),
        .vout22_v_p(vout22_v_p),
        .vout23_v_n(vout23_v_n),
        .vout23_v_p(vout23_v_p),
        .vout30_v_n(vout30_v_n),
        .vout30_v_p(vout30_v_p),
        .vout31_v_n(vout31_v_n),
        .vout31_v_p(vout31_v_p),
        .vout32_v_n(vout32_v_n),
        .vout32_v_p(vout32_v_p),
        .vout33_v_n(vout33_v_n),
        .vout33_v_p(vout33_v_p),
        .xiphy_rx_pins_0_pin0(xiphy_rx_pins_0_pin0),
        .xiphy_rx_pins_0_pin1(xiphy_rx_pins_0_pin1),
        .xiphy_rx_pins_0_pin10(xiphy_rx_pins_0_pin10),
        .xiphy_rx_pins_0_pin11(xiphy_rx_pins_0_pin11),
        .xiphy_rx_pins_0_pin13(xiphy_rx_pins_0_pin13),
        .xiphy_rx_pins_0_pin14(xiphy_rx_pins_0_pin14),
        .xiphy_rx_pins_0_pin15(xiphy_rx_pins_0_pin15),
        .xiphy_rx_pins_0_pin16(xiphy_rx_pins_0_pin16),
        .xiphy_rx_pins_0_pin17(xiphy_rx_pins_0_pin17),
        .xiphy_rx_pins_0_pin18(xiphy_rx_pins_0_pin18),
        .xiphy_rx_pins_0_pin19(xiphy_rx_pins_0_pin19),
        .xiphy_rx_pins_0_pin2(xiphy_rx_pins_0_pin2),
        .xiphy_rx_pins_0_pin20(xiphy_rx_pins_0_pin20),
        .xiphy_rx_pins_0_pin21(xiphy_rx_pins_0_pin21),
        .xiphy_rx_pins_0_pin22(xiphy_rx_pins_0_pin22),
        .xiphy_rx_pins_0_pin23(xiphy_rx_pins_0_pin23),
        .xiphy_rx_pins_0_pin24(xiphy_rx_pins_0_pin24),
        .xiphy_rx_pins_0_pin26(xiphy_rx_pins_0_pin26),
        .xiphy_rx_pins_0_pin27(xiphy_rx_pins_0_pin27),
        .xiphy_rx_pins_0_pin28(xiphy_rx_pins_0_pin28),
        .xiphy_rx_pins_0_pin29(xiphy_rx_pins_0_pin29),
        .xiphy_rx_pins_0_pin3(xiphy_rx_pins_0_pin3),
        .xiphy_rx_pins_0_pin30(xiphy_rx_pins_0_pin30),
        .xiphy_rx_pins_0_pin31(xiphy_rx_pins_0_pin31),
        .xiphy_rx_pins_0_pin32(xiphy_rx_pins_0_pin32),
        .xiphy_rx_pins_0_pin33(xiphy_rx_pins_0_pin33),
        .xiphy_rx_pins_0_pin34(xiphy_rx_pins_0_pin34),
        .xiphy_rx_pins_0_pin35(xiphy_rx_pins_0_pin35),
        .xiphy_rx_pins_0_pin36(xiphy_rx_pins_0_pin36),
        .xiphy_rx_pins_0_pin37(xiphy_rx_pins_0_pin37),
        .xiphy_rx_pins_0_pin39(xiphy_rx_pins_0_pin39),
        .xiphy_rx_pins_0_pin4(xiphy_rx_pins_0_pin4),
        .xiphy_rx_pins_0_pin40(xiphy_rx_pins_0_pin40),
        .xiphy_rx_pins_0_pin41(xiphy_rx_pins_0_pin41),
        .xiphy_rx_pins_0_pin42(xiphy_rx_pins_0_pin42),
        .xiphy_rx_pins_0_pin43(xiphy_rx_pins_0_pin43),
        .xiphy_rx_pins_0_pin44(xiphy_rx_pins_0_pin44),
        .xiphy_rx_pins_0_pin45(xiphy_rx_pins_0_pin45),
        .xiphy_rx_pins_0_pin46(xiphy_rx_pins_0_pin46),
        .xiphy_rx_pins_0_pin47(xiphy_rx_pins_0_pin47),
        .xiphy_rx_pins_0_pin48(xiphy_rx_pins_0_pin48),
        .xiphy_rx_pins_0_pin49(xiphy_rx_pins_0_pin49),
        .xiphy_rx_pins_0_pin5(xiphy_rx_pins_0_pin5),
        .xiphy_rx_pins_0_pin50(xiphy_rx_pins_0_pin50),
        .xiphy_rx_pins_0_pin6(xiphy_rx_pins_0_pin6),
        .xiphy_rx_pins_0_pin7(xiphy_rx_pins_0_pin7),
        .xiphy_rx_pins_0_pin8(xiphy_rx_pins_0_pin8),
        .xiphy_rx_pins_0_pin9(xiphy_rx_pins_0_pin9),
        .xiphy_rx_pins_1_pin0(xiphy_rx_pins_1_pin0),
        .xiphy_rx_pins_1_pin1(xiphy_rx_pins_1_pin1),
        .xiphy_rx_pins_1_pin10(xiphy_rx_pins_1_pin10),
        .xiphy_rx_pins_1_pin11(xiphy_rx_pins_1_pin11),
        .xiphy_rx_pins_1_pin13(xiphy_rx_pins_1_pin13),
        .xiphy_rx_pins_1_pin14(xiphy_rx_pins_1_pin14),
        .xiphy_rx_pins_1_pin15(xiphy_rx_pins_1_pin15),
        .xiphy_rx_pins_1_pin16(xiphy_rx_pins_1_pin16),
        .xiphy_rx_pins_1_pin17(xiphy_rx_pins_1_pin17),
        .xiphy_rx_pins_1_pin18(xiphy_rx_pins_1_pin18),
        .xiphy_rx_pins_1_pin19(xiphy_rx_pins_1_pin19),
        .xiphy_rx_pins_1_pin2(xiphy_rx_pins_1_pin2),
        .xiphy_rx_pins_1_pin20(xiphy_rx_pins_1_pin20),
        .xiphy_rx_pins_1_pin21(xiphy_rx_pins_1_pin21),
        .xiphy_rx_pins_1_pin22(xiphy_rx_pins_1_pin22),
        .xiphy_rx_pins_1_pin23(xiphy_rx_pins_1_pin23),
        .xiphy_rx_pins_1_pin24(xiphy_rx_pins_1_pin24),
        .xiphy_rx_pins_1_pin26(xiphy_rx_pins_1_pin26),
        .xiphy_rx_pins_1_pin27(xiphy_rx_pins_1_pin27),
        .xiphy_rx_pins_1_pin28(xiphy_rx_pins_1_pin28),
        .xiphy_rx_pins_1_pin29(xiphy_rx_pins_1_pin29),
        .xiphy_rx_pins_1_pin3(xiphy_rx_pins_1_pin3),
        .xiphy_rx_pins_1_pin30(xiphy_rx_pins_1_pin30),
        .xiphy_rx_pins_1_pin31(xiphy_rx_pins_1_pin31),
        .xiphy_rx_pins_1_pin32(xiphy_rx_pins_1_pin32),
        .xiphy_rx_pins_1_pin33(xiphy_rx_pins_1_pin33),
        .xiphy_rx_pins_1_pin34(xiphy_rx_pins_1_pin34),
        .xiphy_rx_pins_1_pin35(xiphy_rx_pins_1_pin35),
        .xiphy_rx_pins_1_pin36(xiphy_rx_pins_1_pin36),
        .xiphy_rx_pins_1_pin37(xiphy_rx_pins_1_pin37),
        .xiphy_rx_pins_1_pin39(xiphy_rx_pins_1_pin39),
        .xiphy_rx_pins_1_pin4(xiphy_rx_pins_1_pin4),
        .xiphy_rx_pins_1_pin40(xiphy_rx_pins_1_pin40),
        .xiphy_rx_pins_1_pin41(xiphy_rx_pins_1_pin41),
        .xiphy_rx_pins_1_pin42(xiphy_rx_pins_1_pin42),
        .xiphy_rx_pins_1_pin43(xiphy_rx_pins_1_pin43),
        .xiphy_rx_pins_1_pin44(xiphy_rx_pins_1_pin44),
        .xiphy_rx_pins_1_pin45(xiphy_rx_pins_1_pin45),
        .xiphy_rx_pins_1_pin46(xiphy_rx_pins_1_pin46),
        .xiphy_rx_pins_1_pin47(xiphy_rx_pins_1_pin47),
        .xiphy_rx_pins_1_pin48(xiphy_rx_pins_1_pin48),
        .xiphy_rx_pins_1_pin49(xiphy_rx_pins_1_pin49),
        .xiphy_rx_pins_1_pin5(xiphy_rx_pins_1_pin5),
        .xiphy_rx_pins_1_pin50(xiphy_rx_pins_1_pin50),
        .xiphy_rx_pins_1_pin6(xiphy_rx_pins_1_pin6),
        .xiphy_rx_pins_1_pin7(xiphy_rx_pins_1_pin7),
        .xiphy_rx_pins_1_pin8(xiphy_rx_pins_1_pin8),
        .xiphy_rx_pins_1_pin9(xiphy_rx_pins_1_pin9),
        .xiphy_rx_pins_2_pin0(xiphy_rx_pins_2_pin0),
        .xiphy_rx_pins_2_pin1(xiphy_rx_pins_2_pin1),
        .xiphy_rx_pins_2_pin10(xiphy_rx_pins_2_pin10),
        .xiphy_rx_pins_2_pin11(xiphy_rx_pins_2_pin11),
        .xiphy_rx_pins_2_pin13(xiphy_rx_pins_2_pin13),
        .xiphy_rx_pins_2_pin14(xiphy_rx_pins_2_pin14),
        .xiphy_rx_pins_2_pin15(xiphy_rx_pins_2_pin15),
        .xiphy_rx_pins_2_pin16(xiphy_rx_pins_2_pin16),
        .xiphy_rx_pins_2_pin17(xiphy_rx_pins_2_pin17),
        .xiphy_rx_pins_2_pin18(xiphy_rx_pins_2_pin18),
        .xiphy_rx_pins_2_pin19(xiphy_rx_pins_2_pin19),
        .xiphy_rx_pins_2_pin2(xiphy_rx_pins_2_pin2),
        .xiphy_rx_pins_2_pin20(xiphy_rx_pins_2_pin20),
        .xiphy_rx_pins_2_pin21(xiphy_rx_pins_2_pin21),
        .xiphy_rx_pins_2_pin22(xiphy_rx_pins_2_pin22),
        .xiphy_rx_pins_2_pin23(xiphy_rx_pins_2_pin23),
        .xiphy_rx_pins_2_pin24(xiphy_rx_pins_2_pin24),
        .xiphy_rx_pins_2_pin26(xiphy_rx_pins_2_pin26),
        .xiphy_rx_pins_2_pin27(xiphy_rx_pins_2_pin27),
        .xiphy_rx_pins_2_pin28(xiphy_rx_pins_2_pin28),
        .xiphy_rx_pins_2_pin29(xiphy_rx_pins_2_pin29),
        .xiphy_rx_pins_2_pin3(xiphy_rx_pins_2_pin3),
        .xiphy_rx_pins_2_pin30(xiphy_rx_pins_2_pin30),
        .xiphy_rx_pins_2_pin31(xiphy_rx_pins_2_pin31),
        .xiphy_rx_pins_2_pin32(xiphy_rx_pins_2_pin32),
        .xiphy_rx_pins_2_pin33(xiphy_rx_pins_2_pin33),
        .xiphy_rx_pins_2_pin34(xiphy_rx_pins_2_pin34),
        .xiphy_rx_pins_2_pin35(xiphy_rx_pins_2_pin35),
        .xiphy_rx_pins_2_pin36(xiphy_rx_pins_2_pin36),
        .xiphy_rx_pins_2_pin37(xiphy_rx_pins_2_pin37),
        .xiphy_rx_pins_2_pin39(xiphy_rx_pins_2_pin39),
        .xiphy_rx_pins_2_pin4(xiphy_rx_pins_2_pin4),
        .xiphy_rx_pins_2_pin40(xiphy_rx_pins_2_pin40),
        .xiphy_rx_pins_2_pin41(xiphy_rx_pins_2_pin41),
        .xiphy_rx_pins_2_pin42(xiphy_rx_pins_2_pin42),
        .xiphy_rx_pins_2_pin43(xiphy_rx_pins_2_pin43),
        .xiphy_rx_pins_2_pin44(xiphy_rx_pins_2_pin44),
        .xiphy_rx_pins_2_pin45(xiphy_rx_pins_2_pin45),
        .xiphy_rx_pins_2_pin46(xiphy_rx_pins_2_pin46),
        .xiphy_rx_pins_2_pin47(xiphy_rx_pins_2_pin47),
        .xiphy_rx_pins_2_pin48(xiphy_rx_pins_2_pin48),
        .xiphy_rx_pins_2_pin49(xiphy_rx_pins_2_pin49),
        .xiphy_rx_pins_2_pin5(xiphy_rx_pins_2_pin5),
        .xiphy_rx_pins_2_pin50(xiphy_rx_pins_2_pin50),
        .xiphy_rx_pins_2_pin6(xiphy_rx_pins_2_pin6),
        .xiphy_rx_pins_2_pin7(xiphy_rx_pins_2_pin7),
        .xiphy_rx_pins_2_pin8(xiphy_rx_pins_2_pin8),
        .xiphy_rx_pins_2_pin9(xiphy_rx_pins_2_pin9),
        .xiphy_rx_pins_3_pin0(xiphy_rx_pins_3_pin0),
        .xiphy_rx_pins_3_pin1(xiphy_rx_pins_3_pin1),
        .xiphy_rx_pins_3_pin10(xiphy_rx_pins_3_pin10),
        .xiphy_rx_pins_3_pin11(xiphy_rx_pins_3_pin11),
        .xiphy_rx_pins_3_pin13(xiphy_rx_pins_3_pin13),
        .xiphy_rx_pins_3_pin14(xiphy_rx_pins_3_pin14),
        .xiphy_rx_pins_3_pin15(xiphy_rx_pins_3_pin15),
        .xiphy_rx_pins_3_pin16(xiphy_rx_pins_3_pin16),
        .xiphy_rx_pins_3_pin17(xiphy_rx_pins_3_pin17),
        .xiphy_rx_pins_3_pin18(xiphy_rx_pins_3_pin18),
        .xiphy_rx_pins_3_pin19(xiphy_rx_pins_3_pin19),
        .xiphy_rx_pins_3_pin2(xiphy_rx_pins_3_pin2),
        .xiphy_rx_pins_3_pin20(xiphy_rx_pins_3_pin20),
        .xiphy_rx_pins_3_pin21(xiphy_rx_pins_3_pin21),
        .xiphy_rx_pins_3_pin22(xiphy_rx_pins_3_pin22),
        .xiphy_rx_pins_3_pin23(xiphy_rx_pins_3_pin23),
        .xiphy_rx_pins_3_pin24(xiphy_rx_pins_3_pin24),
        .xiphy_rx_pins_3_pin26(xiphy_rx_pins_3_pin26),
        .xiphy_rx_pins_3_pin27(xiphy_rx_pins_3_pin27),
        .xiphy_rx_pins_3_pin28(xiphy_rx_pins_3_pin28),
        .xiphy_rx_pins_3_pin29(xiphy_rx_pins_3_pin29),
        .xiphy_rx_pins_3_pin3(xiphy_rx_pins_3_pin3),
        .xiphy_rx_pins_3_pin30(xiphy_rx_pins_3_pin30),
        .xiphy_rx_pins_3_pin31(xiphy_rx_pins_3_pin31),
        .xiphy_rx_pins_3_pin32(xiphy_rx_pins_3_pin32),
        .xiphy_rx_pins_3_pin33(xiphy_rx_pins_3_pin33),
        .xiphy_rx_pins_3_pin34(xiphy_rx_pins_3_pin34),
        .xiphy_rx_pins_3_pin35(xiphy_rx_pins_3_pin35),
        .xiphy_rx_pins_3_pin36(xiphy_rx_pins_3_pin36),
        .xiphy_rx_pins_3_pin37(xiphy_rx_pins_3_pin37),
        .xiphy_rx_pins_3_pin39(xiphy_rx_pins_3_pin39),
        .xiphy_rx_pins_3_pin4(xiphy_rx_pins_3_pin4),
        .xiphy_rx_pins_3_pin40(xiphy_rx_pins_3_pin40),
        .xiphy_rx_pins_3_pin41(xiphy_rx_pins_3_pin41),
        .xiphy_rx_pins_3_pin42(xiphy_rx_pins_3_pin42),
        .xiphy_rx_pins_3_pin43(xiphy_rx_pins_3_pin43),
        .xiphy_rx_pins_3_pin44(xiphy_rx_pins_3_pin44),
        .xiphy_rx_pins_3_pin45(xiphy_rx_pins_3_pin45),
        .xiphy_rx_pins_3_pin46(xiphy_rx_pins_3_pin46),
        .xiphy_rx_pins_3_pin47(xiphy_rx_pins_3_pin47),
        .xiphy_rx_pins_3_pin48(xiphy_rx_pins_3_pin48),
        .xiphy_rx_pins_3_pin49(xiphy_rx_pins_3_pin49),
        .xiphy_rx_pins_3_pin5(xiphy_rx_pins_3_pin5),
        .xiphy_rx_pins_3_pin50(xiphy_rx_pins_3_pin50),
        .xiphy_rx_pins_3_pin6(xiphy_rx_pins_3_pin6),
        .xiphy_rx_pins_3_pin7(xiphy_rx_pins_3_pin7),
        .xiphy_rx_pins_3_pin8(xiphy_rx_pins_3_pin8),
        .xiphy_rx_pins_3_pin9(xiphy_rx_pins_3_pin9));
endmodule
