;========================================================
;==== Scale_WEIHGT.ASM
;==== 重量锁定后，再加5.0KG解除锁定
;========================================================
Weight_Entry:
        BCF		    Wakeup_Flags,OnWeightFlag
Weight_3_0KG:
	    MOVLW       96             ; 4.8/0.05KG = 96
        SUBWF       COUNTL,W
		MOVLW       00H
		SUBWFC      COUNTH,W
		BTFSS       STATUS,C
		GOTO        Weight_3_0KG_END
	    MOVLW       102            ; 5.1/0.05=102
        SUBWF       COUNTL,W
		MOVLW       00H
		SUBWFC      COUNTH,W
		BTFSC       STATUS,C
		GOTO        Weight_3_0KG_END
		CLRF        COUNTH
		MOVFL       COUNTL,100     ; 5.0/0.05=100
Weight_3_0KG_END:

;Weight_ZERO:
;	    INCLUDE     Scale_WEIGHT_ZERO.ASM
;Weight_ZERO_END:
	
Weight_ZERO:
        MOVLW       100
        SUBWF       COUNTL,W
		MOVLW       00H
		SUBWFC      COUNTH,W
		BTFSC       STATUS,C 
		GOTO        Weight_ZERO_UP3KG
Weight_ZERO_Less3KG:
	    CALL        F_W_CAL_INIT
	    CLRF        COUNTH
	    CLRF        COUNTL
        BSF         SysFlag4,B_SysFlag4_UnLockEn
		BSF		    SysFlag1,B_SysFlag1_Zero
		BCF		    SysFlag1,B_SysFlag1_Neg
		BTFSS       SysFlag1,B_SysFlag1_Steady
		GOTO        Weight_ZERO_Less3KG_END
		INCF        TrackCount,F
		MOVLW       02H
		SUBWF       TrackCount,W
		BTFSS       STATUS,C
		GOTO        Weight_ZERO_Less3KG_END
		CLRF        TrackCount
        CALL		F_GetZeroPoint
        CALL        F_GetAutoOnCount
        CALL        F_GetAutoDownADC
        CALL        F_GetAutoOnADC
Weight_ZERO_Less3KG_END:
        GOTO        Weight_ZERO_END
Weight_ZERO_UP3KG:
	    CLRF        TrackCount
	    BCF         SysFlag1,B_SysFlag1_ZERO
	    BSF         Wakeup_Flags,OnWeightFlag
	    BTFSS       SysFlag4,B_SysFlag4_UnLockEn
	    GOTO        Weight_ZERO_END
        BCF         SysFlag4,B_SysFlag4_UnLockEn
        BCF         SysFlag4,B_SysFlag4_Lock
        BCF         SysFlag4,B_SysFlag4_FlashDone
Weight_ZERO_END:
	

W_NEG_COUNT_Handle:
		BCF		    SysFlag3,B_SysFlag3_DspNeg
		BTFSS		SysFlag1,B_SysFlag1_Neg
		GOTO        W_NEG_COUNT_Handle_END
		BSF		    SysFlag3,B_SysFlag3_DspNeg
		CALL        F_W_CAL_INIT
        CLRF		CountH
        CLRF		CountL
        CLRF        T_Auto_Off
		BSF		    SysFlag1,B_SysFlag1_Zero
		BCF		    SysFlag1,B_SysFlag1_Neg
		BCF		    Wakeup_Flags,OnWeightFlag
		BCF         SysFlag4,B_SysFlag4_Lock
		BCF         SysFlag4,B_SysFlag4_FlashDone
		BTFSS		SysFlag1,B_SysFlag1_Steady
		GOTO        W_NEG_COUNT_Handle_END
		CALL		F_GetZeroPoint
        CALL        F_GetAutoOnCount
        CALL        F_GetAutoDownADC
        CALL        F_GetAutoOnADC
W_NEG_COUNT_Handle_END:

MemCount:
		BTFSC       SysFlag4,B_SysFlag4_Lock 
		GOTO		MemCount_End
		BTFSC		SysFlag3,B_SysFlag3_DspNeg
		GOTO		MemCount_End
        BTFSC		SysFlag1,B_SysFlag1_Neg
		GOTO		MemCount_End
		BTFSC		SysFlag1,B_SysFlag1_Zero
		GOTO		MemCount_End
		MOVFF       REG0,LockCountH
		MOVFF       REG1,LockCountL
		MOVLW       006H
		MOVWF       REG2
		CALL        Weight_memory
MemCount_End:

JudgeOverWeight:
		BCF		    SysFlag4,B_SysFlag4_OverLoad
        MOVFW       MaxCountL
		SUBWF       CountL,W
		MOVFW       MaxCountH
		SUBWFC      CountH,W
		BTFSS		STATUS, C
		GOTO        OverWeight_End
		BSF		    SysFlag4,B_SysFlag4_OverLoad
		BCF         SysFlag4,B_SysFlag4_Lock
		BCF         SysFlag4,B_SysFlag4_FlashDone
		BTFSC		SysFlag1,B_SysFlag1_Steady
		BCF         W_CAL_Flag,B_W_CAL_Flag_LOCK
OverWeight_End:

JudgeLock_UP_10KG_UNLOCK:
        BTFSS       SysFlag4,B_SysFlag4_Lock 
        GOTO        JudgeLock_UP_10KG_UNLOCK_END
		MOVFF       REG0,LockCountH
		MOVFF       REG1,LockCountL
		MOVLW       LOW  200
		ADDWF       REG1,F
		MOVLW       HIGH 200
		ADDWFC      REG0,F
		MOVFW       REG1
		SUBWF       CountL,W
		MOVFW       REG0
		SUBWFC      CountH,W
		BTFSS       STATUS,C
		GOTO		JudgeLock_UP_10KG_UNLOCK_END
		BCF         SysFlag4,B_SysFlag4_Lock 
		BCF         SysFlag4,B_SysFlag4_FlashDone
		BCF         W_CAL_Flag,B_W_CAL_Flag_LOCK
JudgeLock_UP_10KG_UNLOCK_END:

JudgeLock:
	    BTFSC       SysFlag4,B_SysFlag4_Lock
	    GOTO        JudgeLock_End
		BTFSS		SysFlag1,B_SysFlag1_Steady
		GOTO		JudgeLock_End
		BTFSC		SysFlag1,B_SysFlag1_Neg
		GOTO		JudgeLock_End
		BTFSC		SysFlag1,B_SysFlag1_Zero
		GOTO		JudgeLock_End
		BTFSC		SysFlag4,B_SysFlag4_OverLoad
		GOTO		JudgeLock_End
		MOVFF		LockCountH,CountH
		MOVFF		LockCountL,CountL
        CLRF        LockFlashBase
        CLRF        LockFlashCnt
        CALL        F_RTC_READ
 		BSF		    SysFlag2,B_SysFlag2_GlintEn
		BCF		    SysFlag2,B_SysFlag2_Glint
        BSF		    SysFlag4,B_SysFlag4_Lock
		BCF         SysFlag4,B_SysFlag4_FlashDone
		BCF         SysFlag4,B_SysFlag4_UnLockEn
		CLRF		T_Auto_Off
        BCF         Wakeup_Flags,B_WakenOn_RST_On
        BCF         W_CAL_Flag,B_W_CAL_Flag_LOCK
JudgeLock_End:

Judge_80kgTrgCal:
	    GOTO        Judge_80kgTrgCal_END               ; Disable this cal mode
		BTFSC		SysFlag1,B_SysFlag1_Zero
		GOTO		Judge_80kgTrgCal_END
        BTFSC       SysFlag1,B_SysFlag1_Neg
		GOTO		Judge_80kgTrgCal_END
        MOVLW       0AAH
	    XORWF       Cal_MARK,W
	    BTFSC       STATUS,Z
	    GOTO        Judge_80kgTrgCal_END
		MOVLW       LOW  1600
		SUBWF       CountL,W
		MOVLW       HIGH 1600
		SUBWFC      CountH,W
		BTFSS       STATUS,C
		GOTO        Judge_80kgTrgCal_END
		CLRF        ScaleFlowValue
        BSF         ScaleFlowValue,B_ScaleFlow_TrgCal
  ;---
        BSF         Wakeup_Flags,B_WakenOn_Cal_mode
Judge_80kgTrgCal_END:


Weight_CAL_HANDLE:
		BTFSC		SysFlag1,B_SysFlag1_Neg
		GOTO		Weight_CAL_HANDLE_END
		BTFSC		SysFlag1,B_SysFlag1_Zero
		GOTO		Weight_CAL_HANDLE_END
        BTFSS		SysFlag1,B_SysFlag1_Steady
		GOTO        Weight_CAL_HANDLE_END
	;---
        BTFSS       W_CAL_Flag,B_W_CAL_Flag_EN
	    GOTO        Weight_CAL_HANDLE_END
        BTFSC       W_CAL_Flag,B_W_CAL_Flag_LOCK
		GOTO        Weight_CAL_HANDLE_END
        BSF         W_CAL_Flag,B_W_CAL_Flag_TRG
        BSF         W_CAL_Flag,B_W_CAL_Flag_LOCK
    ;---
        INCLUDE     Scale_Weight_Cal.ASM
Weight_CAL_HANDLE_END:


