.model huge
.386
.stack 100h
.data
.code
testcall proc

mov		ax, @data
mov		ds, ax

mov		ax, 0
mov		es, ax

jmp far ptr   0000

mov		ah, 4ch
int		21h
testcall endp
		end testcall
