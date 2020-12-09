MoGURA2ボード開発用ソフトウェア　(2020/12/08 東北大RCNS 中村)

FreeRTOS上で動作する、データ取得ソフトウェアです。

動作フローとしては

1. クロックジェネレータ等のレジスタのセットアップ	 					(setup_peripheral())
2. RF-ADCのMTSモードでの起動 	 							(rfdcADC_MTS_setup())
3. トリガーロジックのセットアップ(閾値などの適用) 						(SetSwitchThreshold(),  HardwareTrigger_SetupDeviceId)
4. AXI-DMAのセットアップ										(axidma_setup())
5. TCP/IP, DMAタスクの作成									(xTaskCreate, sys_thread_new)
6. タスクスケジューラー起動										(vTaskStartScheduler)
7. DMA・SPI・IICの割込みコントローラのセットアップ					(vApplicationDaemonRxTaskStartupHook())
8. BASELINE設定用DACのセットアップ								(BaselineDAC_Config())
9. データ取得開始											(HardwareTrigger_StartDeviceId())
10. 一定量のバッファがたまるまでDMAを実行しながらデータフォーマットのチェック	(axidma_recv_buff(), checkData())
11. 一定量のバッファがたまったらPSのイーサネット経由でデータを転送	 		(send2pc.hのSEND_BUF_SIZEマクロより一回の送信サイズを設定可能)
12. 総送信データ量が規定値に達するまで10,11を繰り返す		　		(send2pc.hのTOTAL_SEND_SIZEマクロより総送信サイズを設定可能)

となっております。MoGURA2ボード独自の部分(1番および7番のIIC・SPI割込み、8番)以外の動作について、評価用ボードの方で動作確認しております。
なお、外部PCではデータ取得のために簡単なsocke通信をpythonで上記フロー実行前から動作させてデータ取得をしております。

MoGURA2ボードでは4番のAXI-DMAのセットアップでこけている状態です。 
( axidma_setup()->XAxiDma_CfgInitialize()->XAxiDma_Reset()->XAxiDma_WriteReg(RegBase, XAXIDMA_CR_OFFSET, XAXIDMA_CR_RESET_MASK)でこける )

ソースコードは次のような構成になっています。

main.c : 各種IP・ロジック・ペリフェラルのセットアップ
	rfdc_manager.c, rfdc_manager.h							: RF-ADC, DACのセットアップを記述
	axidma_s2mm_manager.c,axidma_s2mm_manager.h 			: AXI-DMAのセットアップ・実行などを記述
	send2pc.c, sendpc.h										: LwIPを使った外部PCへのデータ転送を記述
	hardware_trigger_manager.c, hardware_trigger_manager.h 	: トリガーロジックのセットアップ・データ取得開始・停止等を記述
		trigger_configurator_driver							: トリガーロジック用のドライバ
	peripheral_manager.c, peripheral_manager.c				: クロックジェネレータ等のセットアップ・SPI/IICの動作の記述。(現在はレジスタとBASELINE設定用DACのみ実装)
		peripheral_controllerフォルダ							: クロックジェネレータ等のセットアップのためのドライバ
		
評価用ボードで下記のような設定でデバッグモードで動作させておりました。
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
	
よろしくお願いいたします。