CP1_JUMP_TABLE:
  dq CP1_ADD,	  CP1_SUB,     CP1_MUL,     CP1_DIV,	 CP1_SQRT,    CP1_ABS,	   CP1_MOV,	CP1_NEG      ; Op Code 00..07
  dq CP1_ROUND.L, CP1_TRUNC.L, CP1_CEIL.L,  CP1_FLOOR.L, CP1_ROUND.W, CP1_TRUNC.W, CP1_CEIL.W,	CP1_FLOOR.W  ; Op Code 08..15
  dq CP1_RESERVED,CP1_RESERVED,CP1_RESERVED,CP1_RESERVED,CP1_RESERVED,CP1_RESERVED,CP1_RESERVED,CP1_RESERVED ; Op Code 16..23
  dq CP1_RESERVED,CP1_RESERVED,CP1_RESERVED,CP1_RESERVED,CP1_RESERVED,CP1_RESERVED,CP1_RESERVED,CP1_RESERVED ; Op Code 24..31
  dq CP1_CVT.S,   CP1_CVT.D,   CP1_RESERVED,CP1_RESERVED,CP1_CVT.W,   CP1_CVT.L,   CP1_RESERVED,CP1_RESERVED ; Op Code 32..39
  dq CP1_RESERVED,CP1_RESERVED,CP1_RESERVED,CP1_RESERVED,CP1_RESERVED,CP1_RESERVED,CP1_RESERVED,CP1_RESERVED ; Op Code 40..47
  dq CP1_C.F,	  CP1_C.UN,    CP1_C.EQ,    CP1_C.UEQ,	 CP1_C.OLT,   CP1_C.ULT,   CP1_C.OLE,	CP1_C.ULE    ; Op Code 48..55
  dq CP1_C.SF,	  CP1_C.NGLE,  CP1_C.SEQ,   CP1_C.NGL,	 CP1_C.LT,    CP1_C.NGE,   CP1_C.LE,	CP1_C.NGT    ; Op Code 56..63

CP1_ADD: ; Op Code 17:00 - CP1 R-Instruction Format + Function: ADD.FMT FD,FS,FT Floating-Point Add
  mov	   ebx,eax	       ; EBX = Instruction
  shr	   ebx,6	       ; EBX >>= 6
  and	   ebx,$1F	       ; EBX = FD (5-Bit)
  mov	   ecx,eax	       ; ECX = Instruction
  shr	   ecx,11	       ; ECX >>= 11
  and	   ecx,$1F	       ; ECX = FS (5-Bit)
  mov	   edx,eax	       ; EDX = Instruction
  shr	   edx,16	       ; EDX >>= 16
  and	   edx,$1F	       ; EDX = FT (5-Bit)
  shr	   eax,21	       ; EAX >>= 21
  and	   eax,$7	       ; EAX = FMT (3-Bit)
  cmp	   al,0 	       ; Compare FMT To Zero
  jne	   CP1_ADD_DOUBLE      ; IF (FMT == 0) Single Precision, ELSE Double Precision
  fld	   dword[rcx*8+CP1_F0] ; ST(0) = [FS] (Single)
  fld	   dword[rdx*8+CP1_F0] ; ST(1) = [FT] (Single)
  faddp 		       ; ST(0) = FS + FT
  fstp	   dword[rbx*8+CP1_F0] ; FD = ST(0) (Single)
  jmp	   CPU_INST_EMU_END
  CP1_ADD_DOUBLE:
  fld	   [rcx*8+CP1_F0]      ; ST(0) = [FS] (Double)
  fld	   [rdx*8+CP1_F0]      ; ST(1) = [FT] (Double)
  faddp 		       ; ST(0) = FS + FT
  fstp	   [rbx*8+CP1_F0]      ; FD = ST(0) (Double)
  jmp	   CPU_INST_EMU_END
CP1_SUB: ; Op Code 17:01 - CP1 R-Instruction Format + Function: SUB.FMT FD,FS,FT - Floating-Point Subtract
  mov	   ebx,eax	       ; EBX = Instruction
  shr	   ebx,6	       ; EBX >>= 6
  and	   ebx,$1F	       ; EBX = FD (5-Bit)
  mov	   ecx,eax	       ; ECX = Instruction
  shr	   ecx,11	       ; ECX >>= 11
  and	   ecx,$1F	       ; ECX = FS (5-Bit)
  mov	   edx,eax	       ; EDX = Instruction
  shr	   edx,16	       ; EDX >>= 16
  and	   edx,$1F	       ; EDX = FT (5-Bit)
  shr	   eax,21	       ; EAX >>= 21
  and	   eax,$7	       ; EAX = FMT (3-Bit)
  cmp	   al,0 	       ; Compare FMT To Zero
  jne	   CP1_SUB_DOUBLE      ; IF (FMT == 0) Single Precision, ELSE Double Precision
  fld	   dword[rcx*8+CP1_F0] ; ST(0) = [FS] (Single)
  fld	   dword[rdx*8+CP1_F0] ; ST(1) = [FT] (Single)
  fsubp 		       ; ST(0) = FS - FT
  fstp	   dword[rbx*8+CP1_F0] ; FD = ST(0) (Single)
  jmp	   CPU_INST_EMU_END
  CP1_SUB_DOUBLE:
  fld	   [rcx*8+CP1_F0]      ; ST(0) = [FS] (Double)
  fld	   [rdx*8+CP1_F0]      ; ST(1) = [FT] (Double)
  fsubp 		       ; ST(0) = FS - FT
  fstp	   [rbx*8+CP1_F0]      ; FD = ST(0) (Double)
  jmp	   CPU_INST_EMU_END
CP1_MUL: ; Op Code 17:02 - CP1 R-Instruction Format + Function: MUL.FMT FD,FS,FT - Floating-Point Multiply
  mov	   ebx,eax	       ; EBX = Instruction
  shr	   ebx,6	       ; EBX >>= 6
  and	   ebx,$1F	       ; EBX = FD (5-Bit)
  mov	   ecx,eax	       ; ECX = Instruction
  shr	   ecx,11	       ; ECX >>= 11
  and	   ecx,$1F	       ; ECX = FS (5-Bit)
  mov	   edx,eax	       ; EDX = Instruction
  shr	   edx,16	       ; EDX >>= 16
  and	   edx,$1F	       ; EDX = FT (5-Bit)
  shr	   eax,21	       ; EAX >>= 21
  and	   eax,$7	       ; EAX = FMT (3-Bit)
  cmp	   al,0 	       ; Compare FMT To Zero
  jne	   CP1_MUL_DOUBLE      ; IF (FMT == 0) Single Precision, ELSE Double Precision
  fld	   dword[rcx*8+CP1_F0] ; ST(0) = [FS] (Single)
  fld	   dword[rdx*8+CP1_F0] ; ST(1) = [FT] (Single)
  fmulp 		       ; ST(0) = FS * FT
  fstp	   dword[rbx*8+CP1_F0] ; FD = ST(0) (Single)
  jmp	   CPU_INST_EMU_END
  CP1_MUL_DOUBLE:
  fld	   [rcx*8+CP1_F0]      ; ST(0) = [FS] (Double)
  fld	   [rdx*8+CP1_F0]      ; ST(1) = [FT] (Double)
  fmulp 		       ; ST(0) = FS * FT
  fstp	   [rbx*8+CP1_F0]      ; FD = ST(0) (Double)
  jmp	   CPU_INST_EMU_END
CP1_DIV: ; Op Code 17:03 - CP1 R-Instruction Format + Function: DIV.FMT FD,FS,FT - Floating-Point Divide
  mov	   ebx,eax	       ; EBX = Instruction
  shr	   ebx,6	       ; EBX >>= 6
  and	   ebx,$1F	       ; EBX = FD (5-Bit)
  mov	   ecx,eax	       ; ECX = Instruction
  shr	   ecx,11	       ; ECX >>= 11
  and	   ecx,$1F	       ; ECX = FS (5-Bit)
  mov	   edx,eax	       ; EDX = Instruction
  shr	   edx,16	       ; EDX >>= 16
  and	   edx,$1F	       ; EDX = FT (5-Bit)
  shr	   eax,21	       ; EAX >>= 21
  and	   eax,$7	       ; EAX = FMT (3-Bit)
  cmp	   al,0 	       ; Compare FMT To Zero
  jne	   CP1_DIV_DOUBLE      ; IF (FMT == 0) Single Precision, ELSE Double Precision
  fld	   dword[rcx*8+CP1_F0] ; ST(0) = [FS] (Single)
  fld	   dword[rdx*8+CP1_F0] ; ST(1) = [FT] (Single)
  fdivp 		       ; ST(0) = FS / FT
  fstp	   dword[rbx*8+CP1_F0] ; FD = ST(0) (Single)
  jmp	   CPU_INST_EMU_END
  CP1_DIV_DOUBLE:
  fld	   [rcx*8+CP1_F0]      ; ST(0) = [FS] (Double)
  fld	   [rdx*8+CP1_F0]      ; ST(1) = [FT] (Double)
  fdivp 		       ; ST(0) = FS / FT
  fstp	   [rbx*8+CP1_F0]      ; FD = ST(0) (Double)
  jmp	   CPU_INST_EMU_END
