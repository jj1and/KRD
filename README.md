# About KRD
A detector's electronics development project. Verilog-HDL is mainly used.

# Directory explanation

* proto_ip_code
  * This directory contains HDL-code before IP-packaging.

* ip_repo
  * This directory contains User-packaged IPs and User-defined interface.

* project_tcl
  * You can create a vivado project by running tcl scripts. After running the tcl, the project folder will be created but git will not trace it. It's because the actual project directory is too large to be managed by git. you can create vivado project file by running the command below on PowerShell.
    ```
    cd <directory_project_tcl_exists>

    vivado -source <project_name>.tcl
    ```
  * typical directory structure is like below.
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
  
  * the directory of Xilinx IP's custom information file (.xci file) must be located in the same directory which the tcl script exists. You can set the loaction by Vivado ```"Tools -> Settings -> IP -> Default IP location"```

  * When you add a new directory to this directory, **DO NOT FORGET the vivado project directory to ```".gitignore"```**

* common_source
  * This contains the source code commonly used.   

* project_rtl
  * These codes are old ones. Very similar to "trash".

* trash
  * Trash code. I save them just in case.

