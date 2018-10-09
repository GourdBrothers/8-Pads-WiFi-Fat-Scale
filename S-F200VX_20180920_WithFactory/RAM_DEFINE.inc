;=====================================================
;======= RAM_DEFINE.INC
;=====================================================
    buffer0		     EQU	  080H                        ; for math ,Temporary data
    buffer1		     EQU	  buffer0   + 1
    buffer2		     EQU	  buffer1   + 1
    buffer3		     EQU	  buffer2   + 1
    buffer4		     EQU	  buffer3   + 1
    buffer5		     EQU	  buffer4   + 1
    buffer6		     EQU	  buffer5   + 1

    TempRam1	     EQU	  buffer6   + 1
    TempRam2	     EQU	  TempRam1  + 1
    TempRam3	     EQU	  TempRam2  + 1
    TempRam4	     EQU	  TempRam3  + 1
    TempRam5	     EQU	  TempRam4  + 1
    TempRam6	     EQU	  TempRam5  + 1
    TempRam11	     EQU	  TempRam6  + 1
    TempRam12	     EQU	  TempRam11 + 1
    TempRam13	     EQU	  TempRam12 + 1

	ISR_WORK_BACK    EQU      TempRam13       + 1        ; for interrupt Site protection
	ISR_STATUS_BACK  EQU      ISR_WORK_BACK   + 1
	ISR_BSR_BACK     EQU      ISR_STATUS_BACK + 1
	ISR_FSR0_BACK    EQU      ISR_BSR_BACK    + 1
	ISR_FSR1_BACK    EQU      ISR_FSR0_BACK   + 1
	
	
    R_LED_COUNT      EQU      ISR_FSR1_BACK   + 1       ; for diaplay
    R_LED_DUTY       EQU      R_LED_COUNT     + 1
    R_LED_LIGHT      EQU      R_LED_DUTY      + 1
	R_LED_1          EQU      R_LED_LIGHT     + 1
	R_LED_2          EQU      R_LED_1         + 1
	R_LED_3          EQU      R_LED_2         + 1
	R_LED_4          EQU      R_LED_3         + 1
	R_LED_5          EQU      R_LED_4         + 1
	R_LED_6          EQU      R_LED_5         + 1
	R_LED_7          EQU      R_LED_6         + 1
	
	Display_FALG1           EQU  R_LED_7      + 1
     B_Display_FALG1_BAT    EQU  0
	 B_Display_FALG1_BLE    EQU  1
	 B_Display_FALG1_SJ     EQU  2    ; SJ LB
	 B_Display_FALG1_KG     EQU  3
	 B_Display_FALG1_P3     EQU  4
	
	Display4                EQU  Display_FALG1      + 1
      B_Display4_F          EQU  0
	  B_Display4_G          EQU  1
	  B_Display4_E          EQU  2
	  B_Display4_D          EQU  3
	  B_Display4_A          EQU  4
	  B_Display4_B          EQU  5
	  B_Display4_C          EQU  6
	Display3                EQU  Display4      + 1
	  B_Display3_F          EQU  0
	  B_Display3_G          EQU  1
	  B_Display3_E          EQU  2
	  B_Display3_D          EQU  3
	  B_Display3_A          EQU  4
	  B_Display3_B          EQU  5
	  B_Display3_C          EQU  6
	  B_Display3_P1          EQU  7
	Display2                EQU  Display3      + 1
	  B_Display2_F          EQU  0
	  B_Display2_G          EQU  1
	  B_Display2_E          EQU  2
	  B_Display2_D          EQU  3
	  B_Display2_A          EQU  4
	  B_Display2_B          EQU  5
	  B_Display2_C          EQU  6
	  B_Display2_P2         EQU  7
	Display1                EQU  Display2     + 1
	  B_Display1_F          EQU  0
	  B_Display1_G          EQU  1
	  B_Display1_E          EQU  2
	  B_Display1_D          EQU  3
	  B_Display1_A          EQU  4
	  B_Display1_B          EQU  5
	  B_Display1_C          EQU  6


    H_DR          EQU	Display1 + 1  ; for ADC Buf
    M_DR          EQU	H_DR          + 1
    L_DR          EQU	M_DR          + 1
	
    H_DRBuf       EQU	L_DR          + 1
    M_DRBuf       EQU	H_DRBuf       + 1
    L_DRBuf       EQU	M_DRBuf       + 1
	
    H_DATA        EQU	L_DRBuf       + 1
    M_DATA        EQU	H_DATA        + 1
    L_DATA        EQU	M_DATA        + 1
	
    H_DATAA       EQU	L_DATA        + 1
    M_DATAA       EQU	H_DATAA       + 1
    L_DATAA       EQU	M_DATAA       + 1
	
    H_DATAB       EQU	L_DATAA       + 1
    M_DATAB       EQU	H_DATAB       + 1
    L_DATAB       EQU	M_DATAB       + 1
	
    H_DATAC       EQU	L_DATAB       + 1
    M_DATAC       EQU	H_DATAC       + 1
    L_DATAC       EQU	M_DATAC       + 1

    ADRamH        EQU   L_DATAC       + 1
    ADRamM        EQU   ADRamH        + 1
    ADRamL        EQU   ADRamM        + 1

    AD_Temp0      EQU   ADRamL        + 1
    AD_Temp1      EQU   AD_Temp0      + 1
    AD_Temp2      EQU   AD_Temp1      + 1
    AD_Temp3      EQU   AD_Temp2      + 1

    AdcCount      EQU   AD_Temp3      + 1
    SampleTimes   EQU   AdcCount      + 1
    AdcTrend      EQU   SampleTimes   + 1

    StableCount   EQU   AdcTrend      + 1
    TrackCount    EQU   StableCount   + 1

    CountH        EQU   TrackCount    + 1
    CountL        EQU   CountH        + 1
	CalCountH     EQU   CountL        + 1
	CalCountL     EQU   CalCountH     + 1
    CalConstH     EQU   CalCountL     + 1
    CalConstL     EQU   CalConstH     + 1

    MaxCountH     EQU   CalConstL     + 1  ; Scale Param
    MaxCountL     EQU   MaxCountH     + 1
    CalDot1H      EQU   MaxCountL     + 1  ; FOR Cal
    CalDot1L      EQU   CalDot1H      + 1
    CalDot2H      EQU   CalDot1L      + 1
    CalDot2L      EQU   CalDot2H      + 1
    CalDot3H      EQU   CalDot2L      + 1
    CalDot3L      EQU   CalDot3H      + 1
	Cal_MARK      EQU   CalDot3L      + 1
	
    SysFlag1                    EQU	 Cal_MARK + 1    ; for falgs
       B_SysFlag1_AdcStart      EQU  0
       B_SysFlag1_AdcOk         EQU  1
       B_SysFlag1_DataOk        EQU  2
       B_SysFlag1_Steady        EQU  3
       B_SysFlag1_Zero          EQU  4
       B_SysFlag1_Neg           EQU  5

    SysFlag2                    EQU	 SysFlag1 + 1
       B_SysFlag2_TF_01A        EQU	 0
       B_SysFlag2_TF_01B        EQU	 1
       B_SysFlag2_TF_05A        EQU	 2
       B_SysFlag2_TF_05B        EQU	 3
       B_SysFlag2_GlintEn       EQU	 4
       B_SysFlag2_Glint         EQU	 5
	   B_SysFlag2_CalOK         EQU  7
       GlintFlagCom	            EQU	 00100000B

    SysFlag3                    EQU	 SysFlag2 + 1
       B_SysFlag3_DspNeg        EQU  0
       B_SysFlag3_KScan         EQU  1
       B_SysFlag3_DspCal        EQU  2
       B_SysFlag3_TRG_CAL       EQU  3
       B_SysFlag3_WaitSleep     EQU  4
       B_SysFlag3_FastSleep     EQU  5
       B_SysFlag3_10MS          EQU  6

    SysFlag4                    EQU  SysFlag3     + 1
       B_SysFlag4_Lock          EQU  0
       B_SysFlag4_OverLoad      EQU  2
       B_SysFlag4_UnStable      EQU  3
       B_SysFlag4_UnLockEn      EQU  4
	   B_SysFlag4_FlashDone     EQU  5
	   B_SysFlag4_DataDone      EQU  6

    SysFlag5                    EQU  SysFlag4     + 1
       B_SysFlag5_WdtProcAD     EQU  0
       B_SysFlag5_WdtTrackB     EQU  1
       B_SysFlag5_WdtTrackS     EQU  2
       B_SysFlag5_Null          EQU  3
       B_SysFlag5_Up100kg       EQU  4

    Wifi_SmartCfg               EQU  SysFlag5      + 1
      B_Wifi_SmartCfg_EN        EQU  0
      B_Wifi_SmartCfg_Ack       EQU  1
      B_Wifi_SmartCfg_Flash     EQU  2
      B_Wifi_SmartCfg_T         EQU  3
    Wifi_SmartCfgTimer          EQU  Wifi_SmartCfg + 1
       
    UnitFlag 	         EQU	Wifi_SmartCfgTimer + 1
       KgFlag		     EQU	0
       LbFlag		     EQU	1
       STFlag		     EQU	2
       SJFlag            EQU	1
	   Unit_MAX          EQU    004H

    DownADH              EQU    UnitFlag  +  1    ; FOR AUTO ON
    DownADM              EQU    DownADH   +  1
    DownADL              EQU    DownADM   +  1

    AutoOnADH            EQU    DownADL   +  1
    AutoOnADM            EQU    AutoOnADH +  1
    AutoOnADL            EQU    AutoOnADM +  1

    AutoOnCH             EQU    AutoOnADL +  1
    AutoOnCM             EQU    AutoOnCH  +  1
    AutoOnCL             EQU    AutoOnCM  +  1

    ZeroH                EQU    AutoOnCL  +  1
    ZeroM                EQU    ZeroH     +  1
    ZeroL                EQU    ZeroM     +  1

    LockCountH           EQU    ZeroL         +  1
    LockCountL           EQU    LockCountH    +  1

    Wakeup_Flags         EQU    LockCountL    +  1
        OnWeightFlag         EQU    0
        WakenOn_Flag         EQU    1
        B_WakenOn_INT0       EQU    2
        B_WakenOn_RTC        EQU    3
        B_WakenOn_Cal_mode   EQU    4
        B_WakenOn_RST_On     EQU    5      

	MainFlowValue           EQU  Wakeup_Flags  + 1      ; For system flows
	  B_MainFlow_PowerOn    EQU  0
	  B_MainFlow_Scale      EQU  1
	  B_MainFlow_GetRes     EQU  2
	  B_MainFlow_Factory    EQU  3

	ScaleFlowValue          EQU  MainFlowValue + 1    ; For Scale flow
	  B_ScaleFlow_INIT      EQU  0
	  B_ScaleFlow_ZERO      EQU  1
	  B_ScaleFlow_Weight    EQU  2
	  B_ScaleFlow_CAL       EQU  3
	  B_ScaleFlow_TrgCal    EQU  4
	  B_ScaleFlow_SLEEP     EQU  5

	CalFlowValue            EQU  ScaleFlowValue  + 1       ; For Scale cal Flow
	  B_CalFlow_ADC         EQU  0
	  B_CalFlow_ZERO        EQU  1
	  B_CalFlow_DOT1        EQU  2
	  B_CalFlow_DOT2        EQU  3
	  B_CalFlow_DOT3        EQU  4
	  B_CalFlow_PASS        EQU  5

	ResFlowValue            EQU  CalFlowValue
	  B_ResFlowValue_INIT   EQU  0
	  B_ResFlowValue_WAIT   EQU  1
	  B_ResFlowValue_Done   EQU  2
	  B_ResFlowValue_ERR    EQU  3
	  B_ResFlowValue_EXIT   EQU  4

    FactoryFlowValue            EQU  CalFlowValue
      B_FactoryFlowValue_INIT   EQU  0
      B_FactoryFlowValue_WAIT   EQU  1
      B_FactoryFlowValue_ADC    EQU  2
      B_FactoryFlowValue_CMDCC  EQU  3
      B_FactoryFlowValue_ChkLo  EQU  4
      B_FactoryFlowValue_PASS   EQU  5
      B_FactoryFlowValue_ERR    EQU  6
      
    
