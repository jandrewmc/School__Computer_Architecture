include pcmac.inc
.model small
.8086
.stack 100h

.data

new_line			db 13, 10, '$'

input_radix_prompt	db 'Please enter the input radix in decimal (* to quit): $'
output_radix_prompt	db 'Please enter the output radix in decimal (* to quit): $'
change_radix_prompt	db 'Do you want to change either input or output radix? (y/n) (* to quit): $'

number_A_prompt		db 'Enter the number A (* to quit): $'
number_B_prompt 	db 'Enter the number B (* to quit): $'

input_to_large		db 'Your input was too large, enter a value (-32768 <= input <= 32767 decimal): $'
invalid_radix		db 'You entered an invalid radix, please enter a value between 2 and 36: $'
decimal			db ' decimal$'
hex			db ' hex$'
base			db ' base $'

quotient		db ' quotient, $'
remainder		db ' remainder$'
divide_by_zero		db 'Cannot Divide by Zero', 13, 10, '$'

addition_text		db 'A + B = $'
subtraction_text	db 'A - B = $'
multiplication_text db 'A * B = $'
division_text		db 'A / B = $'
exponent_text		db 'A ^ B = $'

input_radix		dw 0
output_radix		dw 0

num_A			dw 0
num_B			dw 0

.code

main proc

			mov	ax, @data
			mov	ds, ax

Get_Radix_Again:

			_putstr input_radix_prompt			;Get Input Radix
			call	Get_Radix_Input
			mov	input_radix, ax

			_putstr output_radix_prompt			;Get Output Radix
			call	Get_Radix_Input
			mov	output_radix, ax

Get_Input_Numbers:

			_putstr number_A_prompt 			;Get First Number
			mov	cx, input_radix
			call	GetRad
			mov	num_A, ax
			sputstr new_line

			_putstr number_B_prompt				;Get Second Number
			mov	cx, input_radix
			call	GetRad
			mov	num_B, ax
			_putstr new_line
			_putstr new_line

			call	Addition
			call	Subtraction
			call	Multiplication
			call	Division
			call	Exponent
			
			_putstr new_line			

Invalid_Selection:

			_putstr change_radix_prompt			;Check to see if the user wants to quit, 
			_getch								;enter a new input and output radix,
												;or just new input numbers
			cmp	al, '*'
			je	Done
			
			sputstr new_line

			and	al, 11011111b
			cmp	al, 'Y'
			je	Get_Radix_Again
			cmp	al, 'N'
			je	Get_Input_Numbers
			
			_putstr new_line
			jmp	Invalid_Selection
Done:

			_Exit 0

main endp



;##################################################################################
; Get_Radix_Input: This method handles getting the input and output radix
; Preconditions: None
; Postconditions: Resultant radix in AX


Get_Radix_Input	proc

			_SvRegs <cx>
		
Get_Radix:
			
			mov	cx, 10
			call	GetRad

			cmp	ax, 2
			jb	Invalid_Radix_Input
			cmp	ax, 36
			ja	Invalid_Radix_Input

			sputstr	new_line
			
			jmp	Done_Radix

Invalid_Radix_Input:
	
			sputstr new_line
			sputstr invalid_radix
			
			jmp	Get_Radix	

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

			mov	cx, output_radix
				
			cmp	cx, 10
			je	out_dec

			call	PutRad

			cmp	cx, 16
			je	out_hex

			push	ax

			sputstr base
			mov	ax, cx
			mov	cx, 10 
			call	PutRad
			sputch  ','
			sputch  ' '

			pop	ax
			
			jmp	out_dec

out_hex:

			sputstr hex
			sputch ','
			sputch ' '

out_dec:

			mov	cx, 10				
			call	PutRad	
			sputstr	decimal
			sputstr	new_line

			_RsRegs <cx>

			ret

Output_Result	endp
		


;####################################################################################
; Addition: Adds the two numbers together and outputs the result
; Preconditions: A + B where A is var num_A and B is num_B
; Postconditions: None	


Addition proc
		
			_SvRegs <ax>

			sputstr addition_text
				
			mov	ax, num_A
			add	ax, num_B

			call	Output_Result

			_RsRegs <ax>

			ret

Addition endp



;####################################################################################
; Subtraction: Subtracts the two numbers and outputs the result
; Preconditions: A - B where A is a variable named num_A and B is num_B
; Postconditions: None


Subtraction proc

			_SvRegs <ax>
			
			sputstr subtraction_text

			mov	ax, num_A
			sub	ax, num_B

			call	Output_Result

			_RsRegs <ax>

			ret

Subtraction endp



;###################################################################################
; Multiplication: Multiplies the two numbers and outputs the result
; Preconditions: A * B where A is var num_A and B is num_B
; Postconditions: None


Multiplication proc

			_SvRegs <ax>

			sputstr multiplication_text

			mov	ax, num_A
			imul	num_B

			call	Output_Result

			_RsRegs <ax>

			ret

Multiplication endp



;###################################################################################
; Division: Divides the two numbers and outputs the result.  Handles divide by zero.
; Preconditions: A / B where A is var num_A and B is num_B
; Postconditions: None


Division proc
		
			_SvRegs <ax, bx, cx, dx, di>

			xor	dx, dx
			xor	di, di

			sputstr division_text 
			
			mov	ax, num_A
			mov	bx, num_B

			cmp	bx, 0				;For some reason idiv was giving
			je	Div_Zero			;erroneous results.  This is the
			jg	Check_AX_For_Sign	;work around.
			
			inc	di					;track negatives in di
			neg	bx

Check_AX_For_Sign:

			cmp	ax, 0
			jg	Divide_vals	
			
			inc	di
			neg	ax	

