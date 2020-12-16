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
