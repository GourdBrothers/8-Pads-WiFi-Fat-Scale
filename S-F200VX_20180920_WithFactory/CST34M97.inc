;============================================
; CST34M97 Special Register Address Definition
; Version: V1.1
;============================================
; Data Memory Organization 00h-07h                                                   上电复位值
IND0          EQU         00H	 ;   xxxxxxxx     以FSR0中内容作为地址的数据存储器中的数据
IND1          EQU         01H    ;   xxxxxxxx     以FSR1中内容作为地址的数据存储器中的数据
FSR0          EQU         02H    ;   00000000     间接数据存储器的地址指针0
FSR1          EQU         03H    ;   00000000     间接数据存储器的地址指针1
STATUS        EQU         04H    ;   uuu00xxx     -	-	-	PD	TO	DC	C	Z
WORK          EQU         05H    ;   00000000     工作寄存器
INTF          EQU         06H    ;   uu00u000     -	-	TM1IF	TM0IF	-	ADIF	E1IF	E0IF
INTE          EQU         07H    ;   0u00u000     GIE	-	TM1IE	TM0IE	-	ADIE	E1IE	E0IE
BSR           EQU         08H    ;   00uuuu00     IRP0	IRP1	-	-	-	-	PAGE1	PAGE0
EADRH         EQU         0AH    ;   00u00000     FAIL	BUSY	-	PARH[4:0]
EADRL         EQU         0BH    ;   00000000     PARL[7:0]
EDAT          EQU         0CH    ;   11111111     EDAT[7:0]
EOPEN         EQU         0DH    ;   00000000     EOPEN[7:0]
WDTCON        EQU         0EH    ;   0uuuu000     WDTEN	-	-	-	-	WDTS[2:0]
WDTIN         EQU         0FH    ;   10111011     WDTIN[7:0]
ADOH          EQU         10H    ;   00000000     ADO [23:16]
ADOL          EQU         11H    ;   00000000     ADO[15:8]
ADOLL         EQU         12H    ;   00000000     ADO[7:0]
ADCON         EQU         13H    ;   uuuu0000     -	-	-	-   ADSC	ADM[2:0]
MCK           EQU         14H    ;   uuuuu11u     -	-	-	-	-	M2_CK	M1_CK	-
PCK           EQU         15H    ;   u000000u     -	-	-	-	-	S_beep[1:0]	-
NETA          EQU         18H    ;   00u0uuuu     SINL[1:0]	-	CM_SEL	-	- - -
NETC          EQU         1AH    ;   0000000u     CHOPM[1:0]	-	-	ADG[1:0]	ADEN	-
NETE          EQU         1CH    ;   00u0000u     LDOS[1:0]	-	SILB[2:0]	ENLB
NETF          EQU         1DH    ;   u00uu01u     -	LVR_EN	LDOEN	-	-	BGID[1:0]	-
SVD           EQU         1FH    ;   uuuuuuux     -	-	-	-	-	-	-	LBOUT
PT1           EQU         20H    ;   uuuuxxxx     -	-	-	-		PT1[3:0]
PT1EN         EQU         21H    ;   uuuu0000     -	-	-	-		PT1EN[3:0]
PT1PU         EQU         22H    ;   uuuu0000     -	-	-	-	PT1PU[3:0]
AIENB         EQU         23H    ;   1uu10uuu     AIENB3	-	-	AIENB2	AIENB1	-
PT2           EQU         24H    ;   xxxxxxxx     PT2[7:0]
PT2EN         EQU         25H    ;   00000000     PT2EN[7:0]
PT2PU         EQU         26H    ;   00000000     PT2PU[7:0]
PT4           EQU         27H    ;   xxxxxxxx     PT4[7:0]
PT4EN         EQU         28H    ;   00000000     PT4EN[7:0]
PT4PU         EQU         29H    ;   00000000     PT4PU[7:0]
PT1CON        EQU         2DH    ;   0uuu0000     BZEN	-	-	-	E1M[1:0]	E0M[1:0]
PT2CON        EQU         2EH    ;   00000000     PT2CON[7:0]
PTINT         EQU         2FH    ;   00000000     PTW1[3:0]	PTW0[3:0]
INTF2         EQU         32H    ;   uuuu0000     -	-	-	-	RTCIF	SPIIF	URTIF	URRIF
INTE2         EQU         33H    ;   uuuu0000     -	-	-	-	RTCIE	SPIIE	URTIE	URRIE
TM0CON        EQU         34H    ;   0000u1u0     T0EN	T0RATE[2:0]		T0RSTB		T0SEL
TM0IN         EQU         35H    ;   11111111     TM0IN[7:0]
TM0CNT        EQU         36H    ;   00000000     TM0CNT[7:0]
TM1CON        EQU         37H    ;   00000100     T1EN	T1RATE[2:0]	T1CKS	T1RSTB	T1OUT	PWM1OUT
TM1IN         EQU         38H    ;   11111111     TM1IN[7:0]
TM1CNT        EQU         39H    ;   00000000     TM1CNT[7:0]
TM1R          EQU         3AH    ;   00000000     TM1R[7:0]
LED1          EQU         3BH    ;   00000000     LED1[7:0]
LED2          EQU         3CH    ;   00000000     LED2[7:0]
LED3          EQU         3DH    ;   00000000     LED3[7:0]
LED4          EQU         3EH    ;   00000000     LED4[7:0]
LED5          EQU         3FH    ;   00000000     LED5[7:0]
LED6          EQU         40H    ;   00000000     LED6[7:0]
LED7          EQU         41H    ;   00000000     LED7[7:0]
LEDCON1       EQU         42H    ;   00000010     LED_CURRENT[2:0]	LCD_DUTY[1:0]	LEDCLKS[1:0]	LED_PMODE
LEDCON2       EQU         43H    ;   uuuuuuu0     -	LEDEN
CHPCON        EQU         44H    ;   uuu0u100     -	-	-	CHPVS	-	CHPCLKS[1:0]	CHPEN
AD2OH	      EQU         48H    ;   0uuuuu00     AD2EN - - - - - AD2O[9:8]
AD2OL         EQU         49H    ;   00000000     AD2O[7:0]
TEMPC         EQU         59H    ;   00000000     TEMPC [7:0]
RTCCON        EQU         60H    ;   0uuu0uu0     LIR	-	24hr/12hr	-	RTCEN
RTCAER        EQU         61H    ;   00000000     AER[7:0]
RTCYEAR       EQU         62H    ;   00010101     10YEAR(0~9)	1YEAR(0~9)
RTCMON        EQU         63H    ;   uuu10001     -	-	-	10MON(0~1)	1MON(0~9)
RTCDAY        EQU         64H    ;   uu000001     -	-	10DAY(0~3)	1DAT(0~9)
RTCHOUR       EQU         65H    ;   uu000001     -	-	10HOUR10(0~2)	1HOUR(0~9)
RTCMIN        EQU         66H    ;   u0000000     -	10MIN(0~5)	1MIN(0~9)
RTCSEC        EQU         67H    ;   u0000000     -	10SEC(0~5)	1SEC(0~9)
RTCDWR        EQU         68H    ;   uuuuu000     -	-	-	-	-	DWR[2:0] (0~6)
INTEGER       EQU         69H    ;   uuuu0111     				INTEGER[3:0]
FRACTION      EQU         6AH    ;   uu000000     		FRACTION
SCON1         EQU         7AH    ;   00000000     SM0	SM1	SM2	REN	TB8	RB8	UART_SEL	UARTEN
SCON2         EQU         7BH    ;   00uuuuuu     SMOD	UARTCLKS	-	-	-	-	-	-
SBUF          EQU         7CH    ;   00000000

