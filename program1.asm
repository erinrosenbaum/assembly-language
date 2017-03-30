TITLE ELR_Prog1      (ELR_Prog1.asm)

; Author: Erin Rosenbaum
; Course / Project ID: CS 271-400 Winter 2016
; Date: January 17, 2016
; Description: Display my name and program title. Display instructions, prompt the user for 2 numbers, 
;			   Calculate the sum, difference, product, (integer) quotient, and remainder

INCLUDE Irvine32.inc

.386
.model flat,stdcall ; model directive tells the assembler which memory model to use.
.stack 4096		; stack directive tells assembler how many bytes for stack. 
ExitProcess PROTO, dwExitCode:DWORD

.data
var1		DWORD	0
var2		DWORD	0
res1		DWORD	0
res2		DWORD	0
res3		DWORD	0
res4		DWORD	0
res5		DWORD	0
sy1			BYTE		' + ',0
sy2			BYTE		' - ',0
sy3			BYTE		' X ',0
sy4			BYTE		' / ',0
sy5			BYTE		' = ',0
sy6			BYTE		' Remainder ',0

int1		BYTE		'Welcome to the Program. Two numbers will be entered,',0
int2		BYTE		'and the sum, diff, product, quotient, and remainder will be calculated.',0
req1		BYTE		'Author: Erin Rosenbaum',0
req2		BYTE		'Program Title: Program 1',0
req3		BYTE		'Name of Program File: ELR_Prog1.asm',0
inst1		BYTE		'Follow the directions listed below',0
prompt1		BYTE		'Enter 1st number: ',0
prompt2		BYTE		'Enter 2nd number: ',0
prompt3		BYTE		'Do you wish to continue?',0
prompt4		BYTE		'Please re-enter those numbers again so that the second number is less than the first.',0

bye1		BYTE		'Thank you.',0
ex1			BYTE		'**EC: Repeat until user chooses to quit.',0
ex2			BYTE		'**EC: Validate the second number to be less than the first.',0

.code
main PROC
	call	Clrscr

; Introduction

	; main intro
	mov	    edx, OFFSET int1
	call	WriteString
	call	Crlf
	mov		edx, OFFSET int2
	call	WriteString
	call	Crlf
	call	Crlf

	; Description
	mov		edx, OFFSET req1
	call	WriteString	; displays the string to console window as it's stored in memory
	call	CrLf			; new line
	mov		edx, OFFSET req2
	call	WriteString
	call	Crlf
	mov		edx, OFFSET req3
	call	WriteString
	call	Crlf
	call	Crlf
	mov		edx, OFFSET inst1
	call	WriteString
	call	Crlf
	call	Crlf
	
	; Extra credit section
	mov		edx, OFFSET ex1
	call	WriteString
	call	Crlf
	mov		edx, OFFSET ex2
	call	WriteString
	call	Crlf
	call	Crlf

target1:
; Get Data

	; Get the first number		
	mov		edx, OFFSET	prompt1
	call	WriteString 
	call	ReadInt		; stored in eax memory
	mov		var1, eax

	; Get the second number
	mov		edx, OFFSET prompt2
	call	WriteString
	call	ReadInt
	mov		var2, eax
	call	Crlf

	; Validate the second number to be less than the first
	mov		eax, var1
	.IF eax < var2
			mov edx, OFFSET prompt4 
			call WriteString
			call Crlf
			call Crlf
			jmp target1
	.ENDIF

; Perform Calculations
	
	; Addition
		mov eax, var1
		mov edx, var2
		add eax, edx
		mov res1, eax

	; Subtract
		mov eax, var1
		mov edx, var2
		sub eax, edx
		mov res2, eax
		
	; Multiplication
		mov eax, var1
		mov ebx, var2
		mul ebx ; default destination is eax
		mov res3, eax

	; Division
		mov	edx,0
		mov eax, var1
		mov ebx, var2
		div ebx
		mov res4, eax
		mov res5, edx

; Display Results

	; Result of addition
	mov		eax, var1
	call	WriteDec
	mov		edx, OFFSET sy1 
	call	WriteString
	mov		eax, var2
	call	WriteDec
	mov		edx, OFFSET sy5
	call	WriteString
	mov		eax, res1
	call	WriteDec
	call	CrLf

	; Result of subtraction
	mov		eax, var1
	call	WriteDec
	mov		edx, OFFSET sy2 
	call	WriteString
	mov		eax, var2
	call	WriteDec
	mov		edx, OFFSET sy5
	call	WriteString
	mov		eax, res2
	call	WriteDec
	call	CrLf

	; Result of multiplication
	mov		eax, var1
	call	WriteDec
	mov		edx, OFFSET sy3 
	call	WriteString
	mov		eax, var2
	call	WriteDec
	mov		edx, OFFSET sy5
	call	WriteString
	mov		eax, res3
	call	WriteDec
	call	CrLf

	; Result of division
	mov		eax, var1
	call	WriteDec
	mov		edx, OFFSET sy4 
	call	WriteString
	mov		eax, var2
	call	WriteDec
	mov		edx, OFFSET sy5
	call	WriteString
	mov		eax, res4
	call	WriteDec
	mov		edx, OFFSET sy6
	call	WriteString
	mov		eax, res5
	call	WriteDec
	call	CrLf
	call	Crlf

	; Repeat until the user choses to quit
	mov		ebx, OFFSET bye1 ; title of message box into ebx
	mov		edx, OFFSET prompt3
	call	MsgBoxAsk
	.IF eax == 6
		jmp target1
	.ENDIF
	call	Crlf

; Farewell Greeting
	mov			edx, OFFSET bye1
	call		WriteString
	call		CrLf

	INVOKE ExitProcess,0	; exit to operating system
main ENDP

END main