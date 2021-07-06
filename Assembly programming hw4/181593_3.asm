INCLUDE irvine32.inc

.data
str1 BYTE "Enter a Multiplier : ",0
str2 BYTE "Enter a Multiplicand : ",0
str3 BYTE "Product : ",0
bye BYTE "Bye!",0
plierStr BYTE 9 DUP(?)
candStr BYTE 9 DUP(?)
multiplier DWORD 0
multiplicand DWORD 0
lenP DWORD 0
lenC DWORD 0
errorcheck DWORD 0

.code
main PROC
L0:
	call inputNum
	cmp errorcheck, 1
	je goodbye
	mov errorcheck, 0
	mov edx, OFFSET plierStr
	mov ecx, lenP
	call strToHexa
	cmp errorcheck, 1
	je L0
	mov multiplier, eax

	mov edx, OFFSET candStr
	mov ecx, lenC
	call strToHexa
	cmp errorcheck, 1
	je L0
	mov multiplicand, eax

	mov ebx, multiplier
	mov edx, OFFSET str3
	call writeString
	call BitwiseMultiply
	mov ebx, TYPE DWORD
	call writeHex
	call crlf
	call crlf

	loop L0
goodbye:
	mov edx, OFFSET bye
	call writeString
	call crlf
	
main ENDP

strToHexa PROC
mov eax, 0
mov ebx, 0
mov esi, 0	;string index 

L1: 
	mov bl, [edx+esi]
	cmp bl, 102
	ja error
	cmp bl, 97
	jae lower
	cmp bl, 70
	ja error
	cmp bl, 65
	jae upper
	cmp bl, 57
	ja error
	cmp bl, 48
	jae number
error:
	mov errorcheck, 1
	ret
number:
	sub bl, 48
	jmp L2
upper:
	sub bl, 55
	jmp L2
lower:
	sub bl, 87
L2:
	shl eax, 4
	movzx ebx, bl
	add eax, ebx
	add esi,1
	loop L1
ret
strToHexa ENDP

inputNum PROC
	mov edx, OFFSET str1
	call writeString
	mov ecx, SIZEOF plierStr
	mov edx, OFFSET plierStr
	call readString
	mov lenP, eax
	cmp lenP, 0
	jne L4
	mov errorcheck, 1
	ret
L4:
	mov edx, OFFSET str2
	call writeString
	mov ecx, SIZEOF candStr
	mov edx, OFFSET candStr
	call readString
	mov lenC, eax


	
ret
inputNum ENDP

BitwiseMultiply PROC
	mov ecx, 32
	mov edx, multiplicand
	mov eax, 0
L3:
	shr ebx, 1
	jnc shift
	add eax, edx
shift:
	shl edx, 1
	loop L3
ret
BitwiseMultiply ENDP


END main
exit