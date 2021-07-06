INCLUDE irvine32.inc

.data
INCLUDE hw3.inc
CODE_A BYTE '1'
CODE_B BYTE '01'
CODE_C BYTE '000'
CODE_D BYTE '0011'
CODE_E BYTE '0010'
check BYTE 0
str1 BYTE 40 DUP(?)	
output BYTE 40 DUP(?)
lenA BYTE 0
lenB BYTE 0
lenC BYTE 0
lenD BYTE 0
lenE BYTE 0

.code
main PROC

	mov lenA, SIZEOF CODE_A
	mov lenB, SIZEOF CODE_B
	mov lenC, SIZEOF CODE_C
	mov lenD, SIZEOF CODE_D
	mov lenE, SIZEOF CODE_E

	mov edx, OFFSET CODE01
	call changeToByte
	call decompress
	call printStr

	mov edx, OFFSET CODE02
	call changeToByte
	call decompress
	call printStr

	mov edx, OFFSET CODE03
	call changeToByte
	call decompress
	call printStr

	mov edx, OFFSET CODE04
	call changeToByte
	call decompress
	call printStr

	mov edx, OFFSET CODE05
	call changeToByte
	call decompress
	call printStr
main ENDP

changeToByte PROC

mov esi, 0
mov ecx, 31
L1:
	mov eax, [edx]
	mov ebx, 1
	shl ebx, cl
	and eax, ebx
	shr eax, cl
	mov str1[esi], al
	inc esi
loop L1
	
	mov eax, [edx]
	mov ebx, 1
	and eax, ebx
	mov str1[esi], al
	inc esi
ret
changeToByte ENDP

decompress PROC

mov esi, 0
mov edx, 0

L2 :

	call compareA
	cmp check, 1
	jne BBB
	mov output[edx], 'A'
	jmp L3

BBB: call compareB
	cmp check, 1
	jne CCC
	mov output[edx], 'B'
	jmp L3
	
CCC: call compareC
	cmp check, 1
	jne DDD
	mov output[edx], 'C'
	jmp L3

DDD: call compareD
	cmp check, 1
	jne EEE
	mov output[edx], 'D'
	jmp L3

EEE: call compareE
	mov output[edx], 'E'

L3:
	inc edx
	mov check, 0
	cmp esi, 32
	jae L4
loop L2

L4 :
ret
decompress ENDP

compareA PROC

	mov ebx, 0		;CODE_A
	mov edi, esi	;str1
	movzx ecx, lenA
		
LoopA_:
	mov al, CODE_A[ebx]
	sub al, '0'
	cmp str1[edi], al
	jne endA

	inc ebx
	inc edi
	loop LoopA_

	mov check, 1
	movzx ebx, lenA

	add esi, ebx

endA:
ret
compareA ENDP

compareB PROC

	mov ebx, 0		;CODE_B
	mov edi, esi	;str1
	mov cl, lenB
LoopB_:
	mov al, CODE_B[ebx]
	sub al, '0'
	cmp str1[edi], al
	jne endB
	inc ebx
	inc edi
	loop LoopB_
	
	mov check, 1
	movzx ebx, lenB
	add esi, ebx
endB:
ret
compareB ENDP

compareC PROC

	mov ebx, 0		;CODE_C
	mov edi, esi	;str1
	mov cl, lenC
LoopC_:
	mov al, CODE_C[ebx]
	sub al, '0'
	cmp str1[edi], al
	jne endC
	inc ebx
	inc edi
	loop LoopC_

	mov check, 1
	movzx ebx, lenC
	add esi, ebx
endC:
ret
compareC ENDP

compareD PROC

	mov ebx, 0		;CODE_D
	mov edi, esi	;str1
	mov cl, lenD

LoopD_:
	mov al, CODE_D[ebx]
	sub al, '0'
	cmp str1[edi], al
	jne endD
	inc ebx
	inc edi
	loop LoopD_

	mov check, 1
	movzx ebx, lenD
	add esi, ebx
endD:
ret
compareD ENDP

compareE PROC

	mov ebx, 0		;CODE_E
	mov edi, esi	;str1
	mov cl, lenE
LoopE_:
	mov al, CODE_E[ebx]
	sub al, '0'
	cmp str1[edi], al
	jne endE
	inc ebx
	inc edi
	loop LoopE_

	mov check, 1
	movzx ebx, lenE
	add esi, ebx
endE:
ret
compareE ENDP

printStr PROC
	mov ecx, edx
	mov esi, 0
L5:
	mov al, output[esi]
	call WriteChar
	inc esi
	Loop L5
	call Crlf

ret
printStr ENDP
END main