Divide_vals:

			div	bx	

			cmp	di, 1				;if only 1 negative, result is 
			jne	div_output			;negative, otherwise, positive.

			neg	ax
			
div_output:

			mov	cx, output_radix
			cmp	cx, 10
			je	div_dec

			call	PutRad
			sputstr quotient
			xchg	ax, dx
			call	PutRad
			sputstr remainder
			xchg	ax, dx

			cmp	cx, 16
			je	div_hex
			
			push	ax

			sputstr base
			mov	ax, cx
			mov	cx, 10
			call	PutRad
			sputch  ';'
			sputch  ' '

			pop	ax

			jmp	div_dec

div_hex:
			
			sputstr hex
			sputch	';'
			sputch  ' '

div_dec:
		
			mov	cx, 10
			call	PutRad
			sputstr quotient
			xchg	ax, dx
			call	PutRad
			sputstr remainder
			xchg	ax, dx

			sputstr decimal
			sputstr new_line

			jmp	done_div

div_zero:
			
			sputstr divide_by_zero

done_div:

			_RsRegs <di, dx, cx, bx, ax>

			ret

Division endp



;##################################################################################
; Exponent: Calculates A ^ B and displays the result.  Handles B = 0 and B = 1.
; Preconditions: None
; Postconditions: None


Exponent proc

			_SvRegs <ax, bx, cx>
			
			sputstr exponent_text

			mov	ax, 1
			mov	bx, num_A
			mov	cx, num_B
			
			cmp	cx, 0
			jge	Exponent_Loop

			neg	cx
							
Exponent_Loop:

			jcxz	Exponent_Done	
			 
			imul	bx
			dec	cx

			jmp	Exponent_Loop

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

Start_Get_Over:	

			xor	bx, bx			
			xor	di, di
			xor	si, si
				
			mov	ah, 08h
			int	21h
			
			cmp	al, '*'
			jne 	Start_GetRad

			_Exit 0

Get_Input:

			mov	ah, 08h
			int	21h		

Start_GetRad:

			cmp	si, 0
			jne	Not_Neg
				
			cmp	al, '-'
			jne	Not_Neg
			mov	di, 1
			inc	si	
			mov	dl, al
			mov	ah, 02h
			int	21h
			jmp	Get_Input	

Not_Neg:

			cmp	cx, 10
			jle	Numeric_Radix

Alpha_Numeric_Radix:

			cmp	al, '0'
			jb	Invalid_Input
			cmp	al, '9'
			ja	Check_Letters
			
			mov	dl, al
			mov	ah, 02h
			int	21h

			sub	al, '0'
			
			jmp	Calculate_Value
				
Check_Letters:

			mov	dx, cx	
			add	dx, 54

			cmp	al, 'A'
			jb	Invalid_Input
			and	al, 11011111b
			cmp	al, dl
			ja	Invalid_Input

			mov	dl, al
			mov	ah, 02h
			int	21h

			sub	al, 55

			jmp	Calculate_Value

Numeric_Radix:
	
			mov	dx, cx
			add	dx,	'0'
			dec	dx 
			
			cmp	al, '0'
			jb	Invalid_Input
			cmp	al, dl
			ja	Invalid_Input
			
			mov	dl, al	
			mov	ah, 02h
			int	21h

			sub	al, '0'

Calculate_Value:

			xor	dx, dx
			xor	ah, ah
			xchg	ax, bx
			mul	cx
			cmp	dx, 0
			jne	Oversized_Value
			add	bx, ax
			inc  	si
			jmp	Get_Input

Invalid_Input:

			cmp	al, 8
			je	Handle_Backspace
			cmp	al, 13
			je	End_Get
			jmp	Get_Input

Handle_Backspace:
			
			cmp	si, 0
			je	Get_Input	

			dec	si
				
			xor	dx, dx
			mov	ax, bx
			div	cx
			mov	bx, ax
			sputch 	8
			sputch 	' '
			sputch 	8
			xor	ax, ax
			xor	dx, dx
			jmp	Get_Input	

End_Get:
			
			cmp	di, 1
			jne	Size_Var
			cmp	bx, 32768
			ja	Oversized_Value
			je	Special_Case
			neg	bx
			jmp	Done_Get

Size_Var:

			cmp	bx, 32767
			ja	Oversized_Value
			jmp	Done_Get
	
Special_Case:

			mov	bx, 32768
			jmp	Done_Get

Oversized_Value:
			
			sputstr new_line
			sputstr input_to_large
			jmp	Start_Get_Over 			 

Done_Get:

			mov	ax, bx

			_RsRegs <di, si, dx, cx, bx>

			ret	

GetRad endp



;#############################################################################################
; PutRad: Outputs a number to the console in the specified radix
; Preconditions: Number to output in AX, output radix in CX
; Postconditions: None.

PutRad proc

			_SvRegs <ax, bx, cx, dx, si, di>
	
			mov	di, cx
			xor	cx, cx
				
			test	ah, 10000000b				;check for sign
			jz	Process_Number
			sputch  '-'
			neg	ax	
					
Process_Number:

			xor	dx, dx
			div	di	
			push	dx
			inc	cx	
			cmp	ax, 0
			jne	Process_Number	
	
Output_Number:
		
			jcxz	Done_Put
			
			pop	ax
			dec	cx	
			cmp	ax, 10 			
			jb	Numeric_Output

			add	al, 55					;Convert number to letter

			jmp	Print_Number
			
Numeric_Output:
	
			add	al, '0'

Print_Number:

			sputch 	al

			jmp	Output_Number	
			
Done_Put:	
			
			_RsRegs <di, si, dx, cx, bx, ax>

			ret

PutRad endp

end main
