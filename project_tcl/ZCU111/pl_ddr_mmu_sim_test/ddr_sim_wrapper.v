//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1.3 (win64) Build 2644227 Wed Sep  4 09:45:24 MDT 2019
//Date        : Mon Aug 31 16:57:33 2020
//Host        : AKABEKO03 running 64-bit major release  (build 9200)
//Command     : generate_target ddr_sim_wrapper.bd
//Design      : ddr_sim_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module ddr_sim_wrapper
   (CLK,
    DATAMOVER_ERROR_0,
    EXT_RESET,
    MAX_TRIGGER_LENGTH_0,
    M_AXIS_0_tdata,
    M_AXIS_0_tkeep,
    M_AXIS_0_tlast,
    M_AXIS_0_tready,
    M_AXIS_0_tvalid,
    SET_CONFIG_0,
    S_AXIS_0_tdata,
    S_AXIS_0_tlast,
    S_AXIS_0_tready,
    S_AXIS_0_tvalid);
  input CLK;
  output DATAMOVER_ERROR_0;
  input EXT_RESET;
  input [15:0]MAX_TRIGGER_LENGTH_0;
  output [127:0]M_AXIS_0_tdata;
  output [15:0]M_AXIS_0_tkeep;
  output M_AXIS_0_tlast;
  input M_AXIS_0_tready;
  output M_AXIS_0_tvalid;
  input SET_CONFIG_0;
  input [127:0]S_AXIS_0_tdata;
  input S_AXIS_0_tlast;
  output S_AXIS_0_tready;
  input S_AXIS_0_tvalid;

  wire CLK;
  wire DATAMOVER_ERROR_0;
  wire EXT_RESET;
  wire [15:0]MAX_TRIGGER_LENGTH_0;
  wire [127:0]M_AXIS_0_tdata;
  wire [15:0]M_AXIS_0_tkeep;
  wire M_AXIS_0_tlast;
  wire M_AXIS_0_tready;
  wire M_AXIS_0_tvalid;
  wire SET_CONFIG_0;
  wire [127:0]S_AXIS_0_tdata;
  wire S_AXIS_0_tlast;
  wire S_AXIS_0_tready;
  wire S_AXIS_0_tvalid;

  ddr_sim ddr_sim_i
       (.CLK(CLK),
        .DATAMOVER_ERROR_0(DATAMOVER_ERROR_0),
        .EXT_RESET(EXT_RESET),
        .MAX_TRIGGER_LENGTH_0(MAX_TRIGGER_LENGTH_0),
        .M_AXIS_0_tdata(M_AXIS_0_tdata),
        .M_AXIS_0_tkeep(M_AXIS_0_tkeep),
        .M_AXIS_0_tlast(M_AXIS_0_tlast),
        .M_AXIS_0_tready(M_AXIS_0_tready),
        .M_AXIS_0_tvalid(M_AXIS_0_tvalid),
        .SET_CONFIG_0(SET_CONFIG_0),
        .S_AXIS_0_tdata(S_AXIS_0_tdata),
        .S_AXIS_0_tlast(S_AXIS_0_tlast),
        .S_AXIS_0_tready(S_AXIS_0_tready),
        .S_AXIS_0_tvalid(S_AXIS_0_tvalid));
endmodule