CP1_SQRT: ; Op Code 17:04 - CP1 R-Instruction Format + Function: SQRT.FMT FD,FS - Floating-Point Square Root
  mov	   ebx,eax	       ; EBX = Instruction
  shr	   ebx,6	       ; EBX >>= 6
  and	   ebx,$1F	       ; EBX = FD (5-Bit)
  mov	   ecx,eax	       ; ECX = Instruction
  shr	   ecx,11	       ; ECX >>= 11
  and	   ecx,$1F	       ; ECX = FS (5-Bit)
  shr	   eax,21	       ; EAX >>= 21
  and	   eax,$7	       ; EAX = FMT (3-Bit)
  cmp	   al,0 	       ; Compare FMT To Zero
  jne	   CP1_SQRT_DOUBLE     ; IF (FMT == 0) Single Precision, ELSE Double Precision
  fld	   dword[rcx*8+CP1_F0] ; ST(0) = [FS] (Single)
  fsqrt 		       ; ST(0) = SQRT(FS)
  fstp	   dword[rbx*8+CP1_F0] ; FD = ST(0) (Single)
  jmp	   CPU_INST_EMU_END
  CP1_SQRT_DOUBLE:
  fld	   [rcx*8+CP1_F0]      ; ST(0) = [FS] (Double)
  fsqrt 		       ; ST(0) = SQRT(FS)
  fstp	   [rbx*8+CP1_F0]      ; FD = ST(0) (Double)
  jmp	   CPU_INST_EMU_END
CP1_ABS: ; Op Code 17:05 - CP1 R-Instruction Format + Function: ABS.FMT FD,FS - Floating-Point Absolute Value
  mov	   ebx,eax	       ; EBX = Instruction
  shr	   ebx,6	       ; EBX >>= 6
  and	   ebx,$1F	       ; EBX = FD (5-Bit)
  mov	   ecx,eax	       ; ECX = Instruction
  shr	   ecx,11	       ; ECX >>= 11
  and	   ecx,$1F	       ; ECX = FS (5-Bit)
  shr	   eax,21	       ; EAX >>= 21
  and	   eax,$7	       ; EAX = FMT (3-Bit)
  cmp	   al,0 	       ; Compare FMT To Zero
  jne	   CP1_ABS_DOUBLE      ; IF (FMT == 0) Single Precision, ELSE Double Precision
  fld	   dword[rcx*8+CP1_F0] ; ST(0) = [FS] (Single)
  fabs			       ; ST(0) = ABS(FS)
  fstp	   dword[rbx*8+CP1_F0] ; FD = ST(0) (Single)
  jmp	   CPU_INST_EMU_END
  CP1_ABS_DOUBLE:
  fld	   [rcx*8+CP1_F0]      ; ST(0) = [FS] (Double)
  fabs			       ; ST(0) = ABS(FS)
  fstp	   [rbx*8+CP1_F0]      ; FD = ST(0) (Double)
  jmp	   CPU_INST_EMU_END
CP1_MOV: ; Op Code 17:06 - CP1 R-Instruction Format + Function: MOV.FMT FD,FS - Floating-Point Move
  mov	   ebx,eax	       ; EBX = Instruction
  shr	   ebx,6	       ; EBX >>= 6
  and	   ebx,$1F	       ; EBX = FD (5-Bit)
  mov	   ecx,eax	       ; ECX = Instruction
  shr	   ecx,11	       ; ECX >>= 11
  and	   ecx,$1F	       ; ECX = FS (5-Bit)
  shr	   eax,21	       ; EAX >>= 21
  and	   eax,$7	       ; EAX = FMT (3-Bit)
  cmp	   al,0 	       ; Compare FMT To Zero
  jne	   CP1_MOV_DOUBLE      ; IF (FMT == 0) Single Precision, ELSE Double Precision
  fld	   dword[rcx*8+CP1_F0] ; ST(0) = [FS] (Single)
  fstp	   dword[rbx*8+CP1_F0] ; FD = ST(0) (Single)
  jmp	   CPU_INST_EMU_END
  CP1_MOV_DOUBLE:
  fld	   [rcx*8+CP1_F0]      ; ST(0) = [FS] (Double)
  fstp	   [rbx*8+CP1_F0]      ; FD = ST(0) (Double)
  jmp	   CPU_INST_EMU_END
CP1_NEG: ; Op Code 17:07 - CP1 R-Instruction Format + Function: NEG.FMT FD,FS - Floating-Point Negate
  mov	   ebx,eax	       ; EBX = Instruction
  shr	   ebx,6	       ; EBX >>= 6
  and	   ebx,$1F	       ; EBX = FD (5-Bit)
  mov	   ecx,eax	       ; ECX = Instruction
  shr	   ecx,11	       ; ECX >>= 11
  and	   ecx,$1F	       ; ECX = FS (5-Bit)
  shr	   eax,21	       ; EAX >>= 21
  and	   eax,$7	       ; EAX = FMT (3-Bit)
  cmp	   al,0 	       ; Compare FMT To Zero
  jne	   CP1_NEG_DOUBLE      ; IF (FMT == 0) Single Precision, ELSE Double Precision
  fld	   dword[rcx*8+CP1_F0] ; ST(0) = [FS] (Single)
  fchs			       ; ST(0) = -FS
  fstp	   dword[rbx*8+CP1_F0] ; FD = ST(0) (Single)
  jmp	   CPU_INST_EMU_END
  CP1_NEG_DOUBLE:
  fld	   [rcx*8+CP1_F0]      ; ST(0) = [FS] (Double)
  fchs			       ; ST(0) = -FS
  fstp	   [rbx*8+CP1_F0]      ; FD = ST(0) (Double)
  jmp	   CPU_INST_EMU_END
CP1_ROUND.L: ; Op Code 17:08 - CP1 R-Instruction Format + Function: ROUND.L.FMT FD,FS - Floating-Point Round To Long Fixed-Point
  mov	   ebx,eax	       ; EBX = Instruction
  shr	   ebx,6	       ; EBX >>= 6
  and	   ebx,$1F	       ; EBX = FD (5-Bit)
  mov	   ecx,eax	       ; ECX = Instruction
  shr	   ecx,11	       ; ECX >>= 11
  and	   ecx,$1F	       ; ECX = FS (5-Bit)
  shr	   eax,21	       ; EAX >>= 21
  and	   eax,$7	       ; EAX = FMT (3-Bit)
  cmp	   al,0 	       ; Compare FMT To Zero
  jne	   CP1_ROUND.L_DOUBLE  ; IF (FMT == 0) Single Precision, ELSE Double Precision
  fld	   dword[rcx*8+CP1_F0] ; ST(0) = [FS] (Single)
  fistp    [rbx*8+CP1_F0]      ; FD = ROUND(FS) (Single)
  jmp	   CPU_INST_EMU_END
  CP1_ROUND.L_DOUBLE:
  fld	   [rcx*8+CP1_F0]      ; ST(0) = [FS] (Double)
  fistp    [rbx*8+CP1_F0]      ; FD = ROUND(FS) (Double)
  jmp	   CPU_INST_EMU_END
CP1_TRUNC.L: ; Op Code 17:09 - CP1 R-Instruction Format + Function: TRUNC.L.FMT FD,FS - Floating-Point Truncate To Long Fixed-Point
  mov	   ebx,eax	       ; EBX = Instruction
  shr	   ebx,6	       ; EBX >>= 6
  and	   ebx,$1F	       ; EBX = FD (5-Bit)
  mov	   ecx,eax	       ; ECX = Instruction
  shr	   ecx,11	       ; ECX >>= 11
  and	   ecx,$1F	       ; ECX = FS (5-Bit)
  shr	   eax,21	       ; EAX >>= 21
  and	   eax,$7	       ; EAX = FMT (3-Bit)
  cmp	   al,0 	       ; Compare FMT To Zero
  jne	   CP1_TRUNC.L_DOUBLE  ; IF (FMT == 0) Single Precision, ELSE Double Precision
  fld	   dword[rcx*8+CP1_F0] ; ST(0) = [FS] (Single)
  fisttp   [rbx*8+CP1_F0]      ; FD = TRUNC(FS) (Single)
  jmp	   CPU_INST_EMU_END
  CP1_TRUNC.L_DOUBLE:
  fld	   [rcx*8+CP1_F0]      ; ST(0) = [FS] (Double)
  fisttp   [rbx*8+CP1_F0]      ; FD = TRUNC(FS) (Double)
  jmp	   CPU_INST_EMU_END
