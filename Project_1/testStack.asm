.model small
.8086
.stack 100h
.data
.code
	extern Puthex : NEAR
testStack	proc
			mov		ax, @data
			mov		ds, ax

			mov		ax, 01234h
			mov		bx, 05678h
			mov		cx, 09abch
			mov		dx, 0def0h
			
			push	dx
			push	cx
			push	bx
			push	ax

			mov		bp, sp

			mov		ax, [bp]
			call	puthex
			inc		bp
			inc		bp
			mov		ax, [bp]
			call	puthex
			inc		bp
			inc		bp
			mov		ax, [bp]
			call	puthex
			inc		bp
			inc		bp
			mov		ax, [bp]
			call	puthex

			mov		ah, 4ch
			int		21h
teststack	endp
			end teststack
