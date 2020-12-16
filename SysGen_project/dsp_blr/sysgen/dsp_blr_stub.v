`timescale 1 ns / 10 ps
// Generated from Simulink block 
module dsp_blr_stub (
  input [128-1:0] h_s_axis_tdata,
  input [1-1:0] h_s_axis_tvalid,
  input [32-1:0] l_s_axis_tdata,
  input [1-1:0] l_s_axis_tvalid,
  input clk,
  output [160-1:0] dsp_m_axis_tdata,
  output [1-1:0] dsp_m_axis_tvalid,
  output [128-1:0] h_m_axis_tdata,
  output [1-1:0] h_m_axis_tvalid,
  output [32-1:0] l_m_axis_tdata,
  output [1-1:0] l_m_axis_tvalid
);
  dsp_blr sysgen_dut (
    .h_s_axis_tdata(h_s_axis_tdata),
    .h_s_axis_tvalid(h_s_axis_tvalid),
    .l_s_axis_tdata(l_s_axis_tdata),
    .l_s_axis_tvalid(l_s_axis_tvalid),
    .clk(clk),
    .dsp_m_axis_tdata(dsp_m_axis_tdata),
    .dsp_m_axis_tvalid(dsp_m_axis_tvalid),
    .h_m_axis_tdata(h_m_axis_tdata),
    .h_m_axis_tvalid(h_m_axis_tvalid),
    .l_m_axis_tdata(l_m_axis_tdata),
    .l_m_axis_tvalid(l_m_axis_tvalid)
  );
endmodule
