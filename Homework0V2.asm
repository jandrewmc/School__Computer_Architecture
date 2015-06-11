;J Andrew McCormick
;Computer Architecture and Orgainzation
;Summer 2015


.model	small
.8086
.stack	100h
.data

tutorial		db	10, 'Volume Calculation', 13, 10
				db	'Enter the length, width, and height', 13, 10
				db	'in feet and inches to calculate the', 13, 10
				db	'volume of the rectangular prism.', 13, 10
				db	'Example Input:', 13, 10, 10
				db	'length in feet and inches: x y', 13, 10, 10
				db	'where x is the number of feet', 13, 10
				db	'and y is the number of inches', 13, 10, 10, '$'


get_length		db	'length in feet and inches: $'
get_width		db	'width in feet and inches: $'
get_height		db	'height in feet and inches: $'

put_cubic_inches	db	' cu. in.', 13, 10, '$'
put_cubic_feet		db	' cu. ft. $' 

num_1_lw		dw	0
num_1_hw		dw	0
num_2_lw		dw	0
num_2_hw		dw	0
num_3_lw		dw	0
num_3_hw		dw	0

result_0		dw	0
result_1		dw	0
result_2		dw	0
result_3		dw	0

final_result_0	dw	0
final_result_1	dw	0
final_result_2	dw	0
final_result_3	dw	0

div_result_0	dw	0
div_result_1	dw	0
div_result_2	dw	0
div_result_3	dw	0

conv_res_0		dw	0
conv_res_1		dw	0
conv_res_2		dw	0
conv_res_3		dw	0

divisor			dw	006c0h

rem_result		dw	0

.code
				extern	GetDec : NEAR, PutDec : NEAR
Homework0V2		proc
				mov		ax, @data
				mov		ds, ax

				mov		dx, offset tutorial			;print tutorial
				mov		ah, 9h
				int		21h

				mov		dx, offset get_length
				mov		ah, 9h
				int		21h
				call	GetDec
				mov		bx, 12
				mul		bx
				mov		bx, ax
				call	GetDec
				clc
				add		ax, bx
				adc		dx, 0
				mov		num_1_hw, dx
				mov		num_1_lw, ax

				mov		dx, offset get_width
				mov		ah, 9h
				int		21h
				call	GetDec
				mov		bx, 12
				mul		bx
				mov		bx, ax
				call	GetDec
				clc
				add		ax, bx
				adc		dx, 0
				mov		num_2_hw, dx
				mov		num_2_lw, ax

				mov		dx, offset get_height
				mov		ah, 9h
				int		21h
				call	GetDec
				mov		bx, 12
				mul		bx
				mov		bx, ax
				call	GetDec
				clc
				add		ax, bx
				adc		dx, 0
				mov		num_3_hw, dx
				mov		num_3_lw, ax

				
				mov		dx, num_1_lw
				mov		ax, num_2_lw
				mul		dx
				mov		result_0, ax
				mov		result_1, dx

				mov		dx, num_1_hw
				mov		ax, num_2_lw
				mul		dx
				clc
				add		result_1, ax
				adc 	result_2, dx

				mov		dx, num_1_lw
				mov		ax, num_2_hw
				mul		dx
				clc
				add		result_1, ax
				adc		result_2, dx
				adc		result_3, 0

				mov		dx, num_1_hw
				mov		ax, num_1_hw
				mul		dx
				clc
				add		result_2, ax
				adc		result_3, dx

				mov		dx, num_3_lw
				mov		ax, result_0
				mul		dx
				mov		final_result_0, ax
				mov		final_result_1, dx

				mov		dx, num_3_lw
				mov		ax, result_1
				mul		dx
				clc
				add		final_result_1, ax
				adc		final_result_2, dx

				mov		dx, num_3_lw
				mov		ax, result_2
				mul		dx
				clc
				add		final_result_2, ax
				adc		final_result_3, dx

				mov		dx, num_3_hw
				mov		ax, result_0
				mul		dx
				clc
				add		final_result_1, ax
				adc		final_result_2, dx

				mov		dx, num_3_hw
				mov		ax, result_1
				mul		dx
				clc
				add		final_result_2, ax
				adc		final_result_3, dx

				mov		dx, num_3_hw
				mov		ax, result_2
				mul		dx
				add		final_result_3, ax

				mov		bx, divisor
				xor		dx, dx



				cmp		final_result_3, 0
				jz		final_result_3_zero
				
				mov		ax, final_result_3
				
				div		bx
				
				mov		div_result_3, ax
				mov		ax, final_result_2
				
				div		bx
				
				mov		div_result_2, ax
				mov		ax, final_result_1
				
				div		bx
				
				mov		div_result_1, ax
				mov		ax, final_result_0
				
				div		bx
				
				mov		div_result_0, ax
				mov		rem_result, dx	
				
				

				jmp		AllDone

final_result_3_zero:

				cmp		final_result_2, 0
				jz		final_result_2_zero
				
				mov		ax, final_result_2
				
				div		bx
				
				mov		div_result_2, ax
				mov		ax, final_result_1
					
				div		bx

				mov		div_result_1, ax
				mov		ax, final_result_0

				div		bx

				mov		div_result_0, ax
				mov		rem_result, dx

				jmp		AllDone

final_result_2_zero:

				cmp		final_result_1, 0
				jz		final_result_1_zero

				mov		ax, final_result_1

				div		bx

				mov		div_result_1, ax
				mov		ax, final_result_0

				div		bx

				mov		div_result_0, ax
				mov		rem_result, dx

				jmp		AllDone


final_result_1_zero:

				mov		ax, final_result_0

				div		bx

				mov		div_result_0, ax
				mov		rem_result, dx

				jmp		AllDone

AllDone:

				mov		ax, offset final_result_0
				call	PutGDec

				mov		dx, offset put_cubic_inches
				mov		ah, 9h
				int		21h

				mov		ax, offset div_result_0
				call	PutGDec

				mov		dx, offset put_cubic_feet
				mov		ah, 9h
				int		21h

				mov		ax, rem_result
				call	PutDec

				mov		dx, offset put_cubic_inches
				mov		ah, 9h
				int		21h

				mov		ah, 4ch
				int 	21h

Homework0V2		endp

;This will output a giant decimal number in 8086 instruction set
PutGDec			proc
				
				;Preconditions: The offset of the low word of the number
				;to be displayed is in Ax

				push	bx
				push	cx
				push	dx
				
				mov		di, ax
				mov		bx, 0Ah

				xor		ax, ax
				xor		cx, cx
				xor		dx, dx
				
				mov		ax, '$'	
				push	ax

				mov		ax, [di]
				mov		conv_res_0, ax
				add		di, 2
				mov		ax, [di]
				mov		conv_res_1, ax
				add		di, 2
				mov		ax, [di]
				mov		conv_res_2, ax
				add		di, 2
				mov		ax, [di]
				mov		conv_res_3, ax
				
				cmp		conv_res_0, 0
				jne		StartProcess
				cmp		conv_res_1, 0
				jne		StartProcess
				cmp		conv_res_2, 0
				jne		StartProcess
				cmp		conv_res_3, 0
				jne		StartProcess

				mov		ax, '0'
				push	ax
				jmp		Done

StartProcess:
				mov		ax, conv_res_3
				cmp		ax, 0
				ja		StartDivide3
				
				mov		ax, conv_res_2
				cmp		ax, 0
				ja		StartDivide2
				
				mov		ax, conv_res_1
				cmp		ax, 0
				ja		StartDivide1
				
				mov		ax, conv_res_0
				cmp		ax, 0
				ja		StartDivide0
				
				jmp		Done
				
StartDivide3:
				div		bx
				
				mov		conv_res_3, ax

				mov		ax, conv_res_2
StartDivide2:
				div		bx
				
				mov		conv_res_2, ax

				mov		ax, conv_res_1
StartDivide1:
				div		bx
				
				mov		conv_res_1, ax

				mov		ax, conv_res_0
StartDivide0:
				div		bx

				mov		conv_res_0, ax
AlmostDone:
				add		dx, '0'
				push	dx
				xor		dx, dx
				jmp		StartProcess
Done:
				pop		dx
				cmp		dx, '$'
				je		TotallyDone
				
				mov		ah, 02h
				int		21h
				jmp		Done
TotallyDone:
				pop		dx
				pop		cx
				pop		bx

				ret

PutGDec			endp
				end Homework0V2
