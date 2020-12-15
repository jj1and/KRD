
################################################################
# This is a generated script based on design: rfdc_block
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2019.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source rfdc_block_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xczu29dr-ffvf1760-1-e
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name rfdc_block

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:usp_rf_data_converter:2.1\
"

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: rfadc_block
proc create_hier_cell_rfadc_block { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_rfadc_block() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_RFADC

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_RFADC1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_RFADC2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_RFADC3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_RFADC4

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_RFADC5

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_RFADC6

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_RFADC7

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_RFADC8

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_RFADC9

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_RFADC10

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_RFADC11

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_RFADC12

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_RFADC13

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_RFADC14

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_RFADC15

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 adc0_clk

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 adc1_clk

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 adc2_clk

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 adc3_clk

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_usp_rf_data_converter:diff_pins_rtl:1.0 sysref_in

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin00

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin01

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin02

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin03

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin10

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin11

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin12

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin13

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin20

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin21

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin22

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin23

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin30

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin31

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin32

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin33


  # Create pins
  create_bd_pin -dir I -type clk m1_axis_aclk
  create_bd_pin -dir I -type rst m2_axis_aresetn
  create_bd_pin -dir I user_sysref_adc

  # Create instance: usp_rf_data_converter_0, and set properties
  set usp_rf_data_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:usp_rf_data_converter:2.1 usp_rf_data_converter_0 ]
  set_property -dict [ list \
   CONFIG.ADC0_Fabric_Freq {125.000} \
   CONFIG.ADC0_Link_Coupling {1} \
   CONFIG.ADC0_Multi_Tile_Sync {true} \
   CONFIG.ADC0_Outclk_Freq {125.000} \
   CONFIG.ADC0_PLL_Enable {true} \
   CONFIG.ADC0_Refclk_Freq {250.000} \
   CONFIG.ADC1_Enable {1} \
   CONFIG.ADC1_Fabric_Freq {125.000} \
   CONFIG.ADC1_Link_Coupling {1} \
   CONFIG.ADC1_Multi_Tile_Sync {true} \
   CONFIG.ADC1_Outclk_Freq {125.000} \
   CONFIG.ADC1_PLL_Enable {true} \
   CONFIG.ADC1_Refclk_Freq {250.000} \
   CONFIG.ADC2_Enable {1} \
   CONFIG.ADC2_Fabric_Freq {125.000} \
   CONFIG.ADC2_Link_Coupling {1} \
   CONFIG.ADC2_Multi_Tile_Sync {true} \
   CONFIG.ADC2_Outclk_Freq {125.000} \
   CONFIG.ADC2_PLL_Enable {true} \
   CONFIG.ADC2_Refclk_Freq {250.000} \
   CONFIG.ADC3_Enable {1} \
   CONFIG.ADC3_Fabric_Freq {125.000} \
   CONFIG.ADC3_Link_Coupling {1} \
   CONFIG.ADC3_Multi_Tile_Sync {true} \
   CONFIG.ADC3_Outclk_Freq {125.000} \
   CONFIG.ADC3_PLL_Enable {true} \
   CONFIG.ADC3_Refclk_Freq {250.000} \
   CONFIG.ADC_Decimation_Mode00 {2} \
   CONFIG.ADC_Decimation_Mode01 {2} \
   CONFIG.ADC_Decimation_Mode02 {2} \
   CONFIG.ADC_Decimation_Mode03 {2} \
   CONFIG.ADC_Decimation_Mode10 {2} \
   CONFIG.ADC_Decimation_Mode11 {2} \
   CONFIG.ADC_Decimation_Mode12 {2} \
   CONFIG.ADC_Decimation_Mode13 {2} \
   CONFIG.ADC_Decimation_Mode20 {2} \
   CONFIG.ADC_Decimation_Mode21 {2} \
   CONFIG.ADC_Decimation_Mode22 {2} \
   CONFIG.ADC_Decimation_Mode23 {2} \
   CONFIG.ADC_Decimation_Mode30 {2} \
   CONFIG.ADC_Decimation_Mode31 {2} \
   CONFIG.ADC_Decimation_Mode32 {2} \
   CONFIG.ADC_Decimation_Mode33 {2} \
   CONFIG.ADC_Mixer_Type01 {0} \
   CONFIG.ADC_Mixer_Type02 {0} \
   CONFIG.ADC_Mixer_Type03 {0} \
   CONFIG.ADC_Mixer_Type10 {0} \
   CONFIG.ADC_Mixer_Type11 {0} \
   CONFIG.ADC_Mixer_Type12 {0} \
   CONFIG.ADC_Mixer_Type13 {0} \
   CONFIG.ADC_Mixer_Type20 {0} \
   CONFIG.ADC_Mixer_Type21 {0} \
   CONFIG.ADC_Mixer_Type22 {0} \
   CONFIG.ADC_Mixer_Type23 {0} \
   CONFIG.ADC_Mixer_Type30 {0} \
   CONFIG.ADC_Mixer_Type31 {0} \
   CONFIG.ADC_Mixer_Type32 {0} \
   CONFIG.ADC_Mixer_Type33 {0} \
   CONFIG.ADC_Slice01_Enable {true} \
   CONFIG.ADC_Slice02_Enable {true} \
   CONFIG.ADC_Slice03_Enable {true} \
   CONFIG.ADC_Slice10_Enable {true} \
   CONFIG.ADC_Slice11_Enable {true} \
   CONFIG.ADC_Slice12_Enable {true} \
   CONFIG.ADC_Slice13_Enable {true} \
   CONFIG.ADC_Slice20_Enable {true} \
   CONFIG.ADC_Slice21_Enable {true} \
   CONFIG.ADC_Slice22_Enable {true} \
   CONFIG.ADC_Slice23_Enable {true} \
   CONFIG.ADC_Slice30_Enable {true} \
   CONFIG.ADC_Slice31_Enable {true} \
   CONFIG.ADC_Slice32_Enable {true} \
   CONFIG.ADC_Slice33_Enable {true} \
   CONFIG.Axiclk_Freq {125.0} \
   CONFIG.DAC0_Enable {0} \
   CONFIG.DAC0_Fabric_Freq {0.0} \
   CONFIG.DAC0_Multi_Tile_Sync {false} \
   CONFIG.DAC0_Outclk_Freq {50.000} \
   CONFIG.DAC0_PLL_Enable {false} \
   CONFIG.DAC0_Refclk_Freq {6400.000} \
   CONFIG.DAC0_Sampling_Rate {6.4} \
   CONFIG.DAC1_Enable {0} \
   CONFIG.DAC1_Fabric_Freq {0.0} \
   CONFIG.DAC1_Multi_Tile_Sync {false} \
   CONFIG.DAC1_Outclk_Freq {50.000} \
   CONFIG.DAC1_PLL_Enable {false} \
   CONFIG.DAC1_Refclk_Freq {6400.000} \
   CONFIG.DAC1_Sampling_Rate {6.4} \
   CONFIG.DAC2_Enable {0} \
   CONFIG.DAC2_Fabric_Freq {0.0} \
   CONFIG.DAC2_Multi_Tile_Sync {false} \
   CONFIG.DAC2_Outclk_Freq {50.000} \
   CONFIG.DAC2_PLL_Enable {false} \
   CONFIG.DAC2_Refclk_Freq {6400.000} \
   CONFIG.DAC2_Sampling_Rate {6.4} \
   CONFIG.DAC3_Enable {0} \
   CONFIG.DAC3_Fabric_Freq {0.0} \
   CONFIG.DAC3_Multi_Tile_Sync {false} \
   CONFIG.DAC3_Outclk_Freq {50.000} \
   CONFIG.DAC3_PLL_Enable {false} \
   CONFIG.DAC3_Refclk_Freq {6400.000} \
   CONFIG.DAC3_Sampling_Rate {6.4} \
   CONFIG.DAC_Data_Width00 {16} \
   CONFIG.DAC_Data_Width01 {16} \
   CONFIG.DAC_Data_Width02 {16} \
   CONFIG.DAC_Data_Width03 {16} \
   CONFIG.DAC_Data_Width10 {16} \
   CONFIG.DAC_Data_Width11 {16} \
   CONFIG.DAC_Data_Width12 {16} \
   CONFIG.DAC_Data_Width13 {16} \
   CONFIG.DAC_Data_Width20 {16} \
   CONFIG.DAC_Data_Width21 {16} \
   CONFIG.DAC_Data_Width22 {16} \
   CONFIG.DAC_Data_Width23 {16} \
   CONFIG.DAC_Data_Width30 {16} \
   CONFIG.DAC_Data_Width31 {16} \
   CONFIG.DAC_Data_Width32 {16} \
   CONFIG.DAC_Data_Width33 {16} \
   CONFIG.DAC_Interpolation_Mode00 {0} \
   CONFIG.DAC_Interpolation_Mode01 {0} \
   CONFIG.DAC_Interpolation_Mode02 {0} \
   CONFIG.DAC_Interpolation_Mode03 {0} \
   CONFIG.DAC_Interpolation_Mode10 {0} \
   CONFIG.DAC_Interpolation_Mode11 {0} \
   CONFIG.DAC_Interpolation_Mode12 {0} \
   CONFIG.DAC_Interpolation_Mode13 {0} \
   CONFIG.DAC_Interpolation_Mode20 {0} \
   CONFIG.DAC_Interpolation_Mode21 {0} \
   CONFIG.DAC_Interpolation_Mode22 {0} \
   CONFIG.DAC_Interpolation_Mode23 {0} \
   CONFIG.DAC_Interpolation_Mode30 {0} \
   CONFIG.DAC_Interpolation_Mode31 {0} \
   CONFIG.DAC_Interpolation_Mode32 {0} \
   CONFIG.DAC_Interpolation_Mode33 {0} \
   CONFIG.DAC_Mixer_Type00 {3} \
   CONFIG.DAC_Mixer_Type01 {3} \
   CONFIG.DAC_Mixer_Type02 {3} \
   CONFIG.DAC_Mixer_Type03 {3} \
   CONFIG.DAC_Mixer_Type10 {3} \
   CONFIG.DAC_Mixer_Type11 {3} \
   CONFIG.DAC_Mixer_Type12 {3} \
   CONFIG.DAC_Mixer_Type13 {3} \
   CONFIG.DAC_Mixer_Type20 {3} \
   CONFIG.DAC_Mixer_Type21 {3} \
   CONFIG.DAC_Mixer_Type22 {3} \
   CONFIG.DAC_Mixer_Type23 {3} \
   CONFIG.DAC_Mixer_Type30 {3} \
   CONFIG.DAC_Mixer_Type31 {3} \
   CONFIG.DAC_Mixer_Type32 {3} \
   CONFIG.DAC_Mixer_Type33 {3} \
   CONFIG.DAC_Slice00_Enable {false} \
   CONFIG.DAC_Slice01_Enable {false} \
   CONFIG.DAC_Slice02_Enable {false} \
   CONFIG.DAC_Slice03_Enable {false} \
   CONFIG.DAC_Slice10_Enable {false} \
   CONFIG.DAC_Slice11_Enable {false} \
   CONFIG.DAC_Slice12_Enable {false} \
   CONFIG.DAC_Slice13_Enable {false} \
   CONFIG.DAC_Slice20_Enable {false} \
   CONFIG.DAC_Slice21_Enable {false} \
   CONFIG.DAC_Slice22_Enable {false} \
   CONFIG.DAC_Slice23_Enable {false} \
   CONFIG.DAC_Slice30_Enable {false} \
   CONFIG.DAC_Slice31_Enable {false} \
   CONFIG.DAC_Slice32_Enable {false} \
   CONFIG.DAC_Slice33_Enable {false} \
 ] $usp_rf_data_converter_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins vin20] [get_bd_intf_pins usp_rf_data_converter_0/vin20]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins vin21] [get_bd_intf_pins usp_rf_data_converter_0/vin21]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins vin30] [get_bd_intf_pins usp_rf_data_converter_0/vin30]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins vin03] [get_bd_intf_pins usp_rf_data_converter_0/vin03]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins vin00] [get_bd_intf_pins usp_rf_data_converter_0/vin00]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins vin31] [get_bd_intf_pins usp_rf_data_converter_0/vin31]
  connect_bd_intf_net -intf_net Conn7 [get_bd_intf_pins vin02] [get_bd_intf_pins usp_rf_data_converter_0/vin02]
  connect_bd_intf_net -intf_net Conn8 [get_bd_intf_pins vin32] [get_bd_intf_pins usp_rf_data_converter_0/vin32]
  connect_bd_intf_net -intf_net Conn9 [get_bd_intf_pins vin12] [get_bd_intf_pins usp_rf_data_converter_0/vin12]
  connect_bd_intf_net -intf_net Conn10 [get_bd_intf_pins vin33] [get_bd_intf_pins usp_rf_data_converter_0/vin33]
  connect_bd_intf_net -intf_net Conn11 [get_bd_intf_pins vin11] [get_bd_intf_pins usp_rf_data_converter_0/vin11]
  connect_bd_intf_net -intf_net Conn12 [get_bd_intf_pins adc0_clk] [get_bd_intf_pins usp_rf_data_converter_0/adc0_clk]
  connect_bd_intf_net -intf_net Conn13 [get_bd_intf_pins vin23] [get_bd_intf_pins usp_rf_data_converter_0/vin23]
  connect_bd_intf_net -intf_net Conn14 [get_bd_intf_pins vin22] [get_bd_intf_pins usp_rf_data_converter_0/vin22]
  connect_bd_intf_net -intf_net Conn15 [get_bd_intf_pins adc1_clk] [get_bd_intf_pins usp_rf_data_converter_0/adc1_clk]
  connect_bd_intf_net -intf_net Conn16 [get_bd_intf_pins vin13] [get_bd_intf_pins usp_rf_data_converter_0/vin13]
  connect_bd_intf_net -intf_net Conn17 [get_bd_intf_pins adc2_clk] [get_bd_intf_pins usp_rf_data_converter_0/adc2_clk]
  connect_bd_intf_net -intf_net Conn18 [get_bd_intf_pins sysref_in] [get_bd_intf_pins usp_rf_data_converter_0/sysref_in]
  connect_bd_intf_net -intf_net Conn19 [get_bd_intf_pins vin10] [get_bd_intf_pins usp_rf_data_converter_0/vin10]
  connect_bd_intf_net -intf_net Conn20 [get_bd_intf_pins vin01] [get_bd_intf_pins usp_rf_data_converter_0/vin01]
  connect_bd_intf_net -intf_net Conn21 [get_bd_intf_pins adc3_clk] [get_bd_intf_pins usp_rf_data_converter_0/adc3_clk]
  connect_bd_intf_net -intf_net Conn22 [get_bd_intf_pins s_axi] [get_bd_intf_pins usp_rf_data_converter_0/s_axi]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_m00_axis [get_bd_intf_pins M_AXIS_RFADC14] [get_bd_intf_pins usp_rf_data_converter_0/m00_axis]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_m01_axis [get_bd_intf_pins M_AXIS_RFADC15] [get_bd_intf_pins usp_rf_data_converter_0/m01_axis]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_m02_axis [get_bd_intf_pins M_AXIS_RFADC12] [get_bd_intf_pins usp_rf_data_converter_0/m02_axis]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_m03_axis [get_bd_intf_pins M_AXIS_RFADC13] [get_bd_intf_pins usp_rf_data_converter_0/m03_axis]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_m10_axis [get_bd_intf_pins M_AXIS_RFADC10] [get_bd_intf_pins usp_rf_data_converter_0/m10_axis]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_m11_axis [get_bd_intf_pins M_AXIS_RFADC11] [get_bd_intf_pins usp_rf_data_converter_0/m11_axis]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_m12_axis [get_bd_intf_pins M_AXIS_RFADC8] [get_bd_intf_pins usp_rf_data_converter_0/m12_axis]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_m13_axis [get_bd_intf_pins M_AXIS_RFADC9] [get_bd_intf_pins usp_rf_data_converter_0/m13_axis]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_m20_axis [get_bd_intf_pins M_AXIS_RFADC6] [get_bd_intf_pins usp_rf_data_converter_0/m20_axis]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_m21_axis [get_bd_intf_pins M_AXIS_RFADC7] [get_bd_intf_pins usp_rf_data_converter_0/m21_axis]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_m22_axis [get_bd_intf_pins M_AXIS_RFADC4] [get_bd_intf_pins usp_rf_data_converter_0/m22_axis]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_m23_axis [get_bd_intf_pins M_AXIS_RFADC5] [get_bd_intf_pins usp_rf_data_converter_0/m23_axis]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_m30_axis [get_bd_intf_pins M_AXIS_RFADC2] [get_bd_intf_pins usp_rf_data_converter_0/m30_axis]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_m31_axis [get_bd_intf_pins M_AXIS_RFADC3] [get_bd_intf_pins usp_rf_data_converter_0/m31_axis]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_m32_axis [get_bd_intf_pins M_AXIS_RFADC] [get_bd_intf_pins usp_rf_data_converter_0/m32_axis]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_m33_axis [get_bd_intf_pins M_AXIS_RFADC1] [get_bd_intf_pins usp_rf_data_converter_0/m33_axis]

  # Create port connections
  connect_bd_net -net m1_axis_aclk_1 [get_bd_pins m1_axis_aclk] [get_bd_pins usp_rf_data_converter_0/m0_axis_aclk] [get_bd_pins usp_rf_data_converter_0/m1_axis_aclk] [get_bd_pins usp_rf_data_converter_0/m2_axis_aclk] [get_bd_pins usp_rf_data_converter_0/m3_axis_aclk] [get_bd_pins usp_rf_data_converter_0/s_axi_aclk]
  connect_bd_net -net m2_axis_aresetn_1 [get_bd_pins m2_axis_aresetn] [get_bd_pins usp_rf_data_converter_0/m0_axis_aresetn] [get_bd_pins usp_rf_data_converter_0/m1_axis_aresetn] [get_bd_pins usp_rf_data_converter_0/m2_axis_aresetn] [get_bd_pins usp_rf_data_converter_0/m3_axis_aresetn] [get_bd_pins usp_rf_data_converter_0/s_axi_aresetn]
  connect_bd_net -net user_sysref_adc_1 [get_bd_pins user_sysref_adc] [get_bd_pins usp_rf_data_converter_0/user_sysref_adc]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports

  # Create instance: rfadc_block
  create_hier_cell_rfadc_block [current_bd_instance .] rfadc_block

  # Create port connections

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


common::send_msg_id "BD_TCL-1000" "WARNING" "This Tcl script was generated from a block design that has not been validated. It is possible that design <$design_name> may result in errors during validation."

