TITLE Programming Asignment#06     (RosenbaumProg06.asm)

; Author: Erin Rosenbaum
; Course: CS271 Winter 2016
; Project; Programming Assignment # 6        
; Date: March 13, 2016
; Description: The program will generate two random numbers
; between 3 and 12 and then ask the user to guess the number of r
; combinations in n elements. The program will calculate the 
; number of combinations recursively. The numberic input is 
; accepted as a string and converted into an integer. If the user
; inputs non-numeric input, they are prompted to re-enter a number. 

INCLUDE Irvine32.inc

.386
;.model flat
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD

; (insert constant definitions here)

; Macro to write strings
mWriteStr	MACRO varName
	push	edx
	mov		edx,OFFSET varName
	call	WriteString
	pop		edx
ENDM

.data

; (insert variable definitions here)

textB0		BYTE		'Programming Assignment #6B, written by Erin Rosenbaum',0
textB1		BYTE		'Oregon State University, CS271 Winter 2016',0
textB2		BYTE		'March 13, 2016; Combinations, Macros, and Recursion',0
textB3		BYTE		'The system will generate 2 random numbers and your job',0
textB4		BYTE		'will be to enter the number of r-combinations that you think',0
textB5		BYTE		'exist in the set of n elements.',0
textC0		BYTE		'Problem:',0
textC1		BYTE		'Number of elements in the set: ',0
textC2		BYTE		'Number of elements to choose from the set: ',0
textD0		BYTE		'How many combinations do you think there are? ',0
textD1		BYTE		'You entered non-numeric input. Please enter a number: ',0
textF0		BYTE		'There are ',0
textF1		BYTE		' different possible combinations of ',0
textF2		BYTE		' items from a set of ',0
textF3		BYTE		' items.',0
textF4		BYTE		'You are correct!',0
textF5		BYTE		'Your guess is incorrect.',0

 N			DWORD		?
 R			DWORD		?
 answer		DWORD		?
 temp		BYTE		12 DUP(0)
 charCount	DWORD		?
 result		DWORD		?

 localN			EQU DWORD PTR [ebp-4]
 localR			EQU DWORD PTR [ebp-8]
 localNsubR		EQU DWORD PTR [ebp-12]
 localNfac		EQU DWORD PTR [ebp-16]
 localRfac		EQU DWORD PTR [ebp-20]
 localNsubRfac	EQU DWORD PTR [ebp-24]

.code

; A.
main PROC

; B.
call introduction

; C.
; setup stack and call showProblem
	call Randomize
	push OFFSET N
	push OFFSET R
	call showProblem

; D.
; setup stack and call getData
	push OFFSET charCount
	push OFFSET temp
	push OFFSET answer
	call getData

; E.
; setup stack and call combinations
	push N
	push R
	push OFFSET result
	call combinations

; F.
; setup stack and call showResults
	push N
	push R
	push answer
	push result
	call showResults

; (insert executable instructions here)

	exit	; exit to operating system
main ENDP

; B.
introduction PROC
	pushad
	mWriteStr	textB0
	call		Crlf
	mWriteStr	textB1
	call		Crlf
	mWriteStr	textB2
	call		Crlf
	call		Crlf
	mWriteStr	textB3
	call		Crlf
	mWriteStr	textB4
	call		Crlf
	mWriteStr	textB5
	call		Crlf
	call		Crlf
	popad
	ret
introduction ENDP

; C.
showProblem PROC
	pushad
	push		ebp
	mov			ebp,esp
	mov			ebx,[ebp+44]	; @ N
	mov			eax,10			; size of range
	call		Randomrange
	add			eax,3			; offset random number to be in [3 - 12]
	mov			[ebx],eax		; store random number in global variable N
	mov			ebx,[ebp+40]	; @ R
	mov			eax,N
	call		Randomrange
	add			eax,1			; since Randomrange produces a number from [0 - (n-1)]
	mov			[ebx],eax		; store random number in global varialbe R	
	mWriteStr	textC0
	call		Crlf
	mWriteStr	textC1
	mov			eax,N
	call		WriteDec
	call		Crlf
	mWriteStr	textC2
	mov			eax,R
	call		WriteDec
	call		Crlf
	popad
	pop ebp
	ret 8
