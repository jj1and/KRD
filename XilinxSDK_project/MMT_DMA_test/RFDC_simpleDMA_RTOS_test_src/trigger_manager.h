#ifndef __TRIGGER_MANAGER_H_
#define __TRIGGER_MANAGER_H_

#define XPS_BOARD_ZCU111
#include "trigger_manager.h"

int trigger_setup(int16_t threshold, u16 baseline, u8 pre_acuqi_len);

#endif
