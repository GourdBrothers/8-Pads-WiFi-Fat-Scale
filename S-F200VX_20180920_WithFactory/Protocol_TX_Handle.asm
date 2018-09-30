;=================================================
;=====  Protocol_TX_Handle.asm
;=====  CMD10: C5 1E 10 0A 2D 00 00 18 01 08 12 00 15 05 03 00 00 00 00 00 FF FF 00 00 00 00 00 00 00 00 00 00 FC
;=====  CMDCC: C5 01 CC 08
;=================================================

Protocol_TX_Entry:
 	BTFSC    UART_TX_EVENT,B_UART_TX_EVENT_ACK
	GOTO     Protocol_TX_ACK
	BTFSC    UART_TX_EVENT,B_UART_TX_EVENT_unlock
	GOTO     Protocol_TX_UnlockData
	BTFSC    UART_TX_EVENT,B_UART_TX_EVENT_lock
	GOTO     Protocol_TX_LockData
	BTFSC    UART_TX_EVENT,B_UART_TX_EVENT_CFG
	GOTO     Protocol_TX_SmartConfig
	BTFSC    UART_TX_EVENT,B_UART_TX_EVENT_Final
	GOTO     Protocol_TX_FinalData
	BTFSC    UART_TX_EVENT,B_UART_TX_EVENT_WifiTest
	GOTO     Protocol_TX_WifiTest
	GOTO     Protocol_TX_Exit

Protocol_TX_UnlockData:
	CALL     F_Send_UnLockData
	BCF      UART_TX_EVENT,B_UART_TX_EVENT_unlock
	GOTO     Protocol_TX_Exit
	
Protocol_TX_LockData:
	CALL     F_Send_LockData
	BCF      UART_TX_EVENT,B_UART_TX_EVENT_lock
	GOTO     Protocol_TX_Exit
	
Protocol_TX_SmartConfig:
	CALL     F_Send_SmartConfig
	BCF      UART_TX_EVENT,B_UART_TX_EVENT_CFG
	GOTO     Protocol_TX_Exit
	
Protocol_TX_ACK:
	CALL     F_Send_CMDAck
	BCF      UART_TX_EVENT,B_UART_TX_EVENT_ACK
	GOTO     Protocol_TX_Exit
	
Protocol_TX_FinalData:
	CALL     F_Send_FinalData
	BCF      UART_TX_EVENT,B_UART_TX_EVENT_Final
	GOTO     Protocol_TX_Exit
	
Protocol_TX_WifiTest:
	CALL     F_Send_WifiTest
	BCF      UART_TX_EVENT,B_UART_TX_EVENT_WifiTest
	GOTO     Protocol_TX_Exit
	
Protocol_TX_Exit:
	
	