; 80H~0FFH is Gereral Data Memory

;-------------------------------------------
; Status register bit map
;-------------------------------------------
Z       EQU     0
C       EQU     1
DC      EQU     2
TO      EQU     3
PD      EQU     4

;-------------------------------------------
; INTF Interrupt flag register bit map
;-------------------------------------------
E0IF    EQU     0
E1IF    EQU     1
ADIF    EQU     2
AD2IF   EQU     3
TM0IF   EQU     4
TM1IF   EQU     5

;-------------------------------------------
; INTE Interrupt enable register bit map
;-------------------------------------------
E0IE    EQU     0
E1IE    EQU     1
ADIE    EQU     2
AD2IE   EQU     3
TM0IE   EQU     4
TM1IE   EQU     5
GIE     EQU     7

;-------------------------------------------
; BSR register bit map
;-------------------------------------------
PAGE0    EQU     0
PAGE1    EQU     1
IRP1     EQU     6
IRP0	 EQU     7

;-------------------------------------------
; WDTCON register bit map
;-------------------------------------------
WDTS_0   EQU    0
WDTS_1   EQU    1
WDTS_2   EQU    2
WDTEN 	 EQU    7

;-------------------------------------------
; ADCON register bit map
;-------------------------------------------
ADM_0     EQU     0
ADM_1     EQU     1
ADM_2     EQU     2
ADSC      EQU     3
;-------------------------------------------
; MCK register bit map
;-------------------------------------------
M1_CK   EQU     1
M2_CK   EQU     2

