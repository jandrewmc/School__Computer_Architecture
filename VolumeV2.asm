				.model	small
				.8086
				.stack	100h
				.data
width_message	db		'Width > $'
height_message	db		'Height > $'
length_message	db		'Length > $'
				.code
Volume			proc
				extern	GetDec : near, PutDec : near
				
				mov		ax, @data
				mov		ds, ax

				mov		dx, offset width_message	
				mov		ah, 9h						
				int		21h
				call	GetDec
				push	ax
				call	GetDec
				push	ax			

				mov		dx, offset height_message	
				mov		ah, 9h						
				int		21h
				call	GetDec
				push	ax
				call	GetDec
				push 	ax							

				mov		dx, offset length_message
				mov		ah, 9h						
				int		21h
				call 	GetDec
				push	ax						
				call 	GetDec
				push	ax

				pop		bx			;inches of length
				pop		ax			;feet of length
				mov		dx, 12
				mul		dx			;dx:ax = length in feet * 12
				
								
				mov		ah, 4ch				
				int		21h

Volume			endP
				end		Volume

