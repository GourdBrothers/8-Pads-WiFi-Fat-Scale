;=============================================
;===== SCALE_CAL_TRG_FLOW.ASM
;=============================================

SCALE_TrgCal_ENTRY:
	BTFSC    Wakeup_Flags,B_WakenOn_Cal_mode
	GOTO     SCALE_TrgCal_WeightMode
;--- KEY CAL TRG MODE
SCALE_TrgCal_KeyMode:
    BTFSC    SysFlag2,B_SysFlag2_TF_05B
    INCF     TimerCal,F
;---
;	BTFSS    SysFlag1,B_SysFlag1_DataOk
;	GOTO     SCALE_TrgCal_EXIT
;	BTFSC    Key_CNT,B_key_Unit
;	GOTO     SCALE_TrgCal_EXIT
;---
    MOVLW    04H
    SUBWF    TimerCal,W
    BTFSS    STATUS,C
    GOTO     SCALE_TrgCal_EXIT
;---
    BCF      SysFlag3,B_SysFlag3_TRG_CAL
    GOTO     SCALE_TrgCal_DONE
;--- Weight CAL TRG MODE
SCALE_TrgCal_WeightMode:
    BTFSS    SysFlag1,B_SysFlag1_DataOk
	GOTO     SCALE_TrgCal_EXIT
	CALL	 CurAD_ZeroAD
    CALL     _Neg3
	MOVLW    200
	SUBWF    TempRam3,W
	MOVLW    00H
	SUBWFC   TempRam2,W
	MOVLW    00H
	SUBWFC   TempRam1,W
	BTFSC    STATUS,C
	GOTO     SCALE_TrgCal_EXIT
;---
    BSF      SysFlag3,B_SysFlag3_TRG_CAL
SCALE_TrgCal_DONE:
	CALL     F_Clr_Timer05S
	CLRF     T_Auto_Off
	CLRF     TimerCal
    BCF      SysFlag3,B_SysFlag3_DspCal
    CLRF     ScaleFlowValue
    BSF      ScaleFlowValue,B_ScaleFlow_CAL 
	CLRF     CalFlowValue
	BSF      CalFlowValue,B_CalFlow_ADC
SCALE_TrgCal_EXIT:
	
