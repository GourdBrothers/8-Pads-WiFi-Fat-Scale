;=========================================================
;====== RTC_FUN.ASM
;=========================================================

F_Delay_WR_RTC:
    MOVFL  REG0,200
F_Delay_WR_RTC_LOOP:
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    DECFSZ REG0,F
	GOTO   F_Delay_WR_RTC_LOOP
RETURN

;--- 2018.1.8 00:00:00 7 
F_RTC_Default:
  MOVFL    RTC_YEAR   , 18H
  MOVFL    RTC_MON    , 01H
  MOVFL    RTC_DAY    , 08H
  CLRF     RTC_HOUR
  CLRF     RTC_MIN
  CLRF     RTC_SEC
  MOVFL    RTC_Week   , 05H

F_RTC_SET:
  MOVFL    RTCAER , 096H  ; ENABLE WR
  CALL     F_Delay_WR_RTC
;--- COPY
  MOVFF    RTCYEAR,RTC_YEAR
  CALL     F_Delay_WR_RTC
  MOVFF    RTCMON ,RTC_MON
  CALL     F_Delay_WR_RTC
  MOVFF    RTCDAY ,RTC_DAY
  CALL     F_Delay_WR_RTC
  MOVFF    RTCHOUR,RTC_HOUR
  CALL     F_Delay_WR_RTC
  MOVFF    RTCMIN ,RTC_MIN
  CALL     F_Delay_WR_RTC
  MOVFF    RTCSEC ,RTC_SEC
  CALL     F_Delay_WR_RTC
  MOVFF    RTCDWR ,RTC_Week
  CALL     F_Delay_WR_RTC
;---
  BSF      RTCCON , RTCEN
  CALL     F_Delay_WR_RTC
  MOVFL    RTCAER ,000H    ; Disable WR
  CALL     F_Delay_WR_RTC
  BSF      INTE2,RTCIE
RETURN

F_RTC_READ:
  MOVFF    RTC_YEAR  , RTCYEAR      ; RTC
  MOVFF    RTC_MON   , RTCMON
  MOVFF    RTC_DAY   , RTCDAY
  MOVFF    RTC_HOUR  , RTCHOUR
  MOVFF    RTC_MIN   , RTCMIN
  MOVFF    RTC_SEC   , RTCSEC
  MOVFF    RTC_Week  , RTCDWR
RETURN
