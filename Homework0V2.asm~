.model	small
.386
.stack	100h
.data

get_length		db	'length in feet and inches: $'
get_width		db	'width in feet and inches: $'
get_height		db	'height in feet and inches: $'

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

.code
				extern	GetDec : NEAR, PutUDec : NEAR, PutHex : NEAR
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

				mov		ax, num_1_hw
				call	PutHex
				mov		ax, num_1_lw
				call	PutHex

				mov		ax, num_2_hw
				call	PutHex
				mov		ax, num_2_lw
				call	PutHex

				mov		ax, num_3_hw
				call	PutHex
				mov		ax, num_3_lw
				call	PutHex
			
				mov		ah, 4ch
				int 	21h
Homework0V2		endp
				end Homework0V2
