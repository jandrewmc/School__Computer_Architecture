.model	small
.8086
.stack	100h
.data
	num0		dw		0CCCCh
	num1		dw		0DDDDh
	num2		dw		0EEEEh
	num3		dw		0FFFFh
.code
		extern	PutHex : NEAR
TestMem		proc

			mov		ax, @data
			mov		ds, ax



			mov		ax, offset num0
			mov		di, ax
			mov		ax, [di]
			
			call	PutHex




			mov		ah, 4ch
			int		21h

TestMem		endp
			end TestMem
