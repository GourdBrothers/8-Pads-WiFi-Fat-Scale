;=====================================================
;===== IIC_Funs.ASM
;===== 主机部分：已通过逻辑分析仪
;=====================================================

;  IIC_SCL_PTEN    EQU   PT1EN
;  IIC_SCL_PTPU    EQU   PT1PU
;  IIC_SCL_PORT    EQU   PT1
;   B_IIC_PIN_SCL  EQU   3
;
;  IIC_SDA_PTEN    EQU   PT4EN
;  IIC_SDA_PTPU    EQU   PT4PU
;  IIC_SDA_PORT    EQU   PT4
;   B_IIC_PIN_SDA  EQU   2
;


F_IIC_INIT:
	BSF     IIC_SCL_PTEN,B_IIC_PIN_SCL
	BSF     IIC_SCL_PTPU,B_IIC_PIN_SCL
	BSF     IIC_SCL_PORT,B_IIC_PIN_SCL
	BSF     IIC_SDA_PTEN,B_IIC_PIN_SDA
	BSF     IIC_SDA_PTPU,B_IIC_PIN_SDA
	BSF     IIC_SDA_PORT,B_IIC_PIN_SDA
RETURN

F_IIC_IDLE:
	BCF     IIC_SCL_PTEN,B_IIC_PIN_SCL
	BSF     IIC_SCL_PTPU,B_IIC_PIN_SCL
	BCF     IIC_SDA_PTEN,B_IIC_PIN_SDA
	BSF     IIC_SDA_PTPU,B_IIC_PIN_SDA
RETURN

F_IIC_START:
	BSF     IIC_SDA_PORT,B_IIC_PIN_SDA
	BSF     IIC_SCL_PORT,B_IIC_PIN_SCL
	NOP
	NOP
	NOP
	NOP
	BCF     IIC_SDA_PORT,B_IIC_PIN_SDA
	NOP
	NOP
	NOP
	NOP
	BCF     IIC_SCL_PORT,B_IIC_PIN_SCL
RETURN

F_IIC_Respons:
F_IIC_Respons_LOOP:	
RETURN

F_IIC_STOP:
	BCF     IIC_SDA_PORT,B_IIC_PIN_SDA
	BSF     IIC_SCL_PORT,B_IIC_PIN_SCL
	NOP
	NOP
	NOP
	NOP
	BSF     IIC_SDA_PORT,B_IIC_PIN_SDA
RETURN

;--------------------------------------
;--- Check slave ack
;--- OUTPUT IIC_Index[0]
;--- 0 : Has ack
;--- 0 : No  ack
F_IIC_ChkAck:
    BSF     IIC_SCL_PORT,B_IIC_PIN_SCL
	CLRF    IIC_Index
	NOP
	NOP
	NOP
F_IIC_ChkAck_Loop:
	BTFSS   IIC_SDA_PORT,B_IIC_PIN_SDA
	GOTO    F_IIC_HasACK
	INCF    IIC_Index,F
	MOVLW   50
	SUBWF   IIC_Index,W
	BTFSS   STATUS,C
	GOTO    F_IIC_ChkAck_Loop
F_IIC_NoACK:
	BSF     IIC_Index,0
	GOTO    F_IIC_ChkAck_END
F_IIC_HasACK:
    BCF     IIC_Index,0
F_IIC_ChkAck_END:
	BCF     IIC_SCL_PORT,B_IIC_PIN_SCL
	NOP
	NOP
	NOP
	BSF     IIC_SDA_PTEN,B_IIC_PIN_SDA   ; SDA PIN INPUT
	NOP
	NOP
RETURN

;--------------------------------------
;--- Send one byte to slave
;--- Input  : IIC_TempData
;--- Output : NONE
F_IIC_SendByte:
	BSF     IIC_SDA_PTEN,B_IIC_PIN_SDA
	MOVFL   IIC_Index,08H
F_IIC_SendByteLoop:
	BCF     IIC_SCL_PORT,B_IIC_PIN_SCL
	BCF     STATUS,C
	RLF     IIC_TempData,F
	BTFSS   STATUS,C
	GOTO    F_IIC_SendByte_SDA_L
F_IIC_SendByte_SDA_H:
	NOP
	BSF     IIC_SDA_PORT,B_IIC_PIN_SDA
	GOTO    F_IIC_SendByte_COMM
F_IIC_SendByte_SDA_L:
	BCF     IIC_SDA_PORT,B_IIC_PIN_SDA
	NOP
	NOP
F_IIC_SendByte_COMM:
	BSF     IIC_SCL_PORT,B_IIC_PIN_SCL
	NOP
	NOP
	NOP
	NOP
	NOP
	DECFSZ  IIC_Index,F
	GOTO    F_IIC_SendByteLoop
	NOP
	BCF     IIC_SCL_PORT,B_IIC_PIN_SCL
	NOP
	NOP
	NOP
	BCF     IIC_SDA_PTEN,B_IIC_PIN_SDA
RETURN

;--------------------------------------
;--- Send one byte to slave
;--- Input  : IIC_TempData
;--- Output : NONE
F_IIC_ReadByte:
	BCF     IIC_SDA_PTEN,B_IIC_PIN_SDA  ; SDA PIN INPUT
	MOVFL   IIC_Index,08H
F_IIC_ReadByteLoop:
	BSF     IIC_SCL_PORT,B_IIC_PIN_SCL  ; SCL RISE
	BCF     STATUS,C
	RLF     IIC_TempData,F
	NOP
	NOP
	BTFSC   IIC_SDA_PORT,B_IIC_PIN_SDA
	BSF     IIC_TempData,0
	BCF     IIC_SCL_PORT,B_IIC_PIN_SCL    ; SCL low
	NOP
	NOP
	NOP
    DECFSZ  IIC_Index,F
	GOTO    F_IIC_ReadByteLoop
RETURN

;--------------------------------------
;--- Send ack to slave
;--- Input  : NONE
;--- Output : NONE
F_IIC_SendACK:
	BSF     IIC_SDA_PTEN,B_IIC_PIN_SDA   ; SDA PIN INPUT
	BCF     IIC_SDA_PORT,B_IIC_PIN_SDA
    BSF     IIC_SCL_PORT,B_IIC_PIN_SCL   ; SCL High
    NOP
    NOP
    NOP
    NOP
    NOP
    BCF     IIC_SCL_PORT,B_IIC_PIN_SCL   ; SCL High
    NOP
    NOP
    NOP
    NOP
    BSF     IIC_SDA_PORT,B_IIC_PIN_SDA
RETURN

;--------------------------------------
;--- Send noack to slave
;--- Input  : NONE
;--- Output : NONE
F_IIC_SendNoACK:
	BSF     IIC_SDA_PTEN,B_IIC_PIN_SDA  ; SDA PIN INPUT
	BSF     IIC_SDA_PORT,B_IIC_PIN_SDA
    BSF     IIC_SCL_PORT,B_IIC_PIN_SCL   ; SCL High
    NOP
    NOP
    NOP
    NOP
    BCF     IIC_SCL_PORT,B_IIC_PIN_SCL   ; SCL High
RETURN
	
	
	
	
	
	
	