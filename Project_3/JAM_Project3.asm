include pcmac.inc
.model small
.8086
.stack 100h

.data

input_radix_prompt	db 'Please enter the input radix in decimal (q to quit): $'
output_radix_prompt	db 'Please enter the output radix in decimal (q to quit): $'
change_radix_prompt	db 'Do you want to change either input or output radix? (y/n): $'

number_A_prompt		db 'Enter the number A: $'
number_B_prompt 	db 'Enter the number B: $'

input_to_large		db 'Your input was too large, enter a value (-32768 <= input <= 32767 decimal): $'

input_radix			dw 0
output_radix		dw 0
.code
			extern putdec:near, puthex:near
main proc

			mov		ax, @data
			mov		ds, ax

			mov		cx, 10
			call	GetRad
			call	putdec
			mov		cx, 16
			call	GetRad
			call	PutHex	
		

			_Exit 0
main endp

GetRad proc
			
			xor		bx, bx
					
			mov		ah, 08h
			int		21h
			
			cmp		al, '-'
			jne		Not_Neg
			mov		di, 1
	
			mov		dl, al
			mov		ah, 02h
			int		21h
			
Get_Input:
			mov		ah, 08h
			int		21h		
Not_Neg:

			cmp		cx, 10
			jle		Numeric_Radix

Alpha_Numeric_Radix:

			cmp		al, '0'
			jb		Invalid_Input
			cmp		al, '9'
			ja		Check_Letters
			
			mov		dl, al
			mov		ah, 02h
			int		21h

			sub		al, '0'
			
			jmp		Calculate_Value
				
Check_Letters:

			mov		dx, cx	
			add		dx, 54

			cmp		al, 'A'
			jb		Invalid_Input
			and		al, 11011111b
			cmp		al, dl
			ja		Invalid_Input

			mov		dl, al
			mov		ah, 02h
			int		21h

			sub		al, 55

			jmp		Calculate_Value

Numeric_Radix:
	
			mov		dx, cx
			add		dx,	'0'
			dec		dx 
			
			cmp		al, '0'
			jb		Invalid_Input
			cmp		al, dl
			ja		Invalid_Input
			
			mov		dl, al	
			mov		ah, 02h
			int		21h

			sub		al, '0'

Calculate_Value:
			xor		ah, ah
			xchg	ax, bx
			mul		cx
			add		bx, ax
			jmp		Get_Input

Invalid_Input:

			cmp		al, 13
			je		End_Get
			jmp		Get_Input
			
End_Get:
			
			cmp		di, 1
			jne		Size_Var
			cmp		bx, 32768
			ja		Oversized_Value
			je		Special_Case
			neg		bx
			jmp		Done

Size_Var:

			cmp		bx, 32767
			ja		Oversized_Value
			jmp		Done
	
Special_Case:

			mov		bx, 32768
			jmp		Done

Oversized_Value:

			_putstr input_to_large
			jmp GetRad			 

Done:

			mov		ax, bx
			ret	
GetRad endp

end main
