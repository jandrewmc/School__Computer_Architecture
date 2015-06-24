.model large 
.8086
.stack 100h
.data
.code
testBufferString proc

	mov		ax, @data
	mov		ds, ax

theloop:

	mov		ah, 08h
	int		21h

	mov		dl, al
	mov		ah, 02h
	int		21h
	jmp		theloop

	mov		ah, 4ch
	int		21h

testBufferString endp
end testBufferString
