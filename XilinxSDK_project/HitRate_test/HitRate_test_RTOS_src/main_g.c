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
TaskHandle_t xResetTask;

SemaphoreHandle_t xCmdrcvd2FeeCtrlSemaphore = NULL;
SemaphoreHandle_t xALL2ResetTaskSemaphore = NULL;
SemaphoreHandle_t xResetTask2ALLFeeCtrlSemaphore = NULL;

#endif  // FREE_RTOS

TriggerManager_Config fee;