;===================================================
;==== RAM PAGE0
    RTC_Base           EQU   0100H                 ; FOR RTC
	RTC_YEAR           EQU   RTC_Base   + 1
	RTC_MON            EQU   RTC_YEAR   + 1
	RTC_DAY            EQU   RTC_MON    + 1
	RTC_HOUR           EQU   RTC_DAY    + 1
	RTC_MIN            EQU   RTC_HOUR   + 1
	RTC_SEC            EQU   RTC_MIN    + 1
	RTC_Week           EQU   RTC_SEC    + 1
	
    FlyLink_Flag       EQU   RTC_Week   + 1 
      B_FlyLink_Flag_En EQU  0
	
	
	USER_CountH        EQU   FlyLink_Flag+ 1        ; FOR USER INFO
	USER_CountL        EQU   USER_CountH + 1
	USER_Height        EQU   USER_CountL + 1
	USER_SexAge        EQU   USER_Height + 1
	USER_Style         EQU   USER_SexAge + 1

	USER_RZ_H          EQU   USER_Style  + 1
	USER_RZ_L          EQU   USER_RZ_H   + 1
	USER_R1_H          EQU   USER_RZ_L   + 1
	USER_R1_L          EQU   USER_R1_H   + 1
	USER_R2_H          EQU   USER_R1_L   + 1
	USER_R2_L          EQU   USER_R2_H   + 1
	USER_R3_H          EQU   USER_R2_L   + 1
	USER_R3_L          EQU   USER_R3_H   + 1
	USER_R4_H          EQU   USER_R3_L   + 1
	USER_R4_L          EQU   USER_R4_H   + 1
	USER_R5_H          EQU   USER_R4_L   + 1
	USER_R5_L          EQU   USER_R5_H   + 1

	UART_RX_BUF        EQU   USER_R5_L   + 1

    REG0                 EQU	UART_RX_BUF   + 1  ;
    REG1                 EQU	REG0          + 1
    REG2                 EQU	REG1          + 1
    REG3                 EQU	REG2          + 1

    T_Auto_Off           EQU    REG3          + 1
    LockFlashBase        EQU    T_Auto_Off    + 1
    LockFlashCnt         EQU    LockFlashBase + 1
    TBASE05S             EQU    LockFlashCnt  + 1
    AutoOnCnt            EQU    TBASE05S      + 1
    TimerCal             EQU    AutoOnCnt     + 1
    NoSteadyCount        EQU    TimerCal      + 1

    SendCount_H          EQU    NoSteadyCount + 1
    SendCount_L          EQU    SendCount_H   + 1

    Key_Timer            EQU    SendCount_L   + 1
    Key_CODE             EQU    Key_Timer     + 1
    Key_CNT              EQU    Key_CODE      + 1
    Key_TRG              EQU    Key_CNT       + 1
      B_key_Unit         EQU    3

    BIE_ADDR             EQU    Key_TRG       + 1
    BIE_BYTE             EQU    BIE_ADDR      + 1
 
	BatFlag              EQU    BIE_BYTE      + 1   ; For bat Check
	  B_BatFlag_Low      EQU    0
	  B_BatFlag_ADC_OK   EQU    1
	  B_BatFlag_CHK      EQU    2
	  B_BatFlag_ICON     EQU    3
	BAT_LO_CNT           EQU    BatFlag       + 1
	BAT_VAL_H            EQU    BAT_LO_CNT    + 1
	BAT_VAL_L            EQU    BAT_VAL_H     + 1
	BAT_VoltageH         EQU    BAT_VAL_L     + 1
	BAT_VoltageL         EQU    BAT_VoltageH  + 1
     
WifiStatus                    EQU  BAT_VoltageL + 1
  B_WifiStatus_4or8           EQU  0
  B_WifiStatus_Test125X       EQU  1
  B_WifiStatus_LINK           EQU  2
  B_WifiStatus_Smartcfg       EQU  3
  B_WifiStatus_NetCfg         EQU  4
  B_WifiStatus_DataOK         EQU  5
  B_WifiStatus_PcbaTEST       EQU  6
  B_WifiStatus_OTA            EQU  7

WifiSysStatus                 EQU  WifiStatus + 1
  B_WifiSysStatus_HEAT        EQU  0
  B_WifiSysStatus_Encryption  EQU  1
  B_WifiSysStatus_PcbaTest    EQU  2
  B_WifiSysStatus_WifiTesting EQU  3
  B_WifiSysStatus_WifiTestErr EQU  4
  B_WifiSysStatus_125xTesting EQU  5
  B_WifiSysStatus_125xTestErr EQU  6

WifiPwrCnt                    EQU  WifiSysStatus + 1

UartRxFlag         EQU   WifiPwrCnt     + 1   ; FOR UART RX
  B_UartRxFlag_OK  EQU   0 
  B_UartRxFlag_L   EQU   1
  B_UartRxFlag_D   EQU   2
  B_UartRxFlag_C6  EQU   3
  B_UartRxFlag_TRG EQU   4
R_UartRxCnt        EQU   UartRxFlag     + 1
R_UartRXTimer      EQU   R_UartRxCnt    + 1

UART_RX0           EQU   R_UartRXTimer  + 1
UART_RX1           EQU   UART_RX0       + 1
UART_RX2           EQU   UART_RX1       + 1
UART_RX3           EQU   UART_RX2       + 1
UART_RX4           EQU   UART_RX3       + 1
UART_RX5           EQU   UART_RX4       + 1
UART_RX6           EQU   UART_RX5       + 1
UART_RX7           EQU   UART_RX6       + 1
UART_RX8           EQU   UART_RX7       + 1
UART_RX9           EQU   UART_RX8       + 1
UART_RX10          EQU   UART_RX9       + 1
UART_RX11          EQU   UART_RX10      + 1
UART_RX12          EQU   UART_RX11      + 1
UART_RX13          EQU   UART_RX12      + 1
UART_RX14          EQU   UART_RX13      + 1
UART_RX15          EQU   UART_RX14      + 1
UART_RX16          EQU   UART_RX15      + 1
UART_RX17          EQU   UART_RX16      + 1
UART_RX18          EQU   UART_RX17      + 1
UART_RX19          EQU   UART_RX18      + 1
UART_RX20          EQU   UART_RX19      + 1

UART_TX_EVENT  EQU   UART_RX20 + 1              ; FOR UART TX
	B_UART_TX_EVENT_unlock   EQU  0
	B_UART_TX_EVENT_lock     EQU  1
	B_UART_TX_EVENT_CFG      EQU  2
	B_UART_TX_EVENT_ACK      EQU  3
	B_UART_TX_EVENT_Final    EQU  4
	B_UART_TX_EVENT_WifiTest EQU  5
	
UART_TX0       EQU   UART_TX_EVENT +1
UART_TX1       EQU   UART_TX0  + 1
UART_TX2       EQU   UART_TX1  + 1
UART_TX3       EQU   UART_TX2  + 1   
UART_TX4       EQU   UART_TX3  + 1
UART_TX5       EQU   UART_TX4  + 1
UART_TX6       EQU   UART_TX5  + 1
UART_TX7       EQU   UART_TX6  + 1
UART_TX8       EQU   UART_TX7  + 1
UART_TX9       EQU   UART_TX8  + 1
UART_TX10      EQU   UART_TX9  + 1
UART_TX11      EQU   UART_TX10 + 1
UART_TX12      EQU   UART_TX11 + 1
UART_TX13      EQU   UART_TX12 + 1
UART_TX14      EQU   UART_TX13 + 1
UART_TX15      EQU   UART_TX14 + 1
UART_TX16      EQU   UART_TX15 + 1
UART_TX17      EQU   UART_TX16 + 1
UART_TX18      EQU   UART_TX17 + 1
UART_TX19      EQU   UART_TX18 + 1
UART_TX20      EQU   UART_TX19 + 1
UART_TX21      EQU   UART_TX20 + 1
UART_TX22      EQU   UART_TX21 + 1
UART_TX23      EQU   UART_TX22 + 1
UART_TX24      EQU   UART_TX23 + 1
UART_TX25      EQU   UART_TX24 + 1
UART_TX26      EQU   UART_TX25 + 1
UART_TX27      EQU   UART_TX26 + 1
UART_TX28      EQU   UART_TX27 + 1
UART_TX29      EQU   UART_TX28 + 1
UART_TX30      EQU   UART_TX29 + 1
UART_TX31      EQU   UART_TX30 + 1
UART_TX32      EQU   UART_TX31 + 1
UART_ACK       EQU   UART_TX32 + 1

	W_CAL_ADC_H          EQU    UART_ACK      + 1   ; For Weight Cal
	W_CAL_ADC_L          EQU    W_CAL_ADC_H   + 1
	W_CAL1_ADC_H         EQU    W_CAL_ADC_L   + 1
	W_CAL1_ADC_L         EQU    W_CAL1_ADC_H  + 1
	W_CAL2_ADC_H         EQU    W_CAL1_ADC_L  + 1
	W_CAL2_ADC_L         EQU    W_CAL2_ADC_H  + 1
	W_CAL3_ADC_H         EQU    W_CAL2_ADC_L  + 1
	W_CAL3_ADC_L         EQU    W_CAL3_ADC_H  + 1
    W_CAL_Flag           EQU    W_CAL3_ADC_L  + 1
      B_W_CAL_Flag_EN    EQU    0
      B_W_CAL_Flag_1     EQU    1
      B_W_CAL_Flag_2     EQU    2
      B_W_CAL_Flag_3     EQU    3
      B_W_CAL_Flag_PASS  EQU    4
      B_W_CAL_Flag_TRG   EQU    5
      B_W_CAL_Flag_LOCK  EQU    6
      
      
    Fac_TimeOff           EQU    W_CAL_Flag     + 1   ; FOR factory
    Fac_RtcChk_Cnt        EQU    Fac_TimeOff    + 1
    Fac_RcRef_Cnt         EQU    Fac_RtcChk_Cnt + 1
    Fac_ErrCode           EQU    Fac_RcRef_Cnt  + 1
      B_Fac_ErrCode_RTC   EQU    0
      B_Fac_ErrCode_UART  EQU    1
      B_Fac_ErrCode_RES   EQU    2
      B_Fac_ErrCode_WIFI  EQU    3
      B_Fac_ErrCode_LO    EQU    4
    Fac_RX_RecvFlag       EQU    Fac_ErrCode     + 1
      B_Fac_RX_RecvFlag_CmdCC_OK  EQU   0
      B_Fac_RX_RecvFlag_WiFi_OK   EQU   1
      B_Fac_RX_RecvFlag_CS1258_OK EQU   2
    Fac_ErrNum            EQU    Fac_RX_RecvFlag + 1

;-----------------------------------------------------------------------------


;------------------------------------------------------------------------------
UART_TX_SOP  EQU  UART_TX0
UART_TX_LEN  EQU  UART_TX1
UART_TX_CMD  EQU  UART_TX2

UART_RX_SOP  EQU  UART_RX0
UART_RX_LEN  EQU  UART_RX1
UART_RX_CMD  EQU  UART_RX2
    
DispRollCnt  EQU    LockFlashBase
DispRollFlow EQU    LockFlashCnt
  B_DispRollFlow_0 EQU 0
  B_DispRollFlow_1 EQU 1
  B_DispRollFlow_2 EQU 2
  B_DispRollFlow_3 EQU 3
                   
    
                             
    
    
    