;==============================================
;======  Cal.ASM
;======  B_CalFlow_ADC  : 0
;======  B_CalFlow_ZERO : 1
;======  B_CalFlow_DOT1 : 2
;======  B_CalFlow_DOT2 : 3
;======  B_CalFlow_DOT3 : 4
;======  B_CalFlow_PASS : 5
;==============================================

_Cal_Entry:
	
_Cal_TIMER:
	BTFSC       SysFlag2,B_SysFlag2_TF_05B
    INCF        TimerCal,F
_Cal_TIMER_END:	
	
_Cal_FLOW_PRO:	
    BTFSC       CalFlowValue,B_CalFlow_PASS
	GOTO        _Cal_Pass

_Cal_Wait:
    BTFSS       SysFlag3,B_SysFlag3_DspCal
	GOTO        _Cal_Wait_END
    MOVLW       02H
    SUBWF       TimerCal,W
	BTFSS       STATUS,C
	GOTO        _Cal_Exit
    BTFSC       SysFlag1,B_SysFlag1_Steady
	GOTO        _Cal_Exit
    BCF         SysFlag3,B_SysFlag3_DspCal
	CLRF        TimerCal
	GOTO        _Cal_Exit
_Cal_Wait_END:

;----------------------------------------------
;----
    BTFSC       CalFlowValue,B_CalFlow_ADC
	GOTO        _Cal_Adc_Code
    BTFSC       CalFlowValue,B_CalFlow_ZERO
	GOTO        _Cal_zero
    GOTO        _Cal_Track_Zero
    
;-----------------------------------------------	
_Cal_Adc_Code: 
    BTFSS       SysFlag3,B_SysFlag3_TRG_CAL
	GOTO        _Cal_Adc_Code_END
	BCF         SysFlag3,B_SysFlag3_TRG_CAL
    BCF         SysFlag3,B_SysFlag3_DspCal
;--- NEXT FLOW
	CALL        F_CAL_NEXT_FLOW
_Cal_Adc_Code_END:
    GOTO        _Cal_Exit
    
;----------------------------------------------
;----
_Cal_zero:
    MOVLW       02H
    SUBWF       TimerCal,W
	BTFSS       STATUS,C
    GOTO        _Cal_zero_END
	BTFSS       SysFlag1,B_SysFlag1_Steady
    GOTO        _Cal_zero_END
;---
	BSF         SysFlag3,B_SysFlag3_DspCal
;--- NEXT FLOW
	CALL        F_CAL_NEXT_FLOW
_Cal_zero_ADC:
    CALL        F_GetZeroPoint
    CALL        F_GetAutoOnADC
    CALL        F_GetAutoDownADC
_Cal_zero_END:
	GOTO        _Cal_Exit
	
_Cal_Track_Zero:
    BTFSS       SysFlag1,B_SysFlag1_Steady
    GOTO        _Cal_Exit
    CALL        CurAD_ZeroAD
    CALL        _Neg3
    MOVFF       CalDot3H,TempRam2
    MOVFF       CalDot3L,TempRam3
    CLRF        TempRam4
    MOVFL       TempRam5,HIGH 500
    MOVFL       TempRam6,LOW  500
    CALL        _Sub3_3
    BTFSS       STATUS,C
    GOTO        _Cal_zero_ADC
_Cal_Track_Zero_END:


_Cal_DOT_CHK:
    BTFSC        CalFlowValue,B_CalFlow_DOT1
    GOTO         _Cal_CAlDot1
    BTFSC        CalFlowValue,B_CalFlow_DOT2
    GOTO         _Cal_CAlDot2
    BTFSC        CalFlowValue,B_CalFlow_DOT3
    GOTO         _Cal_CAlDot3
    GOTO         _Cal_Exit

_Cal_CAlDot1:
    MOVFF        CalDot1H,CalDot3H
    MOVFF        CalDot1L,CalDot3L
    MOVFF        TempRam3,CalDot1H
    MOVFF        TempRam4,CalDot1L
    MOVFF        TempRam5,HIGH 500
    MOVFF        TempRam6,LOW  500
    CALL         _Sub2_2
    BTFSS        STATUS, C
    GOTO         _Cal_CAlDot1_END
    BSF          SysFlag3,B_SysFlag3_DspCal
