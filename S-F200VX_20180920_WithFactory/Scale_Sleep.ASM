;=======================================================
;==== Scale_Sleep.ASM
;=======================================================
Scale_Sleep_Entry:
	
    CALL    ClrLEDBuffer
    CALL    LoadDspData

    CALL    F_LED_DISP_Disable
	CALL    F_UART_Disable
	CALL    F_SysTimer0_CLOSE
	CALL    F_Bat_Chk_Close
	CLRF    T_Auto_Off

Scale_Sleep_CfgIo:
;	BCF     WIFI_PWR_PORT,WIFI_PWR_PIN
;
;	BSF     PT1EN,UART_RXD_PIN
;	BCF     PT1PU,UART_RXD_PIN
;	BCF     PT1  ,UART_RXD_PIN
;
;	BSF     PT1EN,UART_TXD_PIN
;	BCF     PT1PU,UART_TXD_PIN
;	BCF     PT1  ,UART_TXD_PIN
	CALL    F_WiFi_PowerOff_UartIoOut0

    BCF     Wakeup_Flags,B_WakenOn_INT0
    BCF     Wakeup_Flags,B_WakenOn_RTC
	
Scale_Sleep_cfg:
	BCF     AD2OH,7
    BCF     INTE ,AD2IE
    
    BCF     INTE ,ADIE
    BCF     NETF ,LDOEN
    BSF     INTE ,GIE

Scale_Sleep_Now:
	CLRWDT
	SLEEP
	NOP

Scale_WAKEUP:
;	BTFSC   Wakeup_Flags,B_WakenOn_INT0
;	GOTO    Scale_WAKEUP_INT0
	BTFSC   Wakeup_Flags,B_WakenOn_RTC
	GOTO    Scale_WAKEUP_ScanWeight
	GOTO    Scale_Sleep_cfg

;--- WDT  Wakeup
Scale_WAKEUP_ScanWeight:
	BCF     Wakeup_Flags,B_WakenOn_RTC
	INCLUDE Scale_AutoOn.ASM
	GOTO    Scale_Sleep_Exit

;--- INT1 Wakeup
Scale_WAKEUP_INT0:
	CLRF    Wakeup_Flags
    BSF     Wakeup_Flags  ,WakenOn_Flag
	CLRF    ScaleFlowValue
	BSF     ScaleFlowValue,B_ScaleFlow_INIT
Scale_Sleep_Exit:

	
	