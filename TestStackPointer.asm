.model	small
.8086
.stack	100h
.data
.code
	extern	PutHex : NEAR
TestStackPointer	proc

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
					
					xor		ax, ax
					xor		bx, bx
					xor		cx, cx
					xor		dx, dx



					mov		ax, [bp]
					call	PutHex
					inc		bp
					inc		bp

					mov		ax, [bp]
					call	putHex
					inc		bp
					inc		bp

					mov		ax, [bp]
					call	putHex
					inc		bp
					inc		bp

					mov		ax, [bp]
					call	putHex
				
					mov		ah, 4ch
					int		21h
TestStackPointer	endp
					end TestStackPointer
