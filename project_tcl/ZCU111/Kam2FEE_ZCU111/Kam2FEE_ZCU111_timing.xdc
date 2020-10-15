create_clock -period 8.138 -name {PL_CLK_in_0_clk_p[0]} [get_ports {PL_CLK_in_0_clk_p[0]}]

set_property PACKAGE_PIN AW3 [get_ports EXTERNAL_TRIGGER_0]
set_property IOSTANDARD LVCMOS18 [get_ports EXTERNAL_TRIGGER_0]
set_property PACKAGE_PIN AW4 [get_ports EXTERNAL_TRIGGER_1]
set_property IOSTANDARD LVCMOS18 [get_ports EXTERNAL_TRIGGER_1]
set_property PACKAGE_PIN E8 [get_ports EXTERNAL_TRIGGER_2]
set_property IOSTANDARD LVCMOS18 [get_ports EXTERNAL_TRIGGER_2]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk]
