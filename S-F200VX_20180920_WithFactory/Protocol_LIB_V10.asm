;=============================================================
;==== Protocol_LIB_V10.ASM
;=============================================================

F_Send_UnLockData:
	MOVFF   UART_TX5  , BAT_VoltageH ; HIGH 390     ; BAT 
	MOVFF   UART_TX6  , BAT_VoltageL ; LOW  390
	BCF     STATUS,C
	RLF     UART_TX6,F
	RLF     UART_TX5,F
	MOVFF   UART_TX7  , RTCYEAR      ; RTC
	MOVFF   UART_TX8  , RTCMON
	MOVFF   UART_TX9  , RTCDAY
	MOVFF   UART_TX10 , RTCHOUR
	MOVFF   UART_TX11 , RTCMIN
	MOVFF   UART_TX12 , RTCSEC
	MOVFF   UART_TX13 , RTCDWR
	MOVFL   UART_TX14 , 00000000B    ; STATUS
	GOTO    F_Send_DataComm

F_Send_FinalData:    
	MOVFL   UART_TX14 , 00000011B    ; STATUS
    GOTO    F_Send_Data_comm_A

F_Send_LockData:
    MOVFL   UART_TX14 , 00000010B    ; STATUS

F_Send_Data_comm_A:
	MOVFF   UART_TX5  , BAT_VoltageH ;HIGH 390     ; BAT 
	MOVFF   UART_TX6  , BAT_VoltageL ;LOW  390 
	BCF     STATUS    , C
	RLF     UART_TX6  , F
	RLF     UART_TX5  , F
	MOVFF   UART_TX7  , RTC_YEAR     ; RTC
	MOVFF   UART_TX8  , RTC_MON 
	MOVFF   UART_TX9  , RTC_DAY 
	MOVFF   UART_TX10 , RTC_HOUR
	MOVFF   UART_TX11 , RTC_MIN 
	MOVFF   UART_TX12 , RTC_SEC 
	MOVFF   UART_TX13 , RTC_Week

F_Send_DataComm:
	MOVFL   UART_TX_SOP,0C5H
	MOVFL   UART_TX_LEN,01EH
	MOVFL   UART_TX_CMD,010H
;--- WEIGHT
    CLRF	TempRam4
    CLRF    TempRam5
    MOVFL   TempRam6,5
    CLRF	TempRam11
    MOVFF	TempRam12,SendCount_H
    MOVFF	TempRam13,SendCount_L
    CALL	_Mul3_3
	MOVFF   UART_TX3 ,TempRam5
	MOVFF   UART_TX4 ,TempRam6
;--- unit
;	BTFSC   UnitFlag ,KgFlag
;	BCF     UART_TX14,4
	BTFSC   UnitFlag ,LbFlag
	BSF     UART_TX14,4
;---
	CLRF    UART_TX15 
	CLRF    UART_TX16
	CLRF    UART_TX17
	CLRF    UART_TX18
	CLRF    UART_TX19
;--- 电阻值
	MOVLW   0FFH          ; UART_TX20,UART_TX21 为0FFFFH时，由WIFI测脂
	MOVWF   UART_TX20
	MOVWF   UART_TX21
	MOVLW   000H
	MOVWF   UART_TX22
	MOVWF   UART_TX23
	MOVWF   UART_TX24
	MOVWF   UART_TX25
	MOVWF   UART_TX26
	MOVWF   UART_TX27
	MOVWF   UART_TX28
    MOVWF   UART_TX29
    MOVWF   UART_TX30
    MOVWF   UART_TX31
	GOTO    F_Send_Comm
	
F_Send_SmartConfig:
	MOVFL   UART_TX_SOP,0C5H
	MOVFL   UART_TX_LEN,001H
	MOVFL   UART_TX_CMD,012H
	GOTO    F_Send_Comm
	
F_Send_CMDAck:
	MOVFL   UART_TX_SOP,0C6H
	MOVFL   UART_TX_LEN,001H
	MOVFF   UART_TX_CMD,UART_ACK
	GOTO    F_Send_Comm
	
F_Send_UpdateAck:
	GOTO    F_Send_Comm

F_Send_UpdatePackage:
	GOTO    F_Send_Comm

; Wifi Factory
F_Send_WifiTest:
	MOVFL   UART_TX_SOP,0C5H
	MOVFL   UART_TX_LEN,001H
	MOVFl   UART_TX_CMD,0CCH
	GOTO    F_Send_Comm 
	
;-------------------------	
F_Send_Comm:
	
;-------------------------		
F_Send_CalCs:
    BSF     BSR ,IRP0
	MOVFL   FSR0,UART_TX_SOP
	CLRF    REG0               ; CS
	MOVFF   REG1,UART_TX_LEN
	MOVLW   02H
	ADDWF   REG1,F
F_Send_CalCs_LOOP:
    MOVFW   INDF0
	XORWF   REG0,F
	INCF    FSR0,F
    DECFSZ  REG1,F
	GOTO    F_Send_CalCs_LOOP
	MOVFF   INDF0,REG0
	BCF     BSR ,IRP0
F_UART_Send_CalCs_END:

;-------------------------
F_Send_nBytes: 
    BSF     BSR ,IRP0
	MOVFL   FSR0,UART_TX_SOP
	MOVFF   REG1,UART_TX_LEN
	MOVLW   03H
	ADDWF   REG1,F
F_Send_nBytes_LOOP:
    MOVFF   SBUF,INDF0
    CLRF    REG0
F_Send_nBytes_LOOP_0:
;---
	INCF    REG0,F
	MOVLW   250
	SUBWF   REG0,W
	BTFSC   STATUS,C
	GOTO    F_Send_nBytes_END
;---
    BTFSS   INTF2,URTIF
    GOTO    F_Send_nBytes_LOOP_0
	BCF     INTF2,URTIF
	INCF    FSR0,F
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
    DECFSZ  REG1,F
	GOTO    F_Send_nBytes_LOOP
F_Send_nBytes_END:
	BCF     INTF2,URTIF
    BCF     BSR ,IRP0
RETURN

