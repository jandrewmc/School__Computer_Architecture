include pcmac.inc
.model small
.386
.stack 100h
.data
summation	dw ?
.code
	extern putdec:near
main	proc
		_begin

		mov		cx, 50
		xor		ax, ax
sum:
		add		ax, cx
		dec		cx
		jnz		sum
		
		mov		summation, ax

		call	putdec

		_exit 0		
main	endp
	end main
