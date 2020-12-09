MoGURA2�{�[�h�J���p�\�t�g�E�F�A�@(2020/12/08 ���k��RCNS ����)

FreeRTOS��œ��삷��A�f�[�^�擾�\�t�g�E�F�A�ł��B

����t���[�Ƃ��Ă�

1. �N���b�N�W�F�l���[�^���̃��W�X�^�̃Z�b�g�A�b�v	 					(setup_peripheral())
2. RF-ADC��MTS���[�h�ł̋N�� 	 							(rfdcADC_MTS_setup())
3. �g���K�[���W�b�N�̃Z�b�g�A�b�v(臒l�Ȃǂ̓K�p) 						(SetSwitchThreshold(),  HardwareTrigger_SetupDeviceId)
4. AXI-DMA�̃Z�b�g�A�b�v										(axidma_setup())
5. TCP/IP, DMA�^�X�N�̍쐬									(xTaskCreate, sys_thread_new)
6. �^�X�N�X�P�W���[���[�N��										(vTaskStartScheduler)
7. DMA�ESPI�EIIC�̊����݃R���g���[���̃Z�b�g�A�b�v					(vApplicationDaemonRxTaskStartupHook())
8. BASELINE�ݒ�pDAC�̃Z�b�g�A�b�v								(BaselineDAC_Config())
9. �f�[�^�擾�J�n											(HardwareTrigger_StartDeviceId())
10. ���ʂ̃o�b�t�@�����܂�܂�DMA�����s���Ȃ���f�[�^�t�H�[�}�b�g�̃`�F�b�N	(axidma_recv_buff(), checkData())
11. ���ʂ̃o�b�t�@�����܂�����PS�̃C�[�T�l�b�g�o�R�Ńf�[�^��]��	 		(send2pc.h��SEND_BUF_SIZE�}�N�������̑��M�T�C�Y��ݒ�\)
12. �����M�f�[�^�ʂ��K��l�ɒB����܂�10,11���J��Ԃ�		�@		(send2pc.h��TOTAL_SEND_SIZE�}�N����葍���M�T�C�Y��ݒ�\)

�ƂȂ��Ă���܂��BMoGURA2�{�[�h�Ǝ��̕���(1�Ԃ����7�Ԃ�IIC�ESPI�����݁A8��)�ȊO�̓���ɂ��āA�]���p�{�[�h�̕��œ���m�F���Ă���܂��B
�Ȃ��A�O��PC�ł̓f�[�^�擾�̂��߂ɊȒP��socke�ʐM��python�ŏ�L�t���[���s�O���瓮�삳���ăf�[�^�擾�����Ă���܂��B

MoGURA2�{�[�h�ł�4�Ԃ�AXI-DMA�̃Z�b�g�A�b�v�ł����Ă����Ԃł��B 
( axidma_setup()->XAxiDma_CfgInitialize()->XAxiDma_Reset()->XAxiDma_WriteReg(RegBase, XAXIDMA_CR_OFFSET, XAXIDMA_CR_RESET_MASK)�ł����� )

�\�[�X�R�[�h�͎��̂悤�ȍ\���ɂȂ��Ă��܂��B

main.c : �e��IP�E���W�b�N�E�y���t�F�����̃Z�b�g�A�b�v
	rfdc_manager.c, rfdc_manager.h							: RF-ADC, DAC�̃Z�b�g�A�b�v���L�q
	axidma_s2mm_manager.c,axidma_s2mm_manager.h 			: AXI-DMA�̃Z�b�g�A�b�v�E���s�Ȃǂ��L�q
	send2pc.c, sendpc.h										: LwIP���g�����O��PC�ւ̃f�[�^�]�����L�q
	hardware_trigger_manager.c, hardware_trigger_manager.h 	: �g���K�[���W�b�N�̃Z�b�g�A�b�v�E�f�[�^�擾�J�n�E��~�����L�q
		trigger_configurator_driver							: �g���K�[���W�b�N�p�̃h���C�o
	peripheral_manager.c, peripheral_manager.c				: �N���b�N�W�F�l���[�^���̃Z�b�g�A�b�v�ESPI/IIC�̓���̋L�q�B(���݂̓��W�X�^��BASELINE�ݒ�pDAC�̂ݎ���)
		peripheral_controller�t�H���_							: �N���b�N�W�F�l���[�^���̃Z�b�g�A�b�v�̂��߂̃h���C�o
		
�]���p�{�[�h�ŉ��L�̂悤�Ȑݒ�Ńf�o�b�O���[�h�œ��삳���Ă���܂����B
Following operations will be performed before launching the debugger.
1. Resets entire system. Clears the FPGA fabric (PL).
2. Resets and clears APU reset.
3. Program FPGA fabric (PL).
4. Runs psu_init to initialize PS.
5. Request trigger for PL powerup and reset. Required after programming FPGA.
6. The following processors will be reset and suspended.
	1) psu_cortexa53_0
7. All processors in the system will be suspended, and Applications will be downloaded to the following processors as specified in the Applications tab.
	1) psu_cortexa53_0 (E:\KRD\XilinxSDK_project\MoGURA2_FEE\MoGURA2_FEE_RTOS\Debug\MoGURA2_FEE_RTOS.elf)
	
��낵�����肢�������܂��B