CP1_CEIL.L: ; Op Code 17:10 - CP1 R-Instruction Format + Function: CEIL.L.FMT FD,FS - Floating-Point Ceiling Convert To Long Fixed-Point
  fstcw    [FPU_CTRL]	       ; Store FPU Control Word
  or	   [FPU_CTRL],$0800    ; Set FE_UPWARD In FPU Control Word
  fldcw    [FPU_CTRL]	       ; Load FPU Control Word
  mov	   ebx,eax	       ; EBX = Instruction
  shr	   ebx,6	       ; EBX >>= 6
  and	   ebx,$1F	       ; EBX = FD (5-Bit)
  mov	   ecx,eax	       ; ECX = Instruction
  shr	   ecx,11	       ; ECX >>= 11
  and	   ecx,$1F	       ; ECX = FS (5-Bit)
  shr	   eax,21	       ; EAX >>= 21
  and	   eax,$7	       ; EAX = FMT (3-Bit)
  cmp	   al,0 	       ; Compare FMT To Zero
  jne	   CP1_CEIL.L_DOUBLE   ; IF (FMT == 0) Single Precision, ELSE Double Precision
  fld	   dword[rcx*8+CP1_F0] ; ST(0) = [FS] (Single)
  fistp    [rbx*8+CP1_F0]      ; FD = CEIL(FS) (Single)
  and	   [FPU_CTRL],$F7FF    ; Clear FE_UPWARD In FPU Control Word
  fldcw    [FPU_CTRL]	       ; Load FPU Control Word
  jmp	   CPU_INST_EMU_END
  CP1_CEIL.L_DOUBLE:
  fld	   [rcx*8+CP1_F0]      ; ST(0) = [FS] (Double)
  fistp    [rbx*8+CP1_F0]      ; FD = CEIL(FS) (Double)
  and	   [FPU_CTRL],$F7FF    ; Clear FE_UPWARD In FPU Control Word
  fldcw    [FPU_CTRL]	       ; Load FPU Control Word
  jmp	   CPU_INST_EMU_END
CP1_FLOOR.L: ; Op Code 17:11 - CP1 R-Instruction Format + Function: FLOOR.L.FMT FD,FS - Floating-Point Floor Convert To Long Fixed-Point
  fstcw    [FPU_CTRL]	       ; Store FPU Control Word
  or	   [FPU_CTRL],$0400    ; Set FE_DOWNWARD In FPU Control Word
  fldcw    [FPU_CTRL]	       ; Load FPU Control Word
  mov	   ebx,eax	       ; EBX = Instruction
  shr	   ebx,6	       ; EBX >>= 6
  and	   ebx,$1F	       ; EBX = FD (5-Bit)
  mov	   ecx,eax	       ; ECX = Instruction
  shr	   ecx,11	       ; ECX >>= 11
  and	   ecx,$1F	       ; ECX = FS (5-Bit)
  shr	   eax,21	       ; EAX >>= 21
  and	   eax,$7	       ; EAX = FMT (3-Bit)
  cmp	   al,0 	       ; Compare FMT To Zero
  jne	   CP1_FLOOR.L_DOUBLE  ; IF (FMT == 0) Single Precision, ELSE Double Precision
  fld	   dword[rcx*8+CP1_F0] ; ST(0) = [FS] (Single)
  fistp    [rbx*8+CP1_F0]      ; FD = FLOOR(FS) (Single)
  and	   [FPU_CTRL],$FBFF    ; Clear FE_DOWNWARD In FPU Control Word
  fldcw    [FPU_CTRL]	       ; Load FPU Control Word
  jmp	   CPU_INST_EMU_END
  CP1_FLOOR.L_DOUBLE:
  fld	   [rcx*8+CP1_F0]      ; ST(0) = [FS] (Double)
  fistp    [rbx*8+CP1_F0]      ; FD = FLOOR(FS) (Double)
  and	   [FPU_CTRL],$FBFF    ; Clear FE_DOWNWARD In FPU Control Word
  fldcw    [FPU_CTRL]	       ; Load FPU Control Word
  jmp	   CPU_INST_EMU_END
CP1_ROUND.W: ; Op Code 17:12 - CP1 R-Instruction Format + Function: ROUND.W.FMT FD,FS - Floating-Point Round To Word Fixed-Point
  mov	   ebx,eax	       ; EBX = Instruction
  shr	   ebx,6	       ; EBX >>= 6
  and	   ebx,$1F	       ; EBX = FD (5-Bit)
  mov	   ecx,eax	       ; ECX = Instruction
  shr	   ecx,11	       ; ECX >>= 11
  and	   ecx,$1F	       ; ECX = FS (5-Bit)
  shr	   eax,21	       ; EAX >>= 21
  and	   eax,$7	       ; EAX = FMT (3-Bit)
  cmp	   al,0 	       ; Compare FMT To Zero
  jne	   CP1_ROUND.W_DOUBLE  ; IF (FMT == 0) Single Precision, ELSE Double Precision
  fld	   dword[rcx*8+CP1_F0] ; ST(0) = [FS] (Single)
  fistp    dword[rbx*8+CP1_F0] ; FD = ROUND(FS) (Single)
  jmp	   CPU_INST_EMU_END
  CP1_ROUND.W_DOUBLE:
  fld	   [rcx*8+CP1_F0]      ; ST(0) = [FS] (Double)
  fistp    dword[rbx*8+CP1_F0] ; FD = ROUND(FS) (Double)
  jmp	   CPU_INST_EMU_END
CP1_TRUNC.W: ; Op Code 17:13 - CP1 R-Instruction Format + Function: TRUNC.W.FMT FD,FS - Floating-Point Truncate To Word Fixed-Point
  mov	   ebx,eax	       ; EBX = Instruction
  shr	   ebx,6	       ; EBX >>= 6
  and	   ebx,$1F	       ; EBX = FD (5-Bit)
  mov	   ecx,eax	       ; ECX = Instruction
  shr	   ecx,11	       ; ECX >>= 11
  and	   ecx,$1F	       ; ECX = FS (5-Bit)
  shr	   eax,21	       ; EAX >>= 21
  and	   eax,$7	       ; EAX = FMT (3-Bit)
  cmp	   al,0 	       ; Compare FMT To Zero
  jne	   CP1_TRUNC.W_DOUBLE  ; IF (FMT == 0) Single Precision, ELSE Double Precision
  fld	   dword[rcx*8+CP1_F0] ; ST(0) = [FS] (Single)
  fisttp   dword[rbx*8+CP1_F0] ; FD = TRUNC(FS) (Single)
  jmp	   CPU_INST_EMU_END
  CP1_TRUNC.W_DOUBLE:
  fld	   [rcx*8+CP1_F0]      ; ST(0) = [FS] (Double)
  fisttp   dword[rbx*8+CP1_F0] ; FD = TRUNC(FS) (Double)
  jmp	   CPU_INST_EMU_END
CP1_CEIL.W: ; Op Code 17:14 - CP1 R-Instruction Format + Function: CEIL.W.FMT FD,FS - Floating-Point Ceiling Convert To Word Fixed-Point
  fstcw    [FPU_CTRL]	       ; Store FPU Control Word
  or	   [FPU_CTRL],$0800    ; Set FE_UPWARD In FPU Control Word
  fldcw    [FPU_CTRL]	       ; Load FPU Control Word
  mov	   ebx,eax	       ; EBX = Instruction
  shr	   ebx,6	       ; EBX >>= 6
  and	   ebx,$1F	       ; EBX = FD (5-Bit)
  mov	   ecx,eax	       ; ECX = Instruction
  shr	   ecx,11	       ; ECX >>= 11
  and	   ecx,$1F	       ; ECX = FS (5-Bit)
  shr	   eax,21	       ; EAX >>= 21
  and	   eax,$7	       ; EAX = FMT (3-Bit)
  cmp	   al,0 	       ; Compare FMT To Zero
  jne	   CP1_CEIL.W_DOUBLE   ; IF (FMT == 0) Single Precision, ELSE Double Precision
  fld	   dword[rcx*8+CP1_F0] ; ST(0) = [FS] (Single)
  fistp    dword[rbx*8+CP1_F0] ; FD = CEIL(FS) (Single)
  and	   [FPU_CTRL],$F7FF    ; Clear FE_UPWARD In FPU Control Word
  fldcw    [FPU_CTRL]	       ; Load FPU Control Word
  jmp	   CPU_INST_EMU_END
  CP1_CEIL.W_DOUBLE:
  fld	   [rcx*8+CP1_F0]      ; ST(0) = [FS] (Double)
  fistp    dword[rbx*8+CP1_F0] ; FD = CEIL(FS) (Double)
  and	   [FPU_CTRL],$F7FF    ; Clear FE_UPWARD In FPU Control Word
  fldcw    [FPU_CTRL]	       ; Load FPU Control Word
  jmp	   CPU_INST_EMU_END
