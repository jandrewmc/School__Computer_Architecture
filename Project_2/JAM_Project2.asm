.model small
.8086
.stack 100h
.data

ask_for_string	db 	'Please enter a string (max 50 characters): $'
new_line_string	db	13, 10, '$'

function_list	db 	'Please enter the number of the function you wish to perform (q to quit):', 13, 13, 10
				db	'0 Determine where the first occurrence of a user-input character is in the string.', 13, 10
				db	'1 Find the number of occurrences of a certain letter in a string', 13, 10
				db	'2 Find the length of the input string', 13, 10
				db	'3 Find the number of characters of the input string', 13, 10
				db	'4 Replace every occurrence of a certain letter with another symbol', 13, 10
				db	'5 Capitalize the letters in the string', 13, 10
				db	'6 Make each letter lower case', 13, 10
				db	'7 Toggle the case of each letter', 13, 10
				db	'8 Input a new string', 13, 10
				db	'9 Undo last action', 13, 10, '$'
				
which_function	db	'which function would you like to perform?: $'

function_0_q	db	'Enter a character to determine the first occurrence of: $'

function_0_answer_1	db 'The first $'
function_0_answer_2 db ' in the string: ', 13, 10, '$'
function_0_answer_3	db 'occurs in position $'

function_1_q	db	'Enter a character to determine the number of occurrences of: $'

function_1_answer_1 db 'The character $'
function_1_answer_2 db 'occurs in the string:', 13, 10, '$'
function_1_answer_3 db ' times $'


function_2_answer_1	db	'There are $'
function_2_answer_2	db	' characters in the string: ', 13, 10, '$'

function_3_answer_1 db  'There are $'
function_3_answer_2 db	' characters in the string:', 13, 10, '$'

function_4_q_1		db	'Enter a character to replace: $'
function_4_q_2		db	'Enter replacement character: $'

function_4_answer_1 db	'Replacing all of the $'
function_4_answer_2 db	's in the string:', 13, 10, '$'
function_4_answer_3 db	'with $'
function_4_answer_4 db	' yields', 13, 10, '$'

function_5_answer_1 db	'Capitalizing each letter in the string', 13, 10, '$'
function_5_answer_2 db	'yeilds', 13, 10, '$'



invalid_selection_string	db	'You entered an invalid selection, try again.', 13, 10, '$'
char_not_in_string			db 	'You entered a character that is not in the string.', 13, 10, '$'

input_string		db	'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'
input_string_length	dw 0
new_string			db	'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'

.code
	extern  putdec:near
JAM_Project2 proc
	mov		ax, @data
	mov		ds, ax

	mov		dx, offset ask_for_string
	mov		ah, 9h
	int		21h

	call	Get_Input

	mov		dx, offset function_list
	mov		ah, 9h
	int		21h

select_function:
	
	call	New_Line

	mov		dx, offset which_function
	mov		ah, 9h
	int		21h
	
	mov		ah, 1h
	int		21h
	
	cmp		al, 'q'
	je		exit_prog
	cmp		al, 'Q'
	je		exit_prog

	call	New_Line
	call	New_Line

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

	mov		dx, offset invalid_selection_string
	mov		ah, 9h
	int 	21h

	jmp		select_function

exit_prog:
	
	mov		ah, 4ch
	int		21h
JAM_Project2 endp

Copy_Input_To_New proc
	
	push	bx	
	push	cx
	push	si
	push	di
	
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

	pop		di
	pop		si
	pop		cx
	pop		bx

	ret

Copy_Input_To_New endp

New_Line proc
	
	push	ax
	push	dx

	mov		dx, offset new_line_string
	mov		ah, 9h
	int		21h

	pop		dx
	pop		ax

	ret

New_Line endp

Get_Input proc

	push	ax						;save registers
	push	bx
	push	cx
	push	dx

	mov		cx, 50
	mov		bx, offset input_string

get_input_string:
	
	mov		ah, 01h					;get char from keyboard
	int		21h

	cmp		al, 13 					;if the user presses "enter", string is
	je		get_input_complete		;done being entered

	mov		[bx], al				;save in string
	inc 	bx

	dec		cx					
	jnz		get_input_string

get_input_complete:

	mov		bx, offset input_string_length
	mov		dx, 50
	sub		dx, cx
	mov		[bx], dx				;calculate and save the length of the string
	
	call	New_Line
	call	New_Line

	pop		dx
	pop		cx
	pop		bx
	pop		ax						;restore registers
	
	ret
Get_Input endp

