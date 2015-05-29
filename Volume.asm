INCLUDE	PCMAC.INC
		.MODEL	SMALL
		.386
		.STACK 100h
		.DATA
		.CODE

l	dw	00002h
w	dw	00002h
h	dw	00002h

		EXTERN	PutDDec : NEAR
Volume	PROC

	mov	ax, @data
	mov ds, ax

	mov ax, l
	mov bx, w
	mul bx		
	shl eax, 16     
	mov ax, dx		
	mov dx, h
	shl edx, 16
	mul edx		
	mov eax, edx
	call PutDDec
	mov al, 00
	mov ah, 4ch
	int 21h

Volume	ENDP

		END		Volume
