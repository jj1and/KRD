//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
//Date        : Tue Dec 15 13:33:56 2020
//Host        : LAPTOP-4N9JS6FC running 64-bit major release  (build 9200)
//Command     : generate_target dsp_blr_bd_wrapper.bd
//Design      : dsp_blr_bd_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module dsp_blr_bd_wrapper
   (clk,
    dsp_m_axis_tdata,
    dsp_m_axis_tvalid,
    h_m_axis_tdata,
    h_m_axis_tvalid,
    h_s_axis_tdata,
    h_s_axis_tvalid,
    l_m_axis_tdata,
    l_m_axis_tvalid,
    l_s_axis_tdata,
    l_s_axis_tvalid);
  input clk;
  output [159:0]dsp_m_axis_tdata;
  output [0:0]dsp_m_axis_tvalid;
  output [127:0]h_m_axis_tdata;
  output [0:0]h_m_axis_tvalid;
  input [127:0]h_s_axis_tdata;
  input [0:0]h_s_axis_tvalid;
  output [31:0]l_m_axis_tdata;
  output [0:0]l_m_axis_tvalid;
  input [31:0]l_s_axis_tdata;
  input [0:0]l_s_axis_tvalid;

  wire clk;
  wire [159:0]dsp_m_axis_tdata;
  wire [0:0]dsp_m_axis_tvalid;
  wire [127:0]h_m_axis_tdata;
  wire [0:0]h_m_axis_tvalid;
  wire [127:0]h_s_axis_tdata;
  wire [0:0]h_s_axis_tvalid;
  wire [31:0]l_m_axis_tdata;
  wire [0:0]l_m_axis_tvalid;
  wire [31:0]l_s_axis_tdata;
  wire [0:0]l_s_axis_tvalid;

  dsp_blr_bd dsp_blr_bd_i
       (.clk(clk),
        .dsp_m_axis_tdata(dsp_m_axis_tdata),
        .dsp_m_axis_tvalid(dsp_m_axis_tvalid),
        .h_m_axis_tdata(h_m_axis_tdata),
        .h_m_axis_tvalid(h_m_axis_tvalid),
        .h_s_axis_tdata(h_s_axis_tdata),
        .h_s_axis_tvalid(h_s_axis_tvalid),
        .l_m_axis_tdata(l_m_axis_tdata),
        .l_m_axis_tvalid(l_m_axis_tvalid),
        .l_s_axis_tdata(l_s_axis_tdata),
        .l_s_axis_tvalid(l_s_axis_tvalid));
endmodule