CP1_FLOOR.W: ; Op Code 17:15 - CP1 R-Instruction Format + Function: FLOOR.W.FMT FD,FS - Floating-Point Floor Convert To Word Fixed-Point
  fstcw    [FPU_CTRL]	       ; Store FPU Control Word
  or	   [FPU_CTRL],$0400    ; Set FE_DOWNWARD In FPU Control Word
  fldcw    [FPU_CTRL]	       ; Load FPU Control Word
  mov	   ebx,eax	       ; EBX = Instruction
  shr	   ebx,6	       ; EBX >>= 6
  and	   ebx,$1F	       ; EBX = FD (5-Bit)
  mov	   ecx,eax	       ; ECX = Instruction
  shr	   ecx,11	       ; ECX >>= 11
  and	   ecx,$1F	       ; ECX = FS (5-Bit)
  shr	   eax,21	       ; EAX >>= 21
  and	   eax,$7	       ; EAX = FMT (3-Bit)
  cmp	   al,0 	       ; Compare FMT To Zero
  jne	   CP1_FLOOR.W_DOUBLE  ; IF (FMT == 0) Single Precision, ELSE Double Precision
  fld	   dword[rcx*8+CP1_F0] ; ST(0) = [FS] (Single)
  fistp    dword[rbx*8+CP1_F0] ; FD = FLOOR(FS) (Single)
  and	   [FPU_CTRL],$FBFF    ; Clear FE_DOWNWARD In FPU Control Word
  fldcw    [FPU_CTRL]	       ; Load FPU Control Word
  jmp	   CPU_INST_EMU_END
  CP1_FLOOR.W_DOUBLE:
  fld	   [rcx*8+CP1_F0]      ; ST(0) = [FS] (Double)
  fistp    dword[rbx*8+CP1_F0] ; FD = FLOOR(FS) (Double)
  and	   [FPU_CTRL],$FBFF    ; Clear FE_DOWNWARD In FPU Control Word
  fldcw    [FPU_CTRL]	       ; Load FPU Control Word
  jmp	   CPU_INST_EMU_END
CP1_CVT.S: ; Op Code 17:32 - CP1 R-Instruction Format + Function: CVT.S.FMT FD,FS - Floating-Point Convert To Single Floating-Point
  mov	   ebx,eax	       ; EBX = Instruction
  shr	   ebx,6	       ; EBX >>= 6
  and	   ebx,$1F	       ; EBX = FD (5-Bit)
  mov	   ecx,eax	       ; ECX = Instruction
  shr	   ecx,11	       ; ECX >>= 11
  and	   ecx,$1F	       ; ECX = FS (5-Bit)
  shr	   eax,21	       ; EAX >>= 21
  and	   eax,$7	       ; EAX = FMT (3-Bit)
  cmp	   al,4 	       ; Compare FMT To 4
  je	   CP1_CVT.S_WORD      ; IF (FMT == 4) Word Convert
  cmp	   al,5 	       ; Compare FMT To 5
  je	   CP1_CVT.S_LONG      ; IF (FMT == 5) Long Convert, ELSE Double Convert
  fld	   [rcx*8+CP1_F0]      ; ST(0) = [FS] (Double)
  fstp	   dword[rbx*8+CP1_F0] ; FD = ST(0) (Single)
  jmp	   CPU_INST_EMU_END
  CP1_CVT.S_WORD:
  fild	   dword[rcx*8+CP1_F0] ; ST(0) = [FS] (Word)
  fstp	   dword[rbx*8+CP1_F0] ; FD = ST(0) (Single)
  jmp	   CPU_INST_EMU_END
  CP1_CVT.S_LONG:
  fild	   [rcx*8+CP1_F0]      ; ST(0) = [FS] (Long)
  fstp	   dword[rbx*8+CP1_F0] ; FD = ST(0) (Single)
  jmp	   CPU_INST_EMU_END
CP1_CVT.D: ; Op Code 17:33 - CP1 R-Instruction Format + Function: CVT.D.FMT FD,FS - Floating-Point Convert To Double Floating-Point
  mov	   ebx,eax	       ; EBX = Instruction
  shr	   ebx,6	       ; EBX >>= 6
  and	   ebx,$1F	       ; EBX = FD (5-Bit)
  mov	   ecx,eax	       ; ECX = Instruction
  shr	   ecx,11	       ; ECX >>= 11
  and	   ecx,$1F	       ; ECX = FS (5-Bit)
  shr	   eax,21	       ; EAX >>= 21
  and	   eax,$7	       ; EAX = FMT (3-Bit)
  cmp	   al,4 	       ; Compare FMT To 4
  je	   CP1_CVT.D_WORD      ; IF (FMT == 4) Word Convert
  cmp	   al,5 	       ; Compare FMT To 5
  je	   CP1_CVT.D_LONG      ; IF (FMT == 5) Long Convert, ELSE Single Convert
  fld	   dword[rcx*8+CP1_F0] ; ST(0) = [FS] (Single)
  fstp	   [rbx*8+CP1_F0]      ; FD = ST(0) (Double)
  jmp	   CPU_INST_EMU_END
  CP1_CVT.D_WORD:
  fild	   dword[rcx*8+CP1_F0] ; ST(0) = [FS] (Word)
  fstp	   [rbx*8+CP1_F0]      ; FD = ST(0) (Double)
  jmp	   CPU_INST_EMU_END
  CP1_CVT.D_LONG:
  fild	   [rcx*8+CP1_F0]      ; ST(0) = [FS] (Long)
  fstp	   [rbx*8+CP1_F0]      ; FD = ST(0) (Double)
  jmp	   CPU_INST_EMU_END
CP1_CVT.W: ; Op Code 17:36 - CP1 R-Instruction Format + Function: CVT.W.FMT FD,FS - Floating-Point Convert To Word Fixed-Point
  mov	   ebx,eax	       ; EBX = Instruction
  shr	   ebx,6	       ; EBX >>= 6
  and	   ebx,$1F	       ; EBX = FD (5-Bit)
  mov	   ecx,eax	       ; ECX = Instruction
  shr	   ecx,11	       ; ECX >>= 11
  and	   ecx,$1F	       ; ECX = FS (5-Bit)
  shr	   eax,21	       ; EAX >>= 21
  and	   eax,$7	       ; EAX = FMT (3-Bit)
  cmp	   al,0 	       ; Compare FMT To Zero
  jne	   CP1_CVT.W_DOUBLE    ; IF (FMT == 0) Single Convert, ELSE Double Convert
  fld	   dword[rcx*8+CP1_F0] ; ST(0) = [FS] (Single)
  fistp    [rbx*8+CP1_F0]      ; FD = ST(0) (Word)
  jmp	   CPU_INST_EMU_END
  CP1_CVT.W_DOUBLE:
  fld	   [rcx*8+CP1_F0]      ; ST(0) = [FS] (Double)
  fistp    [rbx*8+CP1_F0]      ; FD = ST(0) (Word)
  jmp	   CPU_INST_EMU_END
CP1_CVT.L: ; Op Code 17:37 - CP1 R-Instruction Format + Function: CVT.L.FMT FD,FS - Floating-Point Convert To Long Fixed-Point
  mov	   ebx,eax	       ; EBX = Instruction
  shr	   ebx,6	       ; EBX >>= 6
  and	   ebx,$1F	       ; EBX = FD (5-Bit)
  mov	   ecx,eax	       ; ECX = Instruction
  shr	   ecx,11	       ; ECX >>= 11
  and	   ecx,$1F	       ; ECX = FS (5-Bit)
  shr	   eax,21	       ; EAX >>= 21
  and	   eax,$7	       ; EAX = FMT (3-Bit)
  cmp	   al,0 	       ; Compare FMT To Zero
  jne	   CP1_CVT.L_DOUBLE    ; IF (FMT == 0) Single Convert, ELSE Double Convert
  fld	   dword[rcx*8+CP1_F0] ; ST(0) = [FS] (Single)
  fistp    [rbx*8+CP1_F0]      ; FD = ST(0) (Word)
  jmp	   CPU_INST_EMU_END
  CP1_CVT.L_DOUBLE:
  fld	   [rcx*8+CP1_F0]      ; ST(0) = [FS] (Double)
  fistp    [rbx*8+CP1_F0]      ; FD = ST(0) (Word)
  jmp	   CPU_INST_EMU_END
