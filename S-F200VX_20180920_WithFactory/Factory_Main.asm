;==============================================================================
;===== Factory_Main.asm
;=====  CMD10: C5 1E 10 00 00 00 00 18 01 08 12 00 02 05 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 CF
;=====  CMDCC: C5 01 CC 08
;===== 1.Factory_Main_Init：初始化相关设备
;===== 2.Factory_Main_WaitSeconds：全显示(用于查看LED灯是否正常),半秒后初始化串口,持续2S
;===== 3.Factory_Main_ADC: 显示 ADC 3秒钟,按压传感器来判断是否正常
;===== 4.Factory_Main_SendCmdCC：间隔500MS发送CMDCC指令,等待WIFI响应
;        这个时候LED从10开始以半秒速度倒数,如果CS1258，WIFIOK，RTC OK,进入低电压检测阶段;
;        如果计时到0时，则会报对应的出错信息
;===== 5.B_FactoryFlowValue_ChkLo: 低电压检测，测试人员按下低电压模拟开关
;===== 6.Factory_Main_PASS: 显示FPAS,表明产测正常
;===== 7.B_FactoryFlowValue_ERR: 显示Er-x,表明产测异常
;==============================================================================

Factory_Main_Entry:
    CLRWDT
    
Factory_Main_NeedHalt:	
	MOVLW       00H
	XORWF       FactoryFlowValue,W
	BTFSC       STATUS,Z
	GOTO        Factory_Main_Halt_END
Factory_Main_Halt:
	HALT
	NOP
Factory_Main_Halt_END:
	
Factory_Main_CheckRTC:
	BTFSC   Fac_ErrCode,B_Fac_ErrCode_RTC
	GOTO    Factory_Main_CheckRTC_END
	BTFSC   FactoryFlowValue,B_FactoryFlowValue_ChkLo
	GOTO    Factory_Main_CheckRTC_END	
	BTFSS   SysFlag2,B_SysFlag2_TF_05B
	GOTO    Factory_Main_CheckRTC_END
	INCF    Fac_RcRef_Cnt,F
	MOVLW   10
	SUBWF   Fac_RcRef_Cnt,W
	BTFSS   STATUS,Z
	GOTO    Factory_Main_CheckRTC_END
;--- 内部RC计时与RTC计时相差在1S以内为正常
	CLRF    TempRam3
	MOVFF   TempRam4,Fac_RtcChk_Cnt
	CLRF    TempRam5
	MOVFF   TempRam6,Fac_RcRef_Cnt
	CALL    _Sub2_2
	CALL    _Neg2
    MOVLW   02H
    SUBWF   TempRam4,W
    MOVLW   00H
    SUBWFC  TempRam3,W
    BTFSS   STATUS,C
    GOTO    Factory_Main_CheckRTC_END
    BSF     Fac_ErrCode,B_Fac_ErrCode_RTC
    CLRF    FactoryFlowValue
    BSF     FactoryFlowValue,B_FactoryFlowValue_ERR
Factory_Main_CheckRTC_END:

Factory_Main_Flow:
	BTFSC   FactoryFlowValue,B_FactoryFlowValue_INIT
	GOTO    Factory_Main_Init
	BTFSC   FactoryFlowValue,B_FactoryFlowValue_WAIT
	GOTO    Factory_Main_WaitSeconds
	BTFSC   FactoryFlowValue,B_FactoryFlowValue_ADC
	GOTO    Factory_Main_ADC
	BTFSC   FactoryFlowValue,B_FactoryFlowValue_CMDCC
	GOTO    Factory_Main_SendCmdCC
	BTFSC   FactoryFlowValue,B_FactoryFlowValue_ChkLo
	GOTO    Factory_Main_ChkLo
	BTFSC   FactoryFlowValue,B_FactoryFlowValue_PASS
	GOTO    Factory_Main_PASS
	BTFSC   FactoryFlowValue,B_FactoryFlowValue_ERR
	GOTO    Factory_Main_ERR
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
   
   CALL     F_Bat_Chk_Init
   
;--- NEXT FLOW 
   CLRF     FactoryFlowValue
   BSF      FactoryFlowValue,B_FactoryFlowValue_WAIT
   CLRF     Fac_TimeOff
   CALL     F_Clr_Timer05S
;--- clrf err ram
   CLRF     Fac_RtcChk_Cnt
   CLRF     Fac_RcRef_Cnt
   CLRF     Fac_ErrCode
Factory_Main_Init_END:
	GOTO    Factory_Main_Flow_END

;---- Power WIFI and Init UART
Factory_Main_WaitSeconds:
	BTFSS   SysFlag2,B_SysFlag2_TF_05B
	GOTO    Factory_Main_WaitSeconds_END
	INCF    Fac_TimeOff,F
	MOVLW   01H
	XORWF   Fac_TimeOff,W
	BTFSC   STATUS,Z
	CALL    F_UART_Enable         ; init uart
	MOVLW   04H
	SUBWF   Fac_TimeOff,W
	BTFSS   STATUS,C
	GOTO    Factory_Main_WaitSeconds_END
;--- NEXT FLOW
	CLRF    FactoryFlowValue
	BSF     FactoryFlowValue,B_FactoryFlowValue_ADC
	CLRF    Fac_TimeOff
    CALL    F_Clr_Timer05S
;--- init uart rx buf
    CALL    F_UART_InitRX
    CLRF    Fac_RX_RecvFlag
Factory_Main_WaitSeconds_END:
	GOTO    Factory_Main_Flow_END

;---- Display adc , 3 Seconds
Factory_Main_ADC:
	BTFSS	SysFlag1,B_SysFlag1_AdcOk
	GOTO    Factory_Main_ADC_Time
	BCF		SysFlag1,B_SysFlag1_AdcOk
