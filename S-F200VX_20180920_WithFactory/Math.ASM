;==================================================
;===== Math.asm
;==================================================

;**************************************************
; Fun    : TempRam3/4 += TempRam5/6
; input	 : TempRam3/4/5/6
; output : TempRam3/4
;**************************************************
_Add2_2:
		MOVFW		TempRam6
		ADDWF		TempRam4, F
		MOVFW		TempRam5
		ADDWFC		TempRam3, F
RETURN

;**************************************************
; Fun    : TempRam3/4 -= TempRam5/6
; input	 : TempRam3/4/5/6
; output : TempRam3/4
;**************************************************
_Sub2_2:
		MOVFW		TempRam6
		SUBWF		TempRam4, F
		MOVFW		TempRam5
		SUBWFC		TempRam3, F
RETURN

;**************************************************
;  TempRam3,TempRam4
;**************************************************
_Neg2:
		BTFSC		STATUS, C
RETURN
		COMF        TempRam4,F
		COMF        TempRam3,F
		MOVLW       001H
		ADDWF       TempRam4,F
		MOVLW       000H
		ADDWFC      TempRam3,F
RETURN

;**************************************************
; Fun    : TempRam1/2/3 -= TempRam4/5/6
; input	 : TempRam1/2/3/4/5/6
; output : TempRam1/2/3
;**************************************************
_Sub3_3:
		MOVFW		TempRam6
		SUBWF		TempRam3, F
		MOVFW		TempRam5
		SUBWFC		TempRam2, F
		MOVFW		TempRam4
		SUBWFC		TempRam1, F
RETURN

;**************************************************
; TempRam1, TempRam2, TempRam3
;**************************************************		
_Neg3:
		  BTFSC		STATUS, C
RETURN
		  COMF		TempRam3,F
		  COMF		TempRam2,F
		  COMF		TempRam1,F
		  MOVLW     001H
		  ADDWF     TempRam3,F
		  MOVLW     000H
		  ADDWFC    TempRam2,F
		  MOVLW     000H
		  ADDWFC    TempRam1,F
RETURN	
			
;**************************************************
;Fun    : (TempRam1/2/3/4/5/6)/(TempRam11/12/13)
;          TempRam4/5/6 ...... TempRam1/2/3 
;input	:  TempRam1/2/3/4/5/6
;		   TempRam11/12/13
;output	: 
;yushu	:	TempRam1, TempRam2, TempRam3
;shang	:	TempRam4, TempRam5, TempRam6
;temp	:	buffer0,buffer1,buffer2,buffer3
;**************************************************
_Div6_3:
		MOVFL		Buffer3,24
_Div6_3Loop:	
		BCF		    STATUS,C
		RLF		    TempRam6, F
		RLF		    TempRam5, F
		RLF		    TempRam4, F
		RLF		    TempRam3, F
		RLF		    TempRam2, F
		RLF		    TempRam1, F
		
		MOVFW		TempRam13
		SUBWF		TempRam3, W
		MOVWF		Buffer2
		
		MOVFW		TempRam12
		SUBWFC		TempRam2, W
		MOVWF		Buffer1
		
		MOVFW		TempRam11
		SUBWFC		TempRam1, W
		MOVWF		Buffer0
		
		BTFSS		STATUS, C
		GOTO		_Div6_3Loop1
		
		MOVFF		TempRam1,Buffer0
		MOVFF		TempRam2,Buffer1
		MOVFF		TempRam3,Buffer2
		
		INCF		TempRam6, F
_Div6_3Loop1:
		DECFSZ		Buffer3, F
		GOTO		_Div6_3Loop
RETURN

;**************************************************
;---- 除法四舍五入
_ProcAdd1:
		BCF		    STATUS  , C
		RLF		    TempRam3, F
		RLF		    TempRam2, F
		RLF		    TempRam1, F
		
		MOVFW		TempRam13
		SUBWF		TempRam3, F
		MOVFW		TempRam12
		SUBWFC		TempRam2, F
		MOVFW		TempRam11
		SUBWFC		TempRam1, F
		BTFSS		STATUS, C
RETURN
_ProcAdd1_A:		
		MOVLW		1
		ADDWF		TempRam6, F
		MOVLW		0
		ADDWFC		TempRam5, F
		MOVLW		0
		ADDWFC		TempRam4, F
RETURN
		
