;======================================
;===== Factory_Main.asm
;===== 1.Factory_Main_Init：初始化显示，并全显
;===== 2.Factory_Main_WaitSeconds：全显示1S后开WIFI电源，半秒后初始化串口,ADC
;===== 3.Factory_Main_SendCmdCC：间隔100MS发送CMDCC指令,等待WIFI响应
;        这个时候显示ADC内码，(如果WIFI响应OK，内码显示5秒钟后转到下一步)
;        (如果WIFI无响应，内码一直显示)
;===== 4.Factory_Main_PASS: 显示FPAS,表明产测正常
;======================================

Factory_Main_Entry:

Factory_Main_NeedHalt:	
	MOVLW       00H
	XORWF       FactoryFlowValue,W
	BTFSC       STATUS,Z
	GOTO        Factory_Main_Halt_END
Factory_Main_Halt:
	HALT
	NOP
Factory_Main_Halt_END:
	
Factory_Main_Timer05s:
	BCF         SysFlag2,B_SysFlag2_TF_05B
	BTFSS       SysFlag2,B_SysFlag2_TF_05A
	GOTO        Factory_Main_Timer05s_END
	BSF         SysFlag2,B_SysFlag2_TF_05B
	BCF         SysFlag2,B_SysFlag2_TF_05A
Factory_Main_Timer05s_END:
	
Factory_Main_Flow:
	BTFSC   FactoryFlowValue,B_FactoryFlowValue_INIT
	GOTO    Factory_Main_Init
	BTFSC   FactoryFlowValue,B_FactoryFlowValue_WAIT
	GOTO    Factory_Main_WaitSeconds
	BTFSC   FactoryFlowValue,B_FactoryFlowValue_ADC
	GOTO    Factory_Main_ADC
	BTFSC   FactoryFlowValue,B_FactoryFlowValue_CMDCC
	GOTO    Factory_Main_SendCmdCC
	BTFSC   FactoryFlowValue,B_FactoryFlowValue_PASS
	GOTO    Factory_Main_PASS
	CLRF    FactoryFlowValue
	
;---- init Led , timer 0 , POWER OFF THE wifi ,ADC
Factory_Main_Init:
   BCF      NETC,ADEN

   CALL     F_WiFi_PowerOn_UartIoFloat
   
   CALL     F_LED_DISP_INIT 
   CALL     ClrLEDBuffer
   CALL     LoadDspData
   
   MOVLW    10000000B    ; LDOS - 2.45V , Lo IS DISABLE
   MOVWF    NETE
   MOVLW    00100010B
   MOVWF    NETF
   BSF      NETF,LDOEN
   
   MOVLW    30
   CALL     cs_delay_1ms
   
   MOVLW    00000111B   ; ADC OUT 30.5HZ
   MOVWF    ADCON
   MOVLW    00000000B
   MOVWF    NETA
   MOVLW    11100000B
   MOVWF    TEMPC
   MOVLW    00001110B   ; PGA =
   MOVWF    NETC
   BSF      NETC,ADEN
   BSF      INTE,ADIE

   CLRF		SampleTimes
   BSF      SysFlag1,B_SysFlag1_AdcStart
   
   CALL     F_SysTimer0_OPEN
   
;--- NEXT FLOW 
   CLRF     FactoryFlowValue
   BSF      FactoryFlowValue,B_FactoryFlowValue_WAIT
   CLRF     T_Auto_Off
   CALL     F_Clr_Timer05S
Factory_Main_Init_END:
	GOTO    Factory_Main_Flow_END

;---- Power WIFI and Init UART
Factory_Main_WaitSeconds:
	BTFSS   SysFlag2,B_SysFlag2_TF_05B
	GOTO    Factory_Main_WaitSeconds_END
	INCF    T_Auto_Off,F
;--
	MOVLW   01H
	XORWF   T_Auto_Off,W
	BTFSC   STATUS,Z
	CALL    F_UART_Enable         ; init uart
;--
	MOVLW   04H
	SUBWF   T_Auto_Off,W
	BTFSS   STATUS,C
	GOTO    Factory_Main_WaitSeconds_END
;--- NEXT FLOW
	CLRF    FactoryFlowValue
	BSF     FactoryFlowValue,Factory_Main_ADC
	CLRF    T_Auto_Off
    CALL    F_Clr_Timer05S
Factory_Main_WaitSeconds_END:
	GOTO    Factory_Main_Flow_END

;---- Display adc 
Factory_Main_ADC:
	BTFSS   SysFlag2,B_SysFlag2_TF_05B
	GOTO    Factory_Main_ADC_END
	INCF    T_Auto_Off,F
	MOVLW   10
	SUBWF   T_Auto_Off,W
	BTFSS   STATUS,C
	GOTO    Factory_Main_ADC_END
;--- NEXT FLOW
	CLRF    FactoryFlowValue
	BSF     FactoryFlowValue,B_FactoryFlowValue_CMDCC
	CLRF    T_Auto_Off
    CALL    F_Clr_Timer05S
Factory_Main_ADC_END:	
	GOTO    Factory_Main_Flow_END
	
;---- SEND CMDCC to WIFI MOUDLE
Factory_Main_SendCmdCC:
	BTFSS   SysFlag2,B_SysFlag2_TF_05B
	GOTO    Factory_Main_SendCmdCC_END
	INCF    T_Auto_Off,F
Factory_Main_SendCmdCC_END:
	GOTO    Factory_Main_Flow_END

;---- RECEIVE WIFI CMD ACK , UARTLINES IS OK
Factory_Main_PASS:
Factory_Main_PASS_END:
	
Factory_Main_Flow_END:
	
;------------------------------------------------------	
Factory_Main_Disp:
	CALL     ClrLEDBuffer

	BTFSC    FactoryFlowValue,B_FactoryFlowValue_INIT
	GOTO     Factory_Main_Init
	BTFSC    FactoryFlowValue,B_FactoryFlowValue_WAIT
	GOTO     Factory_Main_WaitSeconds
	BTFSC    FactoryFlowValue,B_FactoryFlowValue_ADC
	GOTO     Factory_Main_Disp_ADC
	BTFSC    FactoryFlowValue,B_FactoryFlowValue_CMDCC
	GOTO     Factory_Main_SendCmdCC
	BTFSC    FactoryFlowValue,B_FactoryFlowValue_PASS
	GOTO     Factory_Main_Disp_PASS
	
Factory_Main_Disp_INIT:
Factory_Main_Disp_INIT_END:
	GOTO     Factory_Main_Disp_Load
	
Factory_Main_Disp_WAIT:
	CALL     SetAllLEDBuffer
Factory_Main_Disp_WAIT_END:
	GOTO     Factory_Main_Disp_Load
	
Factory_Main_Disp_ADC:
	MOVFF    TempRam11,H_DATA
    MOVFF    TempRam12,M_DATA
    MOVFF    TempRam13,L_DATA
    CALL     F_HexToBcd
	CALL     Display_NumADC
Factory_Main_Disp_ADC_END:
	GOTO     Factory_Main_Disp_Load
	
Factory_Main_Disp_CMDCC:
Factory_Main_Disp_CMDCC_END:
	GOTO     Factory_Main_Disp_Load
	
Factory_Main_Disp_PASS:
Factory_Main_Disp_PASS_END:
	GOTO     Factory_Main_Disp_Load
	
Factory_Main_Disp_Load:
	CALL     LoadDspData
	
Factory_Main_Disp_END:
	
Factory_Main_Exit:
	
	
	
	