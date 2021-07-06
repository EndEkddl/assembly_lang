INCLUDE irvine32.inc

.data
str1 BYTE "Enter a plain text : ",0
str2 BYTE "Enter a key : ",0
str3 BYTE "Original Text : ",0
str4 BYTE "Encrypted Text : ",0
str5 BYTE "Decrypted Text : ",0
bye BYTE "Bye!",0
plain BYTE 42 DUP(?)
key BYTE 11 DUP(?)
lenP DWORD 0
lenK DWORD 0

.code
main PROC
L0:
	call proc1

	cmp lenP, 41
	jae L0

	cmp lenP, 0
	je Finish

inputKey:
	call proc2

	cmp lenK, 0
	je inputKey

	call proc3
	mov edx, OFFSET str4
	call WriteString
	call xorFunc
	call proc4
	call xorFunc
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
	mov ecx, SIZEOF key
	mov edx, OFFSET key
	call ReadString
	mov lenK, eax
	call Crlf
ret
proc2 ENDP

proc3 PROC
	mov edx, OFFSET str3
	call WriteString
	mov edx, OFFSET plain
	call WriteString
	call Crlf
	ret
proc3 ENDP

xorFunc PROC
	mov ecx, lenP
	mov ebx, 0
reset:
	mov esi, 0
L1:
	cmp esi, lenK
	je reset
	mov al, key[esi]
	mov dl, plain[ebx]
	XOR al, dl
	mov plain[ebx], al
	inc esi
	inc ebx
	loop L1
	mov edx, OFFSET plain
	call WriteString
	call Crlf
	ret
xorFunc ENDP

proc4 PROC
	mov edx, OFFSET str5
	call WriteString
	ret
proc4 ENDP

END main
exit