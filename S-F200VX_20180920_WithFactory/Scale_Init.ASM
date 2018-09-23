;===========================================
;==== Scale_Init.ASM
;===========================================

Scale_Init_Entry:
   BCF     INTE,ADIE
   BCF     INTE,E1IE
   BCF     INTE,E0IE
   BCF     INTE,ADIE

Scale_Init_DisableADC:
   BCF      NETC,ADEN

Scale_Init_Power:
;  MOVLW    10011010B    ; LDOS - 2.45V , Lo IS ENABLDE , LVD_PT13
;  MOVLW    10000010B    ; LDOS - 2.45V , Lo IS ENABLDE , 2.4V
   MOVLW    10000000B    ; LDOS - 2.45V , Lo IS DISABLE
   MOVWF    NETE
   MOVLW    00100010B
   MOVWF    NETF
   BSF      NETF,LDOEN

Scale_Init_IO:

	
Scale_Init_CLR_RAM0:
   BCF     BSR ,IRP0
   MOVFL   FSR0,080H
Scale_Init_CLR_RAM0_LOOP:
   CLRF    IND0
   INCF    FSR0,F
   MOVLW   UnitFlag
   SUBWF   FSR0,W
   BTFSS   STATUS,C
   GOTO    Scale_Init_CLR_RAM0_LOOP

Scale_Init_CLR_RAM1:
   BSF     BSR ,IRP0
   MOVFL   FSR0,UART_RX_BUF
Scale_Init_CLR_RAM1_LOOP:
   CLRF    IND0
   INCF    FSR0,F
   MOVLW   0FFH
   SUBWF   FSR0,W
   BTFSS   STATUS,C
   GOTO    Scale_Init_CLR_RAM1_LOOP
   CLRF    IND0
   BCF     BSR,IRP0

Scale_Init_Timer0:
  CALL      F_SysTimer0_OPEN

Scale_Init_Timer1:
;-- Timer1 used for led display

Scale_Init_ADC:
   MOVLW    00000111B   ; ADC OUT 30.5HZ
   MOVWF    ADCON
   MOVLW    00000000B
   MOVWF    NETA
   MOVLW    11100000B
   MOVWF    TEMPC
   MOVLW    00001110B   ; PGA =
   MOVWF    NETC
   BSF      NETC,ADEN
   BSF      INTE,ADIE

   CLRF		SampleTimes
   BSF      SysFlag1,B_SysFlag1_AdcStart

Scale_Init_LED:
   CALL     F_LED_DISP_INIT
   CALL     ClrLEDBuffer
   CALL     LoadDspData
   
Scale_ChkBat_INIT:   
   CALL     F_Bat_Chk_Init
   
Scale_Uart_INIT:
   BCF      WIFI_PWR_PORT,WIFI_PWR_PIN  ; POWER OFF THE WIFI
   CLRF     WifiPwrCnt
   
   BCF      INTE2,URRIE
   BCF      INTE2,URTIE
   CLRF     SCON1
   
   BCF      PT1EN,UART_RXD_PIN
   BCF      PT1PU,UART_RXD_PIN
   BCF      PT1  ,UART_RXD_PIN

   BCF      PT1EN,UART_TXD_PIN
   BCF      PT1PU,UART_TXD_PIN
   BCF      PT1  ,UART_TXD_PIN

Scale_Init_Exit:

	
	
	
	