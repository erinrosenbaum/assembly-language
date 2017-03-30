TITLE Programming Asignment#5     (RosenbaumProg05.asm)

; Author: Erin Rosenbaum
; Course: CS271 Winter 2016
; Project; Programming Assignment # 5         
; Date: February 28, 2016
; Description: Asks the user to enter a number between 10 and 200,
; produces an array of that many random numbers, and then sorts the array
; in descending order. Displays the median
; of the array if the array has an odd number of elements, or calculates the mean
; of the 2 middle elements if the array has an even number of elements.

INCLUDE Irvine32.inc

.386
;.model flat
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD

; (insert constant definitions here)
MIN = 10
MAX = 200
LO  = 100
HI  = 999
TAB = 9

lowMedInd		EQU DWORD PTR [ebp-4] ; to be used as a local variables
lowMed			EQU DWORD PTR [ebp-8]
highMedInd		EQU DWORD PTR [ebp-12]
highMed			EQU DWORD PTR [ebp-16]
AVG				EQU DWORD PTR [ebp-20]
REMAINDER		EQU DWORD PTR [ebp-24]
First			EQU DWORD PTR [ebp-28]
Second			EQU DWORD PTR [ebp-32]
.data

; (insert variable definitions here)

textA0		BYTE	'Programming Assignment #5, written by Erin Rosenbaum',0
textA1		BYTE	'Oregon State University, CS271 Winter 2016',0
textA2		BYTE	'February 28, 2016; Random Numbers and Arrays',0
textA3		BYTE	'You will be asked to enter a number between 10 and 200',0
textA4		BYTE	'and this program will generate that many random',0
textA5		BYTE	'numbers between 100 and 999.',0
textB0		BYTE	'Please enter a number between 10 and 200: ',0
textB1		BYTE	'The number you entered is out of range',0
textB2		BYTE	'Please enter a number that is in the specified range: ',0
textE0		BYTE	'The median is ',0
textE1		BYTE	'.',0

textF0		BYTE	'The Unsorted Numbers',0
textF1		BYTE	'The Sorted Numbers',0

input		DWORD	?
myArray		DWORD	MAX		DUP(?)
isSorted	DWORD	0	; boolean to determine which title to display.
						; once the array is sorted, it can't be unsorted.

.code
main PROC
push OFFSET textA0
push OFFSET textA1
push OFFSET textA2
push OFFSET textA3
push OFFSET textA4
push OFFSET textA5
call introduction

push OFFSET textB0
push OFFSET textB1
push OFFSET textB2
push OFFSET input			;uninitialized value, passed by reference
call getUserData

call Randomize
push OFFSET myArray
push input					;value entered by user
call fillArray

push OFFSET myArray
push input
push OFFSET textF0
push OFFSET	textF1
call displayList

push OFFSET myArray
push input
call sortArray

push OFFSET myArray
push input
push OFFSET textE0
push OFFSET textE1
call displayMedian

push OFFSET myArray
push input
push OFFSET textF0
push OFFSET	textF1
call displayList

; (insert executable instructions here)

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

; A.
introduction PROC
	push ebp
	mov ebp,esp
	mov edx,[ebp+28] 
	call WriteString
	call Crlf
	mov edx,[ebp+24] 
	call WriteString
	call Crlf
	mov edx,[ebp+20] 
	call WriteString
	call Crlf
	call Crlf
	mov edx,[ebp+16] 
	call WriteString
	call Crlf	
	mov edx,[ebp+12] 
	call WriteString
	call Crlf	
	mov edx,[ebp+8] 
	call WriteString
	call Crlf
	call Crlf
	pop ebp
	ret 24
introduction ENDP

; B.
getUserData PROC
	push	ebp
	mov		ebp,esp
	mov		edx,[ebp+20]
	call	WriteString			;prompt the user
tryAgain:
	call	ReadInt
	mov		ebx,[ebp+8]			;address of input in ebx
	mov		[ebx],eax			;store in global variable

	; validate input
	.IF eax > MAX || eax < MIN
		call Crlf
		mov edx,[ebp+16]
		call WriteString
		call Crlf
		mov edx,[ebp+12]
		call WriteString
		jmp tryAgain
	.ENDIF

	pop		ebp
	ret		16
getUserData ENDP

