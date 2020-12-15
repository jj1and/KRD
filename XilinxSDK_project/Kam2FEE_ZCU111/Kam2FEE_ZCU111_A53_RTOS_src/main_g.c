#include "platform_config.h"

#ifdef FREE_RTOS
#include "FreeRTOS.h"
#include "semphr.h"
#include "task.h"

TaskHandle_t cmd_thread;
TaskHandle_t xDmaTask;
TaskHandle_t app_thread;
TaskHandle_t xPeripheralSetupTask;

SemaphoreHandle_t xCmdrcvd2DmaSemaphore = NULL;
SemaphoreHandle_t xDma2Send2pcSemaphore = NULL;

#endif  // FREE_RTOS