;**************************************************
;Fun    :   TempRam4/5/6 * TempRam11/12/13
;input	:	TempRam4/5/6
;           TempRam11/12/13
;output	: 	TempRam1/2/3/4/5/6
;**************************************************
_Mul3_3:
		CLRF		TempRam1
		CLRF		TempRam2
		CLRF		TempRam3
		CLRF		Buffer0
		CLRF		Buffer1
		CLRF		Buffer2
		
		MOVFF		Buffer3,TempRam4
		MOVFF		Buffer4,TempRam5
		MOVFF		Buffer5,TempRam6
		
		CLRF		TempRam4
		CLRF		TempRam5
		CLRF		TempRam6
		
		MOVFL		Buffer6,24
_Mul3_2Loop:
        BCF         STATUS,C
        RRF		    TempRam11, F
		RRF		    TempRam12, F
		RRF		    TempRam13, F

		BTFSS		STATUS, C
		GOTO		_Mul3_2Loop1

		MOVFW		Buffer5
		ADDWF		TempRam6, F
		MOVFW		Buffer4
		ADDWFC		TempRam5, F
		MOVFW		Buffer3
		ADDWFC		TempRam4, F
		MOVFW		Buffer2
		ADDWFC		TempRam3, F
		MOVFW		Buffer1
		ADDWFC		TempRam2, F
		MOVFW		Buffer0
		ADDWFC		TempRam1, F
_Mul3_2Loop1:
		BCF		    STATUS , C
		RLF		    Buffer5, F      
		RLF		    Buffer4, F      
		RLF		    Buffer3, F      
		RLF		    Buffer2, F      
		RLF		    Buffer1, F     
		RLF		    Buffer0, F      
		DECFSZ		Buffer6, F
		GOTO		_Mul3_2Loop
RETURN

;-----------------------------------------------------
;------------  三字节数据转换为压缩BCD码
;------------  InPut: TempRam11/12/13
;------------  OutPut:TempRam1,2,3,4,5,6   （由高到低）         
;-----------------------------------------------------
F_HexToBcd:
		CLRF        TempRam1
		CLRF        TempRam2
		CLRF        TempRam3
		CLRF        TempRam4
		CLRF        TempRam5
		CLRF        TempRam6
		MOVFL		Buffer5,24
F_HexToBcd_Loop:
        BCF		    STATUS,C
		RLF		    TempRam13,F
		RLF		    TempRam12,F
		RLF		    TempRam11,F
		RLF		    TempRam6 ,F
		RLF		    TempRam5 ,F
		RLF		    TempRam4 ,F
		RLF		    TempRam3 ,F
		RLF		    TempRam2 ,F
		RLF		    TempRam1 ,F
		DECFSZ		Buffer5  ,F
		GOTO        F_HexToBcdAdjustDec
;----------------------------------------------------------
F_SpliteBcd:
		MOVFF		buffer0,TempRam1
		MOVFF		buffer1,TempRam2
		MOVFF		buffer2,TempRam3
		MOVFF		buffer3,TempRam4
		MOVFF		buffer4,TempRam5
		MOVFF		buffer5,TempRam6
;----------------------------------------------------------
		MOVFW       buffer5 
		ANDLW		00FH	
		MOVWF		TempRam6
		;RRF_4BIT    buffer5
		SWAPF       buffer5,F
		MOVFW       buffer5
		andlW		00FH	
		MOVWF		TempRam5
	;---
		MOVFW   	buffer4
		ANDLW		00FH	
		MOVWF		TempRam4
		;RRF_4BIT	buffer4
		SWAPF       buffer4,F
		MOVFW       buffer4
		andlW		00FH	
		MOVWF		TempRam3
	;---
		MOVFW   	buffer3
		ANDLW		00FH	
		MOVWF		TempRam2
		;RRF_4BIT	buffer3
		SWAPF       buffer3,F
		MOVFW       buffer3
		andlW		00FH	
		MOVWF		TempRam1
	;---
RETURN
F_HexToBcdAdjustDec:
        BCF         BSR,IRP0
		MOVFL		FSR0,TempRam1
		CALL		F_AdjustBcd
	;--
		MOVFL		FSR0,TempRam2
		CALL		F_AdjustBcd
	;--
		MOVFL		FSR0,TempRam3
		CALL		F_AdjustBcd
	;--
		MOVFL		FSR0,TempRam4
		CALL		F_AdjustBcd
	;--
		MOVFL		FSR0,TempRam5
		CALL		F_AdjustBcd
	;--
		MOVFL	    FSR0,TempRam6
		CALL		F_AdjustBcd
		GOTO        F_HexToBcd_Loop
;------------------------------------
F_AdjustBcd:
		MOVLW       003H
		ADDWF       INDF0,W
		BTFSC       WORK,3
		MOVWF       INDF0
		MOVLW       030H
		ADDWF       INDF0,W
		BTFSC       WORK,7
		MOVWF       INDF0
RETURN







		