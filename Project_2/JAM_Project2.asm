.model small
.8086
.stack 100h
.data

ask_for_string	db 	'Please enter a string (max 50 characters: $'
new_line		db	13, 10, '$'

function_list	db 	'Please enter the number of the function you wish to perform:', 13, 13, 10
				db	'1 Determine where the first occurrence of a user-input character is in the string.', 13, 10
				db	'2 Find the number of occurrences of a certain letter in a string', 13, 10
				db	'3 Find the length of the input string', 13, 10
				db	'4 Find the number of characters of the input string', 13, 10
				db	'5 Capitalize the letters in the string', 13, 10
				db	'6 Make each letter lower case', 13, 10
				db	'7 Toggle the case of each letter', 13, 10
				db	'8 Input a new string', 13, 10
				db	'9 Undo last action', 13, 10, '$'


function_1_q	db	'Enter a character to determine the first occurrence of: $'


first_string	db	'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'
second_string	db	'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'
.code
JAM_Project2 proc
	mov		ax, @data
	mov		ds, ax

	mov		dx, offset ask_for_string
	mov		ah, 9h
	int		21h

	mov		cx, 50
	mov		bx, offset first_string

get_input:
	
	mov		ah, 01h
	int		21h

	mov		[bx], al
	inc 	bx

	cmp		al, 13 					;if the user presses "enter", string is
	je		start					;done being entered

	dec		cx			
	jz		start					;if string is 50 chars long
	jmp		get_input
start:

	mov		dx, offset new_line
	mov		ah, 9h
	int		21h
	
	mov		dx, offset function_list
	mov		ah, 9h
	int		21h


	mov		ah, 4ch
	int		21h
JAM_Project2 endp

Function_1 proc
	mov		dx, offset function_1_q
	mov		ah, 9h
	int		21h

	mov		ah, 01h
	int		21h

	
	ret
Function_1 endp


			end JAM_Project2	