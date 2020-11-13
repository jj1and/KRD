# About KRD
A detector's electronics development project. Verilog-HDL is mainly used.

# Directory explanation

## proto_ip_code
  * This directory contains HDL-code before IP-packaging.

## common_source
  * This contains the source code commonly used in `proto_ip_code`.

## ip_repo
  * This directory contains User-packaged IPs and User-defined interface or System Generator IP.

## project_tcl
  * You can create a vivado project by running tcl scripts. After running the tcl, the project folder will be created but git will not trace it. It's because the actual project directory is too large to be managed by git. you can create vivado project file by running the command below on PowerShell.
    ```
    cd <directory_project_tcl_exists>

    vivado -source <project_name>.tcl
    ```
    If "vivado" command is not found, please check `/path/to/vivado/installed/bin` is added for your system path.
    (For windows, `/path/to/vivado/installed/bin/unwrapped/win64.o` is also needed.)

  * typical directory structure in `project_tcl` is like below.
    ```
    <project_directory>
    ├── hoge.xdc                      # constraint file
    ├── piyo.xdc                      # constraint file
    ├── <project_name>.tcl            # tcl script to create vivado project files
    ├── <project_name>_def_val.txt    # ref file to create vivado project files
    ├── <project_name>_dump.txt       # ref file to create vivado project files
    ├── <Xilinx_IP_directory>         # the directory of Xilinx IP's custom information files(.xci file)
    ├── <hdf_directory>               # hardware file and debug nets included
    │   ├── foo.ltx                   # debug probe file
    │   └── bar.hdf                   # hardware file
    └── bar_wrapper.v                 # wrapper verilog code of design in th vivado project
    ```
  
  * the directory of Xilinx IP's custom information file (.xci file) must be located in the same directory which the tcl script exists. You can set the loaction by Vivado `"Tools -> Settings -> IP -> Default IP location"`

## Xilinx_SDK_project
  * contains XSDK project directory. XSDK project directory refers corresponded `hdf` directory in project_tcl

## SysGen_project
  * contains MATLAB & Simulink project which uses System Generator for DSP

## trash
  * Trash code. I save them just in case.

# How to update 

## Update "proto_ip_code", "project_tcl" and "ip_repo" (without using System Generator for DSP)
  1. Edit HDL codes or create directory for new user IP  in `proto_ip_code`
      * Example: create directory `KRD/proto_ip_code/my_new_module` and add HDL files for this IP
  2. If you would like to track vivado project for test or product, please follow the process below.
      <details><summary>how to create new project</summary>

        1. Create new project directory to board-name directory in `project_tcl`. You should create new board-name directory if your project is for new board.
        2. Create vivado project direncory in this directory. You need to put included HDL files (which isn't contained in `proto_ip_code`) to the project directory.
        3. Create tcl script for generating project. You can create with `"File -> Project -> Write_tcl..."`  
        4. **add the vivado project directory to `".gitignore"`**
      
      * Example:  
          1. create directory `KRD/project_tcl/new_board/my_new_module_test`
          2. `KRD/project_tcl/new_board/my_new_module_test/my_new_module_test/` in project_tcl.  
          (this directory contains vivado project files such as `.xpr`.)
          3. Create tcl script for generating project.  
          ![write_tcl settings example](/figs/write_tcl.png)
          4. **add `KRD/project_tcl/new_board/my_new_module_test/my_new_module_test` to `".gitignore"`**
      </details>
  3. When you updated the vivado project, please recreate tcl script for generating project.
  4. Create `hdf` directory in the project directory. After generating hdf file or bitstream file or both, please export those files to `hdf` directory.  
  You can export hdf file by `"File -> Export -> Export Hardware..."`.  
  You can export Bitstream file by `"File -> Export -> Export Bitstream File..."`
      * Example:  
          1. create `KRD/project_tcl/new_board/my_new_module_test/hdf`
          2. Export `design_1_wrapper.hdf` and `my_new_module_test.bit` in the `hdf` directory.  
          (`design_1_wrapper.hdf` will be change as your top module HDL file name in the vivado project.)
  5. If you have ILA core in the vivado project, please export `debug_probe_nets.ltx` to the `hdf` directory.  
  You can export `debug_probe_nets.ltx` by command `write_debug_probes -force /path/to/project/directory/debug_probe_nets.ltx` with tcl console in  **"IMPLEMENTED DESIGN"** window.
      * Example:  
          1. open "IMPLEMENTED DESIGN" window.
          2. command `write_debug_probes -force KRD/project_tcl/new_board/my_new_module_test/hdf/debug_probe_nets`
  6. After confirmed the update or created module behavior is valid, please package your new module to IP.  
  You can create IP by `"Tools -> Create and Package new IP..."`(Please set ip location to `KRD/ip_repos/proto_ip_outputs`)  
  I recommend create other vivado project for only packaging your HDL codes. (This project doesn't need to be tracked.)

## Update "ip_repo" with using System Generator for DSP
With using System Generator for DSP, please check [Xilinx document UG948](https://japan.xilinx.com/support/documentation-navigation/see-all-versions.html?xlnxproducttypes=Design%20Tools&xlnxdocumentid=UG948).  
* Please set or copy ouputs to `KRD/ip_repos/SysGen_outputs`

## Update XilinxSDK_project
now writing...