; C.
fillArray PROC
	push	ebp
	mov		ebp,esp
	mov		edi,[ebp+12]
	mov		ebx,0
	mov		ecx,[ebp+8]
keepLooping:
	mov		eax,900 ; size of range
	call	RandomRange
	add		eax,LO
	mov		[edi],eax
	add		edi,4
	loop	keepLooping
	pop		ebp
	ret		8
fillArray ENDP

; D. Bubble sort algorithm was taken from Irvine
sortArray PROC
	push	ebp
	mov		ebp,esp
	mov		ecx,[ebp+8]
	dec		ecx
L1:
	push ecx				; save outer loop counter
	mov		esi,[ebp+12]

L2:
	mov		eax,[esi]
	cmp		eax,[esi+4]
	jg		L3
	
	; swap values
	xchg	eax,[esi+4]
	mov		[esi],eax		; store in memory

; Don't need to swap
L3:
	add		esi,4
	loop	L2

	pop		ecx				; restore outer loop counter
	loop	L1

	mov		isSorted,1
	pop		ebp
	ret		8
sortArray ENDP

; E.
displayMedian PROC
	push	ebp
	mov		ebp,esp
	sub		esp,32			; create room for a local variables
	mov		eax,[ebp+16]	; number of elements
	mov		edx,0			; just for best practices for division
	mov		ebx,2			; find out if even or odd number of elements
	div		ebx
	mov		REMAINDER,edx	; save in local variable
	mov		lowMedInd,eax	; store in local variable the index of the 
	mov		eax,lowMedInd
	mov		ebx,4
	mul		ebx				; get the offset for lowMed
	mov		lowMed,eax
	mov		eax,lowMedInd
	dec		eax				; median if number of elements is odd, or the
	mov		highMedInd,eax	; first index if number of elements is even
	mov		ebx,4
	mul		ebx				; offset for highMed
	mov		highMed,eax	

	.IF		REMAINDER == 1		; An odd number of elements
	mov		edx,[ebp+12]		; first part of message
	call	WriteString
	mov		edx,[ebp+20]		; address of array
	mov		ecx,lowMed			; offset of needed value
	mov		eax,[edx+ecx]		; array + offset
	call	WriteDec
	mov		edx,[ebp+8]			; second part of message
	call	WriteString	
	call	Crlf
	.ENDIF

	.IF		REMAINDER == 0		; An even number of elements
	mov		edx,[ebp+12]		; first part of message
	call	WriteString
	mov		edx,[ebp+20]		; address of array
	mov		ecx,lowMed			; offset of first number
	mov		eax,[edx+ecx]		; first value
	mov		First,eax
	mov		edx,[ebp+20]		; address of array
	mov		ecx,highMed			; offset of second number
	mov		eax,[edx+ecx]		; second number
	mov		Second,eax
	mov		eax,Second	
	add		eax,First		
	mov		edx,0				; best practices
	mov		ebx,2
	div		ebx
	
	call	WriteDec
	mov		edx,[ebp+8]
	call	WriteString
	call	Crlf
	.ENDIF

	mov		esp,ebp			; remove local variables from stack
	pop		ebp
	ret		16
displayMedian ENDP

; F.
displayList PROC
	push	ebp
	mov		ebp,esp

	.IF		isSorted == 1
	mov		edx,[ebp+8]
	call	Crlf
	call	WriteString
	call	Crlf
	.ENDIF

	.IF		isSorted == 0
	mov		edx,[ebp+12]
	call	Crlf
	call	WriteString
	call	Crlf
	.ENDIF

	mov		esi,[ebp+20]	;@ myArray
	mov		ecx,[ebp+16]	;loop control
keepGoing:
	mov		eax,[esi]
	call	WriteDec
	mov		al,TAB
	call	WriteChar

	; perform a division to call Crlf
	; if the remained of [(input-count+1)/10] = 0, return to next line
	mov		edx,0		
	mov		eax,input
	mov		ebx,10
	sub		eax,ecx
	inc		eax
	div		ebx
	.IF		edx == 0
	call	Crlf
	.ENDIF

	add		esi,4
	loop	keepGoing
endKeepGoing:
	call	Crlf
	call	Crlf
	pop		ebp
	ret		16
displayList ENDP

END main