Factory_Main_ADC_Time:	
	BTFSS   SysFlag2,B_SysFlag2_TF_05B
	GOTO    Factory_Main_ADC_END
	INCF    Fac_TimeOff,F
	MOVLW   6
	SUBWF   Fac_TimeOff,W
	BTFSS   STATUS,C
	GOTO    Factory_Main_ADC_END
;--- NEXT FLOW
	CLRF    FactoryFlowValue
	BSF     FactoryFlowValue,B_FactoryFlowValue_CMDCC
    CALL    F_Clr_Timer05S
    MOVLW   20
    MOVWF   Fac_TimeOff
Factory_Main_ADC_END:
	GOTO    Factory_Main_Flow_END
	
;---- SEND CMDCC to WIFI MOUDLE
Factory_Main_SendCmdCC:
	BTFSS   SysFlag2,B_SysFlag2_TF_05B
	GOTO    Factory_Main_SendCmdCC_END
;--- SEND CMDCC,TRG FACTORY TEST
Factory_Main_SendCmdCC_0:
	BTFSC   Fac_RX_RecvFlag,B_Fac_RX_RecvFlag_CmdCC_OK
	GOTO    Factory_Main_SendCmdCC_1
	BSF     UART_TX_EVENT,B_UART_TX_EVENT_WifiTest
	GOTO    Factory_Main_SendCmdCC_Timeout
;--- SEND CMD10,GET STATE
Factory_Main_SendCmdCC_1:
	BSF     UART_TX_EVENT,B_UART_TX_EVENT_unlock          ; CMD10
	BTFSS   Fac_RX_RecvFlag,B_Fac_RX_RecvFlag_WiFi_OK
	GOTO    Factory_Main_SendCmdCC_Timeout
	BTFSS   Fac_RX_RecvFlag,B_Fac_RX_RecvFlag_CS1258_OK
	GOTO    Factory_Main_SendCmdCC_Timeout
;--- WIFI 模块通过
	BCF     UART_TX_EVENT,B_UART_TX_EVENT_unlock
	CLRF    FactoryFlowValue
	BSF     FactoryFlowValue,B_FactoryFlowValue_ChkLo
	GOTO    Factory_Main_SendCmdCC_END
;--- CHECK TIMEOUT
Factory_Main_SendCmdCC_Timeout:
	DECF    Fac_TimeOff,F
	MOVLW   0FFH
	XORWF   Fac_TimeOff,W
	BTFSS   STATUS,Z
	GOTO    Factory_Main_SendCmdCC_END
;--- NEXT FLOW
	CLRF    FactoryFlowValue
	BSF     FactoryFlowValue,B_FactoryFlowValue_ERR
;--- ERRCODE
	BTFSS   Fac_RX_RecvFlag,B_Fac_RX_RecvFlag_CmdCC_OK
	BSF     Fac_ErrCode,B_Fac_ErrCode_UART
	BTFSS   Fac_RX_RecvFlag,B_Fac_RX_RecvFlag_CS1258_OK
	BSF     Fac_ErrCode,B_Fac_ErrCode_RES
	BTFSS   Fac_RX_RecvFlag,B_Fac_RX_RecvFlag_WiFi_OK
	BSF     Fac_ErrCode,B_Fac_ErrCode_WIFI
;---
	CALL    F_Clr_Timer05S
    CLRF    Fac_TimeOff
Factory_Main_SendCmdCC_END:
	GOTO    Factory_Main_Flow_END

;---- check Low battery circuit 
Factory_Main_ChkLo:
    BTFSS    BatFlag,B_BatFlag_CHK
    GOTO     Factory_Main_ChkLo_END
    BCF      BatFlag,B_BatFlag_CHK
    CALL     F_Bat_Chk
    BTFSS    BatFlag,B_BatFlag_Low
    GOTO     Factory_Main_ChkLo_END
;-- NEXT FLOW
    CLRF     FactoryFlowValue
	BSF      FactoryFlowValue,B_FactoryFlowValue_PASS
;-- Write Factory MARK
	CALL     F_Factory_WR_Mark
Factory_Main_ChkLo_END:
	GOTO    Factory_Main_Flow_END
	
;---- WIFI AND CS1258 ARE OK
Factory_Main_PASS:
Factory_Main_PASS_END:
	GOTO    Factory_Main_Flow_END
	
;---- WIFI AND CS1258 HAS SOMETHING WRONG
Factory_Main_ERR:
	CLRF     Fac_ErrNum
	BTFSS    Fac_ErrCode,B_Fac_ErrCode_RTC
	GOTO     Factory_Main_ERR_UART
	MOVLW    01H
	GOTO     Factory_Main_ERR_COMM
Factory_Main_ERR_UART:
	BTFSS    Fac_ErrCode,B_Fac_ErrCode_UART
	GOTO     Factory_Main_ERR_RES
	MOVLW    02H
	GOTO     Factory_Main_ERR_COMM
Factory_Main_ERR_RES:
	BTFSS    Fac_ErrCode,B_Fac_ErrCode_RES
	GOTO     Factory_Main_ERR_WIFI
	MOVLW    03H
	GOTO     Factory_Main_ERR_COMM
Factory_Main_ERR_WIFI:
	BTFSS    Fac_ErrCode,B_Fac_ErrCode_WIFI
	GOTO     Factory_Main_ERR_END
	MOVLW    04H
Factory_Main_ERR_COMM:
	MOVWF    Fac_ErrNum
Factory_Main_ERR_END:
	
Factory_Main_Flow_END:
	
;------------------------------------------------------	
Factory_Main_Disp:
	INCLUDE  Factory_Display.ASM
Factory_Main_Disp_END:
	
Factory_Main_Exit:
	
	
	
	