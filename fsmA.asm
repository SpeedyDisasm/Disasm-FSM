	.686
	.MMX
	.XMM
	.model	flat,stdcall
	option	casemap:none
	
	BSIZE equ 15
	PrC equ 13 ;prefix count
	PREFIXSTATE equ 17 ;state count in prefix fsm
	
	include user32.inc
	includelib user32.lib
	include kernel32.inc
	includelib kernel32.lib
	
	.data
	include prefix_state_table.dat ;prefixState
	include prefix_signal_table.dat;prefixSignal
	include state_table.dat ;opcodeState
	include signal_table.dat ;opcodeSignal
	;include modRM_and_immediate_table.dat ;AvailabilityModrmImm
	;include modRM_state_table.dat ;modrmState
	
public disasm 
	.code
	disasm proc byteAddress, count
	;4 parameters: first byte address, state table address, prefix state table iteration count
	push ebp

	mov esi, byteAddress
	mov ecx, count
	mov eax, 0
	pre:
		mov al, [esi]
		cmp eax, 0b9h
	je q
		add esi, 1
	jmp pre
	q:

	lfence
	rdtsc
	cld
	push eax
	push edx
	mov eax, 0
	mov al, [esi]
		qwer:
			push ecx
				call getInstruction
			pop ecx
		loop qwer
		rdtsc
		mov ebx, eax
		mov ecx, edx
	pop edx
	pop eax
	sub ebx, eax
	sub ecx, edx
	mov edx, ebx
	mov eax, ebx
	pop ebp
	ret
disasm endp

;next byte address in esi
getInstruction proc 
;prefix
		mov edx, 0
		mov ebx, 15 ;начальное состояние: 15
		jmp start
	prefixStart:
		mov al, [esi]
		add esi, 1
	start:
		mov dl, prefixSignal[eax*2+ebx]
		mov bx, prefixState[eax*2+ebx]
		cmp edx, 16 ;сигнал равный 16 значит что разбор не окончен
		je prefixStart
		mov ebx, edx
		shl ebx, 9
;opcode
	opcodeStart:
		mov al, [esi]
		add esi, 1
		mov dl, opcodeSignal[eax*2+ebx]
		mov ebx, opcodeState[eax*2+ebx]
		cmp edx, 16
		je opcodeStart
		add esi, edx
		mov al, [esi]
endOfWork:
	ret
getInstruction endp

end