CP1_C.F: ; Op Code 17:48 - CP1 R-Instruction Format + Function: C.F.FMT FS,FT - Floating-Point Compare False
  mov	   ebx,eax	       ; EBX = Instruction
  shr	   ebx,11	       ; EBX >>= 11
  and	   ebx,$1F	       ; EBX = FS (5-Bit)
  mov	   ecx,eax	       ; ECX = Instruction
  shr	   ecx,16	       ; ECX >>= 16
  and	   ecx,$1F	       ; ECX = FT (5-Bit)
  shr	   eax,21	       ; EAX >>= 21
  and	   eax,$7	       ; EAX = FMT (3-Bit)
  cmp	   al,0 	       ; Compare FMT To Zero
  jne	   CP1_C.F_DOUBLE      ; IF (FMT == 0) Single Compare, ELSE Double Compare
  fld	   dword[rcx*8+CP1_F0] ; ST(0) = [FT] (Single)
  fld	   dword[rbx*8+CP1_F0] ; ST(1) = [FS] (Single)
  fcomip   st1		       ; Compare FS To FT
  mov	   [CP1_FP],0	       ; FP = 0
  fstp	   st0		       ; POP Stack
  jmp	   CPU_INST_EMU_END
  CP1_C.F_DOUBLE:
  fld	   [rcx*8+CP1_F0]      ; ST(0) = [FT] (Double)
  fld	   [rbx*8+CP1_F0]      ; ST(1) = [FS] (Double)
  fcomip   st1		       ; Compare FS To FT
  mov	   [CP1_FP],0	       ; FP = 0
  fstp	   st0		       ; POP Stack
  jmp	   CPU_INST_EMU_END
CP1_C.UN: ; Op Code 17:49 - CP1 R-Instruction Format + Function: C.UN.FMT FS,FT - Floating-Point Compare Unordered
  mov	   ebx,eax	       ; EBX = Instruction
  shr	   ebx,11	       ; EBX >>= 11
  and	   ebx,$1F	       ; EBX = FS (5-Bit)
  mov	   ecx,eax	       ; ECX = Instruction
  shr	   ecx,16	       ; ECX >>= 16
  and	   ecx,$1F	       ; ECX = FT (5-Bit)
  shr	   eax,21	       ; EAX >>= 21
  and	   eax,$7	       ; EAX = FMT (3-Bit)
  cmp	   al,0 	       ; Compare FMT To Zero
  jne	   CP1_C.UN_DOUBLE     ; IF (FMT == 0) Single Compare, ELSE Double Compare
  fld	   dword[rcx*8+CP1_F0] ; ST(0) = [FT] (Single)
  fld	   dword[rbx*8+CP1_F0] ; ST(1) = [FS] (Single)
  fcomip   st1		       ; Compare FS To FT
  setp	   [CP1_FP]	       ; Set Byte IF Parity
  fstp	   st0		       ; POP Stack
  jmp	   CPU_INST_EMU_END
  CP1_C.UN_DOUBLE:
  fld	   [rcx*8+CP1_F0]      ; ST(0) = [FT] (Double)
  fld	   [rbx*8+CP1_F0]      ; ST(1) = [FS] (Double)
  fcomip   st1		       ; Compare FS To FT
  setp	   [CP1_FP]	       ; Set Byte IF Parity
  fstp	   st0		       ; POP Stack
  jmp	   CPU_INST_EMU_END
CP1_C.EQ: ; Op Code 17:50 - CP1 R-Instruction Format + Function: C.EQ.FMT FS,FT - Floating-Point Compare Equal
  mov	   ebx,eax	       ; EBX = Instruction
  shr	   ebx,11	       ; EBX >>= 11
  and	   ebx,$1F	       ; EBX = FS (5-Bit)
  mov	   ecx,eax	       ; ECX = Instruction
  shr	   ecx,16	       ; ECX >>= 16
  and	   ecx,$1F	       ; ECX = FT (5-Bit)
  shr	   eax,21	       ; EAX >>= 21
  and	   eax,$7	       ; EAX = FMT (3-Bit)
  cmp	   al,0 	       ; Compare FMT To Zero
  jne	   CP1_C.EQ_DOUBLE     ; IF (FMT == 0) Single Compare, ELSE Double Compare
  fld	   dword[rcx*8+CP1_F0] ; ST(0) = [FT] (Single)
  fld	   dword[rbx*8+CP1_F0] ; ST(1) = [FS] (Single)
  fcomip   st1		       ; Compare FS To FT
  setnp    al		       ; Set Byte IF NOT Parity
  sete	   [CP1_FP]	       ; Set Byte IF Equal
  and	   [CP1_FP],al	       ; FP &= AL
  fstp	   st0		       ; POP Stack
  jmp	   CPU_INST_EMU_END
  CP1_C.EQ_DOUBLE:
  fld	   [rcx*8+CP1_F0]      ; ST(0) = [FT] (Double)
  fld	   [rbx*8+CP1_F0]      ; ST(1) = [FS] (Double)
  fcomip   st1		       ; Compare FS To FT
  setnp    al		       ; Set Byte IF NOT Parity
  sete	   [CP1_FP]	       ; Set Byte IF Equal
  and	   [CP1_FP],al	       ; FP &= AL
  fstp	   st0		       ; POP Stack
  jmp	   CPU_INST_EMU_END
CP1_C.UEQ: ; Op Code 17:51 - CP1 R-Instruction Format + Function: C.UEQ.FMT FS,FT - Floating-Point Compare Unordered or Equal
  mov	   ebx,eax	       ; EBX = Instruction
  shr	   ebx,11	       ; EBX >>= 11
  and	   ebx,$1F	       ; EBX = FS (5-Bit)
  mov	   ecx,eax	       ; ECX = Instruction
  shr	   ecx,16	       ; ECX >>= 16
  and	   ecx,$1F	       ; ECX = FT (5-Bit)
  shr	   eax,21	       ; EAX >>= 21
  and	   eax,$7	       ; EAX = FMT (3-Bit)
  cmp	   al,0 	       ; Compare FMT To Zero
  jne	   CP1_C.UEQ_DOUBLE    ; IF (FMT == 0) Single Compare, ELSE Double Compare
  fld	   dword[rcx*8+CP1_F0] ; ST(0) = [FT] (Single)
  fld	   dword[rbx*8+CP1_F0] ; ST(1) = [FS] (Single)
  fcomip   st1		       ; Compare FS To FT
  setp	   al		       ; Set Byte IF Parity
  sete	   [CP1_FP]	       ; Set Byte IF Equal
  or	   [CP1_FP],al	       ; FP |= AL
  fstp	   st0		       ; POP Stack
  jmp	   CPU_INST_EMU_END
  CP1_C.UEQ_DOUBLE:
  fld	   [rcx*8+CP1_F0]      ; ST(0) = [FT] (Double)
  fld	   [rbx*8+CP1_F0]      ; ST(1) = [FS] (Double)
  fcomip   st1		       ; Compare FS To FT
  setp	   al		       ; Set Byte IF Parity
  sete	   [CP1_FP]	       ; Set Byte IF Equal
  or	   [CP1_FP],al	       ; FP |= AL
  fstp	   st0		       ; POP Stack
  jmp	   CPU_INST_EMU_END
CP1_C.OLT: ; Op Code 17:52 - CP1 R-Instruction Format + Function: C.OLT.FMT FS,FT - Floating-Point Compare Ordered Or Less Than
  mov	   ebx,eax	       ; EBX = Instruction
  shr	   ebx,11	       ; EBX >>= 11
  and	   ebx,$1F	       ; EBX = FS (5-Bit)
  mov	   ecx,eax	       ; ECX = Instruction
  shr	   ecx,16	       ; ECX >>= 16
  and	   ecx,$1F	       ; ECX = FT (5-Bit)
  shr	   eax,21	       ; EAX >>= 21
  and	   eax,$7	       ; EAX = FMT (3-Bit)
  cmp	   al,0 	       ; Compare FMT To Zero
  jne	   CP1_C.OLT_DOUBLE    ; IF (FMT == 0) Single Compare, ELSE Double Compare
  fld	   dword[rcx*8+CP1_F0] ; ST(0) = [FT] (Single)
  fld	   dword[rbx*8+CP1_F0] ; ST(1) = [FS] (Single)
  fcomip   st1		       ; Compare FS To FT
  setnp    al		       ; Set Byte IF NOT Parity
  setb	   [CP1_FP]	       ; Set Byte IF Below
  and	   [CP1_FP],al	       ; FP &= AL
  fstp	   st0		       ; POP Stack
  jmp	   CPU_INST_EMU_END
  CP1_C.OLT_DOUBLE:
  fld	   [rcx*8+CP1_F0]      ; ST(0) = [FT] (Double)
  fld	   [rbx*8+CP1_F0]      ; ST(1) = [FS] (Double)
  fcomip   st1		       ; Compare FS To FT
  setnp    al		       ; Set Byte IF NOT Parity
  setb	   [CP1_FP]	       ; Set Byte IF Below
  and	   [CP1_FP],al	       ; FP &= AL
  fstp	   st0		       ; POP Stack
  jmp	   CPU_INST_EMU_END
