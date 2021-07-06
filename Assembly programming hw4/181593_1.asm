INCLUDE irvine32.inc

.data
str1 BYTE "Enter a plain text : ",0
str2 BYTE "Enter a key : ",0
str3 BYTE "Original Text : ",0
str4 BYTE "Encrypted Text : ",0
str5 BYTE "Decrypted Text : ",0
bye BYTE "Bye!",0
plain BYTE 42 DUP(?)
arr SBYTE 33 DUP(?)
key SBYTE 11 DUP(?)
check BYTE 0
reverse BYTE 0
lenP DWORD 0
lenA DWORD 0
lenK DWORD 0

.code
main PROC
L0:
	call proc1		;read plain

	cmp lenP, 41
	jae L0

	cmp lenP, 0
	je Finish

inputKey:
	call proc2		;read key
	call atoi
	cmp lenA, 0
	je inputKey

	mov eax, lenK
	call dumpregs

	mov eax, lenK
	call proc3		;write plain 
	mov edx, OFFSET str4
	call WriteString
	call rotatePlain	;encrypt plain
	mov reverse, 1
	call proc4
	call rotatePlain	;decrpyt plain
	mov reverse, 0
	call Crlf
	loop L0

Finish:
	mov edx, OFFSET bye
	call WriteString
	call Crlf
	INVOKE ExitProcess, 0
main ENDP

proc1 PROC
	mov edx, OFFSET str1
	call WriteString
	mov ecx, SIZEOF plain
	mov edx, OFFSET plain
	call ReadString
	mov lenP, eax

ret
proc1 ENDP

proc2 PROC

	mov edx, OFFSET str2
	call WriteString
	mov ecx, SIZEOF arr
	mov edx, OFFSET arr
	call ReadString
	mov lenA, eax
	call Crlf

ret
proc2 ENDP

atoi PROC

push eax
push ebx
push ecx
push edx

mov ebx, 0	;key index
mov esi, 0	;arr index
mov eax, 0	;res
mov ecx, 0

atoi1:
	cmp esi, lenA
	jae endAtoi
	cmp arr[esi], 32	;' '
	je blank
	cmp arr[esi], 45	;'-'
	je minus
	jmp number
minus:
	mov check, 1
	jmp indexInc
blank: 
	mov cl, check
	cmp cl, 1
	jne plus
	neg eax
plus:
	mov check, 0
	mov key[ebx], al
	inc ebx
	mov eax, 0
	jmp indexInc
number:
	imul eax, 10
	movzx edx, arr[esi]
	sub edx, 48
	add eax, edx
	inc esi
	jmp atoi1
indexInc:
	inc esi
	jmp atoi1
endAtoi:
	cmp cl,1
	jne plus1
	neg eax
plus1: 
	mov check, 0
	mov key[ebx], al
	inc ebx
	mov lenK, ebx
pop edx
pop ecx
pop ebx
pop eax
	
ret
atoi ENDP

proc3 PROC
	mov edx, OFFSET str3
	call WriteString
	mov edx, OFFSET plain
	call WriteString
	call Crlf
	ret
proc3 ENDP

rotatePlain PROC

	mov ebx, 0	;plain index
reset:
	mov esi, 0	;key index

L1:
	cmp ebx, lenP
	jae L1Exit
	cmp esi, lenK
	jae reset
	mov cl, key[esi]
	mov dl, plain[ebx]

	cmp reverse, 1
	je backward

	cmp cl,0
	jl left
right:
	ror dl, cl
	jmp L2
left:
	neg cl
	rol dl, cl
	jmp L2

backward:
	cmp cl, 0
	jl backRight
	rol dl, cl
	jmp L2

backRight:
	neg cl
	ror dl, cl
L2:
	mov plain[ebx], dl
	inc esi
	inc ebx
	mov ecx, 10
	loop L1

L1Exit:
	mov edx, OFFSET plain
	call WriteString
	call Crlf
	ret
rotatePlain ENDP

proc4 PROC
	mov edx, OFFSET str5
	call WriteString
	ret
proc4 ENDP

END main
exit