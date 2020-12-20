#include "hardware_trigger_manager.h"
#include "platform_config.h"

#ifdef FREE_RTOS
#include "FreeRTOS.h"
#include "queue.h"
#include "semphr.h"
#include "task.h"

TaskHandle_t cleanup_thread;
TaskHandle_t cmd_thread;
TaskHandle_t xPeripheralSetupTask;
TaskHandle_t xFeeCtrlTask;

SemaphoreHandle_t xCmdrcvd2FeeCtrlSemaphore = NULL;

#endif  // FREE_RTOS

TriggerManager_Config fee;