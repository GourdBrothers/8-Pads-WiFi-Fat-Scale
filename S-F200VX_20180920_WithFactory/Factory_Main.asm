;======================================
;===== Factory_Main.asm
;======================================

Factory_Main_Entry:
	
Factory_Main_Flow:
	BTFSC    FactoryFlowValue,B_FactoryFlowValue_INIT
	GOTO     Factory_Main_Init
	BTFSC    FactoryFlowValue,B_FactoryFlowValue_WAIT
	GOTO     Factory_Main_WaitSeconds
	BTFSC    FactoryFlowValue,B_FactoryFlowValue_CMDCC
	GOTO     Factory_Main_SendCmdCC
	BTFSC    FactoryFlowValue,B_FactoryFlowValue_PASS
	GOTO     Factory_Main_PASS
	CLRF     FactoryFlowValue
	
;---- ≥ı ºªØ
Factory_Main_Init:
Factory_Main_Init_END:
	GOTO    Factory_Main_Flow_END
	
;---- Power WIFI and Init UART
Factory_Main_WaitSeconds:
Factory_Main_WaitSeconds_END:
	GOTO    Factory_Main_Flow_END
	
;---- SEND CMDCC to WIFI MOUDLE
Factory_Main_SendCmdCC:
Factory_Main_SendCmdCC_END:
	GOTO    Factory_Main_Flow_END

;---- RECEIVE WIFI CMD ACK , UARTLINES IS OK
Factory_Main_PASS:
Factory_Main_PASS_END:
	
Factory_Main_Flow_END:
	
;------------------------------------------------------	
Factory_Main_Disp:
	BTFSC    FactoryFlowValue,B_FactoryFlowValue_INIT
	GOTO     Factory_Main_Init
	BTFSC    FactoryFlowValue,B_FactoryFlowValue_WAIT
	GOTO     Factory_Main_WaitSeconds
	BTFSC    FactoryFlowValue,B_FactoryFlowValue_CMDCC
	GOTO     Factory_Main_SendCmdCC
	BTFSC    FactoryFlowValue,B_FactoryFlowValue_PASS
	
Factory_Main_Disp_INIT:
Factory_Main_Disp_INIT_END:
	GOTO     Factory_Main_Disp_END
	
Factory_Main_Disp_WAIT:
Factory_Main_Disp_WAIT_END:
	GOTO     Factory_Main_Disp_END
	
Factory_Main_Disp_CMDCC:
Factory_Main_Disp_CMDCC_END:
	GOTO     Factory_Main_Disp_END
	
Factory_Main_Disp_PASS:
Factory_Main_Disp_PASS_END:
	GOTO     Factory_Main_Disp_END
	
Factory_Main_Disp_END:
	
Factory_Main_Exit:
	
	
	
	