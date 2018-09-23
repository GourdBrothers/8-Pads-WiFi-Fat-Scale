;=====================================
;==== Scale_Main.ASM
;==== 1.Display -> OK
;==== 2.Weight  -> OK
;==== 3.WeightOnScan  -> OK
;==== 4.C Mode  -> OK
;==== 5.CAL  -> OK
;=====================================

Main_Scale_Entry:
	
Main_Scale_ChkBat:
;	GOTO     Main_Scale_ChkBat_END              ;  TEST!!!
    BTFSS    ScaleFlowValue,B_ScaleFlow_Weight
    GOTO     Main_Scale_ChkBat_END
    BTFSS    BatFlag,B_BatFlag_CHK
    GOTO     Main_Scale_ChkBat_END
    BCF      BatFlag,B_BatFlag_CHK
    CALL     F_Bat_Chk
Main_Scale_ChkBat_END:

Main_Scale_WIFI_PWR:
	BTFSS    ScaleFlowValue,B_ScaleFlow_Weight
	GOTO     Main_Scale_WIFI_PWR_END
	BTFSC    WIFI_PWR_PORT,WIFI_PWR_PIN    ;POWER IS ON
	GOTO     Main_Scale_WIFI_PWR_END
	BTFSS    SysFlag1,B_SysFlag1_DataOk
	GOTO     Main_Scale_WIFI_PWR_END
	INCF     WifiPwrCnt,F
	MOVLW    02H
	SUBWF    WifiPwrCnt,W
	BTFSS    STATUS,C
	GOTO     Main_Scale_WIFI_PWR_END
	CLRF     WifiPwrCnt
	BSF      WIFI_PWR_PORT,WIFI_PWR_PIN
	MOVLW    10
	CALL     cs_delay_1ms
    CALL     F_UART_Enable
    BTFSC    FlyLink_Flag,B_FlyLink_Flag_En
    CALL     F_WIFI_SmartCfg_TRG
Main_Scale_WIFI_PWR_END:

Main_Scale_KEY:
    INCLUDE  Scale_KeyScan.ASM
Main_Scale_KEY_END:
	
Main_Scale_AutoOFF:
    BTFSS    ScaleFlowValue,B_ScaleFlow_Weight
	GOTO     Main_Scale_AutoOFF_END
    BTFSS    SysFlag2,B_SysFlag2_TF_05B
	GOTO     Main_Scale_AutoOFF_END
    INCF     T_Auto_Off,F 
	MOVLW    30
	BTFSC    Wakeup_Flags,B_WakenOn_RST_On
	MOVLW    239
    BTFSC    SysFlag4,B_SysFlag4_Lock
	MOVLW    30
	BTFSC    SysFlag4,B_SysFlag4_OverLoad
	MOVLW    10
	BTFSC    Wifi_SmartCfg,B_Wifi_SmartCfg_EN
	MOVLW    239
	BTFSC    BatFlag,B_BatFlag_Low
	MOVLW    6
	SUBWF    T_Auto_Off,W
	BTFSS    STATUS,C
	GOTO     Main_Scale_AutoOFF_END
	CLRF     T_Auto_Off
	CLRF     ScaleFlowValue
	BSF      ScaleFlowValue,B_ScaleFlow_SLEEP
Main_Scale_AutoOFF_END:

Main_Scale_FLOW:
    BTFSC    ScaleFlowValue,B_ScaleFlow_INIT 
    GOTO     Main_Scale_Init
    BTFSC    ScaleFlowValue,B_ScaleFlow_ZERO
    GOTO     Main_Scale_ZERO
    BTFSC    ScaleFlowValue,B_ScaleFlow_Weight
    GOTO     Main_Scale_Weight
    BTFSC    ScaleFlowValue,B_ScaleFlow_CAL
    GOTO     Main_Scale_CAL
    BTFSC    ScaleFlowValue,B_ScaleFlow_TrgCal
    GOTO     Main_Scale_TrgCal
    BTFSC    ScaleFlowValue,B_ScaleFlow_SLEEP
    GOTO     Main_Scale_SLEEP
    CLRF     ScaleFlowValue
    BSF      ScaleFlowValue,B_ScaleFlow_INIT

Main_Scale_Init:
    INCLUDE  Scale_Init.ASM
    INCLUDE  Scale_Loadparam.ASM
;---
    CALL     Key_Read_State
Main_Scale_Init_TO_ZERO:
    CLRF     ScaleFlowValue
    BSF      ScaleFlowValue,B_ScaleFlow_ZERO
    BTFSS    Wakeup_Flags,WakenOn_Flag
    GOTO     Main_Scale_Init_END
Main_Scale_Init_TO_Weight:
	MOVFL    AdcTrend,06H
    CLRF     ScaleFlowValue
    BSF      ScaleFlowValue,B_ScaleFlow_Weight
Main_Scale_Init_END:
    CLRF	 WifiPwrCnt
    GOTO     Main_Scale_Exit
	
