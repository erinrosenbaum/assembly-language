TITLE Programming Asignment# 4     (RosenbaumProg04.asm)

; Author: Erin Rosenbaum
; Course: CS271 Winter 2016
; Project; Programming Assignment #4           
; Date: February 14th, 2016
; Description:

INCLUDE Irvine32.inc

.386
;.model flat
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD

; (insert constant definitions here)

MAX = 400
TAB = 9

.data

; (insert variable definitions here)
	textA0			BYTE	'Programming Assignment #4, written by Erin Rosenbaum',0
	textA1			BYTE	'Oregon State University; CS271 Winter 2016; Composite Numbers',0
	textA2			BYTE	'**EC: Aligned columns',0
	textB0			BYTE	'Choose how many composite numbers you want to see',0
	textB1			BYTE	'You can choose a number in the range of [1 .. 400].',0
	textB2			BYTE	'Go ahead and enter your number now: ',0
	textC0			BYTE	'The number you entered is out of range',0
	textC1			BYTE	'Please enter a number that is in range: ',0
	textF0			BYTE	'This is the end of the program.',0
	textF1			BYTE	'Thanks, have a nice day',0 
	test0			BYTE	'TEST',0
	input			DWORD	?
	numToTest		DWORD	4
	denom			DWORD	2
	count			DWORD	0

.code
main PROC
	
; (insert executable instructions here)

	call	introduction
	call	getUserData
	call	validate
	call	showComposites
	call	farewell

	exit	; exit to operating system
main ENDP


; (insert additional procedures here)

; A. 
introduction PROC
	mov			edx,OFFSET textA0
	call		WriteString
	call		Crlf
	mov			edx,OFFSET textA1
	call		WriteString
	call		Crlf
	mov			edx,OFFSET textA2
	call		WriteString
	call		Crlf
	call		Crlf
	ret
introduction ENDP

; B.
getUserData PROC
	mov		edx,OFFSET textB0
	call	WriteString
	call	Crlf
	mov		edx,OFFSET textB1
	call	WriteString
	call	Crlf
	call	Crlf
	mov		edx,OFFSET textB2
	call	WriteString	
	ret
getUserData ENDP

; C. Validate. A procedure that checks if the users input is in the range [1 .. 400]
; If input is out of range, program calls outOfRange function to print 
; a message and then jumps to the line where the user re-enters input. 

validate PROC
tryAgain:
	call	ReadInt
	mov		input,eax
	
	.IF eax > MAX || eax < 1
		call Crlf
		call outOfRange
		jmp tryAgain
	.ENDIF
	ret
validate ENDP

outOfRange PROC
	mov		edx,OFFSET textC0
	call	WriteString
	call	Crlf
	mov		edx,OFFSET textC1
	call	WriteString
	ret
outOfRange	ENDP

; D. 
showComposites PROC
	call	Crlf
	mov		ecx,input
loopComposite:
	call tester
	loop loopComposite
	ret
showComposites ENDP

; E. Prints the composite numbers and increments numToTest
isComposite PROC
	mov		eax, numToTest
	call	WriteDec
	inc		numToTest
	mov		al,TAB
	call	WriteChar
	ret
isComposite ENDP

; This function takes each number in sequential order and divides
; each number by subsequently higher numbers until either an 
; even divisor is found or the number is compared with itself. 
; This function finds the prime numbers when denom and numToTest
; are equal. It then increments numToTest and resets denom back to 2
; and begins another test.

tester PROC
reTest:
	mov		ebx,denom

	; Prime numbers
	.IF ebx == numToTest
		inc	numToTest
		mov	denom,2
		jmp reTest
	.ENDIF

	; Divides numToTest by denom. If there is no remainder, 
	; IsComposite is called. If there is a remainder, denom is 
	; incremented and another division is performed.

	mov		edx,0
	mov		eax,numToTest
	mov		ebx,denom
	div		ebx

	.IF edx == 0
		call	isComposite
		mov		denom,2
	.ELSE
		inc		denom
		jmp		reTest
	.ENDIF

	ret
tester ENDP

; F. Prints farewell message
farewell PROC
	call		Crlf
	call		Crlf
	mov			edx,OFFSET textF0
	call		WriteString
	call		Crlf
	mov			edx,OFFSET textF1
	call		WriteString
	call		Crlf
	ret
farewell ENDP

END main

