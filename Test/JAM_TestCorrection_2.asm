include pcmac.inc
.model small
.386
.stack 100h
.data

formula				db 'Output_Number = B * (Input_Number ^ N) + A$'
new_line			db 13, 10, '$'

B_prompt					db 'B = $'
input_number_prompt 		db 'Input_Number = $'
N_prompt					db 'N = $'
A_prompt					db 'A = $'

B							dw 0
Input_Number				dw 0
N							dw 0
A							dw 0
Output_Number				dw 0

.code
	extern getdec:near, putdec:near
main	proc
		_begin

		sputstr B_prompt
		call	getdec
		mov		si, ax

		sputstr input_number_prompt
		call	getdec
		mov		bx, ax

		sputstr	N_prompt
		call	getdec
		mov		cx, ax

		mov		ax, 1

TheLoop:

		jcxz	Done
		
		mul		bx
		dec		cx

		jmp		TheLoop

Done:

		mul		si
		
		xchg	ax, bx
		
		sputstr A_prompt
		call	getdec	
		add		ax, bx

		mov		Output_Number, ax

		call	putdec

		_exit 0
main	endp
end	main
