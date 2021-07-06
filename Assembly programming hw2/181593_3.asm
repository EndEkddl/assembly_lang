INCLUDE irvine32.inc

.data
str1 BYTE "Type_A_String: ",0
str2 BYTE "A_Word_For_Search: ",0
found BYTE "Found",0
notFound BYTE "Not found",0
bye BYTE "Bye!",0
input BYTE 42 DUP(?)
key BYTE 42 DUP(?)
temp BYTE 42 DUP(?)
len DWORD 0
lenK DWORD 0
check DWORD 0

.code
main PROC
L0:
	call proc1

	cmp len, 41
	jae L0

	cmp len, 0
	je Finish

inputKey:
	call proc2

	cmp lenK, 41
	jae inputKey

	call searchWord
	cmp check, 0
	je no
yes:
	mov edx, OFFSET found
	call WriteString
	call Crlf
	jmp L0
no:
	mov edx, OFFSET notFound
	call WriteString
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
	mov ecx, SIZEOF input
	mov edx, OFFSET input
	call ReadString
	mov len, eax
ret
proc1 ENDP
	
proc2 PROC
	mov edx, OFFSET str2
	call WriteString
	mov ecx, SIZEOF key
	mov edx, OFFSET key
	call ReadString
	mov lenK, eax
ret
proc2 ENDP

searchWord PROC
	mov ecx, len
	mov ebx,-1 ; input
reset : 
	mov esi, 0 ; key
	inc ebx
L1:							;compare input and key
	mov al, input[ebx]
	cmp al, key[esi]
	jne L2;if(input[ebx] != key[esi])
	mov eax, lenK
	sub eax, 1
	cmp esi, eax
	je yes1

	inc ebx
	inc esi
	loop L1

	mov ecx, len			;i=len-ebx-1
	sub ecx, ebx
	sub ecx, 1
L2:							;search space
	mov esi, 0
	inc ebx
	mov al, input[ebx]
	movzx eax, al
	cmp ebx, len
	jae no1
	cmp al, 32
	je reset
	cmp esi, lenK
	je yes1
	loop L2
	
no1:
	mov eax, 0
	mov check, eax
	ret
yes1:
	inc ebx
	cmp input[ebx], 32;input[ebx] == ' '
	je yes2
	cmp ebx, len
	je yes2
	cmp input[ebx], 46
	je yes2
	sub ebx, 1
	jmp L2
yes2:
	mov eax, 1
	mov check, eax
ret
searchWord ENDP

END main
exit