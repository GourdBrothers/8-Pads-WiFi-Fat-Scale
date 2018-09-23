;=============================================
;====== ISR_Handle.ASM
;=============================================

ISR_Entry:
    MOVWF       ISR_WORK_BACK
    MOVFF       ISR_STATUS_BACK,STATUS
    MOVFF       ISR_BSR_BACK   ,BSR
    MOVFF       ISR_FSR0_BACK  ,FSR0
    MOVFF       ISR_FSR1_BACK  ,FSR1
ISR_Chk:
	BTFSC       INTF2,URRIF
	GOTO        ISR_UART0_RX
	BTFSC       INTF,TM1IF
	GOTO        ISR_TM1
	BTFSC       INTF2,RTCIF
	GOTO        ISR_RTC
    BTFSC       INTF,ADIF
	GOTO        ISR_ADC
	BTFSC       INTF,AD2IF
	GOTO        ISR_10BIT_ADC
	BTFSC       INTF,TM0IF
	GOTO        ISR_TM0
	BTFSC       INTF,E0IF
	GOTO        ISR_INT0
	BTFSC       INTF,E1IF
	GOTO        ISR_INT1
;	CLRF		INTF
;	CLRF		INTF2
ISR_Exit:
    MOVFF       STATUS,ISR_STATUS_BACK
    MOVFF       BSR   ,ISR_BSR_BACK
    MOVFF       FSR0  ,ISR_FSR0_BACK
    MOVFF       FSR1  ,ISR_FSR1_BACK
	MOVFW       ISR_WORK_BACK
RETFIE

ISR_RTC:
	BCF         INTF2,RTCIF
	INCF        RTC_Base,F
	MOVLW       02H
	SUBWF       RTC_Base,W
	BTFSS       STATUS,C
	GOTO        ISR_RTC_END
	CLRF        RTC_Base
	BSF         Wakeup_Flags,B_WakenOn_RTC
ISR_RTC_END:
	GOTO        ISR_Exit
	
ISR_UART0_RX:
	BCF         INTF2,URRIF
	MOVFF       UART_RX_BUF,SBUF
;---
	INCLUDE     ISR_UART_RX.asm
ISR_UART0_RX_END:
	GOTO        ISR_Exit
	
	
;--- ADC INT
ISR_ADC:
    BCF         INTF,ADIF
 ;---
    BSF         SysFlag3,B_SysFlag3_KScan
    INCF        Key_Timer,F
 ;--- 
    BSF         BatFlag,B_BatFlag_CHK

    BTFSC       Wifi_SmartCfg,B_Wifi_SmartCfg_EN
	BSF         Wifi_SmartCfg,B_Wifi_SmartCfg_T

 ;---
    BTFSC       SysFlag1,B_SysFlag1_AdcOk
	GOTO        ISR_ADC_END
    INCF        SampleTimes,F
ISR_ADC_DIS3:
    BTFSS       SysFlag1,B_SysFlag1_AdcStart
	GOTO        ISR_ADC_DIS3_END
	MOVLW       003H
	SUBWF       SampleTimes,W
	BTFSS       STATUS,C
	GOTO        ISR_ADC_END
	BCF		    SysFlag1,B_SysFlag1_AdcStart	
	CLRF		SampleTimes
	CLRF		AD_Temp0
	CLRF		AD_Temp1
	CLRF		AD_Temp2
	CLRF		AD_Temp3
	GOTO        ISR_ADC_END
ISR_ADC_DIS3_END:

ISR_ADC_READ:
    MOVFF		ADRamH, ADOH
    MOVFF		ADRamM, ADOL
    MOVFF		ADRamL, ADOLL
	MOVLW       080H
	XORWF       ADRamH,F
ISR_ADC_AutoOn:
	BTFSS       SysFlag5,B_SysFlag5_WdtProcAD
	GOTO        ISR_ADC_SUM
	MOVFL       AdcCount,07H
ISR_ADC_AutoOn_LOOP:
    BCF         STATUS,C
	RRF         ADRamH,F
	RRF         ADRamM,F
	RRF         ADRamL,F
    DECFSZ      AdcCount,F
	GOTO        ISR_ADC_AutoOn_LOOP
	GOTO        ISR_ADC_OK
ISR_ADC_SUM:
    MOVFW		ADRamL
    ADDWF		AD_Temp3, F
    MOVFW		ADRamM
    ADDWFC		AD_Temp2, F
    MOVFW		ADRamH
    ADDWFC		AD_Temp1, F
    MOVLW		00H
    ADDWFC		AD_Temp0, F
    MOVLW       008H
	SUBWF       SampleTimes,W
	BTFSS       STATUS,C
	GOTO        ISR_ADC_END
    CLRF		SampleTimes
ISR_ADC_RRFX:
    MOVFL       AdcCount,7+3  ; 6 + 3
ISR_ADC_RRFX_LOOP:
    BCF		    STATUS, C
    RRF		    AD_Temp0, F
    RRF		    AD_Temp1, F
    RRF		    AD_Temp2, F
    RRF		    AD_Temp3, F
    DECFSZ      AdcCount,F
	GOTO        ISR_ADC_RRFX_LOOP
    MOVFF		H_DATA,AD_Temp1
    MOVFF		M_DATA,AD_Temp2
    MOVFF		L_DATA,AD_Temp3
    CLRF		AD_Temp0
    CLRF		AD_Temp1
    CLRF		AD_Temp2
    CLRF		AD_Temp3
ISR_ADC_OK:
    BSF		    SysFlag1,B_SysFlag1_AdcOk
ISR_ADC_END:
	GOTO        ISR_Exit

ISR_TM0:
	BCF         INTF,TM0IF
	INCLUDE     ISR_TIMER0.ASM
ISR_TM0_END:
	GOTO        ISR_Exit
	
ISR_TM1:
	BCF         INTF,TM1IF
;---
	INCLUDE     ISR_LED.ASM
ISR_TM1_END:	
	GOTO        ISR_Exit
	
ISR_10BIT_ADC:
    BCF         INTF,AD2IF
;---
	BCF         INTF ,AD2IF
    BCF         AD2OH    ,7
;---
	BTFSC       BatFlag,B_BatFlag_ADC_OK
	GOTO        ISR_10BIT_ADC_END
	MOVFF       BAT_VAL_H,AD2OH
	MOVFF       BAT_VAL_L,AD2OL
	BCF         STATUS,C
	RRF         BAT_VAL_H,F
	RRF         BAT_VAL_L,F
	BCF         STATUS,C
	RRF         BAT_VAL_H,F
	RRF         BAT_VAL_L,F
	BSF         BatFlag,B_BatFlag_ADC_OK
ISR_10BIT_ADC_END:
	GOTO        ISR_Exit
	
ISR_INT0:
	BCF         INTF,E0IF
ISR_INT0_END:
	GOTO        ISR_Exit

ISR_INT1:
	BCF         INTF,E1IF
ISR_INT1_END:
	GOTO        ISR_Exit
	
	
	
	
	