INCLUDE irvine32.inc

.data
str1 BYTE "Type_A_String_To_Reverse: ",0
str2 BYTE "Reversed_String: ",0
bye BYTE "Bye!",0
userInput BYTE 42 DUP(?)
len DWORD 0
.code
main PROC
L0:
	 mov edx, OFFSET str1
	 call WriteString
	 mov ecx, SIZEOF userInput
	 mov edx, OFFSET userInput
	 call ReadString

	 mov len, eax

	 cmp len, 41
	 jae L0
	 
	 cmp len, 0
	 je Finish

	 call changeStr
	 
loop L0

Finish:
	 mov edx, OFFSET bye

	 call WriteString
	 call Crlf

	
main ENDP

changeStr PROC
	 mov ecx, len
	 mov esi, 0
L1:
	 movzx eax, userInput[esi]
	 cmp eax, 65
	 jae L2
	 jmp store
L2:
	 cmp eax, 90
	 jbe capital
L3:	 
	 cmp eax, 97
	 jae L4
	 jmp store
capital:
	 add eax, 32
	 jmp store
L4:
	 cmp eax, 122
	 jbe lower
	 jmp store

lower:
	 sub eax, 32
store:
	 push eax
	 inc esi
	 Loop L1
	
	 mov edx, OFFSET str2
	 call WriteString
	 mov ecx, len
	 mov esi, 0
L5:
	 pop eax
	 call WriteChar
	 Loop L5
	 call Crlf

	 ret
changeStr ENDP
END main
