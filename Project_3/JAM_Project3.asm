include pcmac.inc
.model small
.8086
.stack 100h

.data

new_line			db 13, 10, '$'

input_radix_prompt	db 'Please enter the input radix in decimal (q to quit): $'
output_radix_prompt	db 'Please enter the output radix in decimal (q to quit): $'
change_radix_prompt	db 'Do you want to change either input or output radix? (y/n): $'

number_A_prompt		db 'Enter the number A: $'
number_B_prompt 	db 'Enter the number B: $'

input_to_large		db 'Your input was too large, enter a value (-32768 <= input <= 32767 decimal): $'

input_radix			dw 0
output_radix		dw 0

current_radix		dw 0

input				db 'Input: $'
output				db 'Output: $'

.code
			extern putdec:near, puthex:near
main proc

			mov		ax, @data
			mov		ds, ax

			_putstr input_radix_prompt
			mov		cx, 10
			call	GetRad
			mov		[input_radix], ax
			_putstr	new_line

			_putstr output_radix_prompt
			mov		cx, 10
			call	GetRad
			mov		[output_radix], ax
			_putstr new_line

Loop_Here:

			_putstr input
			mov		cx, input_radix
			call	GetRad
			sputstr new_line

			sputstr output
			mov		cx, output_radix
			call	PutRad
			_putstr new_line

			jmp		Loop_Here

			_Exit 0

main endp

GetRad proc
			
			xor 	ax, ax	
			xor		bx, bx
			xor		dx, dx
			xor		si, si
			xor		di, di
				
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

			xor		dx, dx
			xor		ah, ah
			xchg	ax, bx
			mul		cx
			cmp		dx, 0
			jne		Oversized_Value
			add		bx, ax
			jmp		Get_Input

Invalid_Input:

			cmp		al, 8
			je		Handle_Backspace
			cmp		al, 13
			je		End_Get
			jmp		Get_Input

Handle_Backspace:
			
			xor		dx, dx
			mov		ax, bx
			div		cx
			mov		bx, ax
			_putch 	8
			_putch 	' '
			_putch 	8
			xor		ax, ax
			xor		dx, dx
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
			
			_putstr new_line
			_putstr input_to_large
			jmp GetRad			 

Done:

			mov		ax, bx

			ret	

GetRad endp

PutRad proc

			;Preconditions: Number to be output in AX, output radix in CX

			xor		bx, bx
			xor		dx, dx
			xor		si, si
			xor		di, di

			mov		di, cx
			xor		cx, cx
				
			test	ah, 10000000b
			jz		Process_Number
			sputch  '-'
			neg		ax	
					
Process_Number:

			xor		dx, dx
			div		di	
			push	dx
			inc		cx	
			cmp		ax, 0
			jne		Process_Number	
	
Output_Number:
		
			jcxz	Done_Put
			
			pop		ax
			dec		cx	
			cmp		ax, 10 
			jb		Numeric_Output

			add		al, 55

			jmp		Print_Number
			
Numeric_Output:
	
			add		al, '0'

Print_Number:

			_putch al

			jmp		Output_Number	
			
Done_Put:	

			ret

PutRad endp

end main