CP1_C.ULT: ; Op Code 17:53 - CP1 R-Instruction Format + Function: C.ULT.FMT FS,FT - Floating-Point Compare Unordered Or Less Than
  mov	   ebx,eax	       ; EBX = Instruction
  shr	   ebx,11	       ; EBX >>= 11
  and	   ebx,$1F	       ; EBX = FS (5-Bit)
  mov	   ecx,eax	       ; ECX = Instruction
  shr	   ecx,16	       ; ECX >>= 16
  and	   ecx,$1F	       ; ECX = FT (5-Bit)
  shr	   eax,21	       ; EAX >>= 21
  and	   eax,$7	       ; EAX = FMT (3-Bit)
  cmp	   al,0 	       ; Compare FMT To Zero
  jne	   CP1_C.ULT_DOUBLE    ; IF (FMT == 0) Single Compare, ELSE Double Compare
  fld	   dword[rcx*8+CP1_F0] ; ST(0) = [FT] (Single)
  fld	   dword[rbx*8+CP1_F0] ; ST(1) = [FS] (Single)
  fcomip   st1		       ; Compare FS To FT
  setp	   al		       ; Set Byte IF Parity
  setb	   [CP1_FP]	       ; Set Byte IF Below
  or	   [CP1_FP],al	       ; FP |= AL
  fstp	   st0		       ; POP Stack
  jmp	   CPU_INST_EMU_END
  CP1_C.ULT_DOUBLE:
  fld	   [rcx*8+CP1_F0]      ; ST(0) = [FT] (Double)
  fld	   [rbx*8+CP1_F0]      ; ST(1) = [FS] (Double)
  fcomip   st1		       ; Compare FS To FT
  setp	   al		       ; Set Byte IF Parity
  setb	   [CP1_FP]	       ; Set Byte IF Below
  or	   [CP1_FP],al	       ; FP |= AL
  fstp	   st0		       ; POP Stack
  jmp	   CPU_INST_EMU_END
CP1_C.OLE: ; Op Code 17:54 - CP1 R-Instruction Format + Function: C.OLE.FMT FS,FT - Floating-Point Compare Ordered Or Less Than Or Equal
  mov	   ebx,eax	       ; EBX = Instruction
  shr	   ebx,11	       ; EBX >>= 11
  and	   ebx,$1F	       ; EBX = FS (5-Bit)
  mov	   ecx,eax	       ; ECX = Instruction
  shr	   ecx,16	       ; ECX >>= 16
  and	   ecx,$1F	       ; ECX = FT (5-Bit)
  shr	   eax,21	       ; EAX >>= 21
  and	   eax,$7	       ; EAX = FMT (3-Bit)
  cmp	   al,0 	       ; Compare FMT To Zero
  jne	   CP1_C.OLE_DOUBLE    ; IF (FMT == 0) Single Compare, ELSE Double Compare
  fld	   dword[rcx*8+CP1_F0] ; ST(0) = [FT] (Single)
  fld	   dword[rbx*8+CP1_F0] ; ST(1) = [FS] (Single)
  fcomip   st1		       ; Compare FS To FT
  setnp    al		       ; Set Byte IF NOT Parity
  setbe    [CP1_FP]	       ; Set Byte IF Below Or Equal
  and	   [CP1_FP],al	       ; FP &= AL
  fstp	   st0		       ; POP Stack
  jmp	   CPU_INST_EMU_END
  CP1_C.OLE_DOUBLE:
  fld	   [rcx*8+CP1_F0]      ; ST(0) = [FT] (Double)
  fld	   [rbx*8+CP1_F0]      ; ST(1) = [FS] (Double)
  fcomip   st1		       ; Compare FS To FT
  setnp    al		       ; Set Byte IF NOT Parity
  setbe    [CP1_FP]	       ; Set Byte IF Below Or Equal
  and	   [CP1_FP],al	       ; FP &= AL
  fstp	   st0		       ; POP Stack
  jmp	   CPU_INST_EMU_END
CP1_C.ULE: ; Op Code 17:55 - CP1 R-Instruction Format + Function: C.ULE.FMT FS,FT - Floating-Point Compare Unordered Or Less Than Or Equal
  mov	   ebx,eax	       ; EBX = Instruction
  shr	   ebx,11	       ; EBX >>= 11
  and	   ebx,$1F	       ; EBX = FS (5-Bit)
  mov	   ecx,eax	       ; ECX = Instruction
  shr	   ecx,16	       ; ECX >>= 16
  and	   ecx,$1F	       ; ECX = FT (5-Bit)
  shr	   eax,21	       ; EAX >>= 21
  and	   eax,$7	       ; EAX = FMT (3-Bit)
  cmp	   al,0 	       ; Compare FMT To Zero
  jne	   CP1_C.ULE_DOUBLE    ; IF (FMT == 0) Single Compare, ELSE Double Compare
  fld	   dword[rcx*8+CP1_F0] ; ST(0) = [FT] (Single)
  fld	   dword[rbx*8+CP1_F0] ; ST(1) = [FS] (Single)
  fcomip   st1		       ; Compare FS To FT
  setp	   al		       ; Set Byte IF Parity
  setbe    [CP1_FP]	       ; Set Byte IF Below Or Equal
  or	   [CP1_FP],al	       ; FP |= AL
  fstp	   st0		       ; POP Stack
  jmp	   CPU_INST_EMU_END
  CP1_C.ULE_DOUBLE:
  fld	   [rcx*8+CP1_F0]      ; ST(0) = [FT] (Double)
  fld	   [rbx*8+CP1_F0]      ; ST(1) = [FS] (Double)
  fcomip   st1		       ; Compare FS To FT
  setp	   al		       ; Set Byte IF Parity
  setbe    [CP1_FP]	       ; Set Byte IF Below Or Equal
  or	   [CP1_FP],al	       ; FP |= AL
  fstp	   st0		       ; POP Stack
  jmp	   CPU_INST_EMU_END
CP1_C.SF: ; Op Code 17:56 - CP1 R-Instruction Format + Function: C.SF.FMT FS,FT - Floating-Point Compare Signaling False
  mov	   ebx,eax	       ; EBX = Instruction
  shr	   ebx,11	       ; EBX >>= 11
  and	   ebx,$1F	       ; EBX = FS (5-Bit)
  mov	   ecx,eax	       ; ECX = Instruction
  shr	   ecx,16	       ; ECX >>= 16
  and	   ecx,$1F	       ; ECX = FT (5-Bit)
  shr	   eax,21	       ; EAX >>= 21
  and	   eax,$7	       ; EAX = FMT (3-Bit)
  cmp	   al,0 	       ; Compare FMT To Zero
  jne	   CP1_C.SF_DOUBLE     ; IF (FMT == 0) Single Compare, ELSE Double Compare
  fld	   dword[rcx*8+CP1_F0] ; ST(0) = [FT] (Single)
  fld	   dword[rbx*8+CP1_F0] ; ST(1) = [FS] (Single)
  fcomip   st1		       ; Compare FS To FT
  mov	   [CP1_FP],0	       ; FP = 0
  fstp	   st0		       ; POP Stack
  jmp	   CPU_INST_EMU_END
  CP1_C.SF_DOUBLE:
  fld	   [rcx*8+CP1_F0]      ; ST(0) = [FT] (Double)
  fld	   [rbx*8+CP1_F0]      ; ST(1) = [FS] (Double)
  fcomip   st1		       ; Compare FS To FT
  mov	   [CP1_FP],0	       ; FP = 0
  fstp	   st0		       ; POP Stack
  jmp	   CPU_INST_EMU_END
