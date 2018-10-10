;====================================================
;==== BAT_Funs.ASM
;---- LSB   = 3.6*7/12/1024    = 2.1/1024=2.05MV
;---- Input = 3.3*1/3  + X*2.05,
;---- 3.6/2V  = 1.1V + x*2.05MV, x  = 
;====================================================

F_Bat_Chk_Init:
	BCF    INTE    ,AD2IE
    BCF    AD2OH   ,7
    BSF    LEDZCON ,2
	BCF    AIENB   ,AIENB2
	BCF    PT2EN   ,2
	BCF    PT2PU   ,2
	BCF    BatFlag,B_BatFlag_Low
	BCF    BatFlag,B_BatFlag_ADC_OK
	BCF    BatFlag,B_BatFlag_CHK
	BSF    BatFlag,B_BatFlag_ICON
	CLRF   BAT_LO_CNT
    BSF    INTE    ,AD2IE
    NOP
    BSF    AD2OH   ,7
RETURN

F_Bat_Chk_Close:
	BCF     NETE  ,ENLB
    BCF     AD2OH ,7
    BCF     INTE  ,AD2IE
RETURN

F_Bat_Chk:
    BTFSC  BatFlag,B_BatFlag_Low
    GOTO   F_Bat_Chk_END
	BTFSS  BatFlag,B_BatFlag_ADC_OK
	GOTO   F_Bat_Chk_END
	MOVLW  LOW  80 ;91  ;95
	SUBWF  BAT_VAL_L,W
	MOVLW  HIGH 80 ;91  ;95
	SUBWFC BAT_VAL_H,W
	BTFSC  STATUS,C
	GOTO   F_Bat_Enough
;---
	INCF   BAT_LO_CNT,F
	MOVLW  10
	SUBWF  BAT_LO_CNT,W
	BTFSS  STATUS,C
	GOTO   F_Bat_EN
	CLRF   BAT_LO_CNT
F_Bat_IS_LOW:
	BSF    BatFlag,B_BatFlag_Low
	BCF    BatFlag,B_BatFlag_ICON
	CLRF   T_Auto_Off
	CALL   F_Clr_Timer05S
	BCF    AD2OH   ,7
	BCF    INTE    ,AD2IE
	GOTO   F_Bat_Enough_COM
;---
F_Bat_Enough:
	BCF    BatFlag,B_BatFlag_Low
F_Bat_EN:
	BCF    AD2OH   ,7
	NOP
	BSF    AD2OH   ,7
F_Bat_Enough_COM:
    BCF    BatFlag,B_BatFlag_ADC_OK
F_Bat_Chk_END:
RETURN


