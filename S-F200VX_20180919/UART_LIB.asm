;=============================================================
;==== UART_LIB.ASM
;==== 115200bps,8,N,1
;=============================================================
 
;=============================================================
;==== UART_lib.ASM
;==== 115200bps,8,N,1
;=============================================================


; BLE UART protocol STRUCTURE
; Header + length + CMD + Handle(2bytes) + Data + CS 
; Length : CMD ~ Data

F_UART_InitRX:
   	CLRF        UartRxFlag
	CLRF        R_UartRxCnt
	CLRF        R_UartRXTimer
RETURN

F_UART_Enable:
;--
    BCF     PT1EN,0   ; P1.0  Rx   ‰»Î   
    BSF     PT1PU,0	
    BSF     PT1EN,1   ; P1.1  Tx   ‰≥ˆ
    BSF     PT1PU,1
    BSF     PT1  ,1
    MOVLW  	01010001B
    MOVWF   SCON1
    BSF     SCON2,SMOD
    BSF     SCON2,UARTCLKS
    BSF     INTE2,URRIE
    BCF     INTE2,URTIE
RETURN

F_UART_Disable:
    BCF     PT1EN,0   
    BSF     PT1PU,0	
    BCF     PT1EN,1
    BSF     PT1PU,1
    BCF     INTE2,URRIE
    BCF     INTE2,URTIE
    CLRF    SCON1
RETURN