;-------------------------------------------
; PCK register bit map
;-------------------------------------------
S_BEEP0  EQU    1
S_BEEP1  EQU    2

;-------------------------------------------
; NETA register bit map
;-------------------------------------------

CM_SEL    EQU    4
SINL_0    EQU    6
SINL_1    EQU    7

;-------------------------------------------
; NETC register bit map
;-------------------------------------------
ADEN     EQU     1
ADG_0    EQU     2
ADG_1    EQU     3
CHOPM_0  EQU     6
CHOPM_1  EQU     7

;-------------------------------------------
; NETE register bit map
;-------------------------------------------
LB_RST_CON	EQU	 	0
ENLB     	EQU     1
SILB_0   	EQU     2
SILB_1   	EQU     3
SILB_2   	EQU     4
LDOS_0   	EQU     6
LDOS_1   	EQU     7
;-------------------------------------------
; NETF register bit map
;-------------------------------------------
BGID0      EQU     1
BGID1      EQU     2
LDOEN      EQU     5

;-------------------------------------------
; SVD register bit map
;-------------------------------------------
LBOUT   EQU     0
;-------------------------------------------
; AIENB register bit map
;-------------------------------------------

AIENB3  EQU     7
AIENB2  EQU     4
AIENB1  EQU     3

;-------------------------------------------
; PT1CON register bit map
;-------------------------------------------
E0M_0    EQU     0
E0M_1    EQU     1
E1M_0    EQU     2
E1M_1    EQU     3
BZEN     EQU     7

;-------------------------------------------
; PTINT register bit map
;-------------------------------------------
PTW0_0    EQU     0
PTW0_1    EQU     1
PTW0_2    EQU     2
PTW1_0	  EQU     4
PTW1_1	  EQU     5
PTW1_2	  EQU     6
PTW1_3	  EQU     7

;-------------------------------------------
; INTF2 register bit map
;-------------------------------------------
URRIF    EQU     0
URTIF    EQU     1
RTCIF    EQU     3

;-------------------------------------------
; INTE2 register bit map
;-------------------------------------------
URRIE    EQU     0
URTIE    EQU     1
RTCIE    EQU     3

;-------------------------------------------
; TM0CON register bit map
;-------------------------------------------
T0SEL     EQU      0
T0RSTB    EQU      2
T0RATE_0   EQU     4
T0RATE_1   EQU     5
T0RATE_2  EQU      6
T0EN      EQU      7

;-------------------------------------------
; TM1CON register bit map
;-------------------------------------------
PWM1OUT    EQU   0
T1OUT      EQU   1
T1RSTB     EQU   2
T1CKS      EQU   3
T1RATE_0   EQU   4
T1RATE_1   EQU   5
T1RATE_2   EQU   6
T1EN       EQU   7

;-------------------------------------------
; LED1CON register bit map
;-------------------------------------------
LED_PMODE         EQU     0
LEDCLKS_0         EQU     1
LEDCLKS_1         EQU     2
LED_DUTY0         EQU     3
LED_DUTY1         EQU     4
LED_Current0      EQU     5
LED_Current1      EQU     6
LED_Current2      EQU     7

;-------------------------------------------
; LED2CON register bit map
;-------------------------------------------
LEDEN       EQU     0

;-------------------------------------------
; CHPCON register bit map
;-------------------------------------------
CHPEN         EQU    0
CHPCLKS_0     EQU    1
CHPCLKS_1     EQU    2
CHPVS         EQU    4

;-------------------------------------------
; AD2OH register bit map
AD2EN         EQU    7

;-------------------------------------------
; RTCCON register bit map
;-------------------------------------------
RTCEN   	  EQU     0
H_24_12    	  EQU     3
LIR    	      EQU     7

;-------------------------------------------
; RTCDWR register bit map
;-------------------------------------------
DWR_0  		  EQU     0
DWR_1  		  EQU     1
DWR_2 		  EQU     2

;-------------------------------------------
; SCON1 register bit map
;-------------------------------------------
UARTEN      EQU    0
RB8         EQU    2
TB8         EQU    3
REN         EQU    4
SM2         EQU    5
SM1         EQU    6
SM0         EQU    7

;-------------------------------------------
; SCON2 register bit map
;-------------------------------------------
SMOD     EQU    7

;==========================================
W        EQU    0
F        EQU    1