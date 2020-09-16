create_clock -period 8.138 -name {PL_CLK_in_clk_p[0]} [get_ports {PL_CLK_in_clk_p[0]}]

create_generated_clock -name mts_clk_pl_adc_clk [get_pins design_1_i/mts_clk/clk_wiz_ADC/inst/mmcme4_adv_inst/CLKOUT0]
create_generated_clock -name mts_clk_pl_dac_clk [get_pins design_1_i/mts_clk/clk_wiz_DAC/inst/mmcme4_adv_inst/CLKOUT0]

set_clock_groups -name asy_grp1 -asynchronous -group [get_clocks RFDAC0_CLK]  -group [get_clocks RFDAC1_CLK] -group [get_clocks mts_clk_pl_adc_clk] -group [get_clocks mts_clk_pl_dac_clk] -group [get_clocks clk_pl_0]

set_property CLOCK_DELAY_GROUP MTS_ADC [get_nets -of_objects [get_pins design_1_i/mts_clk/clk_wiz_ADC/inst/clk_out1]]
set_property CLOCK_DELAY_GROUP MTS_DAC [get_nets -of_objects [get_pins design_1_i/mts_clk/clk_wiz_DAC/inst/clk_out1]]

set_property ASYNC_REG false [get_cells {design_1_i/mts_clk/sync_*/inst/xpm_cdc_single_inst/syncstages_ff_reg[*]}]
