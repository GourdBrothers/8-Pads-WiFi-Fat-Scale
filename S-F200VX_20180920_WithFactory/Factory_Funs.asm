;==================================================
;==== Factory_Funs.ASM 
;==================================================
Factory_Mark_ADDR_H    EQU    010H
Factory_Mark_ADDR_L    EQU    011H

Factory_Mark_Value_H   EQU    0A5H
Factory_Mark_Value_L   EQU    05AH

F_Factory_Chk_Mark:
;
	MOVLW  Factory_Mark_ADDR_H
	MOVWF  BIE_ADDR
	CALL   F_18MXX_BIE_RD_BYTE
    MOVFW  BIE_BYTE
    MOVWF  REG0
;
    MOVLW  Factory_Mark_ADDR_L
	MOVWF  BIE_ADDR
	CALL   F_18MXX_BIE_RD_BYTE
    MOVFW  BIE_BYTE
    MOVWF  REG1
RETURN

;--- Input: BIE_ADDR,BIE_BYTE
;--- F_18MXX_BIE_WR_BYTE
F_Factory_WR_Mark:
;---
    MOVLW  Factory_Mark_ADDR_H
	MOVWF  BIE_ADDR
	MOVLW  Factory_Mark_Value_H
	MOVWF  BIE_BYTE
	CALL   F_18MXX_BIE_WR_BYTE
	MOVLW  20
	CALL   cs_delay_1ms
;---
    MOVLW  Factory_Mark_ADDR_L
	MOVWF  BIE_ADDR
	MOVLW  Factory_Mark_Value_L
	MOVWF  BIE_BYTE
	CALL   F_18MXX_BIE_WR_BYTE
	MOVLW  20
	CALL   cs_delay_1ms
RETURN
