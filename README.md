# About KRD
A detector's electronics development project. Verilog-HDL is mainly used.

# Directory explanation

* proto_ip_code
  * This directory contains HDL-code before IP-packaging. So, it is updated very frequently.

* ip_repo
  * This directory contains user packaged IPs. The behavior is confirmed at least level.

* hardware_files
  * Bitstream files which meet timing closure. You can create XSDK project by importing this file.

* project_tcl
  * You can create a vivado project by running tcl scripts. The update rate will be slow it's beacause  some sources are managed manually.

* project_rtl
  * These codes are old ones. Very similar to "trash".

* trash
  * Trash code. I save them just in case.

