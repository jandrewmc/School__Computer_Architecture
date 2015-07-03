.model small
.8086
.stack 100h

.data

input_radix_prompt	db 'Please enter the input radix (q to quit): $'
output_radix_prompt	db 'Please enter the output radix (q to quit): $'
change_radix_prompt	db 'Do you want to change either input or output radix? (y/n): $'

number_A_prompt	db 'Enter the number A: $'
number_B_prompt db 'Enter the number B: $'

.code
main proc

	mov		ax, @data
	mov		ds, ax

	;get the input and output radix
	
	;get the numbers A and B (need to check for valid input)
		

	mov		ah, 4ch
	int		21h

main endp

get_rad proc

	
	mov		ah, 08h				;input char without echo
	int		21h

		

get_rad endp

end main
