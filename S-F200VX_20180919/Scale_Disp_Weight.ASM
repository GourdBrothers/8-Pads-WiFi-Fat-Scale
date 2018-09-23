;============================================================
;====  Scale_Disp_weight.ASM
;============================================================

Scale_Disp_W_ENTRY:
    CLRF    TempRam4
    MOVFF   TempRam5,CountH
    MOVFF   TempRam6,CountL

Scale_Disp_Load_Send:
	MOVFF   SendCount_H,CountH
	MOVFF   SendCount_L,CountL
	BTFSS	SysFlag4,B_SysFlag4_Lock
	GOTO    Scale_Disp_Load_Send_END
	MOVFF   SendCount_H,LockCountH
	MOVFF   SendCount_L,LockCountL
Scale_Disp_Load_Send_END:

    BTFSS	SysFlag4,B_SysFlag4_Lock
    GOTO	Scale_Disp_W_0
	
Scale_Disp_W_LOCK:
    MOVFF	TempRam5,LockCountH
    MOVFF	TempRam6,LockCountL
	
    BTFSS	SysFlag2,B_SysFlag2_Glint
    GOTO	Scale_Disp_W_EXIT
	
Scale_Disp_W_0:
	BCF     SysFlag5,B_SysFlag5_Up100kg
    MOVLW   LOW  2000
    SUBWF   TempRam6,W
    MOVLW   HIGH 2000
    SUBWFC  TempRam5,W
    BTFSC   STATUS,C
    BSF     SysFlag5,B_SysFlag5_Up100kg
;---
    CLRF    TempRam11
    CLRF    TempRam12
    MOVFL   TempRam13,05H
    CALL    _Mul3_3
;---
    BTFSC	UnitFlag,KgFlag
	GOTO    Scale_Disp_W_KG
;	BTFSC   UnitFlag,SJFlag
;	GOTO    Scale_Disp_W_SJ
	BTFSC	UnitFlag,LbFlag
	GOTO    Scale_Disp_W_LB
;	BTFSC	UnitFlag,STFlag
;	GOTO    Scale_Disp_W_ST
	CLRF    UnitFlag
    BSF     UnitFlag,KgFlag

Scale_Disp_W_KG:
    CLRF    TempRam11
    MOVFF   TempRam12,TempRam5
    MOVFF   TempRam13,TempRam6
    CALL    F_HexToBcd
    BTFSC   SysFlag5,B_SysFlag5_Up100kg
    GOTO    Scale_Disp_W_KG_Up100kg
    CALL    Display_Num
    BSF     Display2,B_Display2_P2
    GOTO    Scale_Disp_W_KG_END
Scale_Disp_W_KG_Up100kg:
	CALL    Scale_Disp_CLR
	BSF     Display3,B_Display3_P1
Scale_Disp_W_KG_END:
    BSF     Display_FALG1,B_Display_FALG1_KG
    GOTO    Scale_Disp_W_EXIT
    
    
Scale_Disp_W_LB:
	CALL    F_CountKgToLb
    CLRF    TempRam11
    MOVFF   TempRam12,TempRam5
    MOVFF   TempRam13,TempRam6
    CALL    F_HexToBcd
    CALL    Display_Num
Scale_Disp_W_LB_char:
	BSF     Display_FALG1,B_Display_FALG1_SJ
	BSF     Display3,B_Display3_P1
Scale_Disp_W_LB_END:
	GOTO    Scale_Disp_W_EXIT

Scale_Disp_W_SJ:
	CLRF    TempRam11
    MOVFF   TempRam12,TempRam5
    MOVFF   TempRam13,TempRam6
    BCF     STATUS,C
    RLF     TempRam13,F
    RLF     TempRam12,F
    RLF     TempRam11,F
    CALL    F_HexToBcd
;---
    CALL    Scale_Disp_CLR
Scale_Disp_SJ_UNIT:
    BSF     Display_FALG1,B_Display_FALG1_SJ 
    BSF     Display3,B_Display3_P1
Scale_Disp_W_SJ_END:	
	GOTO    Scale_Disp_W_EXIT

Scale_Disp_W_EXIT:
RETURN




