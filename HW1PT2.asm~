.model small
.8086
.stack 100h
.code
hw1pt2 	proc
		mov		bh, 0
		sub		Si, 6d
		mov		di, 23abh
		add		cx, 16d
Label1: mov		al, [si]
		Or		al, 30h
		cmp		bh, 1
		jz		Label3
		test	al, 30h
		jnz		Label2
		mov		al, ' '
		jmp		Label3
Label2:	mov		bh, 1
Label3: mov		[di], al
		Dec		si
		Dec		byte ptr [di]
		cmp		cx, 3d
		jle		Label4
		mul		di
Label4: Loop	Label1

		mov		ah, 4ch
		int		21h
hw1pt2	endp
		end	hw1pt2
