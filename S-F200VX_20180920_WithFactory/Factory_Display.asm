;==========================================================
;===== Factory_Display.ASM
;==========================================================
Factory_Disp_Entry:

Factory_Main_Disp_CLR:
    CALL     ClrLEDBuffer
    
Factory_Disp_FlowChk:
	BTFSC    FactoryFlowValue,B_FactoryFlowValue_INIT
	GOTO     Factory_Main_Disp_INIT
	BTFSC    FactoryFlowValue,B_FactoryFlowValue_WAIT
	GOTO     Factory_Main_Disp_WAIT
	BTFSC    FactoryFlowValue,B_FactoryFlowValue_ADC
	GOTO     Factory_Main_Disp_ADC
	BTFSC    FactoryFlowValue,B_FactoryFlowValue_CMDCC
	GOTO     Factory_Main_Disp_CMDCC
	BTFSC    FactoryFlowValue,B_FactoryFlowValue_ChkLo
	GOTO     Factory_Main_Disp_ChkLo
	BTFSC    FactoryFlowValue,B_FactoryFlowValue_PASS
	GOTO     Factory_Main_Disp_PASS
	BTFSC    FactoryFlowValue,B_FactoryFlowValue_ERR
	GOTO     Factory_Main_Disp_ERR
	
Factory_Main_Disp_INIT:
	; do nothing
Factory_Main_Disp_INIT_END:
	GOTO     Factory_Main_Disp_Load
	
Factory_Main_Disp_WAIT:
	CALL     SetAllLEDBuffer
Factory_Main_Disp_WAIT_END:
	GOTO     Factory_Main_Disp_Load
	
Factory_Main_Disp_ADC:
	MOVFF    TempRam11,H_DATA
    MOVFF    TempRam12,M_DATA
    MOVFF    TempRam13,L_DATA
    CALL     F_HexToBcd
	CALL     Display_NumADC
Factory_Main_Disp_ADC_END:
	GOTO     Factory_Main_Disp_Load
	
Factory_Main_Disp_CMDCC:
	CLRF     TempRam11
    CLRF     TempRam12
    MOVFF    TempRam13,Fac_TimeOff
    CALL     F_HexToBcd
	CALL     Display_NumADC
Factory_Main_Disp_CMDCC_END:
	GOTO     Factory_Main_Disp_Load
	
Factory_Main_Disp_ChkLo:
	CLRF     TempRam11
    MOVFF    TempRam12,BAT_VAL_H
    MOVFF    TempRam13,BAT_VAL_L
    CALL     F_HexToBcd
	CALL     Display_NumADC
Factory_Main_Disp_ChkLo_END:
	GOTO     Factory_Main_Disp_Load
	
Factory_Main_Disp_PASS:
	MOVFL    Display1,LedchF
    MOVFL    Display2,LedchP
    MOVFL    Display3,LedchA
    MOVFL    Display4,Ledch5
Factory_Main_Disp_PASS_END:
	GOTO     Factory_Main_Disp_Load
	
Factory_Main_Disp_ERR:
	MOVFL    Display1,LedchE
    MOVFL    Display2,Ledchr
    MOVFL    Display3,Ledchbar
    MOVFW	 Fac_ErrNum
    CALL	 Led_Num
    IORWF	 Display4,F
Factory_Main_Disp_ERR_END:
	GOTO     Factory_Main_Disp_Load
	
Factory_Main_Disp_Load:
	CALL     LoadDspData
	
Factory_Disp_EXIT:
	