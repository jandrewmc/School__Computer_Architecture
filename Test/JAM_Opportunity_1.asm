;J Andrew McCormick
;Opportunity 1
;Programming portion

include pcmac.inc
.model small
.8086
.stack 100h
.data

new_line		db	13, 10, '$'

question_1		db	'Enter the first number: $'
question_2		db	'Enter the second number: $'

add_answer_1	db	'The absolute value of the sum is $'
add_answer_2	db	', and the absolute value of the difference is $'

mul_answer_1	db	'The product is $'
mul_answer_2 	db	', and the quotient/remainder is $'

repeat_question	db	'Do you wish to repeat?  Enter y or Y to repeat, any other key exits : $'

.code
				extern PutDec:near, GetDec:near
Test1Problem	PROC
				mov		ax, @data
				mov		ds, ax
Restart:
				_putstr new_line			
				_putstr	Question_1
				call	GetDec
				mov		bx, ax
				_putstr	Question_2
				call	GetDec
				mov		cx, ax

				test	ah, 10000000b		;If one number is negative, do add/sub
				jnz		Negative_Num
				test	bh, 10000000b
				jnz		Negative_Num

				mul		bx			
				sputstr mul_answer_1
				call	PutDec

				xor		dx, dx
				mov		ax, bx

				div		cx
				sputstr mul_answer_2
				call	PutDec
				sputch  'R'
				mov		ax, dx
				call	PutDec

				jmp 	Should_Repeat		

Negative_Num:	add		ax, bx
				sub		bx, cx
				test	ah, 10000000b
				jz		Finish_Add
				neg		ax

Finish_Add:		_putstr add_answer_1
				call	PutDec

Subtract:		mov		ax, bx
				test	ah, 10000000b
				jz		Finish_Sub
				neg		ax

Finish_Sub:		_putstr add_answer_2
				call	PutDec

Should_Repeat:	_putstr new_line
				_putstr repeat_question
				_getch
				cmp		al, 'y'
				je		Restart
				cmp		al, 'Y'
				je		Restart

				_Exit 0	
Test1Problem	ENDP
				END	Test1Problem
