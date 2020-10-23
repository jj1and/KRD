# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "ADDRESS_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "BASE_ADDRESS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "CHANNEL_ID_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "FRAME_LENGTH_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "HEADER_FOOTER_ID_WIDTH" -parent ${Page_0}
  set LOCAL_ADDRESS_WIDTH [ipgui::add_param $IPINST -name "LOCAL_ADDRESS_WIDTH" -parent ${Page_0}]
  set_property tooltip {Address width assigned for this ip} ${LOCAL_ADDRESS_WIDTH}
  ipgui::add_param $IPINST -name "TDATA_WIDTH" -parent ${Page_0}


}

proc update_PARAM_VALUE.ADDRESS_WIDTH { PARAM_VALUE.ADDRESS_WIDTH } {
	# Procedure called to update ADDRESS_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADDRESS_WIDTH { PARAM_VALUE.ADDRESS_WIDTH } {
	# Procedure called to validate ADDRESS_WIDTH
	return true
}

proc update_PARAM_VALUE.BASE_ADDRESS { PARAM_VALUE.BASE_ADDRESS } {
	# Procedure called to update BASE_ADDRESS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BASE_ADDRESS { PARAM_VALUE.BASE_ADDRESS } {
	# Procedure called to validate BASE_ADDRESS
	return true
}

proc update_PARAM_VALUE.CHANNEL_ID_WIDTH { PARAM_VALUE.CHANNEL_ID_WIDTH } {
	# Procedure called to update CHANNEL_ID_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CHANNEL_ID_WIDTH { PARAM_VALUE.CHANNEL_ID_WIDTH } {
	# Procedure called to validate CHANNEL_ID_WIDTH
	return true
}

proc update_PARAM_VALUE.FRAME_LENGTH_WIDTH { PARAM_VALUE.FRAME_LENGTH_WIDTH } {
	# Procedure called to update FRAME_LENGTH_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FRAME_LENGTH_WIDTH { PARAM_VALUE.FRAME_LENGTH_WIDTH } {
	# Procedure called to validate FRAME_LENGTH_WIDTH
	return true
}

proc update_PARAM_VALUE.HEADER_FOOTER_ID_WIDTH { PARAM_VALUE.HEADER_FOOTER_ID_WIDTH } {
	# Procedure called to update HEADER_FOOTER_ID_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.HEADER_FOOTER_ID_WIDTH { PARAM_VALUE.HEADER_FOOTER_ID_WIDTH } {
	# Procedure called to validate HEADER_FOOTER_ID_WIDTH
	return true
}

proc update_PARAM_VALUE.LOCAL_ADDRESS_WIDTH { PARAM_VALUE.LOCAL_ADDRESS_WIDTH } {
	# Procedure called to update LOCAL_ADDRESS_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LOCAL_ADDRESS_WIDTH { PARAM_VALUE.LOCAL_ADDRESS_WIDTH } {
	# Procedure called to validate LOCAL_ADDRESS_WIDTH
	return true
}

proc update_PARAM_VALUE.TDATA_WIDTH { PARAM_VALUE.TDATA_WIDTH } {
	# Procedure called to update TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TDATA_WIDTH { PARAM_VALUE.TDATA_WIDTH } {
	# Procedure called to validate TDATA_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.TDATA_WIDTH { MODELPARAM_VALUE.TDATA_WIDTH PARAM_VALUE.TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TDATA_WIDTH}] ${MODELPARAM_VALUE.TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.HEADER_FOOTER_ID_WIDTH { MODELPARAM_VALUE.HEADER_FOOTER_ID_WIDTH PARAM_VALUE.HEADER_FOOTER_ID_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.HEADER_FOOTER_ID_WIDTH}] ${MODELPARAM_VALUE.HEADER_FOOTER_ID_WIDTH}
}

proc update_MODELPARAM_VALUE.CHANNEL_ID_WIDTH { MODELPARAM_VALUE.CHANNEL_ID_WIDTH PARAM_VALUE.CHANNEL_ID_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CHANNEL_ID_WIDTH}] ${MODELPARAM_VALUE.CHANNEL_ID_WIDTH}
}

proc update_MODELPARAM_VALUE.FRAME_LENGTH_WIDTH { MODELPARAM_VALUE.FRAME_LENGTH_WIDTH PARAM_VALUE.FRAME_LENGTH_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FRAME_LENGTH_WIDTH}] ${MODELPARAM_VALUE.FRAME_LENGTH_WIDTH}
}

proc update_MODELPARAM_VALUE.ADDRESS_WIDTH { MODELPARAM_VALUE.ADDRESS_WIDTH PARAM_VALUE.ADDRESS_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADDRESS_WIDTH}] ${MODELPARAM_VALUE.ADDRESS_WIDTH}
}

proc update_MODELPARAM_VALUE.LOCAL_ADDRESS_WIDTH { MODELPARAM_VALUE.LOCAL_ADDRESS_WIDTH PARAM_VALUE.LOCAL_ADDRESS_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LOCAL_ADDRESS_WIDTH}] ${MODELPARAM_VALUE.LOCAL_ADDRESS_WIDTH}
}

proc update_MODELPARAM_VALUE.BASE_ADDRESS { MODELPARAM_VALUE.BASE_ADDRESS PARAM_VALUE.BASE_ADDRESS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BASE_ADDRESS}] ${MODELPARAM_VALUE.BASE_ADDRESS}
}

