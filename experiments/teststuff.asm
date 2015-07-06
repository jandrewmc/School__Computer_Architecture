include pcmac.inc
.model small
.8086
.stack 100h
.data
this_data	db	'abcdefghijklmnopqrstuvwxy'
this_data_2 db	'z'
.code
teststuff	proc
			mov		ax, @data
			mov		ds, ax

			mov		si, offset this_data_2
			mov		cx, 10
theloop:
			mov		al, [si]

			_putch

			dec		si
			dec		si
			dec		cx
			jnz theloop

			mov		ah, 4ch
			int		21h
teststuff 	endp
end	teststuff