;--- NEXT FLOW
	CALL        F_CAL_NEXT_FLOW
_Cal_CAlDot1_END:
    GOTO         _Cal_Exit

_Cal_CAlDot2:
    MOVFF       CalDot2H,CalDot3H
    MOVFF       CalDot2L,CalDot3L
    MOVFF       TempRam5,CalDot1H
    MOVFF       TempRam6,CalDot1L
    BCF         STATUS, C
    RLF         TempRam6, F
    RLF         TempRam5, F
    MOVFF       TempRam3,CalDot2H
    MOVFF       TempRam4,CalDot2L
    CALL		_Sub2_2
    CALL		_Neg2
    MOVFF		TempRam5,TempRam3
    MOVFF		TempRam6,TempRam4
    CLRF		TempRam4
	CLRF        TempRam11
    CLRF		TempRam12
    MOVFL		TempRam13, 100
    CALL		_Mul3_3
    CLRF		TempRam11
    MOVFF		TempRam12,CalDot1H
    MOVFF		TempRam13,CalDot1L
    CALL		_Div6_3
    CALL		_ProcAdd1
    MOVLW		10
    SUBWF		TempRam6, W
    BTFSC		STATUS, C
    GOTO		_Cal_CAlDot2_END
    BSF         SysFlag3,B_SysFlag3_DspCal
;--- NEXT FLOW
	CALL        F_CAL_NEXT_FLOW
_Cal_CAlDot2_END:
    GOTO		_Cal_Exit
	

_Cal_CAlDot3:
    MOVFF		TempRam5,CalDot1H
    MOVFF		TempRam6,CalDot1L
    BCF		    STATUS  , C
    RLF		    TempRam6, F
    RLF		    TempRam5, F
    MOVFW		CalDot1L
    ADDWF		TempRam6, F
    MOVFW		CalDot1H
    ADDWFC		TempRam5, F
    MOVFF		TempRam3,CalDot3H
    MOVFF		TempRam4,CalDot3L
    CALL		_Sub2_2
    CALL		_Neg2
    MOVFF		TempRam5,TempRam3
    MOVFF		TempRam6,TempRam4
    CLRF		TempRam4
	CLRF        TempRam11
    CLRF		TempRam12
    MOVFL		TempRam13, 100
    CALL		_Mul3_3
    CLRF		TempRam11
    MOVFF		TempRam12,CalDot1H
    MOVFF		TempRam13,CalDot1L
    CALL		_Div6_3
    CALL		_ProcAdd1
    MOVLW		10
    SUBWF		TempRam6, W
    BTFSC		STATUS, C
    GOTO		_Cal_Exit

_Cal_Save_Dots:
	CALL        ClrLEDBuffer
    CALL        LoadDspData
;--- Write
    MOVFL       Cal_MARK,0AAH
    CALL        F_18MXX_BLE_CAL_WR
    CALL        F_18MXX_BLE_CAL_RD
;--- NEXT FLOW
	CALL        F_CAL_NEXT_FLOW
    GOTO        _Cal_Exit

_Cal_Pass:
    MOVLW       04H
    SUBWF       TimerCal,W
    BTFSS       STATUS,C
    GOTO        _Cal_Exit
    CLRF        TimerCal
    CLRF        UnitFlag
    BSF         UnitFlag,KgFlag
    CLRF        CountH
    CLRF        CountL
    MOVFL       LockCountH,HIGH 3000
    MOVFL       LockCountL,LOW  3000
    CLRF        SysFlag1
    CLRF        SysFlag2
    CLRF        SysFlag3
    CLRF        SysFlag4
    CLRF        SysFlag5
    CLRF        TimerCal
    CLRF        T_Auto_Off
    CLRF        SampleTimes
    CLRF        StableCount
    BSF         SysFlag1,B_SysFlag1_AdcStart
    CLRF        ScaleFlowValue
    BSF         ScaleFlowValue,B_ScaleFlow_Weight
    CLRF        CalFlowValue
_Cal_Exit:



