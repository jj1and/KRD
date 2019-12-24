set_property PACKAGE_PIN J19 [get_ports CLK_IN1_D_0_clk_p]

set_property IOSTANDARD LVDS [get_ports CLK_IN1_D_0_clk_p]
set_property IOSTANDARD LVDS [get_ports CLK_IN1_D_0_clk_n]

set_property IOSTANDARD LVCMOS18 [get_ports CH0_TRG_VALID]
set_property IOSTANDARD LVCMOS18 [get_ports CH1_TRG_VALID]
set_property PACKAGE_PIN AR16 [get_ports CH0_TRG_VALID]
set_property PACKAGE_PIN AP13 [get_ports CH1_TRG_VALID]
set_property PACKAGE_PIN AP15 [get_ports locked_0]
set_property IOSTANDARD LVCMOS18 [get_ports locked_0]
set_property PACKAGE_PIN AP16 [get_ports LED_OUT_0]
set_property IOSTANDARD LVCMOS18 [get_ports LED_OUT_0]

set_property PACKAGE_PIN AF16 [get_ports CH0_EXT_READY]
set_property IOSTANDARD LVCMOS18 [get_ports CH0_EXT_READY]
set_property PACKAGE_PIN AF17 [get_ports CH1_EXT_READY]
set_property IOSTANDARD LVCMOS18 [get_ports CH1_EXT_READY]



