;===============================================
;=======   CSU18M88_MACRO.INC
;===============================================

MOVFL    MACRO   F1,D1
    MOVLW   D1
	MOVWF   F1
ENDM

MOVFF    MACRO   F1,F2
    MOVFW   F2
	MOVWF   F1
ENDM

RRF_4BIT	MACRO   DATA
	BCF     STATUS,C
	RRF     DATA,F
	BCF     STATUS,C
	RRF     DATA,F
	BCF     STATUS,C
	RRF     DATA,F
	BCF     STATUS,C
	RRF     DATA,F
	ENDM