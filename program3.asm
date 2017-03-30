TITLE Programming Asignment#3     (RosenbaumCS270Prog3.asm)

; Author: Erin Rosenbaum
; Course: CS271 Winter 2016
; Project; Programming Assignment #3            
; Date: February 7, 2016
; Description: The program sums negative numbers greater than -100.
; If the user inputs positive numbers, the program terminates, reports the total, 
; reports the average, and the number of valid negative numbers.

INCLUDE Irvine32.inc

.386
;.model flat
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD

; (insert constant definitions here)

MIN = -100 ; lower limit defined as a constant

.data

textA0			BYTE	'Programming Assignment #3', 0
textA1			BYTE	'Programmed by Erin Rosenbaum',0
textB0			BYTE	'What is your name? ',0
textB1			BYTE	'Hello, ',0
username		BYTE	30 DUP(0) ; input buffer
textC0			BYTE	'Please enter numbers in [-100, -1].',0
textC1			BYTE	'Enter a non-negative number when you are finished to see the results.',0
textD0			BYTE	'Enter number ',0
textD1			BYTE	'You did not enter ANY negative numbers.',0
textD2			BYTE	': ',0
textFA0			BYTE	'You entered ',0
textFA1			BYTE	' valid negative number(s).',0
textFB0			BYTE	'The sum of your valid number(s) is ',0
textFC0			BYTE	'The rounded average is ',0
textFD0			BYTE	'Thank you, ',0 
textFD1			BYTE	', have a nice day.',0
textXtraC		BYTE	'**EC: Numbered the lines during user input.',0
coun			DWORD	0
sum				DWORD	0
inpt			DWORD	?
avg				DWORD	0

; (insert variable definitinkons here)

.code
main PROC

; (insert executable instructions here)
; A. Display the program title and programmer's name
	mov		edx, OFFSET textA0
	call	WriteString
	call	Crlf
	mov		edx, OFFSET textA1
	call	WriteString
	call	Crlf
	call	Crlf
	mov		edx,OFFSET textXtraC
	call	WriteString
	call	Crlf
	call	Crlf

; B. Get the user's name and greet the user
	mov		edx, OFFSET textB0
	call	WriteString
	mov		edx,OFFSET username
	mov		ecx,SIZEOF username
	call	ReadString
	;call	Crlf
	mov		edx,OFFSET textB1
	call	WriteString
	mov		edx,OFFSET username
	call	WriteString
	call	Crlf
	call	Crlf

; C. Display instructions for the user

prompt:
	mov		edx,OFFSET textC0
	call	WriteString
prompt2:
	call	Crlf
	mov		edx,OFFSET textC1
	call	WriteString
	call	Crlf

; D. Repeatedly prompt the user to enter a number

enterInput:
	mov		edx,OFFSET textD0
	call	WriteString
	mov		eax,coun
	add		eax,1		; adds one to the count for display purposes	
	call	WriteDec
	mov		edx,OFFSET textD2
	call	WriteString
	call	ReadInt
	mov		inpt,eax	; value read in is stored in memory

	; Validate input to be in the range [-100, -1] (inclusive)

		; if the input number is less than -100, 
		; go back and prompt the user again to enter another number

			mov		eax,inpt
			cmp		eax,MIN 
			jl		prompt

		; if the input number is positive, skip ahead to calculate average,
		; display results, and exit program

			cmp		eax,-1
			jg		calculate

	; Count and accumulte input values until
	; a non-negative number is entered

	; increment count, add new input to sum, 
	; save the new sum in memory,
	; and then go back and enter another number

keepCounting:
		inc		coun
		mov		eax,sum
		add		eax,inpt
		mov		sum,eax
		jmp		enterInput
	
; E. Calculate the rounded-integer average of the negative numbers

calculate:

	; if count is 0, and there there were no negative numbers entered,
	; display special message and then jump to parting message

	.IF coun == 0
		mov		edx,OFFSET textD1 ; special message
		call	WriteString
		call	Crlf
		jmp		atTheEnd
	.ENDIF

	; calculate the average using idiv
	; extend sign of eax into edx using cdq

	mov		edx,0
	mov		eax,sum
	cdq					; extend sign of eax into edx
	mov		ebx,coun
	idiv	ebx			; quotient is in eax, remainder is in edx
	mov		avg,eax		; save in memory

; F. Display 
	; A.the number of negative numbers entered
		mov		edx,OFFSET textFA0
		call	WriteString
		mov		eax,coun
		call	WriteDec
		mov		edx,OFFSET textFA1
		call	WriteString
		call	Crlf

	; B.the sum of the negative numbers entered
		mov		edx,OFFSET textFB0
		call	WriteString
		mov		eax,sum
		call	WriteInt
		call	Crlf

	; C.the average, rounded to the nearest integer
		mov		edx,OFFSET textFC0
		call	WriteString
		mov		eax,avg
		call	WriteInt
		call	Crlf

	; D. parting message with user's name

AtTheEnd:
		mov		edx,OFFSET textFD0
		call	WriteString
		mov		edx,OFFSET username
		call	WriteString
		mov		edx,OFFSET textFD1
		call	WriteString
		call	Crlf;

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