CP1_C.NGLE: ; Op Code 17:57 - CP1 R-Instruction Format + Function: C.NGLE.FMT FS,FT - Floating-Point Compare Not Greater Than Or Less Than Or Equal
  mov	   ebx,eax	       ; EBX = Instruction
  shr	   ebx,11	       ; EBX >>= 11
  and	   ebx,$1F	       ; EBX = FS (5-Bit)
  mov	   ecx,eax	       ; ECX = Instruction
  shr	   ecx,16	       ; ECX >>= 16
  and	   ecx,$1F	       ; ECX = FT (5-Bit)
  shr	   eax,21	       ; EAX >>= 21
  and	   eax,$7	       ; EAX = FMT (3-Bit)
  cmp	   al,0 	       ; Compare FMT To Zero
  jne	   CP1_C.NGLE_DOUBLE   ; IF (FMT == 0) Single Compare, ELSE Double Compare
  fld	   dword[rcx*8+CP1_F0] ; ST(0) = [FT] (Single)
  fld	   dword[rbx*8+CP1_F0] ; ST(1) = [FS] (Single)
  fcomip   st1		       ; Compare FS To FT
  setp	   [CP1_FP]	       ; Set Byte IF Parity
  fstp	   st0		       ; POP Stack
  jmp	   CPU_INST_EMU_END
  CP1_C.NGLE_DOUBLE:
  fld	   [rcx*8+CP1_F0]      ; ST(0) = [FT] (Double)
  fld	   [rbx*8+CP1_F0]      ; ST(1) = [FS] (Double)
  fcomip   st1		       ; Compare FS To FT
  setp	   [CP1_FP]	       ; Set Byte IF Parity
  fstp	   st0		       ; POP Stack
  jmp	   CPU_INST_EMU_END
CP1_C.SEQ: ; Op Code 17:58 - CP1 R-Instruction Format + Function: C.SEQ.FMT FS,FT - Floating-Point Compare Signaling Equal
  mov	   ebx,eax	       ; EBX = Instruction
  shr	   ebx,11	       ; EBX >>= 11
  and	   ebx,$1F	       ; EBX = FS (5-Bit)
  mov	   ecx,eax	       ; ECX = Instruction
  shr	   ecx,16	       ; ECX >>= 16
  and	   ecx,$1F	       ; ECX = FT (5-Bit)
  shr	   eax,21	       ; EAX >>= 21
  and	   eax,$7	       ; EAX = FMT (3-Bit)
  cmp	   al,0 	       ; Compare FMT To Zero
  jne	   CP1_C.SEQ_DOUBLE    ; IF (FMT == 0) Single Compare, ELSE Double Compare
  fld	   dword[rcx*8+CP1_F0] ; ST(0) = [FT] (Single)
  fld	   dword[rbx*8+CP1_F0] ; ST(1) = [FS] (Single)
  fcomip   st1		       ; Compare FS To FT
  setnp    al		       ; Set Byte IF NOT Parity
  sete	   [CP1_FP]	       ; Set Byte IF Equal
  and	   [CP1_FP],al	       ; FP &= AL
  fstp	   st0		       ; POP Stack
  jmp	   CPU_INST_EMU_END
  CP1_C.SEQ_DOUBLE:
  fld	   [rcx*8+CP1_F0]      ; ST(0) = [FT] (Double)
  fld	   [rbx*8+CP1_F0]      ; ST(1) = [FS] (Double)
  fcomip   st1		       ; Compare FS To FT
  setnp    al		       ; Set Byte IF NOT Parity
  sete	   [CP1_FP]	       ; Set Byte IF Equal
  and	   [CP1_FP],al	       ; FP &= AL
  fstp	   st0		       ; POP Stack
  jmp	   CPU_INST_EMU_END
CP1_C.NGL: ; Op Code 17:59 - CP1 R-Instruction Format + Function: C.NGL.FMT FS,FT - Floating-Point Compare Not Greater Than Or Less Than
  mov	   ebx,eax	       ; EBX = Instruction
  shr	   ebx,11	       ; EBX >>= 11
  and	   ebx,$1F	       ; EBX = FS (5-Bit)
  mov	   ecx,eax	       ; ECX = Instruction
  shr	   ecx,16	       ; ECX >>= 16
  and	   ecx,$1F	       ; ECX = FT (5-Bit)
  shr	   eax,21	       ; EAX >>= 21
  and	   eax,$7	       ; EAX = FMT (3-Bit)
  cmp	   al,0 	       ; Compare FMT To Zero
  jne	   CP1_C.NGL_DOUBLE    ; IF (FMT == 0) Single Compare, ELSE Double Compare
  fld	   dword[rcx*8+CP1_F0] ; ST(0) = [FT] (Single)
  fld	   dword[rbx*8+CP1_F0] ; ST(1) = [FS] (Single)
  fcomip   st1		       ; Compare FS To FT
  setnp    al		       ; Set Byte IF NOT Parity
  sete	   [CP1_FP]	       ; Set Byte IF Equal
  and	   [CP1_FP],al	       ; FP &= AL
  fstp	   st0		       ; POP Stack
  jmp	   CPU_INST_EMU_END
  CP1_C.NGL_DOUBLE:
  fld	   [rcx*8+CP1_F0]      ; ST(0) = [FT] (Double)
  fld	   [rbx*8+CP1_F0]      ; ST(1) = [FS] (Double)
  fcomip   st1		       ; Compare FS To FT
  setnp    al		       ; Set Byte IF NOT Parity
  sete	   [CP1_FP]	       ; Set Byte IF Equal
  and	   [CP1_FP],al	       ; FP &= AL
  fstp	   st0		       ; POP Stack
  jmp	   CPU_INST_EMU_END
CP1_C.LT: ; Op Code 17:60 - CP1 R-Instruction Format + Function: C.LT.FMT FS,FT - Floating-Point Compare Less Than
  mov	   ebx,eax	       ; EBX = Instruction
  shr	   ebx,11	       ; EBX >>= 11
  and	   ebx,$1F	       ; EBX = FS (5-Bit)
  mov	   ecx,eax	       ; ECX = Instruction
  shr	   ecx,16	       ; ECX >>= 16
  and	   ecx,$1F	       ; ECX = FT (5-Bit)
  shr	   eax,21	       ; EAX >>= 21
  and	   eax,$7	       ; EAX = FMT (3-Bit)
  cmp	   al,0 	       ; Compare FMT To Zero
  jne	   CP1_C.LT_DOUBLE     ; IF (FMT == 0) Single Compare, ELSE Double Compare
  fld	   dword[rcx*8+CP1_F0] ; ST(0) = [FT] (Single)
  fld	   dword[rbx*8+CP1_F0] ; ST(1) = [FS] (Single)
  fcomip   st1		       ; Compare FS To FT
  setnp    al		       ; Set Byte IF NOT Parity
  setb	   [CP1_FP]	       ; Set Byte IF Below
  and	   [CP1_FP],al	       ; FP &= AL
  fstp	   st0		       ; POP Stack
  jmp	   CPU_INST_EMU_END
  CP1_C.LT_DOUBLE:
  fld	   [rcx*8+CP1_F0]      ; ST(0) = [FT] (Double)
  fld	   [rbx*8+CP1_F0]      ; ST(1) = [FS] (Double)
  fcomip   st1		       ; Compare FS To FT
  setnp    al		       ; Set Byte IF NOT Parity
  setb	   [CP1_FP]	       ; Set Byte IF Below
  and	   [CP1_FP],al	       ; FP &= AL
  fstp	   st0		       ; POP Stack
  jmp	   CPU_INST_EMU_END
CP1_C.NGE: ; Op Code 17:61 - CP1 R-Instruction Format + Function: C.NGE.FMT FS,FT - Floating-Point Compare Not Greater Than Or Equal
  mov	   ebx,eax	       ; EBX = Instruction
  shr	   ebx,11	       ; EBX >>= 11
  and	   ebx,$1F	       ; EBX = FS (5-Bit)
  mov	   ecx,eax	       ; ECX = Instruction
  shr	   ecx,16	       ; ECX >>= 16
  and	   ecx,$1F	       ; ECX = FT (5-Bit)
  shr	   eax,21	       ; EAX >>= 21
  and	   eax,$7	       ; EAX = FMT (3-Bit)
  cmp	   al,0 	       ; Compare FMT To Zero
  jne	   CP1_C.NGE_DOUBLE    ; IF (FMT == 0) Single Compare, ELSE Double Compare
  fld	   dword[rcx*8+CP1_F0] ; ST(0) = [FT] (Single)
  fld	   dword[rbx*8+CP1_F0] ; ST(1) = [FS] (Single)
  fcomip   st1		       ; Compare FS To FT
  setnp    al		       ; Set Byte IF NOT Parity
  setnae   [CP1_FP]	       ; Set Byte IF NOT Above Or Equal
  and	   [CP1_FP],al	       ; FP &= AL
  fstp	   st0		       ; POP Stack
  jmp	   CPU_INST_EMU_END
  CP1_C.NGE_DOUBLE:
  fld	   [rcx*8+CP1_F0]      ; ST(0) = [FT] (Double)
  fld	   [rbx*8+CP1_F0]      ; ST(1) = [FS] (Double)
  fcomip   st1		       ; Compare FS To FT
  setnp    al		       ; Set Byte IF NOT Parity
  setnae   [CP1_FP]	       ; Set Byte IF NOT Above Or Equal
  and	   [CP1_FP],al	       ; FP &= AL
  fstp	   st0		       ; POP Stack
  jmp	   CPU_INST_EMU_END
