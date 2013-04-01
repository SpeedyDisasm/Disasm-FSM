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
	include prefix_state_table.dat ;opcodeState
	include prefix_signal_table.dat;opcodeSignal
	include state_table.dat ;prefixState
	include modRM_and_immediate_table.dat ;AvailabilityModrmImm
	include modRM_state_table.dat ;modrmState
	
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
		cmp eax, 69h
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
		mov dx, prefixSignal[eax*2+ebx]
		mov bx, prefixState[eax*2+ebx]
		test edx, edx ;compare state and 0
		jz prefixStart
		cmp edx, 10 ;check mandatory prefix state
		ja prefixQuit
		sub esi, 1
		mov al, [esi]
	prefixQuit:
	mov ecx, edx ;save prefix state

;opcode
		mov ebx, 0
		opcodeStart:
				mov edx, ebx ;keep current state 
				;сохраняем текущее состояние
				;умножаем на ширину таблицы
				shl edx, 9 ;9 - if size of the cell of state table is 2 byte
				;получаем смещение, по которому хранится следующее состояние
				mov bx, opcodeState[eax*2 + edx] ;take the next state
				;получаем следующее состояние
				test ebx, ebx ;compare state and 0
				;сравниваем его с 0
				jz exit
			mov al, [esi]
			add esi, 1
				jmp opcodeStart
		exit:
	pop ebx ;load prefix state
	
;modRM
	;здесь ошибка: добавляю я не просто состояние префиксов, а смещение. А использую, так, будто добавляю состояние
	;в текущем тесте это неважно, префиксов тут нет, но как только заработает то что есть - надо поправить
	add ebx, edx
	mov edx, 0
	mov ecx, 0
	mov dx, AvailabilityModrmImm[ebx]
	mov cl, modrmState[edx + eax]
	add esi, ecx
imm:
	mov dx, AvailabilityModrmImm[ebx + PREFIXSTATE]
	add esi, edx
	mov al, [esi]
endOfWork:
	ret
getInstruction endp

end
