.model small
.8086
.stack 100h
.data
string_this db 'this is a string $'
.code
testmemory proc
	mov		ax, @data
	mov		ds, ax

	mov		bx, offset string_this

	mov		dx, [bx]

	mov		ah, 02h
	int		21h
	mov		dl, dh
	int		21h

	mov		cx, 'b'
	mov		[bx], cx

	mov		dx, [bx]

	mov		ah, 02h
	int		21h
	mov		dl, dh
	int		21h


	mov		ah, 4ch
	int		21h
testmemory endp
end testmemory
