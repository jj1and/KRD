
################################################################
# This is a generated script based on design: ladc_block
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
# source ladc_block_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xczu29dr-ffvf1760-1-e
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name ladc_block

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
teldevice.local:user:ADC_IF_TEST:1.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:vio:3.0\
xilinx.com:ip:xlconstant:1.1\
teldevice.local:user:ADC_IF_TEST_1:1.0\
teldevice.local:user:ADC_IF_TEST_2:1.0\
teldevice.local:user:ADC_IF_TEST_3:1.0\
xilinx.com:ip:axis_clock_converter:1.1\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:util_vector_logic:2.0\
xilinx.com:ip:fifo_generator:13.2\
xilinx.com:ip:util_reduced_logic:2.0\
xilinx.com:ip:xlslice:1.0\
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


# Hierarchical cell: hier_3
proc create_hier_cell_hier_3_3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_hier_3_3() - Empty argument(s)!"}
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

  # Create pins
  create_bd_pin -dir I -from 31 -to 0 Din
  create_bd_pin -dir O -from 31 -to 0 dout_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {32} \
 ] $xlconcat_0

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_1

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_2

  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_3

  # Create instance: xlslice_4, and set properties
  set xlslice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_4 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {4} \
   CONFIG.DIN_TO {4} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_4

  # Create instance: xlslice_5, and set properties
  set xlslice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_5 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {5} \
   CONFIG.DIN_TO {5} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_5

  # Create instance: xlslice_6, and set properties
  set xlslice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_6 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {6} \
   CONFIG.DIN_TO {6} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_6

  # Create instance: xlslice_7, and set properties
  set xlslice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_7 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {7} \
   CONFIG.DIN_TO {7} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_7

  # Create instance: xlslice_8, and set properties
  set xlslice_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_8 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {8} \
   CONFIG.DIN_TO {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_8

  # Create instance: xlslice_9, and set properties
  set xlslice_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_9 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {9} \
   CONFIG.DIN_TO {9} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_9

  # Create instance: xlslice_10, and set properties
  set xlslice_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_10 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {10} \
   CONFIG.DIN_TO {10} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_10

  # Create instance: xlslice_11, and set properties
  set xlslice_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_11 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {11} \
   CONFIG.DIN_TO {11} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_11

  # Create instance: xlslice_12, and set properties
  set xlslice_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_12 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {12} \
   CONFIG.DIN_TO {12} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_12

  # Create instance: xlslice_13, and set properties
  set xlslice_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_13 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {13} \
   CONFIG.DIN_TO {13} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_13

  # Create instance: xlslice_14, and set properties
  set xlslice_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_14 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {14} \
   CONFIG.DIN_TO {14} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_14

  # Create instance: xlslice_15, and set properties
  set xlslice_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_15 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {15} \
   CONFIG.DIN_TO {15} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_15

  # Create instance: xlslice_16, and set properties
  set xlslice_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_16 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {16} \
   CONFIG.DIN_TO {16} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_16

  # Create instance: xlslice_17, and set properties
  set xlslice_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_17 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {17} \
   CONFIG.DIN_TO {17} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_17

  # Create instance: xlslice_18, and set properties
  set xlslice_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_18 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {18} \
   CONFIG.DIN_TO {18} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_18

  # Create instance: xlslice_19, and set properties
  set xlslice_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_19 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {19} \
   CONFIG.DIN_TO {19} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_19

  # Create instance: xlslice_20, and set properties
  set xlslice_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_20 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {20} \
   CONFIG.DIN_TO {20} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_20

  # Create instance: xlslice_21, and set properties
  set xlslice_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_21 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {21} \
   CONFIG.DIN_TO {21} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_21

  # Create instance: xlslice_22, and set properties
  set xlslice_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_22 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {22} \
   CONFIG.DIN_TO {22} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_22

  # Create instance: xlslice_23, and set properties
  set xlslice_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_23 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {23} \
   CONFIG.DIN_TO {23} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_23

  # Create instance: xlslice_24, and set properties
  set xlslice_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_24 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {24} \
   CONFIG.DIN_TO {24} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_24

  # Create instance: xlslice_25, and set properties
  set xlslice_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_25 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {25} \
   CONFIG.DIN_TO {25} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_25

  # Create instance: xlslice_26, and set properties
  set xlslice_26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_26 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {26} \
   CONFIG.DIN_TO {26} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_26

  # Create instance: xlslice_27, and set properties
  set xlslice_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_27 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {27} \
   CONFIG.DIN_TO {27} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_27

  # Create instance: xlslice_28, and set properties
  set xlslice_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_28 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {28} \
   CONFIG.DIN_TO {28} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_28

  # Create instance: xlslice_29, and set properties
  set xlslice_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_29 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {29} \
   CONFIG.DIN_TO {29} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_29

  # Create instance: xlslice_30, and set properties
  set xlslice_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_30 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {30} \
   CONFIG.DIN_TO {30} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_30

  # Create instance: xlslice_31, and set properties
  set xlslice_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_31 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {31} \
   CONFIG.DIN_TO {31} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_31

  # Create port connections
  connect_bd_net -net xlconcat_0_dout [get_bd_pins Din] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din] [get_bd_pins xlslice_10/Din] [get_bd_pins xlslice_11/Din] [get_bd_pins xlslice_12/Din] [get_bd_pins xlslice_13/Din] [get_bd_pins xlslice_14/Din] [get_bd_pins xlslice_15/Din] [get_bd_pins xlslice_16/Din] [get_bd_pins xlslice_17/Din] [get_bd_pins xlslice_18/Din] [get_bd_pins xlslice_19/Din] [get_bd_pins xlslice_2/Din] [get_bd_pins xlslice_20/Din] [get_bd_pins xlslice_21/Din] [get_bd_pins xlslice_22/Din] [get_bd_pins xlslice_23/Din] [get_bd_pins xlslice_24/Din] [get_bd_pins xlslice_25/Din] [get_bd_pins xlslice_26/Din] [get_bd_pins xlslice_27/Din] [get_bd_pins xlslice_28/Din] [get_bd_pins xlslice_29/Din] [get_bd_pins xlslice_3/Din] [get_bd_pins xlslice_30/Din] [get_bd_pins xlslice_31/Din] [get_bd_pins xlslice_4/Din] [get_bd_pins xlslice_5/Din] [get_bd_pins xlslice_6/Din] [get_bd_pins xlslice_7/Din] [get_bd_pins xlslice_8/Din] [get_bd_pins xlslice_9/Din]
  connect_bd_net -net xlconcat_0_dout1 [get_bd_pins dout_0] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins xlconcat_0/In12] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_10_Dout [get_bd_pins xlconcat_0/In5] [get_bd_pins xlslice_10/Dout]
  connect_bd_net -net xlslice_11_Dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlslice_11/Dout]
  connect_bd_net -net xlslice_12_Dout [get_bd_pins xlconcat_0/In29] [get_bd_pins xlslice_12/Dout]
  connect_bd_net -net xlslice_13_Dout [get_bd_pins xlconcat_0/In25] [get_bd_pins xlslice_13/Dout]
  connect_bd_net -net xlslice_14_Dout [get_bd_pins xlconcat_0/In21] [get_bd_pins xlslice_14/Dout]
  connect_bd_net -net xlslice_15_Dout [get_bd_pins xlconcat_0/In17] [get_bd_pins xlslice_15/Dout]
  connect_bd_net -net xlslice_16_Dout [get_bd_pins xlconcat_0/In14] [get_bd_pins xlslice_16/Dout]
  connect_bd_net -net xlslice_17_Dout [get_bd_pins xlconcat_0/In10] [get_bd_pins xlslice_17/Dout]
  connect_bd_net -net xlslice_18_Dout [get_bd_pins xlconcat_0/In6] [get_bd_pins xlslice_18/Dout]
  connect_bd_net -net xlslice_19_Dout [get_bd_pins xlconcat_0/In2] [get_bd_pins xlslice_19/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins xlconcat_0/In8] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net xlslice_20_Dout [get_bd_pins xlconcat_0/In30] [get_bd_pins xlslice_20/Dout]
  connect_bd_net -net xlslice_21_Dout [get_bd_pins xlconcat_0/In26] [get_bd_pins xlslice_21/Dout]
  connect_bd_net -net xlslice_22_Dout [get_bd_pins xlconcat_0/In22] [get_bd_pins xlslice_22/Dout]
  connect_bd_net -net xlslice_23_Dout [get_bd_pins xlconcat_0/In18] [get_bd_pins xlslice_23/Dout]
  connect_bd_net -net xlslice_24_Dout [get_bd_pins xlconcat_0/In15] [get_bd_pins xlslice_24/Dout]
  connect_bd_net -net xlslice_25_Dout [get_bd_pins xlconcat_0/In11] [get_bd_pins xlslice_25/Dout]
  connect_bd_net -net xlslice_26_Dout [get_bd_pins xlconcat_0/In7] [get_bd_pins xlslice_26/Dout]
  connect_bd_net -net xlslice_27_Dout [get_bd_pins xlconcat_0/In3] [get_bd_pins xlslice_27/Dout]
  connect_bd_net -net xlslice_28_Dout [get_bd_pins xlconcat_0/In31] [get_bd_pins xlslice_28/Dout]
  connect_bd_net -net xlslice_29_Dout [get_bd_pins xlconcat_0/In27] [get_bd_pins xlslice_29/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins xlconcat_0/In4] [get_bd_pins xlslice_2/Dout]
  connect_bd_net -net xlslice_30_Dout [get_bd_pins xlconcat_0/In23] [get_bd_pins xlslice_30/Dout]
  connect_bd_net -net xlslice_31_Dout [get_bd_pins xlconcat_0/In19] [get_bd_pins xlslice_31/Dout]
  connect_bd_net -net xlslice_3_Dout [get_bd_pins xlconcat_0/In0] [get_bd_pins xlslice_3/Dout]
  connect_bd_net -net xlslice_4_Dout [get_bd_pins xlconcat_0/In28] [get_bd_pins xlslice_4/Dout]
  connect_bd_net -net xlslice_5_Dout [get_bd_pins xlconcat_0/In24] [get_bd_pins xlslice_5/Dout]
  connect_bd_net -net xlslice_6_Dout [get_bd_pins xlconcat_0/In20] [get_bd_pins xlslice_6/Dout]
  connect_bd_net -net xlslice_7_Dout [get_bd_pins xlconcat_0/In16] [get_bd_pins xlslice_7/Dout]
  connect_bd_net -net xlslice_8_Dout [get_bd_pins xlconcat_0/In13] [get_bd_pins xlslice_8/Dout]
  connect_bd_net -net xlslice_9_Dout [get_bd_pins xlconcat_0/In9] [get_bd_pins xlslice_9/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_1
proc create_hier_cell_hier_1_3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_hier_1_3() - Empty argument(s)!"}
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

  # Create pins
  create_bd_pin -dir I -from 31 -to 0 Din
  create_bd_pin -dir O -from 31 -to 0 dout_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {32} \
 ] $xlconcat_0

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_1

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_2

  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_3

  # Create instance: xlslice_4, and set properties
  set xlslice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_4 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {4} \
   CONFIG.DIN_TO {4} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_4

  # Create instance: xlslice_5, and set properties
  set xlslice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_5 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {5} \
   CONFIG.DIN_TO {5} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_5

  # Create instance: xlslice_6, and set properties
  set xlslice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_6 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {6} \
   CONFIG.DIN_TO {6} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_6

  # Create instance: xlslice_7, and set properties
  set xlslice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_7 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {7} \
   CONFIG.DIN_TO {7} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_7

  # Create instance: xlslice_8, and set properties
  set xlslice_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_8 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {8} \
   CONFIG.DIN_TO {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_8

  # Create instance: xlslice_9, and set properties
  set xlslice_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_9 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {9} \
   CONFIG.DIN_TO {9} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_9

  # Create instance: xlslice_10, and set properties
  set xlslice_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_10 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {10} \
   CONFIG.DIN_TO {10} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_10

  # Create instance: xlslice_11, and set properties
  set xlslice_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_11 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {11} \
   CONFIG.DIN_TO {11} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_11

  # Create instance: xlslice_12, and set properties
  set xlslice_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_12 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {12} \
   CONFIG.DIN_TO {12} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_12

  # Create instance: xlslice_13, and set properties
  set xlslice_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_13 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {13} \
   CONFIG.DIN_TO {13} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_13

  # Create instance: xlslice_14, and set properties
  set xlslice_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_14 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {14} \
   CONFIG.DIN_TO {14} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_14

  # Create instance: xlslice_15, and set properties
  set xlslice_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_15 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {15} \
   CONFIG.DIN_TO {15} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_15

  # Create instance: xlslice_16, and set properties
  set xlslice_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_16 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {16} \
   CONFIG.DIN_TO {16} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_16

  # Create instance: xlslice_17, and set properties
  set xlslice_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_17 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {17} \
   CONFIG.DIN_TO {17} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_17

  # Create instance: xlslice_18, and set properties
  set xlslice_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_18 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {18} \
   CONFIG.DIN_TO {18} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_18

  # Create instance: xlslice_19, and set properties
  set xlslice_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_19 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {19} \
   CONFIG.DIN_TO {19} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_19

  # Create instance: xlslice_20, and set properties
  set xlslice_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_20 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {20} \
   CONFIG.DIN_TO {20} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_20

  # Create instance: xlslice_21, and set properties
  set xlslice_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_21 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {21} \
   CONFIG.DIN_TO {21} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_21

  # Create instance: xlslice_22, and set properties
  set xlslice_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_22 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {22} \
   CONFIG.DIN_TO {22} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_22

  # Create instance: xlslice_23, and set properties
  set xlslice_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_23 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {23} \
   CONFIG.DIN_TO {23} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_23

  # Create instance: xlslice_24, and set properties
  set xlslice_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_24 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {24} \
   CONFIG.DIN_TO {24} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_24

  # Create instance: xlslice_25, and set properties
  set xlslice_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_25 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {25} \
   CONFIG.DIN_TO {25} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_25

  # Create instance: xlslice_26, and set properties
  set xlslice_26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_26 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {26} \
   CONFIG.DIN_TO {26} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_26

  # Create instance: xlslice_27, and set properties
  set xlslice_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_27 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {27} \
   CONFIG.DIN_TO {27} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_27

  # Create instance: xlslice_28, and set properties
  set xlslice_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_28 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {28} \
   CONFIG.DIN_TO {28} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_28

  # Create instance: xlslice_29, and set properties
  set xlslice_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_29 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {29} \
   CONFIG.DIN_TO {29} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_29

  # Create instance: xlslice_30, and set properties
  set xlslice_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_30 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {30} \
   CONFIG.DIN_TO {30} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_30

  # Create instance: xlslice_31, and set properties
  set xlslice_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_31 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {31} \
   CONFIG.DIN_TO {31} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_31

  # Create port connections
  connect_bd_net -net xlconcat_0_dout [get_bd_pins Din] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din] [get_bd_pins xlslice_10/Din] [get_bd_pins xlslice_11/Din] [get_bd_pins xlslice_12/Din] [get_bd_pins xlslice_13/Din] [get_bd_pins xlslice_14/Din] [get_bd_pins xlslice_15/Din] [get_bd_pins xlslice_16/Din] [get_bd_pins xlslice_17/Din] [get_bd_pins xlslice_18/Din] [get_bd_pins xlslice_19/Din] [get_bd_pins xlslice_2/Din] [get_bd_pins xlslice_20/Din] [get_bd_pins xlslice_21/Din] [get_bd_pins xlslice_22/Din] [get_bd_pins xlslice_23/Din] [get_bd_pins xlslice_24/Din] [get_bd_pins xlslice_25/Din] [get_bd_pins xlslice_26/Din] [get_bd_pins xlslice_27/Din] [get_bd_pins xlslice_28/Din] [get_bd_pins xlslice_29/Din] [get_bd_pins xlslice_3/Din] [get_bd_pins xlslice_30/Din] [get_bd_pins xlslice_31/Din] [get_bd_pins xlslice_4/Din] [get_bd_pins xlslice_5/Din] [get_bd_pins xlslice_6/Din] [get_bd_pins xlslice_7/Din] [get_bd_pins xlslice_8/Din] [get_bd_pins xlslice_9/Din]
  connect_bd_net -net xlconcat_0_dout1 [get_bd_pins dout_0] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins xlconcat_0/In12] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_10_Dout [get_bd_pins xlconcat_0/In5] [get_bd_pins xlslice_10/Dout]
  connect_bd_net -net xlslice_11_Dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlslice_11/Dout]
  connect_bd_net -net xlslice_12_Dout [get_bd_pins xlconcat_0/In29] [get_bd_pins xlslice_12/Dout]
  connect_bd_net -net xlslice_13_Dout [get_bd_pins xlconcat_0/In25] [get_bd_pins xlslice_13/Dout]
  connect_bd_net -net xlslice_14_Dout [get_bd_pins xlconcat_0/In21] [get_bd_pins xlslice_14/Dout]
  connect_bd_net -net xlslice_15_Dout [get_bd_pins xlconcat_0/In17] [get_bd_pins xlslice_15/Dout]
  connect_bd_net -net xlslice_16_Dout [get_bd_pins xlconcat_0/In14] [get_bd_pins xlslice_16/Dout]
  connect_bd_net -net xlslice_17_Dout [get_bd_pins xlconcat_0/In10] [get_bd_pins xlslice_17/Dout]
  connect_bd_net -net xlslice_18_Dout [get_bd_pins xlconcat_0/In6] [get_bd_pins xlslice_18/Dout]
  connect_bd_net -net xlslice_19_Dout [get_bd_pins xlconcat_0/In2] [get_bd_pins xlslice_19/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins xlconcat_0/In8] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net xlslice_20_Dout [get_bd_pins xlconcat_0/In30] [get_bd_pins xlslice_20/Dout]
  connect_bd_net -net xlslice_21_Dout [get_bd_pins xlconcat_0/In26] [get_bd_pins xlslice_21/Dout]
  connect_bd_net -net xlslice_22_Dout [get_bd_pins xlconcat_0/In22] [get_bd_pins xlslice_22/Dout]
  connect_bd_net -net xlslice_23_Dout [get_bd_pins xlconcat_0/In18] [get_bd_pins xlslice_23/Dout]
  connect_bd_net -net xlslice_24_Dout [get_bd_pins xlconcat_0/In15] [get_bd_pins xlslice_24/Dout]
  connect_bd_net -net xlslice_25_Dout [get_bd_pins xlconcat_0/In11] [get_bd_pins xlslice_25/Dout]
  connect_bd_net -net xlslice_26_Dout [get_bd_pins xlconcat_0/In7] [get_bd_pins xlslice_26/Dout]
  connect_bd_net -net xlslice_27_Dout [get_bd_pins xlconcat_0/In3] [get_bd_pins xlslice_27/Dout]
  connect_bd_net -net xlslice_28_Dout [get_bd_pins xlconcat_0/In31] [get_bd_pins xlslice_28/Dout]
  connect_bd_net -net xlslice_29_Dout [get_bd_pins xlconcat_0/In27] [get_bd_pins xlslice_29/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins xlconcat_0/In4] [get_bd_pins xlslice_2/Dout]
  connect_bd_net -net xlslice_30_Dout [get_bd_pins xlconcat_0/In23] [get_bd_pins xlslice_30/Dout]
  connect_bd_net -net xlslice_31_Dout [get_bd_pins xlconcat_0/In19] [get_bd_pins xlslice_31/Dout]
  connect_bd_net -net xlslice_3_Dout [get_bd_pins xlconcat_0/In0] [get_bd_pins xlslice_3/Dout]
  connect_bd_net -net xlslice_4_Dout [get_bd_pins xlconcat_0/In28] [get_bd_pins xlslice_4/Dout]
  connect_bd_net -net xlslice_5_Dout [get_bd_pins xlconcat_0/In24] [get_bd_pins xlslice_5/Dout]
  connect_bd_net -net xlslice_6_Dout [get_bd_pins xlconcat_0/In20] [get_bd_pins xlslice_6/Dout]
  connect_bd_net -net xlslice_7_Dout [get_bd_pins xlconcat_0/In16] [get_bd_pins xlslice_7/Dout]
  connect_bd_net -net xlslice_8_Dout [get_bd_pins xlconcat_0/In13] [get_bd_pins xlslice_8/Dout]
  connect_bd_net -net xlslice_9_Dout [get_bd_pins xlconcat_0/In9] [get_bd_pins xlslice_9/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_2
proc create_hier_cell_hier_2_3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_hier_2_3() - Empty argument(s)!"}
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

  # Create pins
  create_bd_pin -dir I -from 31 -to 0 Din
  create_bd_pin -dir O -from 31 -to 0 dout_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {32} \
 ] $xlconcat_0

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_1

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_2

  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_3

  # Create instance: xlslice_4, and set properties
  set xlslice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_4 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {4} \
   CONFIG.DIN_TO {4} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_4

  # Create instance: xlslice_5, and set properties
  set xlslice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_5 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {5} \
   CONFIG.DIN_TO {5} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_5

  # Create instance: xlslice_6, and set properties
  set xlslice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_6 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {6} \
   CONFIG.DIN_TO {6} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_6

  # Create instance: xlslice_7, and set properties
  set xlslice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_7 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {7} \
   CONFIG.DIN_TO {7} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_7

  # Create instance: xlslice_8, and set properties
  set xlslice_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_8 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {8} \
   CONFIG.DIN_TO {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_8

  # Create instance: xlslice_9, and set properties
  set xlslice_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_9 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {9} \
   CONFIG.DIN_TO {9} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_9

  # Create instance: xlslice_10, and set properties
  set xlslice_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_10 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {10} \
   CONFIG.DIN_TO {10} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_10

  # Create instance: xlslice_11, and set properties
  set xlslice_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_11 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {11} \
   CONFIG.DIN_TO {11} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_11

  # Create instance: xlslice_12, and set properties
  set xlslice_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_12 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {12} \
   CONFIG.DIN_TO {12} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_12

  # Create instance: xlslice_13, and set properties
  set xlslice_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_13 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {13} \
   CONFIG.DIN_TO {13} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_13

  # Create instance: xlslice_14, and set properties
  set xlslice_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_14 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {14} \
   CONFIG.DIN_TO {14} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_14

  # Create instance: xlslice_15, and set properties
  set xlslice_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_15 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {15} \
   CONFIG.DIN_TO {15} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_15

  # Create instance: xlslice_16, and set properties
  set xlslice_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_16 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {16} \
   CONFIG.DIN_TO {16} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_16

  # Create instance: xlslice_17, and set properties
  set xlslice_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_17 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {17} \
   CONFIG.DIN_TO {17} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_17

  # Create instance: xlslice_18, and set properties
  set xlslice_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_18 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {18} \
   CONFIG.DIN_TO {18} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_18

  # Create instance: xlslice_19, and set properties
  set xlslice_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_19 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {19} \
   CONFIG.DIN_TO {19} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_19

  # Create instance: xlslice_20, and set properties
  set xlslice_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_20 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {20} \
   CONFIG.DIN_TO {20} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_20

  # Create instance: xlslice_21, and set properties
  set xlslice_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_21 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {21} \
   CONFIG.DIN_TO {21} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_21

  # Create instance: xlslice_22, and set properties
  set xlslice_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_22 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {22} \
   CONFIG.DIN_TO {22} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_22

  # Create instance: xlslice_23, and set properties
  set xlslice_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_23 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {23} \
   CONFIG.DIN_TO {23} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_23

  # Create instance: xlslice_24, and set properties
  set xlslice_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_24 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {24} \
   CONFIG.DIN_TO {24} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_24

  # Create instance: xlslice_25, and set properties
  set xlslice_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_25 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {25} \
   CONFIG.DIN_TO {25} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_25

  # Create instance: xlslice_26, and set properties
  set xlslice_26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_26 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {26} \
   CONFIG.DIN_TO {26} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_26

  # Create instance: xlslice_27, and set properties
  set xlslice_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_27 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {27} \
   CONFIG.DIN_TO {27} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_27

  # Create instance: xlslice_28, and set properties
  set xlslice_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_28 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {28} \
   CONFIG.DIN_TO {28} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_28

  # Create instance: xlslice_29, and set properties
  set xlslice_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_29 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {29} \
   CONFIG.DIN_TO {29} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_29

  # Create instance: xlslice_30, and set properties
  set xlslice_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_30 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {30} \
   CONFIG.DIN_TO {30} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_30

  # Create instance: xlslice_31, and set properties
  set xlslice_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_31 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {31} \
   CONFIG.DIN_TO {31} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_31

  # Create port connections
  connect_bd_net -net xlconcat_0_dout [get_bd_pins Din] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din] [get_bd_pins xlslice_10/Din] [get_bd_pins xlslice_11/Din] [get_bd_pins xlslice_12/Din] [get_bd_pins xlslice_13/Din] [get_bd_pins xlslice_14/Din] [get_bd_pins xlslice_15/Din] [get_bd_pins xlslice_16/Din] [get_bd_pins xlslice_17/Din] [get_bd_pins xlslice_18/Din] [get_bd_pins xlslice_19/Din] [get_bd_pins xlslice_2/Din] [get_bd_pins xlslice_20/Din] [get_bd_pins xlslice_21/Din] [get_bd_pins xlslice_22/Din] [get_bd_pins xlslice_23/Din] [get_bd_pins xlslice_24/Din] [get_bd_pins xlslice_25/Din] [get_bd_pins xlslice_26/Din] [get_bd_pins xlslice_27/Din] [get_bd_pins xlslice_28/Din] [get_bd_pins xlslice_29/Din] [get_bd_pins xlslice_3/Din] [get_bd_pins xlslice_30/Din] [get_bd_pins xlslice_31/Din] [get_bd_pins xlslice_4/Din] [get_bd_pins xlslice_5/Din] [get_bd_pins xlslice_6/Din] [get_bd_pins xlslice_7/Din] [get_bd_pins xlslice_8/Din] [get_bd_pins xlslice_9/Din]
  connect_bd_net -net xlconcat_0_dout1 [get_bd_pins dout_0] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins xlconcat_0/In12] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_10_Dout [get_bd_pins xlconcat_0/In5] [get_bd_pins xlslice_10/Dout]
  connect_bd_net -net xlslice_11_Dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlslice_11/Dout]
  connect_bd_net -net xlslice_12_Dout [get_bd_pins xlconcat_0/In29] [get_bd_pins xlslice_12/Dout]
  connect_bd_net -net xlslice_13_Dout [get_bd_pins xlconcat_0/In25] [get_bd_pins xlslice_13/Dout]
  connect_bd_net -net xlslice_14_Dout [get_bd_pins xlconcat_0/In21] [get_bd_pins xlslice_14/Dout]
  connect_bd_net -net xlslice_15_Dout [get_bd_pins xlconcat_0/In17] [get_bd_pins xlslice_15/Dout]
  connect_bd_net -net xlslice_16_Dout [get_bd_pins xlconcat_0/In14] [get_bd_pins xlslice_16/Dout]
  connect_bd_net -net xlslice_17_Dout [get_bd_pins xlconcat_0/In10] [get_bd_pins xlslice_17/Dout]
  connect_bd_net -net xlslice_18_Dout [get_bd_pins xlconcat_0/In6] [get_bd_pins xlslice_18/Dout]
  connect_bd_net -net xlslice_19_Dout [get_bd_pins xlconcat_0/In2] [get_bd_pins xlslice_19/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins xlconcat_0/In8] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net xlslice_20_Dout [get_bd_pins xlconcat_0/In30] [get_bd_pins xlslice_20/Dout]
  connect_bd_net -net xlslice_21_Dout [get_bd_pins xlconcat_0/In26] [get_bd_pins xlslice_21/Dout]
  connect_bd_net -net xlslice_22_Dout [get_bd_pins xlconcat_0/In22] [get_bd_pins xlslice_22/Dout]
  connect_bd_net -net xlslice_23_Dout [get_bd_pins xlconcat_0/In18] [get_bd_pins xlslice_23/Dout]
  connect_bd_net -net xlslice_24_Dout [get_bd_pins xlconcat_0/In15] [get_bd_pins xlslice_24/Dout]
  connect_bd_net -net xlslice_25_Dout [get_bd_pins xlconcat_0/In11] [get_bd_pins xlslice_25/Dout]
  connect_bd_net -net xlslice_26_Dout [get_bd_pins xlconcat_0/In7] [get_bd_pins xlslice_26/Dout]
  connect_bd_net -net xlslice_27_Dout [get_bd_pins xlconcat_0/In3] [get_bd_pins xlslice_27/Dout]
  connect_bd_net -net xlslice_28_Dout [get_bd_pins xlconcat_0/In31] [get_bd_pins xlslice_28/Dout]
  connect_bd_net -net xlslice_29_Dout [get_bd_pins xlconcat_0/In27] [get_bd_pins xlslice_29/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins xlconcat_0/In4] [get_bd_pins xlslice_2/Dout]
  connect_bd_net -net xlslice_30_Dout [get_bd_pins xlconcat_0/In23] [get_bd_pins xlslice_30/Dout]
  connect_bd_net -net xlslice_31_Dout [get_bd_pins xlconcat_0/In19] [get_bd_pins xlslice_31/Dout]
  connect_bd_net -net xlslice_3_Dout [get_bd_pins xlconcat_0/In0] [get_bd_pins xlslice_3/Dout]
  connect_bd_net -net xlslice_4_Dout [get_bd_pins xlconcat_0/In28] [get_bd_pins xlslice_4/Dout]
  connect_bd_net -net xlslice_5_Dout [get_bd_pins xlconcat_0/In24] [get_bd_pins xlslice_5/Dout]
  connect_bd_net -net xlslice_6_Dout [get_bd_pins xlconcat_0/In20] [get_bd_pins xlslice_6/Dout]
  connect_bd_net -net xlslice_7_Dout [get_bd_pins xlconcat_0/In16] [get_bd_pins xlslice_7/Dout]
  connect_bd_net -net xlslice_8_Dout [get_bd_pins xlconcat_0/In13] [get_bd_pins xlslice_8/Dout]
  connect_bd_net -net xlslice_9_Dout [get_bd_pins xlconcat_0/In9] [get_bd_pins xlslice_9/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_0
proc create_hier_cell_hier_0_3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_hier_0_3() - Empty argument(s)!"}
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

  # Create pins
  create_bd_pin -dir I -from 31 -to 0 Din
  create_bd_pin -dir O -from 31 -to 0 dout_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {32} \
 ] $xlconcat_0

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_1

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_2

  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_3

  # Create instance: xlslice_4, and set properties
  set xlslice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_4 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {4} \
   CONFIG.DIN_TO {4} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_4

  # Create instance: xlslice_5, and set properties
  set xlslice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_5 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {5} \
   CONFIG.DIN_TO {5} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_5

  # Create instance: xlslice_6, and set properties
  set xlslice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_6 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {6} \
   CONFIG.DIN_TO {6} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_6

  # Create instance: xlslice_7, and set properties
  set xlslice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_7 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {7} \
   CONFIG.DIN_TO {7} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_7

  # Create instance: xlslice_8, and set properties
  set xlslice_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_8 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {8} \
   CONFIG.DIN_TO {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_8

  # Create instance: xlslice_9, and set properties
  set xlslice_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_9 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {9} \
   CONFIG.DIN_TO {9} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_9

  # Create instance: xlslice_10, and set properties
  set xlslice_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_10 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {10} \
   CONFIG.DIN_TO {10} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_10

  # Create instance: xlslice_11, and set properties
  set xlslice_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_11 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {11} \
   CONFIG.DIN_TO {11} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_11

  # Create instance: xlslice_12, and set properties
  set xlslice_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_12 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {12} \
   CONFIG.DIN_TO {12} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_12

  # Create instance: xlslice_13, and set properties
  set xlslice_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_13 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {13} \
   CONFIG.DIN_TO {13} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_13

  # Create instance: xlslice_14, and set properties
  set xlslice_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_14 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {14} \
   CONFIG.DIN_TO {14} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_14

  # Create instance: xlslice_15, and set properties
  set xlslice_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_15 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {15} \
   CONFIG.DIN_TO {15} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_15

  # Create instance: xlslice_16, and set properties
  set xlslice_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_16 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {16} \
   CONFIG.DIN_TO {16} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_16

  # Create instance: xlslice_17, and set properties
  set xlslice_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_17 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {17} \
   CONFIG.DIN_TO {17} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_17

  # Create instance: xlslice_18, and set properties
  set xlslice_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_18 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {18} \
   CONFIG.DIN_TO {18} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_18

  # Create instance: xlslice_19, and set properties
  set xlslice_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_19 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {19} \
   CONFIG.DIN_TO {19} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_19

  # Create instance: xlslice_20, and set properties
  set xlslice_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_20 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {20} \
   CONFIG.DIN_TO {20} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_20

  # Create instance: xlslice_21, and set properties
  set xlslice_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_21 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {21} \
   CONFIG.DIN_TO {21} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_21

  # Create instance: xlslice_22, and set properties
  set xlslice_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_22 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {22} \
   CONFIG.DIN_TO {22} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_22

  # Create instance: xlslice_23, and set properties
  set xlslice_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_23 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {23} \
   CONFIG.DIN_TO {23} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_23

  # Create instance: xlslice_24, and set properties
  set xlslice_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_24 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {24} \
   CONFIG.DIN_TO {24} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_24

  # Create instance: xlslice_25, and set properties
  set xlslice_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_25 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {25} \
   CONFIG.DIN_TO {25} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_25

  # Create instance: xlslice_26, and set properties
  set xlslice_26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_26 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {26} \
   CONFIG.DIN_TO {26} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_26

  # Create instance: xlslice_27, and set properties
  set xlslice_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_27 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {27} \
   CONFIG.DIN_TO {27} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_27

  # Create instance: xlslice_28, and set properties
  set xlslice_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_28 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {28} \
   CONFIG.DIN_TO {28} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_28

  # Create instance: xlslice_29, and set properties
  set xlslice_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_29 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {29} \
   CONFIG.DIN_TO {29} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_29

  # Create instance: xlslice_30, and set properties
  set xlslice_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_30 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {30} \
   CONFIG.DIN_TO {30} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_30

  # Create instance: xlslice_31, and set properties
  set xlslice_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_31 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {31} \
   CONFIG.DIN_TO {31} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_31

  # Create port connections
  connect_bd_net -net xlconcat_0_dout [get_bd_pins Din] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din] [get_bd_pins xlslice_10/Din] [get_bd_pins xlslice_11/Din] [get_bd_pins xlslice_12/Din] [get_bd_pins xlslice_13/Din] [get_bd_pins xlslice_14/Din] [get_bd_pins xlslice_15/Din] [get_bd_pins xlslice_16/Din] [get_bd_pins xlslice_17/Din] [get_bd_pins xlslice_18/Din] [get_bd_pins xlslice_19/Din] [get_bd_pins xlslice_2/Din] [get_bd_pins xlslice_20/Din] [get_bd_pins xlslice_21/Din] [get_bd_pins xlslice_22/Din] [get_bd_pins xlslice_23/Din] [get_bd_pins xlslice_24/Din] [get_bd_pins xlslice_25/Din] [get_bd_pins xlslice_26/Din] [get_bd_pins xlslice_27/Din] [get_bd_pins xlslice_28/Din] [get_bd_pins xlslice_29/Din] [get_bd_pins xlslice_3/Din] [get_bd_pins xlslice_30/Din] [get_bd_pins xlslice_31/Din] [get_bd_pins xlslice_4/Din] [get_bd_pins xlslice_5/Din] [get_bd_pins xlslice_6/Din] [get_bd_pins xlslice_7/Din] [get_bd_pins xlslice_8/Din] [get_bd_pins xlslice_9/Din]
  connect_bd_net -net xlconcat_0_dout1 [get_bd_pins dout_0] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins xlconcat_0/In12] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_10_Dout [get_bd_pins xlconcat_0/In5] [get_bd_pins xlslice_10/Dout]
  connect_bd_net -net xlslice_11_Dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlslice_11/Dout]
  connect_bd_net -net xlslice_12_Dout [get_bd_pins xlconcat_0/In29] [get_bd_pins xlslice_12/Dout]
  connect_bd_net -net xlslice_13_Dout [get_bd_pins xlconcat_0/In25] [get_bd_pins xlslice_13/Dout]
  connect_bd_net -net xlslice_14_Dout [get_bd_pins xlconcat_0/In21] [get_bd_pins xlslice_14/Dout]
  connect_bd_net -net xlslice_15_Dout [get_bd_pins xlconcat_0/In17] [get_bd_pins xlslice_15/Dout]
  connect_bd_net -net xlslice_16_Dout [get_bd_pins xlconcat_0/In14] [get_bd_pins xlslice_16/Dout]
  connect_bd_net -net xlslice_17_Dout [get_bd_pins xlconcat_0/In10] [get_bd_pins xlslice_17/Dout]
  connect_bd_net -net xlslice_18_Dout [get_bd_pins xlconcat_0/In6] [get_bd_pins xlslice_18/Dout]
  connect_bd_net -net xlslice_19_Dout [get_bd_pins xlconcat_0/In2] [get_bd_pins xlslice_19/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins xlconcat_0/In8] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net xlslice_20_Dout [get_bd_pins xlconcat_0/In30] [get_bd_pins xlslice_20/Dout]
  connect_bd_net -net xlslice_21_Dout [get_bd_pins xlconcat_0/In26] [get_bd_pins xlslice_21/Dout]
  connect_bd_net -net xlslice_22_Dout [get_bd_pins xlconcat_0/In22] [get_bd_pins xlslice_22/Dout]
  connect_bd_net -net xlslice_23_Dout [get_bd_pins xlconcat_0/In18] [get_bd_pins xlslice_23/Dout]
  connect_bd_net -net xlslice_24_Dout [get_bd_pins xlconcat_0/In15] [get_bd_pins xlslice_24/Dout]
  connect_bd_net -net xlslice_25_Dout [get_bd_pins xlconcat_0/In11] [get_bd_pins xlslice_25/Dout]
  connect_bd_net -net xlslice_26_Dout [get_bd_pins xlconcat_0/In7] [get_bd_pins xlslice_26/Dout]
  connect_bd_net -net xlslice_27_Dout [get_bd_pins xlconcat_0/In3] [get_bd_pins xlslice_27/Dout]
  connect_bd_net -net xlslice_28_Dout [get_bd_pins xlconcat_0/In31] [get_bd_pins xlslice_28/Dout]
  connect_bd_net -net xlslice_29_Dout [get_bd_pins xlconcat_0/In27] [get_bd_pins xlslice_29/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins xlconcat_0/In4] [get_bd_pins xlslice_2/Dout]
  connect_bd_net -net xlslice_30_Dout [get_bd_pins xlconcat_0/In23] [get_bd_pins xlslice_30/Dout]
  connect_bd_net -net xlslice_31_Dout [get_bd_pins xlconcat_0/In19] [get_bd_pins xlslice_31/Dout]
  connect_bd_net -net xlslice_3_Dout [get_bd_pins xlconcat_0/In0] [get_bd_pins xlslice_3/Dout]
  connect_bd_net -net xlslice_4_Dout [get_bd_pins xlconcat_0/In28] [get_bd_pins xlslice_4/Dout]
  connect_bd_net -net xlslice_5_Dout [get_bd_pins xlconcat_0/In24] [get_bd_pins xlslice_5/Dout]
  connect_bd_net -net xlslice_6_Dout [get_bd_pins xlconcat_0/In20] [get_bd_pins xlslice_6/Dout]
  connect_bd_net -net xlslice_7_Dout [get_bd_pins xlconcat_0/In16] [get_bd_pins xlslice_7/Dout]
  connect_bd_net -net xlslice_8_Dout [get_bd_pins xlconcat_0/In13] [get_bd_pins xlslice_8/Dout]
  connect_bd_net -net xlslice_9_Dout [get_bd_pins xlconcat_0/In9] [get_bd_pins xlslice_9/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_0
proc create_hier_cell_hier_0_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_hier_0_2() - Empty argument(s)!"}
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

  # Create pins
  create_bd_pin -dir I -from 31 -to 0 Din
  create_bd_pin -dir O -from 31 -to 0 dout_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {32} \
 ] $xlconcat_0

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_1

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_2

  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_3

  # Create instance: xlslice_4, and set properties
  set xlslice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_4 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {4} \
   CONFIG.DIN_TO {4} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_4

  # Create instance: xlslice_5, and set properties
  set xlslice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_5 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {5} \
   CONFIG.DIN_TO {5} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_5

  # Create instance: xlslice_6, and set properties
  set xlslice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_6 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {6} \
   CONFIG.DIN_TO {6} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_6

  # Create instance: xlslice_7, and set properties
  set xlslice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_7 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {7} \
   CONFIG.DIN_TO {7} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_7

  # Create instance: xlslice_8, and set properties
  set xlslice_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_8 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {8} \
   CONFIG.DIN_TO {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_8

  # Create instance: xlslice_9, and set properties
  set xlslice_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_9 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {9} \
   CONFIG.DIN_TO {9} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_9

  # Create instance: xlslice_10, and set properties
  set xlslice_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_10 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {10} \
   CONFIG.DIN_TO {10} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_10

  # Create instance: xlslice_11, and set properties
  set xlslice_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_11 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {11} \
   CONFIG.DIN_TO {11} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_11

  # Create instance: xlslice_12, and set properties
  set xlslice_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_12 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {12} \
   CONFIG.DIN_TO {12} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_12

  # Create instance: xlslice_13, and set properties
  set xlslice_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_13 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {13} \
   CONFIG.DIN_TO {13} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_13

  # Create instance: xlslice_14, and set properties
  set xlslice_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_14 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {14} \
   CONFIG.DIN_TO {14} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_14

  # Create instance: xlslice_15, and set properties
  set xlslice_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_15 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {15} \
   CONFIG.DIN_TO {15} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_15

  # Create instance: xlslice_16, and set properties
  set xlslice_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_16 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {16} \
   CONFIG.DIN_TO {16} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_16

  # Create instance: xlslice_17, and set properties
  set xlslice_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_17 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {17} \
   CONFIG.DIN_TO {17} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_17

  # Create instance: xlslice_18, and set properties
  set xlslice_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_18 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {18} \
   CONFIG.DIN_TO {18} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_18

  # Create instance: xlslice_19, and set properties
  set xlslice_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_19 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {19} \
   CONFIG.DIN_TO {19} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_19

  # Create instance: xlslice_20, and set properties
  set xlslice_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_20 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {20} \
   CONFIG.DIN_TO {20} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_20

  # Create instance: xlslice_21, and set properties
  set xlslice_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_21 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {21} \
   CONFIG.DIN_TO {21} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_21

  # Create instance: xlslice_22, and set properties
  set xlslice_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_22 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {22} \
   CONFIG.DIN_TO {22} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_22

  # Create instance: xlslice_23, and set properties
  set xlslice_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_23 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {23} \
   CONFIG.DIN_TO {23} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_23

  # Create instance: xlslice_24, and set properties
  set xlslice_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_24 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {24} \
   CONFIG.DIN_TO {24} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_24

  # Create instance: xlslice_25, and set properties
  set xlslice_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_25 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {25} \
   CONFIG.DIN_TO {25} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_25

  # Create instance: xlslice_26, and set properties
  set xlslice_26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_26 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {26} \
   CONFIG.DIN_TO {26} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_26

  # Create instance: xlslice_27, and set properties
  set xlslice_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_27 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {27} \
   CONFIG.DIN_TO {27} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_27

  # Create instance: xlslice_28, and set properties
  set xlslice_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_28 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {28} \
   CONFIG.DIN_TO {28} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_28

  # Create instance: xlslice_29, and set properties
  set xlslice_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_29 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {29} \
   CONFIG.DIN_TO {29} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_29

  # Create instance: xlslice_30, and set properties
  set xlslice_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_30 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {30} \
   CONFIG.DIN_TO {30} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_30

  # Create instance: xlslice_31, and set properties
  set xlslice_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_31 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {31} \
   CONFIG.DIN_TO {31} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_31

  # Create port connections
  connect_bd_net -net xlconcat_0_dout [get_bd_pins Din] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din] [get_bd_pins xlslice_10/Din] [get_bd_pins xlslice_11/Din] [get_bd_pins xlslice_12/Din] [get_bd_pins xlslice_13/Din] [get_bd_pins xlslice_14/Din] [get_bd_pins xlslice_15/Din] [get_bd_pins xlslice_16/Din] [get_bd_pins xlslice_17/Din] [get_bd_pins xlslice_18/Din] [get_bd_pins xlslice_19/Din] [get_bd_pins xlslice_2/Din] [get_bd_pins xlslice_20/Din] [get_bd_pins xlslice_21/Din] [get_bd_pins xlslice_22/Din] [get_bd_pins xlslice_23/Din] [get_bd_pins xlslice_24/Din] [get_bd_pins xlslice_25/Din] [get_bd_pins xlslice_26/Din] [get_bd_pins xlslice_27/Din] [get_bd_pins xlslice_28/Din] [get_bd_pins xlslice_29/Din] [get_bd_pins xlslice_3/Din] [get_bd_pins xlslice_30/Din] [get_bd_pins xlslice_31/Din] [get_bd_pins xlslice_4/Din] [get_bd_pins xlslice_5/Din] [get_bd_pins xlslice_6/Din] [get_bd_pins xlslice_7/Din] [get_bd_pins xlslice_8/Din] [get_bd_pins xlslice_9/Din]
  connect_bd_net -net xlconcat_0_dout1 [get_bd_pins dout_0] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins xlconcat_0/In12] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_10_Dout [get_bd_pins xlconcat_0/In5] [get_bd_pins xlslice_10/Dout]
  connect_bd_net -net xlslice_11_Dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlslice_11/Dout]
  connect_bd_net -net xlslice_12_Dout [get_bd_pins xlconcat_0/In29] [get_bd_pins xlslice_12/Dout]
  connect_bd_net -net xlslice_13_Dout [get_bd_pins xlconcat_0/In25] [get_bd_pins xlslice_13/Dout]
  connect_bd_net -net xlslice_14_Dout [get_bd_pins xlconcat_0/In21] [get_bd_pins xlslice_14/Dout]
  connect_bd_net -net xlslice_15_Dout [get_bd_pins xlconcat_0/In17] [get_bd_pins xlslice_15/Dout]
  connect_bd_net -net xlslice_16_Dout [get_bd_pins xlconcat_0/In14] [get_bd_pins xlslice_16/Dout]
  connect_bd_net -net xlslice_17_Dout [get_bd_pins xlconcat_0/In10] [get_bd_pins xlslice_17/Dout]
  connect_bd_net -net xlslice_18_Dout [get_bd_pins xlconcat_0/In6] [get_bd_pins xlslice_18/Dout]
  connect_bd_net -net xlslice_19_Dout [get_bd_pins xlconcat_0/In2] [get_bd_pins xlslice_19/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins xlconcat_0/In8] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net xlslice_20_Dout [get_bd_pins xlconcat_0/In30] [get_bd_pins xlslice_20/Dout]
  connect_bd_net -net xlslice_21_Dout [get_bd_pins xlconcat_0/In26] [get_bd_pins xlslice_21/Dout]
  connect_bd_net -net xlslice_22_Dout [get_bd_pins xlconcat_0/In22] [get_bd_pins xlslice_22/Dout]
  connect_bd_net -net xlslice_23_Dout [get_bd_pins xlconcat_0/In18] [get_bd_pins xlslice_23/Dout]
  connect_bd_net -net xlslice_24_Dout [get_bd_pins xlconcat_0/In15] [get_bd_pins xlslice_24/Dout]
  connect_bd_net -net xlslice_25_Dout [get_bd_pins xlconcat_0/In11] [get_bd_pins xlslice_25/Dout]
  connect_bd_net -net xlslice_26_Dout [get_bd_pins xlconcat_0/In7] [get_bd_pins xlslice_26/Dout]
  connect_bd_net -net xlslice_27_Dout [get_bd_pins xlconcat_0/In3] [get_bd_pins xlslice_27/Dout]
  connect_bd_net -net xlslice_28_Dout [get_bd_pins xlconcat_0/In31] [get_bd_pins xlslice_28/Dout]
  connect_bd_net -net xlslice_29_Dout [get_bd_pins xlconcat_0/In27] [get_bd_pins xlslice_29/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins xlconcat_0/In4] [get_bd_pins xlslice_2/Dout]
  connect_bd_net -net xlslice_30_Dout [get_bd_pins xlconcat_0/In23] [get_bd_pins xlslice_30/Dout]
  connect_bd_net -net xlslice_31_Dout [get_bd_pins xlconcat_0/In19] [get_bd_pins xlslice_31/Dout]
  connect_bd_net -net xlslice_3_Dout [get_bd_pins xlconcat_0/In0] [get_bd_pins xlslice_3/Dout]
  connect_bd_net -net xlslice_4_Dout [get_bd_pins xlconcat_0/In28] [get_bd_pins xlslice_4/Dout]
  connect_bd_net -net xlslice_5_Dout [get_bd_pins xlconcat_0/In24] [get_bd_pins xlslice_5/Dout]
  connect_bd_net -net xlslice_6_Dout [get_bd_pins xlconcat_0/In20] [get_bd_pins xlslice_6/Dout]
  connect_bd_net -net xlslice_7_Dout [get_bd_pins xlconcat_0/In16] [get_bd_pins xlslice_7/Dout]
  connect_bd_net -net xlslice_8_Dout [get_bd_pins xlconcat_0/In13] [get_bd_pins xlslice_8/Dout]
  connect_bd_net -net xlslice_9_Dout [get_bd_pins xlconcat_0/In9] [get_bd_pins xlslice_9/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_1
proc create_hier_cell_hier_1_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_hier_1_2() - Empty argument(s)!"}
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

  # Create pins
  create_bd_pin -dir I -from 31 -to 0 Din
  create_bd_pin -dir O -from 31 -to 0 dout_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {32} \
 ] $xlconcat_0

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_1

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_2

  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_3

  # Create instance: xlslice_4, and set properties
  set xlslice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_4 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {4} \
   CONFIG.DIN_TO {4} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_4

  # Create instance: xlslice_5, and set properties
  set xlslice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_5 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {5} \
   CONFIG.DIN_TO {5} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_5

  # Create instance: xlslice_6, and set properties
  set xlslice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_6 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {6} \
   CONFIG.DIN_TO {6} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_6

  # Create instance: xlslice_7, and set properties
  set xlslice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_7 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {7} \
   CONFIG.DIN_TO {7} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_7

  # Create instance: xlslice_8, and set properties
  set xlslice_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_8 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {8} \
   CONFIG.DIN_TO {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_8

  # Create instance: xlslice_9, and set properties
  set xlslice_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_9 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {9} \
   CONFIG.DIN_TO {9} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_9

  # Create instance: xlslice_10, and set properties
  set xlslice_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_10 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {10} \
   CONFIG.DIN_TO {10} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_10

  # Create instance: xlslice_11, and set properties
  set xlslice_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_11 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {11} \
   CONFIG.DIN_TO {11} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_11

  # Create instance: xlslice_12, and set properties
  set xlslice_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_12 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {12} \
   CONFIG.DIN_TO {12} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_12

  # Create instance: xlslice_13, and set properties
  set xlslice_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_13 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {13} \
   CONFIG.DIN_TO {13} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_13

  # Create instance: xlslice_14, and set properties
  set xlslice_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_14 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {14} \
   CONFIG.DIN_TO {14} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_14

  # Create instance: xlslice_15, and set properties
  set xlslice_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_15 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {15} \
   CONFIG.DIN_TO {15} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_15

  # Create instance: xlslice_16, and set properties
  set xlslice_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_16 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {16} \
   CONFIG.DIN_TO {16} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_16

  # Create instance: xlslice_17, and set properties
  set xlslice_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_17 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {17} \
   CONFIG.DIN_TO {17} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_17

  # Create instance: xlslice_18, and set properties
  set xlslice_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_18 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {18} \
   CONFIG.DIN_TO {18} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_18

  # Create instance: xlslice_19, and set properties
  set xlslice_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_19 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {19} \
   CONFIG.DIN_TO {19} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_19

  # Create instance: xlslice_20, and set properties
  set xlslice_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_20 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {20} \
   CONFIG.DIN_TO {20} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_20

  # Create instance: xlslice_21, and set properties
  set xlslice_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_21 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {21} \
   CONFIG.DIN_TO {21} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_21

  # Create instance: xlslice_22, and set properties
  set xlslice_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_22 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {22} \
   CONFIG.DIN_TO {22} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_22

  # Create instance: xlslice_23, and set properties
  set xlslice_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_23 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {23} \
   CONFIG.DIN_TO {23} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_23

  # Create instance: xlslice_24, and set properties
  set xlslice_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_24 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {24} \
   CONFIG.DIN_TO {24} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_24

  # Create instance: xlslice_25, and set properties
  set xlslice_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_25 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {25} \
   CONFIG.DIN_TO {25} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_25

  # Create instance: xlslice_26, and set properties
  set xlslice_26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_26 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {26} \
   CONFIG.DIN_TO {26} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_26

  # Create instance: xlslice_27, and set properties
  set xlslice_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_27 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {27} \
   CONFIG.DIN_TO {27} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_27

  # Create instance: xlslice_28, and set properties
  set xlslice_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_28 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {28} \
   CONFIG.DIN_TO {28} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_28

  # Create instance: xlslice_29, and set properties
  set xlslice_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_29 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {29} \
   CONFIG.DIN_TO {29} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_29

  # Create instance: xlslice_30, and set properties
  set xlslice_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_30 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {30} \
   CONFIG.DIN_TO {30} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_30

  # Create instance: xlslice_31, and set properties
  set xlslice_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_31 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {31} \
   CONFIG.DIN_TO {31} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_31

  # Create port connections
  connect_bd_net -net xlconcat_0_dout [get_bd_pins Din] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din] [get_bd_pins xlslice_10/Din] [get_bd_pins xlslice_11/Din] [get_bd_pins xlslice_12/Din] [get_bd_pins xlslice_13/Din] [get_bd_pins xlslice_14/Din] [get_bd_pins xlslice_15/Din] [get_bd_pins xlslice_16/Din] [get_bd_pins xlslice_17/Din] [get_bd_pins xlslice_18/Din] [get_bd_pins xlslice_19/Din] [get_bd_pins xlslice_2/Din] [get_bd_pins xlslice_20/Din] [get_bd_pins xlslice_21/Din] [get_bd_pins xlslice_22/Din] [get_bd_pins xlslice_23/Din] [get_bd_pins xlslice_24/Din] [get_bd_pins xlslice_25/Din] [get_bd_pins xlslice_26/Din] [get_bd_pins xlslice_27/Din] [get_bd_pins xlslice_28/Din] [get_bd_pins xlslice_29/Din] [get_bd_pins xlslice_3/Din] [get_bd_pins xlslice_30/Din] [get_bd_pins xlslice_31/Din] [get_bd_pins xlslice_4/Din] [get_bd_pins xlslice_5/Din] [get_bd_pins xlslice_6/Din] [get_bd_pins xlslice_7/Din] [get_bd_pins xlslice_8/Din] [get_bd_pins xlslice_9/Din]
  connect_bd_net -net xlconcat_0_dout1 [get_bd_pins dout_0] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins xlconcat_0/In12] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_10_Dout [get_bd_pins xlconcat_0/In5] [get_bd_pins xlslice_10/Dout]
  connect_bd_net -net xlslice_11_Dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlslice_11/Dout]
  connect_bd_net -net xlslice_12_Dout [get_bd_pins xlconcat_0/In29] [get_bd_pins xlslice_12/Dout]
  connect_bd_net -net xlslice_13_Dout [get_bd_pins xlconcat_0/In25] [get_bd_pins xlslice_13/Dout]
  connect_bd_net -net xlslice_14_Dout [get_bd_pins xlconcat_0/In21] [get_bd_pins xlslice_14/Dout]
  connect_bd_net -net xlslice_15_Dout [get_bd_pins xlconcat_0/In17] [get_bd_pins xlslice_15/Dout]
  connect_bd_net -net xlslice_16_Dout [get_bd_pins xlconcat_0/In14] [get_bd_pins xlslice_16/Dout]
  connect_bd_net -net xlslice_17_Dout [get_bd_pins xlconcat_0/In10] [get_bd_pins xlslice_17/Dout]
  connect_bd_net -net xlslice_18_Dout [get_bd_pins xlconcat_0/In6] [get_bd_pins xlslice_18/Dout]
  connect_bd_net -net xlslice_19_Dout [get_bd_pins xlconcat_0/In2] [get_bd_pins xlslice_19/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins xlconcat_0/In8] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net xlslice_20_Dout [get_bd_pins xlconcat_0/In30] [get_bd_pins xlslice_20/Dout]
  connect_bd_net -net xlslice_21_Dout [get_bd_pins xlconcat_0/In26] [get_bd_pins xlslice_21/Dout]
  connect_bd_net -net xlslice_22_Dout [get_bd_pins xlconcat_0/In22] [get_bd_pins xlslice_22/Dout]
  connect_bd_net -net xlslice_23_Dout [get_bd_pins xlconcat_0/In18] [get_bd_pins xlslice_23/Dout]
  connect_bd_net -net xlslice_24_Dout [get_bd_pins xlconcat_0/In15] [get_bd_pins xlslice_24/Dout]
  connect_bd_net -net xlslice_25_Dout [get_bd_pins xlconcat_0/In11] [get_bd_pins xlslice_25/Dout]
  connect_bd_net -net xlslice_26_Dout [get_bd_pins xlconcat_0/In7] [get_bd_pins xlslice_26/Dout]
  connect_bd_net -net xlslice_27_Dout [get_bd_pins xlconcat_0/In3] [get_bd_pins xlslice_27/Dout]
  connect_bd_net -net xlslice_28_Dout [get_bd_pins xlconcat_0/In31] [get_bd_pins xlslice_28/Dout]
  connect_bd_net -net xlslice_29_Dout [get_bd_pins xlconcat_0/In27] [get_bd_pins xlslice_29/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins xlconcat_0/In4] [get_bd_pins xlslice_2/Dout]
  connect_bd_net -net xlslice_30_Dout [get_bd_pins xlconcat_0/In23] [get_bd_pins xlslice_30/Dout]
  connect_bd_net -net xlslice_31_Dout [get_bd_pins xlconcat_0/In19] [get_bd_pins xlslice_31/Dout]
  connect_bd_net -net xlslice_3_Dout [get_bd_pins xlconcat_0/In0] [get_bd_pins xlslice_3/Dout]
  connect_bd_net -net xlslice_4_Dout [get_bd_pins xlconcat_0/In28] [get_bd_pins xlslice_4/Dout]
  connect_bd_net -net xlslice_5_Dout [get_bd_pins xlconcat_0/In24] [get_bd_pins xlslice_5/Dout]
  connect_bd_net -net xlslice_6_Dout [get_bd_pins xlconcat_0/In20] [get_bd_pins xlslice_6/Dout]
  connect_bd_net -net xlslice_7_Dout [get_bd_pins xlconcat_0/In16] [get_bd_pins xlslice_7/Dout]
  connect_bd_net -net xlslice_8_Dout [get_bd_pins xlconcat_0/In13] [get_bd_pins xlslice_8/Dout]
  connect_bd_net -net xlslice_9_Dout [get_bd_pins xlconcat_0/In9] [get_bd_pins xlslice_9/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_2
proc create_hier_cell_hier_2_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_hier_2_2() - Empty argument(s)!"}
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

  # Create pins
  create_bd_pin -dir I -from 31 -to 0 Din
  create_bd_pin -dir O -from 31 -to 0 dout_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {32} \
 ] $xlconcat_0

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_1

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_2

  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_3

  # Create instance: xlslice_4, and set properties
  set xlslice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_4 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {4} \
   CONFIG.DIN_TO {4} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_4

  # Create instance: xlslice_5, and set properties
  set xlslice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_5 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {5} \
   CONFIG.DIN_TO {5} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_5

  # Create instance: xlslice_6, and set properties
  set xlslice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_6 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {6} \
   CONFIG.DIN_TO {6} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_6

  # Create instance: xlslice_7, and set properties
  set xlslice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_7 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {7} \
   CONFIG.DIN_TO {7} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_7

  # Create instance: xlslice_8, and set properties
  set xlslice_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_8 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {8} \
   CONFIG.DIN_TO {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_8

  # Create instance: xlslice_9, and set properties
  set xlslice_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_9 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {9} \
   CONFIG.DIN_TO {9} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_9

  # Create instance: xlslice_10, and set properties
  set xlslice_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_10 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {10} \
   CONFIG.DIN_TO {10} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_10

  # Create instance: xlslice_11, and set properties
  set xlslice_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_11 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {11} \
   CONFIG.DIN_TO {11} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_11

  # Create instance: xlslice_12, and set properties
  set xlslice_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_12 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {12} \
   CONFIG.DIN_TO {12} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_12

  # Create instance: xlslice_13, and set properties
  set xlslice_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_13 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {13} \
   CONFIG.DIN_TO {13} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_13

  # Create instance: xlslice_14, and set properties
  set xlslice_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_14 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {14} \
   CONFIG.DIN_TO {14} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_14

  # Create instance: xlslice_15, and set properties
  set xlslice_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_15 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {15} \
   CONFIG.DIN_TO {15} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_15

  # Create instance: xlslice_16, and set properties
  set xlslice_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_16 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {16} \
   CONFIG.DIN_TO {16} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_16

  # Create instance: xlslice_17, and set properties
  set xlslice_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_17 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {17} \
   CONFIG.DIN_TO {17} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_17

  # Create instance: xlslice_18, and set properties
  set xlslice_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_18 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {18} \
   CONFIG.DIN_TO {18} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_18

  # Create instance: xlslice_19, and set properties
  set xlslice_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_19 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {19} \
   CONFIG.DIN_TO {19} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_19

  # Create instance: xlslice_20, and set properties
  set xlslice_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_20 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {20} \
   CONFIG.DIN_TO {20} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_20

  # Create instance: xlslice_21, and set properties
  set xlslice_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_21 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {21} \
   CONFIG.DIN_TO {21} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_21

  # Create instance: xlslice_22, and set properties
  set xlslice_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_22 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {22} \
   CONFIG.DIN_TO {22} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_22

  # Create instance: xlslice_23, and set properties
  set xlslice_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_23 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {23} \
   CONFIG.DIN_TO {23} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_23

  # Create instance: xlslice_24, and set properties
  set xlslice_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_24 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {24} \
   CONFIG.DIN_TO {24} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_24

  # Create instance: xlslice_25, and set properties
  set xlslice_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_25 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {25} \
   CONFIG.DIN_TO {25} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_25

  # Create instance: xlslice_26, and set properties
  set xlslice_26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_26 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {26} \
   CONFIG.DIN_TO {26} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_26

  # Create instance: xlslice_27, and set properties
  set xlslice_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_27 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {27} \
   CONFIG.DIN_TO {27} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_27

  # Create instance: xlslice_28, and set properties
  set xlslice_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_28 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {28} \
   CONFIG.DIN_TO {28} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_28

  # Create instance: xlslice_29, and set properties
  set xlslice_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_29 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {29} \
   CONFIG.DIN_TO {29} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_29

  # Create instance: xlslice_30, and set properties
  set xlslice_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_30 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {30} \
   CONFIG.DIN_TO {30} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_30

  # Create instance: xlslice_31, and set properties
  set xlslice_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_31 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {31} \
   CONFIG.DIN_TO {31} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_31

  # Create port connections
  connect_bd_net -net xlconcat_0_dout [get_bd_pins Din] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din] [get_bd_pins xlslice_10/Din] [get_bd_pins xlslice_11/Din] [get_bd_pins xlslice_12/Din] [get_bd_pins xlslice_13/Din] [get_bd_pins xlslice_14/Din] [get_bd_pins xlslice_15/Din] [get_bd_pins xlslice_16/Din] [get_bd_pins xlslice_17/Din] [get_bd_pins xlslice_18/Din] [get_bd_pins xlslice_19/Din] [get_bd_pins xlslice_2/Din] [get_bd_pins xlslice_20/Din] [get_bd_pins xlslice_21/Din] [get_bd_pins xlslice_22/Din] [get_bd_pins xlslice_23/Din] [get_bd_pins xlslice_24/Din] [get_bd_pins xlslice_25/Din] [get_bd_pins xlslice_26/Din] [get_bd_pins xlslice_27/Din] [get_bd_pins xlslice_28/Din] [get_bd_pins xlslice_29/Din] [get_bd_pins xlslice_3/Din] [get_bd_pins xlslice_30/Din] [get_bd_pins xlslice_31/Din] [get_bd_pins xlslice_4/Din] [get_bd_pins xlslice_5/Din] [get_bd_pins xlslice_6/Din] [get_bd_pins xlslice_7/Din] [get_bd_pins xlslice_8/Din] [get_bd_pins xlslice_9/Din]
  connect_bd_net -net xlconcat_0_dout1 [get_bd_pins dout_0] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins xlconcat_0/In12] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_10_Dout [get_bd_pins xlconcat_0/In5] [get_bd_pins xlslice_10/Dout]
  connect_bd_net -net xlslice_11_Dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlslice_11/Dout]
  connect_bd_net -net xlslice_12_Dout [get_bd_pins xlconcat_0/In29] [get_bd_pins xlslice_12/Dout]
  connect_bd_net -net xlslice_13_Dout [get_bd_pins xlconcat_0/In25] [get_bd_pins xlslice_13/Dout]
  connect_bd_net -net xlslice_14_Dout [get_bd_pins xlconcat_0/In21] [get_bd_pins xlslice_14/Dout]
  connect_bd_net -net xlslice_15_Dout [get_bd_pins xlconcat_0/In17] [get_bd_pins xlslice_15/Dout]
  connect_bd_net -net xlslice_16_Dout [get_bd_pins xlconcat_0/In14] [get_bd_pins xlslice_16/Dout]
  connect_bd_net -net xlslice_17_Dout [get_bd_pins xlconcat_0/In10] [get_bd_pins xlslice_17/Dout]
  connect_bd_net -net xlslice_18_Dout [get_bd_pins xlconcat_0/In6] [get_bd_pins xlslice_18/Dout]
  connect_bd_net -net xlslice_19_Dout [get_bd_pins xlconcat_0/In2] [get_bd_pins xlslice_19/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins xlconcat_0/In8] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net xlslice_20_Dout [get_bd_pins xlconcat_0/In30] [get_bd_pins xlslice_20/Dout]
  connect_bd_net -net xlslice_21_Dout [get_bd_pins xlconcat_0/In26] [get_bd_pins xlslice_21/Dout]
  connect_bd_net -net xlslice_22_Dout [get_bd_pins xlconcat_0/In22] [get_bd_pins xlslice_22/Dout]
  connect_bd_net -net xlslice_23_Dout [get_bd_pins xlconcat_0/In18] [get_bd_pins xlslice_23/Dout]
  connect_bd_net -net xlslice_24_Dout [get_bd_pins xlconcat_0/In15] [get_bd_pins xlslice_24/Dout]
  connect_bd_net -net xlslice_25_Dout [get_bd_pins xlconcat_0/In11] [get_bd_pins xlslice_25/Dout]
  connect_bd_net -net xlslice_26_Dout [get_bd_pins xlconcat_0/In7] [get_bd_pins xlslice_26/Dout]
  connect_bd_net -net xlslice_27_Dout [get_bd_pins xlconcat_0/In3] [get_bd_pins xlslice_27/Dout]
  connect_bd_net -net xlslice_28_Dout [get_bd_pins xlconcat_0/In31] [get_bd_pins xlslice_28/Dout]
  connect_bd_net -net xlslice_29_Dout [get_bd_pins xlconcat_0/In27] [get_bd_pins xlslice_29/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins xlconcat_0/In4] [get_bd_pins xlslice_2/Dout]
  connect_bd_net -net xlslice_30_Dout [get_bd_pins xlconcat_0/In23] [get_bd_pins xlslice_30/Dout]
  connect_bd_net -net xlslice_31_Dout [get_bd_pins xlconcat_0/In19] [get_bd_pins xlslice_31/Dout]
  connect_bd_net -net xlslice_3_Dout [get_bd_pins xlconcat_0/In0] [get_bd_pins xlslice_3/Dout]
  connect_bd_net -net xlslice_4_Dout [get_bd_pins xlconcat_0/In28] [get_bd_pins xlslice_4/Dout]
  connect_bd_net -net xlslice_5_Dout [get_bd_pins xlconcat_0/In24] [get_bd_pins xlslice_5/Dout]
  connect_bd_net -net xlslice_6_Dout [get_bd_pins xlconcat_0/In20] [get_bd_pins xlslice_6/Dout]
  connect_bd_net -net xlslice_7_Dout [get_bd_pins xlconcat_0/In16] [get_bd_pins xlslice_7/Dout]
  connect_bd_net -net xlslice_8_Dout [get_bd_pins xlconcat_0/In13] [get_bd_pins xlslice_8/Dout]
  connect_bd_net -net xlslice_9_Dout [get_bd_pins xlconcat_0/In9] [get_bd_pins xlslice_9/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_3
proc create_hier_cell_hier_3_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_hier_3_2() - Empty argument(s)!"}
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

  # Create pins
  create_bd_pin -dir I -from 31 -to 0 Din
  create_bd_pin -dir O -from 31 -to 0 dout_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {32} \
 ] $xlconcat_0

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_1

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_2

  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_3

  # Create instance: xlslice_4, and set properties
  set xlslice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_4 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {4} \
   CONFIG.DIN_TO {4} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_4

  # Create instance: xlslice_5, and set properties
  set xlslice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_5 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {5} \
   CONFIG.DIN_TO {5} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_5

  # Create instance: xlslice_6, and set properties
  set xlslice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_6 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {6} \
   CONFIG.DIN_TO {6} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_6

  # Create instance: xlslice_7, and set properties
  set xlslice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_7 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {7} \
   CONFIG.DIN_TO {7} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_7

  # Create instance: xlslice_8, and set properties
  set xlslice_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_8 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {8} \
   CONFIG.DIN_TO {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_8

  # Create instance: xlslice_9, and set properties
  set xlslice_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_9 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {9} \
   CONFIG.DIN_TO {9} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_9

  # Create instance: xlslice_10, and set properties
  set xlslice_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_10 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {10} \
   CONFIG.DIN_TO {10} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_10

  # Create instance: xlslice_11, and set properties
  set xlslice_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_11 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {11} \
   CONFIG.DIN_TO {11} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_11

  # Create instance: xlslice_12, and set properties
  set xlslice_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_12 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {12} \
   CONFIG.DIN_TO {12} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_12

  # Create instance: xlslice_13, and set properties
  set xlslice_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_13 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {13} \
   CONFIG.DIN_TO {13} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_13

  # Create instance: xlslice_14, and set properties
  set xlslice_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_14 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {14} \
   CONFIG.DIN_TO {14} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_14

  # Create instance: xlslice_15, and set properties
  set xlslice_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_15 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {15} \
   CONFIG.DIN_TO {15} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_15

  # Create instance: xlslice_16, and set properties
  set xlslice_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_16 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {16} \
   CONFIG.DIN_TO {16} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_16

  # Create instance: xlslice_17, and set properties
  set xlslice_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_17 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {17} \
   CONFIG.DIN_TO {17} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_17

  # Create instance: xlslice_18, and set properties
  set xlslice_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_18 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {18} \
   CONFIG.DIN_TO {18} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_18

  # Create instance: xlslice_19, and set properties
  set xlslice_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_19 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {19} \
   CONFIG.DIN_TO {19} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_19

  # Create instance: xlslice_20, and set properties
  set xlslice_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_20 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {20} \
   CONFIG.DIN_TO {20} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_20

  # Create instance: xlslice_21, and set properties
  set xlslice_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_21 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {21} \
   CONFIG.DIN_TO {21} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_21

  # Create instance: xlslice_22, and set properties
  set xlslice_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_22 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {22} \
   CONFIG.DIN_TO {22} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_22

  # Create instance: xlslice_23, and set properties
  set xlslice_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_23 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {23} \
   CONFIG.DIN_TO {23} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_23

  # Create instance: xlslice_24, and set properties
  set xlslice_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_24 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {24} \
   CONFIG.DIN_TO {24} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_24

  # Create instance: xlslice_25, and set properties
  set xlslice_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_25 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {25} \
   CONFIG.DIN_TO {25} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_25

  # Create instance: xlslice_26, and set properties
  set xlslice_26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_26 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {26} \
   CONFIG.DIN_TO {26} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_26

  # Create instance: xlslice_27, and set properties
  set xlslice_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_27 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {27} \
   CONFIG.DIN_TO {27} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_27

  # Create instance: xlslice_28, and set properties
  set xlslice_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_28 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {28} \
   CONFIG.DIN_TO {28} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_28

  # Create instance: xlslice_29, and set properties
  set xlslice_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_29 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {29} \
   CONFIG.DIN_TO {29} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_29

  # Create instance: xlslice_30, and set properties
  set xlslice_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_30 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {30} \
   CONFIG.DIN_TO {30} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_30

  # Create instance: xlslice_31, and set properties
  set xlslice_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_31 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {31} \
   CONFIG.DIN_TO {31} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_31

  # Create port connections
  connect_bd_net -net xlconcat_0_dout [get_bd_pins Din] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din] [get_bd_pins xlslice_10/Din] [get_bd_pins xlslice_11/Din] [get_bd_pins xlslice_12/Din] [get_bd_pins xlslice_13/Din] [get_bd_pins xlslice_14/Din] [get_bd_pins xlslice_15/Din] [get_bd_pins xlslice_16/Din] [get_bd_pins xlslice_17/Din] [get_bd_pins xlslice_18/Din] [get_bd_pins xlslice_19/Din] [get_bd_pins xlslice_2/Din] [get_bd_pins xlslice_20/Din] [get_bd_pins xlslice_21/Din] [get_bd_pins xlslice_22/Din] [get_bd_pins xlslice_23/Din] [get_bd_pins xlslice_24/Din] [get_bd_pins xlslice_25/Din] [get_bd_pins xlslice_26/Din] [get_bd_pins xlslice_27/Din] [get_bd_pins xlslice_28/Din] [get_bd_pins xlslice_29/Din] [get_bd_pins xlslice_3/Din] [get_bd_pins xlslice_30/Din] [get_bd_pins xlslice_31/Din] [get_bd_pins xlslice_4/Din] [get_bd_pins xlslice_5/Din] [get_bd_pins xlslice_6/Din] [get_bd_pins xlslice_7/Din] [get_bd_pins xlslice_8/Din] [get_bd_pins xlslice_9/Din]
  connect_bd_net -net xlconcat_0_dout1 [get_bd_pins dout_0] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins xlconcat_0/In12] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_10_Dout [get_bd_pins xlconcat_0/In5] [get_bd_pins xlslice_10/Dout]
  connect_bd_net -net xlslice_11_Dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlslice_11/Dout]
  connect_bd_net -net xlslice_12_Dout [get_bd_pins xlconcat_0/In29] [get_bd_pins xlslice_12/Dout]
  connect_bd_net -net xlslice_13_Dout [get_bd_pins xlconcat_0/In25] [get_bd_pins xlslice_13/Dout]
  connect_bd_net -net xlslice_14_Dout [get_bd_pins xlconcat_0/In21] [get_bd_pins xlslice_14/Dout]
  connect_bd_net -net xlslice_15_Dout [get_bd_pins xlconcat_0/In17] [get_bd_pins xlslice_15/Dout]
  connect_bd_net -net xlslice_16_Dout [get_bd_pins xlconcat_0/In14] [get_bd_pins xlslice_16/Dout]
  connect_bd_net -net xlslice_17_Dout [get_bd_pins xlconcat_0/In10] [get_bd_pins xlslice_17/Dout]
  connect_bd_net -net xlslice_18_Dout [get_bd_pins xlconcat_0/In6] [get_bd_pins xlslice_18/Dout]
  connect_bd_net -net xlslice_19_Dout [get_bd_pins xlconcat_0/In2] [get_bd_pins xlslice_19/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins xlconcat_0/In8] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net xlslice_20_Dout [get_bd_pins xlconcat_0/In30] [get_bd_pins xlslice_20/Dout]
  connect_bd_net -net xlslice_21_Dout [get_bd_pins xlconcat_0/In26] [get_bd_pins xlslice_21/Dout]
  connect_bd_net -net xlslice_22_Dout [get_bd_pins xlconcat_0/In22] [get_bd_pins xlslice_22/Dout]
  connect_bd_net -net xlslice_23_Dout [get_bd_pins xlconcat_0/In18] [get_bd_pins xlslice_23/Dout]
  connect_bd_net -net xlslice_24_Dout [get_bd_pins xlconcat_0/In15] [get_bd_pins xlslice_24/Dout]
  connect_bd_net -net xlslice_25_Dout [get_bd_pins xlconcat_0/In11] [get_bd_pins xlslice_25/Dout]
  connect_bd_net -net xlslice_26_Dout [get_bd_pins xlconcat_0/In7] [get_bd_pins xlslice_26/Dout]
  connect_bd_net -net xlslice_27_Dout [get_bd_pins xlconcat_0/In3] [get_bd_pins xlslice_27/Dout]
  connect_bd_net -net xlslice_28_Dout [get_bd_pins xlconcat_0/In31] [get_bd_pins xlslice_28/Dout]
  connect_bd_net -net xlslice_29_Dout [get_bd_pins xlconcat_0/In27] [get_bd_pins xlslice_29/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins xlconcat_0/In4] [get_bd_pins xlslice_2/Dout]
  connect_bd_net -net xlslice_30_Dout [get_bd_pins xlconcat_0/In23] [get_bd_pins xlslice_30/Dout]
  connect_bd_net -net xlslice_31_Dout [get_bd_pins xlconcat_0/In19] [get_bd_pins xlslice_31/Dout]
  connect_bd_net -net xlslice_3_Dout [get_bd_pins xlconcat_0/In0] [get_bd_pins xlslice_3/Dout]
  connect_bd_net -net xlslice_4_Dout [get_bd_pins xlconcat_0/In28] [get_bd_pins xlslice_4/Dout]
  connect_bd_net -net xlslice_5_Dout [get_bd_pins xlconcat_0/In24] [get_bd_pins xlslice_5/Dout]
  connect_bd_net -net xlslice_6_Dout [get_bd_pins xlconcat_0/In20] [get_bd_pins xlslice_6/Dout]
  connect_bd_net -net xlslice_7_Dout [get_bd_pins xlconcat_0/In16] [get_bd_pins xlslice_7/Dout]
  connect_bd_net -net xlslice_8_Dout [get_bd_pins xlconcat_0/In13] [get_bd_pins xlslice_8/Dout]
  connect_bd_net -net xlslice_9_Dout [get_bd_pins xlconcat_0/In9] [get_bd_pins xlslice_9/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_0
proc create_hier_cell_hier_0_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_hier_0_1() - Empty argument(s)!"}
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

  # Create pins
  create_bd_pin -dir I -from 31 -to 0 Din
  create_bd_pin -dir O -from 31 -to 0 dout_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {32} \
 ] $xlconcat_0

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_1

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_2

  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_3

  # Create instance: xlslice_4, and set properties
  set xlslice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_4 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {4} \
   CONFIG.DIN_TO {4} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_4

  # Create instance: xlslice_5, and set properties
  set xlslice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_5 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {5} \
   CONFIG.DIN_TO {5} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_5

  # Create instance: xlslice_6, and set properties
  set xlslice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_6 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {6} \
   CONFIG.DIN_TO {6} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_6

  # Create instance: xlslice_7, and set properties
  set xlslice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_7 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {7} \
   CONFIG.DIN_TO {7} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_7

  # Create instance: xlslice_8, and set properties
  set xlslice_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_8 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {8} \
   CONFIG.DIN_TO {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_8

  # Create instance: xlslice_9, and set properties
  set xlslice_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_9 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {9} \
   CONFIG.DIN_TO {9} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_9

  # Create instance: xlslice_10, and set properties
  set xlslice_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_10 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {10} \
   CONFIG.DIN_TO {10} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_10

  # Create instance: xlslice_11, and set properties
  set xlslice_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_11 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {11} \
   CONFIG.DIN_TO {11} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_11

  # Create instance: xlslice_12, and set properties
  set xlslice_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_12 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {12} \
   CONFIG.DIN_TO {12} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_12

  # Create instance: xlslice_13, and set properties
  set xlslice_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_13 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {13} \
   CONFIG.DIN_TO {13} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_13

  # Create instance: xlslice_14, and set properties
  set xlslice_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_14 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {14} \
   CONFIG.DIN_TO {14} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_14

  # Create instance: xlslice_15, and set properties
  set xlslice_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_15 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {15} \
   CONFIG.DIN_TO {15} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_15

  # Create instance: xlslice_16, and set properties
  set xlslice_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_16 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {16} \
   CONFIG.DIN_TO {16} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_16

  # Create instance: xlslice_17, and set properties
  set xlslice_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_17 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {17} \
   CONFIG.DIN_TO {17} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_17

  # Create instance: xlslice_18, and set properties
  set xlslice_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_18 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {18} \
   CONFIG.DIN_TO {18} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_18

  # Create instance: xlslice_19, and set properties
  set xlslice_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_19 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {19} \
   CONFIG.DIN_TO {19} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_19

  # Create instance: xlslice_20, and set properties
  set xlslice_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_20 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {20} \
   CONFIG.DIN_TO {20} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_20

  # Create instance: xlslice_21, and set properties
  set xlslice_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_21 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {21} \
   CONFIG.DIN_TO {21} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_21

  # Create instance: xlslice_22, and set properties
  set xlslice_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_22 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {22} \
   CONFIG.DIN_TO {22} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_22

  # Create instance: xlslice_23, and set properties
  set xlslice_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_23 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {23} \
   CONFIG.DIN_TO {23} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_23

  # Create instance: xlslice_24, and set properties
  set xlslice_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_24 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {24} \
   CONFIG.DIN_TO {24} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_24

  # Create instance: xlslice_25, and set properties
  set xlslice_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_25 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {25} \
   CONFIG.DIN_TO {25} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_25

  # Create instance: xlslice_26, and set properties
  set xlslice_26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_26 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {26} \
   CONFIG.DIN_TO {26} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_26

  # Create instance: xlslice_27, and set properties
  set xlslice_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_27 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {27} \
   CONFIG.DIN_TO {27} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_27

  # Create instance: xlslice_28, and set properties
  set xlslice_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_28 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {28} \
   CONFIG.DIN_TO {28} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_28

  # Create instance: xlslice_29, and set properties
  set xlslice_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_29 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {29} \
   CONFIG.DIN_TO {29} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_29

  # Create instance: xlslice_30, and set properties
  set xlslice_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_30 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {30} \
   CONFIG.DIN_TO {30} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_30

  # Create instance: xlslice_31, and set properties
  set xlslice_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_31 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {31} \
   CONFIG.DIN_TO {31} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_31

  # Create port connections
  connect_bd_net -net xlconcat_0_dout [get_bd_pins Din] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din] [get_bd_pins xlslice_10/Din] [get_bd_pins xlslice_11/Din] [get_bd_pins xlslice_12/Din] [get_bd_pins xlslice_13/Din] [get_bd_pins xlslice_14/Din] [get_bd_pins xlslice_15/Din] [get_bd_pins xlslice_16/Din] [get_bd_pins xlslice_17/Din] [get_bd_pins xlslice_18/Din] [get_bd_pins xlslice_19/Din] [get_bd_pins xlslice_2/Din] [get_bd_pins xlslice_20/Din] [get_bd_pins xlslice_21/Din] [get_bd_pins xlslice_22/Din] [get_bd_pins xlslice_23/Din] [get_bd_pins xlslice_24/Din] [get_bd_pins xlslice_25/Din] [get_bd_pins xlslice_26/Din] [get_bd_pins xlslice_27/Din] [get_bd_pins xlslice_28/Din] [get_bd_pins xlslice_29/Din] [get_bd_pins xlslice_3/Din] [get_bd_pins xlslice_30/Din] [get_bd_pins xlslice_31/Din] [get_bd_pins xlslice_4/Din] [get_bd_pins xlslice_5/Din] [get_bd_pins xlslice_6/Din] [get_bd_pins xlslice_7/Din] [get_bd_pins xlslice_8/Din] [get_bd_pins xlslice_9/Din]
  connect_bd_net -net xlconcat_0_dout1 [get_bd_pins dout_0] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins xlconcat_0/In12] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_10_Dout [get_bd_pins xlconcat_0/In5] [get_bd_pins xlslice_10/Dout]
  connect_bd_net -net xlslice_11_Dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlslice_11/Dout]
  connect_bd_net -net xlslice_12_Dout [get_bd_pins xlconcat_0/In29] [get_bd_pins xlslice_12/Dout]
  connect_bd_net -net xlslice_13_Dout [get_bd_pins xlconcat_0/In25] [get_bd_pins xlslice_13/Dout]
  connect_bd_net -net xlslice_14_Dout [get_bd_pins xlconcat_0/In21] [get_bd_pins xlslice_14/Dout]
  connect_bd_net -net xlslice_15_Dout [get_bd_pins xlconcat_0/In17] [get_bd_pins xlslice_15/Dout]
  connect_bd_net -net xlslice_16_Dout [get_bd_pins xlconcat_0/In14] [get_bd_pins xlslice_16/Dout]
  connect_bd_net -net xlslice_17_Dout [get_bd_pins xlconcat_0/In10] [get_bd_pins xlslice_17/Dout]
  connect_bd_net -net xlslice_18_Dout [get_bd_pins xlconcat_0/In6] [get_bd_pins xlslice_18/Dout]
  connect_bd_net -net xlslice_19_Dout [get_bd_pins xlconcat_0/In2] [get_bd_pins xlslice_19/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins xlconcat_0/In8] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net xlslice_20_Dout [get_bd_pins xlconcat_0/In30] [get_bd_pins xlslice_20/Dout]
  connect_bd_net -net xlslice_21_Dout [get_bd_pins xlconcat_0/In26] [get_bd_pins xlslice_21/Dout]
  connect_bd_net -net xlslice_22_Dout [get_bd_pins xlconcat_0/In22] [get_bd_pins xlslice_22/Dout]
  connect_bd_net -net xlslice_23_Dout [get_bd_pins xlconcat_0/In18] [get_bd_pins xlslice_23/Dout]
  connect_bd_net -net xlslice_24_Dout [get_bd_pins xlconcat_0/In15] [get_bd_pins xlslice_24/Dout]
  connect_bd_net -net xlslice_25_Dout [get_bd_pins xlconcat_0/In11] [get_bd_pins xlslice_25/Dout]
  connect_bd_net -net xlslice_26_Dout [get_bd_pins xlconcat_0/In7] [get_bd_pins xlslice_26/Dout]
  connect_bd_net -net xlslice_27_Dout [get_bd_pins xlconcat_0/In3] [get_bd_pins xlslice_27/Dout]
  connect_bd_net -net xlslice_28_Dout [get_bd_pins xlconcat_0/In31] [get_bd_pins xlslice_28/Dout]
  connect_bd_net -net xlslice_29_Dout [get_bd_pins xlconcat_0/In27] [get_bd_pins xlslice_29/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins xlconcat_0/In4] [get_bd_pins xlslice_2/Dout]
  connect_bd_net -net xlslice_30_Dout [get_bd_pins xlconcat_0/In23] [get_bd_pins xlslice_30/Dout]
  connect_bd_net -net xlslice_31_Dout [get_bd_pins xlconcat_0/In19] [get_bd_pins xlslice_31/Dout]
  connect_bd_net -net xlslice_3_Dout [get_bd_pins xlconcat_0/In0] [get_bd_pins xlslice_3/Dout]
  connect_bd_net -net xlslice_4_Dout [get_bd_pins xlconcat_0/In28] [get_bd_pins xlslice_4/Dout]
  connect_bd_net -net xlslice_5_Dout [get_bd_pins xlconcat_0/In24] [get_bd_pins xlslice_5/Dout]
  connect_bd_net -net xlslice_6_Dout [get_bd_pins xlconcat_0/In20] [get_bd_pins xlslice_6/Dout]
  connect_bd_net -net xlslice_7_Dout [get_bd_pins xlconcat_0/In16] [get_bd_pins xlslice_7/Dout]
  connect_bd_net -net xlslice_8_Dout [get_bd_pins xlconcat_0/In13] [get_bd_pins xlslice_8/Dout]
  connect_bd_net -net xlslice_9_Dout [get_bd_pins xlconcat_0/In9] [get_bd_pins xlslice_9/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_1
proc create_hier_cell_hier_1_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_hier_1_1() - Empty argument(s)!"}
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

  # Create pins
  create_bd_pin -dir I -from 31 -to 0 Din
  create_bd_pin -dir O -from 31 -to 0 dout_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {32} \
 ] $xlconcat_0

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_1

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_2

  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_3

  # Create instance: xlslice_4, and set properties
  set xlslice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_4 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {4} \
   CONFIG.DIN_TO {4} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_4

  # Create instance: xlslice_5, and set properties
  set xlslice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_5 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {5} \
   CONFIG.DIN_TO {5} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_5

  # Create instance: xlslice_6, and set properties
  set xlslice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_6 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {6} \
   CONFIG.DIN_TO {6} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_6

  # Create instance: xlslice_7, and set properties
  set xlslice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_7 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {7} \
   CONFIG.DIN_TO {7} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_7

  # Create instance: xlslice_8, and set properties
  set xlslice_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_8 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {8} \
   CONFIG.DIN_TO {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_8

  # Create instance: xlslice_9, and set properties
  set xlslice_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_9 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {9} \
   CONFIG.DIN_TO {9} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_9

  # Create instance: xlslice_10, and set properties
  set xlslice_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_10 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {10} \
   CONFIG.DIN_TO {10} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_10

  # Create instance: xlslice_11, and set properties
  set xlslice_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_11 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {11} \
   CONFIG.DIN_TO {11} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_11

  # Create instance: xlslice_12, and set properties
  set xlslice_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_12 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {12} \
   CONFIG.DIN_TO {12} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_12

  # Create instance: xlslice_13, and set properties
  set xlslice_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_13 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {13} \
   CONFIG.DIN_TO {13} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_13

  # Create instance: xlslice_14, and set properties
  set xlslice_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_14 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {14} \
   CONFIG.DIN_TO {14} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_14

  # Create instance: xlslice_15, and set properties
  set xlslice_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_15 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {15} \
   CONFIG.DIN_TO {15} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_15

  # Create instance: xlslice_16, and set properties
  set xlslice_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_16 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {16} \
   CONFIG.DIN_TO {16} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_16

  # Create instance: xlslice_17, and set properties
  set xlslice_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_17 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {17} \
   CONFIG.DIN_TO {17} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_17

  # Create instance: xlslice_18, and set properties
  set xlslice_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_18 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {18} \
   CONFIG.DIN_TO {18} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_18

  # Create instance: xlslice_19, and set properties
  set xlslice_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_19 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {19} \
   CONFIG.DIN_TO {19} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_19

  # Create instance: xlslice_20, and set properties
  set xlslice_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_20 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {20} \
   CONFIG.DIN_TO {20} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_20

  # Create instance: xlslice_21, and set properties
  set xlslice_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_21 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {21} \
   CONFIG.DIN_TO {21} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_21

  # Create instance: xlslice_22, and set properties
  set xlslice_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_22 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {22} \
   CONFIG.DIN_TO {22} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_22

  # Create instance: xlslice_23, and set properties
  set xlslice_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_23 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {23} \
   CONFIG.DIN_TO {23} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_23

  # Create instance: xlslice_24, and set properties
  set xlslice_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_24 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {24} \
   CONFIG.DIN_TO {24} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_24

  # Create instance: xlslice_25, and set properties
  set xlslice_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_25 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {25} \
   CONFIG.DIN_TO {25} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_25

  # Create instance: xlslice_26, and set properties
  set xlslice_26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_26 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {26} \
   CONFIG.DIN_TO {26} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_26

  # Create instance: xlslice_27, and set properties
  set xlslice_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_27 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {27} \
   CONFIG.DIN_TO {27} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_27

  # Create instance: xlslice_28, and set properties
  set xlslice_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_28 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {28} \
   CONFIG.DIN_TO {28} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_28

  # Create instance: xlslice_29, and set properties
  set xlslice_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_29 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {29} \
   CONFIG.DIN_TO {29} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_29

  # Create instance: xlslice_30, and set properties
  set xlslice_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_30 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {30} \
   CONFIG.DIN_TO {30} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_30

  # Create instance: xlslice_31, and set properties
  set xlslice_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_31 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {31} \
   CONFIG.DIN_TO {31} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_31

  # Create port connections
  connect_bd_net -net xlconcat_0_dout [get_bd_pins Din] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din] [get_bd_pins xlslice_10/Din] [get_bd_pins xlslice_11/Din] [get_bd_pins xlslice_12/Din] [get_bd_pins xlslice_13/Din] [get_bd_pins xlslice_14/Din] [get_bd_pins xlslice_15/Din] [get_bd_pins xlslice_16/Din] [get_bd_pins xlslice_17/Din] [get_bd_pins xlslice_18/Din] [get_bd_pins xlslice_19/Din] [get_bd_pins xlslice_2/Din] [get_bd_pins xlslice_20/Din] [get_bd_pins xlslice_21/Din] [get_bd_pins xlslice_22/Din] [get_bd_pins xlslice_23/Din] [get_bd_pins xlslice_24/Din] [get_bd_pins xlslice_25/Din] [get_bd_pins xlslice_26/Din] [get_bd_pins xlslice_27/Din] [get_bd_pins xlslice_28/Din] [get_bd_pins xlslice_29/Din] [get_bd_pins xlslice_3/Din] [get_bd_pins xlslice_30/Din] [get_bd_pins xlslice_31/Din] [get_bd_pins xlslice_4/Din] [get_bd_pins xlslice_5/Din] [get_bd_pins xlslice_6/Din] [get_bd_pins xlslice_7/Din] [get_bd_pins xlslice_8/Din] [get_bd_pins xlslice_9/Din]
  connect_bd_net -net xlconcat_0_dout1 [get_bd_pins dout_0] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins xlconcat_0/In12] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_10_Dout [get_bd_pins xlconcat_0/In5] [get_bd_pins xlslice_10/Dout]
  connect_bd_net -net xlslice_11_Dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlslice_11/Dout]
  connect_bd_net -net xlslice_12_Dout [get_bd_pins xlconcat_0/In29] [get_bd_pins xlslice_12/Dout]
  connect_bd_net -net xlslice_13_Dout [get_bd_pins xlconcat_0/In25] [get_bd_pins xlslice_13/Dout]
  connect_bd_net -net xlslice_14_Dout [get_bd_pins xlconcat_0/In21] [get_bd_pins xlslice_14/Dout]
  connect_bd_net -net xlslice_15_Dout [get_bd_pins xlconcat_0/In17] [get_bd_pins xlslice_15/Dout]
  connect_bd_net -net xlslice_16_Dout [get_bd_pins xlconcat_0/In14] [get_bd_pins xlslice_16/Dout]
  connect_bd_net -net xlslice_17_Dout [get_bd_pins xlconcat_0/In10] [get_bd_pins xlslice_17/Dout]
  connect_bd_net -net xlslice_18_Dout [get_bd_pins xlconcat_0/In6] [get_bd_pins xlslice_18/Dout]
  connect_bd_net -net xlslice_19_Dout [get_bd_pins xlconcat_0/In2] [get_bd_pins xlslice_19/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins xlconcat_0/In8] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net xlslice_20_Dout [get_bd_pins xlconcat_0/In30] [get_bd_pins xlslice_20/Dout]
  connect_bd_net -net xlslice_21_Dout [get_bd_pins xlconcat_0/In26] [get_bd_pins xlslice_21/Dout]
  connect_bd_net -net xlslice_22_Dout [get_bd_pins xlconcat_0/In22] [get_bd_pins xlslice_22/Dout]
  connect_bd_net -net xlslice_23_Dout [get_bd_pins xlconcat_0/In18] [get_bd_pins xlslice_23/Dout]
  connect_bd_net -net xlslice_24_Dout [get_bd_pins xlconcat_0/In15] [get_bd_pins xlslice_24/Dout]
  connect_bd_net -net xlslice_25_Dout [get_bd_pins xlconcat_0/In11] [get_bd_pins xlslice_25/Dout]
  connect_bd_net -net xlslice_26_Dout [get_bd_pins xlconcat_0/In7] [get_bd_pins xlslice_26/Dout]
  connect_bd_net -net xlslice_27_Dout [get_bd_pins xlconcat_0/In3] [get_bd_pins xlslice_27/Dout]
  connect_bd_net -net xlslice_28_Dout [get_bd_pins xlconcat_0/In31] [get_bd_pins xlslice_28/Dout]
  connect_bd_net -net xlslice_29_Dout [get_bd_pins xlconcat_0/In27] [get_bd_pins xlslice_29/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins xlconcat_0/In4] [get_bd_pins xlslice_2/Dout]
  connect_bd_net -net xlslice_30_Dout [get_bd_pins xlconcat_0/In23] [get_bd_pins xlslice_30/Dout]
  connect_bd_net -net xlslice_31_Dout [get_bd_pins xlconcat_0/In19] [get_bd_pins xlslice_31/Dout]
  connect_bd_net -net xlslice_3_Dout [get_bd_pins xlconcat_0/In0] [get_bd_pins xlslice_3/Dout]
  connect_bd_net -net xlslice_4_Dout [get_bd_pins xlconcat_0/In28] [get_bd_pins xlslice_4/Dout]
  connect_bd_net -net xlslice_5_Dout [get_bd_pins xlconcat_0/In24] [get_bd_pins xlslice_5/Dout]
  connect_bd_net -net xlslice_6_Dout [get_bd_pins xlconcat_0/In20] [get_bd_pins xlslice_6/Dout]
  connect_bd_net -net xlslice_7_Dout [get_bd_pins xlconcat_0/In16] [get_bd_pins xlslice_7/Dout]
  connect_bd_net -net xlslice_8_Dout [get_bd_pins xlconcat_0/In13] [get_bd_pins xlslice_8/Dout]
  connect_bd_net -net xlslice_9_Dout [get_bd_pins xlconcat_0/In9] [get_bd_pins xlslice_9/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_2
proc create_hier_cell_hier_2_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_hier_2_1() - Empty argument(s)!"}
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

  # Create pins
  create_bd_pin -dir I -from 31 -to 0 Din
  create_bd_pin -dir O -from 31 -to 0 dout_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {32} \
 ] $xlconcat_0

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_1

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_2

  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_3

  # Create instance: xlslice_4, and set properties
  set xlslice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_4 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {4} \
   CONFIG.DIN_TO {4} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_4

  # Create instance: xlslice_5, and set properties
  set xlslice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_5 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {5} \
   CONFIG.DIN_TO {5} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_5

  # Create instance: xlslice_6, and set properties
  set xlslice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_6 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {6} \
   CONFIG.DIN_TO {6} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_6

  # Create instance: xlslice_7, and set properties
  set xlslice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_7 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {7} \
   CONFIG.DIN_TO {7} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_7

  # Create instance: xlslice_8, and set properties
  set xlslice_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_8 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {8} \
   CONFIG.DIN_TO {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_8

  # Create instance: xlslice_9, and set properties
  set xlslice_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_9 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {9} \
   CONFIG.DIN_TO {9} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_9

  # Create instance: xlslice_10, and set properties
  set xlslice_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_10 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {10} \
   CONFIG.DIN_TO {10} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_10

  # Create instance: xlslice_11, and set properties
  set xlslice_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_11 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {11} \
   CONFIG.DIN_TO {11} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_11

  # Create instance: xlslice_12, and set properties
  set xlslice_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_12 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {12} \
   CONFIG.DIN_TO {12} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_12

  # Create instance: xlslice_13, and set properties
  set xlslice_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_13 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {13} \
   CONFIG.DIN_TO {13} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_13

  # Create instance: xlslice_14, and set properties
  set xlslice_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_14 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {14} \
   CONFIG.DIN_TO {14} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_14

  # Create instance: xlslice_15, and set properties
  set xlslice_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_15 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {15} \
   CONFIG.DIN_TO {15} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_15

  # Create instance: xlslice_16, and set properties
  set xlslice_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_16 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {16} \
   CONFIG.DIN_TO {16} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_16

  # Create instance: xlslice_17, and set properties
  set xlslice_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_17 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {17} \
   CONFIG.DIN_TO {17} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_17

  # Create instance: xlslice_18, and set properties
  set xlslice_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_18 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {18} \
   CONFIG.DIN_TO {18} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_18

  # Create instance: xlslice_19, and set properties
  set xlslice_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_19 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {19} \
   CONFIG.DIN_TO {19} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_19

  # Create instance: xlslice_20, and set properties
  set xlslice_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_20 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {20} \
   CONFIG.DIN_TO {20} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_20

  # Create instance: xlslice_21, and set properties
  set xlslice_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_21 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {21} \
   CONFIG.DIN_TO {21} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_21

  # Create instance: xlslice_22, and set properties
  set xlslice_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_22 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {22} \
   CONFIG.DIN_TO {22} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_22

  # Create instance: xlslice_23, and set properties
  set xlslice_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_23 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {23} \
   CONFIG.DIN_TO {23} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_23

  # Create instance: xlslice_24, and set properties
  set xlslice_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_24 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {24} \
   CONFIG.DIN_TO {24} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_24

  # Create instance: xlslice_25, and set properties
  set xlslice_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_25 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {25} \
   CONFIG.DIN_TO {25} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_25

  # Create instance: xlslice_26, and set properties
  set xlslice_26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_26 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {26} \
   CONFIG.DIN_TO {26} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_26

  # Create instance: xlslice_27, and set properties
  set xlslice_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_27 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {27} \
   CONFIG.DIN_TO {27} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_27

  # Create instance: xlslice_28, and set properties
  set xlslice_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_28 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {28} \
   CONFIG.DIN_TO {28} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_28

  # Create instance: xlslice_29, and set properties
  set xlslice_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_29 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {29} \
   CONFIG.DIN_TO {29} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_29

  # Create instance: xlslice_30, and set properties
  set xlslice_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_30 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {30} \
   CONFIG.DIN_TO {30} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_30

  # Create instance: xlslice_31, and set properties
  set xlslice_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_31 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {31} \
   CONFIG.DIN_TO {31} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_31

  # Create port connections
  connect_bd_net -net xlconcat_0_dout [get_bd_pins Din] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din] [get_bd_pins xlslice_10/Din] [get_bd_pins xlslice_11/Din] [get_bd_pins xlslice_12/Din] [get_bd_pins xlslice_13/Din] [get_bd_pins xlslice_14/Din] [get_bd_pins xlslice_15/Din] [get_bd_pins xlslice_16/Din] [get_bd_pins xlslice_17/Din] [get_bd_pins xlslice_18/Din] [get_bd_pins xlslice_19/Din] [get_bd_pins xlslice_2/Din] [get_bd_pins xlslice_20/Din] [get_bd_pins xlslice_21/Din] [get_bd_pins xlslice_22/Din] [get_bd_pins xlslice_23/Din] [get_bd_pins xlslice_24/Din] [get_bd_pins xlslice_25/Din] [get_bd_pins xlslice_26/Din] [get_bd_pins xlslice_27/Din] [get_bd_pins xlslice_28/Din] [get_bd_pins xlslice_29/Din] [get_bd_pins xlslice_3/Din] [get_bd_pins xlslice_30/Din] [get_bd_pins xlslice_31/Din] [get_bd_pins xlslice_4/Din] [get_bd_pins xlslice_5/Din] [get_bd_pins xlslice_6/Din] [get_bd_pins xlslice_7/Din] [get_bd_pins xlslice_8/Din] [get_bd_pins xlslice_9/Din]
  connect_bd_net -net xlconcat_0_dout1 [get_bd_pins dout_0] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins xlconcat_0/In12] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_10_Dout [get_bd_pins xlconcat_0/In5] [get_bd_pins xlslice_10/Dout]
  connect_bd_net -net xlslice_11_Dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlslice_11/Dout]
  connect_bd_net -net xlslice_12_Dout [get_bd_pins xlconcat_0/In29] [get_bd_pins xlslice_12/Dout]
  connect_bd_net -net xlslice_13_Dout [get_bd_pins xlconcat_0/In25] [get_bd_pins xlslice_13/Dout]
  connect_bd_net -net xlslice_14_Dout [get_bd_pins xlconcat_0/In21] [get_bd_pins xlslice_14/Dout]
  connect_bd_net -net xlslice_15_Dout [get_bd_pins xlconcat_0/In17] [get_bd_pins xlslice_15/Dout]
  connect_bd_net -net xlslice_16_Dout [get_bd_pins xlconcat_0/In14] [get_bd_pins xlslice_16/Dout]
  connect_bd_net -net xlslice_17_Dout [get_bd_pins xlconcat_0/In10] [get_bd_pins xlslice_17/Dout]
  connect_bd_net -net xlslice_18_Dout [get_bd_pins xlconcat_0/In6] [get_bd_pins xlslice_18/Dout]
  connect_bd_net -net xlslice_19_Dout [get_bd_pins xlconcat_0/In2] [get_bd_pins xlslice_19/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins xlconcat_0/In8] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net xlslice_20_Dout [get_bd_pins xlconcat_0/In30] [get_bd_pins xlslice_20/Dout]
  connect_bd_net -net xlslice_21_Dout [get_bd_pins xlconcat_0/In26] [get_bd_pins xlslice_21/Dout]
  connect_bd_net -net xlslice_22_Dout [get_bd_pins xlconcat_0/In22] [get_bd_pins xlslice_22/Dout]
  connect_bd_net -net xlslice_23_Dout [get_bd_pins xlconcat_0/In18] [get_bd_pins xlslice_23/Dout]
  connect_bd_net -net xlslice_24_Dout [get_bd_pins xlconcat_0/In15] [get_bd_pins xlslice_24/Dout]
  connect_bd_net -net xlslice_25_Dout [get_bd_pins xlconcat_0/In11] [get_bd_pins xlslice_25/Dout]
  connect_bd_net -net xlslice_26_Dout [get_bd_pins xlconcat_0/In7] [get_bd_pins xlslice_26/Dout]
  connect_bd_net -net xlslice_27_Dout [get_bd_pins xlconcat_0/In3] [get_bd_pins xlslice_27/Dout]
  connect_bd_net -net xlslice_28_Dout [get_bd_pins xlconcat_0/In31] [get_bd_pins xlslice_28/Dout]
  connect_bd_net -net xlslice_29_Dout [get_bd_pins xlconcat_0/In27] [get_bd_pins xlslice_29/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins xlconcat_0/In4] [get_bd_pins xlslice_2/Dout]
  connect_bd_net -net xlslice_30_Dout [get_bd_pins xlconcat_0/In23] [get_bd_pins xlslice_30/Dout]
  connect_bd_net -net xlslice_31_Dout [get_bd_pins xlconcat_0/In19] [get_bd_pins xlslice_31/Dout]
  connect_bd_net -net xlslice_3_Dout [get_bd_pins xlconcat_0/In0] [get_bd_pins xlslice_3/Dout]
  connect_bd_net -net xlslice_4_Dout [get_bd_pins xlconcat_0/In28] [get_bd_pins xlslice_4/Dout]
  connect_bd_net -net xlslice_5_Dout [get_bd_pins xlconcat_0/In24] [get_bd_pins xlslice_5/Dout]
  connect_bd_net -net xlslice_6_Dout [get_bd_pins xlconcat_0/In20] [get_bd_pins xlslice_6/Dout]
  connect_bd_net -net xlslice_7_Dout [get_bd_pins xlconcat_0/In16] [get_bd_pins xlslice_7/Dout]
  connect_bd_net -net xlslice_8_Dout [get_bd_pins xlconcat_0/In13] [get_bd_pins xlslice_8/Dout]
  connect_bd_net -net xlslice_9_Dout [get_bd_pins xlconcat_0/In9] [get_bd_pins xlslice_9/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_3
proc create_hier_cell_hier_3_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_hier_3_1() - Empty argument(s)!"}
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

  # Create pins
  create_bd_pin -dir I -from 31 -to 0 Din
  create_bd_pin -dir O -from 31 -to 0 dout_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {32} \
 ] $xlconcat_0

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_1

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_2

  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_3

  # Create instance: xlslice_4, and set properties
  set xlslice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_4 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {4} \
   CONFIG.DIN_TO {4} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_4

  # Create instance: xlslice_5, and set properties
  set xlslice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_5 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {5} \
   CONFIG.DIN_TO {5} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_5

  # Create instance: xlslice_6, and set properties
  set xlslice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_6 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {6} \
   CONFIG.DIN_TO {6} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_6

  # Create instance: xlslice_7, and set properties
  set xlslice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_7 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {7} \
   CONFIG.DIN_TO {7} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_7

  # Create instance: xlslice_8, and set properties
  set xlslice_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_8 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {8} \
   CONFIG.DIN_TO {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_8

  # Create instance: xlslice_9, and set properties
  set xlslice_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_9 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {9} \
   CONFIG.DIN_TO {9} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_9

  # Create instance: xlslice_10, and set properties
  set xlslice_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_10 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {10} \
   CONFIG.DIN_TO {10} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_10

  # Create instance: xlslice_11, and set properties
  set xlslice_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_11 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {11} \
   CONFIG.DIN_TO {11} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_11

  # Create instance: xlslice_12, and set properties
  set xlslice_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_12 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {12} \
   CONFIG.DIN_TO {12} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_12

  # Create instance: xlslice_13, and set properties
  set xlslice_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_13 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {13} \
   CONFIG.DIN_TO {13} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_13

  # Create instance: xlslice_14, and set properties
  set xlslice_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_14 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {14} \
   CONFIG.DIN_TO {14} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_14

  # Create instance: xlslice_15, and set properties
  set xlslice_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_15 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {15} \
   CONFIG.DIN_TO {15} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_15

  # Create instance: xlslice_16, and set properties
  set xlslice_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_16 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {16} \
   CONFIG.DIN_TO {16} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_16

  # Create instance: xlslice_17, and set properties
  set xlslice_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_17 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {17} \
   CONFIG.DIN_TO {17} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_17

  # Create instance: xlslice_18, and set properties
  set xlslice_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_18 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {18} \
   CONFIG.DIN_TO {18} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_18

  # Create instance: xlslice_19, and set properties
  set xlslice_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_19 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {19} \
   CONFIG.DIN_TO {19} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_19

  # Create instance: xlslice_20, and set properties
  set xlslice_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_20 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {20} \
   CONFIG.DIN_TO {20} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_20

  # Create instance: xlslice_21, and set properties
  set xlslice_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_21 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {21} \
   CONFIG.DIN_TO {21} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_21

  # Create instance: xlslice_22, and set properties
  set xlslice_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_22 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {22} \
   CONFIG.DIN_TO {22} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_22

  # Create instance: xlslice_23, and set properties
  set xlslice_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_23 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {23} \
   CONFIG.DIN_TO {23} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_23

  # Create instance: xlslice_24, and set properties
  set xlslice_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_24 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {24} \
   CONFIG.DIN_TO {24} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_24

  # Create instance: xlslice_25, and set properties
  set xlslice_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_25 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {25} \
   CONFIG.DIN_TO {25} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_25

  # Create instance: xlslice_26, and set properties
  set xlslice_26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_26 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {26} \
   CONFIG.DIN_TO {26} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_26

  # Create instance: xlslice_27, and set properties
  set xlslice_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_27 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {27} \
   CONFIG.DIN_TO {27} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_27

  # Create instance: xlslice_28, and set properties
  set xlslice_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_28 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {28} \
   CONFIG.DIN_TO {28} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_28

  # Create instance: xlslice_29, and set properties
  set xlslice_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_29 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {29} \
   CONFIG.DIN_TO {29} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_29

  # Create instance: xlslice_30, and set properties
  set xlslice_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_30 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {30} \
   CONFIG.DIN_TO {30} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_30

  # Create instance: xlslice_31, and set properties
  set xlslice_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_31 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {31} \
   CONFIG.DIN_TO {31} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_31

  # Create port connections
  connect_bd_net -net xlconcat_0_dout [get_bd_pins Din] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din] [get_bd_pins xlslice_10/Din] [get_bd_pins xlslice_11/Din] [get_bd_pins xlslice_12/Din] [get_bd_pins xlslice_13/Din] [get_bd_pins xlslice_14/Din] [get_bd_pins xlslice_15/Din] [get_bd_pins xlslice_16/Din] [get_bd_pins xlslice_17/Din] [get_bd_pins xlslice_18/Din] [get_bd_pins xlslice_19/Din] [get_bd_pins xlslice_2/Din] [get_bd_pins xlslice_20/Din] [get_bd_pins xlslice_21/Din] [get_bd_pins xlslice_22/Din] [get_bd_pins xlslice_23/Din] [get_bd_pins xlslice_24/Din] [get_bd_pins xlslice_25/Din] [get_bd_pins xlslice_26/Din] [get_bd_pins xlslice_27/Din] [get_bd_pins xlslice_28/Din] [get_bd_pins xlslice_29/Din] [get_bd_pins xlslice_3/Din] [get_bd_pins xlslice_30/Din] [get_bd_pins xlslice_31/Din] [get_bd_pins xlslice_4/Din] [get_bd_pins xlslice_5/Din] [get_bd_pins xlslice_6/Din] [get_bd_pins xlslice_7/Din] [get_bd_pins xlslice_8/Din] [get_bd_pins xlslice_9/Din]
  connect_bd_net -net xlconcat_0_dout1 [get_bd_pins dout_0] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins xlconcat_0/In12] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_10_Dout [get_bd_pins xlconcat_0/In5] [get_bd_pins xlslice_10/Dout]
  connect_bd_net -net xlslice_11_Dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlslice_11/Dout]
  connect_bd_net -net xlslice_12_Dout [get_bd_pins xlconcat_0/In29] [get_bd_pins xlslice_12/Dout]
  connect_bd_net -net xlslice_13_Dout [get_bd_pins xlconcat_0/In25] [get_bd_pins xlslice_13/Dout]
  connect_bd_net -net xlslice_14_Dout [get_bd_pins xlconcat_0/In21] [get_bd_pins xlslice_14/Dout]
  connect_bd_net -net xlslice_15_Dout [get_bd_pins xlconcat_0/In17] [get_bd_pins xlslice_15/Dout]
  connect_bd_net -net xlslice_16_Dout [get_bd_pins xlconcat_0/In14] [get_bd_pins xlslice_16/Dout]
  connect_bd_net -net xlslice_17_Dout [get_bd_pins xlconcat_0/In10] [get_bd_pins xlslice_17/Dout]
  connect_bd_net -net xlslice_18_Dout [get_bd_pins xlconcat_0/In6] [get_bd_pins xlslice_18/Dout]
  connect_bd_net -net xlslice_19_Dout [get_bd_pins xlconcat_0/In2] [get_bd_pins xlslice_19/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins xlconcat_0/In8] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net xlslice_20_Dout [get_bd_pins xlconcat_0/In30] [get_bd_pins xlslice_20/Dout]
  connect_bd_net -net xlslice_21_Dout [get_bd_pins xlconcat_0/In26] [get_bd_pins xlslice_21/Dout]
  connect_bd_net -net xlslice_22_Dout [get_bd_pins xlconcat_0/In22] [get_bd_pins xlslice_22/Dout]
  connect_bd_net -net xlslice_23_Dout [get_bd_pins xlconcat_0/In18] [get_bd_pins xlslice_23/Dout]
  connect_bd_net -net xlslice_24_Dout [get_bd_pins xlconcat_0/In15] [get_bd_pins xlslice_24/Dout]
  connect_bd_net -net xlslice_25_Dout [get_bd_pins xlconcat_0/In11] [get_bd_pins xlslice_25/Dout]
  connect_bd_net -net xlslice_26_Dout [get_bd_pins xlconcat_0/In7] [get_bd_pins xlslice_26/Dout]
  connect_bd_net -net xlslice_27_Dout [get_bd_pins xlconcat_0/In3] [get_bd_pins xlslice_27/Dout]
  connect_bd_net -net xlslice_28_Dout [get_bd_pins xlconcat_0/In31] [get_bd_pins xlslice_28/Dout]
  connect_bd_net -net xlslice_29_Dout [get_bd_pins xlconcat_0/In27] [get_bd_pins xlslice_29/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins xlconcat_0/In4] [get_bd_pins xlslice_2/Dout]
  connect_bd_net -net xlslice_30_Dout [get_bd_pins xlconcat_0/In23] [get_bd_pins xlslice_30/Dout]
  connect_bd_net -net xlslice_31_Dout [get_bd_pins xlconcat_0/In19] [get_bd_pins xlslice_31/Dout]
  connect_bd_net -net xlslice_3_Dout [get_bd_pins xlconcat_0/In0] [get_bd_pins xlslice_3/Dout]
  connect_bd_net -net xlslice_4_Dout [get_bd_pins xlconcat_0/In28] [get_bd_pins xlslice_4/Dout]
  connect_bd_net -net xlslice_5_Dout [get_bd_pins xlconcat_0/In24] [get_bd_pins xlslice_5/Dout]
  connect_bd_net -net xlslice_6_Dout [get_bd_pins xlconcat_0/In20] [get_bd_pins xlslice_6/Dout]
  connect_bd_net -net xlslice_7_Dout [get_bd_pins xlconcat_0/In16] [get_bd_pins xlslice_7/Dout]
  connect_bd_net -net xlslice_8_Dout [get_bd_pins xlconcat_0/In13] [get_bd_pins xlslice_8/Dout]
  connect_bd_net -net xlslice_9_Dout [get_bd_pins xlconcat_0/In9] [get_bd_pins xlslice_9/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_0
proc create_hier_cell_hier_0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_hier_0() - Empty argument(s)!"}
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

  # Create pins
  create_bd_pin -dir I -from 31 -to 0 Din
  create_bd_pin -dir O -from 31 -to 0 dout_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {32} \
 ] $xlconcat_0

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_1

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_2

  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_3

  # Create instance: xlslice_4, and set properties
  set xlslice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_4 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {4} \
   CONFIG.DIN_TO {4} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_4

  # Create instance: xlslice_5, and set properties
  set xlslice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_5 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {5} \
   CONFIG.DIN_TO {5} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_5

  # Create instance: xlslice_6, and set properties
  set xlslice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_6 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {6} \
   CONFIG.DIN_TO {6} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_6

  # Create instance: xlslice_7, and set properties
  set xlslice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_7 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {7} \
   CONFIG.DIN_TO {7} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_7

  # Create instance: xlslice_8, and set properties
  set xlslice_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_8 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {8} \
   CONFIG.DIN_TO {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_8

  # Create instance: xlslice_9, and set properties
  set xlslice_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_9 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {9} \
   CONFIG.DIN_TO {9} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_9

  # Create instance: xlslice_10, and set properties
  set xlslice_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_10 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {10} \
   CONFIG.DIN_TO {10} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_10

  # Create instance: xlslice_11, and set properties
  set xlslice_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_11 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {11} \
   CONFIG.DIN_TO {11} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_11

  # Create instance: xlslice_12, and set properties
  set xlslice_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_12 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {12} \
   CONFIG.DIN_TO {12} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_12

  # Create instance: xlslice_13, and set properties
  set xlslice_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_13 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {13} \
   CONFIG.DIN_TO {13} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_13

  # Create instance: xlslice_14, and set properties
  set xlslice_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_14 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {14} \
   CONFIG.DIN_TO {14} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_14

  # Create instance: xlslice_15, and set properties
  set xlslice_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_15 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {15} \
   CONFIG.DIN_TO {15} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_15

  # Create instance: xlslice_16, and set properties
  set xlslice_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_16 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {16} \
   CONFIG.DIN_TO {16} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_16

  # Create instance: xlslice_17, and set properties
  set xlslice_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_17 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {17} \
   CONFIG.DIN_TO {17} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_17

  # Create instance: xlslice_18, and set properties
  set xlslice_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_18 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {18} \
   CONFIG.DIN_TO {18} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_18

  # Create instance: xlslice_19, and set properties
  set xlslice_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_19 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {19} \
   CONFIG.DIN_TO {19} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_19

  # Create instance: xlslice_20, and set properties
  set xlslice_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_20 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {20} \
   CONFIG.DIN_TO {20} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_20

  # Create instance: xlslice_21, and set properties
  set xlslice_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_21 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {21} \
   CONFIG.DIN_TO {21} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_21

  # Create instance: xlslice_22, and set properties
  set xlslice_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_22 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {22} \
   CONFIG.DIN_TO {22} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_22

  # Create instance: xlslice_23, and set properties
  set xlslice_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_23 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {23} \
   CONFIG.DIN_TO {23} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_23

  # Create instance: xlslice_24, and set properties
  set xlslice_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_24 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {24} \
   CONFIG.DIN_TO {24} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_24

  # Create instance: xlslice_25, and set properties
  set xlslice_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_25 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {25} \
   CONFIG.DIN_TO {25} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_25

  # Create instance: xlslice_26, and set properties
  set xlslice_26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_26 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {26} \
   CONFIG.DIN_TO {26} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_26

  # Create instance: xlslice_27, and set properties
  set xlslice_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_27 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {27} \
   CONFIG.DIN_TO {27} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_27

  # Create instance: xlslice_28, and set properties
  set xlslice_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_28 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {28} \
   CONFIG.DIN_TO {28} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_28

  # Create instance: xlslice_29, and set properties
  set xlslice_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_29 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {29} \
   CONFIG.DIN_TO {29} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_29

  # Create instance: xlslice_30, and set properties
  set xlslice_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_30 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {30} \
   CONFIG.DIN_TO {30} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_30

  # Create instance: xlslice_31, and set properties
  set xlslice_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_31 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {31} \
   CONFIG.DIN_TO {31} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_31

  # Create port connections
  connect_bd_net -net xlconcat_0_dout [get_bd_pins Din] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din] [get_bd_pins xlslice_10/Din] [get_bd_pins xlslice_11/Din] [get_bd_pins xlslice_12/Din] [get_bd_pins xlslice_13/Din] [get_bd_pins xlslice_14/Din] [get_bd_pins xlslice_15/Din] [get_bd_pins xlslice_16/Din] [get_bd_pins xlslice_17/Din] [get_bd_pins xlslice_18/Din] [get_bd_pins xlslice_19/Din] [get_bd_pins xlslice_2/Din] [get_bd_pins xlslice_20/Din] [get_bd_pins xlslice_21/Din] [get_bd_pins xlslice_22/Din] [get_bd_pins xlslice_23/Din] [get_bd_pins xlslice_24/Din] [get_bd_pins xlslice_25/Din] [get_bd_pins xlslice_26/Din] [get_bd_pins xlslice_27/Din] [get_bd_pins xlslice_28/Din] [get_bd_pins xlslice_29/Din] [get_bd_pins xlslice_3/Din] [get_bd_pins xlslice_30/Din] [get_bd_pins xlslice_31/Din] [get_bd_pins xlslice_4/Din] [get_bd_pins xlslice_5/Din] [get_bd_pins xlslice_6/Din] [get_bd_pins xlslice_7/Din] [get_bd_pins xlslice_8/Din] [get_bd_pins xlslice_9/Din]
  connect_bd_net -net xlconcat_0_dout1 [get_bd_pins dout_0] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins xlconcat_0/In12] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_10_Dout [get_bd_pins xlconcat_0/In5] [get_bd_pins xlslice_10/Dout]
  connect_bd_net -net xlslice_11_Dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlslice_11/Dout]
  connect_bd_net -net xlslice_12_Dout [get_bd_pins xlconcat_0/In29] [get_bd_pins xlslice_12/Dout]
  connect_bd_net -net xlslice_13_Dout [get_bd_pins xlconcat_0/In25] [get_bd_pins xlslice_13/Dout]
  connect_bd_net -net xlslice_14_Dout [get_bd_pins xlconcat_0/In21] [get_bd_pins xlslice_14/Dout]
  connect_bd_net -net xlslice_15_Dout [get_bd_pins xlconcat_0/In17] [get_bd_pins xlslice_15/Dout]
  connect_bd_net -net xlslice_16_Dout [get_bd_pins xlconcat_0/In14] [get_bd_pins xlslice_16/Dout]
  connect_bd_net -net xlslice_17_Dout [get_bd_pins xlconcat_0/In10] [get_bd_pins xlslice_17/Dout]
  connect_bd_net -net xlslice_18_Dout [get_bd_pins xlconcat_0/In6] [get_bd_pins xlslice_18/Dout]
  connect_bd_net -net xlslice_19_Dout [get_bd_pins xlconcat_0/In2] [get_bd_pins xlslice_19/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins xlconcat_0/In8] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net xlslice_20_Dout [get_bd_pins xlconcat_0/In30] [get_bd_pins xlslice_20/Dout]
  connect_bd_net -net xlslice_21_Dout [get_bd_pins xlconcat_0/In26] [get_bd_pins xlslice_21/Dout]
  connect_bd_net -net xlslice_22_Dout [get_bd_pins xlconcat_0/In22] [get_bd_pins xlslice_22/Dout]
  connect_bd_net -net xlslice_23_Dout [get_bd_pins xlconcat_0/In18] [get_bd_pins xlslice_23/Dout]
  connect_bd_net -net xlslice_24_Dout [get_bd_pins xlconcat_0/In15] [get_bd_pins xlslice_24/Dout]
  connect_bd_net -net xlslice_25_Dout [get_bd_pins xlconcat_0/In11] [get_bd_pins xlslice_25/Dout]
  connect_bd_net -net xlslice_26_Dout [get_bd_pins xlconcat_0/In7] [get_bd_pins xlslice_26/Dout]
  connect_bd_net -net xlslice_27_Dout [get_bd_pins xlconcat_0/In3] [get_bd_pins xlslice_27/Dout]
  connect_bd_net -net xlslice_28_Dout [get_bd_pins xlconcat_0/In31] [get_bd_pins xlslice_28/Dout]
  connect_bd_net -net xlslice_29_Dout [get_bd_pins xlconcat_0/In27] [get_bd_pins xlslice_29/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins xlconcat_0/In4] [get_bd_pins xlslice_2/Dout]
  connect_bd_net -net xlslice_30_Dout [get_bd_pins xlconcat_0/In23] [get_bd_pins xlslice_30/Dout]
  connect_bd_net -net xlslice_31_Dout [get_bd_pins xlconcat_0/In19] [get_bd_pins xlslice_31/Dout]
  connect_bd_net -net xlslice_3_Dout [get_bd_pins xlconcat_0/In0] [get_bd_pins xlslice_3/Dout]
  connect_bd_net -net xlslice_4_Dout [get_bd_pins xlconcat_0/In28] [get_bd_pins xlslice_4/Dout]
  connect_bd_net -net xlslice_5_Dout [get_bd_pins xlconcat_0/In24] [get_bd_pins xlslice_5/Dout]
  connect_bd_net -net xlslice_6_Dout [get_bd_pins xlconcat_0/In20] [get_bd_pins xlslice_6/Dout]
  connect_bd_net -net xlslice_7_Dout [get_bd_pins xlconcat_0/In16] [get_bd_pins xlslice_7/Dout]
  connect_bd_net -net xlslice_8_Dout [get_bd_pins xlconcat_0/In13] [get_bd_pins xlslice_8/Dout]
  connect_bd_net -net xlslice_9_Dout [get_bd_pins xlconcat_0/In9] [get_bd_pins xlslice_9/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_1
proc create_hier_cell_hier_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_hier_1() - Empty argument(s)!"}
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

  # Create pins
  create_bd_pin -dir I -from 31 -to 0 Din
  create_bd_pin -dir O -from 31 -to 0 dout_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {32} \
 ] $xlconcat_0

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_1

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_2

  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_3

  # Create instance: xlslice_4, and set properties
  set xlslice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_4 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {4} \
   CONFIG.DIN_TO {4} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_4

  # Create instance: xlslice_5, and set properties
  set xlslice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_5 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {5} \
   CONFIG.DIN_TO {5} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_5

  # Create instance: xlslice_6, and set properties
  set xlslice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_6 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {6} \
   CONFIG.DIN_TO {6} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_6

  # Create instance: xlslice_7, and set properties
  set xlslice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_7 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {7} \
   CONFIG.DIN_TO {7} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_7

  # Create instance: xlslice_8, and set properties
  set xlslice_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_8 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {8} \
   CONFIG.DIN_TO {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_8

  # Create instance: xlslice_9, and set properties
  set xlslice_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_9 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {9} \
   CONFIG.DIN_TO {9} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_9

  # Create instance: xlslice_10, and set properties
  set xlslice_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_10 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {10} \
   CONFIG.DIN_TO {10} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_10

  # Create instance: xlslice_11, and set properties
  set xlslice_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_11 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {11} \
   CONFIG.DIN_TO {11} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_11

  # Create instance: xlslice_12, and set properties
  set xlslice_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_12 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {12} \
   CONFIG.DIN_TO {12} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_12

  # Create instance: xlslice_13, and set properties
  set xlslice_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_13 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {13} \
   CONFIG.DIN_TO {13} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_13

  # Create instance: xlslice_14, and set properties
  set xlslice_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_14 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {14} \
   CONFIG.DIN_TO {14} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_14

  # Create instance: xlslice_15, and set properties
  set xlslice_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_15 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {15} \
   CONFIG.DIN_TO {15} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_15

  # Create instance: xlslice_16, and set properties
  set xlslice_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_16 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {16} \
   CONFIG.DIN_TO {16} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_16

  # Create instance: xlslice_17, and set properties
  set xlslice_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_17 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {17} \
   CONFIG.DIN_TO {17} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_17

  # Create instance: xlslice_18, and set properties
  set xlslice_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_18 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {18} \
   CONFIG.DIN_TO {18} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_18

  # Create instance: xlslice_19, and set properties
  set xlslice_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_19 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {19} \
   CONFIG.DIN_TO {19} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_19

  # Create instance: xlslice_20, and set properties
  set xlslice_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_20 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {20} \
   CONFIG.DIN_TO {20} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_20

  # Create instance: xlslice_21, and set properties
  set xlslice_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_21 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {21} \
   CONFIG.DIN_TO {21} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_21

  # Create instance: xlslice_22, and set properties
  set xlslice_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_22 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {22} \
   CONFIG.DIN_TO {22} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_22

  # Create instance: xlslice_23, and set properties
  set xlslice_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_23 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {23} \
   CONFIG.DIN_TO {23} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_23

  # Create instance: xlslice_24, and set properties
  set xlslice_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_24 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {24} \
   CONFIG.DIN_TO {24} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_24

  # Create instance: xlslice_25, and set properties
  set xlslice_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_25 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {25} \
   CONFIG.DIN_TO {25} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_25

  # Create instance: xlslice_26, and set properties
  set xlslice_26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_26 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {26} \
   CONFIG.DIN_TO {26} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_26

  # Create instance: xlslice_27, and set properties
  set xlslice_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_27 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {27} \
   CONFIG.DIN_TO {27} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_27

  # Create instance: xlslice_28, and set properties
  set xlslice_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_28 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {28} \
   CONFIG.DIN_TO {28} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_28

  # Create instance: xlslice_29, and set properties
  set xlslice_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_29 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {29} \
   CONFIG.DIN_TO {29} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_29

  # Create instance: xlslice_30, and set properties
  set xlslice_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_30 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {30} \
   CONFIG.DIN_TO {30} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_30

  # Create instance: xlslice_31, and set properties
  set xlslice_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_31 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {31} \
   CONFIG.DIN_TO {31} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_31

  # Create port connections
  connect_bd_net -net xlconcat_0_dout [get_bd_pins Din] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din] [get_bd_pins xlslice_10/Din] [get_bd_pins xlslice_11/Din] [get_bd_pins xlslice_12/Din] [get_bd_pins xlslice_13/Din] [get_bd_pins xlslice_14/Din] [get_bd_pins xlslice_15/Din] [get_bd_pins xlslice_16/Din] [get_bd_pins xlslice_17/Din] [get_bd_pins xlslice_18/Din] [get_bd_pins xlslice_19/Din] [get_bd_pins xlslice_2/Din] [get_bd_pins xlslice_20/Din] [get_bd_pins xlslice_21/Din] [get_bd_pins xlslice_22/Din] [get_bd_pins xlslice_23/Din] [get_bd_pins xlslice_24/Din] [get_bd_pins xlslice_25/Din] [get_bd_pins xlslice_26/Din] [get_bd_pins xlslice_27/Din] [get_bd_pins xlslice_28/Din] [get_bd_pins xlslice_29/Din] [get_bd_pins xlslice_3/Din] [get_bd_pins xlslice_30/Din] [get_bd_pins xlslice_31/Din] [get_bd_pins xlslice_4/Din] [get_bd_pins xlslice_5/Din] [get_bd_pins xlslice_6/Din] [get_bd_pins xlslice_7/Din] [get_bd_pins xlslice_8/Din] [get_bd_pins xlslice_9/Din]
  connect_bd_net -net xlconcat_0_dout1 [get_bd_pins dout_0] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins xlconcat_0/In12] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_10_Dout [get_bd_pins xlconcat_0/In5] [get_bd_pins xlslice_10/Dout]
  connect_bd_net -net xlslice_11_Dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlslice_11/Dout]
  connect_bd_net -net xlslice_12_Dout [get_bd_pins xlconcat_0/In29] [get_bd_pins xlslice_12/Dout]
  connect_bd_net -net xlslice_13_Dout [get_bd_pins xlconcat_0/In25] [get_bd_pins xlslice_13/Dout]
  connect_bd_net -net xlslice_14_Dout [get_bd_pins xlconcat_0/In21] [get_bd_pins xlslice_14/Dout]
  connect_bd_net -net xlslice_15_Dout [get_bd_pins xlconcat_0/In17] [get_bd_pins xlslice_15/Dout]
  connect_bd_net -net xlslice_16_Dout [get_bd_pins xlconcat_0/In14] [get_bd_pins xlslice_16/Dout]
  connect_bd_net -net xlslice_17_Dout [get_bd_pins xlconcat_0/In10] [get_bd_pins xlslice_17/Dout]
  connect_bd_net -net xlslice_18_Dout [get_bd_pins xlconcat_0/In6] [get_bd_pins xlslice_18/Dout]
  connect_bd_net -net xlslice_19_Dout [get_bd_pins xlconcat_0/In2] [get_bd_pins xlslice_19/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins xlconcat_0/In8] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net xlslice_20_Dout [get_bd_pins xlconcat_0/In30] [get_bd_pins xlslice_20/Dout]
  connect_bd_net -net xlslice_21_Dout [get_bd_pins xlconcat_0/In26] [get_bd_pins xlslice_21/Dout]
  connect_bd_net -net xlslice_22_Dout [get_bd_pins xlconcat_0/In22] [get_bd_pins xlslice_22/Dout]
  connect_bd_net -net xlslice_23_Dout [get_bd_pins xlconcat_0/In18] [get_bd_pins xlslice_23/Dout]
  connect_bd_net -net xlslice_24_Dout [get_bd_pins xlconcat_0/In15] [get_bd_pins xlslice_24/Dout]
  connect_bd_net -net xlslice_25_Dout [get_bd_pins xlconcat_0/In11] [get_bd_pins xlslice_25/Dout]
  connect_bd_net -net xlslice_26_Dout [get_bd_pins xlconcat_0/In7] [get_bd_pins xlslice_26/Dout]
  connect_bd_net -net xlslice_27_Dout [get_bd_pins xlconcat_0/In3] [get_bd_pins xlslice_27/Dout]
  connect_bd_net -net xlslice_28_Dout [get_bd_pins xlconcat_0/In31] [get_bd_pins xlslice_28/Dout]
  connect_bd_net -net xlslice_29_Dout [get_bd_pins xlconcat_0/In27] [get_bd_pins xlslice_29/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins xlconcat_0/In4] [get_bd_pins xlslice_2/Dout]
  connect_bd_net -net xlslice_30_Dout [get_bd_pins xlconcat_0/In23] [get_bd_pins xlslice_30/Dout]
  connect_bd_net -net xlslice_31_Dout [get_bd_pins xlconcat_0/In19] [get_bd_pins xlslice_31/Dout]
  connect_bd_net -net xlslice_3_Dout [get_bd_pins xlconcat_0/In0] [get_bd_pins xlslice_3/Dout]
  connect_bd_net -net xlslice_4_Dout [get_bd_pins xlconcat_0/In28] [get_bd_pins xlslice_4/Dout]
  connect_bd_net -net xlslice_5_Dout [get_bd_pins xlconcat_0/In24] [get_bd_pins xlslice_5/Dout]
  connect_bd_net -net xlslice_6_Dout [get_bd_pins xlconcat_0/In20] [get_bd_pins xlslice_6/Dout]
  connect_bd_net -net xlslice_7_Dout [get_bd_pins xlconcat_0/In16] [get_bd_pins xlslice_7/Dout]
  connect_bd_net -net xlslice_8_Dout [get_bd_pins xlconcat_0/In13] [get_bd_pins xlslice_8/Dout]
  connect_bd_net -net xlslice_9_Dout [get_bd_pins xlconcat_0/In9] [get_bd_pins xlslice_9/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_2
proc create_hier_cell_hier_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_hier_2() - Empty argument(s)!"}
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

  # Create pins
  create_bd_pin -dir I -from 31 -to 0 Din
  create_bd_pin -dir O -from 31 -to 0 dout_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {32} \
 ] $xlconcat_0

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_1

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_2

  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_3

  # Create instance: xlslice_4, and set properties
  set xlslice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_4 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {4} \
   CONFIG.DIN_TO {4} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_4

  # Create instance: xlslice_5, and set properties
  set xlslice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_5 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {5} \
   CONFIG.DIN_TO {5} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_5

  # Create instance: xlslice_6, and set properties
  set xlslice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_6 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {6} \
   CONFIG.DIN_TO {6} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_6

  # Create instance: xlslice_7, and set properties
  set xlslice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_7 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {7} \
   CONFIG.DIN_TO {7} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_7

  # Create instance: xlslice_8, and set properties
  set xlslice_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_8 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {8} \
   CONFIG.DIN_TO {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_8

  # Create instance: xlslice_9, and set properties
  set xlslice_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_9 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {9} \
   CONFIG.DIN_TO {9} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_9

  # Create instance: xlslice_10, and set properties
  set xlslice_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_10 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {10} \
   CONFIG.DIN_TO {10} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_10

  # Create instance: xlslice_11, and set properties
  set xlslice_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_11 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {11} \
   CONFIG.DIN_TO {11} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_11

  # Create instance: xlslice_12, and set properties
  set xlslice_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_12 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {12} \
   CONFIG.DIN_TO {12} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_12

  # Create instance: xlslice_13, and set properties
  set xlslice_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_13 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {13} \
   CONFIG.DIN_TO {13} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_13

  # Create instance: xlslice_14, and set properties
  set xlslice_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_14 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {14} \
   CONFIG.DIN_TO {14} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_14

  # Create instance: xlslice_15, and set properties
  set xlslice_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_15 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {15} \
   CONFIG.DIN_TO {15} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_15

  # Create instance: xlslice_16, and set properties
  set xlslice_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_16 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {16} \
   CONFIG.DIN_TO {16} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_16

  # Create instance: xlslice_17, and set properties
  set xlslice_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_17 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {17} \
   CONFIG.DIN_TO {17} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_17

  # Create instance: xlslice_18, and set properties
  set xlslice_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_18 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {18} \
   CONFIG.DIN_TO {18} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_18

  # Create instance: xlslice_19, and set properties
  set xlslice_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_19 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {19} \
   CONFIG.DIN_TO {19} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_19

  # Create instance: xlslice_20, and set properties
  set xlslice_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_20 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {20} \
   CONFIG.DIN_TO {20} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_20

  # Create instance: xlslice_21, and set properties
  set xlslice_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_21 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {21} \
   CONFIG.DIN_TO {21} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_21

  # Create instance: xlslice_22, and set properties
  set xlslice_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_22 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {22} \
   CONFIG.DIN_TO {22} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_22

  # Create instance: xlslice_23, and set properties
  set xlslice_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_23 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {23} \
   CONFIG.DIN_TO {23} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_23

  # Create instance: xlslice_24, and set properties
  set xlslice_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_24 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {24} \
   CONFIG.DIN_TO {24} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_24

  # Create instance: xlslice_25, and set properties
  set xlslice_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_25 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {25} \
   CONFIG.DIN_TO {25} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_25

  # Create instance: xlslice_26, and set properties
  set xlslice_26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_26 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {26} \
   CONFIG.DIN_TO {26} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_26

  # Create instance: xlslice_27, and set properties
  set xlslice_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_27 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {27} \
   CONFIG.DIN_TO {27} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_27

  # Create instance: xlslice_28, and set properties
  set xlslice_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_28 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {28} \
   CONFIG.DIN_TO {28} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_28

  # Create instance: xlslice_29, and set properties
  set xlslice_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_29 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {29} \
   CONFIG.DIN_TO {29} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_29

  # Create instance: xlslice_30, and set properties
  set xlslice_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_30 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {30} \
   CONFIG.DIN_TO {30} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_30

  # Create instance: xlslice_31, and set properties
  set xlslice_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_31 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {31} \
   CONFIG.DIN_TO {31} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_31

  # Create port connections
  connect_bd_net -net xlconcat_0_dout [get_bd_pins Din] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din] [get_bd_pins xlslice_10/Din] [get_bd_pins xlslice_11/Din] [get_bd_pins xlslice_12/Din] [get_bd_pins xlslice_13/Din] [get_bd_pins xlslice_14/Din] [get_bd_pins xlslice_15/Din] [get_bd_pins xlslice_16/Din] [get_bd_pins xlslice_17/Din] [get_bd_pins xlslice_18/Din] [get_bd_pins xlslice_19/Din] [get_bd_pins xlslice_2/Din] [get_bd_pins xlslice_20/Din] [get_bd_pins xlslice_21/Din] [get_bd_pins xlslice_22/Din] [get_bd_pins xlslice_23/Din] [get_bd_pins xlslice_24/Din] [get_bd_pins xlslice_25/Din] [get_bd_pins xlslice_26/Din] [get_bd_pins xlslice_27/Din] [get_bd_pins xlslice_28/Din] [get_bd_pins xlslice_29/Din] [get_bd_pins xlslice_3/Din] [get_bd_pins xlslice_30/Din] [get_bd_pins xlslice_31/Din] [get_bd_pins xlslice_4/Din] [get_bd_pins xlslice_5/Din] [get_bd_pins xlslice_6/Din] [get_bd_pins xlslice_7/Din] [get_bd_pins xlslice_8/Din] [get_bd_pins xlslice_9/Din]
  connect_bd_net -net xlconcat_0_dout1 [get_bd_pins dout_0] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins xlconcat_0/In12] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_10_Dout [get_bd_pins xlconcat_0/In5] [get_bd_pins xlslice_10/Dout]
  connect_bd_net -net xlslice_11_Dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlslice_11/Dout]
  connect_bd_net -net xlslice_12_Dout [get_bd_pins xlconcat_0/In29] [get_bd_pins xlslice_12/Dout]
  connect_bd_net -net xlslice_13_Dout [get_bd_pins xlconcat_0/In25] [get_bd_pins xlslice_13/Dout]
  connect_bd_net -net xlslice_14_Dout [get_bd_pins xlconcat_0/In21] [get_bd_pins xlslice_14/Dout]
  connect_bd_net -net xlslice_15_Dout [get_bd_pins xlconcat_0/In17] [get_bd_pins xlslice_15/Dout]
  connect_bd_net -net xlslice_16_Dout [get_bd_pins xlconcat_0/In14] [get_bd_pins xlslice_16/Dout]
  connect_bd_net -net xlslice_17_Dout [get_bd_pins xlconcat_0/In10] [get_bd_pins xlslice_17/Dout]
  connect_bd_net -net xlslice_18_Dout [get_bd_pins xlconcat_0/In6] [get_bd_pins xlslice_18/Dout]
  connect_bd_net -net xlslice_19_Dout [get_bd_pins xlconcat_0/In2] [get_bd_pins xlslice_19/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins xlconcat_0/In8] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net xlslice_20_Dout [get_bd_pins xlconcat_0/In30] [get_bd_pins xlslice_20/Dout]
  connect_bd_net -net xlslice_21_Dout [get_bd_pins xlconcat_0/In26] [get_bd_pins xlslice_21/Dout]
  connect_bd_net -net xlslice_22_Dout [get_bd_pins xlconcat_0/In22] [get_bd_pins xlslice_22/Dout]
  connect_bd_net -net xlslice_23_Dout [get_bd_pins xlconcat_0/In18] [get_bd_pins xlslice_23/Dout]
  connect_bd_net -net xlslice_24_Dout [get_bd_pins xlconcat_0/In15] [get_bd_pins xlslice_24/Dout]
  connect_bd_net -net xlslice_25_Dout [get_bd_pins xlconcat_0/In11] [get_bd_pins xlslice_25/Dout]
  connect_bd_net -net xlslice_26_Dout [get_bd_pins xlconcat_0/In7] [get_bd_pins xlslice_26/Dout]
  connect_bd_net -net xlslice_27_Dout [get_bd_pins xlconcat_0/In3] [get_bd_pins xlslice_27/Dout]
  connect_bd_net -net xlslice_28_Dout [get_bd_pins xlconcat_0/In31] [get_bd_pins xlslice_28/Dout]
  connect_bd_net -net xlslice_29_Dout [get_bd_pins xlconcat_0/In27] [get_bd_pins xlslice_29/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins xlconcat_0/In4] [get_bd_pins xlslice_2/Dout]
  connect_bd_net -net xlslice_30_Dout [get_bd_pins xlconcat_0/In23] [get_bd_pins xlslice_30/Dout]
  connect_bd_net -net xlslice_31_Dout [get_bd_pins xlconcat_0/In19] [get_bd_pins xlslice_31/Dout]
  connect_bd_net -net xlslice_3_Dout [get_bd_pins xlconcat_0/In0] [get_bd_pins xlslice_3/Dout]
  connect_bd_net -net xlslice_4_Dout [get_bd_pins xlconcat_0/In28] [get_bd_pins xlslice_4/Dout]
  connect_bd_net -net xlslice_5_Dout [get_bd_pins xlconcat_0/In24] [get_bd_pins xlslice_5/Dout]
  connect_bd_net -net xlslice_6_Dout [get_bd_pins xlconcat_0/In20] [get_bd_pins xlslice_6/Dout]
  connect_bd_net -net xlslice_7_Dout [get_bd_pins xlconcat_0/In16] [get_bd_pins xlslice_7/Dout]
  connect_bd_net -net xlslice_8_Dout [get_bd_pins xlconcat_0/In13] [get_bd_pins xlslice_8/Dout]
  connect_bd_net -net xlslice_9_Dout [get_bd_pins xlconcat_0/In9] [get_bd_pins xlslice_9/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_3
proc create_hier_cell_hier_3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_hier_3() - Empty argument(s)!"}
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

  # Create pins
  create_bd_pin -dir I -from 31 -to 0 Din
  create_bd_pin -dir O -from 31 -to 0 dout_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {32} \
 ] $xlconcat_0

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_1

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_2

  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_3

  # Create instance: xlslice_4, and set properties
  set xlslice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_4 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {4} \
   CONFIG.DIN_TO {4} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_4

  # Create instance: xlslice_5, and set properties
  set xlslice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_5 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {5} \
   CONFIG.DIN_TO {5} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_5

  # Create instance: xlslice_6, and set properties
  set xlslice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_6 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {6} \
   CONFIG.DIN_TO {6} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_6

  # Create instance: xlslice_7, and set properties
  set xlslice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_7 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {7} \
   CONFIG.DIN_TO {7} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_7

  # Create instance: xlslice_8, and set properties
  set xlslice_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_8 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {8} \
   CONFIG.DIN_TO {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_8

  # Create instance: xlslice_9, and set properties
  set xlslice_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_9 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {9} \
   CONFIG.DIN_TO {9} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_9

  # Create instance: xlslice_10, and set properties
  set xlslice_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_10 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {10} \
   CONFIG.DIN_TO {10} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_10

  # Create instance: xlslice_11, and set properties
  set xlslice_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_11 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {11} \
   CONFIG.DIN_TO {11} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_11

  # Create instance: xlslice_12, and set properties
  set xlslice_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_12 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {12} \
   CONFIG.DIN_TO {12} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_12

  # Create instance: xlslice_13, and set properties
  set xlslice_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_13 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {13} \
   CONFIG.DIN_TO {13} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_13

  # Create instance: xlslice_14, and set properties
  set xlslice_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_14 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {14} \
   CONFIG.DIN_TO {14} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_14

  # Create instance: xlslice_15, and set properties
  set xlslice_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_15 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {15} \
   CONFIG.DIN_TO {15} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_15

  # Create instance: xlslice_16, and set properties
  set xlslice_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_16 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {16} \
   CONFIG.DIN_TO {16} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_16

  # Create instance: xlslice_17, and set properties
  set xlslice_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_17 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {17} \
   CONFIG.DIN_TO {17} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_17

  # Create instance: xlslice_18, and set properties
  set xlslice_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_18 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {18} \
   CONFIG.DIN_TO {18} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_18

  # Create instance: xlslice_19, and set properties
  set xlslice_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_19 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {19} \
   CONFIG.DIN_TO {19} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_19

  # Create instance: xlslice_20, and set properties
  set xlslice_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_20 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {20} \
   CONFIG.DIN_TO {20} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_20

  # Create instance: xlslice_21, and set properties
  set xlslice_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_21 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {21} \
   CONFIG.DIN_TO {21} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_21

  # Create instance: xlslice_22, and set properties
  set xlslice_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_22 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {22} \
   CONFIG.DIN_TO {22} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_22

  # Create instance: xlslice_23, and set properties
  set xlslice_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_23 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {23} \
   CONFIG.DIN_TO {23} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_23

  # Create instance: xlslice_24, and set properties
  set xlslice_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_24 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {24} \
   CONFIG.DIN_TO {24} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_24

  # Create instance: xlslice_25, and set properties
  set xlslice_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_25 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {25} \
   CONFIG.DIN_TO {25} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_25

  # Create instance: xlslice_26, and set properties
  set xlslice_26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_26 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {26} \
   CONFIG.DIN_TO {26} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_26

  # Create instance: xlslice_27, and set properties
  set xlslice_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_27 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {27} \
   CONFIG.DIN_TO {27} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_27

  # Create instance: xlslice_28, and set properties
  set xlslice_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_28 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {28} \
   CONFIG.DIN_TO {28} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_28

  # Create instance: xlslice_29, and set properties
  set xlslice_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_29 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {29} \
   CONFIG.DIN_TO {29} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_29

  # Create instance: xlslice_30, and set properties
  set xlslice_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_30 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {30} \
   CONFIG.DIN_TO {30} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_30

  # Create instance: xlslice_31, and set properties
  set xlslice_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_31 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {31} \
   CONFIG.DIN_TO {31} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_31

  # Create port connections
  connect_bd_net -net xlconcat_0_dout [get_bd_pins Din] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din] [get_bd_pins xlslice_10/Din] [get_bd_pins xlslice_11/Din] [get_bd_pins xlslice_12/Din] [get_bd_pins xlslice_13/Din] [get_bd_pins xlslice_14/Din] [get_bd_pins xlslice_15/Din] [get_bd_pins xlslice_16/Din] [get_bd_pins xlslice_17/Din] [get_bd_pins xlslice_18/Din] [get_bd_pins xlslice_19/Din] [get_bd_pins xlslice_2/Din] [get_bd_pins xlslice_20/Din] [get_bd_pins xlslice_21/Din] [get_bd_pins xlslice_22/Din] [get_bd_pins xlslice_23/Din] [get_bd_pins xlslice_24/Din] [get_bd_pins xlslice_25/Din] [get_bd_pins xlslice_26/Din] [get_bd_pins xlslice_27/Din] [get_bd_pins xlslice_28/Din] [get_bd_pins xlslice_29/Din] [get_bd_pins xlslice_3/Din] [get_bd_pins xlslice_30/Din] [get_bd_pins xlslice_31/Din] [get_bd_pins xlslice_4/Din] [get_bd_pins xlslice_5/Din] [get_bd_pins xlslice_6/Din] [get_bd_pins xlslice_7/Din] [get_bd_pins xlslice_8/Din] [get_bd_pins xlslice_9/Din]
  connect_bd_net -net xlconcat_0_dout1 [get_bd_pins dout_0] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins xlconcat_0/In12] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_10_Dout [get_bd_pins xlconcat_0/In5] [get_bd_pins xlslice_10/Dout]
  connect_bd_net -net xlslice_11_Dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlslice_11/Dout]
  connect_bd_net -net xlslice_12_Dout [get_bd_pins xlconcat_0/In29] [get_bd_pins xlslice_12/Dout]
  connect_bd_net -net xlslice_13_Dout [get_bd_pins xlconcat_0/In25] [get_bd_pins xlslice_13/Dout]
  connect_bd_net -net xlslice_14_Dout [get_bd_pins xlconcat_0/In21] [get_bd_pins xlslice_14/Dout]
  connect_bd_net -net xlslice_15_Dout [get_bd_pins xlconcat_0/In17] [get_bd_pins xlslice_15/Dout]
  connect_bd_net -net xlslice_16_Dout [get_bd_pins xlconcat_0/In14] [get_bd_pins xlslice_16/Dout]
  connect_bd_net -net xlslice_17_Dout [get_bd_pins xlconcat_0/In10] [get_bd_pins xlslice_17/Dout]
  connect_bd_net -net xlslice_18_Dout [get_bd_pins xlconcat_0/In6] [get_bd_pins xlslice_18/Dout]
  connect_bd_net -net xlslice_19_Dout [get_bd_pins xlconcat_0/In2] [get_bd_pins xlslice_19/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins xlconcat_0/In8] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net xlslice_20_Dout [get_bd_pins xlconcat_0/In30] [get_bd_pins xlslice_20/Dout]
  connect_bd_net -net xlslice_21_Dout [get_bd_pins xlconcat_0/In26] [get_bd_pins xlslice_21/Dout]
  connect_bd_net -net xlslice_22_Dout [get_bd_pins xlconcat_0/In22] [get_bd_pins xlslice_22/Dout]
  connect_bd_net -net xlslice_23_Dout [get_bd_pins xlconcat_0/In18] [get_bd_pins xlslice_23/Dout]
  connect_bd_net -net xlslice_24_Dout [get_bd_pins xlconcat_0/In15] [get_bd_pins xlslice_24/Dout]
  connect_bd_net -net xlslice_25_Dout [get_bd_pins xlconcat_0/In11] [get_bd_pins xlslice_25/Dout]
  connect_bd_net -net xlslice_26_Dout [get_bd_pins xlconcat_0/In7] [get_bd_pins xlslice_26/Dout]
  connect_bd_net -net xlslice_27_Dout [get_bd_pins xlconcat_0/In3] [get_bd_pins xlslice_27/Dout]
  connect_bd_net -net xlslice_28_Dout [get_bd_pins xlconcat_0/In31] [get_bd_pins xlslice_28/Dout]
  connect_bd_net -net xlslice_29_Dout [get_bd_pins xlconcat_0/In27] [get_bd_pins xlslice_29/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins xlconcat_0/In4] [get_bd_pins xlslice_2/Dout]
  connect_bd_net -net xlslice_30_Dout [get_bd_pins xlconcat_0/In23] [get_bd_pins xlslice_30/Dout]
  connect_bd_net -net xlslice_31_Dout [get_bd_pins xlconcat_0/In19] [get_bd_pins xlslice_31/Dout]
  connect_bd_net -net xlslice_3_Dout [get_bd_pins xlconcat_0/In0] [get_bd_pins xlslice_3/Dout]
  connect_bd_net -net xlslice_4_Dout [get_bd_pins xlconcat_0/In28] [get_bd_pins xlslice_4/Dout]
  connect_bd_net -net xlslice_5_Dout [get_bd_pins xlconcat_0/In24] [get_bd_pins xlslice_5/Dout]
  connect_bd_net -net xlslice_6_Dout [get_bd_pins xlconcat_0/In20] [get_bd_pins xlslice_6/Dout]
  connect_bd_net -net xlslice_7_Dout [get_bd_pins xlconcat_0/In16] [get_bd_pins xlslice_7/Dout]
  connect_bd_net -net xlslice_8_Dout [get_bd_pins xlconcat_0/In13] [get_bd_pins xlslice_8/Dout]
  connect_bd_net -net xlslice_9_Dout [get_bd_pins xlconcat_0/In9] [get_bd_pins xlslice_9/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: lgain_adc_15
proc create_hier_cell_lgain_adc_15 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_lgain_adc_15() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC


  # Create pins
  create_bd_pin -dir I -from 7 -to 0 In0
  create_bd_pin -dir I -from 7 -to 0 In1
  create_bd_pin -dir I -from 7 -to 0 In2
  create_bd_pin -dir I -from 7 -to 0 In3
  create_bd_pin -dir I M_ACLK
  create_bd_pin -dir I M_ARESETN
  create_bd_pin -dir I S_ACLK
  create_bd_pin -dir I S_ARESETN
  create_bd_pin -dir O -from 31 -to 0 dout_0_3
  create_bd_pin -dir I empty_0
  create_bd_pin -dir I empty_1
  create_bd_pin -dir I empty_2
  create_bd_pin -dir I empty_3

  # Create instance: axis_clock_converter_0, and set properties
  set axis_clock_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_0 ]

  # Create instance: empty_concat, and set properties
  set empty_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 empty_concat ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $empty_concat

  # Create instance: empty_inverse, and set properties
  set empty_inverse [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 empty_inverse ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $empty_inverse

  # Create instance: fifo_generator_0, and set properties
  set fifo_generator_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_generator_0 ]
  set_property -dict [ list \
   CONFIG.Empty_Threshold_Assert_Value_rach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wrch {14} \
   CONFIG.FIFO_Implementation_axis {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_rach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wrch {Common_Clock_Distributed_RAM} \
   CONFIG.Full_Threshold_Assert_Value_rach {15} \
   CONFIG.Full_Threshold_Assert_Value_wach {15} \
   CONFIG.Full_Threshold_Assert_Value_wrch {15} \
   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
   CONFIG.Reset_Type {Asynchronous_Reset} \
   CONFIG.TDATA_NUM_BYTES {4} \
   CONFIG.TKEEP_WIDTH {4} \
   CONFIG.TSTRB_WIDTH {4} \
   CONFIG.TUSER_WIDTH {0} \
 ] $fifo_generator_0

  # Create instance: hier_3
  create_hier_cell_hier_3_3 $hier_obj hier_3

  # Create instance: util_reduced_logic_0, and set properties
  set util_reduced_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_reduced_logic_0

  # Create instance: xlconcat_3, and set properties
  set xlconcat_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_3 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $xlconcat_3

  # Create interface connections
  connect_bd_intf_net -intf_net axis_clock_converter_0_M_AXIS [get_bd_intf_pins M_AXIS_LGAIN_ADC] [get_bd_intf_pins axis_clock_converter_0/M_AXIS]
  connect_bd_intf_net -intf_net fifo_generator_0_M_AXIS [get_bd_intf_pins axis_clock_converter_0/S_AXIS] [get_bd_intf_pins fifo_generator_0/M_AXIS]

  # Create port connections
  connect_bd_net -net In0_1 [get_bd_pins In0] [get_bd_pins xlconcat_3/In0]
  connect_bd_net -net In1_1 [get_bd_pins In1] [get_bd_pins xlconcat_3/In1]
  connect_bd_net -net In2_1 [get_bd_pins In2] [get_bd_pins xlconcat_3/In2]
  connect_bd_net -net In3_1 [get_bd_pins In3] [get_bd_pins xlconcat_3/In3]
  connect_bd_net -net M_ACLK_1 [get_bd_pins M_ACLK] [get_bd_pins axis_clock_converter_0/m_axis_aclk]
  connect_bd_net -net M_ARESETN_1 [get_bd_pins M_ARESETN] [get_bd_pins axis_clock_converter_0/m_axis_aresetn]
  connect_bd_net -net S_ARESETN_1 [get_bd_pins S_ARESETN] [get_bd_pins axis_clock_converter_0/s_axis_aresetn] [get_bd_pins fifo_generator_0/s_aresetn]
  connect_bd_net -net S_AXIS_ACLK_1 [get_bd_pins S_ACLK] [get_bd_pins axis_clock_converter_0/s_axis_aclk] [get_bd_pins fifo_generator_0/s_aclk]
  connect_bd_net -net empty_0_1 [get_bd_pins empty_0] [get_bd_pins empty_concat/In0]
  connect_bd_net -net empty_1_1 [get_bd_pins empty_1] [get_bd_pins empty_concat/In1]
  connect_bd_net -net empty_2_1 [get_bd_pins empty_2] [get_bd_pins empty_concat/In2]
  connect_bd_net -net empty_3_1 [get_bd_pins empty_3] [get_bd_pins empty_concat/In3]
  connect_bd_net -net empty_inverse_Res [get_bd_pins empty_inverse/Res] [get_bd_pins util_reduced_logic_0/Op1]
  connect_bd_net -net hier_3_dout_0 [get_bd_pins dout_0_3] [get_bd_pins fifo_generator_0/s_axis_tdata] [get_bd_pins hier_3/dout_0]
  connect_bd_net -net util_reduced_logic_0_Res [get_bd_pins fifo_generator_0/s_axis_tvalid] [get_bd_pins util_reduced_logic_0/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins empty_concat/dout] [get_bd_pins empty_inverse/Op1]
  connect_bd_net -net xlconcat_3_dout [get_bd_pins hier_3/Din] [get_bd_pins xlconcat_3/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: lgain_adc_14
proc create_hier_cell_lgain_adc_14 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_lgain_adc_14() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC


  # Create pins
  create_bd_pin -dir I -from 7 -to 0 In0
  create_bd_pin -dir I -from 7 -to 0 In1
  create_bd_pin -dir I -from 7 -to 0 In2
  create_bd_pin -dir I -from 7 -to 0 In3
  create_bd_pin -dir I M_ACLK
  create_bd_pin -dir I M_ARESETN
  create_bd_pin -dir I S_ACLK
  create_bd_pin -dir I S_ARESETN
  create_bd_pin -dir O -from 31 -to 0 dout_0_1
  create_bd_pin -dir I empty_0
  create_bd_pin -dir I empty_1
  create_bd_pin -dir I empty_2
  create_bd_pin -dir I empty_3

  # Create instance: axis_clock_converter_0, and set properties
  set axis_clock_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_0 ]

  # Create instance: empty_concat, and set properties
  set empty_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 empty_concat ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $empty_concat

  # Create instance: empty_inverse, and set properties
  set empty_inverse [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 empty_inverse ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $empty_inverse

  # Create instance: fifo_generator_0, and set properties
  set fifo_generator_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_generator_0 ]
  set_property -dict [ list \
   CONFIG.Empty_Threshold_Assert_Value_rach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wrch {14} \
   CONFIG.FIFO_Implementation_axis {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_rach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wrch {Common_Clock_Distributed_RAM} \
   CONFIG.Full_Threshold_Assert_Value_rach {15} \
   CONFIG.Full_Threshold_Assert_Value_wach {15} \
   CONFIG.Full_Threshold_Assert_Value_wrch {15} \
   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
   CONFIG.Reset_Type {Asynchronous_Reset} \
   CONFIG.TDATA_NUM_BYTES {4} \
   CONFIG.TKEEP_WIDTH {4} \
   CONFIG.TSTRB_WIDTH {4} \
   CONFIG.TUSER_WIDTH {0} \
 ] $fifo_generator_0

  # Create instance: hier_1
  create_hier_cell_hier_1_3 $hier_obj hier_1

  # Create instance: util_reduced_logic_0, and set properties
  set util_reduced_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_reduced_logic_0

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $xlconcat_1

  # Create interface connections
  connect_bd_intf_net -intf_net axis_clock_converter_0_M_AXIS [get_bd_intf_pins M_AXIS_LGAIN_ADC] [get_bd_intf_pins axis_clock_converter_0/M_AXIS]
  connect_bd_intf_net -intf_net fifo_generator_0_M_AXIS [get_bd_intf_pins axis_clock_converter_0/S_AXIS] [get_bd_intf_pins fifo_generator_0/M_AXIS]

  # Create port connections
  connect_bd_net -net In0_1 [get_bd_pins In0] [get_bd_pins xlconcat_1/In0]
  connect_bd_net -net In1_1 [get_bd_pins In1] [get_bd_pins xlconcat_1/In1]
  connect_bd_net -net In2_1 [get_bd_pins In2] [get_bd_pins xlconcat_1/In2]
  connect_bd_net -net In3_1 [get_bd_pins In3] [get_bd_pins xlconcat_1/In3]
  connect_bd_net -net M_ACLK_1 [get_bd_pins M_ACLK] [get_bd_pins axis_clock_converter_0/m_axis_aclk]
  connect_bd_net -net M_ARESETN_1 [get_bd_pins M_ARESETN] [get_bd_pins axis_clock_converter_0/m_axis_aresetn]
  connect_bd_net -net S_ARESETN_1 [get_bd_pins S_ARESETN] [get_bd_pins axis_clock_converter_0/s_axis_aresetn] [get_bd_pins fifo_generator_0/s_aresetn]
  connect_bd_net -net S_AXIS_ACLK_1 [get_bd_pins S_ACLK] [get_bd_pins axis_clock_converter_0/s_axis_aclk] [get_bd_pins fifo_generator_0/s_aclk]
  connect_bd_net -net empty_0_1 [get_bd_pins empty_0] [get_bd_pins empty_concat/In0]
  connect_bd_net -net empty_1_1 [get_bd_pins empty_1] [get_bd_pins empty_concat/In1]
  connect_bd_net -net empty_2_1 [get_bd_pins empty_2] [get_bd_pins empty_concat/In2]
  connect_bd_net -net empty_3_1 [get_bd_pins empty_3] [get_bd_pins empty_concat/In3]
  connect_bd_net -net empty_inverse_Res [get_bd_pins empty_inverse/Res] [get_bd_pins util_reduced_logic_0/Op1]
  connect_bd_net -net hier_1_dout_0 [get_bd_pins dout_0_1] [get_bd_pins fifo_generator_0/s_axis_tdata] [get_bd_pins hier_1/dout_0]
  connect_bd_net -net util_reduced_logic_0_Res [get_bd_pins fifo_generator_0/s_axis_tvalid] [get_bd_pins util_reduced_logic_0/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins empty_concat/dout] [get_bd_pins empty_inverse/Op1]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins hier_1/Din] [get_bd_pins xlconcat_1/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: lgain_adc_13
proc create_hier_cell_lgain_adc_13 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_lgain_adc_13() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC


  # Create pins
  create_bd_pin -dir I -from 7 -to 0 In0
  create_bd_pin -dir I -from 7 -to 0 In1
  create_bd_pin -dir I -from 7 -to 0 In2
  create_bd_pin -dir I -from 7 -to 0 In3
  create_bd_pin -dir I M_ACLK
  create_bd_pin -dir I M_ARESETN
  create_bd_pin -dir I S_ACLK
  create_bd_pin -dir I S_ARESETN
  create_bd_pin -dir O -from 31 -to 0 dout_0_2
  create_bd_pin -dir I empty_0
  create_bd_pin -dir I empty_1
  create_bd_pin -dir I empty_2
  create_bd_pin -dir I empty_3

  # Create instance: axis_clock_converter_0, and set properties
  set axis_clock_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_0 ]

  # Create instance: empty_concat, and set properties
  set empty_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 empty_concat ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $empty_concat

  # Create instance: empty_inverse, and set properties
  set empty_inverse [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 empty_inverse ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $empty_inverse

  # Create instance: fifo_generator_0, and set properties
  set fifo_generator_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_generator_0 ]
  set_property -dict [ list \
   CONFIG.Empty_Threshold_Assert_Value_rach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wrch {14} \
   CONFIG.FIFO_Implementation_axis {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_rach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wrch {Common_Clock_Distributed_RAM} \
   CONFIG.Full_Threshold_Assert_Value_rach {15} \
   CONFIG.Full_Threshold_Assert_Value_wach {15} \
   CONFIG.Full_Threshold_Assert_Value_wrch {15} \
   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
   CONFIG.Reset_Type {Asynchronous_Reset} \
   CONFIG.TDATA_NUM_BYTES {4} \
   CONFIG.TKEEP_WIDTH {4} \
   CONFIG.TSTRB_WIDTH {4} \
   CONFIG.TUSER_WIDTH {0} \
 ] $fifo_generator_0

  # Create instance: hier_2
  create_hier_cell_hier_2_3 $hier_obj hier_2

  # Create instance: util_reduced_logic_0, and set properties
  set util_reduced_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_reduced_logic_0

  # Create instance: xlconcat_2, and set properties
  set xlconcat_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_2 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $xlconcat_2

  # Create interface connections
  connect_bd_intf_net -intf_net axis_clock_converter_0_M_AXIS [get_bd_intf_pins M_AXIS_LGAIN_ADC] [get_bd_intf_pins axis_clock_converter_0/M_AXIS]
  connect_bd_intf_net -intf_net fifo_generator_0_M_AXIS [get_bd_intf_pins axis_clock_converter_0/S_AXIS] [get_bd_intf_pins fifo_generator_0/M_AXIS]

  # Create port connections
  connect_bd_net -net In0_1 [get_bd_pins In0] [get_bd_pins xlconcat_2/In0]
  connect_bd_net -net In1_1 [get_bd_pins In1] [get_bd_pins xlconcat_2/In1]
  connect_bd_net -net In2_1 [get_bd_pins In2] [get_bd_pins xlconcat_2/In2]
  connect_bd_net -net In3_1 [get_bd_pins In3] [get_bd_pins xlconcat_2/In3]
  connect_bd_net -net M_ACLK_1 [get_bd_pins M_ACLK] [get_bd_pins axis_clock_converter_0/m_axis_aclk]
  connect_bd_net -net M_ARESETN_1 [get_bd_pins M_ARESETN] [get_bd_pins axis_clock_converter_0/m_axis_aresetn]
  connect_bd_net -net S_ARESETN_1 [get_bd_pins S_ARESETN] [get_bd_pins axis_clock_converter_0/s_axis_aresetn] [get_bd_pins fifo_generator_0/s_aresetn]
  connect_bd_net -net S_AXIS_ACLK_1 [get_bd_pins S_ACLK] [get_bd_pins axis_clock_converter_0/s_axis_aclk] [get_bd_pins fifo_generator_0/s_aclk]
  connect_bd_net -net empty_0_1 [get_bd_pins empty_0] [get_bd_pins empty_concat/In0]
  connect_bd_net -net empty_1_1 [get_bd_pins empty_1] [get_bd_pins empty_concat/In1]
  connect_bd_net -net empty_2_1 [get_bd_pins empty_2] [get_bd_pins empty_concat/In2]
  connect_bd_net -net empty_3_1 [get_bd_pins empty_3] [get_bd_pins empty_concat/In3]
  connect_bd_net -net empty_inverse_Res [get_bd_pins empty_inverse/Res] [get_bd_pins util_reduced_logic_0/Op1]
  connect_bd_net -net hier_2_dout_0 [get_bd_pins dout_0_2] [get_bd_pins fifo_generator_0/s_axis_tdata] [get_bd_pins hier_2/dout_0]
  connect_bd_net -net util_reduced_logic_0_Res [get_bd_pins fifo_generator_0/s_axis_tvalid] [get_bd_pins util_reduced_logic_0/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins empty_concat/dout] [get_bd_pins empty_inverse/Op1]
  connect_bd_net -net xlconcat_2_dout [get_bd_pins hier_2/Din] [get_bd_pins xlconcat_2/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: lgain_adc_12
proc create_hier_cell_lgain_adc_12 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_lgain_adc_12() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC


  # Create pins
  create_bd_pin -dir I -from 7 -to 0 In0
  create_bd_pin -dir I -from 7 -to 0 In1
  create_bd_pin -dir I -from 7 -to 0 In2
  create_bd_pin -dir I -from 7 -to 0 In3
  create_bd_pin -dir I M_ACLK
  create_bd_pin -dir I M_ARESETN
  create_bd_pin -dir I S_ACLK
  create_bd_pin -dir I S_ARESETN
  create_bd_pin -dir O -from 31 -to 0 dout_0_0
  create_bd_pin -dir I empty_0
  create_bd_pin -dir I empty_1
  create_bd_pin -dir I empty_2
  create_bd_pin -dir I empty_3

  # Create instance: axis_clock_converter_0, and set properties
  set axis_clock_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_0 ]

  # Create instance: empty_concat, and set properties
  set empty_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 empty_concat ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $empty_concat

  # Create instance: empty_inverse, and set properties
  set empty_inverse [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 empty_inverse ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $empty_inverse

  # Create instance: fifo_generator_0, and set properties
  set fifo_generator_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_generator_0 ]
  set_property -dict [ list \
   CONFIG.Empty_Threshold_Assert_Value_rach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wrch {14} \
   CONFIG.FIFO_Implementation_axis {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_rach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wrch {Common_Clock_Distributed_RAM} \
   CONFIG.Full_Threshold_Assert_Value_rach {15} \
   CONFIG.Full_Threshold_Assert_Value_wach {15} \
   CONFIG.Full_Threshold_Assert_Value_wrch {15} \
   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
   CONFIG.Reset_Type {Asynchronous_Reset} \
   CONFIG.TDATA_NUM_BYTES {4} \
   CONFIG.TKEEP_WIDTH {4} \
   CONFIG.TSTRB_WIDTH {4} \
   CONFIG.TUSER_WIDTH {0} \
 ] $fifo_generator_0

  # Create instance: hier_0
  create_hier_cell_hier_0_3 $hier_obj hier_0

  # Create instance: util_reduced_logic_0, and set properties
  set util_reduced_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_reduced_logic_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $xlconcat_0

  # Create interface connections
  connect_bd_intf_net -intf_net axis_clock_converter_0_M_AXIS [get_bd_intf_pins M_AXIS_LGAIN_ADC] [get_bd_intf_pins axis_clock_converter_0/M_AXIS]
  connect_bd_intf_net -intf_net fifo_generator_0_M_AXIS [get_bd_intf_pins axis_clock_converter_0/S_AXIS] [get_bd_intf_pins fifo_generator_0/M_AXIS]

  # Create port connections
  connect_bd_net -net In0_1 [get_bd_pins In0] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net In1_1 [get_bd_pins In1] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net In2_1 [get_bd_pins In2] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net In3_1 [get_bd_pins In3] [get_bd_pins xlconcat_0/In3]
  connect_bd_net -net M_ACLK_1 [get_bd_pins M_ACLK] [get_bd_pins axis_clock_converter_0/m_axis_aclk]
  connect_bd_net -net M_ARESETN_1 [get_bd_pins M_ARESETN] [get_bd_pins axis_clock_converter_0/m_axis_aresetn]
  connect_bd_net -net S_ARESETN_1 [get_bd_pins S_ARESETN] [get_bd_pins axis_clock_converter_0/s_axis_aresetn] [get_bd_pins fifo_generator_0/s_aresetn]
  connect_bd_net -net S_AXIS_ACLK_1 [get_bd_pins S_ACLK] [get_bd_pins axis_clock_converter_0/s_axis_aclk] [get_bd_pins fifo_generator_0/s_aclk]
  connect_bd_net -net empty_0_1 [get_bd_pins empty_0] [get_bd_pins empty_concat/In0]
  connect_bd_net -net empty_1_1 [get_bd_pins empty_1] [get_bd_pins empty_concat/In1]
  connect_bd_net -net empty_2_1 [get_bd_pins empty_2] [get_bd_pins empty_concat/In2]
  connect_bd_net -net empty_3_1 [get_bd_pins empty_3] [get_bd_pins empty_concat/In3]
  connect_bd_net -net empty_inverse_Res [get_bd_pins empty_inverse/Res] [get_bd_pins util_reduced_logic_0/Op1]
  connect_bd_net -net hier_0_dout_0 [get_bd_pins dout_0_0] [get_bd_pins fifo_generator_0/s_axis_tdata] [get_bd_pins hier_0/dout_0]
  connect_bd_net -net util_reduced_logic_0_Res [get_bd_pins fifo_generator_0/s_axis_tvalid] [get_bd_pins util_reduced_logic_0/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins empty_concat/dout] [get_bd_pins empty_inverse/Op1]
  connect_bd_net -net xlconcat_0_dout_1 [get_bd_pins hier_0/Din] [get_bd_pins xlconcat_0/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: lgain_adc_11
proc create_hier_cell_lgain_adc_11 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_lgain_adc_11() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC


  # Create pins
  create_bd_pin -dir I -from 7 -to 0 In0
  create_bd_pin -dir I -from 7 -to 0 In1
  create_bd_pin -dir I -from 7 -to 0 In2
  create_bd_pin -dir I -from 7 -to 0 In3
  create_bd_pin -dir I M_ACLK
  create_bd_pin -dir I M_ARESETN
  create_bd_pin -dir I S_ACLK
  create_bd_pin -dir I S_ARESETN
  create_bd_pin -dir O -from 31 -to 0 dout_0_0
  create_bd_pin -dir I empty_0
  create_bd_pin -dir I empty_1
  create_bd_pin -dir I empty_2
  create_bd_pin -dir I empty_3

  # Create instance: axis_clock_converter_0, and set properties
  set axis_clock_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_0 ]

  # Create instance: empty_concat, and set properties
  set empty_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 empty_concat ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $empty_concat

  # Create instance: empty_inverse, and set properties
  set empty_inverse [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 empty_inverse ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $empty_inverse

  # Create instance: fifo_generator_0, and set properties
  set fifo_generator_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_generator_0 ]
  set_property -dict [ list \
   CONFIG.Empty_Threshold_Assert_Value_rach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wrch {14} \
   CONFIG.FIFO_Implementation_axis {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_rach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wrch {Common_Clock_Distributed_RAM} \
   CONFIG.Full_Threshold_Assert_Value_rach {15} \
   CONFIG.Full_Threshold_Assert_Value_wach {15} \
   CONFIG.Full_Threshold_Assert_Value_wrch {15} \
   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
   CONFIG.Reset_Type {Asynchronous_Reset} \
   CONFIG.TDATA_NUM_BYTES {4} \
   CONFIG.TKEEP_WIDTH {4} \
   CONFIG.TSTRB_WIDTH {4} \
   CONFIG.TUSER_WIDTH {0} \
 ] $fifo_generator_0

  # Create instance: hier_0
  create_hier_cell_hier_0_2 $hier_obj hier_0

  # Create instance: util_reduced_logic_0, and set properties
  set util_reduced_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_reduced_logic_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $xlconcat_0

  # Create interface connections
  connect_bd_intf_net -intf_net axis_clock_converter_0_M_AXIS [get_bd_intf_pins M_AXIS_LGAIN_ADC] [get_bd_intf_pins axis_clock_converter_0/M_AXIS]
  connect_bd_intf_net -intf_net fifo_generator_0_M_AXIS [get_bd_intf_pins axis_clock_converter_0/S_AXIS] [get_bd_intf_pins fifo_generator_0/M_AXIS]

  # Create port connections
  connect_bd_net -net In0_1 [get_bd_pins In0] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net In1_1 [get_bd_pins In1] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net In2_1 [get_bd_pins In2] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net In3_1 [get_bd_pins In3] [get_bd_pins xlconcat_0/In3]
  connect_bd_net -net M_ACLK_1 [get_bd_pins M_ACLK] [get_bd_pins axis_clock_converter_0/m_axis_aclk]
  connect_bd_net -net M_ARESETN_1 [get_bd_pins M_ARESETN] [get_bd_pins axis_clock_converter_0/m_axis_aresetn]
  connect_bd_net -net S_ARESETN_1 [get_bd_pins S_ARESETN] [get_bd_pins axis_clock_converter_0/s_axis_aresetn] [get_bd_pins fifo_generator_0/s_aresetn]
  connect_bd_net -net S_AXIS_ACLK_1 [get_bd_pins S_ACLK] [get_bd_pins axis_clock_converter_0/s_axis_aclk] [get_bd_pins fifo_generator_0/s_aclk]
  connect_bd_net -net empty_0_1 [get_bd_pins empty_0] [get_bd_pins empty_concat/In0]
  connect_bd_net -net empty_1_1 [get_bd_pins empty_1] [get_bd_pins empty_concat/In1]
  connect_bd_net -net empty_2_1 [get_bd_pins empty_2] [get_bd_pins empty_concat/In2]
  connect_bd_net -net empty_3_1 [get_bd_pins empty_3] [get_bd_pins empty_concat/In3]
  connect_bd_net -net empty_inverse_Res [get_bd_pins empty_inverse/Res] [get_bd_pins util_reduced_logic_0/Op1]
  connect_bd_net -net hier_0_dout_0 [get_bd_pins dout_0_0] [get_bd_pins fifo_generator_0/s_axis_tdata] [get_bd_pins hier_0/dout_0]
  connect_bd_net -net util_reduced_logic_0_Res [get_bd_pins fifo_generator_0/s_axis_tvalid] [get_bd_pins util_reduced_logic_0/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins empty_concat/dout] [get_bd_pins empty_inverse/Op1]
  connect_bd_net -net xlconcat_0_dout_1 [get_bd_pins hier_0/Din] [get_bd_pins xlconcat_0/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: lgain_adc_10
proc create_hier_cell_lgain_adc_10 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_lgain_adc_10() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC


  # Create pins
  create_bd_pin -dir I -from 7 -to 0 In0
  create_bd_pin -dir I -from 7 -to 0 In1
  create_bd_pin -dir I -from 7 -to 0 In2
  create_bd_pin -dir I -from 7 -to 0 In3
  create_bd_pin -dir I M_ACLK
  create_bd_pin -dir I M_ARESETN
  create_bd_pin -dir I S_ACLK
  create_bd_pin -dir I S_ARESETN
  create_bd_pin -dir O -from 31 -to 0 dout_0_1
  create_bd_pin -dir I empty_0
  create_bd_pin -dir I empty_1
  create_bd_pin -dir I empty_2
  create_bd_pin -dir I empty_3

  # Create instance: axis_clock_converter_0, and set properties
  set axis_clock_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_0 ]

  # Create instance: empty_concat, and set properties
  set empty_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 empty_concat ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $empty_concat

  # Create instance: empty_inverse, and set properties
  set empty_inverse [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 empty_inverse ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $empty_inverse

  # Create instance: fifo_generator_0, and set properties
  set fifo_generator_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_generator_0 ]
  set_property -dict [ list \
   CONFIG.Empty_Threshold_Assert_Value_rach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wrch {14} \
   CONFIG.FIFO_Implementation_axis {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_rach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wrch {Common_Clock_Distributed_RAM} \
   CONFIG.Full_Threshold_Assert_Value_rach {15} \
   CONFIG.Full_Threshold_Assert_Value_wach {15} \
   CONFIG.Full_Threshold_Assert_Value_wrch {15} \
   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
   CONFIG.Reset_Type {Asynchronous_Reset} \
   CONFIG.TDATA_NUM_BYTES {4} \
   CONFIG.TKEEP_WIDTH {4} \
   CONFIG.TSTRB_WIDTH {4} \
   CONFIG.TUSER_WIDTH {0} \
 ] $fifo_generator_0

  # Create instance: hier_1
  create_hier_cell_hier_1_2 $hier_obj hier_1

  # Create instance: util_reduced_logic_0, and set properties
  set util_reduced_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_reduced_logic_0

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $xlconcat_1

  # Create interface connections
  connect_bd_intf_net -intf_net axis_clock_converter_0_M_AXIS [get_bd_intf_pins M_AXIS_LGAIN_ADC] [get_bd_intf_pins axis_clock_converter_0/M_AXIS]
  connect_bd_intf_net -intf_net fifo_generator_0_M_AXIS [get_bd_intf_pins axis_clock_converter_0/S_AXIS] [get_bd_intf_pins fifo_generator_0/M_AXIS]

  # Create port connections
  connect_bd_net -net In0_1 [get_bd_pins In0] [get_bd_pins xlconcat_1/In0]
  connect_bd_net -net In1_1 [get_bd_pins In1] [get_bd_pins xlconcat_1/In1]
  connect_bd_net -net In2_1 [get_bd_pins In2] [get_bd_pins xlconcat_1/In2]
  connect_bd_net -net In3_1 [get_bd_pins In3] [get_bd_pins xlconcat_1/In3]
  connect_bd_net -net M_ACLK_1 [get_bd_pins M_ACLK] [get_bd_pins axis_clock_converter_0/m_axis_aclk]
  connect_bd_net -net M_ARESETN_1 [get_bd_pins M_ARESETN] [get_bd_pins axis_clock_converter_0/m_axis_aresetn]
  connect_bd_net -net S_ARESETN_1 [get_bd_pins S_ARESETN] [get_bd_pins axis_clock_converter_0/s_axis_aresetn] [get_bd_pins fifo_generator_0/s_aresetn]
  connect_bd_net -net S_AXIS_ACLK_1 [get_bd_pins S_ACLK] [get_bd_pins axis_clock_converter_0/s_axis_aclk] [get_bd_pins fifo_generator_0/s_aclk]
  connect_bd_net -net empty_0_1 [get_bd_pins empty_0] [get_bd_pins empty_concat/In0]
  connect_bd_net -net empty_1_1 [get_bd_pins empty_1] [get_bd_pins empty_concat/In1]
  connect_bd_net -net empty_2_1 [get_bd_pins empty_2] [get_bd_pins empty_concat/In2]
  connect_bd_net -net empty_3_1 [get_bd_pins empty_3] [get_bd_pins empty_concat/In3]
  connect_bd_net -net empty_inverse_Res [get_bd_pins empty_inverse/Res] [get_bd_pins util_reduced_logic_0/Op1]
  connect_bd_net -net hier_1_dout_0 [get_bd_pins dout_0_1] [get_bd_pins fifo_generator_0/s_axis_tdata] [get_bd_pins hier_1/dout_0]
  connect_bd_net -net util_reduced_logic_0_Res [get_bd_pins fifo_generator_0/s_axis_tvalid] [get_bd_pins util_reduced_logic_0/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins empty_concat/dout] [get_bd_pins empty_inverse/Op1]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins hier_1/Din] [get_bd_pins xlconcat_1/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: lgain_adc_9
proc create_hier_cell_lgain_adc_9 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_lgain_adc_9() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC


  # Create pins
  create_bd_pin -dir I -from 7 -to 0 In0
  create_bd_pin -dir I -from 7 -to 0 In1
  create_bd_pin -dir I -from 7 -to 0 In2
  create_bd_pin -dir I -from 7 -to 0 In3
  create_bd_pin -dir I M_ACLK
  create_bd_pin -dir I M_ARESETN
  create_bd_pin -dir I S_ACLK
  create_bd_pin -dir I S_ARESETN
  create_bd_pin -dir O -from 31 -to 0 dout_0_2
  create_bd_pin -dir I empty_0
  create_bd_pin -dir I empty_1
  create_bd_pin -dir I empty_2
  create_bd_pin -dir I empty_3

  # Create instance: axis_clock_converter_0, and set properties
  set axis_clock_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_0 ]

  # Create instance: empty_concat, and set properties
  set empty_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 empty_concat ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $empty_concat

  # Create instance: empty_inverse, and set properties
  set empty_inverse [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 empty_inverse ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $empty_inverse

  # Create instance: fifo_generator_0, and set properties
  set fifo_generator_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_generator_0 ]
  set_property -dict [ list \
   CONFIG.Empty_Threshold_Assert_Value_rach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wrch {14} \
   CONFIG.FIFO_Implementation_axis {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_rach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wrch {Common_Clock_Distributed_RAM} \
   CONFIG.Full_Threshold_Assert_Value_rach {15} \
   CONFIG.Full_Threshold_Assert_Value_wach {15} \
   CONFIG.Full_Threshold_Assert_Value_wrch {15} \
   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
   CONFIG.Reset_Type {Asynchronous_Reset} \
   CONFIG.TDATA_NUM_BYTES {4} \
   CONFIG.TKEEP_WIDTH {4} \
   CONFIG.TSTRB_WIDTH {4} \
   CONFIG.TUSER_WIDTH {0} \
 ] $fifo_generator_0

  # Create instance: hier_2
  create_hier_cell_hier_2_2 $hier_obj hier_2

  # Create instance: util_reduced_logic_0, and set properties
  set util_reduced_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_reduced_logic_0

  # Create instance: xlconcat_2, and set properties
  set xlconcat_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_2 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $xlconcat_2

  # Create interface connections
  connect_bd_intf_net -intf_net axis_clock_converter_0_M_AXIS [get_bd_intf_pins M_AXIS_LGAIN_ADC] [get_bd_intf_pins axis_clock_converter_0/M_AXIS]
  connect_bd_intf_net -intf_net fifo_generator_0_M_AXIS [get_bd_intf_pins axis_clock_converter_0/S_AXIS] [get_bd_intf_pins fifo_generator_0/M_AXIS]

  # Create port connections
  connect_bd_net -net In0_1 [get_bd_pins In0] [get_bd_pins xlconcat_2/In0]
  connect_bd_net -net In1_1 [get_bd_pins In1] [get_bd_pins xlconcat_2/In1]
  connect_bd_net -net In2_1 [get_bd_pins In2] [get_bd_pins xlconcat_2/In2]
  connect_bd_net -net In3_1 [get_bd_pins In3] [get_bd_pins xlconcat_2/In3]
  connect_bd_net -net M_ACLK_1 [get_bd_pins M_ACLK] [get_bd_pins axis_clock_converter_0/m_axis_aclk]
  connect_bd_net -net M_ARESETN_1 [get_bd_pins M_ARESETN] [get_bd_pins axis_clock_converter_0/m_axis_aresetn]
  connect_bd_net -net S_ARESETN_1 [get_bd_pins S_ARESETN] [get_bd_pins axis_clock_converter_0/s_axis_aresetn] [get_bd_pins fifo_generator_0/s_aresetn]
  connect_bd_net -net S_AXIS_ACLK_1 [get_bd_pins S_ACLK] [get_bd_pins axis_clock_converter_0/s_axis_aclk] [get_bd_pins fifo_generator_0/s_aclk]
  connect_bd_net -net empty_0_1 [get_bd_pins empty_0] [get_bd_pins empty_concat/In0]
  connect_bd_net -net empty_1_1 [get_bd_pins empty_1] [get_bd_pins empty_concat/In1]
  connect_bd_net -net empty_2_1 [get_bd_pins empty_2] [get_bd_pins empty_concat/In2]
  connect_bd_net -net empty_3_1 [get_bd_pins empty_3] [get_bd_pins empty_concat/In3]
  connect_bd_net -net empty_inverse_Res [get_bd_pins empty_inverse/Res] [get_bd_pins util_reduced_logic_0/Op1]
  connect_bd_net -net hier_2_dout_0 [get_bd_pins dout_0_2] [get_bd_pins fifo_generator_0/s_axis_tdata] [get_bd_pins hier_2/dout_0]
  connect_bd_net -net util_reduced_logic_0_Res [get_bd_pins fifo_generator_0/s_axis_tvalid] [get_bd_pins util_reduced_logic_0/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins empty_concat/dout] [get_bd_pins empty_inverse/Op1]
  connect_bd_net -net xlconcat_2_dout [get_bd_pins hier_2/Din] [get_bd_pins xlconcat_2/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: lgain_adc_8
proc create_hier_cell_lgain_adc_8 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_lgain_adc_8() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC


  # Create pins
  create_bd_pin -dir I -from 7 -to 0 In0
  create_bd_pin -dir I -from 7 -to 0 In1
  create_bd_pin -dir I -from 7 -to 0 In2
  create_bd_pin -dir I -from 7 -to 0 In3
  create_bd_pin -dir I M_ACLK
  create_bd_pin -dir I M_ARESETN
  create_bd_pin -dir I S_ACLK
  create_bd_pin -dir I S_ARESETN
  create_bd_pin -dir O -from 31 -to 0 dout_0_3
  create_bd_pin -dir I empty_0
  create_bd_pin -dir I empty_1
  create_bd_pin -dir I empty_2
  create_bd_pin -dir I empty_3

  # Create instance: axis_clock_converter_0, and set properties
  set axis_clock_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_0 ]

  # Create instance: empty_concat, and set properties
  set empty_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 empty_concat ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $empty_concat

  # Create instance: empty_inverse, and set properties
  set empty_inverse [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 empty_inverse ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $empty_inverse

  # Create instance: fifo_generator_0, and set properties
  set fifo_generator_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_generator_0 ]
  set_property -dict [ list \
   CONFIG.Empty_Threshold_Assert_Value_rach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wrch {14} \
   CONFIG.FIFO_Implementation_axis {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_rach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wrch {Common_Clock_Distributed_RAM} \
   CONFIG.Full_Threshold_Assert_Value_rach {15} \
   CONFIG.Full_Threshold_Assert_Value_wach {15} \
   CONFIG.Full_Threshold_Assert_Value_wrch {15} \
   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
   CONFIG.Reset_Type {Asynchronous_Reset} \
   CONFIG.TDATA_NUM_BYTES {4} \
   CONFIG.TKEEP_WIDTH {4} \
   CONFIG.TSTRB_WIDTH {4} \
   CONFIG.TUSER_WIDTH {0} \
 ] $fifo_generator_0

  # Create instance: hier_3
  create_hier_cell_hier_3_2 $hier_obj hier_3

  # Create instance: util_reduced_logic_0, and set properties
  set util_reduced_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_reduced_logic_0

  # Create instance: xlconcat_3, and set properties
  set xlconcat_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_3 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $xlconcat_3

  # Create interface connections
  connect_bd_intf_net -intf_net axis_clock_converter_0_M_AXIS [get_bd_intf_pins M_AXIS_LGAIN_ADC] [get_bd_intf_pins axis_clock_converter_0/M_AXIS]
  connect_bd_intf_net -intf_net fifo_generator_0_M_AXIS [get_bd_intf_pins axis_clock_converter_0/S_AXIS] [get_bd_intf_pins fifo_generator_0/M_AXIS]

  # Create port connections
  connect_bd_net -net In0_1 [get_bd_pins In0] [get_bd_pins xlconcat_3/In0]
  connect_bd_net -net In1_1 [get_bd_pins In1] [get_bd_pins xlconcat_3/In1]
  connect_bd_net -net In2_1 [get_bd_pins In2] [get_bd_pins xlconcat_3/In2]
  connect_bd_net -net In3_1 [get_bd_pins In3] [get_bd_pins xlconcat_3/In3]
  connect_bd_net -net M_ACLK_1 [get_bd_pins M_ACLK] [get_bd_pins axis_clock_converter_0/m_axis_aclk]
  connect_bd_net -net M_ARESETN_1 [get_bd_pins M_ARESETN] [get_bd_pins axis_clock_converter_0/m_axis_aresetn]
  connect_bd_net -net S_ARESETN_1 [get_bd_pins S_ARESETN] [get_bd_pins axis_clock_converter_0/s_axis_aresetn] [get_bd_pins fifo_generator_0/s_aresetn]
  connect_bd_net -net S_AXIS_ACLK_1 [get_bd_pins S_ACLK] [get_bd_pins axis_clock_converter_0/s_axis_aclk] [get_bd_pins fifo_generator_0/s_aclk]
  connect_bd_net -net empty_0_1 [get_bd_pins empty_0] [get_bd_pins empty_concat/In0]
  connect_bd_net -net empty_1_1 [get_bd_pins empty_1] [get_bd_pins empty_concat/In1]
  connect_bd_net -net empty_2_1 [get_bd_pins empty_2] [get_bd_pins empty_concat/In2]
  connect_bd_net -net empty_3_1 [get_bd_pins empty_3] [get_bd_pins empty_concat/In3]
  connect_bd_net -net empty_inverse_Res [get_bd_pins empty_inverse/Res] [get_bd_pins util_reduced_logic_0/Op1]
  connect_bd_net -net hier_3_dout_0 [get_bd_pins dout_0_3] [get_bd_pins fifo_generator_0/s_axis_tdata] [get_bd_pins hier_3/dout_0]
  connect_bd_net -net util_reduced_logic_0_Res [get_bd_pins fifo_generator_0/s_axis_tvalid] [get_bd_pins util_reduced_logic_0/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins empty_concat/dout] [get_bd_pins empty_inverse/Op1]
  connect_bd_net -net xlconcat_3_dout [get_bd_pins hier_3/Din] [get_bd_pins xlconcat_3/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: lgain_adc_7
proc create_hier_cell_lgain_adc_7 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_lgain_adc_7() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC


  # Create pins
  create_bd_pin -dir I -from 7 -to 0 In0
  create_bd_pin -dir I -from 7 -to 0 In1
  create_bd_pin -dir I -from 7 -to 0 In2
  create_bd_pin -dir I -from 7 -to 0 In3
  create_bd_pin -dir I M_ACLK
  create_bd_pin -dir I M_ARESETN
  create_bd_pin -dir I S_ACLK
  create_bd_pin -dir I S_ARESETN
  create_bd_pin -dir O -from 31 -to 0 dout_0_0
  create_bd_pin -dir I empty_0
  create_bd_pin -dir I empty_1
  create_bd_pin -dir I empty_2
  create_bd_pin -dir I empty_3

  # Create instance: axis_clock_converter_0, and set properties
  set axis_clock_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_0 ]

  # Create instance: empty_concat, and set properties
  set empty_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 empty_concat ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $empty_concat

  # Create instance: empty_inverse, and set properties
  set empty_inverse [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 empty_inverse ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $empty_inverse

  # Create instance: fifo_generator_0, and set properties
  set fifo_generator_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_generator_0 ]
  set_property -dict [ list \
   CONFIG.Empty_Threshold_Assert_Value_rach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wrch {14} \
   CONFIG.FIFO_Implementation_axis {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_rach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wrch {Common_Clock_Distributed_RAM} \
   CONFIG.Full_Threshold_Assert_Value_rach {15} \
   CONFIG.Full_Threshold_Assert_Value_wach {15} \
   CONFIG.Full_Threshold_Assert_Value_wrch {15} \
   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
   CONFIG.Reset_Type {Asynchronous_Reset} \
   CONFIG.TDATA_NUM_BYTES {4} \
   CONFIG.TKEEP_WIDTH {4} \
   CONFIG.TSTRB_WIDTH {4} \
   CONFIG.TUSER_WIDTH {0} \
 ] $fifo_generator_0

  # Create instance: hier_0
  create_hier_cell_hier_0_1 $hier_obj hier_0

  # Create instance: util_reduced_logic_0, and set properties
  set util_reduced_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_reduced_logic_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $xlconcat_0

  # Create interface connections
  connect_bd_intf_net -intf_net axis_clock_converter_0_M_AXIS [get_bd_intf_pins M_AXIS_LGAIN_ADC] [get_bd_intf_pins axis_clock_converter_0/M_AXIS]
  connect_bd_intf_net -intf_net fifo_generator_0_M_AXIS [get_bd_intf_pins axis_clock_converter_0/S_AXIS] [get_bd_intf_pins fifo_generator_0/M_AXIS]

  # Create port connections
  connect_bd_net -net In0_1 [get_bd_pins In0] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net In1_1 [get_bd_pins In1] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net In2_1 [get_bd_pins In2] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net In3_1 [get_bd_pins In3] [get_bd_pins xlconcat_0/In3]
  connect_bd_net -net M_ACLK_1 [get_bd_pins M_ACLK] [get_bd_pins axis_clock_converter_0/m_axis_aclk]
  connect_bd_net -net M_ARESETN_1 [get_bd_pins M_ARESETN] [get_bd_pins axis_clock_converter_0/m_axis_aresetn]
  connect_bd_net -net S_ARESETN_1 [get_bd_pins S_ARESETN] [get_bd_pins axis_clock_converter_0/s_axis_aresetn] [get_bd_pins fifo_generator_0/s_aresetn]
  connect_bd_net -net S_AXIS_ACLK_1 [get_bd_pins S_ACLK] [get_bd_pins axis_clock_converter_0/s_axis_aclk] [get_bd_pins fifo_generator_0/s_aclk]
  connect_bd_net -net empty_0_1 [get_bd_pins empty_0] [get_bd_pins empty_concat/In0]
  connect_bd_net -net empty_1_1 [get_bd_pins empty_1] [get_bd_pins empty_concat/In1]
  connect_bd_net -net empty_2_1 [get_bd_pins empty_2] [get_bd_pins empty_concat/In2]
  connect_bd_net -net empty_3_1 [get_bd_pins empty_3] [get_bd_pins empty_concat/In3]
  connect_bd_net -net empty_inverse_Res [get_bd_pins empty_inverse/Res] [get_bd_pins util_reduced_logic_0/Op1]
  connect_bd_net -net hier_0_dout_0 [get_bd_pins dout_0_0] [get_bd_pins fifo_generator_0/s_axis_tdata] [get_bd_pins hier_0/dout_0]
  connect_bd_net -net util_reduced_logic_0_Res [get_bd_pins fifo_generator_0/s_axis_tvalid] [get_bd_pins util_reduced_logic_0/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins empty_concat/dout] [get_bd_pins empty_inverse/Op1]
  connect_bd_net -net xlconcat_0_dout_1 [get_bd_pins hier_0/Din] [get_bd_pins xlconcat_0/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: lgain_adc_6
proc create_hier_cell_lgain_adc_6 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_lgain_adc_6() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC


  # Create pins
  create_bd_pin -dir I -from 7 -to 0 In0
  create_bd_pin -dir I -from 7 -to 0 In1
  create_bd_pin -dir I -from 7 -to 0 In2
  create_bd_pin -dir I -from 7 -to 0 In3
  create_bd_pin -dir I M_ACLK
  create_bd_pin -dir I M_ARESETN
  create_bd_pin -dir I S_ACLK
  create_bd_pin -dir I S_ARESETN
  create_bd_pin -dir O -from 31 -to 0 dout_0_1
  create_bd_pin -dir I empty_0
  create_bd_pin -dir I empty_1
  create_bd_pin -dir I empty_2
  create_bd_pin -dir I empty_3

  # Create instance: axis_clock_converter_0, and set properties
  set axis_clock_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_0 ]

  # Create instance: empty_concat, and set properties
  set empty_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 empty_concat ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $empty_concat

  # Create instance: empty_inverse, and set properties
  set empty_inverse [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 empty_inverse ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $empty_inverse

  # Create instance: fifo_generator_0, and set properties
  set fifo_generator_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_generator_0 ]
  set_property -dict [ list \
   CONFIG.Empty_Threshold_Assert_Value_rach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wrch {14} \
   CONFIG.FIFO_Implementation_axis {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_rach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wrch {Common_Clock_Distributed_RAM} \
   CONFIG.Full_Threshold_Assert_Value_rach {15} \
   CONFIG.Full_Threshold_Assert_Value_wach {15} \
   CONFIG.Full_Threshold_Assert_Value_wrch {15} \
   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
   CONFIG.Reset_Type {Asynchronous_Reset} \
   CONFIG.TDATA_NUM_BYTES {4} \
   CONFIG.TKEEP_WIDTH {4} \
   CONFIG.TSTRB_WIDTH {4} \
   CONFIG.TUSER_WIDTH {0} \
 ] $fifo_generator_0

  # Create instance: hier_1
  create_hier_cell_hier_1_1 $hier_obj hier_1

  # Create instance: util_reduced_logic_0, and set properties
  set util_reduced_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_reduced_logic_0

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $xlconcat_1

  # Create interface connections
  connect_bd_intf_net -intf_net axis_clock_converter_0_M_AXIS [get_bd_intf_pins M_AXIS_LGAIN_ADC] [get_bd_intf_pins axis_clock_converter_0/M_AXIS]
  connect_bd_intf_net -intf_net fifo_generator_0_M_AXIS [get_bd_intf_pins axis_clock_converter_0/S_AXIS] [get_bd_intf_pins fifo_generator_0/M_AXIS]

  # Create port connections
  connect_bd_net -net In0_1 [get_bd_pins In0] [get_bd_pins xlconcat_1/In0]
  connect_bd_net -net In1_1 [get_bd_pins In1] [get_bd_pins xlconcat_1/In1]
  connect_bd_net -net In2_1 [get_bd_pins In2] [get_bd_pins xlconcat_1/In2]
  connect_bd_net -net In3_1 [get_bd_pins In3] [get_bd_pins xlconcat_1/In3]
  connect_bd_net -net M_ACLK_1 [get_bd_pins M_ACLK] [get_bd_pins axis_clock_converter_0/m_axis_aclk]
  connect_bd_net -net M_ARESETN_1 [get_bd_pins M_ARESETN] [get_bd_pins axis_clock_converter_0/m_axis_aresetn]
  connect_bd_net -net S_ARESETN_1 [get_bd_pins S_ARESETN] [get_bd_pins axis_clock_converter_0/s_axis_aresetn] [get_bd_pins fifo_generator_0/s_aresetn]
  connect_bd_net -net S_AXIS_ACLK_1 [get_bd_pins S_ACLK] [get_bd_pins axis_clock_converter_0/s_axis_aclk] [get_bd_pins fifo_generator_0/s_aclk]
  connect_bd_net -net empty_0_1 [get_bd_pins empty_0] [get_bd_pins empty_concat/In0]
  connect_bd_net -net empty_1_1 [get_bd_pins empty_1] [get_bd_pins empty_concat/In1]
  connect_bd_net -net empty_2_1 [get_bd_pins empty_2] [get_bd_pins empty_concat/In2]
  connect_bd_net -net empty_3_1 [get_bd_pins empty_3] [get_bd_pins empty_concat/In3]
  connect_bd_net -net empty_inverse_Res [get_bd_pins empty_inverse/Res] [get_bd_pins util_reduced_logic_0/Op1]
  connect_bd_net -net hier_1_dout_0 [get_bd_pins dout_0_1] [get_bd_pins fifo_generator_0/s_axis_tdata] [get_bd_pins hier_1/dout_0]
  connect_bd_net -net util_reduced_logic_0_Res [get_bd_pins fifo_generator_0/s_axis_tvalid] [get_bd_pins util_reduced_logic_0/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins empty_concat/dout] [get_bd_pins empty_inverse/Op1]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins hier_1/Din] [get_bd_pins xlconcat_1/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: lgain_adc_5
proc create_hier_cell_lgain_adc_5 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_lgain_adc_5() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC


  # Create pins
  create_bd_pin -dir I -from 7 -to 0 In0
  create_bd_pin -dir I -from 7 -to 0 In1
  create_bd_pin -dir I -from 7 -to 0 In2
  create_bd_pin -dir I -from 7 -to 0 In3
  create_bd_pin -dir I M_ACLK
  create_bd_pin -dir I M_ARESETN
  create_bd_pin -dir I S_ACLK
  create_bd_pin -dir I S_ARESETN
  create_bd_pin -dir O -from 31 -to 0 dout_0_2
  create_bd_pin -dir I empty_0
  create_bd_pin -dir I empty_1
  create_bd_pin -dir I empty_2
  create_bd_pin -dir I empty_3

  # Create instance: axis_clock_converter_0, and set properties
  set axis_clock_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_0 ]

  # Create instance: empty_concat, and set properties
  set empty_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 empty_concat ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $empty_concat

  # Create instance: empty_inverse, and set properties
  set empty_inverse [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 empty_inverse ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $empty_inverse

  # Create instance: fifo_generator_0, and set properties
  set fifo_generator_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_generator_0 ]
  set_property -dict [ list \
   CONFIG.Empty_Threshold_Assert_Value_rach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wrch {14} \
   CONFIG.FIFO_Implementation_axis {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_rach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wrch {Common_Clock_Distributed_RAM} \
   CONFIG.Full_Threshold_Assert_Value_rach {15} \
   CONFIG.Full_Threshold_Assert_Value_wach {15} \
   CONFIG.Full_Threshold_Assert_Value_wrch {15} \
   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
   CONFIG.Reset_Type {Asynchronous_Reset} \
   CONFIG.TDATA_NUM_BYTES {4} \
   CONFIG.TKEEP_WIDTH {4} \
   CONFIG.TSTRB_WIDTH {4} \
   CONFIG.TUSER_WIDTH {0} \
 ] $fifo_generator_0

  # Create instance: hier_2
  create_hier_cell_hier_2_1 $hier_obj hier_2

  # Create instance: util_reduced_logic_0, and set properties
  set util_reduced_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_reduced_logic_0

  # Create instance: xlconcat_2, and set properties
  set xlconcat_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_2 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $xlconcat_2

  # Create interface connections
  connect_bd_intf_net -intf_net axis_clock_converter_0_M_AXIS [get_bd_intf_pins M_AXIS_LGAIN_ADC] [get_bd_intf_pins axis_clock_converter_0/M_AXIS]
  connect_bd_intf_net -intf_net fifo_generator_0_M_AXIS [get_bd_intf_pins axis_clock_converter_0/S_AXIS] [get_bd_intf_pins fifo_generator_0/M_AXIS]

  # Create port connections
  connect_bd_net -net In0_1 [get_bd_pins In0] [get_bd_pins xlconcat_2/In0]
  connect_bd_net -net In1_1 [get_bd_pins In1] [get_bd_pins xlconcat_2/In1]
  connect_bd_net -net In2_1 [get_bd_pins In2] [get_bd_pins xlconcat_2/In2]
  connect_bd_net -net In3_1 [get_bd_pins In3] [get_bd_pins xlconcat_2/In3]
  connect_bd_net -net M_ACLK_1 [get_bd_pins M_ACLK] [get_bd_pins axis_clock_converter_0/m_axis_aclk]
  connect_bd_net -net M_ARESETN_1 [get_bd_pins M_ARESETN] [get_bd_pins axis_clock_converter_0/m_axis_aresetn]
  connect_bd_net -net S_ARESETN_1 [get_bd_pins S_ARESETN] [get_bd_pins axis_clock_converter_0/s_axis_aresetn] [get_bd_pins fifo_generator_0/s_aresetn]
  connect_bd_net -net S_AXIS_ACLK_1 [get_bd_pins S_ACLK] [get_bd_pins axis_clock_converter_0/s_axis_aclk] [get_bd_pins fifo_generator_0/s_aclk]
  connect_bd_net -net empty_0_1 [get_bd_pins empty_0] [get_bd_pins empty_concat/In0]
  connect_bd_net -net empty_1_1 [get_bd_pins empty_1] [get_bd_pins empty_concat/In1]
  connect_bd_net -net empty_2_1 [get_bd_pins empty_2] [get_bd_pins empty_concat/In2]
  connect_bd_net -net empty_3_1 [get_bd_pins empty_3] [get_bd_pins empty_concat/In3]
  connect_bd_net -net empty_inverse_Res [get_bd_pins empty_inverse/Res] [get_bd_pins util_reduced_logic_0/Op1]
  connect_bd_net -net hier_2_dout_0 [get_bd_pins dout_0_2] [get_bd_pins fifo_generator_0/s_axis_tdata] [get_bd_pins hier_2/dout_0]
  connect_bd_net -net util_reduced_logic_0_Res [get_bd_pins fifo_generator_0/s_axis_tvalid] [get_bd_pins util_reduced_logic_0/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins empty_concat/dout] [get_bd_pins empty_inverse/Op1]
  connect_bd_net -net xlconcat_2_dout [get_bd_pins hier_2/Din] [get_bd_pins xlconcat_2/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: lgain_adc_4
proc create_hier_cell_lgain_adc_4 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_lgain_adc_4() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC


  # Create pins
  create_bd_pin -dir I -from 7 -to 0 In0
  create_bd_pin -dir I -from 7 -to 0 In1
  create_bd_pin -dir I -from 7 -to 0 In2
  create_bd_pin -dir I -from 7 -to 0 In3
  create_bd_pin -dir I M_ACLK
  create_bd_pin -dir I M_ARESETN
  create_bd_pin -dir I S_ACLK
  create_bd_pin -dir I S_ARESETN
  create_bd_pin -dir O -from 31 -to 0 dout_0_3
  create_bd_pin -dir I empty_0
  create_bd_pin -dir I empty_1
  create_bd_pin -dir I empty_2
  create_bd_pin -dir I empty_3

  # Create instance: axis_clock_converter_0, and set properties
  set axis_clock_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_0 ]

  # Create instance: empty_concat, and set properties
  set empty_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 empty_concat ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $empty_concat

  # Create instance: empty_inverse, and set properties
  set empty_inverse [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 empty_inverse ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $empty_inverse

  # Create instance: fifo_generator_0, and set properties
  set fifo_generator_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_generator_0 ]
  set_property -dict [ list \
   CONFIG.Empty_Threshold_Assert_Value_rach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wrch {14} \
   CONFIG.FIFO_Implementation_axis {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_rach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wrch {Common_Clock_Distributed_RAM} \
   CONFIG.Full_Threshold_Assert_Value_rach {15} \
   CONFIG.Full_Threshold_Assert_Value_wach {15} \
   CONFIG.Full_Threshold_Assert_Value_wrch {15} \
   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
   CONFIG.Reset_Type {Asynchronous_Reset} \
   CONFIG.TDATA_NUM_BYTES {4} \
   CONFIG.TKEEP_WIDTH {4} \
   CONFIG.TSTRB_WIDTH {4} \
   CONFIG.TUSER_WIDTH {0} \
 ] $fifo_generator_0

  # Create instance: hier_3
  create_hier_cell_hier_3_1 $hier_obj hier_3

  # Create instance: util_reduced_logic_0, and set properties
  set util_reduced_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_reduced_logic_0

  # Create instance: xlconcat_3, and set properties
  set xlconcat_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_3 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $xlconcat_3

  # Create interface connections
  connect_bd_intf_net -intf_net axis_clock_converter_0_M_AXIS [get_bd_intf_pins M_AXIS_LGAIN_ADC] [get_bd_intf_pins axis_clock_converter_0/M_AXIS]
  connect_bd_intf_net -intf_net fifo_generator_0_M_AXIS [get_bd_intf_pins axis_clock_converter_0/S_AXIS] [get_bd_intf_pins fifo_generator_0/M_AXIS]

  # Create port connections
  connect_bd_net -net In0_1 [get_bd_pins In0] [get_bd_pins xlconcat_3/In0]
  connect_bd_net -net In1_1 [get_bd_pins In1] [get_bd_pins xlconcat_3/In1]
  connect_bd_net -net In2_1 [get_bd_pins In2] [get_bd_pins xlconcat_3/In2]
  connect_bd_net -net In3_1 [get_bd_pins In3] [get_bd_pins xlconcat_3/In3]
  connect_bd_net -net M_ACLK_1 [get_bd_pins M_ACLK] [get_bd_pins axis_clock_converter_0/m_axis_aclk]
  connect_bd_net -net M_ARESETN_1 [get_bd_pins M_ARESETN] [get_bd_pins axis_clock_converter_0/m_axis_aresetn]
  connect_bd_net -net S_ARESETN_1 [get_bd_pins S_ARESETN] [get_bd_pins axis_clock_converter_0/s_axis_aresetn] [get_bd_pins fifo_generator_0/s_aresetn]
  connect_bd_net -net S_AXIS_ACLK_1 [get_bd_pins S_ACLK] [get_bd_pins axis_clock_converter_0/s_axis_aclk] [get_bd_pins fifo_generator_0/s_aclk]
  connect_bd_net -net empty_0_1 [get_bd_pins empty_0] [get_bd_pins empty_concat/In0]
  connect_bd_net -net empty_1_1 [get_bd_pins empty_1] [get_bd_pins empty_concat/In1]
  connect_bd_net -net empty_2_1 [get_bd_pins empty_2] [get_bd_pins empty_concat/In2]
  connect_bd_net -net empty_3_1 [get_bd_pins empty_3] [get_bd_pins empty_concat/In3]
  connect_bd_net -net empty_inverse_Res [get_bd_pins empty_inverse/Res] [get_bd_pins util_reduced_logic_0/Op1]
  connect_bd_net -net hier_3_dout_0 [get_bd_pins dout_0_3] [get_bd_pins fifo_generator_0/s_axis_tdata] [get_bd_pins hier_3/dout_0]
  connect_bd_net -net util_reduced_logic_0_Res [get_bd_pins fifo_generator_0/s_axis_tvalid] [get_bd_pins util_reduced_logic_0/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins empty_concat/dout] [get_bd_pins empty_inverse/Op1]
  connect_bd_net -net xlconcat_3_dout [get_bd_pins hier_3/Din] [get_bd_pins xlconcat_3/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: lgain_adc_3
proc create_hier_cell_lgain_adc_3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_lgain_adc_3() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC


  # Create pins
  create_bd_pin -dir I -from 7 -to 0 In0
  create_bd_pin -dir I -from 7 -to 0 In1
  create_bd_pin -dir I -from 7 -to 0 In2
  create_bd_pin -dir I -from 7 -to 0 In3
  create_bd_pin -dir I M_ACLK
  create_bd_pin -dir I M_ARESETN
  create_bd_pin -dir I S_ACLK
  create_bd_pin -dir I S_ARESETN
  create_bd_pin -dir O -from 31 -to 0 dout_0
  create_bd_pin -dir I empty_0
  create_bd_pin -dir I empty_1
  create_bd_pin -dir I empty_2
  create_bd_pin -dir I empty_3

  # Create instance: axis_clock_converter_0, and set properties
  set axis_clock_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_0 ]

  # Create instance: empty_concat, and set properties
  set empty_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 empty_concat ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $empty_concat

  # Create instance: empty_inverse, and set properties
  set empty_inverse [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 empty_inverse ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $empty_inverse

  # Create instance: fifo_generator_0, and set properties
  set fifo_generator_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_generator_0 ]
  set_property -dict [ list \
   CONFIG.Empty_Threshold_Assert_Value_rach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wrch {14} \
   CONFIG.FIFO_Implementation_axis {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_rach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wrch {Common_Clock_Distributed_RAM} \
   CONFIG.Full_Threshold_Assert_Value_rach {15} \
   CONFIG.Full_Threshold_Assert_Value_wach {15} \
   CONFIG.Full_Threshold_Assert_Value_wrch {15} \
   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
   CONFIG.Reset_Type {Asynchronous_Reset} \
   CONFIG.TDATA_NUM_BYTES {4} \
   CONFIG.TKEEP_WIDTH {4} \
   CONFIG.TSTRB_WIDTH {4} \
   CONFIG.TUSER_WIDTH {0} \
 ] $fifo_generator_0

  # Create instance: hier_0
  create_hier_cell_hier_0 $hier_obj hier_0

  # Create instance: util_reduced_logic_0, and set properties
  set util_reduced_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_reduced_logic_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $xlconcat_0

  # Create interface connections
  connect_bd_intf_net -intf_net axis_clock_converter_0_M_AXIS [get_bd_intf_pins M_AXIS_LGAIN_ADC] [get_bd_intf_pins axis_clock_converter_0/M_AXIS]
  connect_bd_intf_net -intf_net fifo_generator_0_M_AXIS [get_bd_intf_pins axis_clock_converter_0/S_AXIS] [get_bd_intf_pins fifo_generator_0/M_AXIS]

  # Create port connections
  connect_bd_net -net In0_1 [get_bd_pins In0] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net In1_1 [get_bd_pins In1] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net In2_1 [get_bd_pins In2] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net In3_1 [get_bd_pins In3] [get_bd_pins xlconcat_0/In3]
  connect_bd_net -net M_ACLK_1 [get_bd_pins M_ACLK] [get_bd_pins axis_clock_converter_0/m_axis_aclk]
  connect_bd_net -net M_ARESETN_1 [get_bd_pins M_ARESETN] [get_bd_pins axis_clock_converter_0/m_axis_aresetn]
  connect_bd_net -net S_ARESETN_1 [get_bd_pins S_ARESETN] [get_bd_pins axis_clock_converter_0/s_axis_aresetn] [get_bd_pins fifo_generator_0/s_aresetn]
  connect_bd_net -net S_AXIS_ACLK_1 [get_bd_pins S_ACLK] [get_bd_pins axis_clock_converter_0/s_axis_aclk] [get_bd_pins fifo_generator_0/s_aclk]
  connect_bd_net -net empty_0_1 [get_bd_pins empty_0] [get_bd_pins empty_concat/In0]
  connect_bd_net -net empty_1_1 [get_bd_pins empty_1] [get_bd_pins empty_concat/In1]
  connect_bd_net -net empty_2_1 [get_bd_pins empty_2] [get_bd_pins empty_concat/In2]
  connect_bd_net -net empty_3_1 [get_bd_pins empty_3] [get_bd_pins empty_concat/In3]
  connect_bd_net -net empty_inverse_Res [get_bd_pins empty_inverse/Res] [get_bd_pins util_reduced_logic_0/Op1]
  connect_bd_net -net hier_0_dout_0 [get_bd_pins dout_0] [get_bd_pins fifo_generator_0/s_axis_tdata] [get_bd_pins hier_0/dout_0]
  connect_bd_net -net util_reduced_logic_0_Res [get_bd_pins fifo_generator_0/s_axis_tvalid] [get_bd_pins util_reduced_logic_0/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins hier_0/Din] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconcat_0_dout1 [get_bd_pins empty_concat/dout] [get_bd_pins empty_inverse/Op1]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: lgain_adc_2
proc create_hier_cell_lgain_adc_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_lgain_adc_2() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC


  # Create pins
  create_bd_pin -dir I -from 7 -to 0 In0
  create_bd_pin -dir I -from 7 -to 0 In1
  create_bd_pin -dir I -from 7 -to 0 In2
  create_bd_pin -dir I -from 7 -to 0 In3
  create_bd_pin -dir I M_ACLK
  create_bd_pin -dir I M_ARESETN
  create_bd_pin -dir I S_ACLK
  create_bd_pin -dir I S_ARESETN
  create_bd_pin -dir O -from 31 -to 0 dout_0_0
  create_bd_pin -dir I empty_0
  create_bd_pin -dir I empty_1
  create_bd_pin -dir I empty_2
  create_bd_pin -dir I empty_3

  # Create instance: axis_clock_converter_0, and set properties
  set axis_clock_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_0 ]

  # Create instance: empty_concat, and set properties
  set empty_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 empty_concat ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $empty_concat

  # Create instance: empty_inverse, and set properties
  set empty_inverse [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 empty_inverse ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $empty_inverse

  # Create instance: fifo_generator_0, and set properties
  set fifo_generator_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_generator_0 ]
  set_property -dict [ list \
   CONFIG.Empty_Threshold_Assert_Value_rach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wrch {14} \
   CONFIG.FIFO_Implementation_axis {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_rach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wrch {Common_Clock_Distributed_RAM} \
   CONFIG.Full_Threshold_Assert_Value_rach {15} \
   CONFIG.Full_Threshold_Assert_Value_wach {15} \
   CONFIG.Full_Threshold_Assert_Value_wrch {15} \
   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
   CONFIG.Reset_Type {Asynchronous_Reset} \
   CONFIG.TDATA_NUM_BYTES {4} \
   CONFIG.TKEEP_WIDTH {4} \
   CONFIG.TSTRB_WIDTH {4} \
   CONFIG.TUSER_WIDTH {0} \
 ] $fifo_generator_0

  # Create instance: hier_1
  create_hier_cell_hier_1 $hier_obj hier_1

  # Create instance: util_reduced_logic_0, and set properties
  set util_reduced_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_reduced_logic_0

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $xlconcat_1

  # Create interface connections
  connect_bd_intf_net -intf_net axis_clock_converter_0_M_AXIS [get_bd_intf_pins M_AXIS_LGAIN_ADC] [get_bd_intf_pins axis_clock_converter_0/M_AXIS]
  connect_bd_intf_net -intf_net fifo_generator_0_M_AXIS [get_bd_intf_pins axis_clock_converter_0/S_AXIS] [get_bd_intf_pins fifo_generator_0/M_AXIS]

  # Create port connections
  connect_bd_net -net In0_1 [get_bd_pins In0] [get_bd_pins xlconcat_1/In0]
  connect_bd_net -net In1_1 [get_bd_pins In1] [get_bd_pins xlconcat_1/In1]
  connect_bd_net -net In2_1 [get_bd_pins In2] [get_bd_pins xlconcat_1/In2]
  connect_bd_net -net In3_1 [get_bd_pins In3] [get_bd_pins xlconcat_1/In3]
  connect_bd_net -net M_ACLK_1 [get_bd_pins M_ACLK] [get_bd_pins axis_clock_converter_0/m_axis_aclk]
  connect_bd_net -net M_ARESETN_1 [get_bd_pins M_ARESETN] [get_bd_pins axis_clock_converter_0/m_axis_aresetn]
  connect_bd_net -net S_ARESETN_1 [get_bd_pins S_ARESETN] [get_bd_pins axis_clock_converter_0/s_axis_aresetn] [get_bd_pins fifo_generator_0/s_aresetn]
  connect_bd_net -net S_AXIS_ACLK_1 [get_bd_pins S_ACLK] [get_bd_pins axis_clock_converter_0/s_axis_aclk] [get_bd_pins fifo_generator_0/s_aclk]
  connect_bd_net -net empty_0_1 [get_bd_pins empty_0] [get_bd_pins empty_concat/In0]
  connect_bd_net -net empty_1_1 [get_bd_pins empty_1] [get_bd_pins empty_concat/In1]
  connect_bd_net -net empty_2_1 [get_bd_pins empty_2] [get_bd_pins empty_concat/In2]
  connect_bd_net -net empty_3_1 [get_bd_pins empty_3] [get_bd_pins empty_concat/In3]
  connect_bd_net -net empty_inverse_Res [get_bd_pins empty_inverse/Res] [get_bd_pins util_reduced_logic_0/Op1]
  connect_bd_net -net hier_1_dout_0 [get_bd_pins dout_0_0] [get_bd_pins fifo_generator_0/s_axis_tdata] [get_bd_pins hier_1/dout_0]
  connect_bd_net -net util_reduced_logic_0_Res [get_bd_pins fifo_generator_0/s_axis_tvalid] [get_bd_pins util_reduced_logic_0/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins empty_concat/dout] [get_bd_pins empty_inverse/Op1]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins hier_1/Din] [get_bd_pins xlconcat_1/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: lgain_adc_1
proc create_hier_cell_lgain_adc_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_lgain_adc_1() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC


  # Create pins
  create_bd_pin -dir I -from 7 -to 0 In0
  create_bd_pin -dir I -from 7 -to 0 In1
  create_bd_pin -dir I -from 7 -to 0 In2
  create_bd_pin -dir I -from 7 -to 0 In3
  create_bd_pin -dir I M_ACLK
  create_bd_pin -dir I M_ARESETN
  create_bd_pin -dir I S_ACLK
  create_bd_pin -dir I S_ARESETN
  create_bd_pin -dir O -from 31 -to 0 dout_0_1
  create_bd_pin -dir I empty_0
  create_bd_pin -dir I empty_1
  create_bd_pin -dir I empty_2
  create_bd_pin -dir I empty_3

  # Create instance: axis_clock_converter_0, and set properties
  set axis_clock_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_0 ]

  # Create instance: empty_concat, and set properties
  set empty_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 empty_concat ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $empty_concat

  # Create instance: empty_inverse, and set properties
  set empty_inverse [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 empty_inverse ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $empty_inverse

  # Create instance: fifo_generator_0, and set properties
  set fifo_generator_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_generator_0 ]
  set_property -dict [ list \
   CONFIG.Empty_Threshold_Assert_Value_rach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wrch {14} \
   CONFIG.FIFO_Implementation_axis {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_rach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wrch {Common_Clock_Distributed_RAM} \
   CONFIG.Full_Threshold_Assert_Value_rach {15} \
   CONFIG.Full_Threshold_Assert_Value_wach {15} \
   CONFIG.Full_Threshold_Assert_Value_wrch {15} \
   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
   CONFIG.Reset_Type {Asynchronous_Reset} \
   CONFIG.TDATA_NUM_BYTES {4} \
   CONFIG.TKEEP_WIDTH {4} \
   CONFIG.TSTRB_WIDTH {4} \
   CONFIG.TUSER_WIDTH {0} \
 ] $fifo_generator_0

  # Create instance: hier_2
  create_hier_cell_hier_2 $hier_obj hier_2

  # Create instance: util_reduced_logic_0, and set properties
  set util_reduced_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_reduced_logic_0

  # Create instance: xlconcat_2, and set properties
  set xlconcat_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_2 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $xlconcat_2

  # Create interface connections
  connect_bd_intf_net -intf_net axis_clock_converter_0_M_AXIS [get_bd_intf_pins M_AXIS_LGAIN_ADC] [get_bd_intf_pins axis_clock_converter_0/M_AXIS]
  connect_bd_intf_net -intf_net fifo_generator_0_M_AXIS [get_bd_intf_pins axis_clock_converter_0/S_AXIS] [get_bd_intf_pins fifo_generator_0/M_AXIS]

  # Create port connections
  connect_bd_net -net In0_1 [get_bd_pins In0] [get_bd_pins xlconcat_2/In0]
  connect_bd_net -net In1_1 [get_bd_pins In1] [get_bd_pins xlconcat_2/In1]
  connect_bd_net -net In2_1 [get_bd_pins In2] [get_bd_pins xlconcat_2/In2]
  connect_bd_net -net In3_1 [get_bd_pins In3] [get_bd_pins xlconcat_2/In3]
  connect_bd_net -net M_ACLK_1 [get_bd_pins M_ACLK] [get_bd_pins axis_clock_converter_0/m_axis_aclk]
  connect_bd_net -net M_ARESETN_1 [get_bd_pins M_ARESETN] [get_bd_pins axis_clock_converter_0/m_axis_aresetn]
  connect_bd_net -net S_ARESETN_1 [get_bd_pins S_ARESETN] [get_bd_pins axis_clock_converter_0/s_axis_aresetn] [get_bd_pins fifo_generator_0/s_aresetn]
  connect_bd_net -net S_AXIS_ACLK_1 [get_bd_pins S_ACLK] [get_bd_pins axis_clock_converter_0/s_axis_aclk] [get_bd_pins fifo_generator_0/s_aclk]
  connect_bd_net -net empty_0_1 [get_bd_pins empty_0] [get_bd_pins empty_concat/In0]
  connect_bd_net -net empty_1_1 [get_bd_pins empty_1] [get_bd_pins empty_concat/In1]
  connect_bd_net -net empty_2_1 [get_bd_pins empty_2] [get_bd_pins empty_concat/In2]
  connect_bd_net -net empty_3_1 [get_bd_pins empty_3] [get_bd_pins empty_concat/In3]
  connect_bd_net -net empty_inverse_Res [get_bd_pins empty_inverse/Res] [get_bd_pins util_reduced_logic_0/Op1]
  connect_bd_net -net hier_2_dout_0 [get_bd_pins dout_0_1] [get_bd_pins fifo_generator_0/s_axis_tdata] [get_bd_pins hier_2/dout_0]
  connect_bd_net -net util_reduced_logic_0_Res [get_bd_pins fifo_generator_0/s_axis_tvalid] [get_bd_pins util_reduced_logic_0/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins empty_concat/dout] [get_bd_pins empty_inverse/Op1]
  connect_bd_net -net xlconcat_2_dout [get_bd_pins hier_2/Din] [get_bd_pins xlconcat_2/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: lgain_adc_0
proc create_hier_cell_lgain_adc_0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_lgain_adc_0() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC


  # Create pins
  create_bd_pin -dir I -from 7 -to 0 In0
  create_bd_pin -dir I -from 7 -to 0 In1
  create_bd_pin -dir I -from 7 -to 0 In2
  create_bd_pin -dir I -from 7 -to 0 In3
  create_bd_pin -dir I M_ACLK
  create_bd_pin -dir I M_ARESETN
  create_bd_pin -dir I S_ACLK
  create_bd_pin -dir I S_ARESETN
  create_bd_pin -dir O -from 31 -to 0 dout_0_2
  create_bd_pin -dir I empty_0
  create_bd_pin -dir I empty_1
  create_bd_pin -dir I empty_2
  create_bd_pin -dir I empty_3

  # Create instance: axis_clock_converter_0, and set properties
  set axis_clock_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_0 ]

  # Create instance: empty_concat, and set properties
  set empty_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 empty_concat ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $empty_concat

  # Create instance: empty_inverse, and set properties
  set empty_inverse [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 empty_inverse ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $empty_inverse

  # Create instance: fifo_generator_0, and set properties
  set fifo_generator_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_generator_0 ]
  set_property -dict [ list \
   CONFIG.Empty_Threshold_Assert_Value_rach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wach {14} \
   CONFIG.Empty_Threshold_Assert_Value_wrch {14} \
   CONFIG.FIFO_Implementation_axis {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_rach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wach {Common_Clock_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wdch {Common_Clock_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wrch {Common_Clock_Distributed_RAM} \
   CONFIG.Full_Threshold_Assert_Value_rach {15} \
   CONFIG.Full_Threshold_Assert_Value_wach {15} \
   CONFIG.Full_Threshold_Assert_Value_wrch {15} \
   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
   CONFIG.Reset_Type {Asynchronous_Reset} \
   CONFIG.TDATA_NUM_BYTES {4} \
   CONFIG.TKEEP_WIDTH {4} \
   CONFIG.TSTRB_WIDTH {4} \
   CONFIG.TUSER_WIDTH {0} \
 ] $fifo_generator_0

  # Create instance: hier_3
  create_hier_cell_hier_3 $hier_obj hier_3

  # Create instance: util_reduced_logic_0, and set properties
  set util_reduced_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_reduced_logic_0

  # Create instance: xlconcat_3, and set properties
  set xlconcat_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_3 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $xlconcat_3

  # Create interface connections
  connect_bd_intf_net -intf_net axis_clock_converter_0_M_AXIS [get_bd_intf_pins M_AXIS_LGAIN_ADC] [get_bd_intf_pins axis_clock_converter_0/M_AXIS]
  connect_bd_intf_net -intf_net fifo_generator_0_M_AXIS [get_bd_intf_pins axis_clock_converter_0/S_AXIS] [get_bd_intf_pins fifo_generator_0/M_AXIS]

  # Create port connections
  connect_bd_net -net Din_1 [get_bd_pins hier_3/Din] [get_bd_pins xlconcat_3/dout]
  connect_bd_net -net In0_1 [get_bd_pins In0] [get_bd_pins xlconcat_3/In0]
  connect_bd_net -net In1_1 [get_bd_pins In1] [get_bd_pins xlconcat_3/In1]
  connect_bd_net -net In2_1 [get_bd_pins In2] [get_bd_pins xlconcat_3/In2]
  connect_bd_net -net In3_1 [get_bd_pins In3] [get_bd_pins xlconcat_3/In3]
  connect_bd_net -net M_ACLK_1 [get_bd_pins M_ACLK] [get_bd_pins axis_clock_converter_0/m_axis_aclk]
  connect_bd_net -net M_ARESETN_1 [get_bd_pins M_ARESETN] [get_bd_pins axis_clock_converter_0/m_axis_aresetn]
  connect_bd_net -net S_ARESETN_1 [get_bd_pins S_ARESETN] [get_bd_pins axis_clock_converter_0/s_axis_aresetn] [get_bd_pins fifo_generator_0/s_aresetn]
  connect_bd_net -net S_AXIS_ACLK_1 [get_bd_pins S_ACLK] [get_bd_pins axis_clock_converter_0/s_axis_aclk] [get_bd_pins fifo_generator_0/s_aclk]
  connect_bd_net -net empty_0_1 [get_bd_pins empty_0] [get_bd_pins empty_concat/In0]
  connect_bd_net -net empty_1_1 [get_bd_pins empty_1] [get_bd_pins empty_concat/In1]
  connect_bd_net -net empty_2_1 [get_bd_pins empty_2] [get_bd_pins empty_concat/In2]
  connect_bd_net -net empty_3_1 [get_bd_pins empty_3] [get_bd_pins empty_concat/In3]
  connect_bd_net -net empty_inverse_Res [get_bd_pins empty_inverse/Res] [get_bd_pins util_reduced_logic_0/Op1]
  connect_bd_net -net hier_3_dout_0 [get_bd_pins dout_0_2] [get_bd_pins fifo_generator_0/s_axis_tdata] [get_bd_pins hier_3/dout_0]
  connect_bd_net -net util_reduced_logic_0_Res [get_bd_pins fifo_generator_0/s_axis_tvalid] [get_bd_pins util_reduced_logic_0/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins empty_concat/dout] [get_bd_pins empty_inverse/Op1]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: lgain_adc_block_3
proc create_hier_cell_lgain_adc_block_3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_lgain_adc_block_3() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC_12

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC_13

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC_14

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC_15

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_high_speed_selectio_wiz:hssio_data_rx_rtl:1.0 xiphy_rx_pins_3


  # Create pins
  create_bd_pin -dir I M_ACLK
  create_bd_pin -dir I M_ARESETN
  create_bd_pin -dir O fifo_rd_data_valid
  create_bd_pin -dir I rst

  # Create instance: ADC_IF_TEST_3_0_B66, and set properties
  set ADC_IF_TEST_3_0_B66 [ create_bd_cell -type ip -vlnv teldevice.local:user:ADC_IF_TEST_3:1.0 ADC_IF_TEST_3_0_B66 ]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
 ] [get_bd_pins /lgain_adc_blocks/lgain_adc_block_3/ADC_IF_TEST_3_0_B66/clk]

  # Create instance: lgain_adc_12
  create_hier_cell_lgain_adc_12 $hier_obj lgain_adc_12

  # Create instance: lgain_adc_13
  create_hier_cell_lgain_adc_13 $hier_obj lgain_adc_13

  # Create instance: lgain_adc_14
  create_hier_cell_lgain_adc_14 $hier_obj lgain_adc_14

  # Create instance: lgain_adc_15
  create_hier_cell_lgain_adc_15 $hier_obj lgain_adc_15

  # Create instance: lgain_cf_replica_rst, and set properties
  set lgain_cf_replica_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 lgain_cf_replica_rst ]

  # Create instance: vio_0, and set properties
  set vio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:vio:3.0 vio_0 ]
  set_property -dict [ list \
   CONFIG.C_NUM_PROBE_IN {21} \
 ] $vio_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net lgain_adc_12_M_AXIS_LGAIN_ADC [get_bd_intf_pins M_AXIS_LGAIN_ADC_12] [get_bd_intf_pins lgain_adc_12/M_AXIS_LGAIN_ADC]
  connect_bd_intf_net -intf_net lgain_adc_13_M_AXIS_LGAIN_ADC [get_bd_intf_pins M_AXIS_LGAIN_ADC_13] [get_bd_intf_pins lgain_adc_13/M_AXIS_LGAIN_ADC]
  connect_bd_intf_net -intf_net lgain_adc_14_M_AXIS_LGAIN_ADC [get_bd_intf_pins M_AXIS_LGAIN_ADC_14] [get_bd_intf_pins lgain_adc_14/M_AXIS_LGAIN_ADC]
  connect_bd_intf_net -intf_net lgain_adc_15_M_AXIS_LGAIN_ADC [get_bd_intf_pins M_AXIS_LGAIN_ADC_15] [get_bd_intf_pins lgain_adc_15/M_AXIS_LGAIN_ADC]
  connect_bd_intf_net -intf_net xiphy_rx_pins_3_1 [get_bd_intf_pins xiphy_rx_pins_3] [get_bd_intf_pins ADC_IF_TEST_3_0_B66/xiphy_rx_pins]

  # Create port connections
  connect_bd_net -net ADC_IF_TEST_3_0_B66_bitslip_error_0 [get_bd_pins ADC_IF_TEST_3_0_B66/bitslip_error_0] [get_bd_pins vio_0/probe_in2]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_bitslip_error_4 [get_bd_pins ADC_IF_TEST_3_0_B66/bitslip_error_4] [get_bd_pins vio_0/probe_in0]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_bitslip_error_6 [get_bd_pins ADC_IF_TEST_3_0_B66/bitslip_error_6] [get_bd_pins vio_0/probe_in3]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_bitslip_error_8 [get_bd_pins ADC_IF_TEST_3_0_B66/bitslip_error_8] [get_bd_pins vio_0/probe_in4]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_bitslip_error_10 [get_bd_pins ADC_IF_TEST_3_0_B66/bitslip_error_10] [get_bd_pins vio_0/probe_in5]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_bitslip_error_13 [get_bd_pins ADC_IF_TEST_3_0_B66/bitslip_error_13] [get_bd_pins vio_0/probe_in6]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_bitslip_error_17 [get_bd_pins ADC_IF_TEST_3_0_B66/bitslip_error_17] [get_bd_pins vio_0/probe_in7]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_bitslip_error_19 [get_bd_pins ADC_IF_TEST_3_0_B66/bitslip_error_19] [get_bd_pins vio_0/probe_in8]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_bitslip_error_21 [get_bd_pins ADC_IF_TEST_3_0_B66/bitslip_error_21] [get_bd_pins vio_0/probe_in9]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_bitslip_error_23 [get_bd_pins ADC_IF_TEST_3_0_B66/bitslip_error_23] [get_bd_pins vio_0/probe_in10]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_bitslip_error_26 [get_bd_pins ADC_IF_TEST_3_0_B66/bitslip_error_26] [get_bd_pins vio_0/probe_in1]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_bitslip_error_30 [get_bd_pins ADC_IF_TEST_3_0_B66/bitslip_error_30] [get_bd_pins vio_0/probe_in11]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_bitslip_error_32 [get_bd_pins ADC_IF_TEST_3_0_B66/bitslip_error_32] [get_bd_pins vio_0/probe_in12]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_bitslip_error_34 [get_bd_pins ADC_IF_TEST_3_0_B66/bitslip_error_34] [get_bd_pins vio_0/probe_in13]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_bitslip_error_36 [get_bd_pins ADC_IF_TEST_3_0_B66/bitslip_error_36] [get_bd_pins vio_0/probe_in14]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_bitslip_error_39 [get_bd_pins ADC_IF_TEST_3_0_B66/bitslip_error_39] [get_bd_pins vio_0/probe_in15]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_bitslip_error_43 [get_bd_pins ADC_IF_TEST_3_0_B66/bitslip_error_43] [get_bd_pins vio_0/probe_in16]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_bitslip_error_45 [get_bd_pins ADC_IF_TEST_3_0_B66/bitslip_error_45] [get_bd_pins vio_0/probe_in17]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_bitslip_error_47 [get_bd_pins ADC_IF_TEST_3_0_B66/bitslip_error_47] [get_bd_pins vio_0/probe_in18]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_bitslip_error_49 [get_bd_pins ADC_IF_TEST_3_0_B66/bitslip_error_49] [get_bd_pins vio_0/probe_in19]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_data_to_fabric_b66_bg0_pin10_10 [get_bd_pins ADC_IF_TEST_3_0_B66/data_to_fabric_b66_bg0_pin10_10] [get_bd_pins lgain_adc_12/In1]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_data_to_fabric_b66_bg0_pin4_4 [get_bd_pins ADC_IF_TEST_3_0_B66/data_to_fabric_b66_bg0_pin4_4] [get_bd_pins lgain_adc_12/In3]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_data_to_fabric_b66_bg0_pin6_6 [get_bd_pins ADC_IF_TEST_3_0_B66/data_to_fabric_b66_bg0_pin6_6] [get_bd_pins lgain_adc_12/In2]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_data_to_fabric_b66_bg0_pin8_8 [get_bd_pins ADC_IF_TEST_3_0_B66/data_to_fabric_b66_bg0_pin8_8] [get_bd_pins lgain_adc_12/In0]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_data_to_fabric_b66_bg1_pin10_23 [get_bd_pins ADC_IF_TEST_3_0_B66/data_to_fabric_b66_bg1_pin10_23] [get_bd_pins lgain_adc_14/In0]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_data_to_fabric_b66_bg1_pin4_17 [get_bd_pins ADC_IF_TEST_3_0_B66/data_to_fabric_b66_bg1_pin4_17] [get_bd_pins lgain_adc_14/In1]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_data_to_fabric_b66_bg1_pin6_19 [get_bd_pins ADC_IF_TEST_3_0_B66/data_to_fabric_b66_bg1_pin6_19] [get_bd_pins lgain_adc_14/In3]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_data_to_fabric_b66_bg1_pin8_21 [get_bd_pins ADC_IF_TEST_3_0_B66/data_to_fabric_b66_bg1_pin8_21] [get_bd_pins lgain_adc_14/In2]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_data_to_fabric_b66_bg2_pin10_36 [get_bd_pins ADC_IF_TEST_3_0_B66/data_to_fabric_b66_bg2_pin10_36] [get_bd_pins lgain_adc_13/In0]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_data_to_fabric_b66_bg2_pin4_30 [get_bd_pins ADC_IF_TEST_3_0_B66/data_to_fabric_b66_bg2_pin4_30] [get_bd_pins lgain_adc_13/In2]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_data_to_fabric_b66_bg2_pin6_32 [get_bd_pins ADC_IF_TEST_3_0_B66/data_to_fabric_b66_bg2_pin6_32] [get_bd_pins lgain_adc_13/In1]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_data_to_fabric_b66_bg2_pin8_34 [get_bd_pins ADC_IF_TEST_3_0_B66/data_to_fabric_b66_bg2_pin8_34] [get_bd_pins lgain_adc_13/In3]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_data_to_fabric_b66_bg3_pin10_49 [get_bd_pins ADC_IF_TEST_3_0_B66/data_to_fabric_b66_bg3_pin10_49] [get_bd_pins lgain_adc_15/In1]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_data_to_fabric_b66_bg3_pin4_43 [get_bd_pins ADC_IF_TEST_3_0_B66/data_to_fabric_b66_bg3_pin4_43] [get_bd_pins lgain_adc_15/In3]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_data_to_fabric_b66_bg3_pin6_45 [get_bd_pins ADC_IF_TEST_3_0_B66/data_to_fabric_b66_bg3_pin6_45] [get_bd_pins lgain_adc_15/In0]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_data_to_fabric_b66_bg3_pin8_47 [get_bd_pins ADC_IF_TEST_3_0_B66/data_to_fabric_b66_bg3_pin8_47] [get_bd_pins lgain_adc_15/In2]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_fifo_empty_4 [get_bd_pins ADC_IF_TEST_3_0_B66/fifo_empty_4] [get_bd_pins lgain_adc_12/empty_0]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_fifo_empty_6 [get_bd_pins ADC_IF_TEST_3_0_B66/fifo_empty_6] [get_bd_pins lgain_adc_12/empty_1]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_fifo_empty_8 [get_bd_pins ADC_IF_TEST_3_0_B66/fifo_empty_8] [get_bd_pins lgain_adc_12/empty_2]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_fifo_empty_10 [get_bd_pins ADC_IF_TEST_3_0_B66/fifo_empty_10] [get_bd_pins lgain_adc_12/empty_3]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_fifo_empty_17 [get_bd_pins ADC_IF_TEST_3_0_B66/fifo_empty_17] [get_bd_pins lgain_adc_14/empty_0]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_fifo_empty_19 [get_bd_pins ADC_IF_TEST_3_0_B66/fifo_empty_19] [get_bd_pins lgain_adc_14/empty_1]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_fifo_empty_21 [get_bd_pins ADC_IF_TEST_3_0_B66/fifo_empty_21] [get_bd_pins lgain_adc_14/empty_2]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_fifo_empty_23 [get_bd_pins ADC_IF_TEST_3_0_B66/fifo_empty_23] [get_bd_pins lgain_adc_14/empty_3]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_fifo_empty_30 [get_bd_pins ADC_IF_TEST_3_0_B66/fifo_empty_30] [get_bd_pins lgain_adc_13/empty_0]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_fifo_empty_32 [get_bd_pins ADC_IF_TEST_3_0_B66/fifo_empty_32] [get_bd_pins lgain_adc_13/empty_1]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_fifo_empty_34 [get_bd_pins ADC_IF_TEST_3_0_B66/fifo_empty_34] [get_bd_pins lgain_adc_13/empty_2]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_fifo_empty_36 [get_bd_pins ADC_IF_TEST_3_0_B66/fifo_empty_36] [get_bd_pins lgain_adc_13/empty_3]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_fifo_empty_43 [get_bd_pins ADC_IF_TEST_3_0_B66/fifo_empty_43] [get_bd_pins lgain_adc_15/empty_0]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_fifo_empty_45 [get_bd_pins ADC_IF_TEST_3_0_B66/fifo_empty_45] [get_bd_pins lgain_adc_15/empty_1]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_fifo_empty_47 [get_bd_pins ADC_IF_TEST_3_0_B66/fifo_empty_47] [get_bd_pins lgain_adc_15/empty_2]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_fifo_empty_49 [get_bd_pins ADC_IF_TEST_3_0_B66/fifo_empty_49] [get_bd_pins lgain_adc_15/empty_3]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_fifo_rd_data_valid [get_bd_pins fifo_rd_data_valid] [get_bd_pins ADC_IF_TEST_3_0_B66/fifo_rd_data_valid]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_pll0_locked [get_bd_pins ADC_IF_TEST_3_0_B66/pll0_locked] [get_bd_pins lgain_cf_replica_rst/ext_reset_in]
  connect_bd_net -net ADC_IF_TEST_3_0_B66_rx_bitslip_sync_done [get_bd_pins ADC_IF_TEST_3_0_B66/rx_bitslip_sync_done] [get_bd_pins vio_0/probe_in20]
  connect_bd_net -net ADC_IF_TEST_3_0_pll0_clkout0 [get_bd_pins ADC_IF_TEST_3_0_B66/fifo_rd_clk_0] [get_bd_pins ADC_IF_TEST_3_0_B66/fifo_rd_clk_4] [get_bd_pins ADC_IF_TEST_3_0_B66/fifo_rd_clk_6] [get_bd_pins ADC_IF_TEST_3_0_B66/fifo_rd_clk_8] [get_bd_pins ADC_IF_TEST_3_0_B66/fifo_rd_clk_10] [get_bd_pins ADC_IF_TEST_3_0_B66/fifo_rd_clk_13] [get_bd_pins ADC_IF_TEST_3_0_B66/fifo_rd_clk_17] [get_bd_pins ADC_IF_TEST_3_0_B66/fifo_rd_clk_19] [get_bd_pins ADC_IF_TEST_3_0_B66/fifo_rd_clk_21] [get_bd_pins ADC_IF_TEST_3_0_B66/fifo_rd_clk_23] [get_bd_pins ADC_IF_TEST_3_0_B66/fifo_rd_clk_26] [get_bd_pins ADC_IF_TEST_3_0_B66/fifo_rd_clk_30] [get_bd_pins ADC_IF_TEST_3_0_B66/fifo_rd_clk_32] [get_bd_pins ADC_IF_TEST_3_0_B66/fifo_rd_clk_34] [get_bd_pins ADC_IF_TEST_3_0_B66/fifo_rd_clk_36] [get_bd_pins ADC_IF_TEST_3_0_B66/fifo_rd_clk_39] [get_bd_pins ADC_IF_TEST_3_0_B66/fifo_rd_clk_43] [get_bd_pins ADC_IF_TEST_3_0_B66/fifo_rd_clk_45] [get_bd_pins ADC_IF_TEST_3_0_B66/fifo_rd_clk_47] [get_bd_pins ADC_IF_TEST_3_0_B66/fifo_rd_clk_49] [get_bd_pins ADC_IF_TEST_3_0_B66/pll0_clkout0] [get_bd_pins lgain_adc_12/S_ACLK] [get_bd_pins lgain_adc_13/S_ACLK] [get_bd_pins lgain_adc_14/S_ACLK] [get_bd_pins lgain_adc_15/S_ACLK] [get_bd_pins lgain_cf_replica_rst/slowest_sync_clk]
  connect_bd_net -net M_ACLK_1 [get_bd_pins M_ACLK] [get_bd_pins ADC_IF_TEST_3_0_B66/clk] [get_bd_pins lgain_adc_12/M_ACLK] [get_bd_pins lgain_adc_13/M_ACLK] [get_bd_pins lgain_adc_14/M_ACLK] [get_bd_pins lgain_adc_15/M_ACLK] [get_bd_pins vio_0/clk]
  connect_bd_net -net M_ARESETN_1 [get_bd_pins M_ARESETN] [get_bd_pins lgain_adc_12/M_ARESETN] [get_bd_pins lgain_adc_13/M_ARESETN] [get_bd_pins lgain_adc_14/M_ARESETN] [get_bd_pins lgain_adc_15/M_ARESETN]
  connect_bd_net -net en_vtc_bsc0_1 [get_bd_pins ADC_IF_TEST_3_0_B66/en_vtc_bsc0] [get_bd_pins ADC_IF_TEST_3_0_B66/en_vtc_bsc1] [get_bd_pins ADC_IF_TEST_3_0_B66/en_vtc_bsc2] [get_bd_pins ADC_IF_TEST_3_0_B66/en_vtc_bsc3] [get_bd_pins ADC_IF_TEST_3_0_B66/en_vtc_bsc4] [get_bd_pins ADC_IF_TEST_3_0_B66/en_vtc_bsc5] [get_bd_pins ADC_IF_TEST_3_0_B66/en_vtc_bsc6] [get_bd_pins ADC_IF_TEST_3_0_B66/en_vtc_bsc7] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net lgain_cf_replica_rst_peripheral_aresetn [get_bd_pins lgain_adc_12/S_ARESETN] [get_bd_pins lgain_adc_13/S_ARESETN] [get_bd_pins lgain_adc_14/S_ARESETN] [get_bd_pins lgain_adc_15/S_ARESETN] [get_bd_pins lgain_cf_replica_rst/peripheral_aresetn]
  connect_bd_net -net rst_1 [get_bd_pins rst] [get_bd_pins ADC_IF_TEST_3_0_B66/rst]
  connect_bd_net -net vio_0_probe_out0 [get_bd_pins ADC_IF_TEST_3_0_B66/start_bitslip] [get_bd_pins vio_0/probe_out0]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: lgain_adc_block_2
proc create_hier_cell_lgain_adc_block_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_lgain_adc_block_2() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC_8

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC_9

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC_10

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC_11

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_high_speed_selectio_wiz:hssio_data_rx_rtl:1.0 xiphy_rx_pins_2


  # Create pins
  create_bd_pin -dir I M_ACLK
  create_bd_pin -dir I M_ARESETN
  create_bd_pin -dir O fifo_rd_data_valid
  create_bd_pin -dir I rst

  # Create instance: ADC_IF_TEST_2_0_B65, and set properties
  set ADC_IF_TEST_2_0_B65 [ create_bd_cell -type ip -vlnv teldevice.local:user:ADC_IF_TEST_2:1.0 ADC_IF_TEST_2_0_B65 ]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
 ] [get_bd_pins /lgain_adc_blocks/lgain_adc_block_2/ADC_IF_TEST_2_0_B65/clk]

  # Create instance: lgain_8b_replica_rst, and set properties
  set lgain_8b_replica_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 lgain_8b_replica_rst ]

  # Create instance: lgain_adc_8
  create_hier_cell_lgain_adc_8 $hier_obj lgain_adc_8

  # Create instance: lgain_adc_9
  create_hier_cell_lgain_adc_9 $hier_obj lgain_adc_9

  # Create instance: lgain_adc_10
  create_hier_cell_lgain_adc_10 $hier_obj lgain_adc_10

  # Create instance: lgain_adc_11
  create_hier_cell_lgain_adc_11 $hier_obj lgain_adc_11

  # Create instance: vio_0, and set properties
  set vio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:vio:3.0 vio_0 ]
  set_property -dict [ list \
   CONFIG.C_NUM_PROBE_IN {21} \
 ] $vio_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net lgain_adc_10_M_AXIS_LGAIN_ADC [get_bd_intf_pins M_AXIS_LGAIN_ADC_10] [get_bd_intf_pins lgain_adc_10/M_AXIS_LGAIN_ADC]
  connect_bd_intf_net -intf_net lgain_adc_11_M_AXIS_LGAIN_ADC [get_bd_intf_pins M_AXIS_LGAIN_ADC_11] [get_bd_intf_pins lgain_adc_11/M_AXIS_LGAIN_ADC]
  connect_bd_intf_net -intf_net lgain_adc_8_M_AXIS_LGAIN_ADC [get_bd_intf_pins M_AXIS_LGAIN_ADC_8] [get_bd_intf_pins lgain_adc_8/M_AXIS_LGAIN_ADC]
  connect_bd_intf_net -intf_net lgain_adc_9_M_AXIS_LGAIN_ADC [get_bd_intf_pins M_AXIS_LGAIN_ADC_9] [get_bd_intf_pins lgain_adc_9/M_AXIS_LGAIN_ADC]
  connect_bd_intf_net -intf_net xiphy_rx_pins_2_1 [get_bd_intf_pins xiphy_rx_pins_2] [get_bd_intf_pins ADC_IF_TEST_2_0_B65/xiphy_rx_pins]

  # Create port connections
  connect_bd_net -net ADC_IF_TEST_2_0_B65_bitslip_error_0 [get_bd_pins ADC_IF_TEST_2_0_B65/bitslip_error_0] [get_bd_pins vio_0/probe_in2]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_bitslip_error_4 [get_bd_pins ADC_IF_TEST_2_0_B65/bitslip_error_4] [get_bd_pins vio_0/probe_in0]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_bitslip_error_6 [get_bd_pins ADC_IF_TEST_2_0_B65/bitslip_error_6] [get_bd_pins vio_0/probe_in3]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_bitslip_error_8 [get_bd_pins ADC_IF_TEST_2_0_B65/bitslip_error_8] [get_bd_pins vio_0/probe_in4]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_bitslip_error_10 [get_bd_pins ADC_IF_TEST_2_0_B65/bitslip_error_10] [get_bd_pins vio_0/probe_in5]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_bitslip_error_13 [get_bd_pins ADC_IF_TEST_2_0_B65/bitslip_error_13] [get_bd_pins vio_0/probe_in6]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_bitslip_error_17 [get_bd_pins ADC_IF_TEST_2_0_B65/bitslip_error_17] [get_bd_pins vio_0/probe_in7]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_bitslip_error_19 [get_bd_pins ADC_IF_TEST_2_0_B65/bitslip_error_19] [get_bd_pins vio_0/probe_in8]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_bitslip_error_21 [get_bd_pins ADC_IF_TEST_2_0_B65/bitslip_error_21] [get_bd_pins vio_0/probe_in9]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_bitslip_error_23 [get_bd_pins ADC_IF_TEST_2_0_B65/bitslip_error_23] [get_bd_pins vio_0/probe_in10]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_bitslip_error_26 [get_bd_pins ADC_IF_TEST_2_0_B65/bitslip_error_26] [get_bd_pins vio_0/probe_in1]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_bitslip_error_30 [get_bd_pins ADC_IF_TEST_2_0_B65/bitslip_error_30] [get_bd_pins vio_0/probe_in11]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_bitslip_error_32 [get_bd_pins ADC_IF_TEST_2_0_B65/bitslip_error_32] [get_bd_pins vio_0/probe_in12]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_bitslip_error_34 [get_bd_pins ADC_IF_TEST_2_0_B65/bitslip_error_34] [get_bd_pins vio_0/probe_in13]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_bitslip_error_36 [get_bd_pins ADC_IF_TEST_2_0_B65/bitslip_error_36] [get_bd_pins vio_0/probe_in14]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_bitslip_error_39 [get_bd_pins ADC_IF_TEST_2_0_B65/bitslip_error_39] [get_bd_pins vio_0/probe_in15]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_bitslip_error_43 [get_bd_pins ADC_IF_TEST_2_0_B65/bitslip_error_43] [get_bd_pins vio_0/probe_in16]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_bitslip_error_45 [get_bd_pins ADC_IF_TEST_2_0_B65/bitslip_error_45] [get_bd_pins vio_0/probe_in17]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_bitslip_error_47 [get_bd_pins ADC_IF_TEST_2_0_B65/bitslip_error_47] [get_bd_pins vio_0/probe_in18]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_bitslip_error_49 [get_bd_pins ADC_IF_TEST_2_0_B65/bitslip_error_49] [get_bd_pins vio_0/probe_in19]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_data_to_fabric_b65_bg0_pin10_10 [get_bd_pins ADC_IF_TEST_2_0_B65/data_to_fabric_b65_bg0_pin10_10] [get_bd_pins lgain_adc_11/In1]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_data_to_fabric_b65_bg0_pin4_4 [get_bd_pins ADC_IF_TEST_2_0_B65/data_to_fabric_b65_bg0_pin4_4] [get_bd_pins lgain_adc_11/In2]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_data_to_fabric_b65_bg0_pin6_6 [get_bd_pins ADC_IF_TEST_2_0_B65/data_to_fabric_b65_bg0_pin6_6] [get_bd_pins lgain_adc_11/In0]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_data_to_fabric_b65_bg0_pin8_8 [get_bd_pins ADC_IF_TEST_2_0_B65/data_to_fabric_b65_bg0_pin8_8] [get_bd_pins lgain_adc_11/In3]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_data_to_fabric_b65_bg1_pin10_23 [get_bd_pins ADC_IF_TEST_2_0_B65/data_to_fabric_b65_bg1_pin10_23] [get_bd_pins lgain_adc_10/In0]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_data_to_fabric_b65_bg1_pin4_17 [get_bd_pins ADC_IF_TEST_2_0_B65/data_to_fabric_b65_bg1_pin4_17] [get_bd_pins lgain_adc_10/In3]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_data_to_fabric_b65_bg1_pin6_19 [get_bd_pins ADC_IF_TEST_2_0_B65/data_to_fabric_b65_bg1_pin6_19] [get_bd_pins lgain_adc_10/In2]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_data_to_fabric_b65_bg1_pin8_21 [get_bd_pins ADC_IF_TEST_2_0_B65/data_to_fabric_b65_bg1_pin8_21] [get_bd_pins lgain_adc_10/In1]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_data_to_fabric_b65_bg2_pin10_36 [get_bd_pins ADC_IF_TEST_2_0_B65/data_to_fabric_b65_bg2_pin10_36] [get_bd_pins lgain_adc_9/In0]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_data_to_fabric_b65_bg2_pin4_30 [get_bd_pins ADC_IF_TEST_2_0_B65/data_to_fabric_b65_bg2_pin4_30] [get_bd_pins lgain_adc_9/In3]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_data_to_fabric_b65_bg2_pin6_32 [get_bd_pins ADC_IF_TEST_2_0_B65/data_to_fabric_b65_bg2_pin6_32] [get_bd_pins lgain_adc_9/In1]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_data_to_fabric_b65_bg2_pin8_34 [get_bd_pins ADC_IF_TEST_2_0_B65/data_to_fabric_b65_bg2_pin8_34] [get_bd_pins lgain_adc_9/In2]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_data_to_fabric_b65_bg3_pin10_49 [get_bd_pins ADC_IF_TEST_2_0_B65/data_to_fabric_b65_bg3_pin10_49] [get_bd_pins lgain_adc_8/In3]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_data_to_fabric_b65_bg3_pin4_43 [get_bd_pins ADC_IF_TEST_2_0_B65/data_to_fabric_b65_bg3_pin4_43] [get_bd_pins lgain_adc_8/In0]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_data_to_fabric_b65_bg3_pin6_45 [get_bd_pins ADC_IF_TEST_2_0_B65/data_to_fabric_b65_bg3_pin6_45] [get_bd_pins lgain_adc_8/In2]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_data_to_fabric_b65_bg3_pin8_47 [get_bd_pins ADC_IF_TEST_2_0_B65/data_to_fabric_b65_bg3_pin8_47] [get_bd_pins lgain_adc_8/In1]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_fifo_empty_4 [get_bd_pins ADC_IF_TEST_2_0_B65/fifo_empty_4] [get_bd_pins lgain_adc_11/empty_0]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_fifo_empty_6 [get_bd_pins ADC_IF_TEST_2_0_B65/fifo_empty_6] [get_bd_pins lgain_adc_11/empty_1]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_fifo_empty_8 [get_bd_pins ADC_IF_TEST_2_0_B65/fifo_empty_8] [get_bd_pins lgain_adc_11/empty_2]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_fifo_empty_10 [get_bd_pins ADC_IF_TEST_2_0_B65/fifo_empty_10] [get_bd_pins lgain_adc_11/empty_3]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_fifo_empty_17 [get_bd_pins ADC_IF_TEST_2_0_B65/fifo_empty_17] [get_bd_pins lgain_adc_10/empty_0]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_fifo_empty_19 [get_bd_pins ADC_IF_TEST_2_0_B65/fifo_empty_19] [get_bd_pins lgain_adc_10/empty_1]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_fifo_empty_21 [get_bd_pins ADC_IF_TEST_2_0_B65/fifo_empty_21] [get_bd_pins lgain_adc_10/empty_2]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_fifo_empty_23 [get_bd_pins ADC_IF_TEST_2_0_B65/fifo_empty_23] [get_bd_pins lgain_adc_10/empty_3]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_fifo_empty_30 [get_bd_pins ADC_IF_TEST_2_0_B65/fifo_empty_30] [get_bd_pins lgain_adc_9/empty_0]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_fifo_empty_32 [get_bd_pins ADC_IF_TEST_2_0_B65/fifo_empty_32] [get_bd_pins lgain_adc_9/empty_1]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_fifo_empty_34 [get_bd_pins ADC_IF_TEST_2_0_B65/fifo_empty_34] [get_bd_pins lgain_adc_9/empty_2]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_fifo_empty_36 [get_bd_pins ADC_IF_TEST_2_0_B65/fifo_empty_36] [get_bd_pins lgain_adc_9/empty_3]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_fifo_empty_43 [get_bd_pins ADC_IF_TEST_2_0_B65/fifo_empty_43] [get_bd_pins lgain_adc_8/empty_0]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_fifo_empty_45 [get_bd_pins ADC_IF_TEST_2_0_B65/fifo_empty_45] [get_bd_pins lgain_adc_8/empty_1]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_fifo_empty_47 [get_bd_pins ADC_IF_TEST_2_0_B65/fifo_empty_47] [get_bd_pins lgain_adc_8/empty_2]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_fifo_empty_49 [get_bd_pins ADC_IF_TEST_2_0_B65/fifo_empty_49] [get_bd_pins lgain_adc_8/empty_3]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_fifo_rd_data_valid [get_bd_pins fifo_rd_data_valid] [get_bd_pins ADC_IF_TEST_2_0_B65/fifo_rd_data_valid]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_pll0_clkout0 [get_bd_pins ADC_IF_TEST_2_0_B65/fifo_rd_clk_0] [get_bd_pins ADC_IF_TEST_2_0_B65/fifo_rd_clk_4] [get_bd_pins ADC_IF_TEST_2_0_B65/fifo_rd_clk_6] [get_bd_pins ADC_IF_TEST_2_0_B65/fifo_rd_clk_8] [get_bd_pins ADC_IF_TEST_2_0_B65/fifo_rd_clk_10] [get_bd_pins ADC_IF_TEST_2_0_B65/fifo_rd_clk_13] [get_bd_pins ADC_IF_TEST_2_0_B65/fifo_rd_clk_17] [get_bd_pins ADC_IF_TEST_2_0_B65/fifo_rd_clk_19] [get_bd_pins ADC_IF_TEST_2_0_B65/fifo_rd_clk_21] [get_bd_pins ADC_IF_TEST_2_0_B65/fifo_rd_clk_23] [get_bd_pins ADC_IF_TEST_2_0_B65/fifo_rd_clk_26] [get_bd_pins ADC_IF_TEST_2_0_B65/fifo_rd_clk_30] [get_bd_pins ADC_IF_TEST_2_0_B65/fifo_rd_clk_32] [get_bd_pins ADC_IF_TEST_2_0_B65/fifo_rd_clk_34] [get_bd_pins ADC_IF_TEST_2_0_B65/fifo_rd_clk_36] [get_bd_pins ADC_IF_TEST_2_0_B65/fifo_rd_clk_39] [get_bd_pins ADC_IF_TEST_2_0_B65/fifo_rd_clk_43] [get_bd_pins ADC_IF_TEST_2_0_B65/fifo_rd_clk_45] [get_bd_pins ADC_IF_TEST_2_0_B65/fifo_rd_clk_47] [get_bd_pins ADC_IF_TEST_2_0_B65/fifo_rd_clk_49] [get_bd_pins ADC_IF_TEST_2_0_B65/pll0_clkout0] [get_bd_pins lgain_8b_replica_rst/slowest_sync_clk] [get_bd_pins lgain_adc_10/S_ACLK] [get_bd_pins lgain_adc_11/S_ACLK] [get_bd_pins lgain_adc_8/S_ACLK] [get_bd_pins lgain_adc_9/S_ACLK]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_pll0_locked [get_bd_pins ADC_IF_TEST_2_0_B65/pll0_locked] [get_bd_pins lgain_8b_replica_rst/ext_reset_in]
  connect_bd_net -net ADC_IF_TEST_2_0_B65_rx_bitslip_sync_done [get_bd_pins ADC_IF_TEST_2_0_B65/rx_bitslip_sync_done] [get_bd_pins vio_0/probe_in20]
  connect_bd_net -net M_ACLK_1 [get_bd_pins M_ACLK] [get_bd_pins ADC_IF_TEST_2_0_B65/clk] [get_bd_pins lgain_adc_10/M_ACLK] [get_bd_pins lgain_adc_11/M_ACLK] [get_bd_pins lgain_adc_8/M_ACLK] [get_bd_pins lgain_adc_9/M_ACLK] [get_bd_pins vio_0/clk]
  connect_bd_net -net M_ARESETN_1 [get_bd_pins M_ARESETN] [get_bd_pins lgain_adc_10/M_ARESETN] [get_bd_pins lgain_adc_11/M_ARESETN] [get_bd_pins lgain_adc_8/M_ARESETN] [get_bd_pins lgain_adc_9/M_ARESETN]
  connect_bd_net -net en_vtc_bsc0_1 [get_bd_pins ADC_IF_TEST_2_0_B65/en_vtc_bsc0] [get_bd_pins ADC_IF_TEST_2_0_B65/en_vtc_bsc1] [get_bd_pins ADC_IF_TEST_2_0_B65/en_vtc_bsc2] [get_bd_pins ADC_IF_TEST_2_0_B65/en_vtc_bsc3] [get_bd_pins ADC_IF_TEST_2_0_B65/en_vtc_bsc4] [get_bd_pins ADC_IF_TEST_2_0_B65/en_vtc_bsc5] [get_bd_pins ADC_IF_TEST_2_0_B65/en_vtc_bsc6] [get_bd_pins ADC_IF_TEST_2_0_B65/en_vtc_bsc7] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net lgain_8b_replica_rst_peripheral_aresetn [get_bd_pins lgain_8b_replica_rst/peripheral_aresetn] [get_bd_pins lgain_adc_10/S_ARESETN] [get_bd_pins lgain_adc_11/S_ARESETN] [get_bd_pins lgain_adc_8/S_ARESETN] [get_bd_pins lgain_adc_9/S_ARESETN]
  connect_bd_net -net rst_1 [get_bd_pins rst] [get_bd_pins ADC_IF_TEST_2_0_B65/rst]
  connect_bd_net -net vio_0_probe_out0 [get_bd_pins ADC_IF_TEST_2_0_B65/start_bitslip] [get_bd_pins vio_0/probe_out0]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: lgain_adc_block_1
proc create_hier_cell_lgain_adc_block_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_lgain_adc_block_1() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC_4

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC_5

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC_6

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC_7

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_high_speed_selectio_wiz:hssio_data_rx_rtl:1.0 xiphy_rx_pins_1


  # Create pins
  create_bd_pin -dir I M_ACLK
  create_bd_pin -dir I M_ARESETN
  create_bd_pin -dir O fifo_rd_data_valid
  create_bd_pin -dir I rst

  # Create instance: ADC_IF_TEST_1_0_B64, and set properties
  set ADC_IF_TEST_1_0_B64 [ create_bd_cell -type ip -vlnv teldevice.local:user:ADC_IF_TEST_1:1.0 ADC_IF_TEST_1_0_B64 ]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
 ] [get_bd_pins /lgain_adc_blocks/lgain_adc_block_1/ADC_IF_TEST_1_0_B64/clk]

  # Create instance: lgain_47_replica_rst, and set properties
  set lgain_47_replica_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 lgain_47_replica_rst ]

  # Create instance: lgain_adc_4
  create_hier_cell_lgain_adc_4 $hier_obj lgain_adc_4

  # Create instance: lgain_adc_5
  create_hier_cell_lgain_adc_5 $hier_obj lgain_adc_5

  # Create instance: lgain_adc_6
  create_hier_cell_lgain_adc_6 $hier_obj lgain_adc_6

  # Create instance: lgain_adc_7
  create_hier_cell_lgain_adc_7 $hier_obj lgain_adc_7

  # Create instance: vio_0, and set properties
  set vio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:vio:3.0 vio_0 ]
  set_property -dict [ list \
   CONFIG.C_NUM_PROBE_IN {21} \
 ] $vio_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net lgain_adc_4_M_AXIS_LGAIN_ADC [get_bd_intf_pins M_AXIS_LGAIN_ADC_4] [get_bd_intf_pins lgain_adc_4/M_AXIS_LGAIN_ADC]
  connect_bd_intf_net -intf_net lgain_adc_5_M_AXIS_LGAIN_ADC [get_bd_intf_pins M_AXIS_LGAIN_ADC_5] [get_bd_intf_pins lgain_adc_5/M_AXIS_LGAIN_ADC]
  connect_bd_intf_net -intf_net lgain_adc_6_M_AXIS_LGAIN_ADC [get_bd_intf_pins M_AXIS_LGAIN_ADC_6] [get_bd_intf_pins lgain_adc_6/M_AXIS_LGAIN_ADC]
  connect_bd_intf_net -intf_net lgain_adc_7_M_AXIS_LGAIN_ADC [get_bd_intf_pins M_AXIS_LGAIN_ADC_7] [get_bd_intf_pins lgain_adc_7/M_AXIS_LGAIN_ADC]
  connect_bd_intf_net -intf_net xiphy_rx_pins_1_1 [get_bd_intf_pins xiphy_rx_pins_1] [get_bd_intf_pins ADC_IF_TEST_1_0_B64/xiphy_rx_pins]

  # Create port connections
  connect_bd_net -net ADC_IF_TEST_1_0_B64_bitslip_error_0 [get_bd_pins ADC_IF_TEST_1_0_B64/bitslip_error_0] [get_bd_pins vio_0/probe_in2]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_bitslip_error_2 [get_bd_pins ADC_IF_TEST_1_0_B64/bitslip_error_2] [get_bd_pins vio_0/probe_in3]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_bitslip_error_4 [get_bd_pins ADC_IF_TEST_1_0_B64/bitslip_error_4] [get_bd_pins vio_0/probe_in0]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_bitslip_error_6 [get_bd_pins ADC_IF_TEST_1_0_B64/bitslip_error_6] [get_bd_pins vio_0/probe_in4]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_bitslip_error_8 [get_bd_pins ADC_IF_TEST_1_0_B64/bitslip_error_8] [get_bd_pins vio_0/probe_in5]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_bitslip_error_13 [get_bd_pins ADC_IF_TEST_1_0_B64/bitslip_error_13] [get_bd_pins vio_0/probe_in6]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_bitslip_error_17 [get_bd_pins ADC_IF_TEST_1_0_B64/bitslip_error_17] [get_bd_pins vio_0/probe_in7]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_bitslip_error_19 [get_bd_pins ADC_IF_TEST_1_0_B64/bitslip_error_19] [get_bd_pins vio_0/probe_in8]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_bitslip_error_21 [get_bd_pins ADC_IF_TEST_1_0_B64/bitslip_error_21] [get_bd_pins vio_0/probe_in9]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_bitslip_error_23 [get_bd_pins ADC_IF_TEST_1_0_B64/bitslip_error_23] [get_bd_pins vio_0/probe_in10]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_bitslip_error_26 [get_bd_pins ADC_IF_TEST_1_0_B64/bitslip_error_26] [get_bd_pins vio_0/probe_in1]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_bitslip_error_30 [get_bd_pins ADC_IF_TEST_1_0_B64/bitslip_error_30] [get_bd_pins vio_0/probe_in11]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_bitslip_error_32 [get_bd_pins ADC_IF_TEST_1_0_B64/bitslip_error_32] [get_bd_pins vio_0/probe_in12]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_bitslip_error_34 [get_bd_pins ADC_IF_TEST_1_0_B64/bitslip_error_34] [get_bd_pins vio_0/probe_in13]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_bitslip_error_36 [get_bd_pins ADC_IF_TEST_1_0_B64/bitslip_error_36] [get_bd_pins vio_0/probe_in14]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_bitslip_error_39 [get_bd_pins ADC_IF_TEST_1_0_B64/bitslip_error_39] [get_bd_pins vio_0/probe_in15]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_bitslip_error_43 [get_bd_pins ADC_IF_TEST_1_0_B64/bitslip_error_43] [get_bd_pins vio_0/probe_in16]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_bitslip_error_45 [get_bd_pins ADC_IF_TEST_1_0_B64/bitslip_error_45] [get_bd_pins vio_0/probe_in17]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_bitslip_error_47 [get_bd_pins ADC_IF_TEST_1_0_B64/bitslip_error_47] [get_bd_pins vio_0/probe_in18]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_bitslip_error_49 [get_bd_pins ADC_IF_TEST_1_0_B64/bitslip_error_49] [get_bd_pins vio_0/probe_in19]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_data_to_fabric_b64_bg0_pin2_2 [get_bd_pins ADC_IF_TEST_1_0_B64/data_to_fabric_b64_bg0_pin2_2] [get_bd_pins lgain_adc_7/In3]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_data_to_fabric_b64_bg0_pin4_4 [get_bd_pins ADC_IF_TEST_1_0_B64/data_to_fabric_b64_bg0_pin4_4] [get_bd_pins lgain_adc_7/In1]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_data_to_fabric_b64_bg0_pin6_6 [get_bd_pins ADC_IF_TEST_1_0_B64/data_to_fabric_b64_bg0_pin6_6] [get_bd_pins lgain_adc_7/In2]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_data_to_fabric_b64_bg0_pin8_8 [get_bd_pins ADC_IF_TEST_1_0_B64/data_to_fabric_b64_bg0_pin8_8] [get_bd_pins lgain_adc_7/In0]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_data_to_fabric_b64_bg1_pin10_23 [get_bd_pins ADC_IF_TEST_1_0_B64/data_to_fabric_b64_bg1_pin10_23] [get_bd_pins lgain_adc_6/In2]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_data_to_fabric_b64_bg1_pin4_17 [get_bd_pins ADC_IF_TEST_1_0_B64/data_to_fabric_b64_bg1_pin4_17] [get_bd_pins lgain_adc_6/In1]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_data_to_fabric_b64_bg1_pin6_19 [get_bd_pins ADC_IF_TEST_1_0_B64/data_to_fabric_b64_bg1_pin6_19] [get_bd_pins lgain_adc_6/In3]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_data_to_fabric_b64_bg1_pin8_21 [get_bd_pins ADC_IF_TEST_1_0_B64/data_to_fabric_b64_bg1_pin8_21] [get_bd_pins lgain_adc_6/In0]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_data_to_fabric_b64_bg2_pin10_36 [get_bd_pins ADC_IF_TEST_1_0_B64/data_to_fabric_b64_bg2_pin10_36] [get_bd_pins lgain_adc_5/In0]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_data_to_fabric_b64_bg2_pin4_30 [get_bd_pins ADC_IF_TEST_1_0_B64/data_to_fabric_b64_bg2_pin4_30] [get_bd_pins lgain_adc_5/In1]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_data_to_fabric_b64_bg2_pin6_32 [get_bd_pins ADC_IF_TEST_1_0_B64/data_to_fabric_b64_bg2_pin6_32] [get_bd_pins lgain_adc_5/In3]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_data_to_fabric_b64_bg2_pin8_34 [get_bd_pins ADC_IF_TEST_1_0_B64/data_to_fabric_b64_bg2_pin8_34] [get_bd_pins lgain_adc_5/In2]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_data_to_fabric_b64_bg3_pin10_49 [get_bd_pins ADC_IF_TEST_1_0_B64/data_to_fabric_b64_bg3_pin10_49] [get_bd_pins lgain_adc_4/In2]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_data_to_fabric_b64_bg3_pin4_43 [get_bd_pins ADC_IF_TEST_1_0_B64/data_to_fabric_b64_bg3_pin4_43] [get_bd_pins lgain_adc_4/In1]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_data_to_fabric_b64_bg3_pin6_45 [get_bd_pins ADC_IF_TEST_1_0_B64/data_to_fabric_b64_bg3_pin6_45] [get_bd_pins lgain_adc_4/In0]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_data_to_fabric_b64_bg3_pin8_47 [get_bd_pins ADC_IF_TEST_1_0_B64/data_to_fabric_b64_bg3_pin8_47] [get_bd_pins lgain_adc_4/In3]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_fifo_empty_2 [get_bd_pins ADC_IF_TEST_1_0_B64/fifo_empty_2] [get_bd_pins lgain_adc_7/empty_0]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_fifo_empty_4 [get_bd_pins ADC_IF_TEST_1_0_B64/fifo_empty_4] [get_bd_pins lgain_adc_7/empty_1]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_fifo_empty_6 [get_bd_pins ADC_IF_TEST_1_0_B64/fifo_empty_6] [get_bd_pins lgain_adc_7/empty_2]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_fifo_empty_8 [get_bd_pins ADC_IF_TEST_1_0_B64/fifo_empty_8] [get_bd_pins lgain_adc_7/empty_3]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_fifo_empty_17 [get_bd_pins ADC_IF_TEST_1_0_B64/fifo_empty_17] [get_bd_pins lgain_adc_6/empty_0]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_fifo_empty_19 [get_bd_pins ADC_IF_TEST_1_0_B64/fifo_empty_19] [get_bd_pins lgain_adc_6/empty_1]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_fifo_empty_21 [get_bd_pins ADC_IF_TEST_1_0_B64/fifo_empty_21] [get_bd_pins lgain_adc_6/empty_2]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_fifo_empty_23 [get_bd_pins ADC_IF_TEST_1_0_B64/fifo_empty_23] [get_bd_pins lgain_adc_6/empty_3]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_fifo_empty_30 [get_bd_pins ADC_IF_TEST_1_0_B64/fifo_empty_30] [get_bd_pins lgain_adc_5/empty_0]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_fifo_empty_32 [get_bd_pins ADC_IF_TEST_1_0_B64/fifo_empty_32] [get_bd_pins lgain_adc_5/empty_1]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_fifo_empty_34 [get_bd_pins ADC_IF_TEST_1_0_B64/fifo_empty_34] [get_bd_pins lgain_adc_5/empty_2]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_fifo_empty_36 [get_bd_pins ADC_IF_TEST_1_0_B64/fifo_empty_36] [get_bd_pins lgain_adc_5/empty_3]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_fifo_empty_43 [get_bd_pins ADC_IF_TEST_1_0_B64/fifo_empty_43] [get_bd_pins lgain_adc_4/empty_0]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_fifo_empty_45 [get_bd_pins ADC_IF_TEST_1_0_B64/fifo_empty_45] [get_bd_pins lgain_adc_4/empty_1]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_fifo_empty_47 [get_bd_pins ADC_IF_TEST_1_0_B64/fifo_empty_47] [get_bd_pins lgain_adc_4/empty_2]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_fifo_empty_49 [get_bd_pins ADC_IF_TEST_1_0_B64/fifo_empty_49] [get_bd_pins lgain_adc_4/empty_3]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_fifo_rd_data_valid [get_bd_pins fifo_rd_data_valid] [get_bd_pins ADC_IF_TEST_1_0_B64/fifo_rd_data_valid]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_pll0_locked [get_bd_pins ADC_IF_TEST_1_0_B64/pll0_locked] [get_bd_pins lgain_47_replica_rst/ext_reset_in]
  connect_bd_net -net ADC_IF_TEST_1_0_B64_rx_bitslip_sync_done [get_bd_pins ADC_IF_TEST_1_0_B64/rx_bitslip_sync_done] [get_bd_pins vio_0/probe_in20]
  connect_bd_net -net ADC_IF_TEST_1_0_pll0_clkout0 [get_bd_pins ADC_IF_TEST_1_0_B64/fifo_rd_clk_0] [get_bd_pins ADC_IF_TEST_1_0_B64/fifo_rd_clk_2] [get_bd_pins ADC_IF_TEST_1_0_B64/fifo_rd_clk_4] [get_bd_pins ADC_IF_TEST_1_0_B64/fifo_rd_clk_6] [get_bd_pins ADC_IF_TEST_1_0_B64/fifo_rd_clk_8] [get_bd_pins ADC_IF_TEST_1_0_B64/fifo_rd_clk_13] [get_bd_pins ADC_IF_TEST_1_0_B64/fifo_rd_clk_17] [get_bd_pins ADC_IF_TEST_1_0_B64/fifo_rd_clk_19] [get_bd_pins ADC_IF_TEST_1_0_B64/fifo_rd_clk_21] [get_bd_pins ADC_IF_TEST_1_0_B64/fifo_rd_clk_23] [get_bd_pins ADC_IF_TEST_1_0_B64/fifo_rd_clk_26] [get_bd_pins ADC_IF_TEST_1_0_B64/fifo_rd_clk_30] [get_bd_pins ADC_IF_TEST_1_0_B64/fifo_rd_clk_32] [get_bd_pins ADC_IF_TEST_1_0_B64/fifo_rd_clk_34] [get_bd_pins ADC_IF_TEST_1_0_B64/fifo_rd_clk_36] [get_bd_pins ADC_IF_TEST_1_0_B64/fifo_rd_clk_39] [get_bd_pins ADC_IF_TEST_1_0_B64/fifo_rd_clk_43] [get_bd_pins ADC_IF_TEST_1_0_B64/fifo_rd_clk_45] [get_bd_pins ADC_IF_TEST_1_0_B64/fifo_rd_clk_47] [get_bd_pins ADC_IF_TEST_1_0_B64/fifo_rd_clk_49] [get_bd_pins ADC_IF_TEST_1_0_B64/pll0_clkout0] [get_bd_pins lgain_47_replica_rst/slowest_sync_clk] [get_bd_pins lgain_adc_4/S_ACLK] [get_bd_pins lgain_adc_5/S_ACLK] [get_bd_pins lgain_adc_6/S_ACLK] [get_bd_pins lgain_adc_7/S_ACLK]
  connect_bd_net -net M_ACLK_1 [get_bd_pins M_ACLK] [get_bd_pins ADC_IF_TEST_1_0_B64/clk] [get_bd_pins lgain_adc_4/M_ACLK] [get_bd_pins lgain_adc_5/M_ACLK] [get_bd_pins lgain_adc_6/M_ACLK] [get_bd_pins lgain_adc_7/M_ACLK] [get_bd_pins vio_0/clk]
  connect_bd_net -net M_ARESETN_1 [get_bd_pins M_ARESETN] [get_bd_pins lgain_adc_4/M_ARESETN] [get_bd_pins lgain_adc_5/M_ARESETN] [get_bd_pins lgain_adc_6/M_ARESETN] [get_bd_pins lgain_adc_7/M_ARESETN]
  connect_bd_net -net en_vtc_bsc0_1 [get_bd_pins ADC_IF_TEST_1_0_B64/en_vtc_bsc0] [get_bd_pins ADC_IF_TEST_1_0_B64/en_vtc_bsc1] [get_bd_pins ADC_IF_TEST_1_0_B64/en_vtc_bsc2] [get_bd_pins ADC_IF_TEST_1_0_B64/en_vtc_bsc3] [get_bd_pins ADC_IF_TEST_1_0_B64/en_vtc_bsc4] [get_bd_pins ADC_IF_TEST_1_0_B64/en_vtc_bsc5] [get_bd_pins ADC_IF_TEST_1_0_B64/en_vtc_bsc6] [get_bd_pins ADC_IF_TEST_1_0_B64/en_vtc_bsc7] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net lgain_47_replica_rst_peripheral_aresetn [get_bd_pins lgain_47_replica_rst/peripheral_aresetn] [get_bd_pins lgain_adc_4/S_ARESETN] [get_bd_pins lgain_adc_5/S_ARESETN] [get_bd_pins lgain_adc_6/S_ARESETN] [get_bd_pins lgain_adc_7/S_ARESETN]
  connect_bd_net -net rst_1 [get_bd_pins rst] [get_bd_pins ADC_IF_TEST_1_0_B64/rst]
  connect_bd_net -net vio_0_probe_out0 [get_bd_pins ADC_IF_TEST_1_0_B64/start_bitslip] [get_bd_pins vio_0/probe_out0]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: lgain_adc_block_0
proc create_hier_cell_lgain_adc_block_0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_lgain_adc_block_0() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC_0

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC_1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC_2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC_3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_high_speed_selectio_wiz:hssio_data_rx_rtl:1.0 xiphy_rx_pins_0


  # Create pins
  create_bd_pin -dir I M_ACLK
  create_bd_pin -dir I M_ARESETN
  create_bd_pin -dir O fifo_rd_data_valid
  create_bd_pin -dir I -type rst rst

  # Create instance: ADC_IF_TEST_0_B69, and set properties
  set ADC_IF_TEST_0_B69 [ create_bd_cell -type ip -vlnv teldevice.local:user:ADC_IF_TEST:1.0 ADC_IF_TEST_0_B69 ]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
 ] [get_bd_pins /lgain_adc_blocks/lgain_adc_block_0/ADC_IF_TEST_0_B69/clk]

  # Create instance: lgain_B69_rst, and set properties
  set lgain_B69_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 lgain_B69_rst ]

  # Create instance: lgain_adc_0
  create_hier_cell_lgain_adc_0 $hier_obj lgain_adc_0

  # Create instance: lgain_adc_1
  create_hier_cell_lgain_adc_1 $hier_obj lgain_adc_1

  # Create instance: lgain_adc_2
  create_hier_cell_lgain_adc_2 $hier_obj lgain_adc_2

  # Create instance: lgain_adc_3
  create_hier_cell_lgain_adc_3 $hier_obj lgain_adc_3

  # Create instance: vio_0, and set properties
  set vio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:vio:3.0 vio_0 ]
  set_property -dict [ list \
   CONFIG.C_NUM_PROBE_IN {21} \
 ] $vio_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net lgain_adc_0_M_AXIS_LGAIN_ADC [get_bd_intf_pins M_AXIS_LGAIN_ADC_0] [get_bd_intf_pins lgain_adc_0/M_AXIS_LGAIN_ADC]
  connect_bd_intf_net -intf_net lgain_adc_1_M_AXIS_LGAIN_ADC [get_bd_intf_pins M_AXIS_LGAIN_ADC_1] [get_bd_intf_pins lgain_adc_1/M_AXIS_LGAIN_ADC]
  connect_bd_intf_net -intf_net lgain_adc_2_M_AXIS_LGAIN_ADC [get_bd_intf_pins M_AXIS_LGAIN_ADC_2] [get_bd_intf_pins lgain_adc_2/M_AXIS_LGAIN_ADC]
  connect_bd_intf_net -intf_net lgain_adc_3_M_AXIS_LGAIN_ADC [get_bd_intf_pins M_AXIS_LGAIN_ADC_3] [get_bd_intf_pins lgain_adc_3/M_AXIS_LGAIN_ADC]
  connect_bd_intf_net -intf_net xiphy_rx_pins_0_1 [get_bd_intf_pins xiphy_rx_pins_0] [get_bd_intf_pins ADC_IF_TEST_0_B69/xiphy_rx_pins]

  # Create port connections
  connect_bd_net -net ADC_IF_TEST_0_B69_bitslip_error_2 [get_bd_pins ADC_IF_TEST_0_B69/bitslip_error_2] [get_bd_pins vio_0/probe_in3]
  connect_bd_net -net ADC_IF_TEST_0_B69_bitslip_error_4 [get_bd_pins ADC_IF_TEST_0_B69/bitslip_error_4] [get_bd_pins vio_0/probe_in0]
  connect_bd_net -net ADC_IF_TEST_0_B69_bitslip_error_6 [get_bd_pins ADC_IF_TEST_0_B69/bitslip_error_6] [get_bd_pins vio_0/probe_in4]
  connect_bd_net -net ADC_IF_TEST_0_B69_bitslip_error_8 [get_bd_pins ADC_IF_TEST_0_B69/bitslip_error_8] [get_bd_pins vio_0/probe_in5]
  connect_bd_net -net ADC_IF_TEST_0_B69_bitslip_error_10 [get_bd_pins ADC_IF_TEST_0_B69/bitslip_error_10] [get_bd_pins vio_0/probe_in6]
  connect_bd_net -net ADC_IF_TEST_0_B69_bitslip_error_15 [get_bd_pins ADC_IF_TEST_0_B69/bitslip_error_15] [get_bd_pins vio_0/probe_in7]
  connect_bd_net -net ADC_IF_TEST_0_B69_bitslip_error_17 [get_bd_pins ADC_IF_TEST_0_B69/bitslip_error_17] [get_bd_pins vio_0/probe_in8]
  connect_bd_net -net ADC_IF_TEST_0_B69_bitslip_error_19 [get_bd_pins ADC_IF_TEST_0_B69/bitslip_error_19] [get_bd_pins vio_0/probe_in9]
  connect_bd_net -net ADC_IF_TEST_0_B69_bitslip_error_21 [get_bd_pins ADC_IF_TEST_0_B69/bitslip_error_21] [get_bd_pins vio_0/probe_in10]
  connect_bd_net -net ADC_IF_TEST_0_B69_bitslip_error_23 [get_bd_pins ADC_IF_TEST_0_B69/bitslip_error_23] [get_bd_pins vio_0/probe_in11]
  connect_bd_net -net ADC_IF_TEST_0_B69_bitslip_error_26 [get_bd_pins ADC_IF_TEST_0_B69/bitslip_error_26] [get_bd_pins vio_0/probe_in1]
  connect_bd_net -net ADC_IF_TEST_0_B69_bitslip_error_28 [get_bd_pins ADC_IF_TEST_0_B69/bitslip_error_28] [get_bd_pins vio_0/probe_in2]
  connect_bd_net -net ADC_IF_TEST_0_B69_bitslip_error_30 [get_bd_pins ADC_IF_TEST_0_B69/bitslip_error_30] [get_bd_pins vio_0/probe_in12]
  connect_bd_net -net ADC_IF_TEST_0_B69_bitslip_error_34 [get_bd_pins ADC_IF_TEST_0_B69/bitslip_error_34] [get_bd_pins vio_0/probe_in13]
  connect_bd_net -net ADC_IF_TEST_0_B69_bitslip_error_36 [get_bd_pins ADC_IF_TEST_0_B69/bitslip_error_36] [get_bd_pins vio_0/probe_in14]
  connect_bd_net -net ADC_IF_TEST_0_B69_bitslip_error_41 [get_bd_pins ADC_IF_TEST_0_B69/bitslip_error_41] [get_bd_pins vio_0/probe_in15]
  connect_bd_net -net ADC_IF_TEST_0_B69_bitslip_error_43 [get_bd_pins ADC_IF_TEST_0_B69/bitslip_error_43] [get_bd_pins vio_0/probe_in16]
  connect_bd_net -net ADC_IF_TEST_0_B69_bitslip_error_45 [get_bd_pins ADC_IF_TEST_0_B69/bitslip_error_45] [get_bd_pins vio_0/probe_in17]
  connect_bd_net -net ADC_IF_TEST_0_B69_bitslip_error_47 [get_bd_pins ADC_IF_TEST_0_B69/bitslip_error_47] [get_bd_pins vio_0/probe_in18]
  connect_bd_net -net ADC_IF_TEST_0_B69_bitslip_error_49 [get_bd_pins ADC_IF_TEST_0_B69/bitslip_error_49] [get_bd_pins vio_0/probe_in19]
  connect_bd_net -net ADC_IF_TEST_0_B69_data_to_fabric_bg0_pin10_10 [get_bd_pins ADC_IF_TEST_0_B69/data_to_fabric_bg0_pin10_10] [get_bd_pins lgain_adc_3/In2]
  connect_bd_net -net ADC_IF_TEST_0_B69_data_to_fabric_bg0_pin2_2 [get_bd_pins ADC_IF_TEST_0_B69/data_to_fabric_bg0_pin2_2] [get_bd_pins lgain_adc_3/In3]
  connect_bd_net -net ADC_IF_TEST_0_B69_data_to_fabric_bg0_pin4_4 [get_bd_pins ADC_IF_TEST_0_B69/data_to_fabric_bg0_pin4_4] [get_bd_pins lgain_adc_3/In1]
  connect_bd_net -net ADC_IF_TEST_0_B69_data_to_fabric_bg0_pin8_8 [get_bd_pins ADC_IF_TEST_0_B69/data_to_fabric_bg0_pin8_8] [get_bd_pins lgain_adc_3/In0]
  connect_bd_net -net ADC_IF_TEST_0_B69_data_to_fabric_bg1_pin10_23 [get_bd_pins ADC_IF_TEST_0_B69/data_to_fabric_bg1_pin10_23] [get_bd_pins lgain_adc_2/In2]
  connect_bd_net -net ADC_IF_TEST_0_B69_data_to_fabric_bg1_pin2_15 [get_bd_pins ADC_IF_TEST_0_B69/data_to_fabric_bg1_pin2_15] [get_bd_pins lgain_adc_2/In3]
  connect_bd_net -net ADC_IF_TEST_0_B69_data_to_fabric_bg1_pin4_17 [get_bd_pins ADC_IF_TEST_0_B69/data_to_fabric_bg1_pin4_17] [get_bd_pins lgain_adc_2/In1]
  connect_bd_net -net ADC_IF_TEST_0_B69_data_to_fabric_bg1_pin8_21 [get_bd_pins ADC_IF_TEST_0_B69/data_to_fabric_bg1_pin8_21] [get_bd_pins lgain_adc_2/In0]
  connect_bd_net -net ADC_IF_TEST_0_B69_data_to_fabric_bg2_pin10_36 [get_bd_pins ADC_IF_TEST_0_B69/data_to_fabric_bg2_pin10_36] [get_bd_pins lgain_adc_1/In2]
  connect_bd_net -net ADC_IF_TEST_0_B69_data_to_fabric_bg2_pin2_28 [get_bd_pins ADC_IF_TEST_0_B69/data_to_fabric_bg2_pin2_28] [get_bd_pins lgain_adc_1/In3]
  connect_bd_net -net ADC_IF_TEST_0_B69_data_to_fabric_bg2_pin4_30 [get_bd_pins ADC_IF_TEST_0_B69/data_to_fabric_bg2_pin4_30] [get_bd_pins lgain_adc_1/In1]
  connect_bd_net -net ADC_IF_TEST_0_B69_data_to_fabric_bg2_pin8_34 [get_bd_pins ADC_IF_TEST_0_B69/data_to_fabric_bg2_pin8_34] [get_bd_pins lgain_adc_1/In0]
  connect_bd_net -net ADC_IF_TEST_0_B69_data_to_fabric_bg3_pin10_49 [get_bd_pins ADC_IF_TEST_0_B69/data_to_fabric_bg3_pin10_49] [get_bd_pins lgain_adc_0/In2]
  connect_bd_net -net ADC_IF_TEST_0_B69_data_to_fabric_bg3_pin2_41 [get_bd_pins ADC_IF_TEST_0_B69/data_to_fabric_bg3_pin2_41] [get_bd_pins lgain_adc_0/In3]
  connect_bd_net -net ADC_IF_TEST_0_B69_data_to_fabric_bg3_pin4_43 [get_bd_pins ADC_IF_TEST_0_B69/data_to_fabric_bg3_pin4_43] [get_bd_pins lgain_adc_0/In0]
  connect_bd_net -net ADC_IF_TEST_0_B69_data_to_fabric_bg3_pin8_47 [get_bd_pins ADC_IF_TEST_0_B69/data_to_fabric_bg3_pin8_47] [get_bd_pins lgain_adc_0/In1]
  connect_bd_net -net ADC_IF_TEST_0_B69_fifo_empty_2 [get_bd_pins ADC_IF_TEST_0_B69/fifo_empty_2] [get_bd_pins lgain_adc_3/empty_0]
  connect_bd_net -net ADC_IF_TEST_0_B69_fifo_empty_4 [get_bd_pins ADC_IF_TEST_0_B69/fifo_empty_4] [get_bd_pins lgain_adc_3/empty_1]
  connect_bd_net -net ADC_IF_TEST_0_B69_fifo_empty_8 [get_bd_pins ADC_IF_TEST_0_B69/fifo_empty_8] [get_bd_pins lgain_adc_3/empty_2]
  connect_bd_net -net ADC_IF_TEST_0_B69_fifo_empty_10 [get_bd_pins ADC_IF_TEST_0_B69/fifo_empty_10] [get_bd_pins lgain_adc_3/empty_3]
  connect_bd_net -net ADC_IF_TEST_0_B69_fifo_empty_15 [get_bd_pins ADC_IF_TEST_0_B69/fifo_empty_15] [get_bd_pins lgain_adc_2/empty_0]
  connect_bd_net -net ADC_IF_TEST_0_B69_fifo_empty_21 [get_bd_pins ADC_IF_TEST_0_B69/fifo_empty_21] [get_bd_pins lgain_adc_2/empty_2]
  connect_bd_net -net ADC_IF_TEST_0_B69_fifo_empty_23 [get_bd_pins ADC_IF_TEST_0_B69/fifo_empty_23] [get_bd_pins lgain_adc_2/empty_3]
  connect_bd_net -net ADC_IF_TEST_0_B69_fifo_empty_28 [get_bd_pins ADC_IF_TEST_0_B69/fifo_empty_28] [get_bd_pins lgain_adc_1/empty_0]
  connect_bd_net -net ADC_IF_TEST_0_B69_fifo_empty_30 [get_bd_pins ADC_IF_TEST_0_B69/fifo_empty_30] [get_bd_pins lgain_adc_1/empty_1]
  connect_bd_net -net ADC_IF_TEST_0_B69_fifo_empty_34 [get_bd_pins ADC_IF_TEST_0_B69/fifo_empty_34] [get_bd_pins lgain_adc_1/empty_2]
  connect_bd_net -net ADC_IF_TEST_0_B69_fifo_empty_36 [get_bd_pins ADC_IF_TEST_0_B69/fifo_empty_36] [get_bd_pins lgain_adc_1/empty_3]
  connect_bd_net -net ADC_IF_TEST_0_B69_fifo_empty_41 [get_bd_pins ADC_IF_TEST_0_B69/fifo_empty_41] [get_bd_pins lgain_adc_0/empty_0]
  connect_bd_net -net ADC_IF_TEST_0_B69_fifo_empty_43 [get_bd_pins ADC_IF_TEST_0_B69/fifo_empty_43] [get_bd_pins lgain_adc_0/empty_1]
  connect_bd_net -net ADC_IF_TEST_0_B69_fifo_empty_47 [get_bd_pins ADC_IF_TEST_0_B69/fifo_empty_47] [get_bd_pins lgain_adc_0/empty_2]
  connect_bd_net -net ADC_IF_TEST_0_B69_fifo_empty_49 [get_bd_pins ADC_IF_TEST_0_B69/fifo_empty_49] [get_bd_pins lgain_adc_0/empty_3]
  connect_bd_net -net ADC_IF_TEST_0_B69_fifo_rd_data_valid [get_bd_pins fifo_rd_data_valid] [get_bd_pins ADC_IF_TEST_0_B69/fifo_rd_data_valid]
  connect_bd_net -net ADC_IF_TEST_0_B69_pll0_clkout0 [get_bd_pins ADC_IF_TEST_0_B69/fifo_rd_clk_2] [get_bd_pins ADC_IF_TEST_0_B69/fifo_rd_clk_4] [get_bd_pins ADC_IF_TEST_0_B69/fifo_rd_clk_6] [get_bd_pins ADC_IF_TEST_0_B69/fifo_rd_clk_8] [get_bd_pins ADC_IF_TEST_0_B69/fifo_rd_clk_10] [get_bd_pins ADC_IF_TEST_0_B69/fifo_rd_clk_15] [get_bd_pins ADC_IF_TEST_0_B69/fifo_rd_clk_17] [get_bd_pins ADC_IF_TEST_0_B69/fifo_rd_clk_19] [get_bd_pins ADC_IF_TEST_0_B69/fifo_rd_clk_21] [get_bd_pins ADC_IF_TEST_0_B69/fifo_rd_clk_23] [get_bd_pins ADC_IF_TEST_0_B69/fifo_rd_clk_26] [get_bd_pins ADC_IF_TEST_0_B69/fifo_rd_clk_28] [get_bd_pins ADC_IF_TEST_0_B69/fifo_rd_clk_30] [get_bd_pins ADC_IF_TEST_0_B69/fifo_rd_clk_34] [get_bd_pins ADC_IF_TEST_0_B69/fifo_rd_clk_36] [get_bd_pins ADC_IF_TEST_0_B69/fifo_rd_clk_41] [get_bd_pins ADC_IF_TEST_0_B69/fifo_rd_clk_43] [get_bd_pins ADC_IF_TEST_0_B69/fifo_rd_clk_45] [get_bd_pins ADC_IF_TEST_0_B69/fifo_rd_clk_47] [get_bd_pins ADC_IF_TEST_0_B69/fifo_rd_clk_49] [get_bd_pins ADC_IF_TEST_0_B69/pll0_clkout0] [get_bd_pins lgain_B69_rst/slowest_sync_clk] [get_bd_pins lgain_adc_0/S_ACLK] [get_bd_pins lgain_adc_1/S_ACLK] [get_bd_pins lgain_adc_2/S_ACLK] [get_bd_pins lgain_adc_3/S_ACLK]
  connect_bd_net -net ADC_IF_TEST_0_B69_pll0_locked [get_bd_pins ADC_IF_TEST_0_B69/pll0_locked] [get_bd_pins lgain_B69_rst/ext_reset_in]
  connect_bd_net -net ADC_IF_TEST_0_B69_rx_bitslip_sync_done [get_bd_pins ADC_IF_TEST_0_B69/rx_bitslip_sync_done] [get_bd_pins vio_0/probe_in20]
  connect_bd_net -net empty_1_1 [get_bd_pins ADC_IF_TEST_0_B69/fifo_empty_17] [get_bd_pins lgain_adc_2/empty_1]
  connect_bd_net -net lgain_03_rst_peripheral_aresetn [get_bd_pins lgain_B69_rst/peripheral_aresetn] [get_bd_pins lgain_adc_0/S_ARESETN] [get_bd_pins lgain_adc_1/S_ARESETN] [get_bd_pins lgain_adc_2/S_ARESETN] [get_bd_pins lgain_adc_3/S_ARESETN]
  connect_bd_net -net mts_clk_pl_user_clk [get_bd_pins M_ACLK] [get_bd_pins ADC_IF_TEST_0_B69/clk] [get_bd_pins lgain_adc_0/M_ACLK] [get_bd_pins lgain_adc_1/M_ACLK] [get_bd_pins lgain_adc_2/M_ACLK] [get_bd_pins lgain_adc_3/M_ACLK] [get_bd_pins vio_0/clk]
  connect_bd_net -net pl_user_clk_rst_peripheral_aresetn [get_bd_pins M_ARESETN] [get_bd_pins lgain_adc_0/M_ARESETN] [get_bd_pins lgain_adc_1/M_ARESETN] [get_bd_pins lgain_adc_2/M_ARESETN] [get_bd_pins lgain_adc_3/M_ARESETN]
  connect_bd_net -net rst_1 [get_bd_pins rst] [get_bd_pins ADC_IF_TEST_0_B69/rst]
  connect_bd_net -net vio_0_probe_out0 [get_bd_pins ADC_IF_TEST_0_B69/start_bitslip] [get_bd_pins vio_0/probe_out0]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins ADC_IF_TEST_0_B69/en_vtc_bsc0] [get_bd_pins ADC_IF_TEST_0_B69/en_vtc_bsc1] [get_bd_pins ADC_IF_TEST_0_B69/en_vtc_bsc2] [get_bd_pins ADC_IF_TEST_0_B69/en_vtc_bsc3] [get_bd_pins ADC_IF_TEST_0_B69/en_vtc_bsc4] [get_bd_pins ADC_IF_TEST_0_B69/en_vtc_bsc5] [get_bd_pins ADC_IF_TEST_0_B69/en_vtc_bsc6] [get_bd_pins ADC_IF_TEST_0_B69/en_vtc_bsc7] [get_bd_pins xlconstant_0/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: lgain_adc_blocks
proc create_hier_cell_lgain_adc_blocks { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_lgain_adc_blocks() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC4

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC5

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC6

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC7

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC8

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC9

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC10

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC11

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC12

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC13

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC14

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_LGAIN_ADC15

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_high_speed_selectio_wiz:hssio_data_rx_rtl:1.0 xiphy_rx_pins_0

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_high_speed_selectio_wiz:hssio_data_rx_rtl:1.0 xiphy_rx_pins_1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_high_speed_selectio_wiz:hssio_data_rx_rtl:1.0 xiphy_rx_pins_2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_high_speed_selectio_wiz:hssio_data_rx_rtl:1.0 xiphy_rx_pins_3


  # Create pins
  create_bd_pin -dir I M_ACLK
  create_bd_pin -dir I M_ARESETN
  create_bd_pin -dir O fifo_rd_data_valid
  create_bd_pin -dir O fifo_rd_data_valid1
  create_bd_pin -dir O fifo_rd_data_valid2
  create_bd_pin -dir O fifo_rd_data_valid3
  create_bd_pin -dir I -type rst rst

  # Create instance: lgain_adc_block_0
  create_hier_cell_lgain_adc_block_0 $hier_obj lgain_adc_block_0

  # Create instance: lgain_adc_block_1
  create_hier_cell_lgain_adc_block_1 $hier_obj lgain_adc_block_1

  # Create instance: lgain_adc_block_2
  create_hier_cell_lgain_adc_block_2 $hier_obj lgain_adc_block_2

  # Create instance: lgain_adc_block_3
  create_hier_cell_lgain_adc_block_3 $hier_obj lgain_adc_block_3

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins xiphy_rx_pins_2] [get_bd_intf_pins lgain_adc_block_2/xiphy_rx_pins_2]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins xiphy_rx_pins_1] [get_bd_intf_pins lgain_adc_block_1/xiphy_rx_pins_1]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins xiphy_rx_pins_3] [get_bd_intf_pins lgain_adc_block_3/xiphy_rx_pins_3]
  connect_bd_intf_net -intf_net lgain_adc_block_0_M_AXIS_LGAIN_ADC_0 [get_bd_intf_pins M_AXIS_LGAIN_ADC] [get_bd_intf_pins lgain_adc_block_0/M_AXIS_LGAIN_ADC_0]
  connect_bd_intf_net -intf_net lgain_adc_block_0_M_AXIS_LGAIN_ADC_1 [get_bd_intf_pins M_AXIS_LGAIN_ADC1] [get_bd_intf_pins lgain_adc_block_0/M_AXIS_LGAIN_ADC_1]
  connect_bd_intf_net -intf_net lgain_adc_block_0_M_AXIS_LGAIN_ADC_2 [get_bd_intf_pins M_AXIS_LGAIN_ADC2] [get_bd_intf_pins lgain_adc_block_0/M_AXIS_LGAIN_ADC_2]
  connect_bd_intf_net -intf_net lgain_adc_block_0_M_AXIS_LGAIN_ADC_3 [get_bd_intf_pins M_AXIS_LGAIN_ADC3] [get_bd_intf_pins lgain_adc_block_0/M_AXIS_LGAIN_ADC_3]
  connect_bd_intf_net -intf_net lgain_adc_block_1_M_AXIS_LGAIN_ADC_4 [get_bd_intf_pins M_AXIS_LGAIN_ADC4] [get_bd_intf_pins lgain_adc_block_1/M_AXIS_LGAIN_ADC_4]
  connect_bd_intf_net -intf_net lgain_adc_block_1_M_AXIS_LGAIN_ADC_5 [get_bd_intf_pins M_AXIS_LGAIN_ADC5] [get_bd_intf_pins lgain_adc_block_1/M_AXIS_LGAIN_ADC_5]
  connect_bd_intf_net -intf_net lgain_adc_block_1_M_AXIS_LGAIN_ADC_6 [get_bd_intf_pins M_AXIS_LGAIN_ADC6] [get_bd_intf_pins lgain_adc_block_1/M_AXIS_LGAIN_ADC_6]
  connect_bd_intf_net -intf_net lgain_adc_block_1_M_AXIS_LGAIN_ADC_7 [get_bd_intf_pins M_AXIS_LGAIN_ADC7] [get_bd_intf_pins lgain_adc_block_1/M_AXIS_LGAIN_ADC_7]
  connect_bd_intf_net -intf_net lgain_adc_block_2_M_AXIS_LGAIN_ADC_8 [get_bd_intf_pins M_AXIS_LGAIN_ADC8] [get_bd_intf_pins lgain_adc_block_2/M_AXIS_LGAIN_ADC_8]
  connect_bd_intf_net -intf_net lgain_adc_block_2_M_AXIS_LGAIN_ADC_9 [get_bd_intf_pins M_AXIS_LGAIN_ADC9] [get_bd_intf_pins lgain_adc_block_2/M_AXIS_LGAIN_ADC_9]
  connect_bd_intf_net -intf_net lgain_adc_block_2_M_AXIS_LGAIN_ADC_10 [get_bd_intf_pins M_AXIS_LGAIN_ADC10] [get_bd_intf_pins lgain_adc_block_2/M_AXIS_LGAIN_ADC_10]
  connect_bd_intf_net -intf_net lgain_adc_block_2_M_AXIS_LGAIN_ADC_11 [get_bd_intf_pins M_AXIS_LGAIN_ADC11] [get_bd_intf_pins lgain_adc_block_2/M_AXIS_LGAIN_ADC_11]
  connect_bd_intf_net -intf_net lgain_adc_block_3_M_AXIS_LGAIN_ADC_12 [get_bd_intf_pins M_AXIS_LGAIN_ADC12] [get_bd_intf_pins lgain_adc_block_3/M_AXIS_LGAIN_ADC_12]
  connect_bd_intf_net -intf_net lgain_adc_block_3_M_AXIS_LGAIN_ADC_13 [get_bd_intf_pins M_AXIS_LGAIN_ADC13] [get_bd_intf_pins lgain_adc_block_3/M_AXIS_LGAIN_ADC_13]
  connect_bd_intf_net -intf_net lgain_adc_block_3_M_AXIS_LGAIN_ADC_14 [get_bd_intf_pins M_AXIS_LGAIN_ADC14] [get_bd_intf_pins lgain_adc_block_3/M_AXIS_LGAIN_ADC_14]
  connect_bd_intf_net -intf_net lgain_adc_block_3_M_AXIS_LGAIN_ADC_15 [get_bd_intf_pins M_AXIS_LGAIN_ADC15] [get_bd_intf_pins lgain_adc_block_3/M_AXIS_LGAIN_ADC_15]
  connect_bd_intf_net -intf_net xiphy_rx_pins_0_1 [get_bd_intf_pins xiphy_rx_pins_0] [get_bd_intf_pins lgain_adc_block_0/xiphy_rx_pins_0]

  # Create port connections
  connect_bd_net -net lgain_adc_block_0_fifo_rd_data_valid [get_bd_pins fifo_rd_data_valid] [get_bd_pins lgain_adc_block_0/fifo_rd_data_valid]
  connect_bd_net -net lgain_adc_block_1_fifo_rd_data_valid [get_bd_pins fifo_rd_data_valid1] [get_bd_pins lgain_adc_block_1/fifo_rd_data_valid]
  connect_bd_net -net lgain_adc_block_2_fifo_rd_data_valid [get_bd_pins fifo_rd_data_valid2] [get_bd_pins lgain_adc_block_2/fifo_rd_data_valid]
  connect_bd_net -net lgain_adc_block_3_fifo_rd_data_valid [get_bd_pins fifo_rd_data_valid3] [get_bd_pins lgain_adc_block_3/fifo_rd_data_valid]
  connect_bd_net -net mts_clk_pl_user_clk [get_bd_pins M_ACLK] [get_bd_pins lgain_adc_block_0/M_ACLK] [get_bd_pins lgain_adc_block_1/M_ACLK] [get_bd_pins lgain_adc_block_2/M_ACLK] [get_bd_pins lgain_adc_block_3/M_ACLK]
  connect_bd_net -net pl_user_clk_rst_peripheral_aresetn [get_bd_pins M_ARESETN] [get_bd_pins lgain_adc_block_0/M_ARESETN] [get_bd_pins lgain_adc_block_1/M_ARESETN] [get_bd_pins lgain_adc_block_2/M_ARESETN] [get_bd_pins lgain_adc_block_3/M_ARESETN]
  connect_bd_net -net rst_1 [get_bd_pins rst] [get_bd_pins lgain_adc_block_0/rst] [get_bd_pins lgain_adc_block_1/rst] [get_bd_pins lgain_adc_block_2/rst] [get_bd_pins lgain_adc_block_3/rst]

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

  # Create instance: lgain_adc_blocks
  create_hier_cell_lgain_adc_blocks [current_bd_instance .] lgain_adc_blocks

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

