;================================
;==== LCD_MAP_Define.INC
;================================

;============================================================
;===== Dispaly Segment

   SEG_F       EQU   00000001B
   SEG_G       EQU   00000010B
   SEG_E       EQU   00000100B
   SEG_D       EQU   00001000B
   SEG_A       EQU   00010000B
   SEG_B       EQU   00100000B
   SEG_C       EQU   01000000B
   
   Lcdch0      EQU   SEG_A+SEG_B+SEG_C+SEG_D+SEG_E+SEG_F
   Lcdch1	   EQU   SEG_B+SEG_C
   Lcdch2	   EQU   SEG_A+SEG_B+SEG_D+SEG_E+SEG_G
   Lcdch3	   EQU   SEG_A+SEG_B+SEG_C+SEG_D+SEG_G
   Lcdch4	   EQU   SEG_B+SEG_C+SEG_F+SEG_G
   Lcdch5	   EQU   SEG_A+SEG_C+SEG_D+SEG_F+SEG_G
   Lcdch6	   EQU   SEG_A+SEG_C+SEG_D+SEG_E+SEG_F+SEG_G
   Lcdch7	   EQU   SEG_A+SEG_B+SEG_C
   Lcdch8	   EQU   SEG_A+SEG_B+SEG_C+SEG_D+SEG_E+SEG_F+SEG_G
   Lcdch9	   EQU   SEG_A+SEG_B+SEG_C+SEG_D+SEG_F+SEG_G
   LcdchNo	   EQU   00H
   LcdchA	   EQU   SEG_A+SEG_B+SEG_C+SEG_E+SEG_F+SEG_G
   Lcdchb	   EQU   SEG_C+SEG_D+SEG_E+SEG_F+SEG_G
   LcdchC	   EQU   SEG_A+SEG_D+SEG_E+SEG_F
   Lcdchd	   EQU   SEG_B+SEG_C+SEG_D+SEG_E+SEG_G
   LcdchE	   EQU   SEG_A+SEG_D+SEG_E+SEG_F+SEG_G
   LcdchF	   EQU   SEG_A+SEG_E+SEG_F+SEG_G
   LcdchH      EQU   SEG_B+SEG_C+SEG_E+SEG_F+SEG_G
   LcdchL	   EQU   SEG_D+SEG_E+SEG_F
   LcdchN	   EQU   SEG_A+SEG_B+SEG_C+SEG_E+SEG_F
   Lcdcho	   EQU   SEG_C+SEG_D+SEG_E+SEG_G
   LcdchP	   EQU   SEG_A+SEG_B+SEG_E+SEG_F+SEG_G
   Lcdchr	   EQU   SEG_E+SEG_G
   LcdchT	   EQU   SEG_D+SEG_E+SEG_F+SEG_G
   LcdchU	   EQU   SEG_B+SEG_C+SEG_D+SEG_E+SEG_F
   LcdchBar    EQU   SEG_G
   LcdchUpo    EQU   SEG_A+SEG_B+SEG_F+SEG_G

   Disp_No     EQU   10




