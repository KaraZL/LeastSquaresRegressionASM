.model flat,c

.code

LeastSquares	proc
				
				push ebp
				mov ebp,esp
				;local storage
				sub esp,8

				xor eax,eax
				;=n
				mov ecx,[ebp+16]		
				test ecx,ecx
				jle Finish

				;x and y
				mov eax, [ebp+8]
				mov edx, [ebp+12]

				;initialize fpu for sums
				;sum(x) sum(y) sum(x^2) sum(xy)
				fldz						;sum(xy) = 0
				fldz						;...
				fldz
				fldz

@@:
				;current stack sum x,y,xx,xy
				fld real8 ptr[edx]
				;y,sx,sy,sxx,sxy
				fadd st(2), st(0)

				fld real8 ptr[eax]
				;x,y,sx,sy,sxx,sxy
				fadd st(2), st(0)
				;copy x
				fld st(0)
				fld st(0)
				;current stack x,x,x,y,sx,sy,sxx,sxy
				;sum xx
				fmulp
				faddp st(5), st(0) ;store in 5 and pop
				;sum xy
				fmulp
				faddp st(4), st(0) ;store in 4 and pop

				;par 8 - real8
				add eax,8
				add edx,8
				dec ecx
				;jump back to @@
				jnz @B

				;-----------------------------------------------------------------------
				; denom = n * sum_xx - (sum_x)^2
				; current stack sx,sy,sxx,sxy
				fild dword ptr [ebp+16] ;convert n integer to double dec
				fmul st(0), st(3) ;store in 0

				fld st(1)
				fld st(0)
				; sx,sx, n*sxx, sx,sy....
				;denom
				fmulp
				fsubp
				fstp real8 ptr[ebp-8]


				;--------------------------------------------------------------------------
				; m = (n * sxy - sx * sy) / denom
				fild dword ptr [ebp+16]
				;num
				fmul st(0), st(4)
				fld st(1) ;sx
				fld st(3) ;sy
				fmulp
				fsubp

				fdiv real8 ptr [ebp-8] ;store in st(0)
				mov eax, [ebp+20] ;=m
				fstp real8 ptr[eax]

				;-------------------------------------------------------------------
				;b = (sxx * sy - sx * sxy) / denom
				;stack sx,sy,sxx,sxy

				fxch st(2) ;exchange the contents
				fmulp
				;sxxsy, sx, sy
				fxch st(2)
				fmulp
				fsubp

				fdiv real8 ptr [ebp-8]
				mov eax, [ebp+24] ;=b
				fstp real8 ptr [eax]
				mov eax, 1

Finish:
				mov esp, ebp
				pop ebp
				ret



LeastSquares	endp
				end