;===========================================================
;==== Scale_AutoOn.ASM
;===========================================================

Scale_AutoOn_ENTRY:
    CLRF        SysFlag1
    CLRF        SysFlag5
    BSF		    SysFlag1,B_SysFlag1_AdcStart
	BSF         SysFlag5,B_SysFlag5_WdtProcAD
    CLRF		SampleTimes
    MOVFL		buffer0 , 10
    MOVFL		buffer1 , 2

Scale_AutoOn_Timer:
    INCF        T_Auto_Off,F
	MOVLW       60
	SUBWF       T_Auto_Off,W
	BTFSS       STATUS,C
	GOTO        Scale_AutoOn_Timer_END
	CLRF        T_Auto_Off
	CLRF        LockCountH
	CLRF        LockCountL
Scale_AutoOn_Timer_END:

Scale_AutoOn_CFG:
    BSF         NETF,LDOEN
;--- DELAY
	MOVFL       REG0,5
Scale_AutoOn_delay:
    NOP
	DECFSZ      REG0,F
	GOTO        Scale_AutoOn_delay
;---
    MOVLW       00000000B   ; ADC OUT 1953HZ*2
    MOVWF       ADCON
    BSF         NETC ,ADEN
    BSF		    INTE ,ADIE
Scale_AutoOn_Loop:
	CLRWDT
    BCF		    SysFlag1,B_SysFlag1_AdcOk
    HALT
    NOP
    BTFSS		SysFlag1,B_SysFlag1_AdcOk
    GOTO		Scale_AutoOn_Loop
;--- check adc
    MOVFW		AutoOnADL
	SUBWF		ADRamL, W
	MOVFW		AutoOnADm
	SUBWFC		ADRamM, W
	MOVFW	    AutoOnADH
	SUBWFC		ADRamH, W
	BTFSC		STATUS, C
    GOTO		Scale_AutoOn_UP

Scale_AutoOn_Down:
    BTFSC		SysFlag5,B_SysFlag5_WdtTrackB
    GOTO		Scale_Sleep_cfg
    MOVFW		DownADL
    SUBWF		ADRamL, W
    MOVFW		DownADM
    SUBWFC		ADRamM, W
    MOVFW		DownADH
    SUBWFC		ADRamH, W
    BTFSC		STATUS, C
    GOTO		Scale_Sleep_cfg
    BSF		    SysFlag5,B_SysFlag5_WdtTrackS
Scale_AutoOn_Down_Cnt:
    BTFSS       Wakeup_Flags,OnWeightFlag
    GOTO		Scale_Sleep_cfg
    DECFSZ		buffer1, F
    GOTO		Scale_AutoOn_Loop
    BCF         Wakeup_Flags,OnWeightFlag
    GOTO        Scale_Sleep_cfg

Scale_AutoOn_UP:
    BTFSC		SysFlag5,B_SysFlag5_WdtTrackS
    GOTO		Scale_Sleep_cfg
    BSF		    SysFlag5,B_SysFlag5_WdtTrackB
    BTFSC		Wakeup_Flags,OnWeightFlag
    GOTO		Scale_Sleep_cfg
    DECFSZ		buffer0, F
    GOTO		Scale_AutoOn_Loop

Scale_AutoOn_Second:
    MOVLW       00000100B   ; ADC OUT fast
    MOVWF       ADCON
    CLRF        SysFlag1
    BSF		    SysFlag1,B_SysFlag1_AdcStart
    CLRF		SampleTimes
    MOVFL		buffer0, 3
Scale_AutoOn_Second_Loop:
	CLRWDT
    BCF		    SysFlag1,B_SysFlag1_AdcOk
    HALT
    NOP
    BTFSS		SysFlag1,B_SysFlag1_AdcOk
    GOTO		Scale_AutoOn_Second_Loop
    MOVFW       AutoOnCL
	SUBWF		ADRamL, W
    MOVFW       AutoOnCM
	SUBWFC		ADRamM, W
    MOVFW       AutoOnCH
	SUBWFC		ADRamH, W
    BTFSS       STATUS,C
	GOTO        Scale_Sleep_cfg
    DECFSZ      buffer0,F
	GOTO        Scale_AutoOn_Second_Loop
;--- 
Scale_AutoOn_SUCCESS:
	CLRF        Wakeup_Flags
Scale_AutoOn_SUCCESS_0:
    BCF		    INTE ,ADIE
    BCF         NETC ,ADEN
    ;BCF         NETF ,LDOEN
	BSF         Wakeup_Flags  ,WakenOn_Flag
	CLRF        MainFlowValue
	BSF         MainFlowValue,B_MainFlow_Scale
	CLRF        ScaleFlowValue
	BSF         ScaleFlowValue,B_ScaleFlow_INIT
	CLRF        SysFlag2
    CLRF        SysFlag1
    CLRF        SysFlag5
	CLRF        T_Auto_Off
	CLRF        UART_TX_EVENT

Scale_AutoOn_Exit:



