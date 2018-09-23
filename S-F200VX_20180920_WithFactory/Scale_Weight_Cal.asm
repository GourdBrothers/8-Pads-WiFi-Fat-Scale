;==========================================
;====    Scale_Weight_Cal.ASM
;==========================================

W_CAL_Handle_Entry:
    BTFSS   W_CAL_Flag,B_W_CAL_Flag_EN
	GOTO    W_CAL_Handle_Clr
	BTFSS   W_CAL_Flag,B_W_CAL_Flag_TRG
	GOTO    W_CAL_Handle_Exit
	BCF     W_CAL_Flag,B_W_CAL_Flag_TRG
;---
	BTFSC   W_CAL_Flag,B_W_CAL_Flag_1
	GOTO    W_CAL_Handle_First
	BTFSC   W_CAL_Flag,B_W_CAL_Flag_2
	GOTO    W_CAL_Handle_Second
	BTFSC   W_CAL_Flag,B_W_CAL_Flag_3
	GOTO    W_CAL_Handle_Third
    GOTO    W_CAL_Handle_Clr
W_CAL_Handle_First:
    MOVLW   LOW  3000 ;500
	SUBWF   W_CAL_ADC_L,W
	MOVLW   HIGH 3000 ;500
	SUBWFC  W_CAL_ADC_H,W
	BTFSS   STATUS,C
	GOTO    W_CAL_Handle_Clr
	MOVFF   W_CAL1_ADC_H,W_CAL_ADC_H
	MOVFF   W_CAL1_ADC_L,W_CAL_ADC_L
;---
    BCF     W_CAL_Flag,B_W_CAL_Flag_1
    BSF     W_CAL_Flag,B_W_CAL_Flag_2
W_CAL_Handle_First_END:
    GOTO    W_CAL_Handle_Exit

W_CAL_Handle_Second:
	CLRF    REG0
	MOVFL   REG1,200
	CALL    F_CHECK_SENSOR_RANGE_AND_LINE
	BTFSC   STATUS,C
    GOTO    W_CAL_Handle_Exit
	MOVFF   W_CAL2_ADC_H,W_CAL_ADC_H
	MOVFF   W_CAL2_ADC_L,W_CAL_ADC_L
;---
    BCF     W_CAL_Flag,B_W_CAL_Flag_2
    BSF     W_CAL_Flag,B_W_CAL_Flag_3
W_CAL_Handle_Second_END:
    GOTO    W_CAL_Handle_Exit

W_CAL_Handle_Third:
	MOVFL   REG0,HIGH 300
	MOVFL   REG1,LOW  300
	CALL    F_CHECK_SENSOR_RANGE_AND_LINE
	BTFSC   STATUS,C
	GOTO    W_CAL_Handle_Clr
	MOVFF   W_CAL3_ADC_H,W_CAL_ADC_H
	MOVFF   W_CAL3_ADC_L,W_CAL_ADC_L
W_CAL_Handle_Third_END:
;---
	MOVFF    CalDot1H,W_CAL1_ADC_H
	MOVFF    CalDot1L,W_CAL1_ADC_L
	MOVFF    CalDot2H,W_CAL2_ADC_H
	MOVFF    CalDot2L,W_CAL2_ADC_L
	MOVFF    CalDot3H,W_CAL3_ADC_H
	MOVFF    CalDot3L,W_CAL3_ADC_L
W_CAL_Handle_PASS:
;--- WR the Cal data
	MOVLW    0AAH
	MOVWF    Cal_MARK
	CALL     F_18MXX_BLE_CAL_WR
    CALL     F_18MXX_BLE_CAL_RD
;--- to cal pass flow
    CLRF     CalFlowValue
	BSF      CalFlowValue,B_CalFlow_PASS
	CLRF     ScaleFlowValue
	BSF      ScaleFlowValue,B_ScaleFlow_CAL
	CLRF     TimerCal
	CALL     F_Clr_Timer05S
	
W_CAL_Handle_Clr:
	BTFSS    SysFlag4,B_SysFlag4_OverLoad
    CLRF     W_CAL_Flag

W_CAL_Handle_Exit:




