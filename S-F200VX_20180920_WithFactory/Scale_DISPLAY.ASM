;==========================================
;==== Scale_DISPLAY.ASM
;==========================================
Scale_DISPLAY_ENTRY:
    CALL     ClrLEDBuffer

    BTFSC    ScaleFlowValue,B_ScaleFlow_ZERO
	GOTO     Scale_DISPLAY_ZERO
    BTFSC    ScaleFlowValue,B_ScaleFlow_Weight
	GOTO     Scale_DISPLAY_WEIGHT
    BTFSC    ScaleFlowValue,B_ScaleFlow_CAL
	GOTO     Scale_DISPLAY_CAL
	BTFSC    ScaleFlowValue,B_ScaleFlow_TrgCal
	GOTO     Scale_DISPLAY_TRG_CAL
    GOTO     Scale_DISPLAY_EXIT

Scale_DISPLAY_ZERO:
    CALL     SetAllLEDBuffer
Scale_DISPLAY_ZERO_END:
    GOTO     Scale_DISPLAY_LOAD
    
Scale_DISPLAY_WEIGHT:

	;--- TEST!!!
;TEST_DISP_ADC2:
;    CLRF     TempRam11
;    MOVFF    TempRam12,BAT_VoltageH ;BAT_VAL_H
;    MOVFF    TempRam13,BAT_VoltageL ;BAT_VAL_L
;    CALL     F_HexToBcd
;	CALL     Display_NumADC
;TEST_DISP_ADC2_END:
;	GOTO     Scale_DISPLAY_LOAD
	;--- TEST!!!

Scale_DISPLAY_LO:
    BTFSS    BatFlag,B_BatFlag_Low
	GOTO     Scale_DISPLAY_LO_END
    MOVFL    Display2,LedchL
    MOVFL    Display3,LedchO
    GOTO     Scale_DISPLAY_WEIGHT_END
Scale_DISPLAY_LO_END:

Scale_DISPLAY_Neg:
	BTFSS	 SysFlag3,B_SysFlag3_DspNeg
	GOTO     Scale_DISPLAY_Neg_END
	MOVFL    Display1,LedchBar
    MOVWF    Display2
    MOVWF    Display3
    MOVWF    Display4
    GOTO     Scale_DISPLAY_WEIGHT_END
Scale_DISPLAY_Neg_END:

Scale_DISPLAY_OverLoad:
	BTFSS    SysFlag4,B_SysFlag4_OverLoad
	GOTO     Scale_DISPLAY_OverLoad_END
    MOVFL    Display2,LedchE
    MOVFL    Display3,Ledchr
    MOVFL    Display4,Ledchr
	GOTO     Scale_DISPLAY_WEIGHT_END
Scale_DISPLAY_OverLoad_END:
	
Scale_DISPLAY_WEIGHT_Normal:
    CALL     Scale_Disp_W_ENTRY
Scale_DISPLAY_WEIGHT_END:
	
Scale_DISPLAY_WifiCfg:	
	BTFSS    Wifi_SmartCfg,B_Wifi_SmartCfg_Flash
	GOTO     Scale_DISPLAY_Online
	BSF      Display_FALG1,B_Display_FALG1_BLE
Scale_DISPLAY_WifiCfg_END:

Scale_DISPLAY_Online:
	BTFSS    WifiStatus,B_WifiStatus_LINK
	GOTO     Scale_DISPLAY_Online_end
	BSF      Display_FALG1,B_Display_FALG1_BLE
Scale_DISPLAY_Online_end:	
    GOTO     Scale_DISPLAY_LOAD

Scale_DISPLAY_CAL:
    INCLUDE  Scale_DISP_CAL.ASM
Scale_DISPLAY_CAL_END:
	GOTO     Scale_DISPLAY_LOAD

Scale_DISPLAY_TRG_CAL:
	BTFSS    Wakeup_Flags,B_WakenOn_Cal_mode
	GOTO     Scale_DISPLAY_TRG_CAL_KEY
Scale_DISPLAY_TRG_CAL_Weight:
    MOVFF    TempRam11,H_DR
    MOVFF    TempRam12,M_DR
    MOVFF    TempRam13,L_DR
    CALL     F_HexToBcd
	CALL     Display_Num
	GOTO     Scale_DISPLAY_TRG_CAL_END
Scale_DISPLAY_TRG_CAL_KEY:
    MOVFL    Display2,LEdchA
    MOVFL    Display3,LEdch0
    MOVFL    Display4,LEdch0
Scale_DISPLAY_TRG_CAL_END:
;----------------------------------------------

Scale_DISPLAY_LOAD:
    CALL     LoadDspData

Scale_DISPLAY_EXIT:




