	.686
	.MMX
	.XMM
	.model	flat,stdcall
	option	casemap:none
	.code
	
	include kernel32.inc
	includelib kernel32.lib

main proc
;enter code here
	main endp
	
;����� ���������� ����� �������� � �������� edi
;����� ������� ��������� ��� ������� - � esi
getInstruction proc
	
	call getPrefix
	
	mov ebx, 0
	start:
		lodsb
		push ebx ;��������� ������� ���������
		shl ebx, 9 ;�������� �� ������ ������� � ��� �� 2, ������ ��� ������ � ������� 2 �����
		shl eax, 1 ; �� ����������� ������� �������� ������� ���� �� 2
		add eax, ebx ;�������� ��������, �� �������� �������� ��������� ���������
		mov ebx, [esi + eax] ;�������� �������� ���������
		or ebx, ebx ;���������� ��� � 0
		jnz start
		pop ebx 
	;����������� ������ �������
	;���� ������� �� ��� ���-��
	;�, ��������, �������������� ����
getInstruction endp

getPrefix proc

getPrefix endp
	
end main