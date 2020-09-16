set_property PACKAGE_PIN AL17 [get_ports CLK_IN1_D_0_clk_p]
set_property IOSTANDARD LVDS [get_ports CLK_IN1_D_0_clk_p]
set_property IOSTANDARD LVCMOS18 [get_ports DATAFRAME_GEN_ERROR_LED]

set_property PACKAGE_PIN AP13 [get_ports CLK_LOCKED_LED]
set_property IOSTANDARD LVCMOS18 [get_ports CLK_LOCKED_LED]
set_property PACKAGE_PIN AF15 [get_ports EXT_RESET]
set_property PACKAGE_PIN AR13 [get_ports RESET_LED]
set_property IOSTANDARD LVCMOS18 [get_ports RESET_LED]
set_property IOSTANDARD LVCMOS18 [get_ports EXT_RESET]

set_property PACKAGE_PIN J19 [get_ports diff_clock_rtl_clk_p]
set_property IOSTANDARD LVDS [get_ports diff_clock_rtl_clk_p]
set_property IOSTANDARD LVDS [get_ports diff_clock_rtl_clk_n]

set_property PACKAGE_PIN AR16 [get_ports DATAFRAME_GEN_ERROR_LED]
set_property PACKAGE_PIN AP16 [get_ports DATAMOVER_ERROR_LED]
set_property IOSTANDARD LVCMOS18 [get_ports DATAMOVER_ERROR_LED]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk]
