.model small
.8086
.stack 100h
.data
.code
HW0PT3	proc
		mov		ax, @data
		mov		ds, ax

		mov		ax, ds
		mov		bx, 0010h

		call	FillDS

		mov		ah, 4ch
		int		21h
HW0PT3	endp	
FillDS	proc

		xor		di, 0
		mov		ds, ax
		mov		cx, 0
		mov		dx, 1
SetZeros:			
		mov		ds:[di], cx
		inc		di
		inc		di
		cmp		di, bx
		jge		SetupOnes
		jmp		SetZeros
SetupOnes:
		mov		di, bx
		test	bx, 1
		jz		Set_Ones
		mov		ds:[di], dl
		inc		di
Set_Ones:
		mov		ds:[di], dx
		inc		di
		inc		di
		cmp		di, 0
		je		Done
		jmp		Set_Ones
Done:
		ret	
FillDS	endp
		end	HW0PT3
