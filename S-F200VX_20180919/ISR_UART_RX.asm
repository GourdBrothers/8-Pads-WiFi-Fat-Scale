;============================================================
;===== ISR_UART_RX.ASM
;============================================================
ISR_RX_Entry:
    BTFSC    UartRxFlag,B_UartRxFlag_OK
	GOTO     ISR_RX_EXIT 
	BSF      UartRxFlag,B_UartRxFlag_TRG
	CLRF     R_UartRXTimer
	BTFSC    UartRxFlag,B_UartRxFlag_L
	GOTO     ISR_RX_Length
	BTFSC    UartRxFlag,B_UartRxFlag_D
	GOTO     ISR_RX_DataBuf
ISR_RX_Header_C5:
    MOVLW    0C5H
	XORWF    UART_RX_BUF,W
	BTFSS    STATUS,Z
	GOTO     ISR_RX_Header_C6
	MOVFF    UART_RX_SOP,UART_RX_BUF
	BSF      UartRxFlag,B_UartRxFlag_L
	BCF      UartRxFlag,B_UartRxFlag_D
	BCF      UartRxFlag,B_UartRxFlag_C6
	GOTO     ISR_RX_EXIT
ISR_RX_Header_C6:
	MOVLW    0C6H
	XORWF    UART_RX_BUF,W
	BTFSS    STATUS,Z
	GOTO     ISR_RX_Init
	MOVFF    UART_RX_SOP,UART_RX_BUF
	BSF      UartRxFlag,B_UartRxFlag_L
    BCF      UartRxFlag,B_UartRxFlag_D
    BSF      UartRxFlag,B_UartRxFlag_C6
	GOTO     ISR_RX_EXIT
ISR_RX_Length:
    BCF      UartRxFlag,B_UartRxFlag_L
	BSF      UartRxFlag,B_UartRxFlag_D
	MOVFF    UART_RX_LEN,UART_RX_BUF
	MOVLW    18+1
	SUBWF    UART_RX_LEN,W
	BTFSC    STATUS,C
	GOTO     ISR_RX_Init
    CLRF     R_UartRxCnt
    GOTO     ISR_RX_EXIT
ISR_RX_DataBuf:
    BSF      BSR,IRP0
	MOVFL    FSR0,UART_RX2
	MOVFW    R_UartRxCnt
	ADDWF    FSR0,F
	MOVFF    IND0,UART_RX_BUF
	INCF     R_UartRxCnt,F
	MOVFW    UART_RX_LEN
	ADDLW    01H
	SUBWF    R_UartRxCnt,W
	BTFSS    STATUS,C
	GOTO     ISR_RX_EXIT
ISR_RX_OK:
    CLRF     UartRxFlag
    BSF      UartRxFlag,B_UartRxFlag_OK
	CLRF     R_UartRxCnt
	CLRF     R_UartRXTimer
    GOTO     ISR_RX_EXIT
ISR_RX_Init:
    CLRF     UartRxFlag
	CLRF     R_UartRxCnt
	CLRF     R_UartRXTimer
ISR_RX_EXIT:
	