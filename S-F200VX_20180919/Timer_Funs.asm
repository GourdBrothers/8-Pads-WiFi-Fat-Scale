;=====================================================
;===== Timer_LIB.ASM
;=====================================================
F_SysTimer0_Config:
    CLRF     TM0CNT
    MOVFL    TM0IN  , 150
	MOVFL    TM0CON , 01110000B   ; TM0_CLK = cpuclk(2m),2m/256/150

F_SysTimer0_CLOSE:
    BCF      INTE	, TM0IE
	BCF      TM0CON , T0EN
RETURN

F_SysTimer0_OPEN:
	BTFSC    TM0CON ,T0EN
	GOTO     F_SysTimer0_OPEN_END
	BSF      INTE	,TM0IE
	BSF      TM0CON ,T0EN
F_SysTimer0_OPEN_END:
RETURN
