;====================================================================
;===== Protocol_RX_Handle.asm
;===== CMDA0_TEST_RTC: C5 08 A0 17 11 30 15 35 26 04 59
;===== CMDA1_TEST_KG: C5 02 A1 00 66 
;===== CMDA1_TEST_LB: C5 02 A1 01 67
;====================================================================

Protocol_RX_Entry:
    BTFSS   UartRxFlag,B_UartRxFlag_OK
    GOTO    Protocol_RX_END
    
Protocol_RX_ChkCS:
    BSF     BSR ,IRP0
	MOVFL   FSR0,UART_RX_SOP
	CLRF    REG0               ; CS
	MOVFF   REG1,UART_RX_LEN
	MOVLW   03H
	ADDWF   REG1,F
Protocol_RX_ChkCS_LOOP:	
    MOVFW   INDF0
	XORWF   REG0,F
	INCF    FSR0,F
	DECFSZ  REG1,F
	GOTO    Protocol_RX_ChkCS_LOOP
    BCF     BSR ,IRP0
;---
	MOVLW   00H
	XORWF   REG0,W
	BTFSC   STATUS,Z
	GOTO    Protocol_RX_ChkCS_OK
Protocol_RX_ChkCS_ERR:
	GOTO    Protocol_RX_Init
Protocol_RX_ChkCS_OK:
    
Protocol_RX_CHK:
	MOVLW    0C5H
	XORWF    UART_RX_SOP,W
	BTFSC    STATUS,Z
	GOTO     Protocol_RX_C5
	MOVLW    0C6H
	XORWF    UART_RX_SOP,W
	BTFSC    STATUS,Z
	GOTO     Protocol_RX_C6
	GOTO     Protocol_RX_Init
;--- WIFI DATA
Protocol_RX_C5:
    MOVLW    0A0H
    XORWF    UART_RX_CMD,W
    BTFSC    STATUS,Z
    GOTO     Protocol_RX_CmdA0_RTC
    MOVLW    0A1H
    XORWF    UART_RX_CMD,W
    BTFSC    STATUS,Z
    GOTO     Protocol_RX_CmdA1_UNIT
    MOVLW    0A2H
    XORWF    UART_RX_CMD,W
    BTFSC    STATUS,Z
    GOTO     Protocol_RX_CmdA2_UPDATE
    GOTO     Protocol_RX_C5_END
    
Protocol_RX_CmdA0_RTC:
	MOVFF    RTC_YEAR , UART_RX3
	MOVFF    RTC_MON  , UART_RX4
	MOVFF    RTC_DAY  , UART_RX5
	MOVFF    RTC_HOUR , UART_RX6
	MOVFF    RTC_MIN  , UART_RX7
	MOVFF    RTC_SEC  , UART_RX8
	MOVFF    RTC_Week , UART_RX9
	CALL     F_RTC_SET
	CLRF     T_Auto_Off
Protocol_RX_CmdA0_RTC_END:
	GOTO     Protocol_RX_C5_END

Protocol_RX_CmdA1_UNIT:
	BTFSC    UART_TX3,0
	GOTO     Protocol_RX_CmdA1_UNIT_KG
	BTFSC    UART_TX3,1
	GOTO     Protocol_RX_CmdA1_UNIT_KG
Protocol_RX_CmdA1_UNIT_other:
	GOTO     Protocol_RX_CmdA1_UNIT_END
Protocol_RX_CmdA1_UNIT_KG:
	CLRF     UnitFlag
	BSF      UnitFlag ,KgFlag
	CLRF     T_Auto_Off
	GOTO     Protocol_RX_CmdA1_UNIT_END
Protocol_RX_CmdA1_UNIT_LB:
	CLRF     UnitFlag
	BSF      UnitFlag ,LbFlag
	CLRF     T_Auto_Off
Protocol_RX_CmdA1_UNIT_END:
	GOTO     Protocol_RX_C5_END

Protocol_RX_CmdA2_UPDATE:
Protocol_RX_CmdA2_UPDATE_END:
	GOTO     Protocol_RX_C5_END
	
Protocol_RX_C5_END:
	MOVFF    UART_ACK,UART_RX_CMD
	BSF      UART_TX_EVENT,B_UART_TX_EVENT_ACK
	GOTO     Protocol_RX_Init

;--- WIFI ACK
Protocol_RX_C6:	
	MOVLW    010H
	XORWF    UART_RX_CMD,W
	BTFSC    STATUS,Z
	GOTO     Protocol_RX_C6_CMD10
	MOVLW    012H
    XORWF    UART_RX_CMD,W
	BTFSC    STATUS,Z
	GOTO     Protocol_RX_C6_CMD12
	MOVLW    0CCH
    XORWF    UART_RX_CMD,W
    GOTO     Protocol_RX_C6_CMDCC
	GOTO     Protocol_RX_C6_END
	
Protocol_RX_C6_CMD10:
	MOVFF    WifiStatus   ,UART_RX3
	MOVFF    WifiSysStatus,UART_RX4
;--
	BTFSS    WifiStatus,B_WifiStatus_PcbaTEST
	GOTO     Protocol_RX_C6_CMD10_Link
;-- cs1258 产测标志检测
Protocol_RX_C6_CMD10_CS1258_TEST:
	BTFSS    WifiSysStatus,B_WifiSysStatus_125xTesting
	GOTO     Protocol_RX_C6_CMD10_WIFI_TEST
	BTFSC    WifiSysStatus,B_WifiSysStatus_125xTestErr
	BSF      Fac_RX_RecvFlag,B_Fac_RX_RecvFlag_CS1258_OK  ; CS1258 产测OK
;-- WiFi 产测标志检测
Protocol_RX_C6_CMD10_WIFI_TEST:
	BTFSS    WifiSysStatus,B_WifiSysStatus_WifiTesting
	GOTO     Protocol_RX_C6_CMD10_Link
	BTFSC    WifiSysStatus,B_WifiSysStatus_WifiTestErr
	BSF      Fac_RX_RecvFlag,B_Fac_RX_RecvFlag_WiFi_OK    ; WiFi 产测OK
;--- wifi 连接状态检测
Protocol_RX_C6_CMD10_Link:
	BTFSS    WifiStatus,B_WifiStatus_LINK
	GOTO     Protocol_RX_C6_CMD10_END
	CALL     F_WIFI_SmartCfg_Disable
Protocol_RX_C6_CMD10_END:
	GOTO     Protocol_RX_C6_END
	
Protocol_RX_C6_CMD12:
	BSF      Wifi_SmartCfg,B_Wifi_SmartCfg_Ack
	CLRF     T_Auto_Off
Protocol_RX_C6_CMD12_END:
    GOTO     Protocol_RX_C6_END
    
Protocol_RX_C6_CMDCC:
	MOVLW    01H
	XORWF    UART_RX3,W
	BTFSC    STATUS,Z
	BSF      Fac_RX_RecvFlag,B_Fac_RX_RecvFlag_CmdCC_OK
Protocol_RX_C6_CMDCC_END:
	GOTO     Protocol_RX_C6_END
	
Protocol_RX_C6_END:
	
Protocol_RX_Init:
    CLRF     UartRxFlag
	CLRF     R_UartRxCnt
	CLRF     R_UartRXTimer

Protocol_RX_END:
	
	
	
	
	
	