	.686
	.MMX
	.XMM
	.model	flat,stdcall
	option	casemap:none
	
	BSIZE equ 15
	
	include user32.inc
	includelib user32.lib
	include kernel32.inc
	includelib kernel32.lib
	
	.data
	ifmt	db "%0lu", 0
	outp	db BSIZE dup(?)
	
;disasm PROTO :dword, :dword, :dword
	
	.code
public disasm 
	disasm proc byteAddress, tableAddress, count
	;���� ��� �������� � ������� ��� ���������: ����� ������� �����, ����� ������� ���������, ���������� ��������
	;��������� �������� ��������� ���������
	push ebp
	push esi
	push edi
	
	mov ecx, count
	mov edi, byteAddress
	mov esi, tableAddress
	push ecx ;��������� ���������� ��������, ��� ���������� �����
	qwer:
		call getInstruction
		;������ �� ������ ������� - ������������ ����. ����� ����� ����� ������ �������
		;push eax
	loop qwer
	pop ecx
	
	invoke GetStdHandle, -11
	
	;print:
	;	pop ebx
	;	invoke	wsprintf, addr outp, addr ifmt, ebx
	;	invoke	WriteConsoleA, eax, addr outp, 10, 0, 0
	;loop print
	
	
	;��������������� �������� ��������� ���������
	pop edi
	pop esi
	pop ebp
	
	ret
	disasm endp
	
;����� ���������� ����� �������� � �������� edi
;����� ������� ��������� ��� ������� - � esi
getInstruction proc
	
	call getPrefix
	
	mov ebx, 0
	instructionStart:
		lodsb
		mov edx, ebx ;��������� ������� ���������
		shl ebx, 9 ;�������� �� ������ ������� � ��� �� 2, ������ ��� ������ � ������� 2 �����
		shl eax, 1 ; �� ����������� ������� �������� ������� ���� �� 2
		add eax, ebx ;�������� ��������, �� �������� �������� ��������� ���������
		mov ebx, [esi + eax] ;�������� �������� ���������
		or ebx, ebx ;���������� ��� � 0
		jnz instructionStart
		mov eax, edx;���������� ��������� �� ������� ���������
	;����������� ������ �������
	;�, ��������, ���� �������������� ����
	ret
getInstruction endp

getPrefix proc
		cld
	prefixStart:	
		mov ecx, 11 ;���������� ���������
		;REPNE SCAS m16 Find AX, starting at ES:[(E)DI]
		;Compare AL with byte at ES:(E)DI or RDI then set status flags
		repe scasb
		;repne scasb
		;jnz q
		jz prefixStart
		;set bit
		;jmp start
	q:	ret
getPrefix endp
	
end disasm