/*
 * platform_config.h
 *
 *  Created on: 2020/05/08
 *      Author: npart
 */

#ifndef SRC_PLATFORM_CONFIG_H_
#define SRC_PLATFORM_CONFIG_H_

#define PLATFORM_ZYNQMP
#define FREE_RTOS

// #define XPS_ZCU111_BOARD
#define MOGURA2_TED_BOARD

#define UART_DEVICE_ID 0
#define PLATFORM_EMAC_BASEADDR XPAR_XEMACPS_0_BASEADDR

#endif /* SRC_PLATFORM_CONFIG_H_ */
