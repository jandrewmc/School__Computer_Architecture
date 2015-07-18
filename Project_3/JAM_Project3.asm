include pcmac.inc
.model small
.8086
.stack 100h

.data

new_line			db 13, 10, '$'

input_radix_prompt	db 'Please enter the input radix in decimal (* to quit): $'
output_radix_prompt	db 'Please enter the output radix in decimal (* to quit): $'
change_radix_prompt	db 'Do you want to change either input or output radix? (y/n, * to quit): $'

number_A_prompt		db 'Enter the number A (* to quit): $'
number_B_prompt 	db 'Enter the number B (* to quit): $'

input_to_large		db 'Your input was too large, enter a value (-32768 <= input <= 32767 decimal): $'
invalid_radix		db 'You entered an invalid radix, please enter a value between 2 and 36: $'
decimal				db ' decimal$'
hex					db ' hex$'
base				db ' base $'

quotient			db ' quotient, $'
remainder			db ' remainder$'
divide_by_zero		db 'Cannot Divide by Zero', 13, 10, '$'

addition_text		db 'A + B = $'
subtraction_text	db 'A - B = $'
multiplication_text db 'A * B = $'
division_text		db 'A / B = $'
exponent_text		db 'A ^ B = $'

input_radix			dw 0
output_radix		dw 0

num_A				dw 0
num_B				dw 0

.code

main proc

			mov		ax, @data
			mov		ds, ax

Get_Radix_Again:

			_putstr input_radix_prompt			;Get Input Radix
			call	Get_Radix_Input
			mov		input_radix, ax

			_putstr output_radix_prompt			;Get Output Radix
			call	Get_Radix_Input
			mov		output_radix, ax

Get_Input_Numbers:

			_putstr number_A_prompt 			;Get First Number
			mov		cx, input_radix
			call	GetRad
			mov		num_A, ax
			sputstr new_line

			_putstr number_B_prompt				;Get Second Number
			mov		cx, input_radix
			call	GetRad
			mov		num_B, ax
			_putstr new_line

			call	Addition
			call	Subtraction
			call	Multiplication
			call	Division
			call	Exponent
						
Invalid_Selection:

			_putstr change_radix_prompt			;Check to see if the user wants to quit, 
			_getch								;enter a new input and output radix,
												;or just new input numbers
			cmp		al, '*'
			je		Done
			
			sputstr new_line

			and		al, 11011111b
			cmp		al, 'Y'
			je		Get_Radix_Again
			cmp		al, 'N'
			je		Get_Input_Numbers
			
			_putstr new_line
			jmp		Invalid_Selection
Done:

			_Exit 0

main endp



;##################################################################################
; Get_Radix_Input: This method handles getting the input and output radix
; Preconditions: None
; Postconditions: Resultant radix in AX


Get_Radix_Input	proc

Get_Radix:

			_SvRegs <cx>
			
			mov		cx, 10
			call	GetRad

			cmp		ax, 2
			jb		Invalid_Radix_Input
			cmp		ax, 36
			ja		Invalid_Radix_Input

			sputstr	new_line
			
			jmp		Done_Radix

Invalid_Radix_Input:
	
			sputstr new_line
			sputstr invalid_radix
			
			jmp		Get_Radix	

Done_Radix:

			_RsRegs <cx>

			ret

Get_Radix_Input	endp



;##########################################################################################
; Output_Result: This method handles outputting the result in the output radix and decimal 
; Preconditions: Result to output in ax 
; Postconditions: None


Output_Result	proc

			_SvRegs <cx>
			mov		cx, output_radix
				
			cmp		cx, 10
			je		out_dec

			call	PutRad

			cmp		cx, 16
			je		out_hex

			push	ax

			sputstr base
			mov		ax, cx
			mov		cx, 10 
			call	PutRad
			sputch  ','
			sputch  ' '

			pop		ax
			
			jmp		out_dec

out_hex:

			sputstr hex
			sputch ','
			sputch ' '

