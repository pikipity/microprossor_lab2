	ORG 0H
	JMP MAIN

	ORG 03H
	JMP SUM

	ORG 13H
	JMP SUB

;This is the add subroutine for INT0
;input: P1 and P2
;function: P1+P2 and display
;output: display Carry -> P3.0 and P3.1 -> first 7-seg LED
;                summation -> P0 -> last two 7-seg LED
;REG: A, B, PSW
SUM:
	CLR EA               ;stop interrupt
	CALL Clear_display	 ;Clear LED
	;do summation
	MOV A,P1
	MOV B,A
	MOV A,P2
	ADD A,B
	;display summation
	MOV P0,A
	;display carray
	JNC SUM_finish       ;if no carry, display nothing
	CLR P3.0			 ;if have carry, display 1
	CLR P3.1
	;finish summation
SUM_finish:
	SETB EA              ;restart interrupt
	RETI

;This is the subbtraction for INT1
;input:	P1 and P2
;function: P1-P2 and display
;output: if difference is positive, display difference in last two 7-seg LED
;        if difference is negative, display negative sign in first 7-seg LED 
;                                   and display absoluate difference in last two 7-seg LED
;REG: A,B,PSW
SUB:
	CLR EA                 ;stop EA
	CALL Clear_display	   ;clear display
	;start P1-P2
	MOV A,P2
	MOV B,A
	MOV A,P1
	CLR C
	SUBB A,B
	;
	JC SUB_negative		   ;if negative, jump to SUB_negative
SUB_positive:			   ;if positive, go to SUB_positive
	MOV P0,A			   ;if difference is positive, display difference in last two 7-seg LED
	JMP SUB_finish
SUB_negative:			   
	CLR P3.4	;display negative sign
	MOV	A,P1	;display P2-P1 to last two 7-seg LED
	MOV B,A
	MOV A,P2
	CLR C
	SUBB A,B
	MOV P0,A
	;finish subbtraction
SUB_finish:
	SETB EA
	RETI

Clear_display:
	MOV P0,#0
	SETB P3.0
	SETB P3.1
	SETB P3.4
	RET

MAIN:
	CALL Clear_display
	SETB EX0
	SETB IT0
	SETB EX1
	SETB IT1
	SETB EA
	JMP $
	END
