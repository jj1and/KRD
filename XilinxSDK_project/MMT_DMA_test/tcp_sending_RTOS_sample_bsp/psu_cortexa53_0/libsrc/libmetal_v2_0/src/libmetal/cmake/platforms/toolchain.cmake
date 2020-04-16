set (CMAKE_SYSTEM_PROCESSOR "arm" CACHE STRING "")
set (MACHINE "zynqmp_a53")
set (CROSS_PREFIX "aarch64-none-elf-" CACHE STRING "")
set (CMAKE_C_FLAGS "-O2 -c -g -Wall -Wextra -IC:/Users/npart/KRD/XilinxSDK_project/MMT_DMA_test/tcp_sending_RTOS_sample_bsp/psu_cortexa53_0/include" CACHE STRING "")
set (CMAKE_SYSTEM_NAME "FreeRTOS" CACHE STRING "")
include (CMakeForceCompiler)
CMAKE_FORCE_C_COMPILER ("${CROSS_PREFIX}gcc" GNU)
CMAKE_FORCE_CXX_COMPILER ("${CROSS_PREFIX}g++" GNU)
set (CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER CACHE STRING "")
set (CMAKE_FIND_ROOT_PATH_MODE_LIBRARY NEVER CACHE STRING "")
set (CMAKE_FIND_ROOT_PATH_MODE_INCLUDE NEVER CACHE STRING "")
