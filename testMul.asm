.model	small
.8086
.stack 	100h
.data

low_word	dw	0FFDBh
high_word	dw	00024h

.code
	extrn	PutHex : NEAR
testMul	PROC

	mov		ax, @data
	mov		ds, ax

	mov		ax, low_word
	mov		bx, high_word
	xor		cx, cx
	xor		dx, dx

	call	BoothsAlgorithm32bit

	push	ax
	push	bx
	push 	cx
	push 	dx

	mov		si, high_word
	mov		di, low_word

	pop		ax
	call	PutHex

	pop		ax
	call	PutHex

	pop		ax
	call	PutHex

	pop		ax
	call	PutHex

	mov	ah, 4ch
	int	21h

testMul	ENDP

BoothsAlgorithm32bit	PROC

			mov		dx, 32
			push	dx
			mov		bp, sp
			xor		dx, dx		
			clc

TheLoop:
			jnc		CarryFlag0
			jc		CarryFlag1
CarryFlag0:
			test	ax, 1
			jnz		CF0LSB1
			jz		Shift
CF0LSB1:
			sub		cx, di
			sbb		dx, si
			jmp		Shift
CarryFlag1:
			test	ax, 1
			jnz		Shift
			jz		CF1LSB0
CF1LSB0:
			add		cx, di
			adc		dx, si
			jmp		Shift
Shift:
			sar		dx, 1
			rcr		cx, 1
			rcr		bx, 1
			rcr		ax, 1
			
			push	cx
			mov		cx, [bp]
			dec		cx
			mov		[bp], cx
			pop		cx

			jnz		TheLoop

			ret

BoothsAlgorithm32bit	ENDP




		END	testMul