Main_Scale_ZERO:
    BTFSS    SysFlag1,B_SysFlag1_DataOk
    GOTO     Main_Scale_ZERO_END
    BTFSS    SysFlag1,B_SysFlag1_Steady
    GOTO     Main_Scale_ZERO_END
    CALL     F_GetZeroPoint
    CALL     F_GetAutoOnCount
    CALL     F_GetAutoDownADC
    CALL     F_GetAutoOnADC
    CLRF     CountH
    CLRF     CountL
Main_Scale_ZERO_TO_WEIGHT:
   	CLRF     ScaleFlowValue
    BSF      ScaleFlowValue,B_ScaleFlow_Weight
	CLRF     T_Auto_Off
	CALL     F_Clr_Timer05S
	CLRF	 WifiPwrCnt
	CALL     F_WIFI_SmartCfg_TRG
    CALL     F_W_CAL_INIT
Main_Scale_ZERO_END:
    GOTO     Main_Scale_DISP

Main_Scale_Weight:
    BTFSS    SysFlag1,B_SysFlag1_DataOk
    GOTO     Main_Scale_Weight_END
    CALL     _GetCount
    INCLUDE  Scale_WEIHGT.ASM
;---
Main_Scale_Weight_SEND:
	BTFSC    Wifi_SmartCfg,B_Wifi_SmartCfg_EN
	GOTO     Main_Scale_Weight_SEND_END
	BTFSS    WIFI_PWR_PORT,WIFI_PWR_PIN
	GOTO     Main_Scale_Weight_SEND_END
	BTFSS    SysFlag4,B_SysFlag4_Lock
	GOTO     Main_Scale_SEND_UNLOCk
Main_Scale_SEND_LOCk:
    BSF      UART_TX_EVENT,B_UART_TX_EVENT_lock
    GOTO     Main_Scale_Weight_SEND_END
Main_Scale_SEND_UNLOCk:
	BSF      UART_TX_EVENT,B_UART_TX_EVENT_unlock
Main_Scale_Weight_SEND_END:
	
Main_Scale_Weight_FlashDone:
	BTFSS    SysFlag4,B_SysFlag4_Lock
	GOTO     Main_Scale_Weight_FlashDone_END
	BTFSS    SysFlag4,B_SysFlag4_FlashDone
	GOTO     Main_Scale_Weight_FlashDone_END
	MOVLW    02H
	SUBWF    T_Auto_Off,W
	BTFSS    STATUS,C
	GOTO     Main_Scale_Weight_FlashDone_END
	BCF      SysFlag4,B_SysFlag4_FlashDone
	BTFSS    Wakeup_Flags,OnWeightFlag
	GOTO     Main_Scale_Weight_FlashDone_END
;--- FLOW TO GetRes
	CLRF     MainFlowValue
	BSF      MainFlowValue,B_MainFlow_GetRes
	CLRF     T_Auto_Off
	CALL     F_Clr_Timer05S
	CLRF     ResFlowValue
	CLRF     DispRollFlow
	BSF      DispRollFlow,B_DispRollFlow_0
Main_Scale_Weight_FlashDone_END:

Main_Scale_Weight_END:

Main_Scale_UNST:
	BTFSC    SysFlag4,B_SysFlag4_Lock
	GOTO     Main_Scale_UNST_CLR
	BTFSC    BatFlag,B_BatFlag_Low
	GOTO     Main_Scale_UNST_CLR
	BTFSC    SysFlag1,B_SysFlag1_Zero
	GOTO     Main_Scale_UNST_CLR
	BTFSC    SysFlag3,B_SysFlag3_DspNeg
	GOTO     Main_Scale_UNST_CLR
	BTFSC    SysFlag4,B_SysFlag4_OverLoad
	GOTO     Main_Scale_UNST_CLR
	BTFSC    SysFlag1,B_SysFlag1_Steady
	GOTO     Main_Scale_UNST_CLR
	CLRF     T_Auto_Off
	BTFSC    SysFlag2,B_SysFlag2_TF_05B
	INCF     NoSteadyCount,F
	MOVLW    60
	SUBWF    NoSteadyCount,W
	BTFSS    STATUS,C
	GOTO     Main_Scale_UNST_END
    CLRF     ScaleFlowValue
    BSF      ScaleFlowValue,B_ScaleFlow_SLEEP
Main_Scale_UNST_CLR:
    CLRF     NoSteadyCount
Main_Scale_UNST_END:
    GOTO     Main_Scale_DISP

Main_Scale_CAL:
	INCLUDE  Scale_CAL.ASM
Main_Scale_CAL_END:
	GOTO     Main_Scale_DISP

Main_Scale_TrgCal:
    INCLUDE  SCALE_CAL_TRG_FLOW.ASM
Main_Scale_TrgCal_END:
    GOTO     Main_Scale_DISP

Main_Scale_SLEEP:
	INCLUDE  Scale_Sleep.ASM
Main_Scale_SLEEP_END:
    GOTO     Main_Scale_Exit

Main_Scale_DISP:
    INCLUDE  Scale_DISPLAY.ASM
Main_Scale_DISP_END:

Main_Scale_Exit:
   
   