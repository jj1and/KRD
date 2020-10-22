//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1.3 (win64) Build 2644227 Wed Sep  4 09:45:24 MDT 2019
//Date        : Thu Oct 22 20:03:11 2020
//Host        : AKABEKO03 running 64-bit major release  (build 9200)
//Command     : generate_target sim_design_wrapper.bd
//Design      : sim_design_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module sim_design_wrapper
   (CLK_125MHZ,
    CLK_333MHZ,
    DATAFRAME_GEN_ERROR,
    EXT_RESET,
    MAX_TRIGGER_LENGTH,
    M_AXIS_TDATA,
    M_AXIS_TKEEP,
    M_AXIS_TLAST,
    M_AXIS_TREADY,
    M_AXIS_TVALID,
    SET_CONFIG,
    S_AXIS_TDATA,
    S_AXIS_TVALID);
  input CLK_125MHZ;
  input CLK_333MHZ;
  output DATAFRAME_GEN_ERROR;
  input EXT_RESET;
  input [15:0]MAX_TRIGGER_LENGTH;
  output [127:0]M_AXIS_TDATA;
  output [15:0]M_AXIS_TKEEP;
  output M_AXIS_TLAST;
  input M_AXIS_TREADY;
  output M_AXIS_TVALID;
  input SET_CONFIG;
  input [215:0]S_AXIS_TDATA;
  input S_AXIS_TVALID;

  wire CLK_125MHZ;
  wire CLK_333MHZ;
  wire DATAFRAME_GEN_ERROR;
  wire EXT_RESET;
  wire [15:0]MAX_TRIGGER_LENGTH;
  wire [127:0]M_AXIS_TDATA;
  wire [15:0]M_AXIS_TKEEP;
  wire M_AXIS_TLAST;
  wire M_AXIS_TREADY;
  wire M_AXIS_TVALID;
  wire SET_CONFIG;
  wire [215:0]S_AXIS_TDATA;
  wire S_AXIS_TVALID;

  sim_design sim_design_i
       (.CLK_125MHZ(CLK_125MHZ),
        .CLK_333MHZ(CLK_333MHZ),
        .DATAFRAME_GEN_ERROR(DATAFRAME_GEN_ERROR),
        .EXT_RESET(EXT_RESET),
        .MAX_TRIGGER_LENGTH(MAX_TRIGGER_LENGTH),
        .M_AXIS_TDATA(M_AXIS_TDATA),
        .M_AXIS_TKEEP(M_AXIS_TKEEP),
        .M_AXIS_TLAST(M_AXIS_TLAST),
        .M_AXIS_TREADY(M_AXIS_TREADY),
        .M_AXIS_TVALID(M_AXIS_TVALID),
        .SET_CONFIG(SET_CONFIG),
        .S_AXIS_TDATA(S_AXIS_TDATA),
        .S_AXIS_TVALID(S_AXIS_TVALID));
endmodule
