.model small
.8086
.stack 100h
.data

Output_number dw 0
Input_number dw 2
A dw 5
B dw 7
N dw 3

.code
	extern PutDec : near
TestExp	PROC

		mov		ax, @data
		mov		ds, ax

		mov		cx, N
		mov		ax, Input_number
		mov		bx, ax
		dec		cx
cont_mul: 	mul		bx
		dec		cx
		jnz		cont_mul
		mul		B
		add		ax, A
		mov		output_number, ax
		
		mov		ax, output_number
		call	PutDec
				

		mov		ah, 4ch
		int		21h

TestExp	Endp
		End		TestExp	