CP1_C.LE: ; Op Code 17:62 - CP1 R-Instruction Format + Function: C.LE.FMT FS,FT - Floating-Point Compare Less Than Or Equal
  mov	   ebx,eax	       ; EBX = Instruction
  shr	   ebx,11	       ; EBX >>= 11
  and	   ebx,$1F	       ; EBX = FS (5-Bit)
  mov	   ecx,eax	       ; ECX = Instruction
  shr	   ecx,16	       ; ECX >>= 16
  and	   ecx,$1F	       ; ECX = FT (5-Bit)
  shr	   eax,21	       ; EAX >>= 21
  and	   eax,$7	       ; EAX = FMT (3-Bit)
  cmp	   al,0 	       ; Compare FMT To Zero
  jne	   CP1_C.LE_DOUBLE     ; IF (FMT == 0) Single Compare, ELSE Double Compare
  fld	   dword[rcx*8+CP1_F0] ; ST(0) = [FT] (Single)
  fld	   dword[rbx*8+CP1_F0] ; ST(1) = [FS] (Single)
  fcomip   st1		       ; Compare FS To FT
  setnp    al		       ; Set Byte IF NOT Parity
  setbe    [CP1_FP]	       ; Set Byte IF Below Or Equal
  and	   [CP1_FP],al	       ; FP &= AL
  fstp	   st0		       ; POP Stack
  jmp	   CPU_INST_EMU_END
  CP1_C.LE_DOUBLE:
  fld	   [rcx*8+CP1_F0]      ; ST(0) = [FT] (Double)
  fld	   [rbx*8+CP1_F0]      ; ST(1) = [FS] (Double)
  fcomip   st1		       ; Compare FS To FT
  setnp    al		       ; Set Byte IF NOT Parity
  setbe    [CP1_FP]	       ; Set Byte IF Below Or Equal
  and	   [CP1_FP],al	       ; FP &= AL
  fstp	   st0		       ; POP Stack
  jmp	   CPU_INST_EMU_END
CP1_C.NGT: ; Op Code 17:63 - CP1 R-Instruction Format + Function: C.NGT.FMT FS,FT - Floating-Point Compare Not Greater Than
  mov	   ebx,eax	       ; EBX = Instruction
  shr	   ebx,11	       ; EBX >>= 11
  and	   ebx,$1F	       ; EBX = FS (5-Bit)
  mov	   ecx,eax	       ; ECX = Instruction
  shr	   ecx,16	       ; ECX >>= 16
  and	   ecx,$1F	       ; ECX = FT (5-Bit)
  shr	   eax,21	       ; EAX >>= 21
  and	   eax,$7	       ; EAX = FMT (3-Bit)
  cmp	   al,0 	       ; Compare FMT To Zero
  jne	   CP1_C.NGT_DOUBLE    ; IF (FMT == 0) Single Compare, ELSE Double Compare
  fld	   dword[rcx*8+CP1_F0] ; ST(0) = [FT] (Single)
  fld	   dword[rbx*8+CP1_F0] ; ST(1) = [FS] (Single)
  fcomip   st1		       ; Compare FS To FT
  setnp    al		       ; Set Byte IF NOT Parity
  setna    [CP1_FP]	       ; Set Byte IF NOT Above
  and	   [CP1_FP],al	       ; FP &= AL
  fstp	   st0		       ; POP Stack
  jmp	   CPU_INST_EMU_END
  CP1_C.NGT_DOUBLE:
  fld	   [rcx*8+CP1_F0]      ; ST(0) = [FT] (Double)
  fld	   [rbx*8+CP1_F0]      ; ST(1) = [FS] (Double)
  fcomip   st1		       ; Compare FS To FT
  setnp    al		       ; Set Byte IF NOT Parity
  setna    [CP1_FP]	       ; Set Byte IF NOT Above
  and	   [CP1_FP],al	       ; FP &= AL
  fstp	   st0		       ; POP Stack
  jmp	   CPU_INST_EMU_END

CP1_BC_JUMP_TABLE:
  dq CP1_BC1F,	  CP1_BC1T,    CP1_BC1FL,   CP1_BC1TL,	 CP1_RESERVED,CP1_RESERVED,CP1_RESERVED,CP1_RESERVED ; Branch Code 00..07
  dq CP1_RESERVED,CP1_RESERVED,CP1_RESERVED,CP1_RESERVED,CP1_RESERVED,CP1_RESERVED,CP1_RESERVED,CP1_RESERVED ; Branch Code 08..15
  dq CP1_RESERVED,CP1_RESERVED,CP1_RESERVED,CP1_RESERVED,CP1_RESERVED,CP1_RESERVED,CP1_RESERVED,CP1_RESERVED ; Branch Code 16..23
  dq CP1_RESERVED,CP1_RESERVED,CP1_RESERVED,CP1_RESERVED,CP1_RESERVED,CP1_RESERVED,CP1_RESERVED,CP1_RESERVED ; Branch Code 24..31

CP1_BC1F: ; CP1 BC Code 00 - I-Instruction Format: BC1F Offset - Branch On FP False
  movsx    ebx,ax	    ; EBX = Offset (Sign-Extended 16-Bit)
  cmp	   [CP1_FP],0	    ; Compare FP To False
  jne	   CPU_INST_EMU_END ; IF (FP == False) Set Delay Slot, ELSE Do Not Branch
  ; ELSE Store Delay Slot Program Counter Relative Offset Address
  mov	   eax,[CPU_PC]     ; Delay Slot = CPU_PC + (Offset << 2)
  shl	   ebx,2
  add	   eax,ebx
  mov	   [DELAY_SLOT],eax
  jmp	   CPU_INST_EMU     ; Execute Delay Slot
CP1_BC1T: ; CP1 BC Code 01 - I-Instruction Format: BC1T Offset - Branch On FP True
  movsx    ebx,ax	    ; EBX = Offset (Sign-Extended 16-Bit)
  cmp	   [CP1_FP],1	    ; Compare FP To True
  jne	   CPU_INST_EMU_END ; IF (FP == True) Set Delay Slot, ELSE Do Not Branch
  ; ELSE Store Delay Slot Program Counter Relative Offset Address
  mov	   eax,[CPU_PC]     ; Delay Slot = CPU_PC + (Offset << 2)
  shl	   ebx,2
  add	   eax,ebx
  mov	   [DELAY_SLOT],eax
  jmp	   CPU_INST_EMU     ; Execute Delay Slot
CP1_BC1FL: ; CP1 BC Code 02 - I-Instruction Format: BC1FL Offset - Branch On FP False Likely
  movsx    ebx,ax	    ; EBX = Offset (Sign-Extended 16-Bit)
  cmp	   [CP1_FP],0	    ; Compare FP To False
  jne	   CP1_BC1FL_LIKELY ; IF (FP == False) Set Delay Slot, ELSE Do Not Branch, PC += 4
  ; ELSE Store Delay Slot Program Counter Relative Offset Address
  mov	   eax,[CPU_PC]     ; Delay Slot = CPU_PC + (Offset << 2)
  shl	   ebx,2
  add	   eax,ebx
  mov	   [DELAY_SLOT],eax
  jmp	   CPU_INST_EMU     ; Execute Delay Slot
  CP1_BC1FL_LIKELY:
  add	   [CPU_PC],4	    ; Program Counter += 4
  jmp	   CPU_INST_EMU_END
CP1_BC1TL: ; CP1 BC Code 03 - I-Instruction Format: BC1TL Offset - Branch On FP True Likely
  movsx    ebx,ax	    ; EBX = Offset (Sign-Extended 16-Bit)
  cmp	   [CP1_FP],1	    ; Compare FP To True
  jne	   CP1_BC1TL_LIKELY ; IF (FP == True) Set Delay Slot, ELSE Do Not Branch, PC += 4
  ; ELSE Store Delay Slot Program Counter Relative Offset Address
  mov	   eax,[CPU_PC]     ; Delay Slot = CPU_PC + (Offset << 2)
  shl	   ebx,2
  add	   eax,ebx
  mov	   [DELAY_SLOT],eax
  jmp	   CPU_INST_EMU     ; Execute Delay Slot
  CP1_BC1TL_LIKELY:
  add	   [CPU_PC],4	    ; Program Counter += 4
  jmp	   CPU_INST_EMU_END

CP1_RESERVED: ; CP1 Op Code: Reserved
  invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY+BACKGROUND_RED ; HANDLE, Console Text Attribute
  invoke   WriteFile,[hcn],ProgramError,12,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
  invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY+BACKGROUND_RED+BACKGROUND_INTENSITY ; HANDLE, Console Text Attribute
  invoke   WriteFile,[hcn],'RESERVED CP1 OP CODE',20,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
  jmp	   CPU_INST_EMU_END