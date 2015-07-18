.model	small
.8086
.stack	100h
.data
.code
	extern putdec:far
TestStack	proc

			mov		ax, @data
			mov		ds, ax

			call putdec		
			
			mov		ah, 4ch
			int		21h
			
TestStack	endp


NearProc1	proc

			call	NearProc2
			ret

NearProc1	endp


NearProc2	proc

			ret

NearProc2	endp

			end	TestStack
