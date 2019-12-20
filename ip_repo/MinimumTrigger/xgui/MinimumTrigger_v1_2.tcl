
# Loading additional proc with user specified bodies to compute parameter values.
source [file join [file dirname [file dirname [info script]]] gui/MinimumTrigger_v1_0.gtcl]

# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "ADC_RESOLUTION_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "CHANNEL_ID" -parent ${Page_0}
  ipgui::add_param $IPINST -name "FIRST_TIME_STAMP_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "HIT_DETECTION_WINDOW_WORD" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MAX_FRAME_LENGTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "POST_ACQUI_LEN" -parent ${Page_0}

  ipgui::add_param $IPINST -name "MAX_DELAY_CNT_WIDTH"
  ipgui::add_param $IPINST -name "TIME_STAMP_WIDTH"

}

proc update_PARAM_VALUE.POST_ACQUI_LEN { PARAM_VALUE.POST_ACQUI_LEN PARAM_VALUE.POST_ACQUI_LEN PARAM_VALUE.MAX_FRAME_LENGTH PARAM_VALUE.MAX_DELAY_CNT_WIDTH } {
	# Procedure called to update POST_ACQUI_LEN when any of the dependent parameters in the arguments change
	
	set POST_ACQUI_LEN ${PARAM_VALUE.POST_ACQUI_LEN}
	set MAX_FRAME_LENGTH ${PARAM_VALUE.MAX_FRAME_LENGTH}
	set MAX_DELAY_CNT_WIDTH ${PARAM_VALUE.MAX_DELAY_CNT_WIDTH}
	set values(POST_ACQUI_LEN) [get_property value $POST_ACQUI_LEN]
	set values(MAX_FRAME_LENGTH) [get_property value $MAX_FRAME_LENGTH]
	set values(MAX_DELAY_CNT_WIDTH) [get_property value $MAX_DELAY_CNT_WIDTH]
	if { [gen_USERPARAMETER_POST_ACQUI_LEN_ENABLEMENT $values(POST_ACQUI_LEN) $values(MAX_FRAME_LENGTH) $values(MAX_DELAY_CNT_WIDTH)] } {
		set_property enabled true $POST_ACQUI_LEN
	} else {
		set_property enabled false $POST_ACQUI_LEN
	}
}

proc validate_PARAM_VALUE.POST_ACQUI_LEN { PARAM_VALUE.POST_ACQUI_LEN } {
	# Procedure called to validate POST_ACQUI_LEN
	return true
}

proc update_PARAM_VALUE.ADC_RESOLUTION_WIDTH { PARAM_VALUE.ADC_RESOLUTION_WIDTH } {
	# Procedure called to update ADC_RESOLUTION_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADC_RESOLUTION_WIDTH { PARAM_VALUE.ADC_RESOLUTION_WIDTH } {
	# Procedure called to validate ADC_RESOLUTION_WIDTH
	return true
}

proc update_PARAM_VALUE.CHANNEL_ID { PARAM_VALUE.CHANNEL_ID } {
	# Procedure called to update CHANNEL_ID when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CHANNEL_ID { PARAM_VALUE.CHANNEL_ID } {
	# Procedure called to validate CHANNEL_ID
	return true
}

proc update_PARAM_VALUE.DOUT_WIDTH { PARAM_VALUE.DOUT_WIDTH } {
	# Procedure called to update DOUT_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DOUT_WIDTH { PARAM_VALUE.DOUT_WIDTH } {
	# Procedure called to validate DOUT_WIDTH
	return true
}

proc update_PARAM_VALUE.FIRST_TIME_STAMP_WIDTH { PARAM_VALUE.FIRST_TIME_STAMP_WIDTH } {
	# Procedure called to update FIRST_TIME_STAMP_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FIRST_TIME_STAMP_WIDTH { PARAM_VALUE.FIRST_TIME_STAMP_WIDTH } {
	# Procedure called to validate FIRST_TIME_STAMP_WIDTH
	return true
}

proc update_PARAM_VALUE.HIT_DETECTION_WINDOW_WORD { PARAM_VALUE.HIT_DETECTION_WINDOW_WORD } {
	# Procedure called to update HIT_DETECTION_WINDOW_WORD when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.HIT_DETECTION_WINDOW_WORD { PARAM_VALUE.HIT_DETECTION_WINDOW_WORD } {
	# Procedure called to validate HIT_DETECTION_WINDOW_WORD
	return true
}

