;=============================================================
;==== LED_DISP_LIB.ASM
;=============================================================

;===========================================
		
Led_Num:
    ADDPCW
    RETLW    Ledch0			; 0  (work=0)
    RETLW    Ledch1			; 1  (work=1)
    RETLW    Ledch2			; 2  (work=2)
    RETLW    Ledch3			; 3  (work=3)
    RETLW    Ledch4			; 4  (work=4)
    RETLW    Ledch5			; 5  (work=5)
    RETLW    Ledch6			; 6  (work=6)
    RETLW    Ledch7			; 7  (work=7)
    RETLW    Ledch8			; 8  (work=8)
    RETLW    Ledch9			; 9  (work=9)
    RETLW    LedchNo			; No (work=10)

F_LED_DISP_INIT:
    BCF         INTE    ,TM1IE
	CLRF        TM1CON
    MOVFL       LEDCON1 ,11101001B    ; 10MA , 3.8V pump ENABLE
	CLRF        LEDCON2 
	MOVFL       CHPCON  ,00010101B
	MOVFL       LEDTEST1,026H
	BSF         LEDZCON ,2
	MOVFL       PT2EN   ,11111011B
	CLRF        PT2PU
	CLRF        PT2
    MOVFL       TM1IN   ,250          ; 125000 /250 = 500
	MOVFL       TM1CON  ,11000000B    ; 2m    / 16 = 125000
	BSF         INTE    ,TM1IE
RETURN

F_LED_DISP_Disable:
    BCF         INTE  ,TM1IE
	CLRF        TM1CON
    CLRF        LEDCON1
	CLRF        CHPCON
	CLRF        LEDTEST1
	MOVFL       PT2EN,11111011B
	CLRF        PT2PU
	CLRF        PT2
RETURN

ClrLEDBuffer:
    MOVLW		00H
    GOTO		DisplayCom
SetAllLEDBuffer:
    MOVLW		0FFH
DisplayCom:
    MOVWF       Display1
    MOVWF       Display2
    MOVWF       Display3
    MOVWF       Display4
    MOVWF       Display_FALG1
RETURN

LoadDspData:
	CLRF        R_LED_1
	CLRF        R_LED_2
	CLRF        R_LED_3
	CLRF        R_LED_4
	CLRF        R_LED_5
	CLRF        R_LED_6
	CLRF        R_LED_7
LoadDspData_1:
    BTFSC       Display1,B_Display1_F
	BSF         Num1_F
    BTFSC       Display1,B_Display1_G
	BSF         Num1_G
    BTFSC       Display1,B_Display1_E
	BSF         Num1_E
    BTFSC       Display1,B_Display1_D
	BSF         Num1_D
    BTFSC       Display1,B_Display1_A
	BSF         Num1_A
    BTFSC       Display1,B_Display1_B
	BSF         Num1_B
    BTFSC       Display1,B_Display1_C
	BSF         Num1_C
LoadDspData_2:
    BTFSC       Display2,B_Display2_F
	BSF         Num2_F
    BTFSC       Display2,B_Display2_G
	BSF         Num2_G
    BTFSC       Display2,B_Display2_E
	BSF         Num2_E
    BTFSC       Display2,B_Display2_D
	BSF         Num2_D
    BTFSC       Display2,B_Display2_A
	BSF         Num2_A
    BTFSC       Display2,B_Display2_B
	BSF         Num2_B
    BTFSC       Display2,B_Display2_C
	BSF         Num2_C
LoadDspData_3:
    BTFSC       Display3,B_Display3_F
	BSF         Num3_F
    BTFSC       Display3,B_Display3_G
	BSF         Num3_G
    BTFSC       Display3,B_Display3_E
	BSF         Num3_E
    BTFSC       Display3,B_Display3_D
	BSF         Num3_D
    BTFSC       Display3,B_Display3_A
	BSF         Num3_A
    BTFSC       Display3,B_Display3_B
	BSF         Num3_B
    BTFSC       Display3,B_Display3_C
	BSF         Num3_C
