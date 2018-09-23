;===========================================================
;======== ISR_TIMER0.ASM
;=== 10MS
;===========================================================

ISR_TIMER0_RX_TIMEOUT:
    BTFSS       UartRxFlag,B_UartRxFlag_TRG
    GOTO        ISR_TIMER0_RX_TIMEOUT_END
    INCF        R_UartRXTimer,F 
    MOVLW       3
    SUBWF       R_UartRXTimer,W
    BTFSS       STATUS,C
    GOTO        ISR_TIMER0_RX_TIMEOUT_END
    CLRF        UartRxFlag
    CLRF        R_UartRxCnt
    CLRF        R_UartRXTimer
ISR_TIMER0_RX_TIMEOUT_END:

ISR_TIMER0_LOCK:
    BTFSS       SysFlag4,B_SysFlag4_Lock
	GOTO        ISR_TIMER0_LOCK_END
	BTFSS       SysFlag2,B_SysFlag2_GlintEn
	GOTO        ISR_TIMER0_LOCK_END
    INCF		LockFlashBase, F
    MOVLW		50
    SUBWF		LockFlashBase, W
    BTFSS		STATUS, C
    GOTO		ISR_TIMER0_LOCK_END
    CLRF		LockFlashBase
;---
    INCF		LockFlashCnt, F
    MOVLW		GlintFlagCom
    XORWF		SysFlag2, F
    MOVLW		5
    SUBWF		LockFlashCnt, W
    BTFSS		STATUS, C
    GOTO		ISR_TIMER0_LOCK_END
    CLRF		LockFlashCnt
;---
    BSF         SysFlag2,B_SysFlag2_Glint
    BCF		    SysFlag2,B_SysFlag2_GlintEn
;---
    CLRF		T_Auto_Off
	BSF         SysFlag4,B_SysFlag4_FlashDone
;---
	BSF         SysFlag4,B_SysFlag4_DataDone
ISR_TIMER0_LOCK_END:

ISR_TIMER0_05S:
    INCF        TBASE05S,F
	MOVLW       50
	SUBWF       TBASE05S,W
	BTFSS       STATUS,C
	GOTO        ISR_TIMER0_05S_END
	CLRF        TBASE05S
	BSF         SysFlag2,B_SysFlag2_TF_05A
ISR_TIMER0_05S_END:
 
	
	
;===========================================================
	