;=================================================================
;=========  CSM37F58_lib.ASM
;=================================================================

;======================================
;=== Send functions

;--- CMD 4 pad measure
F_IIC_Wr_M_PART_4:
	MOVFL    IIC_DATA0,010H         ; ADDR
	MOVFL    IIC_DATA1,002H
	MOVFL    IIC_DATA2,000H         ; DATA, 4 电极
    MOVFL    IIC_Cnt  ,001H         ; length of data
    GOTO     F_IIC_Send_COMM
    
;--- CMD 8 pad measure
F_IIC_Wr_M_PART_8:
	MOVFL    IIC_DATA0,010H         ; ADDR
	MOVFL    IIC_DATA1,002H
	MOVFL    IIC_DATA2,002H         ; DATA, 8 电极
    MOVFL    IIC_Cnt  ,001H         ; length of data
    GOTO     F_IIC_Send_COMM

;--- CMD enadle measure
F_IIC_Send_EnableMeasure:
	MOVFL    IIC_DATA0,010H         ; ADDR
	MOVFL    IIC_DATA1,000H
	MOVFL    IIC_DATA2,080H         ; DATA
    MOVFL    IIC_Cnt  ,001H         ; length of data
    GOTO     F_IIC_Send_COMM
    
;--- CMD write user's information
F_IIC_Send_UserInfo:
	MOVFL    IIC_DATA0,010H         ; ADDR
	MOVFL    IIC_DATA1,058H
	MOVFF    IIC_DATA2,USER_CountH  ; DATA
	MOVFF    IIC_DATA3,USER_CountL
	MOVFF    IIC_DATA4,USER_Height
	MOVFF    IIC_DATA5,USER_SexAge
	MOVFF    IIC_DATA5,USER_Style
    MOVFL    IIC_Cnt  ,005H         ; length of data
	GOTO     F_IIC_Send_COMM
	
;--- CMD START FAT CAL
F_IIC_Send_StartCalFat:
	MOVFL    IIC_DATA0,03FH         ; ADDR
	MOVFL    IIC_DATA1,05AH	
    MOVFL    IIC_DATA2,004H         ; data
    MOVFL    IIC_Cnt  ,001H         ; length of data
	GOTO     F_IIC_Send_COMM
	
;--- CMD write flash
F_IIC_Send_wrFlash: 
	MOVFL    IIC_DATA0,03FH         ; ADDR
	MOVFL    IIC_DATA1,05AH	
    MOVFL    IIC_DATA2,005H         ; data
    MOVFL    IIC_Cnt  ,001H         ; length of data
    GOTO     F_IIC_Read_COMM
		
;--- CMD SLEEP
F_IIC_Send_SLEEP:
	MOVFL    IIC_DATA0,03FH         ; ADDR
	MOVFL    IIC_DATA1,05AH	
    MOVFL    IIC_DATA2,035H         ; data
    MOVFL    IIC_Cnt  ,001H         ; length of data
	GOTO     F_IIC_Send_COMM
	
;--- CMD WAKEUP
F_IIC_Send_WAKEUP:	
	MOVFL    IIC_DATA0,03FH         ; ADDR
	MOVFL    IIC_DATA1,05AH	
    MOVFL    IIC_DATA2,053H         ; data
    MOVFL    IIC_Cnt  ,001H         ; length of data
	GOTO     F_IIC_Send_COMM

;---
F_IIC_Send_COMM:
    CALL     F_IIC_INIT
	BSF      BSR ,IRP0
	MOVFL    FSR0,IIC_DATA2
F_IIC_Send_N_Bytes:
	CALL     F_IIC_START
	MOVFL    IIC_TempData,0A0H       ; DEVICE
	CALL     F_IIC_SendByte
	CALL     F_IIC_ChkAck
	MOVFF    IIC_TempData,IIC_DATA0  ; ADDER H
	CALL     F_IIC_SendByte
	CALL     F_IIC_ChkAck
	MOVFF    IIC_TempData,IIC_DATA1  ; ADDER L
	CALL     F_IIC_SendByte
	CALL     F_IIC_ChkAck
F_IIC_Send_N_Bytes_Loop:
	MOVFF    IIC_TempData,INDF0      ; DATA
	CALL     F_IIC_SendByte
	CALL     F_IIC_ChkAck
	INCF     FSR0,F
	DECFSZ   IIC_Cnt,F
	GOTO     F_IIC_Send_N_Bytes_Loop
F_IIC_Send_N_Bytes_End:
	CALL	 F_IIC_STOP
	CALL     F_IIC_IDLE
	BCF      BSR ,IRP0
