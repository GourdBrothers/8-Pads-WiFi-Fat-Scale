;=====================================
;==== Scale_DISP_CAL.ASM
;=====================================
Scale_DISP_CAL_ENTRY:

	BTFSC   CalFlowValue,B_CalFlow_PASS
	GOTO    Scale_DISP_CAL_PASS
	BTFSC   CalFlowValue,B_CalFlow_ADC
	GOTO    Scale_DISP_CAL_ADC
	BTFSC   CalFlowValue,B_CalFlow_ZERO
	GOTO    Scale_DISP_CAL_ZERO
;---
    BTFSS   SysFlag3,B_SysFlag3_DspCal
	GOTO    Scale_DISP_Dispersion_ADC
Scale_DISP_CalDot:
	BTFSC   CalFlowValue,B_CalFlow_DOT1
	GOTO    Scale_DISP_CAL_DOT1
	BTFSC   CalFlowValue,B_CalFlow_DOT2
	GOTO    Scale_DISP_CAL_DOT2
	BTFSC   CalFlowValue,B_CalFlow_DOT3
	GOTO    Scale_DISP_CAL_DOT3
	
	CLRF    CalFlowValue
	BSF     CalFlowValue,B_CalFlow_ADC
	
Scale_DISP_CAL_ADC:
    MOVFF   TempRam11,H_DR
    MOVFF   TempRam12,M_DR
    MOVFF   TempRam13,L_DR
    CALL    F_HexToBcd
	CALL    Display_Num
Scale_DISP_CAL_ADC_END:
    GOTO    Scale_DISP_CAL_EXIT
	
Scale_DISP_CAL_ZERO:
    MOVFL   Display2,LedchC
    MOVFL   Display3,LedchA
    MOVFL   Display4,LedchL
Scale_DISP_CAL_ZERO_END:
    GOTO    Scale_DISP_CAL_EXIT
	
Scale_DISP_Dispersion_ADC:
    CALL    CurAD_ZeroAD
	CALL    _Neg3
    MOVFF   TempRam11,TempRam1
    MOVFF   TempRam12,TempRam2
    MOVFF   TempRam13,TempRam3
	CALL    F_HexToBcd
	CALL    Display_Num
Scale_DISP_Dispersion_ADC_END:
    GOTO    Scale_DISP_CAL_EXIT
	
Scale_DISP_CAL_DOT1:
    MOVFL   Display2,Ledch5
    MOVFL   Display3,Ledch0
    MOVWF   Display4
    BSF     Display_FALG1,B_Display_FALG1_KG
    BSF     Display3,B_Display3_P1
Scale_DISP_CAL_DOT1_END:
    GOTO    Scale_DISP_CAL_EXIT
	
Scale_DISP_CAL_DOT2:
    MOVFL   Display1,Ledch1
    MOVFL   Display2,Ledch0
    MOVWF   Display3
    MOVWF   Display4
    BSF     Display_FALG1,B_Display_FALG1_KG
    BSF     Display3,B_Display3_P1
Scale_DISP_CAL_DOT2_END:
    GOTO    Scale_DISP_CAL_EXIT

Scale_DISP_CAL_DOT3:
    MOVFL   Display1,Ledch1
    MOVFL   Display2,Ledch5
    MOVFL   Display3,Ledch0
    MOVWF   Display4
    BSF     Display_FALG1,B_Display_FALG1_KG
    BSF     Display3,B_Display3_P1
Scale_DISP_CAL_DOT3_END:
    GOTO    Scale_DISP_CAL_EXIT
	
Scale_DISP_CAL_PASS:
	MOVFL   Display1,LEdchP
    MOVFL   Display2,LEdchA
    MOVFL   Display3,LEdch5
    MOVWF   Display4
Scale_DISP_CAL_PASS_END:

Scale_DISP_CAL_EXIT:

