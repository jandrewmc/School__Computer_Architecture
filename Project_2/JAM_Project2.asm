.model small 
.8086
.stack 100h
.data

ask_for_string			db 	'Please enter a string (max 50 characters): $'
new_line 				db	13, 10, '$'			

function_list			db	'0) Determine where the first occurrence of a given character in the string.', 13, 10
						db	'1) Find the number of occurrences of a certain character in a string', 13, 10
						db	'2) Find the length of the input string', 13, 10
						db	'3) Find the number of characters of the input string', 13, 10
						db	'4) Replace every occurrence of a certain character with another character', 13, 10
						db	'5) Capitalize the letters in the string', 13, 10
						db	'6) Make each letter lower case', 13, 10
						db	'7) Toggle the case of each letter', 13, 10
						db	'8) Input a new string', 13, 10
						db	'9) Undo last modifying action (options 4-9)', 13, 10, '$'
				
which_function			db	'which function would you like to perform? (q to quit, p to display function list): $'

function_0_q			db	'Enter a character to determine the first occurrence of: $'

function_0_answer_1		db 'The first $'
function_0_answer_2 	db ' in the string: ', 13, 10, '$' 
function_0_answer_3		db 'occurs in position $'

function_1_q			db	'Enter a character to determine the number of occurrences of: $'

function_1_answer_1 	db 'The character $'
function_1_answer_2 	db ' occurs in the string:', 13, 10, '$'
function_1_answer_3 	db ' times $'


function_2_answer_1		db	'There are $'
function_2_answer_2		db	' characters in the string: ', 13, 10, '$'

function_3_answer_1 	db  'There are $'
function_3_answer_2	 	db	' alpha-numeric characters in the string:', 13, 10, '$'

function_4_q_1			db	'Enter a character to replace: $'
function_4_q_2			db	'Enter replacement character: $'

function_4_answer_1 	db	'Replacing all of the $'
function_4_answer_2 	db	's in the string:', 13, 10, '$'
function_4_answer_3		db	'with $'
function_4_answer_4 	db	' yields', 13, 10, '$'

function_5_answer_1 	db	'Capitalizing each letter in the string:', 13, 10, '$'
function_5_answer_2 	db	'yields', 13, 10, '$'

function_6_answer_1 	db	'Making each letter lowercase in the string:', 13, 10, '$'
function_6_answer_2 	db	'yields', 13, 10, '$'

function_7_answer_1 	db	'Toggling the case of each letter in the string:', 13, 10, '$'
function_7_answer_2 	db	'yields:', 13, 10, '$'

function_9_answer_1		db	'Last modifying action undone', 13, 10, '$'
function_9_answer_2		db	'Current string:', 13, 10, '$'

invalid_selection_string	db	'You entered an invalid selection, try again.', 13, 10, '$'
char_not_in_string			db 	'You entered a character that is not in the string.', 13, 10, '$'

input_string			db	'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'
input_string_length		dw 	0

new_string				db	'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'
new_string_length		dw	0

invalid_string_input 	db 'Invalid string input...input string must have more than 0 characters.', 13, 10, '$'

cant_undo				db	'No actions have been performed to undo.', 13, 10, '$'
.code
	extern  putdec:near

_begin Macro
	mov		ax, @data
	mov		ds, ax
	endm

_printstring Macro A
	push	dx
	push	ax

	mov		dx, offset A
	mov		ah, 9h
	int		21h

	pop		ax
	pop		dx
	endm

_save_regs Macro
	push	ax
	push	bx
	push	cx
	push	dx
	push	si
	push	di
	
	xor		ax, ax
	xor		bx, bx
	xor		cx, cx
	xor		dx, dx
	xor		si, si
	xor		di, di

	endm

_restore_regs Macro
	pop		di
	pop		si
	pop		dx
	pop		cx
	pop		bx
	pop		ax
	endm

_printstring_bychar Macro A, B
					LOCAL cont_print		
		push	ax
		push	bx
		push	cx
		push	dx

		mov		cx, A
		mov		bx, offset B
cont_print:
		mov		dx, [bx]
		mov		ah, 02h
		int		21h
		inc		bx
		dec		cx
		jnz		cont_print

		pop		dx
		pop		cx
		pop		bx
		pop		ax

		endm

_printchar Macro A
		
		push	ax
		push	dx
			
		mov		dl, A
		mov		ah, 02h
		int		21h
		
		pop		dx
		pop		ax

		endm

_getchar_echo Macro
		
		mov		ah, 01h
		int		21h

		endm

_getchar_noecho Macro

		mov		ah, 08h
		int		21h

		endm
main proc

	_begin

	call	Get_Input

select_function_with_list:

	_printstring new_line
	_printstring new_line

	_printstring function_list

select_function:
	
	_printstring new_line	

	_printstring which_function
	
	_getchar_echo
	
	cmp		al, 'q'						;q quits the program
	je		exit_prog
	cmp		al, 'Q'
	je		exit_prog
	cmp		al, 'p'						;p prints out the function list
	je		select_function_with_list
	cmp		al, 'P'
	je		select_function_with_list	
	
	_printstring new_line
	_printstring new_line
										;check which function was selected
	cmp		al, '0'
	jne		f1
	call	Function_0
	jmp		select_function
f1:	
	cmp		al, '1'
	jne		f2
	call	Function_1
	jmp		select_function
f2:
	cmp		al, '2'
	jne		f3
	call	Function_2
	jmp		select_function
f3:
	cmp		al, '3'
	jne		f4
	call	Function_3
	jmp		select_function
f4:
	cmp		al, '4'
	jne		f5
	call	Function_4
	jmp		select_function
f5:
	cmp		al, '5'
	jne		f6
	call	Function_5
	jmp		select_function
f6:
	cmp		al, '6'
	jne		f7
	call	Function_6
	jmp		select_function
f7:
	cmp		al, '7'
	jne		f8
	call	Function_7
	jmp		select_function
f8:
	cmp		al, '8'
	jne		f9
	call	Function_8
	jmp		select_function
f9:
	cmp		al, '9'
	jne		invalid_selection
	call	Function_9
	jmp		select_function

invalid_selection:
	
	_printstring invalid_selection_string

	jmp		select_function

exit_prog:
	
	mov		ah, 4ch
	int		21h
main endp



;#################################################################
;To preserve the original string after modification, we copy it

Copy_Input_To_New proc
	
	_save_regs
		
	mov		si, offset input_string
	mov		di, offset new_string

	mov		cx, 25

repeat_loop:

	mov		bx, [si]
	mov		[di], bx
	
	inc 	di
	inc 	di

	inc		si
	inc		si
	
	dec		cx
	jnz		repeat_loop

	mov		ax, input_string_length
	mov		new_string_length, ax

	_restore_regs

	ret
Copy_Input_To_New endp



;######################################################################
;there are times when we need to swap the saved strings

Swap_Strings	proc
	
	_save_regs

	mov		si, offset input_string
	mov		di, offset new_string
	mov		cx, 25

swap_loop:
	
	mov		ax, [si]
	mov		bx, [di]
	mov		[si], bx
	mov		[di], ax

	inc		si
	inc		si

	inc		di
	inc		di
		
	dec		cx
	cmp		cx, 0
	jg		swap_loop

	mov		ax, input_string_length
	mov		bx, new_string_length

	mov		new_string_length, ax
	mov		input_string_length, bx

	_restore_regs

	ret
Swap_Strings	endp



;####################################################################
;This procedure handles the input string.  It effectively strips out the 
;unwanted characters from the input.

Get_Input proc

	_save_regs
		
try_again:
	
	_printstring ask_for_string

	mov		cx, 50
	mov		bx, offset input_string

get_input_string:

	_getchar_echo

	cmp		al, 8				;handle backspace
	je		backspace_char	
	cmp		al, 13				;enter ends input
	je		get_input_complete	

	mov		[bx], al			;save it
	inc		bx
	
	dec		cx					;if our max has not been reached
	jnz		get_input_string	;get next character
	jmp		get_input_complete

backspace_char:
	mov		ax, '$'
	mov		[bx], ax
	dec		bx
	mov		[bx], ax 
	inc		cx
	
	_printchar 20h	
	_printchar 08h
		
	jmp		get_input_string

get_input_complete:

	mov		dx, 50
	sub		dx, cx
	mov		input_string_length, dx		;calculate and save the length of the string
	
	cmp		input_string_length, 0
	jne		input_finished
	
	_printstring invalid_selection_string
	_printstring new_line
	
	jmp		try_again

input_finished:

	_printstring new_line

	_restore_regs

	ret
Get_Input endp



;########################################################################
;Function 0

Function_0 proc
	
	_save_regs

	_printstring function_0_q

f0_get_char:

	_getchar_noecho

	cmp		al, 8				;skip backspace
	je		f0_get_char	

	_printchar al
	
	xor		cx, cx

	mov		bx, offset input_string

f0_next_char:
	
	cmp		cx, input_string_length
	je		not_in_string
	
	mov		dx, [bx]

	cmp		dl, al
	je		f0_done
	
	inc		bx
	inc		cx

	jmp		f0_next_char
not_in_string:

	_printstring new_line

	_printstring char_not_in_string		

	jmp		f0_skip_print

f0_done:
	
	_printstring new_line
	_printstring new_line
	_printstring function_0_answer_1

	_printchar 27h
	_printchar al
	_printchar 27h	
	
	_printstring function_0_answer_2
	_printstring_bychar input_string_length, input_string	
	_printstring new_line
	_printstring function_0_answer_3		
		
	mov		ax, cx
	call	PutDec	

	_printstring new_line

f0_skip_print:

	_restore_regs

	ret
Function_0 endp



;#######################################################################
;Function 1

Function_1 proc

	_save_regs
	
	_printstring function_1_q

f1_get_char:

	_getchar_noecho

	cmp		al, 8				;skip backspace
	je		f1_get_char	

	_printchar al

	_printstring new_line	

	mov		cx, input_string_length
	mov		bx, offset input_string 
	xor		si, si

f1_start:

	mov		dx, [bx]
	cmp		al, dl
	jne		f1_cont
	inc		si

f1_cont:
	inc		bx
	dec		cx
	jnz		f1_start

	_printstring new_line
	_printstring function_1_answer_1

	_printchar 27h	
	_printchar al
	_printchar 27h	

	_printstring function_1_answer_2	
	_printstring_bychar input_string_length, input_string	
	_printstring new_line
		
	mov		ax, si
	call	PutDec

	_printstring function_1_answer_3	
	_printstring new_line
		
	_restore_regs

	ret
Function_1 endp



;#######################################################################
;Function 2

Function_2 proc
	
	_save_regs

	_printstring function_2_answer_1

	mov		ax, input_string_length
	call	PutDec

	_printstring function_2_answer_2

	_printstring_bychar input_string_length, input_string	
	_printstring new_line	

	_restore_regs

	ret
Function_2 endp



;#######################################################################
;Function 3

Function_3 proc
	
	_save_regs

	xor		si, si

	mov		bx, offset input_string
	mov		cx, input_string_length

f3_start:
	mov		dx, [bx]

	cmp		dl, '0'
	jb		f3_end
	cmp		dl, '9'
	ja		f3_check_letters
	jmp		f3_char_found

f3_check_letters:

	cmp		dl, 'A'
	jb		f3_end
	and		dl, 11011111b
	cmp		dl, 'Z'
	ja		f3_end
	
f3_char_found:

	inc		si

f3_end:
	
	inc		bx
	dec		cx
	jnz		f3_start

	_printstring function_3_answer_1

	mov		ax, si
	call	PutDec

	_printstring function_3_answer_2
	_printstring_bychar input_string_length, input_string	
	_printstring new_line

	_restore_regs

	ret
Function_3 endp



;########################################################################
;Function 3

Function_4 proc

	_save_regs
	
	_printstring function_4_q_1

f4_get_char:

	_getchar_noecho

	cmp		al, 8				;skip backspace
	je		f4_get_char	

	_printchar al	

	xor		ah, ah

	mov		si, ax				;char to replace

	_printstring new_line

	_printstring function_4_q_2
	
