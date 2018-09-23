;=================================================================
;===== FunLibs.ASM
;=================================================================
;***********************************************
;延时指令周期数：2+2+1	+	(250*8*delay_k1)
;  函数进入2条指令周期，退出1条指令周期，
;  数据准备2条指令周期
;***********************************************
cs_delay_1ms:
	movwf   	REG0
delay_1ms_lp1:
	movlw   	249
	movwf		REG1
delay_1ms_lp2:
	nop
	nop
	nop
	nop
	nop
	decfsz  	REG1,F
	goto    	delay_1ms_lp2
	decfsz  	REG0,F
	goto    	delay_1ms_lp1
return

Key_Read_State:
	MOVFF       REG0,PT1
	MOVLW       00001000B
	ANDWF       REG0,w
	MOVWF       REG1
	MOVLW       00001000B
    XORWF       REG1,F
    MOVFW       Key_CNT
    XORWF       REG1,W
    ANDWF       REG1,W
    MOVWF       Key_TRG 
    MOVFF       Key_CNT,REG1
RETURN

F_CountKgToLb:
;    MOVFL       TempRam11,002H   ; 144480
;    MOVFL       TempRam12,034H
;    MOVFL       TempRam13,060H
    CLRF        TempRam11
    MOVFL       TempRam12,HIGH 14448
    MOVFL       TempRam13,LOW  14448
    CALL        _Mul3_3
    MOVFL       TempRam11,001H
    CLRF        TempRam12        ; 65536
    CLRF        TempRam13
    CALL        _Div6_3
    CALL        _ProcAdd1
    BCF         STATUS,C
    RRF         TempRam4,F
    RRF         TempRam5,F
    RRF         TempRam6,F
    BCF         STATUS,C
    RLF         TempRam6,F
    RLF         TempRam5,F
    RLF         TempRam4,F
RETURN

F_GetZeroPoint:
    MOVFF		ZeroH,H_DR
    MOVFF		ZeroM,M_DR
    MOVFF		ZeroL,L_DR
RETURN

CurAD_ZeroAD:
    MOVFF	    TempRam1,H_DR
    MOVFF	    TempRam2,M_DR
    MOVFF	    TempRam3,L_DR
    MOVFF	    TempRam4,ZeroH
    MOVFF	    TempRam5,ZeroM
    MOVFF	    TempRam6,ZeroL
    CALL	    _Sub3_3
RETURN

F_GetAutoOnCount: 
    BCF         BSR  , IRP0
    MOVFL       FSR0 , AutoOnCH
    MOVLW       47  ; 28
    GOTO        F_GetAutoADC
	
F_GetAutoDownADC:
    BCF         BSR , IRP0
    MOVFL       FSR0, DownADH
    MOVLW       23
    GOTO        F_GetAutoADC

F_GetAutoOnADC:
    BCF         BSR,IRP0
    MOVFL       FSR0, AutoOnADH
    MOVLW       43   ; 26
	
F_GetAutoADC:
    MOVWF       TempRam13
	CLRF		TempRam12
	CLRF        TempRam11
	CLRF		TempRam4
	MOVFF		TempRam5 ,CalDot1H
	MOVFF		TempRam6 ,CalDot1L
	CALL		_Mul3_3
	CLRF		TempRam11
	MOVFL		TempRam12,HIGH 500
	MOVFL		TempRam13,LOW  500
	CALL		_Div6_3
	CALL		_ProcAdd1

	MOVFW       ZeroL
	ADDWF       TempRam6,F
	MOVFW       ZeroM
	ADDWFC      TempRam5,F
	MOVFW       ZeroH
	ADDWFC      TempRam4,F

	MOVFF       INDF0,TempRam4
	INCF        FSR0,F
	MOVFF       INDF0,TempRam5
	INCF        FSR0,F
	MOVFF       INDF0,TempRam6
RETURN

Weight_memory:
    MOVFF		TempRam3,CountH
    MOVFF		TempRam4,CountL
    MOVFF		TempRam5,Reg0
    MOVFF		TempRam6,Reg1
    CALL		_Sub2_2
    CALL		_Neg2
    CLRF		TempRam5
    MOVFF		TempRam6,Reg2
    CALL		_Sub2_2
    BTFSC		STATUS,C
    GOTO		Weight_memory_END
    MOVFF		CountH,Reg0
    MOVFF		CountL,Reg1
Weight_memory_END:
RETURN

;F_LO_CHK:
;    BTFSC       BatFlag,B_BatFlag_Low
;	GOTO        F_LO_CHK_END
;    BTFSC       LVDCON,LBOUT
;	GOTO        F_LO_UP
;F_LO_Down:      
;    INCF        BAT_LO_CNT,F
;	MOVLW       20
;	SUBWF       BAT_LO_CNT,W
;	BTFSS       STATUS,C
;	GOTO        F_LO_CHK_END
;	BSF         BatFlag,B_BatFlag_Low
;	CLRF        T_Auto_Off
;F_LO_UP:
;    CLRF        BAT_LO_CNT
;F_LO_CHK_END:
;RETURN

F_Clr_Timer05S:
    CLRF       TBASE05S
	BCF        SysFlag2,B_SysFlag2_TF_05A
	BCF        SysFlag2,B_SysFlag2_TF_05B
RETURN


