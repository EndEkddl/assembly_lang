INCLUDE irvine32.inc

.data
INCLUDE hw3.inc
andStr BYTE "1. x AND y", 0
orStr BYTE "2. x OR y", 0
notStr BYTE "3. NOT x", 0
xorStr BYTE "4. x XOR y", 0
exitProg BYTE "5. Exit program", 0
enterX BYTE "Enter x : ",0
enterY BYTE "Enter y : ",0
resAND BYTE "Result of x AND y : ",0
resOR BYTE "Result of x OR y : ",0
resNOT BYTE "Result of NOT x : ",0
resXOR BYTE "Result of x XOR y : ",0
chooseMode BYTE "Choose Calculation Mode : ",0
changeMode BYTE "Do you want to change the mode(Y/N)? : ",0
BYE BYTE "Bye!",0
strX BYTE 9 DUP(?)
strY BYTE 9 DUP(?)
stay BYTE 2 DUP(?)
varX DWORD 0
varY DWORD 0
lenX DWORD 0
lenY DWORD 0
errorcheck DWORD 0
mode BYTE 2 DUP(?)
caseTable BYTE '1'
	DWORD andFunc
	Entrysize = ($-caseTable)
	BYTE '2'
	DWORD orFunc
	BYTE '3'
	DWORD notFunc
	BYTE '4'
	DWORD xorFunc
	BYTE '5'
	DWORD endProg
numberOfEntries=($-caseTable) / Entrysize


.code
main PROC
L0:
	call printMenu
	call crlf
L5:
	mov edx, OFFSET chooseMode
	call writeString
	mov ecx, SIZEOF mode
	mov edx, OFFSET mode
	call readString
	movzx eax, mode[0]
	mov ebx, OFFSET caseTable
	mov ecx, numberOfEntries

L6:
	cmp al, [ebx]
	jne L7
	call NEAR PTR [ebx+1]
	call crlf
	jmp L0
L7:
	add ebx, Entrysize
	loop L6
	jmp L5
main ENDP
exit

endProg PROC
	call crlf
	mov edx, OFFSET BYE
	call writeString
	call crlf
exit
endProg ENDP
printMenu PROC

	mov edx, OFFSET andStr
	call writeString
	call crlf
	mov edx, OFFSET orStr
	call writeString
	call crlf
	mov edx, OFFSET notStr
	call writeString
	call crlf
	mov edx, OFFSET xorStr
	call writeString
	call crlf
	mov edx, OFFSET exitProg
	call writeString
	call crlf

ret
printMenu ENDP

strToHex PROC
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
	inc esi
	loop L1

ret
strToHex ENDP

andFunc PROC
startAnd:
	call crlf

backX1:
	mov errorcheck, 0
	mov edx, OFFSET enterX
	call writeString

	mov ecx, SIZEOF strX
	mov edx, OFFSET strX
	call readString
	mov lenX, eax
	mov ecx, lenX
	call strToHex

	cmp errorcheck, 1
	je backX1
	mov varX, eax

backY1:
	mov errorcheck, 0
	mov edx, OFFSET enterY
	call writeString

	mov ecx, SIZEOF strY
	mov edx, OFFSET strY
	call readString
	mov lenY, eax
	mov ecx, lenY
	call strToHex

	cmp errorcheck,1
	je backY1
	mov varY, eax
	mov eax, varX
	and eax, varY
	mov edx, OFFSET resAND
	call writeString

	mov ebx, TYPE DWORD
	call writeHex
	call crlf
	call crlf

	mov edx, OFFSET changeMode
	call writeString
	mov ecx, SIZEOF stay
	mov edx, OFFSET stay
	call readString

	mov esi,0
	cmp stay[esi], 78
	je startAnd
ret
andFunc ENDP

orFunc PROC
startOr:
	call crlf

backX2:
	mov errorcheck, 0
	mov edx, OFFSET enterX
	call writeString

	mov ecx, SIZEOF strX
	mov edx, OFFSET strX
	call readString
	mov lenX, eax
	mov ecx, lenX
	call strToHex
	cmp errorcheck, 1
	je backX2
	mov varX, eax

backY2:
	mov errorcheck, 0
	mov edx, OFFSET enterY
	call writeString

	mov ecx, SIZEOF strY
	mov edx, OFFSET strY
	call readString
	mov lenY, eax
	mov ecx, lenY

	call strToHex
	cmp errorcheck, 1
	je backY2

	mov varY, eax
	mov eax, varX
	or eax, varY
	mov edx, OFFSET resOR
	call writeString

	mov ebx, TYPE DWORD
	call writeHex
	call crlf
	call crlf

	mov edx, OFFSET changeMode
	call writeString
	mov ecx, SIZEOF stay
	mov edx, OFFSET stay
	call readString

	mov esi,0
	cmp stay[esi], 78
	je startOr
ret
orFunc ENDP

notFunc PROC
startNot:
	call crlf
backX3:
	mov errorcheck, 0
	mov edx, OFFSET enterX
	call writeString

	mov ecx, SIZEOF strX
	mov edx, OFFSET strX
	call readString
	mov lenX, eax
	mov ecx, lenX
	call strToHex
	cmp errorcheck, 1
	je backX3

	neg eax
	mov varX, eax
	mov eax, varX
	mov edx, OFFSET resNOT
	call writeString

	mov ebx, TYPE DWORD
	call writeHex
	call crlf
	call crlf

	mov edx, OFFSET changeMode
	call writeString
	mov ecx, SIZEOF stay
	mov edx, OFFSET stay
	call readString

	mov esi,0
	cmp stay[esi], 78
	je startNot
ret
notFunc ENDP

xorFunc PROC
startXor:
	call crlf

backX4:
	mov errorcheck, 0
	mov edx, OFFSET enterX
	call writeString

	mov ecx, SIZEOF strX
	mov edx, OFFSET strX
	call readString
	mov lenX, eax
	mov ecx, lenX
	call strToHex
	cmp errorcheck, 1
	je backX4
	mov varX, eax
backY4:
	mov errorcheck, 0
	mov edx, OFFSET enterY
	call writeString

	mov ecx, SIZEOF strY
	mov edx, OFFSET strY
	call readString
	mov lenY, eax
	mov ecx, lenY
	call strToHex

	cmp errorcheck, 1
	je backY4
	mov varY, eax
	mov eax, varX
	xor eax, varY
	mov edx, OFFSET resXOR
	call writeString

	mov ebx, TYPE DWORD
	call writeHex
	call crlf
	call crlf
	mov edx, OFFSET changeMode
	call writeString
	mov ecx, SIZEOF stay
	mov edx, OFFSET stay
	call readString

	mov esi,0
	cmp stay[esi], 78
	je startXor
ret
xorFunc ENDP

END main