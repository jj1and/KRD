`ifndef xlConvPkgIncluded
`include "conv_pkg.v"
`endif

`timescale 1 ns / 10 ps
// Generated from Simulink block dsp_blr_InputOnly_2_struct
module dsp_blr_inputonly_2_struct (
  input [128-1:0] h_s_axis_tdata,
  input [1-1:0] h_s_axis_tvalid,
  input [32-1:0] l_s_axis_tdata,
  input [1-1:0] l_s_axis_tvalid,
  input clk_1,
  input ce_1,
  output [128-1:0] dsp_m_axis_tdata,
  output [1-1:0] dsp_m_axis_tvalid,
  output [128-1:0] h_m_axis_tdata,
  output [1-1:0] h_m_axis_tvalid,
  output [32-1:0] l_m_axis_tdata,
  output [1-1:0] l_m_axis_tvalid
);
  wire [32-1:0] l_s_axis_tdata_net;
  wire [1-1:0] l_s_axis_tvalid_net;
  wire [1-1:0] delay_q_net;
  wire [32-1:0] l_gain_tdata_delay_q_net;
  wire ce_net;
  wire clk_net;
  wire [1-1:0] l_gain_tvalid_delay_q_net;
  wire [128-1:0] h_s_axis_tdata_net;
  wire [1-1:0] h_s_axis_tvalid_net;
  assign dsp_m_axis_tdata = h_s_axis_tdata_net;
  assign dsp_m_axis_tvalid = delay_q_net;
  assign h_m_axis_tdata = h_s_axis_tdata_net;
  assign h_m_axis_tvalid = delay_q_net;
  assign h_s_axis_tdata_net = h_s_axis_tdata;
  assign h_s_axis_tvalid_net = h_s_axis_tvalid;
  assign l_m_axis_tdata = l_gain_tdata_delay_q_net;
  assign l_m_axis_tvalid = l_gain_tvalid_delay_q_net;
  assign l_s_axis_tdata_net = l_s_axis_tdata;
  assign l_s_axis_tvalid_net = l_s_axis_tvalid;
  assign clk_net = clk_1;
  assign ce_net = ce_1;
  dsp_blr_inputonly_2_xldelay #(
    .latency(2),
    .reg_retiming(0),
    .reset(0),
    .width(1)
  )
  delay (
    .en(1'b1),
    .rst(1'b0),
    .d(h_s_axis_tvalid_net),
    .clk(clk_net),
    .ce(ce_net),
    .q(delay_q_net)
  );
  sysgen_delay_226817aacd l_gain_tdata_delay (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .d(l_s_axis_tdata_net),
    .q(l_gain_tdata_delay_q_net)
  );
  sysgen_delay_26983d872f l_gain_tvalid_delay (
    .clk(1'b0),
    .ce(1'b0),
    .clr(1'b0),
    .d(l_s_axis_tvalid_net),
    .q(l_gain_tvalid_delay_q_net)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block 
module dsp_blr_inputonly_2_default_clock_driver (
  input dsp_blr_inputonly_2_sysclk,
  input dsp_blr_inputonly_2_sysce,
  input dsp_blr_inputonly_2_sysclr,
  output dsp_blr_inputonly_2_clk1,
  output dsp_blr_inputonly_2_ce1
);
  xlclockdriver #(
    .period(1),
    .log_2_period(1)
  )
  clockdriver (
    .sysclk(dsp_blr_inputonly_2_sysclk),
    .sysce(dsp_blr_inputonly_2_sysce),
    .sysclr(dsp_blr_inputonly_2_sysclr),
    .clk(dsp_blr_inputonly_2_clk1),
    .ce(dsp_blr_inputonly_2_ce1)
  );
endmodule
`timescale 1 ns / 10 ps
// Generated from Simulink block 
(* core_generation_info = "dsp_blr_inputonly_2,sysgen_core_2019_1,{,compilation=IP Catalog,block_icon_display=Default,family=zynquplusRFSOC,part=xczu29dr,speed=-1-e,package=ffvf1760,synthesis_language=verilog,hdl_library=xil_defaultlib,synthesis_strategy=Vivado Synthesis Defaults,implementation_strategy=Vivado Implementation Defaults,testbench=1,interface_doc=1,ce_clr=0,clock_period=8,system_simulink_period=8e-09,waveform_viewer=1,axilite_interface=0,ip_catalog_plugin=0,hwcosim_burst_mode=0,simulation_time=0.0001,delay=3,}" *)
module dsp_blr_inputonly_2 (
  input [128-1:0] h_s_axis_tdata,
  input [1-1:0] h_s_axis_tvalid,
  input [32-1:0] l_s_axis_tdata,
  input [1-1:0] l_s_axis_tvalid,
  input clk,
  output [128-1:0] dsp_m_axis_tdata,
  output [1-1:0] dsp_m_axis_tvalid,
  output [128-1:0] h_m_axis_tdata,
  output [1-1:0] h_m_axis_tvalid,
  output [32-1:0] l_m_axis_tdata,
  output [1-1:0] l_m_axis_tvalid
);
  wire clk_1_net;
  wire ce_1_net;
  dsp_blr_inputonly_2_default_clock_driver dsp_blr_inputonly_2_default_clock_driver (
    .dsp_blr_inputonly_2_sysclk(clk),
    .dsp_blr_inputonly_2_sysce(1'b1),
    .dsp_blr_inputonly_2_sysclr(1'b0),
    .dsp_blr_inputonly_2_clk1(clk_1_net),
    .dsp_blr_inputonly_2_ce1(ce_1_net)
  );
  dsp_blr_inputonly_2_struct dsp_blr_inputonly_2_struct (
    .h_s_axis_tdata(h_s_axis_tdata),
    .h_s_axis_tvalid(h_s_axis_tvalid),
    .l_s_axis_tdata(l_s_axis_tdata),
    .l_s_axis_tvalid(l_s_axis_tvalid),
    .clk_1(clk_1_net),
    .ce_1(ce_1_net),
    .dsp_m_axis_tdata(dsp_m_axis_tdata),
    .dsp_m_axis_tvalid(dsp_m_axis_tvalid),
    .h_m_axis_tdata(h_m_axis_tdata),
    .h_m_axis_tvalid(h_m_axis_tvalid),
    .l_m_axis_tdata(l_m_axis_tdata),
    .l_m_axis_tvalid(l_m_axis_tvalid)
  );
endmodule
