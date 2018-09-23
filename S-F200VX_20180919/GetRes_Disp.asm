;==================================================
;===== GetRes_Disp.ASM
;==================================================
GetRes_Disp_ENTRY:
    CALL     ClrLEDBuffer

    BTFSC    ResFlowValue,B_ResFlowValue_Done
	GOTO     GetRes_Disp_Done
	BTFSC    ResFlowValue,B_ResFlowValue_ERR
	GOTO     GetRes_Disp_ERR
	BTFSC    ResFlowValue,B_ResFlowValue_WAIT
	GOTO     GetRes_Disp_WAIT
	GOTO     GetRes_DISPLAY_Online

GetRes_Disp_WAIT:
    MOVLW    LEdcho
    BTFSC    DispRollFlow,B_DispRollFlow_0
    MOVWF    Display1
    BTFSC    DispRollFlow,B_DispRollFlow_1
    MOVWF    Display2
    BTFSC    DispRollFlow,B_DispRollFlow_2
    MOVWF    Display3
    BTFSC    DispRollFlow,B_DispRollFlow_3
    MOVWF    Display4
GetRes_Disp_WAIT_END:
    GOTO     GetRes_DISPLAY_Online
    
GetRes_Disp_Done:	
    CALL     Scale_Disp_W_ENTRY
GetRes_Disp_Done_END:	
    GOTO     GetRes_DISPLAY_Online
    
GetRes_Disp_ERR:
	MOVFL    Display1,LEdchE
	MOVFL    Display2,LEdchR
	MOVFL    Display3,LEdchR
	MOVFL    Display4,LEdchF
GetRes_Disp_ERR_END:	
    GOTO     GetRes_DISPLAY_Online	
    
GetRes_DISPLAY_Online:
	BTFSS    WifiStatus,B_WifiStatus_LINK
	GOTO     GetRes_DISPLAY_Online_end
	BSF      Display_FALG1,B_Display_FALG1_BLE
GetRes_DISPLAY_Online_end:
	
    CALL     LoadDspData  
    
GetRes_Disp_Exit: