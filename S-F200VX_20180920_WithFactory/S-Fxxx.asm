;===============================================
;==== S-F200 LED,XY6035_8电极WIFI脂肪秤
;==== WIFI 模块测量阻抗,秤只发送体重与时间
;==== CHIP : CSU18MB86-24PIN
;==== CS   : 
;==== LINE : 3252
;==== ModyfyDate: 2018-09-19
; 1. SCALE->OK 20180118
; 2. WIFI ->OK 20180129
; 3. 更新WIFI固件 -> 20180521
; 4. 更换LED显示框 -> 20180705 (wifi-lb-kg-bat)
; 5. 增加重量标定 -> 20180719
; 6. 重量开机5KG，最小显示5.0KG -> 20180801
; 7. 更换LED显示框3002 -> 20180919(未完成)
;===============================================
    INCLUDE   CSU18MB86.INC
    INCLUDE   CSU18MXX_MACRO.INC
    INCLUDE   RAM_DEFINE.INC
    INCLUDE   ConstDefine.INC
    INCLUDE   LED_Define.INC
    INCLUDE   CSM37F58_Define.INC
;============================================
; program start
;============================================
	ORG       000H
	NOP
	GOTO      SysReset
	ORG       004H
	GOTO      ISR_Entry
;============================================
SysReset:
	CLRF      MainFlowValue
	BSF       MainFlowValue,B_MainFlow_PowerOn

;============================================
MainLoop:
	CLRWDT
	NOP

Main_Timer:
    BCF       SysFlag2,B_SysFlag2_TF_05B
    BTFSS     SysFlag2,B_SysFlag2_TF_05A
	GOTO      Main_Timer_END
	BCF       SysFlag2,B_SysFlag2_TF_05A
	BSF       SysFlag2,B_SysFlag2_TF_05B
Main_Timer_END:
	
Main_FLOW:
	BTFSC     MainFlowValue,B_MainFlow_PowerOn
	GOTO      Main_FLOW_PowerOn
	BTFSC     MainFlowValue,B_MainFlow_Scale
	GOTO      Main_FLOW_Scale
	BTFSC     MainFlowValue,B_MainFlow_GetRes
	GOTO      Main_FLOW_GetRes
	BTFSC     MainFlowValue,B_MainFlow_Factory
	GOTO      Main_FLOW_Factory
	CLRF	  MainFlowValue
	
Main_FLOW_PowerOn:
	INCLUDE   PowerOn.ASM
	CLRF      MainFlowValue
    BSF       MainFlowValue,B_MainFlow_Factory
    CLRF      FactoryFlowValue
;	CLRF      MainFlowValue
;	BSF       MainFlowValue,B_MainFlow_Scale
Main_FLOW_PowerOn_End:
    GOTO      Main_FLOW_END

Main_FLOW_Scale:
	INCLUDE   Scale_Main.ASM
	GOTO      MAIN_ADC_PRO
	
Main_FLOW_GetRes:
	INCLUDE   Main_GetRes.ASM
	GOTO      MAIN_ADC_PRO

MAIN_ADC_PRO:
    BCF		  SysFlag1,B_SysFlag1_DataOk
    BTFSS     SysFlag1,B_SysFlag1_AdcOk
    GOTO	  MAIN_ADC_PRO_END
	INCLUDE   Scale_ADC_PRO.ASM
    BCF		  SysFlag1,B_SysFlag1_AdcOk
    BSF		  SysFlag1,B_SysFlag1_DataOk
MAIN_ADC_PRO_END:
	GOTO      MAIN_Flow_END
	
Main_FLOW_Factory:
	INCLUDE   Factory_Main.ASM
Main_FLOW_Factory_END:
	GOTO      MAIN_Flow_END
    
Main_FLOW_END:
    
Main_UART_RX:
	INCLUDE   Protocol_RX_Handle.asm
Main_UART_RX_END:
	
Main_UART_TX:
	INCLUDE   Protocol_TX_Handle.asm
Main_UART_TX_END:

Main_WifiCfg:	
	CALL      F_WIFI_SmartCfg
Main_WifiCfg_END:
	
	GOTO      MainLoop
	
;============================================
	INCLUDE   ISR_Handle.ASM
    INCLUDE   Math.ASM
	INCLUDE   FunLibs.ASM
	INCLUDE   LED_DISP_LIB.ASM
	INCLUDE   Scale_GetCount.ASM
    INCLUDE   Scale_Disp_Weight.ASM
    INCLUDE   RTC_FUN.ASM
    INCLUDE   BIE_18MXX_LIBS.ASM
    INCLUDE   Timer_Funs.ASM
    INCLUDE   BAT_Funs.ASM
    INCLUDE   UART_LIB.ASM
    INCLUDE   Protocol_LIB_V10.ASM
    INCLUDE   WIFI_SmartCfg.ASM
    ;INCLUDE   IIC_Funs.ASM
    ;INCLUDE   CSM37F58_lib.ASM
;============================================
	END
;============================================