Function_0 proc
	
	push	ax
	push	bx
	push	cx
	push	dx

	mov		dx, offset function_0_q
	mov		ah, 9h
	int		21h

	mov		ah, 01h
	int		21h

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

	call	New_Line
	
	mov		dx, offset char_not_in_string
	mov		ah, 9h
	int		21h

	jmp		f0_skip_print

f0_done:
	
	call	New_Line

	push	ax

	mov		dx, offset function_0_answer_1
	mov		ah, 9h
	int		21h
	
	mov		dl, 27h
	mov		ah, 02h
	int		21h
	
	pop		ax

	mov		dl, al
	mov		ah, 02h
	int		21h
	
	mov		dl, 27h
	int		21h
	
	mov		dx, offset function_0_answer_2
	mov		ah, 9h
	int		21h
	
	mov		dx, offset input_string
	int		21h
	
	call	New_Line
	
	mov		dx, offset function_0_answer_3
	mov		ah, 9h
	int		21h
	
	mov		ax, cx
	call	PutDec	

f0_skip_print:

	pop		dx
	pop		cx
	pop		bx
	pop		ax

	ret
Function_0 endp

Function_1 proc

	push	ax
	push	bx
	push	cx
	push	dx
	push	si

	mov		dx, offset function_1_q
	mov		ah, 9h
	int		21h

	mov		ah, 01h
	int		21h

	call	New_Line
	
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

	push	ax

	mov		dx, offset function_1_answer_1
	mov		ah, 9h
	int		21h
		
	mov		dl, 27h
	mov		ah, 02h
	int		21h
	
	pop		ax

	mov		dl, al
	mov		ah, 02h
	int		21h
	
	mov		dl, 27h
	int		21h
	
	mov		dx, offset function_1_answer_2
	mov		ah, 9h
	int		21h
	
	mov		dx, offset input_string
	mov		ah, 9h
	int		21h

	call	New_Line
	
	mov		ax, si
	call	PutDec
	
	mov		dx, offset function_1_answer_3
	mov		ah, 9h
	int		21h
		
	pop		si
	pop		dx
	pop		cx
	pop		bx
	pop		ax

	ret
Function_1 endp

Function_2 proc
	push   	ax
	push	dx

	mov		dx, offset function_2_answer_1
	mov		ah, 9h
	int		21h

	mov		ax, input_string_length
	call	PutDec

	mov		dx, offset function_2_answer_2
	mov		ah, 9h
	int		21h

	mov		dx, offset input_string
	mov		ah, 9h
	int		21h
	
	pop		dx
	pop 	ax

	ret
Function_2 endp

Function_3 proc

	ret
Function_3 endp

Function_4 proc
	
	mov		dx, offset function_4_q_1
	mov		ah, 9h
	int		21h

	mov		ah, 01h
	int		21h

	xor		ah, ah

	mov		si, ax				;char to replace

	call	New_Line

	mov		dx, offset function_4_q_2
	mov		ah, 9h
	int		21h
	mov		ah, 01h
	int		21h

	xor		ah, ah
	
	mov		di, ax				;replacement char

	call	New_Line
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

	mov		dx, offset function_4_answer_1
	mov		ah, 9h
	int		21h
	
	mov		dl, 27h
	mov		ah, 02h
	int		21h
	
	mov		dx, si
	mov		ah, 02h
	int		21h
	
	mov		dx, offset function_4_answer_2
	mov		ah, 9h
	int		21h
	
	mov		dx, offset input_string
	mov		ah, 9h
	int		21h

	call	New_Line

	mov		dx, offset function_4_answer_3
	mov		ah, 9h
	int		21h

	mov		dx, di
	mov		ah, 02h
	int		21h

	mov		dx, offset function_4_answer_4
	mov		ah, 9h
	int 	21h

	mov		dx, offset new_string
	mov		ah, 9h
	int		21h

		
	ret
Function_4 endp

Function_5 proc

	push	ax
	push	bx
	push	cx
	push	dx
	push	si

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
	
	mov		dx, offset function_5_answer_1
	mov		ah, 9h
	int		21h
	
	mov		dx, offset input_string
	mov		ah, 9h
	int		21h
	
	call	New_Line
	
	mov		dx, offset function_5_answer_2
	mov		ah, 9h
	int		21h
	
	mov		dx, offset new_string
	mov		ah, 9h
	int		21h		
	
	pop		si
	pop		dx
	pop		cx
	pop		bx
	pop		ax

	ret
Function_5 endp

Function_6 proc
	

	ret
Function_6 endp

Function_7 proc

	ret
Function_7 endp

Function_8 proc

	ret
Function_8 endp

Function_9 proc

	ret
Function_9 endp
			end JAM_Project2	