out_dec:

			mov		cx, 10				
			call	PutRad	
			sputstr	decimal
			sputstr	new_line

			_RsRegs <cx>

			ret

Output_Result	endp
		


;####################################################################################
; Addition: Adds the two numbers together and outputs the result
; Preconditions: None
; Postconditions: None	


Addition proc
		
			_SvRegs <ax>

			sputstr addition_text
				
			mov		ax, num_A
			add		ax, num_B

			call	Output_Result

			_RsRegs <ax>

			ret

Addition endp



;####################################################################################
; Subtraction: Subtracts the two numbers and outputs the result
; Preconditions: None
; Postconditions: None


Subtraction proc

			_SvRegs <ax>
			
			sputstr subtraction_text

			mov		ax, num_A
			sub		ax, num_B

			call	Output_Result

			_RsRegs <ax>

			ret

Subtraction endp



;###################################################################################
; Multiplication: Multiplies the two numbers and outputs the result
; Preconditions: None
; Postconditions: None


Multiplication proc

			_SvRegs <ax>

			sputstr multiplication_text

			mov		ax, num_A
			mul		num_B

			call	Output_Result

			_RsRegs <ax>

			ret

Multiplication endp



;###################################################################################
; Division: Divides the two numbers and outputs the result.  Handles divide by zero.
; Preconditions: None
; Postconditions: None


Division proc
		
			_SvRegs <ax, bx, cx, dx>

			sputstr division_text 
			
			mov		bx, num_B
			cmp		bx, 0
			je		Div_Zero

			xor		dx, dx
			mov		ax, num_A
			div		bx	

			mov		cx, output_radix
			cmp		cx, 10
			je		div_dec

			call	PutRad
			sputstr quotient
			xchg	ax, dx
			call	PutRad
			sputstr remainder
			xchg	ax, dx

			cmp		cx, 16
			je		div_hex
			
			push	ax

			sputstr base
			mov		ax, cx
			mov		cx, 10
			call	PutRad
			sputch  ';'
			sputch  ' '
			jmp		div_dec

			pop		ax

div_hex:
			
			sputstr hex
			sputch	';'
			sputch  ' '

div_dec:

			call	PutRad
			sputstr quotient
			xchg	ax, dx
			call	PutRad
			sputstr remainder
			xchg	ax, dx

			sputstr decimal
			sputstr new_line

			jmp		done_div

div_zero:
			
			sputstr divide_by_zero

done_div:

			_RsRegs <dx, cx, bx, ax>

			ret

Division endp



;##################################################################################
; Exponent: Calculates A ^ B and displays the result.  Handles B = 0 and B = 1.
; Preconditions: None
; Postconditions: None


Exponent proc

			_SvRegs <ax, bx, cx>
			
			sputstr exponent_text

			mov		ax, 1
			mov		bx, num_A
			mov		cx, num_B
						
Exponent_Loop:

			jcxz	Exponent_Done	
			 
			mul		bx
			dec		cx

			jmp		Exponent_Loop

Exponent_Done:

			call	output_result

			_RsRegs <cx, bx, ax>

			ret

Exponent endp



;###################################################################################
; GetRad: Gets a 16 bit value from any given input radix between 2 and 36
; Preconditions: Input radix in CX
; Postconditions: Output value in AX


GetRad proc
			
			_SvRegs <bx, cx, dx, si, di>
				
			mov		ah, 08h
			int		21h
			
			cmp		al, '*'
			jne 	Start_GetRad

			_Exit 0
			
Start_GetRad:
						
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
			sputch 	8
			sputch 	' '
			sputch 	8
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
			
			sputstr new_line
			sputstr input_to_large
			jmp GetRad			 

Done:

			mov		ax, bx

			_RsRegs <di, si, dx, cx, bx>

			ret	

GetRad endp

PutRad proc

			;Preconditions: Number to be output in AX, output radix in CX

			_SvRegs <ax, bx, cx, dx, si, di>
	
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
			
			_RsRegs <di, si, dx, cx, bx, ax>

			ret

PutRad endp

end main