RETURN

;======================================
;=== Read functions
;--- read module status
F_IIC_Read_STATUS:
	MOVFL    IIC_DATA0,010H         ; ADDR
	MOVFL    IIC_DATA1,000H
    MOVFL    IIC_Cnt  ,1            ; length of data
    GOTO     F_IIC_Read_COMM
    
;--- read REG M_PART
F_IIC_Read_M_PART:
	MOVFL    IIC_DATA0,010H         ; ADDR
	MOVFL    IIC_DATA1,002H
    MOVFL    IIC_Cnt  ,1            ; length of data
    GOTO     F_IIC_Read_COMM
    
;--- read res status
F_IIC_Read_zSTATUS:
	MOVFL    IIC_DATA0,010H         ; ADDR
	MOVFL    IIC_DATA1,010H
    MOVFL    IIC_Cnt  ,1            ; length of data
    GOTO     F_IIC_Read_COMM
   
;--- read  Err_status
F_IIC_Read_errSTATUS:
	MOVFL    IIC_DATA0,010H         ; ADDR
	MOVFL    IIC_DATA1,011H
    MOVFL    IIC_Cnt  ,1            ; length of data
    GOTO     F_IIC_Read_COMM
    
;--- read  Cmd status
F_IIC_Read_cSTATUS:
	MOVFL    IIC_DATA0,010H         ; ADDR
	MOVFL    IIC_DATA1,012H
    MOVFL    IIC_Cnt  ,1            ; length of data
    GOTO     F_IIC_Read_COMM
    
;--- read Frequence STATUS
F_IIC_Read_fSTATUS:
	MOVFL    IIC_DATA0,010H         ; ADDR
	MOVFL    IIC_DATA1,013H
    MOVFL    IIC_Cnt  ,1            ; length of data
    GOTO     F_IIC_Read_COMM
    
;--- read 4pad res
F_IIC_Read_4PadRES:
	MOVFL    IIC_DATA0,010H         ; ADDR
	MOVFL    IIC_DATA1,0D8H
    MOVFL    IIC_Cnt  ,2            ; length of data
    GOTO     F_IIC_Read_COMM

;--- read 8pad res
F_IIC_Read_8PadRES:
	MOVFL    IIC_DATA0,010H         ; ADDR
	MOVFL    IIC_DATA1,0DAH
    MOVFL    IIC_Cnt  ,10           ; length of data
    GOTO     F_IIC_Read_COMM

;---
F_IIC_Read_COMM:
	CALL    F_IIC_INIT
	BSF     BSR ,IRP0
	MOVFL   FSR0,IIC_DATA2
F_IIC_Read_N_Bytes:
    CALL    F_IIC_START             ; start
	MOVFL   IIC_TempData,0A0H       ; Device
	CALL    F_IIC_SendByte
	CALL    F_IIC_ChkAck
	MOVFF   IIC_TempData,IIC_DATA0  ; ADDER H
	CALL    F_IIC_SendByte
	CALL    F_IIC_ChkAck
	MOVFF   IIC_TempData,IIC_DATA1  ; ADDER L
	CALL    F_IIC_SendByte
	CALL    F_IIC_ChkAck
    CALL    F_IIC_START             ; restart
	MOVFL   IIC_TempData,0A1H
	CALL    F_IIC_SendByte
	CALL    F_IIC_ChkAck
;---
	MOVFL    REG0,30
F_IIC_Read_delay:
	NOP
	DECFSZ   REG0,F
	GOTO     F_IIC_Read_delay
;---
	MOVLW    01H
	XORWF    IIC_Cnt,W
	BTFSC    STATUS,Z
	GOTO     F_IIC_Read_LastByte
;--- 
	DECF     IIC_Cnt,F
F_IIC_Read_N_Bytes_Loop:
    CALL     F_IIC_ReadByte
    CALL     F_IIC_SendACK
    MOVFF    INDF0,IIC_TempData ;DATA
    INCF     FSR0,F
	DECFSZ   IIC_Cnt,F
	GOTO     F_IIC_Read_N_Bytes_Loop
;---
F_IIC_Read_LastByte:
    CALL     F_IIC_ReadByte
    CALL     F_IIC_SendNoACK
    MOVFF    INDF0,IIC_TempData ;DATA
F_IIC_Read_N_Bytes_End:
    CALL     F_IIC_STOP
	CALL     F_IIC_IDLE
	BCF      BSR ,IRP0
RETURN
	