f4_get_char_r:

	_getchar_noecho

	cmp		al, 8				;skip backspace
	je		f4_get_char_r

	_printchar al

	xor		ah, ah
	
	mov		di, ax				;replacement char

	_printstring new_line
		
	call	Copy_Input_To_New

	mov		bx, offset new_string
	mov		cx, input_string_length

f4_start:

	mov		dx, [bx]
	mov		ax, si

	cmp		dl, al
	jne		f4_cont

	mov		ax, di
	mov		dl, al
	mov		[bx], dx

f4_cont:

	inc		bx
	dec		cx
	jne		f4_start

	_printstring new_line
	_printstring function_4_answer_1

	_printchar 27h
	mov		dx, si
	_printchar dl
	_printchar 27h
	
	_printstring function_4_answer_2
	_printstring_bychar input_string_length, input_string	
	_printstring new_line
	_printstring function_4_answer_3

	mov		dx, di
	_printchar dl

	_printstring function_4_answer_4
	_printstring_bychar new_string_length, new_string	
	_printstring new_line

	call	Swap_Strings

	_restore_regs

	ret
Function_4 endp

Function_5 proc
	
	_save_regs

	call	Copy_Input_To_New

	mov		si, offset new_string
	mov		cx, input_string_length 
f5_next_letter:

	mov		bx, [si]
	cmp		bl, 'a'
	jl		f5_skip_char
	cmp		bl, 'z'
	jg		f5_skip_char

	xor	 	bl, 20h
	mov		[si], bx

f5_skip_char:
	
	inc		si
	dec		cx
	jnz		f5_next_letter
	
	_printstring function_5_answer_1
	_printstring_bychar input_string_length, input_string	
	_printstring new_line
	_printstring function_5_answer_2
	_printstring_bychar new_string_length, new_string	
	_printstring new_line

	call	Swap_Strings

	_restore_regs

	ret
Function_5 endp

Function_6 proc
	
	_save_regs

	call	Copy_Input_To_New
	
	mov		si, offset new_string
	mov		cx, input_string_length
		
f6_next_letter:

	mov		bx, [si]
	
	cmp		bl, 'A'
	jl		f6_skip_letter
	cmp		bl, 'Z'
	jg		f6_skip_letter
	
	xor		bl, 020h
	
	mov		[si], bx

f6_skip_letter:

	inc		si
	dec		cx
	jnz		f6_next_letter

	_printstring function_6_answer_1
	_printstring_bychar input_string_length, input_string	
	_printstring new_line
	_printstring function_6_answer_2
	_printstring_bychar new_string_length, new_string	
	_printstring new_line	

	call	Swap_Strings
	
	_restore_regs

	ret
Function_6 endp

Function_7 proc
	
	_save_regs

	call	Copy_Input_To_New

	mov		bx, offset new_string
	mov		cx, input_string_length

f7_start:

	mov		dx, [bx]

	cmp		dl, 'A'
	jb		f7_end
	cmp		dl, 'Z'
	ja		f7_check_lower

	xor		dl, 20h
	jmp		f7_end

f7_check_lower:

	cmp		dl, 'a'
	jb		f7_end
	cmp		dl, 'z'
	ja		f7_end

	xor		dl, 20h

f7_end:

	mov		[bx], dx
	inc		bx
	dec		cx
	jnz		f7_start

	_printstring function_7_answer_1
	_printstring_bychar input_string_length, input_string	
	_printstring new_line
	_printstring function_7_answer_2
	_printstring_bychar new_string_length, new_string	
	_printstring new_line

	call	Swap_Strings

	_restore_regs	

	ret
Function_7 endp

Function_8 proc

	call	Swap_Strings
	call 	Get_Input
	
	ret
Function_8 endp

Function_9 proc

	_save_regs

	mov		dx, new_string_length
	cmp		dx, 0
	jne		perform_undo
	
	_printstring cant_undo

	jmp		finished_undo	

perform_undo:
	
	call	Swap_Strings

finished_undo:

	_printstring function_9_answer_1
	_printstring function_9_answer_2
	_printstring_bychar input_string_length, input_string
	_printstring new_line

	_restore_regs

	ret
Function_9 endp
			end main	
