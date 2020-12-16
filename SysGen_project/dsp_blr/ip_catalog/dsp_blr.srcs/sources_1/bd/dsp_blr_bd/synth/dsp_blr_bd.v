//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
//Date        : Tue Dec 15 13:33:56 2020
//Host        : LAPTOP-4N9JS6FC running 64-bit major release  (build 9200)
//Command     : generate_target dsp_blr_bd.bd
//Design      : dsp_blr_bd
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "dsp_blr_bd,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=dsp_blr_bd,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=1,numHierBlks=0,maxHierDepth=0,numSysgenBlks=1,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=SYSGEN,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "dsp_blr_bd.hwdef" *) 
module dsp_blr_bd
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
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK, ASSOCIATED_BUSIF dsp_m_axis:h_m_axis:h_s_axis:l_m_axis:l_s_axis, CLK_DOMAIN dsp_blr_bd_clk, FREQ_HZ 100000000, INSERT_VIP 0, PHASE 0.000" *) input clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 dsp_m_axis TDATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME dsp_m_axis, CLK_DOMAIN dsp_blr_bd_clk, FREQ_HZ 100000000, HAS_TKEEP 0, HAS_TLAST 0, HAS_TREADY 0, HAS_TSTRB 0, INSERT_VIP 0, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {TDATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 160} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} real {fixed {fractwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} signed {attribs {resolve_type immediate dependency {} format bool minimum {} maximum {}} value false}}}}}}, PHASE 0.000, TDATA_NUM_BYTES 20, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0" *) output [159:0]dsp_m_axis_tdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 dsp_m_axis TVALID" *) output [0:0]dsp_m_axis_tvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 h_m_axis TDATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME h_m_axis, CLK_DOMAIN dsp_blr_bd_clk, FREQ_HZ 100000000, HAS_TKEEP 0, HAS_TLAST 0, HAS_TREADY 0, HAS_TSTRB 0, INSERT_VIP 0, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {TDATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 128} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} real {fixed {fractwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} signed {attribs {resolve_type immediate dependency {} format bool minimum {} maximum {}} value false}}}}}}, PHASE 0.000, TDATA_NUM_BYTES 16, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0" *) output [127:0]h_m_axis_tdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 h_m_axis TVALID" *) output [0:0]h_m_axis_tvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 h_s_axis TDATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME h_s_axis, CLK_DOMAIN dsp_blr_bd_clk, FREQ_HZ 100000000, HAS_TKEEP 0, HAS_TLAST 0, HAS_TREADY 1, HAS_TSTRB 0, INSERT_VIP 0, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {TDATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 128} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} real {fixed {fractwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} signed {attribs {resolve_type immediate dependency {} format bool minimum {} maximum {}} value false}}}}}}, PHASE 0.000, TDATA_NUM_BYTES 16, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0" *) input [127:0]h_s_axis_tdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 h_s_axis TVALID" *) input [0:0]h_s_axis_tvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 l_m_axis TDATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME l_m_axis, CLK_DOMAIN dsp_blr_bd_clk, FREQ_HZ 100000000, HAS_TKEEP 0, HAS_TLAST 0, HAS_TREADY 0, HAS_TSTRB 0, INSERT_VIP 0, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {TDATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 32} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} real {fixed {fractwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} signed {attribs {resolve_type immediate dependency {} format bool minimum {} maximum {}} value false}}}}}}, PHASE 0.000, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0" *) output [31:0]l_m_axis_tdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 l_m_axis TVALID" *) output [0:0]l_m_axis_tvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 l_s_axis TDATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME l_s_axis, CLK_DOMAIN dsp_blr_bd_clk, FREQ_HZ 100000000, HAS_TKEEP 0, HAS_TLAST 0, HAS_TREADY 1, HAS_TSTRB 0, INSERT_VIP 0, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {TDATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 32} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} real {fixed {fractwidth {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} signed {attribs {resolve_type immediate dependency {} format bool minimum {} maximum {}} value false}}}}}}, PHASE 0.000, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0" *) input [31:0]l_s_axis_tdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 l_s_axis TVALID" *) input [0:0]l_s_axis_tvalid;

  wire clk_1;
  wire [159:0]dsp_blr_1_dsp_m_axis_TDATA;
  wire [0:0]dsp_blr_1_dsp_m_axis_TVALID;
  wire [127:0]dsp_blr_1_h_m_axis_TDATA;
  wire [0:0]dsp_blr_1_h_m_axis_TVALID;
  wire [31:0]dsp_blr_1_l_m_axis_TDATA;
  wire [0:0]dsp_blr_1_l_m_axis_TVALID;
  wire [127:0]h_s_axis_1_TDATA;
  wire [0:0]h_s_axis_1_TVALID;
  wire [31:0]l_s_axis_1_TDATA;
  wire [0:0]l_s_axis_1_TVALID;

  assign clk_1 = clk;
  assign dsp_m_axis_tdata[159:0] = dsp_blr_1_dsp_m_axis_TDATA;
  assign dsp_m_axis_tvalid[0] = dsp_blr_1_dsp_m_axis_TVALID;
  assign h_m_axis_tdata[127:0] = dsp_blr_1_h_m_axis_TDATA;
  assign h_m_axis_tvalid[0] = dsp_blr_1_h_m_axis_TVALID;
  assign h_s_axis_1_TDATA = h_s_axis_tdata[127:0];
  assign h_s_axis_1_TVALID = h_s_axis_tvalid[0];
  assign l_m_axis_tdata[31:0] = dsp_blr_1_l_m_axis_TDATA;
  assign l_m_axis_tvalid[0] = dsp_blr_1_l_m_axis_TVALID;
  assign l_s_axis_1_TDATA = l_s_axis_tdata[31:0];
  assign l_s_axis_1_TVALID = l_s_axis_tvalid[0];
  dsp_blr_bd_dsp_blr_1_0 dsp_blr_1
       (.clk(clk_1),
        .dsp_m_axis_tdata(dsp_blr_1_dsp_m_axis_TDATA),
        .dsp_m_axis_tvalid(dsp_blr_1_dsp_m_axis_TVALID),
        .h_m_axis_tdata(dsp_blr_1_h_m_axis_TDATA),
        .h_m_axis_tvalid(dsp_blr_1_h_m_axis_TVALID),
        .h_s_axis_tdata(h_s_axis_1_TDATA),
        .h_s_axis_tvalid(h_s_axis_1_TVALID),
        .l_m_axis_tdata(dsp_blr_1_l_m_axis_TDATA),
        .l_m_axis_tvalid(dsp_blr_1_l_m_axis_TVALID),
        .l_s_axis_tdata(l_s_axis_1_TDATA),
        .l_s_axis_tvalid(l_s_axis_1_TVALID));
endmodule