showProblem ENDP

; D.
getData PROC
	pushad
	push	ebp
	mov		ebp,esp
	mWriteStr textD0
tryAgain:
	mov		edx,[ebp+44]		; offset of temp string
	mov		ecx,12				; 12 is larger than the largest possible string
	call	ReadString
	call	Crlf
	mov		ebx,[ebp+48]		; @ charCount
	mov		[ebx],eax			; saves charCount in memory
	mov		ecx,charCount		; loop for each character
	mov		esi,[ebp+44]		; array of strings in esi
nextChar:
	mov		ebx,[ebp+40] 
	mov		eax,[ebx]			; @ answer in eax
	mov		ebx,10
	mul		ebx
	mov		ebx,[ebp+40]		; @ answer
	mov		[ebx],eax
	mov		al,[esi]			; each character in ESI
	inc		esi	
	sub		al,48
	.IF		al < 0 || al > 9	; must be in the range of digits
	mWriteStr textD1
	jmp		tryAgain
	.ENDIF
	mov		ebx,[ebp+40]
	add		[ebx],al			; add current value to answer
	loop	nextChar
	popad
	pop ebp
	ret 12
getData ENDP

; E.
combinations PROC
	push	eax				; save the register
	push	ebp
	mov		ebp,esp
	sub		esp,24			; create room for local variables
	mov		eax,[ebp+20]	; @ N
	mov		localN,eax		; store N in local variable
	mov		eax,[ebp+16]	; @ R
	mov		localR,eax		; store R in local variable
	mov		eax,localN
	sub		eax,localR
	mov		localNsubR,eax	; N - R in local variable

	; Factorial function influenced by Irvine
	; Receives N,R, or N-R in EAX
	; Returns factorial in EAX

	mov		eax,localN
	push	eax
	call	Factorial
	mov		localNfac,eax		; save local variable
	
	mov		eax,localR
	push	eax	
	call	Factorial
	mov		localRfac,eax		; save local variable
	
	mov		eax,localNsubR
	push	eax
	call	Factorial
	mov		localNsubRfac,eax	; save local variable
	
	mov		eax,localNfac
	mov		edx,0
	mov		ebx,localRfac
	div		ebx
	mov		ebx,localNsubRfac
	div		ebx
	mov		result,eax

	mov		esp,ebp				; remove local variables from stack
	pop		ebp
	pop		eax
	ret		12
combinations ENDP

Factorial PROC 
	push	ebp
	mov		ebp,esp
	mov		eax,[ebp+8]
	
	cmp		eax,0
	ja		L1			; not yet base case
	mov		eax,1		; base case returns 1
	jmp		L2			; returns 
L1:
	dec		eax
	push	eax
	call	Factorial 
ReturnFact:
	mov		ebx,[ebp+8]
	mul		ebx
L2:	
	pop		ebp
	ret		4
factorial ENDP

; F.
showResults PROC
	pushad
	push		ebp
	mov			ebp,esp
	mWriteStr	textF0
	mov			eax,0
	add			eax,[ebp+40]		; result
	call		WriteDec
	mWriteStr	textF1
	mov			eax,0
	add			eax,[ebp+48]	; R
	call		WriteDec
	mWriteStr	textF2
	mov			eax,0
	add			eax,[ebp+52]	; N
	call		WriteDec
	mWriteStr	textF3
	call		Crlf
	mov			eax,[ebp+40]		; result
	.IF eax == answer 			; Correct answer
	mWriteStr	textF4
	.ELSE
	mWriteStr	textF5
	.ENDIF
	call		Crlf
	call		Crlf

	popad
	pop ebp
	ret 16
showResults ENDP

; (insert additional procedures here)

END main