.model	small
.8086
.stack	100h
.data

max_val	dw	0ffffh

.code
testAdd	proc
		extern	PutHex : near
		mov		ax, @data
		mov		ds, ax

		mov		ax, max_val
		mov		bx, 0000ch
		mul		bx

		push	ax
		push	dx

		clc

		pop		dx
		pop		ax

		add		ax, max_val
		adc		dx, 0

		push	ax
		push	dx

		pop		ax
		call	PutHex

		pop		ax
		call	PutHex
		
		mov		ah, 4ch
		int		21h
testAdd	endp
		end	testAdd
