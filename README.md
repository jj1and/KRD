# About KRD
A detector's electronics development project. Verilog-HDL is mainly used.

# Directory explanation

* proto_ip_code
  * This directory contains HDL-code before IP-packaging. So, it is updated very frequently.

* ip_repo
  * This directory contains User-packaged IPs and User-defined interface. The behavior is confirmed at least level.

<!-- * hardware_files
  * Bitstream files which meet timing closure. You can create XSDK project by importing this file. -->

* project_tcl
  * You can create a vivado project by running tcl scripts. After running the tcl, the project folder will be created but git will not trace it. It's because the actual project directory is too large to be managed by git.
  *  Hardware file should be in the same directory with the tcl script is included. 
  When you add change to the project and export the hardware, please export it to the directory of the tcl script.
  * Folder including custom information file of Xilinx IP (.xci file) is also located in the same directory. When you add Customized Xilinx IP, please set project to generate output to the same folder. You can set it via "Tools -> Settings -> IP -> Default IP location" 

* common_source
  * This contains the source code used in many project.   


* project_rtl
  * These codes are old ones. Very similar to "trash".

* trash
  * Trash code. I save them just in case.

