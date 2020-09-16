set_property PACKAGE_PIN AF15 [get_ports EXT_RESET]
set_property IOSTANDARD LVCMOS18 [get_ports EXT_RESET]
set_property PACKAGE_PIN AP13 [get_ports ADC_CLK_LED]
set_property IOSTANDARD LVCMOS18 [get_ports ADC_CLK_LED]
set_property PACKAGE_PIN AR16 [get_ports DAC_LED_OUT]
set_property IOSTANDARD LVCMOS18 [get_ports DAC_LED_OUT]

set_property PACKAGE_PIN AL16 [get_ports {PL_CLK_in_clk_p[0]}]
set_property PACKAGE_PIN AL15 [get_ports {PL_CLK_in_clk_n[0]}]
set_property PACKAGE_PIN AK17 [get_ports {PL_SYSREF_CLK_in_clk_p[0]}]
set_property PACKAGE_PIN AK16 [get_ports {PL_SYSREF_CLK_in_clk_n[0]}]

set_property IOSTANDARD LVDS [get_ports {PL_CLK_in_clk_p[0]}]
set_property IOSTANDARD LVDS [get_ports {PL_CLK_in_clk_n[0]}]
set_property IOSTANDARD LVDS [get_ports {PL_SYSREF_CLK_in_clk_p[0]}]
set_property IOSTANDARD LVDS [get_ports {PL_SYSREF_CLK_in_clk_n[0]}]

set_property DIFF_TERM_ADV TERM_100 [get_ports {PL_CLK_in_clk_p[0]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {PL_SYSREF_CLK_in_clk_p[0]}]

set_property DQS_BIAS TRUE [get_ports {PL_CLK_in_clk_p[0]}]
set_property DQS_BIAS TRUE [get_ports {PL_CLK_in_clk_n[0]}]
set_property DQS_BIAS TRUE [get_ports {PL_SYSREF_CLK_in_clk_p[0]}]
set_property DQS_BIAS TRUE [get_ports {PL_SYSREF_CLK_in_clk_n[0]}]


