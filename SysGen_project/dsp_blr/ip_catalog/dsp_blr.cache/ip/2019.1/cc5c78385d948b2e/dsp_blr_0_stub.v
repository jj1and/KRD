// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Tue Dec 15 13:35:11 2020
// Host        : LAPTOP-4N9JS6FC running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ dsp_blr_0_stub.v
// Design      : dsp_blr_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu29dr-ffvf1760-1-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "dsp_blr,Vivado 2019.1" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(h_s_axis_tdata, h_s_axis_tvalid, 
  l_s_axis_tdata, l_s_axis_tvalid, clk, dsp_m_axis_tdata, dsp_m_axis_tvalid, h_m_axis_tdata, 
  h_m_axis_tvalid, l_m_axis_tdata, l_m_axis_tvalid)
/* synthesis syn_black_box black_box_pad_pin="h_s_axis_tdata[127:0],h_s_axis_tvalid[0:0],l_s_axis_tdata[31:0],l_s_axis_tvalid[0:0],clk,dsp_m_axis_tdata[159:0],dsp_m_axis_tvalid[0:0],h_m_axis_tdata[127:0],h_m_axis_tvalid[0:0],l_m_axis_tdata[31:0],l_m_axis_tvalid[0:0]" */;
  input [127:0]h_s_axis_tdata;
  input [0:0]h_s_axis_tvalid;
  input [31:0]l_s_axis_tdata;
  input [0:0]l_s_axis_tvalid;
  input clk;
  output [159:0]dsp_m_axis_tdata;
  output [0:0]dsp_m_axis_tvalid;
  output [127:0]h_m_axis_tdata;
  output [0:0]h_m_axis_tvalid;
  output [31:0]l_m_axis_tdata;
  output [0:0]l_m_axis_tvalid;
endmodule
