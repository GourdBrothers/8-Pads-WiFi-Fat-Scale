;=================================================
;===== Scale_KeyScan.ASM
;=================================================

Scale_KeyScan_Entry:
    BTFSS    SysFlag3,B_SysFlag3_KScan
	GOTO     Scale_KeyScan_EXIT
	BCF      SysFlag3,B_SysFlag3_KScan
;---
    CALL     Key_Read_State

Scale_KeyScan_TRG:
    BTFSS    Key_TRG,B_key_Unit
	GOTO     Scale_KeyScan_TRG_END
;---
	BTFSS    ScaleFlowValue,B_ScaleFlow_CAL
	INCF     Key_CODE,F
	BTFSC    CalFlowValue,B_CalFlow_ADC 
	BSF      SysFlag3,B_SysFlag3_TRG_CAL
    BTFSS    ScaleFlowValue,B_ScaleFlow_Weight
	GOTO     Scale_KeyTRG_UNIT_END
Scale_KeyTRG_UNIT:
	BCF      STATUS,C
	RLF      UnitFlag,F
	MOVLW    Unit_MAX
	SUBWF    UnitFlag,W
	BTFSS    STATUS,C
	GOTO     Scale_KeyTRG_UNIT_END
	CLRF     UnitFlag
	BSF      UnitFlag,KgFlag
Scale_KeyTRG_UNIT_END:
    CLRF     Key_Timer
    CLRF     T_Auto_Off
    GOTO     Scale_KeyScan_EXIT
Scale_KeyScan_TRG_END:

Scale_KeyScan_LONG:
    BTFSS    Key_CNT,B_key_Unit
	GOTO     Scale_KeyScan_NOPRESS
	BTFSC    ScaleFlowValue,B_ScaleFlow_CAL
	GOTO     Scale_KeyScan_LONG_END
;--- 连续按四下时去检测是否要标定
	MOVLW    04H
	XORWF    Key_CODE,W
	BTFSC    STATUS,Z
	GOTO     Scale_KeyScan_LONG_CAL
;--- WIFI SmartCfg
Scale_KeyScan_LONG_WifiCfg:
	MOVLW    90
	SUBWF    Key_Timer,W
	BTFSS    STATUS,C
	GOTO     Scale_KeyScan_LONG_WifiCfg_END
    CLRF     Key_CODE
	CLRF     Key_Timer
    CLRF     T_Auto_Off
	CALL     F_WIFI_SmartCfg_TRG
Scale_KeyScan_LONG_WifiCfg_END:
	GOTO     Scale_KeyScan_LONG_END
;--- cal 
Scale_KeyScan_LONG_CAL:
	MOVLW    49
	SUBWF    Key_Timer,W
	BTFSS    STATUS,C
	GOTO     Scale_KeyScan_LONG_END
	CLRF     Key_Timer
;---
;	CLRF     ScaleFlowValue
;	BSF      ScaleFlowValue,B_ScaleFlow_TrgCal
;	CLRF     TimerCal
;	BCF      Wakeup_Flags,B_WakenOn_Cal_mode
;--- Scale Flow To CAL 
    CLRF     ScaleFlowValue
    BSF      ScaleFlowValue,B_ScaleFlow_CAL 
	CLRF     CalFlowValue
	BSF      CalFlowValue,B_CalFlow_ADC
    CLRF     TBASE05S
    CLRF     T_Auto_Off
	BCF      SysFlag2,B_SysFlag2_TF_05A
	BCF      SysFlag3,B_SysFlag3_DspCal
	BCF      SysFlag3,B_SysFlag3_TRG_CAL
 	BCF      Wakeup_Flags,B_WakenOn_Cal_mode
Scale_KeyScan_CLR:
    CLRF     Key_CODE
Scale_KeyScan_LONG_END:
    GOTO     Scale_KeyScan_EXIT

Scale_KeyScan_NOPRESS:
    MOVLW    10
    SUBWF    Key_Timer,W
	BTFSC    STATUS,C
	CLRF     Key_CODE

Scale_KeyScan_EXIT:






