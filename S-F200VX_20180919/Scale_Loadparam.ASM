;========================================================
;====== Scale_Loadparam.ASM
;========================================================

_Load_Param_Entry:
	MOVFL    MaxCountH,HIGH 3062
	MOVFL    MaxCountL,LOW  3062
;	MOVFL    CalDot1H ,HIGH 5000
;	MOVFL    CalDot1L ,LOW  5000
;	MOVFL    CalDot2H ,HIGH 10000
;	MOVFL    CalDot2L ,LOW  10000
;	MOVFL    CalDot3H ,HIGH 15000
;	MOVFL    CalDot3L ,LOW  15000	
;	CALL     F_18MXX_BLE_CAL_WR	

	CALL     F_18MXX_BLE_CAL_RD	
	MOVLW    0AAH
	XORWF    Cal_MARK,W
	BTFSC    STATUS,Z
	GOTO    _Load_Param_Exit
_Load_Param_Default:

	MOVFL    CalDot1H ,HIGH  6000
	MOVFL    CalDot1L ,LOW   6000
	MOVFL    CalDot2H ,HIGH 12000
	MOVFL    CalDot2L ,LOW  12000
	MOVFL    CalDot3H ,HIGH 18000
	MOVFL    CalDot3L ,LOW  18000

_Load_Param_Exit:
	