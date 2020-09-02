create_clock -period 8.138 -name {PL_CLK_in_0_clk_p[0]} [get_ports {PL_CLK_in_0_clk_p[0]}]

set_property IOSTANDARD LVCMOS18 [get_ports DATAMOVER_ERROR_LED]
set_property IOSTANDARD LVCMOS18 [get_ports DF_GEN_ERROR_LED]
set_property IOSTANDARD LVCMOS18 [get_ports EXT_RESET]
set_property PACKAGE_PIN AF15 [get_ports EXT_RESET]
set_property PACKAGE_PIN AR16 [get_ports DATAMOVER_ERROR_LED]
set_property PACKAGE_PIN AP13 [get_ports DF_GEN_ERROR_LED]
