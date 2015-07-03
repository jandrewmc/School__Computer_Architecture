.model small 
.8086
.stack 100h
.data
max_size db 51 
actual_size db ' '
string_input db '$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'

.code

	extern putdec : near

testBufferString proc

	mov		ax, @data
	mov		ds, ax

	mov		dx, offset max_size
	mov		ah, 0ah
	int		21h

	mov		bx, offset actual_size
	mov		al, [bx]
	xor		ah, ah
	call	PutDec

	mov		dx, offset string_input
	mov		ah, 9h
	int		21h

	mov		ah, 4ch
	int		21h

testBufferString endp
end testBufferString
