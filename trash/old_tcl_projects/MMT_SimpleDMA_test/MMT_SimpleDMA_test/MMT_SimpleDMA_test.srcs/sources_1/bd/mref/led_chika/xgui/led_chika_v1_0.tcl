# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "CLOCK_FREQ_MHZ" -parent ${Page_0}
  ipgui::add_param $IPINST -name "INTERVAL_MSEC" -parent ${Page_0}


}

proc update_PARAM_VALUE.CLOCK_FREQ_MHZ { PARAM_VALUE.CLOCK_FREQ_MHZ } {
	# Procedure called to update CLOCK_FREQ_MHZ when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CLOCK_FREQ_MHZ { PARAM_VALUE.CLOCK_FREQ_MHZ } {
	# Procedure called to validate CLOCK_FREQ_MHZ
	return true
}

proc update_PARAM_VALUE.INTERVAL_MSEC { PARAM_VALUE.INTERVAL_MSEC } {
	# Procedure called to update INTERVAL_MSEC when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.INTERVAL_MSEC { PARAM_VALUE.INTERVAL_MSEC } {
	# Procedure called to validate INTERVAL_MSEC
	return true
}


proc update_MODELPARAM_VALUE.CLOCK_FREQ_MHZ { MODELPARAM_VALUE.CLOCK_FREQ_MHZ PARAM_VALUE.CLOCK_FREQ_MHZ } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CLOCK_FREQ_MHZ}] ${MODELPARAM_VALUE.CLOCK_FREQ_MHZ}
}

proc update_MODELPARAM_VALUE.INTERVAL_MSEC { MODELPARAM_VALUE.INTERVAL_MSEC PARAM_VALUE.INTERVAL_MSEC } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INTERVAL_MSEC}] ${MODELPARAM_VALUE.INTERVAL_MSEC}
}

