;================================================================
;===== Scale_WEIGHT_ZERO.ASM
;===== +0.5KG~+2.5KG之间锁定后闪烁完成后，显示C一秒后回0
;===== -0.5KG~-2.5KG之间稳定后回零
;================================================================
Scale_WeightZeroEntry:

   BCF          C_Mode_Flag,B_C_Mode_Flag_NEG
   BCF		    Wakeup_Flags,OnWeightFlag

Scale_WeightZero_CHK_0_3KG:
    MOVLW       05H
	SUBWF       CountL,W
	MOVLW       00H
	SUBWFC      CountH,W
	BTFSC       STATUS,C
	GOTO        Scale_WeightZero_UP_0_3KG
;--- WEIHGT LESS 0.3KG
Scale_TRACk_ZERO:
    CLRF        COUNTH
    CLRF        COUNTL
    BTFSS       W_TrgCal_FALG,B_W_TrgCal_FALG_EN
    GOTO        Scale_TRACk_ZERO_A
    CLRF        W_TrgCal_FALG
    BSF         W_TrgCal_FALG,B_W_TrgCal_FALG_EN
    BSF         W_TrgCal_FALG,B_W_TrgCal_FALG_First
Scale_TRACk_ZERO_A:
    BCF         SysFlag1,B_SysFlag1_Neg
    BSF         SysFlag1,B_SysFlag1_ZERO
    BSF         SysFlag4,B_SysFlag4_UnLockEn
    BTFSS		SysFlag1,B_SysFlag1_Steady
    CLRF        TrackCount
    INCF        TrackCount,F
    MOVLW       03H
    SUBWF       TrackCount,W
    BTFSS       STATUS,C
    GOTO        Scale_TRACk_ZERO_END
Scale_TRACk_ZERO_DO:
    CLRF        COUNTH
    CLRF        COUNTL
	CLRF        TrackCount
    CALL		F_GetZeroPoint
    CALL		F_GetAutoOnADC
    CALL        F_GetAutoDownADC
Scale_TRACk_ZERO_END:
	GOTO        Scale_WeightZeroExit
	
;--------------------------------------------------
;--- WEIGHT UP 0.3KG
Scale_WeightZero_UP_0_3KG:
    MOVLW       30
	SUBWF       CountL,W
	MOVLW       00H
	SUBWFC      CountH,W
	BTFSC       STATUS,C
	GOTO        Scale_WeightZero_UP_3_0KG
;   
    BSF         SysFlag4,B_SysFlag4_UnLockEn
    BCF         SysFlag1,B_SysFlag1_ZERO 
;--------------------------------------------------
;--- WEIGHT DOWN 3.0KG	
Scale_WeightZero_DOWN_3_0KG:
;---
    BTFSC       SysFlag1,B_SysFlag1_Neg
    GOTO        Scale_WeightZero_DOWN_3_0KG_NEG
; +0.3kg ~ +3.0KG
Scale_WeightZero_DOWN_3_0KG_POS:
    BTFSS		SysFlag1,B_SysFlag1_Steady
    GOTO        Scale_WeightZero_DOWN_3_0KG_END
;    BTFSS       SysFlag4,B_SysFlag4_FlashDone
;    GOTO        Scale_WeightZero_DOWN_3_0KG_END
    BSF         SysFlag1,B_SysFlag1_ZERO
;   Unlock
    BCF         SysFlag4,B_SysFlag4_Lock
    BCF         SysFlag4,B_SysFlag4_FlashDone
;   C MODE IS TRG
    CLRF        C_Mode_TIME
    CLRF        C_Mode_Flag
    BSF         C_Mode_Flag,B_C_Mode_Flag_EN
    CALL        F_Clr_Timer05S
    CLRF        T_Auto_Off
    GOTO        Scale_TRACk_ZERO_DO

; -0.3kg ~ -3.0KG
Scale_WeightZero_DOWN_3_0KG_NEG:
	CALL        F_Clr_Timer05S
	CLRF        T_Auto_Off
 	BSF         C_Mode_Flag,B_C_Mode_Flag_NEG
 	BCF         SysFlag1,B_SysFlag1_Neg
 	BCF         SysFlag4,B_SysFlag4_Lock
    BSF         SysFlag4,B_SysFlag4_FlashDone
 	BTFSS		SysFlag1,B_SysFlag1_Steady
 	GOTO        Scale_WeightZero_DOWN_3_0KG_END
 	BCF         C_Mode_Flag,B_C_Mode_Flag_NEG
 	MOVFL       TrackCount,05H
    GOTO        Scale_TRACk_ZERO_A

Scale_WeightZero_DOWN_3_0KG_END:
    GOTO        Scale_WeightZeroExit

;--------------------------------------------------
;--- WEIGHT UP 3.0KG
Scale_WeightZero_UP_3_0KG:
    BCF         SysFlag1,B_SysFlag1_ZERO
	BTFSC       SysFlag1,B_SysFlag1_Neg
	GOTO        Scale_WeightZeroExit
;UP +3.0kg
Scale_WeightZero_UP_3_0KG_POS:
	BSF		    Wakeup_Flags,OnWeightFlag
	BTFSS       SysFlag4,B_SysFlag4_UnLockEn
	GOTO        Scale_WeightZero_UP_3_0KG_END
    BCF         SysFlag4,B_SysFlag4_UnLockEn
    BCF         SysFlag4,B_SysFlag4_Lock
    BCF         SysFlag4,B_SysFlag4_FlashDone
Scale_WeightZero_UP_3_0KG_END:
	
Scale_WeightZeroExit:
	
	
	