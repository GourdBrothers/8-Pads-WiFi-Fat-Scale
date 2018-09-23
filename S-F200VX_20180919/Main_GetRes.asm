;=======================================================================
;==== Main_GetRes.asm
;=======================================================================
Main_GetRes_Entry:
	
Main_GetRes_Timeout:
	BTFSS    SysFlag2,B_SysFlag2_TF_05B
	GOTO     Main_GetRes_Timeout_END
	INCF     T_Auto_Off,F
;---
	MOVLW    60
	SUBWF    T_Auto_Off,W
	BTFSS    STATUS,C
	GOTO     Main_GetRes_Timeout_END
	CLRF     T_Auto_Off
	CLRF     ResFlowValue
	BSF      ResFlowValue,B_ResFlowValue_EXIT
Main_GetRes_Timeout_END:

;--- Check Weight down
Main_GetRes_ChkWeight:
    BTFSS    SysFlag1,B_SysFlag1_DataOk
    GOTO     Main_GetRes_ChkWeight_End
    CALL     _GetCount
	MOVLW    60
    SUBWF    COUNTL,W
	MOVLW    00H
	SUBWFC   COUNTH,W
	BTFSS    STATUS,C
	GOTO     Main_GetRes_ChkWeight_Down
Main_GetRes_ChkWeight_UP:
	BTFSS    ResFlowValue,B_ResFlowValue_Done
	GOTO     Main_GetRes_ChkWeight_End
	BTFSC    Wakeup_Flags,OnWeightFlag
    GOTO     Main_GetRes_ChkWeight_End
	GOTO     Main_GetRes_TO_Weight
;---
Main_GetRes_ChkWeight_Down:
	CLRF     COUNTH
	CLRF     COUNTL
	BCF      Wakeup_Flags,OnWeightFlag
;---
	BTFSC    ResFlowValue,B_ResFlowValue_WAIT
	GOTO     Main_GetRes_TO_Weight
	BTFSC    ResFlowValue,B_ResFlowValue_Done
	GOTO     Main_GetRes_TO_ZERO
	GOTO     Main_GetRes_ChkWeight_End
;--- BACK TO WEIGHT 
Main_GetRes_TO_Weight:
	CLRF     MainFlowValue
	BSF      MainFlowValue,B_MainFlow_Scale
	CLRF     ScaleFlowValue
	BSF      ScaleFlowValue,B_ScaleFlow_WEIGHT
	CLRF     T_Auto_Off
	BCF      SysFlag4,B_SysFlag4_Lock
	GOTO     Main_GetRes_ChkWeight_End
Main_GetRes_TO_ZERO:
	BTFSS    SysFlag1,B_SysFlag1_Steady
	GOTO     Main_GetRes_ChkWeight_End
    CALL	 F_GetZeroPoint
    CALL	 F_GetAutoOnADC
    CALL     F_GetAutoDownADC
Main_GetRes_ChkWeight_End:

;---
Main_GetRes_Flow:
	BTFSC    ResFlowValue,B_ResFlowValue_INIT
	GOTO     Main_GetRes_Init
	BTFSC    ResFlowValue,B_ResFlowValue_WAIT
	GOTO     Main_GetRes_Wait
	BTFSC    ResFlowValue,B_ResFlowValue_Done
	GOTO     Main_GetRes_Done
	BTFSC    ResFlowValue,B_ResFlowValue_ERR
	GOTO     Main_GetRes_Err
	BTFSC    ResFlowValue,B_ResFlowValue_EXIT
	GOTO     Main_GetRes_Exit
	CLRF     ResFlowValue

Main_GetRes_Init:
;--- NEXT FLOW
	CLRF     T_Auto_Off
	CALL     F_Clr_Timer05S
	CLRF     ResFlowValue
	BSF      ResFlowValue,B_ResFlowValue_WAIT
Main_GetRes_Init_END:
	GOTO     Main_GetRes_Flow_END

Main_GetRes_Wait:
;--- Disp roll Handle
Main_GetRes_ROLL:
	CLRF     REG0
	BTFSS    SysFlag2,B_SysFlag2_TF_05B
	GOTO     Main_GetRes_ROLL_END
	BCF      STATUS,C
	RLF      DispRollFlow,F
	MOVLW    010H
	SUBWF    DispRollFlow,W
	BTFSS    STATUS,C
	GOTO     Main_GetRes_ROLL_END
	CLRF     DispRollFlow
	BSF      DispRollFlow,B_DispRollFlow_0
	BSF      REG0,0
Main_GetRes_ROLL_END:
;---
	BTFSS    WifiStatus,B_WifiStatus_Test125X
	GOTO     Main_GetRes_Send
	BTFSS    REG0,0
	GOTO     Main_GetRes_STATUS_END
;--- Data IS RADY
Main_GetRes_STATUS_OK:
	CLRF     T_Auto_Off
	CALL     F_Clr_Timer05S
	CLRF     ResFlowValue
	BSF      ResFlowValue,B_ResFlowValue_Done
;--- Everything is ok, send data
Main_GetRes_Send:
	BTFSC    SysFlag2,B_SysFlag2_TF_05B
	BSF      UART_TX_EVENT,B_UART_TX_EVENT_Final
Main_GetRes_STATUS_END:
;---
Main_GetRes_Wait_END:
	GOTO     Main_GetRes_Flow_END

Main_GetRes_Done:
	MOVLW    8
	SUBWF    T_Auto_Off,W
	BTFSS    STATUS,C
	GOTO     Main_GetRes_Done_END
	CLRF     ResFlowValue
    BSF      ResFlowValue,B_ResFlowValue_EXIT
Main_GetRes_Done_END:
	GOTO     Main_GetRes_Flow_END

Main_GetRes_Err:
	MOVLW    6
	SUBWF    T_Auto_Off,W
	BTFSS    STATUS,C
	GOTO     Main_GetRes_Err_END
	CLRF     ResFlowValue
    BSF      ResFlowValue,B_ResFlowValue_EXIT
Main_GetRes_Err_END:
	GOTO     Main_GetRes_Flow_END

Main_GetRes_Exit:
	CLRF     MainFlowValue
	BSF      MainFlowValue,B_MainFlow_Scale
	CLRF     T_Auto_Off
	CLRF     ScaleFlowValue
	BSF      ScaleFlowValue,B_ScaleFlow_SLEEP
    NOP
Main_GetRes_Flow_END:
;---

Main_GetRes_Disp:
	INCLUDE  GetRes_Disp.ASM
Main_GetRes_Disp_END:
	
Main_GetRes_End:
	
	