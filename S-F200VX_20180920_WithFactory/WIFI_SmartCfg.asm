;========================================================================
;======= WIFI_SmartCfg.ASM
;========================================================================
F_WIFI_SmartCfg:
    BTFSS  Wifi_SmartCfg,B_Wifi_SmartCfg_EN 
    GOTO   F_WIFI_SmartCfg_END
    
F_WIFI_SmartCfg_ChkAck:
	BTFSS  SysFlag1,B_SysFlag1_DataOk
	GOTO   F_WIFI_SmartCfg_ChkAck_END
	
    BSF    UART_TX_EVENT,B_UART_TX_EVENT_unlock	
	BCF    UART_TX_EVENT,B_UART_TX_EVENT_CFG

	BTFSC  Wifi_SmartCfg,B_Wifi_SmartCfg_Ack
	GOTO   F_WIFI_SmartCfg_ChkAck_END

    BSF    UART_TX_EVENT,B_UART_TX_EVENT_CFG
    BCF    UART_TX_EVENT,B_UART_TX_EVENT_unlock
	
F_WIFI_SmartCfg_ChkAck_END:

F_WIFI_SmartCfg_FLASH:
    BTFSS  Wifi_SmartCfg,B_Wifi_SmartCfg_T
    GOTO   F_WIFI_SmartCfg_FLASH_END
    BCF    Wifi_SmartCfg,B_Wifi_SmartCfg_T
    INCF   Wifi_SmartCfgTimer,F
    MOVLW  10
    SUBWF  Wifi_SmartCfgTimer,W
    BTFSS  STATUS,C
    GOTO   F_WIFI_SmartCfg_FLASH_END
    CLRF   Wifi_SmartCfgTimer
 ;---
    MOVLW  04H
    XORWF  Wifi_SmartCfg,F
F_WIFI_SmartCfg_FLASH_END:
	
F_WIFI_SmartCfg_END:
RETURN

F_WIFI_SmartCfg_TRG:
	CLRF    Wifi_SmartCfg
	BSF     Wifi_SmartCfg,B_Wifi_SmartCfg_EN
	CLRF    Wifi_SmartCfgTimer
	BSF     UART_TX_EVENT,B_UART_TX_EVENT_CFG
	BSF     FlyLink_Flag,B_FlyLink_Flag_En
RETURN

F_WIFI_SmartCfg_Disable:
	;BTFSC   Wifi_SmartCfg,B_Wifi_SmartCfg_EN
    CLRF    Wifi_SmartCfg
    BCF     FlyLink_Flag,B_FlyLink_Flag_En
RETURN


