TITLE Program Template     (RosenbaumCS270Assig2.asm)

; Author: Erin Rosenbaum
; Course / Project ID: CS271 Winter 2016               
; Date: January 24, 2016
; Description: Prompts user to enter their name and the number of elements
; in the Fibonacci sequence they wish to have printed.

INCLUDE Irvine32.inc

.386
;.model flat
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD

; (insert constant definitions here)

MAX = 46
TAB = 9				; ASCII code

.data
text1a		BYTE	'Fibonacci Numbers',0
text1b		BYTE	'Programmed by Erin Rosenbaum',0
text1c		BYTE	'What is your name? ',0
text1d		BYTE	'Hello, ',0
text2a		BYTE	'Enter the number of Fibonacci terms to be displayed ',0
text2b		BYTE	'Give the number as an integer in the range [1 .. 46]. ',0
text3a		BYTE	'How many Fibonacci terms do you want displayed? ',0
oor1		BYTE	'Out of range. Enter a number between 1 and 46. ',0
bye4a		BYTE	'These results were produced by Erin Rosenbaum.',0
bye4b		BYTE	'Good bye, ',0
bye4c		BYTE	'.',0

username	BYTE	30 DUP(0)
numfibs		DWORD	0
sum			DWORD	0
fib			DWORD	0
count		DWORD	0
countmod	DWORD	0

.code
main PROC

	call	Clrscr

; Introduction

; Line 1
	mov		edx,OFFSET text1a
	call	WriteString
	call	Crlf

; Line 2
	mov		edx,OFFSET text1b
	call	WriteString
	call	Crlf
	call	Crlf

; Line 3 Ask the user to input their name and save it to memory
	mov		edx,OFFSET text1c
	call	WriteString
	mov		edx,OFFSET username
	mov		ecx,SIZEOF username
	call	ReadString
	call	Crlf

; Line 4 Greeting
	mov		edx,OFFSET text1d
	call	WriteString
	mov		edx,OFFSET username
	call	WriteString
	call	Crlf


; userInstructions

; Line 5
mov edx,OFFSET text2a
	call	WriteString
	call	Crlf

; Line 6
mov		edx,OFFSET text2b
	call	WriteString
	call	Crlf
	call	Crlf

target1:
; getUserData

; Line 7, have the user input an integer
	mov		edx,OFFSET text3a
	call	WriteString
	call	ReadInt
	mov		numfibs,eax

; Data validation
; Test if input is between 1 and 46
; If not, display Out of Range message and repeat input sequence

.IF eax < 1 || eax > MAX
	mov		edx,OFFSET oor1
	call	Crlf
	call	WriteString
	call	Crlf
	jmp target1

.ENDIF
	call	Crlf

; displayFibs

	mov		ecx,numfibs		; initialize base cases and loop counter 
	mov		eax,0			
	mov		ebx,1
	
L1:	
	inc		count
	mov		sum,eax
	add		eax,ebx		; Add numbers to get Fibonacci number
	call	WriteDec	; 
	
	
	mov		fib,eax
 	mov		fib,eax		; store current value in memory and hold the value so eax can be used with TAB
	mov		al,TAB		; horizontal tab
	call	WriteChar

	; Spacing
	mov		edx,0
	mov		eax,count
	mov		ebx,5
	div		ebx
	.IF		edx == 0
			call Crlf
	.ENDIF

	mov		ebx,sum
	mov		eax,fib		; restore value stored in eax
	loop	L1


	call	Crlf
	
; Farewell

; Line 1
	mov		edx,OFFSET bye4a
	call	WriteString
	call	Crlf

; Line 2
	mov		edx,OFFSET bye4b
	call	WriteString
	mov		edx,OFFSET username
	call	WriteString
	mov		edx,OFFSET bye4c
	call	WriteString
	call	Crlf
	call	Crlf

exit	; exit to operating system
main ENDP

END main
