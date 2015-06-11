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
new_line		db 13, 10, '$'

.code
	extern	GetDec : NEAR, PutDec : NEAR

Project1		proc

			mov		ax, @data
			mov		ds, ax
			
			mov		dx, offset tutorial
			mov		ah, 9h
			int		21h

			mov		dx, offset get_input
			mov		ah, 9h
			int		21h

			call	GetDec		
			push	ax			;hour_in

			call	GetDec
			push	ax			;min_in

			call	GetDec
			push 	ax			;sec_in


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


			mov		dx, offset hours_out
			mov		ah, 9h
			int		21h

			pop		di
			mov		ax, di	
			call	puthex

			pop		si
			mov		ax, si
			call	puthex	

			mov		dx, offset minutes_out
			mov		ah, 9h
			int		21h

			pop		cx
			mov		ax, cx
			call	puthex

			
			mov		dx, offset seconds_out
			mov		ah, 9h
			int		21h

			pop		bx
			mov		ax, bx
			call	puthex

			mov		dx, offset new_line
			mov		ah, 9h
			int		21h

			push	bx			;sec
			push	cx			;min
			push	si			;hour_lw
			push	di			;hour_hw



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

			mov		dx, offset minutes_out
			mov		ah, 9h
			int		21h

			pop		di
			mov		ax, di	
			call	puthex

			pop		si
			mov		ax, si
			call	puthex

			mov		dx, offset seconds_out
			mov		ah, 9h
			int		21h

			pop		cx
			mov		ax, cx
			call	puthex

			mov		dx, offset new_line
			mov		ah, 9h
			int		21h

			push	cx			;sec
			push	si			;min_lw
			push	di			;min_hw
			

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

			mov		dx, offset seconds_out
			mov		ah, 9h
			int		21h

			pop		ax
			call	puthex

			pop		ax
			call	puthex

			mov		dx, offset new_line
			mov		ah, 9h
			int		21h

			mov		ah, 4ch
			int		21h

Project1		endp
PutDDec16bit	proc
	
;Preconditions: DX:AX is the double word you want to print

			push	bx
			push	cx

			mov		bx, '$"
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

start_div_lw

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

			pop		cx
			pop		bx


			ret
PutDDec16bit	endp

			end	Project1
