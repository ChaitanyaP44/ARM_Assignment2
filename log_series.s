; Log(1+x) series implementation 
; Log(1+x) = x-(x^2/2)+(x^3/3)-(x^4/4).....(x^n/n)
; Series is implemented upto 7th term and result register S7 stores 33506.0546875 (in decimal) after adding 7th term which is correct as expected. 
	AREA log_series, CODE, READONLY
	EXPORT __main
	ENTRY
; 
; S0 -> Value of x (here x is taken as 6)
; S1 -> Value of n (current number of term) and also considered as denominator of a particular term (temporary storage)
; S2 -> Max value of n  (i.e. number of terms for which calculation is done, n_max=7)
; S3 -> Numerator of a particular term (temporary storage )
; S4 -> Holds next term which is to be added to the series
; S6 -> Stores 1 to increament n by 1
; S7 -> Result
  
__main FUNCTION
	
	
	VLDR.F32 S0, =6				    ; Value of x in log(1+x)
	VLDR.F32 S1, =1					; Current term index i.e. value of n
	VLDR.F32 S2, =8				    ; Maximum number of terms to be considered i.e. n_max=7 (it is taken as 8 loop stops after 7th term is added)
	VMOV.F32 S3, S0					; Storing first term of the series to S3, this will be updated on each iteration.
	VLDR.F32 S6, =1					; constant to increment the counter by at every loop
	VLDR.F32 S7, =0
	VLDR.F32 S8, =1                 ; sign bit which toggles in each iteration
	
loop
	VDIV.F32 S4, S3, S1			    ; Calculating (x^n/n)
	VMUL.F32 S4, S4, S8                          ; changing sign of term
	VADD.F32 S7, S7, S4				; Updating result register by adding current term
	
	VADD.F32 S1, S1, S6		        ; Updates n i.e. n=n+1
	VMUL.F32 S3, S3, S0				; Updates numerator (multiplying by 'x')
	VNEG.F32 S8, S8					; To Toggle sign of next term
	VCMP.F32 S1, S2					; Checks stop condition (when n reaches maximum n_max)
	VMRS APSR_nzcv, FPSCR			; Transfer FP status register to ARM APSR. This instuction is required for subsequent branch conditional instruction.
	BNE loop						; when exit condition is NOT satisfied

stop B stop ; program stops after adding 7th term.

	
	ENDFUNC
	END 
