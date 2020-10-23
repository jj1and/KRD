# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "ADC_FIFO_DEPTH" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "CHANNEL_ID" -parent ${Page_0}
  ipgui::add_param $IPINST -name "HF_FIFO_DEPTH" -parent ${Page_0} -widget comboBox


}

proc update_PARAM_VALUE.ADC_FIFO_DEPTH { PARAM_VALUE.ADC_FIFO_DEPTH } {
	# Procedure called to update ADC_FIFO_DEPTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADC_FIFO_DEPTH { PARAM_VALUE.ADC_FIFO_DEPTH } {
	# Procedure called to validate ADC_FIFO_DEPTH
	return true
}

proc update_PARAM_VALUE.CHANNEL_ID { PARAM_VALUE.CHANNEL_ID } {
	# Procedure called to update CHANNEL_ID when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CHANNEL_ID { PARAM_VALUE.CHANNEL_ID } {
	# Procedure called to validate CHANNEL_ID
	return true
}

proc update_PARAM_VALUE.HF_FIFO_DEPTH { PARAM_VALUE.HF_FIFO_DEPTH } {
	# Procedure called to update HF_FIFO_DEPTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.HF_FIFO_DEPTH { PARAM_VALUE.HF_FIFO_DEPTH } {
	# Procedure called to validate HF_FIFO_DEPTH
	return true
}


proc update_MODELPARAM_VALUE.CHANNEL_ID { MODELPARAM_VALUE.CHANNEL_ID PARAM_VALUE.CHANNEL_ID } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CHANNEL_ID}] ${MODELPARAM_VALUE.CHANNEL_ID}
}

proc update_MODELPARAM_VALUE.ADC_FIFO_DEPTH { MODELPARAM_VALUE.ADC_FIFO_DEPTH PARAM_VALUE.ADC_FIFO_DEPTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADC_FIFO_DEPTH}] ${MODELPARAM_VALUE.ADC_FIFO_DEPTH}
}

proc update_MODELPARAM_VALUE.HF_FIFO_DEPTH { MODELPARAM_VALUE.HF_FIFO_DEPTH PARAM_VALUE.HF_FIFO_DEPTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.HF_FIFO_DEPTH}] ${MODELPARAM_VALUE.HF_FIFO_DEPTH}
}

