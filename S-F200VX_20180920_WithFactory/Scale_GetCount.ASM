;========================================================
;==== Scale_GetCount.ASM
;========================================================
_GetCount:
		CALL		CurAD_ZeroAD
    ;---
		BCF		    SysFlag1,B_SysFlag1_Neg
		BTFSS		STATUS, C
		BSF		    SysFlag1,B_SysFlag1_Neg
		CALL		_Neg3
    ;---
		MOVFF       W_CAL_ADC_H,TempRam2
		MOVFF       W_CAL_ADC_L,TempRam3
    ;---
		MOVFF		TempRam1,TempRam2
		MOVFF		TempRam2,TempRam3
		
		movff		TempRam3,TempRam1
		movff		TempRam4,TempRam2
		
		MOVFF		TempRam5,CalDot1H
		MOVFF		TempRam6,CalDot1L
		CALL		_Sub2_2
		BTFSS		STATUS,C
		GOTO		GetCount1  

		MOVFF		TempRam3,TempRam1
		MOVFF		TempRam4,TempRam2
		MOVFF		TempRam5,CalDot2H
		MOVFF		TempRam6,CalDot2L
		CALL		_Sub2_2
		BTFSS		STATUS,C
		GOTO		GetCount2
;---
		MOVFL		Reg1,HIGH 2000
		MOVFL		Reg2,LOW  2000
		
		MOVFW		CalDot2L
		SUBWF		CalDot3L, W
		MOVWF		CalConstL
		
		MOVFW		CalDot2H
		SUBWFC		CalDot3H, W
		MOVWF		CalConstH
		
		MOVFW		CalDot2L
		SUBWF		TempRam2, W
		MOVWF		TempRam6
		
		MOVFW		CalDot2H
		SUBWFC		TempRam1, W
		MOVWF		TempRam5
		
		MOVFL       CalCountH,HIGH 1000
		MOVFL       CalCountL,LOW  1000
		GOTO		GetCount3

GetCount1:
		CLRF		Reg1
		CLRF		Reg2
		MOVFF		CalConstH,CalDot1H
		MOVFF		CalConstL,CalDot1L
		MOVFF		TempRam5 ,TempRam1
		MOVFF		TempRam6 ,TempRam2
		MOVFL       CalCountH,HIGH 1000
		MOVFL       CalCountL,LOW  1000
		GOTO		GetCount3

GetCount2:
		
		MOVFL		Reg1,HIGH 1000
		MOVFL		Reg2,LOW  1000

		MOVFW		CalDot1L
		SUBWF		CalDot2L, w
		MOVWF		CalConstL

		MOVFW		CalDot1H
		SUBWFC		CalDot2H, w
		MOVWF		CalConstH

		MOVFW		CalDot1L
		SUBWF		TempRam2, w
		MOVWF		TempRam6

		MOVFW		CalDot1H
		SUBWFC		TempRam1, w
		MOVWF		TempRam5
		
		MOVFL       CalCountH,HIGH 1000
		MOVFL       CalCountL,LOW  1000

GetCount3:
		CLRF		TempRam4
		CLRF		TempRam11
		MOVFF		TempRam12,CalCountH
		MOVFF		TempRam13,CalCountL
		CALL		_Mul3_3
		
		CLRF		TempRam11
		MOVFF		TempRam12,CalConstH
		MOVFF		TempRam13,CalConstL
		CALL		_Div6_3
		CALL		_ProcAdd1
		
		MOVFF		TempRam3,Reg1
		MOVFF		TempRam4,Reg2

		CALL		_Add2_2

		MOVFF		CountH,TempRam3
		MOVFF		CountL,TempRam4

GetCount_End:

RETURN