proc update_PARAM_VALUE.MAX_DELAY_CNT_WIDTH { PARAM_VALUE.MAX_DELAY_CNT_WIDTH } {
	# Procedure called to update MAX_DELAY_CNT_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAX_DELAY_CNT_WIDTH { PARAM_VALUE.MAX_DELAY_CNT_WIDTH } {
	# Procedure called to validate MAX_DELAY_CNT_WIDTH
	return true
}

proc update_PARAM_VALUE.MAX_FRAME_LENGTH { PARAM_VALUE.MAX_FRAME_LENGTH } {
	# Procedure called to update MAX_FRAME_LENGTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAX_FRAME_LENGTH { PARAM_VALUE.MAX_FRAME_LENGTH } {
	# Procedure called to validate MAX_FRAME_LENGTH
	return true
}

proc update_PARAM_VALUE.TDATA_WIDTH { PARAM_VALUE.TDATA_WIDTH } {
	# Procedure called to update TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TDATA_WIDTH { PARAM_VALUE.TDATA_WIDTH } {
	# Procedure called to validate TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.TIME_STAMP_WIDTH { PARAM_VALUE.TIME_STAMP_WIDTH } {
	# Procedure called to update TIME_STAMP_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TIME_STAMP_WIDTH { PARAM_VALUE.TIME_STAMP_WIDTH } {
	# Procedure called to validate TIME_STAMP_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.HIT_DETECTION_WINDOW_WORD { MODELPARAM_VALUE.HIT_DETECTION_WINDOW_WORD PARAM_VALUE.HIT_DETECTION_WINDOW_WORD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.HIT_DETECTION_WINDOW_WORD}] ${MODELPARAM_VALUE.HIT_DETECTION_WINDOW_WORD}
}

proc update_MODELPARAM_VALUE.CHANNEL_ID { MODELPARAM_VALUE.CHANNEL_ID PARAM_VALUE.CHANNEL_ID } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CHANNEL_ID}] ${MODELPARAM_VALUE.CHANNEL_ID}
}

proc update_MODELPARAM_VALUE.ADC_RESOLUTION_WIDTH { MODELPARAM_VALUE.ADC_RESOLUTION_WIDTH PARAM_VALUE.ADC_RESOLUTION_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADC_RESOLUTION_WIDTH}] ${MODELPARAM_VALUE.ADC_RESOLUTION_WIDTH}
}

proc update_MODELPARAM_VALUE.MAX_FRAME_LENGTH { MODELPARAM_VALUE.MAX_FRAME_LENGTH PARAM_VALUE.MAX_FRAME_LENGTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAX_FRAME_LENGTH}] ${MODELPARAM_VALUE.MAX_FRAME_LENGTH}
}

proc update_MODELPARAM_VALUE.MAX_DELAY_CNT_WIDTH { MODELPARAM_VALUE.MAX_DELAY_CNT_WIDTH PARAM_VALUE.MAX_DELAY_CNT_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAX_DELAY_CNT_WIDTH}] ${MODELPARAM_VALUE.MAX_DELAY_CNT_WIDTH}
}

proc update_MODELPARAM_VALUE.POST_ACQUI_LEN { MODELPARAM_VALUE.POST_ACQUI_LEN PARAM_VALUE.POST_ACQUI_LEN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.POST_ACQUI_LEN}] ${MODELPARAM_VALUE.POST_ACQUI_LEN}
}

proc update_MODELPARAM_VALUE.TIME_STAMP_WIDTH { MODELPARAM_VALUE.TIME_STAMP_WIDTH PARAM_VALUE.TIME_STAMP_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TIME_STAMP_WIDTH}] ${MODELPARAM_VALUE.TIME_STAMP_WIDTH}
}

proc update_MODELPARAM_VALUE.FIRST_TIME_STAMP_WIDTH { MODELPARAM_VALUE.FIRST_TIME_STAMP_WIDTH PARAM_VALUE.FIRST_TIME_STAMP_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FIRST_TIME_STAMP_WIDTH}] ${MODELPARAM_VALUE.FIRST_TIME_STAMP_WIDTH}
}

proc update_MODELPARAM_VALUE.TDATA_WIDTH { MODELPARAM_VALUE.TDATA_WIDTH PARAM_VALUE.TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TDATA_WIDTH}] ${MODELPARAM_VALUE.TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.DOUT_WIDTH { MODELPARAM_VALUE.DOUT_WIDTH PARAM_VALUE.DOUT_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DOUT_WIDTH}] ${MODELPARAM_VALUE.DOUT_WIDTH}
}

