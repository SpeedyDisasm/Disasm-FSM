;@goto -)
		.686
		.MMX
		.XMM
		.model	flat,stdcall
		option	casemap:none
		COUNT equ 100000

include kernel32.inc
includelib kernel32.lib

		.code
main proc

commands MACRO
		rept COUNT
			db 0B9h, 068h, 000h, 0DCh, 000h ;MOV ECX,fsm.00DC0068
			db 0A1h, 0DCh, 01Bh, 0DCh, 000h ;MOV EAX,DWORD PTR DS:[DC1BDC]
			db 0E8h, 0F4h, 025h, 000h, 000h ;CALL fsm.00DA3A4D
			endm
		endm
	
		commands
		invoke	ExitProcess, 0
		main endp
end main

:-)
@echo off
for %%A in (ml.exe,link.exe) do if "%%~$path:A"=="" call vspath
ml /nologo /c /coff %1 %~f0
link /merge:.rdata=.text /subsystem:console /nologo %~dpn0.obj
del %~dpn0.obj
