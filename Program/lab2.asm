	ORG 0H
	JMP MAIN

	ORG 03H
	JMP SUM

	ORG 13H
	JMP SUB

;This is the add subroutine for INT0
;input: P1 and P2
;function: P1+P2 and display
;output: display C -> P3.0
;                summation -> P0
;REG: A, B, PSW
SUM:
	CLR EA;stop interrupt
	MOV A,P1
	MOV B,A
	MOV A,P2
	ADD A,B
	MOV P0,A
	MOV P3.0,C
	SETB EA;restart interrupt
	RETI

;This is the subbtraction for INT1
;input:	P1 and P2
;function: P1-P2 and display
;output: display C -> P3.0
;                summation -> P0
;REG: A,B,PSW
SUB:
	CLR EA;stop EA
	MOV A,P2
	MOV B,A
	MOV A,P1
	CLR C
	SUBB A,B
	MOV P0,A
	MOV P3.0,C
	SETB EA
	RETI

MAIN:
	MOV P0,#0
	MOV A,P3
	ANL A,#0FEH
	MOV P3,A
	SETB EX0
	SETB IT0
	SETB EX1
	SETB IT1
	SETB EA
	JMP $
	END
