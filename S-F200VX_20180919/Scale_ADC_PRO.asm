 ;===================================================
 ;===  Scale_ADC_PRO.ASM
 ;===================================================
_ProcAdc:
		MOVFF		TempRam1,H_DR
		MOVFF		TempRam2,M_DR
		MOVFF		TempRam3,L_DR
		MOVFF		TempRam4,H_DATA
		MOVFF		TempRam5,M_DATA
		MOVFF		TempRam6,L_DATA
		CALL		_Sub3_3
		CALL		_Neg3

		CLRF		TempRam4
		CLRF		TempRam5
		MOVLW       20
		MOVWF		TempRam6
		CALL		_Sub3_3
		BTFSC		STATUS, C
		GOTO		Proc_Adc1
		CLRF        AdcTrend
_ProcAdc0:
		MOVFF		TempRam11,H_DATAC
		MOVFF		TempRam12,M_DATAC
		MOVFF		TempRam13,L_DATAC 

		MOVFW		L_DATAB
		MOVWF		L_DATAC
		ADDWF		TempRam13, F

		MOVFW		M_DATAB
		MOVWF		M_DATAC
		ADDWFC		TempRam12, F

		MOVFW		H_DATAB
		MOVWF		H_DATAC
		ADDWFC		TempRam11, F
;------------------------------------------------		
		MOVFW		L_DATAA
		MOVWF		L_DATAB
		ADDWF		TempRam13, F

		MOVFW		M_DATAA
		MOVWF		M_DATAB
		ADDWFC		TempRam12, F

		MOVFW		H_DATAA
		MOVWF		H_DATAB
		ADDWFC		TempRam11, F
;------------------------------------------------		
		MOVFW		L_DATA
		MOVWF		L_DATAA
		ADDWF		TempRam13, F

		MOVFW		M_DATA
		MOVWF		M_DATAA
		ADDWFC		TempRam12, F

		MOVFW		H_DATA
		MOVWF		H_DATAA
		ADDWFC		TempRam11, F

		BCF		    STATUS,C
		RRF		    TempRam11, F
		RRF		    TempRam12, F
		RRF		    TempRam13, F

		BCF		    STATUS,C
		RRF		    TempRam11, F
		RRF		    TempRam12, F
		RRF		    TempRam13, F

		MOVFF		H_DR,TempRam11
		MOVFF		M_DR,TempRam12
		MOVFF		L_DR,TempRam13
		GOTO		Proc_Adc2

;------------------------------------------------
Proc_Adc1:
	    INCF        AdcTrend,F
	    MOVLW       02H
	    SUBWF       AdcTrend,W
	    BTFSS       STATUS,C
	    GOTO        ProcAdc_End
	    DECF        AdcTrend,F
	
		MOVFW		H_DATA
		MOVWF		H_DR
		MOVWF		H_DATAA
		MOVWF		H_DATAB
		MOVWF		H_DATAC

		MOVFW		M_DATA
		MOVWF		M_DR
		MOVWF		M_DATAA
		MOVWF		M_DATAB
		MOVWF		M_DATAC

		MOVFW		L_DATA
		MOVWF		L_DR
		MOVWF		L_DATAA
		MOVWF		L_DATAB
		MOVWF		L_DATAC

;------------------------------------------------
Proc_Adc2:
		MOVFF		TempRam4,H_DRBuf		
		MOVFF		TempRam5,M_DRBuf
		MOVFF		TempRam6,L_DRBuf

		MOVFW		H_DR
		MOVWF		H_DRBuf
		MOVWF		TempRam1

		MOVFW		M_DR
		MOVWF		M_DRBuf
		MOVWF		TempRam2

		MOVFW		L_DR
		MOVWF		L_DRBuf
		MOVWF		TempRam3

		CALL		_Sub3_3
		CALL		_Neg3

		CLRF		TempRam4
		CLRF		TempRam5
		MOVLW       004H
		MOVWF       TempRam6
		CALL		_Sub3_3
		BTFSC		STATUS, C
		GOTO		UnStable

		INCF		StableCount, F
		MOVLW       004H
		SUBWF		StableCount, W
		BTFSS		STATUS, C
		GOTO		ProcAdc_End
		DECF		StableCount, F
		BSF		    SysFlag1,B_SysFlag1_Steady
		GOTO		ProcAdc_End

Unstable:
		CLRF		StableCount
		BCF		    SysFlag1,B_SysFlag1_Steady

ProcAdc_End:

