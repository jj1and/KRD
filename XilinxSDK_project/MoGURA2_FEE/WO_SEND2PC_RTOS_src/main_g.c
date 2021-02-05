#include "hardware_trigger_manager.h"
#include "platform_config.h"

#ifdef FREE_RTOS
#include "FreeRTOS.h"
#include "queue.h"
#include "semphr.h"
#include "task.h"
TaskHandle_t cleanup_thread;
TaskHandle_t cmd_thread;
TaskHandle_t xDmaTask;
TaskHandle_t app_thread;
TaskHandle_t xPeripheralSetupTask;

SemaphoreHandle_t xCmdrcvd2DmaSemaphore = NULL;
SemaphoreHandle_t xDma2Send2pcSemaphore = NULL;

int DmaTaskState;

#endif  // FREE_RTOS

TriggerManager_Config fee;