F_CAL_NEXT_FLOW:
	CLRF       TimerCal
	BCF        STATUS,C
	RLF        CalFlowValue,F
RETURN


;F_2W_TrgCal:
;	BTFSS    W_TrgCal_FALG,B_W_TrgCal_FALG_EN
;	GOTO     F_2W_TrgCal_END
;	BTFSC    W_TrgCal_FALG,B_W_TrgCal_FALG_First
;	GOTO     F_2W_TrgCal_First
;	BTFSC    W_TrgCal_FALG,B_W_TrgCal_FALG_Second
;	GOTO     F_2W_TrgCal_Second
;	GOTO     F_2W_TrgCal_END
;;--- 50kg
;F_2W_TrgCal_First:
;;---
;    MOVFF	 TempRam3,CountH
;    MOVFF	 TempRam4,CountL
;;---
;	MOVLW    HIGH 500
;	MOVWF    TempRam5
;	MOVLW    LOW  500
;	MOVWF    TempRam6
;    CALL	 _Sub2_2
;    CALL	 _Neg2
;	MOVLW    00H
;    MOVWF	 TempRam5
;	MOVLW    50              ; + - 5.0kg
;    MOVWF	 TempRam6
;    CALL	 _Sub2_2
;    BTFSC	 STATUS,C
;	GOTO     F_2W_TrgCal_CLR
;    BCF      W_TrgCal_FALG,B_W_TrgCal_FALG_First
;    BSF      W_TrgCal_FALG,B_W_TrgCal_FALG_Second
;F_2W_TrgCal_FirstEnd:
;    GOTO     F_2W_TrgCal_END
;
;F_2W_TrgCal_Second: 
;    MOVFF	 TempRam3,CountH
;    MOVFF	 TempRam4,CountL
;	MOVLW    HIGH 1000
;	MOVWF    TempRam5
;	MOVLW    LOW  1000
;	MOVWF    TempRam6
;    CALL	 _Sub2_2
;    CALL	 _Neg2
;	MOVLW    00H
;    MOVWF	 TempRam5
;	MOVLW    50              ; + - 5.0kg
;    MOVWF	 TempRam6
;    CALL	 _Sub2_2
;    BTFSC	 STATUS,C
;	GOTO     F_2W_TrgCal_CLR
;    CLRF     SysFlag4 
;    CLRF     SysFlag3
;    CLRF     ScaleFlowValue
;    BSF      ScaleFlowValue,B_ScaleFlow_TrgCal
;  ;---
;    BSF      Wakeup_Flags,B_WakenOn_Cal_mode
;F_2W_TrgCal_Second_END:
;
;F_2W_TrgCal_CLR:
;    CLRF        W_TrgCal_FALG
;F_2W_TrgCal_END:
;
;RETURN
;
;F_COPY_MeasureData:
;RETURN                    
;	
;-------------------------------------------
;----  Input: REG0,REG1
F_CHECK_SENSOR_RANGE_AND_LINE:
	CLRF    TempRam4
	MOVFF   TempRam5,W_CAL_ADC_H
	MOVFF   TempRam6,W_CAL_ADC_L
	CLRF    TempRam11
	CLRF    TempRam12
	MOVFL   TempRam13,100
	CALL	_Mul3_3
	CLRF    TempRam11
    MOVFF   TempRam12,W_CAL1_ADC_H
    MOVFF   TempRam13,W_CAL1_ADC_L
	CALL	_Div6_3
	CALL	_ProcAdd1
	CLRF    TempRam1
	MOVFF   TempRam2 , REG0
	MOVFF   TempRam3 , REG1
    CALL	_Sub3_3
    CALL	_Neg3
	MOVLW   8
	SUBWF   TempRam3,W
	MOVLW   00H
	SUBWFC  TempRam2,W
	MOVLW   00H
	SUBWFC  TempRam1,W
RETURN

F_W_CAL_INIT:
    CLRF    W_CAL_Flag
    BSF     W_CAL_Flag,B_W_CAL_Flag_EN
    BSF     W_CAL_Flag,B_W_CAL_Flag_1
RETURN


F_WiFi_PowerOff_UartIoOut0:
   BCF      WIFI_PWR_PORT,WIFI_PWR_PIN  ; POWER OFF THE WIFI
   CLRF     WifiPwrCnt
   
   BCF      INTE2,URRIE
   BCF      INTE2,URTIE
   CLRF     SCON1
   
   BSF      PT1EN,UART_RXD_PIN
   BCF      PT1PU,UART_RXD_PIN
   BCF      PT1  ,UART_RXD_PIN

   BSF      PT1EN,UART_TXD_PIN
   BCF      PT1PU,UART_TXD_PIN
   BCF      PT1  ,UART_TXD_PIN
RETURN	

F_WiFi_PowerOn_UartIoFloat:
   BCF      PT1EN,UART_RXD_PIN
   BCF      PT1PU,UART_RXD_PIN
   BCF      PT1  ,UART_RXD_PIN

   BCF      PT1EN,UART_TXD_PIN
   BCF      PT1PU,UART_TXD_PIN
   BCF      PT1  ,UART_TXD_PIN
   
   BSF      WIFI_PWR_PORT,WIFI_PWR_PIN  ; POWER ON THE WIFI
   CLRF     WifiPwrCnt
RETURN	
	