create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 2 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 6 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list design_1_i/clk_wiz_0/inst/clk_out2]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 64 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {design_1_i/MinimumTrigger_0/DOUT[0]} {design_1_i/MinimumTrigger_0/DOUT[1]} {design_1_i/MinimumTrigger_0/DOUT[2]} {design_1_i/MinimumTrigger_0/DOUT[3]} {design_1_i/MinimumTrigger_0/DOUT[4]} {design_1_i/MinimumTrigger_0/DOUT[5]} {design_1_i/MinimumTrigger_0/DOUT[6]} {design_1_i/MinimumTrigger_0/DOUT[7]} {design_1_i/MinimumTrigger_0/DOUT[8]} {design_1_i/MinimumTrigger_0/DOUT[9]} {design_1_i/MinimumTrigger_0/DOUT[10]} {design_1_i/MinimumTrigger_0/DOUT[11]} {design_1_i/MinimumTrigger_0/DOUT[12]} {design_1_i/MinimumTrigger_0/DOUT[13]} {design_1_i/MinimumTrigger_0/DOUT[14]} {design_1_i/MinimumTrigger_0/DOUT[15]} {design_1_i/MinimumTrigger_0/DOUT[16]} {design_1_i/MinimumTrigger_0/DOUT[17]} {design_1_i/MinimumTrigger_0/DOUT[18]} {design_1_i/MinimumTrigger_0/DOUT[19]} {design_1_i/MinimumTrigger_0/DOUT[20]} {design_1_i/MinimumTrigger_0/DOUT[21]} {design_1_i/MinimumTrigger_0/DOUT[22]} {design_1_i/MinimumTrigger_0/DOUT[23]} {design_1_i/MinimumTrigger_0/DOUT[24]} {design_1_i/MinimumTrigger_0/DOUT[25]} {design_1_i/MinimumTrigger_0/DOUT[26]} {design_1_i/MinimumTrigger_0/DOUT[27]} {design_1_i/MinimumTrigger_0/DOUT[28]} {design_1_i/MinimumTrigger_0/DOUT[29]} {design_1_i/MinimumTrigger_0/DOUT[30]} {design_1_i/MinimumTrigger_0/DOUT[31]} {design_1_i/MinimumTrigger_0/DOUT[32]} {design_1_i/MinimumTrigger_0/DOUT[33]} {design_1_i/MinimumTrigger_0/DOUT[34]} {design_1_i/MinimumTrigger_0/DOUT[35]} {design_1_i/MinimumTrigger_0/DOUT[36]} {design_1_i/MinimumTrigger_0/DOUT[37]} {design_1_i/MinimumTrigger_0/DOUT[38]} {design_1_i/MinimumTrigger_0/DOUT[39]} {design_1_i/MinimumTrigger_0/DOUT[40]} {design_1_i/MinimumTrigger_0/DOUT[41]} {design_1_i/MinimumTrigger_0/DOUT[42]} {design_1_i/MinimumTrigger_0/DOUT[43]} {design_1_i/MinimumTrigger_0/DOUT[44]} {design_1_i/MinimumTrigger_0/DOUT[45]} {design_1_i/MinimumTrigger_0/DOUT[46]} {design_1_i/MinimumTrigger_0/DOUT[47]} {design_1_i/MinimumTrigger_0/DOUT[48]} {design_1_i/MinimumTrigger_0/DOUT[49]} {design_1_i/MinimumTrigger_0/DOUT[50]} {design_1_i/MinimumTrigger_0/DOUT[51]} {design_1_i/MinimumTrigger_0/DOUT[52]} {design_1_i/MinimumTrigger_0/DOUT[53]} {design_1_i/MinimumTrigger_0/DOUT[54]} {design_1_i/MinimumTrigger_0/DOUT[55]} {design_1_i/MinimumTrigger_0/DOUT[56]} {design_1_i/MinimumTrigger_0/DOUT[57]} {design_1_i/MinimumTrigger_0/DOUT[58]} {design_1_i/MinimumTrigger_0/DOUT[59]} {design_1_i/MinimumTrigger_0/DOUT[60]} {design_1_i/MinimumTrigger_0/DOUT[61]} {design_1_i/MinimumTrigger_0/DOUT[62]} {design_1_i/MinimumTrigger_0/DOUT[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 64 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {design_1_i/MinimumTrigger_1/DOUT[0]} {design_1_i/MinimumTrigger_1/DOUT[1]} {design_1_i/MinimumTrigger_1/DOUT[2]} {design_1_i/MinimumTrigger_1/DOUT[3]} {design_1_i/MinimumTrigger_1/DOUT[4]} {design_1_i/MinimumTrigger_1/DOUT[5]} {design_1_i/MinimumTrigger_1/DOUT[6]} {design_1_i/MinimumTrigger_1/DOUT[7]} {design_1_i/MinimumTrigger_1/DOUT[8]} {design_1_i/MinimumTrigger_1/DOUT[9]} {design_1_i/MinimumTrigger_1/DOUT[10]} {design_1_i/MinimumTrigger_1/DOUT[11]} {design_1_i/MinimumTrigger_1/DOUT[12]} {design_1_i/MinimumTrigger_1/DOUT[13]} {design_1_i/MinimumTrigger_1/DOUT[14]} {design_1_i/MinimumTrigger_1/DOUT[15]} {design_1_i/MinimumTrigger_1/DOUT[16]} {design_1_i/MinimumTrigger_1/DOUT[17]} {design_1_i/MinimumTrigger_1/DOUT[18]} {design_1_i/MinimumTrigger_1/DOUT[19]} {design_1_i/MinimumTrigger_1/DOUT[20]} {design_1_i/MinimumTrigger_1/DOUT[21]} {design_1_i/MinimumTrigger_1/DOUT[22]} {design_1_i/MinimumTrigger_1/DOUT[23]} {design_1_i/MinimumTrigger_1/DOUT[24]} {design_1_i/MinimumTrigger_1/DOUT[25]} {design_1_i/MinimumTrigger_1/DOUT[26]} {design_1_i/MinimumTrigger_1/DOUT[27]} {design_1_i/MinimumTrigger_1/DOUT[28]} {design_1_i/MinimumTrigger_1/DOUT[29]} {design_1_i/MinimumTrigger_1/DOUT[30]} {design_1_i/MinimumTrigger_1/DOUT[31]} {design_1_i/MinimumTrigger_1/DOUT[32]} {design_1_i/MinimumTrigger_1/DOUT[33]} {design_1_i/MinimumTrigger_1/DOUT[34]} {design_1_i/MinimumTrigger_1/DOUT[35]} {design_1_i/MinimumTrigger_1/DOUT[36]} {design_1_i/MinimumTrigger_1/DOUT[37]} {design_1_i/MinimumTrigger_1/DOUT[38]} {design_1_i/MinimumTrigger_1/DOUT[39]} {design_1_i/MinimumTrigger_1/DOUT[40]} {design_1_i/MinimumTrigger_1/DOUT[41]} {design_1_i/MinimumTrigger_1/DOUT[42]} {design_1_i/MinimumTrigger_1/DOUT[43]} {design_1_i/MinimumTrigger_1/DOUT[44]} {design_1_i/MinimumTrigger_1/DOUT[45]} {design_1_i/MinimumTrigger_1/DOUT[46]} {design_1_i/MinimumTrigger_1/DOUT[47]} {design_1_i/MinimumTrigger_1/DOUT[48]} {design_1_i/MinimumTrigger_1/DOUT[49]} {design_1_i/MinimumTrigger_1/DOUT[50]} {design_1_i/MinimumTrigger_1/DOUT[51]} {design_1_i/MinimumTrigger_1/DOUT[52]} {design_1_i/MinimumTrigger_1/DOUT[53]} {design_1_i/MinimumTrigger_1/DOUT[54]} {design_1_i/MinimumTrigger_1/DOUT[55]} {design_1_i/MinimumTrigger_1/DOUT[56]} {design_1_i/MinimumTrigger_1/DOUT[57]} {design_1_i/MinimumTrigger_1/DOUT[58]} {design_1_i/MinimumTrigger_1/DOUT[59]} {design_1_i/MinimumTrigger_1/DOUT[60]} {design_1_i/MinimumTrigger_1/DOUT[61]} {design_1_i/MinimumTrigger_1/DOUT[62]} {design_1_i/MinimumTrigger_1/DOUT[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 1 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list CH0_TRG_VALID_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 1 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list CH1_TRG_VALID_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list CH0_EXT_READY_IBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 1 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list CH1_EXT_READY_IBUF]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets u_ila_0_clk_out2]
