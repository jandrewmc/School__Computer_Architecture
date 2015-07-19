include pcmac.inc
.model small
.8086
.stack 100h
.data
new_line db 13, 10, '$'
.code
extern putudec:near, putdec:near
main proc
	mov		ax, @data
	mov		ds, ax

	xor		dx, dx
	mov		ax, 255
	neg		ax
	mov		bx, 2
	div		bx
	call	putdec
	_putstr new_line

	xor		dx, dx
	mov		ax, 255
	neg		ax
	mov		bx, 2
	idiv	bx
	call	putdec
	_putstr new_line

	xor		dx, dx
	mov		ax, 255
	neg		ax
	mov		bx, 2
	neg		bx
	div		bx
	call	putudec
	_putstr new_line

	xor		dx, dx
	mov		ax, 255
	neg		ax
	mov		bx, 2
	neg		bx
	idiv	bx
	neg		ax
	call	putudec
	_putstr new_line

	xor 	dx, dx
	mov		ax, 255
	mov		bx, 2
	div		bx
	call	putdec
	mov		ah, 4ch
	int		21h
main endp

end main
