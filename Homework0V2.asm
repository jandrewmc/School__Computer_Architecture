.model	small
.8086
.stack	100h
.data

get_length		db	'length in feet and inches: $'
get_width		db	'width in feet and inches: $'
get_height		db	'height in feet and inches: $'

put_cubic_inches	db	' cu. in.', 13, 10, '$'
put_cubic_feet	db	' cu. ft.$' 

num_1_lw		dw	00000h
num_1_hw		dw	00000h
num_2_lw		dw	00000h
num_2_hw		dw	00000h
num_3_lw		dw	00000h
num_3_hw		dw	00000h

result_0		dw	00000h
result_1		dw	00000h
result_2		dw	00000h
result_3		dw	00000h

final_result_0	dw	00000h
final_result_1	dw	00000h
final_result_2	dw	00000h
final_result_3	dw	00000h

div_result_0	dw	00000h
div_result_1	dw	00000h
div_result_2	dw	00000h
div_result_3	dw	00000h

conv_res_0	dw	0
conv_res_1	dw	0
conv_res_2	dw	0
conv_res_3	dw	0

divisor			dw	006c0h

rem_result		dw	00000h

.code
				extern	GetDec : NEAR, PutDec : NEAR
Homework0V2		proc
				mov		ax, @data
				mov		ds, ax

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
				
				mov		conv_res_0, [di]
				add		di, 2
				mov		conv_res_1, [di]
				add		di, 2
				mov		conv_res_2, [di]
				add		di, 2
				mov		conv_res_3, [di]
				
				push	'$'
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
				
				push	'0'
				jmp		Done
				
StartDivide3:
				cmp		ax, bx
				jb		SetupDivide2

				div		bx
				
				mov		conv_res_3, dx

SetupDivide2:
				mov		dx, ax
				mov		ax, conv_res_2
StartDivide2:
				cmp		dx, 0
				ja		SkipDiv2Check
				cmp		ax, bx
				jb		SetupDivide1
SkipDiv2Check:
				div		bx
				
				mov		conv_res_2, dx
SetupDivide1:
				mov		dx, ax
				mov		ax, conv_res_1
StartDivide1:
				cmp		dx, ax
				ja		SkipDev1Check
				cmp		ax, bx
				jb		SetupDivide0
SkipDiv1Check:
				div		bx
				
				mov		conv_res_1, dx
SetupDivide0:
				mov		dx, ax
				mov		ax, conv_res_0
StartDivide0:
				cmp		dx, ax
				ja		SkipDev0Check
				cmp		ax, bx
				jb		AlmostDone
SkipDev0Check:
				div		bx

				mov		conv_res_0, dx
AlmostDone:
				add		ax, '0'
				push		ax
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
