;J Andrew McCormick
;EECS 2110: Computer Architecture
;Summer 2015
;Project 1: Time

.model small
.8086
.stack 100h
.data

tutorial	db	10, 'Time Calculator', 13, 10, 10
			db	'You will enter time in hours,', 13, 10
			db	'minutes, and seconds in the ', 13, 10
			db	'following format:', 13, 10, 10
			db	'Enter hours, minutes, and seconds: x y z', 13, 10, 10
			db	'where x is hours, y is minutes,', 13, 10
			db	'and z is seconds', 13, 10, 10, '$'
			
get_input	db	'Enter hours, minutes, and seconds:$' 

hours_out		db ' hours: $'
minutes_out		db ' minutes: $'
seconds_out		db ' seconds: $'
play_again		db 'Do you want to play again? (y/n): $'
bad_input		db 'Bad input!  Try Again!', 13, 10, '$'
new_line		db 13, 10, '$'

.code
	extern	GetDec : NEAR, Puthex : NEAR, PutDec : NEAR

Project1		proc

			mov		ax, @data
			mov		ds, ax
			
			mov		dx, offset tutorial					;Print out tutorial
			mov		ah, 9h
			int		21h

Start_Again:

			mov		dx, offset new_line
			mov		ah, 9h
			int		21h

			mov		dx, offset get_input				;Print out get input message
			mov		ah, 9h
			int		21h
		
;Get the input from the user

			call	GetDec		
			push	ax			;hour_in

			call	GetDec
			push	ax			;min_in

			call	GetDec
			push 	ax			;sec_in

;Convert the input to hours minutes and seconds

			xor		dx, dx
			pop		ax			;sec_in
			mov		bx, 60
			div		bx
			pop		cx			;min_in
			push	dx			;sec_tot
			xor		dx, dx
			clc
			add		ax, cx		;sec_res + min_in
			adc		dx, 0		;if carry, in dx now
			div		bx			
			pop		cx			;sec_tot
			pop		bx			;hour_in
			push	cx			;sec_tot
			push	dx			;min_tot
			xor		dx, dx
			clc
			add		ax, bx		;min_res + hour_in
			adc		dx, 0		;if carry, in dx now
			push	ax			;hour_tot_lw
			push	dx			;hour_tot_hw

;Output Hours, Minutes and Seconds.  This uses the base pointer and offsets.

			mov		dx, offset hours_out
			mov		ah, 9h
			int		21h
			
			mov		bp, sp

			mov		dx, [bp]
			inc		bp
			inc		bp
			mov		ax, [bp]
			call	putddec16bit
			
			mov		dx, offset minutes_out
			mov		ah, 9h
			int		21h

			inc		bp
			inc		bp
			mov		ax, [bp]
			call	putdec

			mov		dx, offset seconds_out
			mov		ah, 9h
			int		21h

			inc		bp
			inc		bp
			mov		ax, [bp]
			call	putdec

			mov		dx, offset new_line
			mov		ah, 9h
			int		21h

;Convert Hours, Minutes, and Seconds to Minutes and Seconds.

			pop		cx			;hour_hw
			pop		ax			;hour_lw
			mov		bx, 60
			mul		bx
			push	ax			;min_lw_res
			mov		ax, cx		;hour_hw
			mov		cx, dx
			mul		bx
			add		ax, cx
			push	ax			;min_hw_res
			pop		dx			;min_hw_res
			pop		ax			;min_lw_res
			pop		cx			;min
			add		ax, cx
			adc		dx, 0		
			push	ax			;min_lw_tot
			push	dx			;min_hw_tot

;Print out Minutes and Seconds.

			mov		dx, offset minutes_out
			mov		ah, 9h
			int		21h

			mov		bp, sp

			mov		dx, [bp]
			inc		bp
			inc		bp
			mov		ax, [bp]
			call	putddec16bit

			mov		dx, offset seconds_out
			mov		ah, 9h
			int		21h

			inc		bp
			inc		bp
			mov		ax, [bp]
			call	putdec

			mov		dx, offset new_line
			mov		ah, 9h
			int		21h

;Convert Minutes and Seconds to Seconds.

			pop		cx			;min_hw
			pop		ax			;min_lw
			mov		bx, 60
			mul		bx
			push	ax			;sec_lw_res
			mov		ax, cx
			mov		cx, dx
			mul		bx
			add		ax, cx
			push	ax			;sec_hw_res
			pop		dx			;set_hw_res
			pop		ax			;set_lw_res
			pop		cx			;sec
			add		ax, cx
			adc		dx, 0
			push	ax			;sec_lw_tot
			push	dx			;sec_hw_tot

;Print out seconds

			mov		dx, offset seconds_out
			mov		ah, 9h
			int		21h

			mov		bp, sp
			mov		dx, [bp]
			inc		bp
			inc		bp
			mov		ax, [bp]
			call	putddec16bit

			mov		dx, offset new_line
			mov		ah, 9h
			int		21h

;Ask the user if they want to play again.

Ask_Again:
			mov		dx, offset play_again
			mov		ah, 9h
			int		21h
			mov		ah, 01h
			int		21h

			cmp		al, 'y'
			je		Start_Again

			cmp		al, 'Y'
			je		Start_Again

			cmp		al, 'n'
			je		End_Prog

			cmp		al, 'N'
			je		End_Prog

			mov		dx, offset new_line
			mov		ah, 9h
			int		21h
		
			mov		dx, offset bad_input
			mov		ah, 9h
			int		21h		

			jmp	    Ask_Again

End_Prog:

			mov		ah, 4ch
			int		21h

Project1		endp

PutDDec16bit	proc
	
;Preconditions: DX:AX is the double word you want to print
			push	ax
			push	bx
			push	cx
			push	dx
			push	si
			push	di

			xor		di, di
			xor		si, si

			mov		bx, '$'
			push	bx

			mov		bx, 0Ah

			cmp		dx, 0
			jne		StartProcess
			cmp		ax, 0
			jne		StartProcess

			mov		ax, '0'
			push	ax
			jmp		Done

StartProcess:

			cmp		dx, 0
			ja		start_div_hw

			cmp		ax, 0
			ja		start_div_lw

			jmp		Done

start_div_hw:
			
			mov		cx, ax
			mov		ax, dx
			xor		dx, dx
			div		bx
			mov		di, ax
			mov		ax, cx

start_div_lw:

			div		bx
			mov		si, ax

			add		dx, '0'
			push	dx
			mov		dx, di
			mov		ax, si
			jmp		StartProcess

Done:

			pop		dx
			cmp		dx, '$'
			je		TotallyDone

			mov		ah, 02h
			int		21h
			jmp		Done

TotallyDone:
			pop		di
			pop		si
			pop		dx
			pop		cx
			pop		bx
			pop		ax


			ret
PutDDec16bit	endp
				end	Project1
