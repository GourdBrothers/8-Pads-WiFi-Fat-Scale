;================================================================
;==== PowerOn.ASM
;================================================================

PowerOn_Entry:
    CLRF     INTE
	CLRF     INTE2
	CLRF     BSR

PowerOn_SET_CLK:
    MOVFL    MCK   , 00000110B   ; CPU_CLK = 2M
	NOP

PowerOn_EN_WDT:
	BCF      STATUS,TO
	MOVFL    WDTIN ,0BBH
	MOVFL    WDTCON,10000100B
    CLRWDT

PowerOn_SET_IO:
    MOVFL    PTINT ,00010000B
    CLRF     PT2CON

PowerOn_SET_IO1:
    BSF      AIENB , AIENB1
    MOVFL    PT1EN , 11110100B
	MOVFL    PT1PU , 00001011B
	MOVFL    PT1   , 00001011B

PowerOn_SET_IO2:
    BCF      AIENB , AIENB2
    MOVFL    PT2EN , 11111011B
	MOVFL    PT2PU , 00000000B
	MOVFL    PT2   , 00000000B

PowerOn_SET_IO4:
    BCF      AIENB , AIENB3
    MOVFL    PT4EN , 00000000B
	MOVFL    PT4PU , 11111100B
	MOVFL    PT4   , 11111100B

PowerOn_ClrRam0:
    BCF      BSR , IRP0
	MOVFL    FSR0, 080H
PowerOn_ClrRam0_LOOP:
    CLRF     IND0
	INCFSZ   FSR0,F
	GOTO     PowerOn_ClrRam0_LOOP

PowerOn_ClrRam1:
    BSF      BSR  , IRP0
	MOVFL    FSR0 , 000H
PowerOn_ClrRam1_LOOP:
    CLRF     IND0
    INCFSZ   FSR0 , F
    GOTO     PowerOn_ClrRam1_LOOP
	BCF      BSR  , IRP0

PowerOn_SET_TM0:
    CALL     F_SysTimer0_Config
    
PowerOn_SET_RTC:
    CALL     F_RTC_Default

PowerOn_ENABLE_GIE:
    BSF      INTE,GIE

PowerOn_Default:
	BSF      UnitFlag , KgFlag
;	BSF      UnitFlag , SJFlag

PowerOn_Exit:
	
	