LoadDspData_4:
    BTFSC       Display4,B_Display4_F
	BSF         Num4_F
    BTFSC       Display4,B_Display4_G
	BSF         Num4_G
    BTFSC       Display4,B_Display4_E
	BSF         Num4_E
    BTFSC       Display4,B_Display4_D
	BSF         Num4_D
    BTFSC       Display4,B_Display4_A
	BSF         Num4_A
    BTFSC       Display4,B_Display4_B
	BSF         Num4_B
    BTFSC       Display4,B_Display4_C
	BSF         Num4_C
LoadDspData_Flag:
    BTFSC       Display_FALG1,B_Display_FALG1_BAT
	BSF         FLAG1_BAT
    BTFSC       Display_FALG1,B_Display_FALG1_BLE
	BSF         FLAG1_BLE
    BTFSC       Display_FALG1,B_Display_FALG1_SJ
	BSF         FLAG1_SJ
    BTFSC       Display_FALG1,B_Display_FALG1_KG
	BSF         FLAG1_KG
    BTFSC       Display3,B_Display3_P1
    BSF         FLAG1_P1
    BTFSC       Display2,B_Display2_P2
	BSF         FLAG1_P2
    BTFSC       Display_FALG1,B_Display_FALG1_P3
	BSF         FLAG1_P3

LoadDspData_TO_LED_REG:
    MOVFF       LED1,R_LED_1
    MOVFF       LED2,R_LED_2
    MOVFF       LED3,R_LED_3
    MOVFF       LED4,R_LED_4
    MOVFF       LED5,R_LED_5
    MOVFF       LED6,R_LED_6
    MOVFF       LED7,R_LED_7
RETURN


Display_NumADC:
	MOVLW		00H
    XORWF		TempRam2, W
    BTFSS		STATUS, Z
    GOTO		Display_NumADC_END
    MOVFL		TempRam2,Disp_No

    MOVLW		00H
    XORWF		TempRam3, W
    BTFSS		STATUS, Z
    GOTO		Display_NumADC_END
    MOVFL		TempRam3,Disp_No
	
    MOVLW		00H
    XORWF		TempRam4, W
    BTFSS		STATUS, Z
    GOTO		Display_NumADC_END
    MOVFL		TempRam4,Disp_No

    MOVLW		00H
    XORWF		TempRam5, W
    BTFSS		STATUS, Z
    GOTO		Display_NumADC_END
    MOVFL		TempRam5,Disp_No
    
Display_NumADC_END:    
	GOTO        Display_Num1

	
Display_Num:

    MOVLW		00H
    XORWF		TempRam2, W
    BTFSS		STATUS, Z
    GOTO		Display_Num1
    MOVFL		TempRam2,Disp_No

    MOVLW		00H
    XORWF		TempRam3, W
    BTFSS		STATUS, Z
    GOTO		Display_Num1
    MOVFL		TempRam3,Disp_No
    
	BTFSS       ScaleFlowValue,B_ScaleFlow_CAL
	GOTO        Display_Num1
	
    MOVLW		00H
    XORWF		TempRam4, W
    BTFSS		STATUS, Z
    GOTO		Display_Num1
    MOVFL		TempRam4,Disp_No

    MOVLW		00H
    XORWF		TempRam5, W
    BTFSS		STATUS, Z
    GOTO		Display_Num1
    MOVFL		TempRam5,Disp_No

Display_Num1:

    MOVFW		TempRam3
    CALL		Led_Num
    IORWF		Display1,F

    MOVFW		TempRam4
    CALL		Led_Num
    IORWF		Display2,F

    MOVFW		TempRam5
    CALL		Led_Num
    IORWF		Display3,F

    MOVFW		TempRam6
    CALL		Led_Num
    IORWF		Display4,F

RETURN


Scale_Disp_CLR:
    MOVFW	TempRam2
    CALL	Led_Num
    IORWF	Display1,F  ; 
    MOVFW	TempRam3
    CALL	Led_Num
    IORWF	Display2,F  ;
    MOVFW	TempRam4
    CALL	Led_Num
    IORWF	Display3,F  ;
    MOVFW	TempRam5
    CALL	Led_Num
    IORWF	Display4,F  ;
;---
    MOVLW   00H
    XORWF   TempRam2,W
    BTFSS   STATUS,Z
    GOTO    Scale_Disp_CLR_END
    CLRF    Display1
    MOVLW   00H
    XORWF   TempRam3,W
    BTFSC   STATUS,Z
    CLRF    Display2
Scale_Disp_CLR_END:
RETURN






