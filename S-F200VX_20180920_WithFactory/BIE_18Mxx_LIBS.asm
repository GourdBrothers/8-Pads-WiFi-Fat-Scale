;==============================================
;==== BIE_18MXX_LIBS.ASM
;==============================================
;----------------------------------------------
;--- BIE write one BYTE
;--- Input: BIE_ADDR,BIE_BYTE
F_18MXX_BIE_WR_BYTE:
;	MOVFL  WDTCON,085H
	CLRWDT
	MOVFL    EADRH ,020H
	MOVFF    EADRL ,BIE_ADDR
F_18MXX_BIE_WR_DisGIE:
	BCF      INTE  ,GIE
F_18MXX_BIE_WR_Enable:
	MOVFL    EOPEN ,096H
	MOVFL    EOPEN ,069H
	MOVFL    EOPEN ,05AH
F_18MXX_BIE_WR_LoadData:
	MOVFW    BIE_BYTE
F_18MXX_BIE_WR_DO:
	TBLP     100
F_18MXX_BIE_WR_END:
	CLRWDT
	BSF      INTE  ,GIE
RETURN

;----------------------------------------------
;--- BIE read one BYTE
;--- Input: BIE_ADDR
F_18MXX_BIE_RD_BYTE:
	MOVFF    EADRL,BIE_ADDR
	MOVFL    EADRH,020H
	MOVP
	MOVWF    BIE_BYTE
RETURN


;==========================================
;--- Write bulid in Eeprom functions
;--- OTA BLE MARK WRITE
F_18MXX_BLE_CAL_WR:
	BCF      BSR     ,IRP0
	MOVFL    FSR0    ,CalDot1H
    CLRF     BIE_ADDR
	MOVFL    REG3    ,07H
F_18MXX_BLE_CAL_LOOP:
	MOVFF    BIE_BYTE,IND0
	CALL     F_18MXX_BIE_WR_BYTE
	MOVLW    20
	CALL     cs_delay_1ms
	INCF     FSR0    ,F
	INCF     BIE_ADDR,F
	DECFSZ   REG3    ,F
	GOTO     F_18MXX_BLE_CAL_LOOP
RETURN

;----------------------------------------------
;--- Read bulid in Eeprom functions

F_18MXX_BLE_CAL_RD:
    BCF      BSR     ,IRP0
	MOVFL    FSR0    ,CalDot1H
    CLRF     BIE_ADDR
    MOVFL    REG3    ,07H
F_18MXX_BLE_CAL_RD_LOOP:
	CALL     F_18MXX_BIE_RD_BYTE
    MOVFF    IND0    ,BIE_BYTE
	INCF     FSR0    ,F
	INCF     BIE_ADDR,F
	DECFSZ   REG3    ,F
	GOTO     F_18MXX_BLE_CAL_RD_LOOP
RETURN




