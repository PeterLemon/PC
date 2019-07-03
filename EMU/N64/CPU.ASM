CPU_INST_EMU: ; Run CPU Instruction
  ; Load Next Instruction
  mov	   eax,[CPU_PC]  ; EAX = Program Counter
  and	   eax,$1FFFFFFF ; EAX &= MEM_MAP Mask
  add	   rax,[MEM_MAP]
  mov	   eax,[rax]	 ; Convert Instruction To Little Endian
  bswap    eax		 ; EAX = Instruction (32-Bit)

  mov	   ebx,eax	 ; EBX = Instruction
  shr	   ebx,26	 ; EBX = Upper 6-Bits Instruction Opcode Number
  mov	   ebx,[ebx*8+CPU_JUMP_TABLE]

  inc	   [CYCLES]	 ; Cycles++
  add	   [CPU_PC],4	 ; Program Counter += 4

  jmp	   rbx		 ; Instruction At Jump Table
  CPU_INST_EMU_END:

  ; Delay Slot
  cmp	   [DELAY_SLOT],0   ; Compare Delay Slot To Zero
  je	   NO_DELAY_SLOT    ; IF (Delay Slot = 0) No Delay Slot
  mov	   eax,[DELAY_SLOT] ; EAX = Delay Slot
  mov	   [CPU_PC],eax     ; Program Counter = Delay Slot
  mov	   [DELAY_SLOT],0   ; Delay Slot = 0
  NO_DELAY_SLOT:

  cmp	   [CYCLES],1562624 ; 93757440Hz / 60Hz = 1562624
  jle	   CPU_INST_EMU
  sub	   [CYCLES],1562624 ; Cycles -= 1562624

  ret

CPU_JUMP_TABLE:
  dq CPU_FUNCTION,CPU_REGIMM,CPU_J,	  CPU_JAL,     CPU_BEQ,     CPU_BNE,	 CPU_BLEZ,    CPU_BGTZ	   ; Op Code 00..07
  dq CPU_ADDI,	  CPU_ADDIU, CPU_SLTI,	  CPU_SLTIU,   CPU_ANDI,    CPU_ORI,	 CPU_XORI,    CPU_LUI	   ; Op Code 08..15
  dq CPU_RESERVED,CPU_COP1,  CPU_RESERVED,CPU_RESERVED,CPU_BEQL,    CPU_BNEL,	 CPU_BLEZL,   CPU_BGTZL    ; Op Code 16..23
  dq CPU_DADDI,   CPU_DADDIU,CPU_LDL,	  CPU_LDR,     CPU_RESERVED,CPU_RESERVED,CPU_RESERVED,CPU_RESERVED ; Op Code 24..31
  dq CPU_LB,	  CPU_LH,    CPU_LWL,	  CPU_LW,      CPU_LBU,     CPU_LHU,	 CPU_LWR,     CPU_LWU	   ; Op Code 32..39
  dq CPU_SB,	  CPU_SH,    CPU_SWL,	  CPU_SW,      CPU_SDL,     CPU_SDR,	 CPU_SWR,     CPU_CACHE    ; Op Code 40..47
  dq CPU_RESERVED,CPU_LWC1,  CPU_RESERVED,CPU_RESERVED,CPU_RESERVED,CPU_LDC1,	 CPU_RESERVED,CPU_LD	   ; Op Code 48..55
  dq CPU_RESERVED,CPU_SWC1,  CPU_RESERVED,CPU_RESERVED,CPU_RESERVED,CPU_SDC1,	 CPU_RESERVED,CPU_SD	   ; Op Code 56..63

CPU_FUNCTION: ; Op Code 00 - R-Instruction Format: Function Code
  mov	   ebx,eax ; EBX = Instruction
  and	   ebx,$3F ; EBX = Lower 6-Bits Instruction Function Code
  mov	   ebx,[ebx*8+CPU_FUNCTION_JUMP_TABLE]
  jmp	   rbx
CPU_REGIMM: ; Op Code 01 - REGIMM-Instruction Format: RT Code
  mov	   ebx,eax ; EBX = Instruction
  shr	   ebx,16  ; EBX >>= 16
  and	   ebx,$3F ; EBX = 5-Bits RT Code
  mov	   ebx,[ebx*8+CPU_REGIMM_JUMP_TABLE]
  jmp	   rbx
CPU_J: ; Op Code 02 - J-Instruction Format: J Target - Jump
  ; Store Delay Slot Program Counter Relative Offset Address
  mov	   ebx,[CPU_PC] ; Delay Slot = CPU_PC Top 4 Bits | (26-Bit Target << 2)
  mov	   ecx,$F0000000
  and	   ebx,ecx
  and	   eax,$03FFFFFF
  shl	   eax,2
  or	   eax,ebx
  mov	   [DELAY_SLOT],eax
  jmp	   CPU_INST_EMU ; Execute Delay Slot
CPU_JAL: ; Op Code 03 - J-Instruction Format: JAL Target - Jump And Link
  ; Store Link To RA (Instruction After Delay Slot)
  mov	   rbx,0	; RBX = 0 (Zero-Extend 64-Bit)
  mov	   ebx,[CPU_PC] ; EBX = PC
  add	   rbx,4	; RBX += 4
  movsxd   rbx,ebx	; Sign-Extend 64-Bit Result
  mov	   [CPU_RA],rbx ; RA = RBX
  ; Store Delay Slot Program Counter Relative Offset Address
  mov	   ebx,[CPU_PC] ; Delay Slot = CPU_PC Top 4 Bits | (26-Bit Target << 2)
  mov	   ecx,$F0000000
  and	   ebx,ecx
  and	   eax,$03FFFFFF
  shl	   eax,2
  or	   eax,ebx
  mov	   [DELAY_SLOT],eax
  jmp	   CPU_INST_EMU ; Execute Delay Slot
CPU_BEQ: ; Op Code 04 - I-Instruction Format: BEQ RS,RT,Offset - Branch on Equal
  movsx    ebx,ax	      ; EBX = Offset (Sign-Extended 16-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = RS
  cmp	   rax,[rcx*8+CPU_R0] ; Compare RS To RT
  jne	   CPU_INST_EMU_END   ; IF (RS == RT) Set Delay Slot, ELSE Do Not Branch
  ; ELSE Store Delay Slot Program Counter Relative Offset Address
  mov	   eax,[CPU_PC]       ; Delay Slot = CPU_PC + (Offset << 2)
  shl	   ebx,2
  add	   eax,ebx
  mov	   [DELAY_SLOT],eax
  jmp	   CPU_INST_EMU       ; Execute Delay Slot
CPU_BNE: ; Op Code 05 - I-Instruction Format: BNE RS,RT,Offset - Branch On Not Equal
  movsx    ebx,ax	      ; EBX = Offset (Sign-Extended 16-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = RS
  cmp	   rax,[rcx*8+CPU_R0] ; Compare RS To RT
  je	   CPU_INST_EMU_END   ; IF (RS != RT) Set Delay Slot, ELSE Do Not Branch
  ; ELSE Store Delay Slot Program Counter Relative Offset Address
  mov	   eax,[CPU_PC] ; Delay Slot = CPU_PC + (Offset << 2)
  shl	   ebx,2
  add	   eax,ebx
  mov	   [DELAY_SLOT],eax
  jmp	   CPU_INST_EMU ; Execute Delay Slot
CPU_BLEZ: ; Op Code 06 - I-Instruction Format: BLEZ RS,Offset - Branch On Less Than Or Equal To Zero
  movsx    ebx,ax	      ; EBX = Offset (Sign-Extended 16-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = RS
  cmp	   rax,0	      ; Compare RS To 0
  jg	   CPU_INST_EMU_END   ; IF (RS <= 0) Set Delay Slot, ELSE Do Not Store Delay Slot
  ; ELSE Store Delay Slot Program Counter Relative Offset Address
  mov	   eax,[CPU_PC]       ; Delay Slot = CPU_PC + (Offset << 2)
  shl	   ebx,2
  add	   eax,ebx
  mov	   [DELAY_SLOT],eax
  jmp	   CPU_INST_EMU       ; Execute Delay Slot
CPU_BGTZ: ; Op Code 07 - I-Instruction Format: BGTZ RS,Offset - Branch On Greater Than Zero
  movsx    ebx,ax	      ; EBX = Offset (Sign-Extended 16-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = RS
  cmp	   rax,0	      ; Compare RS To 0
  jle	   CPU_INST_EMU_END   ; IF (RS > 0) Set Delay Slot, ELSE Do Not Store Delay Slot
  ; ELSE Store Delay Slot Program Counter Relative Offset Address
  mov	   eax,[CPU_PC]       ; Delay Slot = CPU_PC + (Offset << 2)
  shl	   ebx,2
  add	   eax,ebx
  mov	   [DELAY_SLOT],eax
  jmp	   CPU_INST_EMU       ; Execute Delay Slot
CPU_ADDI: ; Op Code 08 - I-Instruction Format: ADDI RT,RS,Immediate - Add Immediate Word
  movsx    ebx,ax	      ; EBX = Immediate (Sign-Extended 16-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RS]
  add	   ebx,eax	      ; EBX += RS (Signed Add)
  movsxd   rbx,ebx	      ; Sign-Extend 32-Bit Result
  mov	   [rcx*8+CPU_R0],rbx ; RT = RBX
  jmp	   CPU_INST_EMU_END
CPU_ADDIU: ; Op Code 09 - I-Instruction Format: ADDIU RT,RS,Immediate - Add Immediate Unsigned Word
  movsx    ebx,ax	      ; EBX = Immediate (Sign-Extended 16-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RS]
  adc	   ebx,eax	      ; EBX += RS (Unsigned Add)
  movsxd   rbx,ebx	      ; Sign-Extend 32-Bit Result
  mov	   [rcx*8+CPU_R0],rbx ; RT = RBX
  jmp	   CPU_INST_EMU_END
CPU_SLTI: ; Op Code 10 - I-Instruction Format: SLTI RT,RS,Immediate - Set On Less Than Immediate
  movsx    ebx,ax	      ; EBX = Immediate (Sign-Extended 16-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RS]
  cmp	   eax,ebx	      ; Compare RS To Immediate
  setl	   al		      ; Set Byte IF Less (Signed)
  movzx    rax,al	      ; Zero-Extend 64-Bit Result
  mov	   [rcx*8+CPU_R0],rax ; RT = RAX
  jmp	   CPU_INST_EMU_END
CPU_SLTIU: ; Op Code 11 - I-Instruction Format: SLTIU RT,RS,Immediate - Set On Less Than Immediate Unsigned
  movsx    ebx,ax	      ; EBX = Immediate (Sign-Extended 16-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RS]
  cmp	   eax,ebx	      ; Compare RS To Immediate
  setb	   al		      ; Set Byte IF Below (Unsigned)
  movzx    rax,al	      ; Zero-Extend 64-Bit Result
  mov	   [rcx*8+CPU_R0],rax ; RT = RAX
  jmp	   CPU_INST_EMU_END
CPU_ANDI: ; Op Code 12 - I-Instruction Format: ANDI RT,RS,Immediate - AND Immediate
  movzx    ebx,ax	      ; EBX = Immediate (Zero-Extended 16-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  and	   rbx,[rax*8+CPU_R0] ; RBX &= RS
  mov	   [rcx*8+CPU_R0],rbx ; RT = RBX
  jmp	   CPU_INST_EMU_END
CPU_ORI: ; Op Code 13 - I-Instruction Format: ORI RT,RS,Immediate - OR Immediate
  movzx    ebx,ax	      ; EBX = Immediate (Zero Extend 16-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  or	   rbx,[rax*8+CPU_R0] ; RBX |= RS
  mov	   [rcx*8+CPU_R0],rbx ; RT = RBX
  jmp	   CPU_INST_EMU_END
CPU_XORI: ; Op Code 14 - I-Instruction Format: XORI RT,RS,Immediate - Exclusive OR Immediate
  movzx    ebx,ax	      ; EBX = Immediate (Zero-Extended 16-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  xor	   rbx,[rax*8+CPU_R0] ; RBX ^= RS
  mov	   [rcx*8+CPU_R0],rbx ; RT = RBX
  jmp	   CPU_INST_EMU_END
CPU_LUI: ; Op Code 15 - I-Instruction Format: LUI RT,Immediate - Load Upper Immediate
  movzx    ebx,ax	      ; EBX = Immediate (Zero-Extended 16-Bit)
  shl	   ebx,16	      ; EBX <<= 16
  shr	   eax,16	      ; EAX >>= 16
  and	   eax,$1F	      ; EAX = RT (5-Bit)
  movsxd   rbx,ebx	      ; Sign Extend 32-Bit Result
  mov	   [rax*8+CPU_R0],rbx ; RT = RBX
  jmp	   CPU_INST_EMU_END
CPU_COP1: ; Op Code 17 - CP1 BC Format: Branch Code / R-Instruction Format: Function Code
  mov	   ebx,eax ; EBX = Instruction
  shr	   ebx,21  ; EBX >>= 21
  and	   ebx,$1F ; EBX = BC (5-BIT)
  cmp	   bl,8    ; Compare BC To 8
  jne	   CPU_COP1_OP ; IF (BC == 8) COP1 BC Format, ELSE R-Instruction Format
  mov	   ebx,eax ; EBX = Instruction
  shr	   ebx,16  ; EBX >>= 16
  and	   ebx,$3F ; EBX = 5-Bits Branch Code
  mov	   ebx,[ebx*8+CP1_BC_JUMP_TABLE]
  jmp	   rbx
  CPU_COP1_OP:
  mov	   ebx,eax ; EBX = Instruction
  and	   ebx,$3F ; EBX = Lower 6-Bits Instruction Function Code
  mov	   ebx,[ebx*8+CP1_JUMP_TABLE]
  jmp	   rbx
CPU_BEQL: ; Op Code 20 - I-Instruction Format: BEQL RS,RT,Offset - Branch On Equal Likely
  movsx    ebx,ax	      ; EBX = Offset (Sign-Extended 16-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = RS
  cmp	   rax,[rcx*8+CPU_R0] ; Compare RS To RT
  jne	   CPU_BEQL_LIKELY    ; IF (RS == RT) Set Delay Slot, ELSE Do Not Branch, PC += 4
  ; ELSE Store Delay Slot Program Counter Relative Offset Address
  mov	   eax,[CPU_PC]       ; Delay Slot = CPU_PC + (Offset << 2)
  shl	   ebx,2
  add	   eax,ebx
  mov	   [DELAY_SLOT],eax
  jmp	   CPU_INST_EMU       ; Execute Delay Slot
  CPU_BEQL_LIKELY:
  add	   [CPU_PC],4	      ; Program Counter += 4
  jmp	   CPU_INST_EMU_END
CPU_BNEL: ; Op Code 21 - I-Instruction Format: BNEL RS,RT,Offset - Branch On Not Equal Likely
  movsx    ebx,ax	      ; EBX = Offset (Sign-Extended 16-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = RS
  cmp	   rax,[rcx*8+CPU_R0] ; Compare RS To RT
  je	   CPU_BNEL_LIKELY    ; IF (RS != RT) Set Delay Slot, ELSE Do Not Branch, PC += 4
  ; ELSE Store Delay Slot Program Counter Relative Offset Address
  mov	   eax,[CPU_PC]       ; Delay Slot = CPU_PC + (Offset << 2)
  shl	   ebx,2
  add	   eax,ebx
  mov	   [DELAY_SLOT],eax
  jmp	   CPU_INST_EMU       ; Execute Delay Slot
  CPU_BNEL_LIKELY:
  add	   [CPU_PC],4	      ; Program Counter += 4
  jmp	   CPU_INST_EMU_END
CPU_BLEZL: ; Op Code 22 - I-Instruction Format: BLEZL RS,Offset - Branch On Less Than Or Equal To Zero Likely
  movsx    ebx,ax	      ; EBX = Offset (Sign-Extended 16-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = RS
  cmp	   rax,0	      ; Compare RS To 0
  jg	   CPU_BLEZL_LIKELY   ; IF (RS <= 0) Set Delay Slot, ELSE Do Not Store Delay Slot, PC += 4
  ; ELSE Store Delay Slot Program Counter Relative Offset Address
  mov	   eax,[CPU_PC]       ; Delay Slot = CPU_PC + (Offset << 2)
  shl	   ebx,2
  add	   eax,ebx
  mov	   [DELAY_SLOT],eax
  jmp	   CPU_INST_EMU       ; Execute Delay Slot
  CPU_BLEZL_LIKELY:
  add	   [CPU_PC],4	      ; Program Counter += 4
  jmp	   CPU_INST_EMU_END
CPU_BGTZL: ; Op Code 23 - I-Instruction Format: BGTZL RS,Offset - Branch On Greater Than Zero Likely
  movsx    ebx,ax	      ; EBX = Offset (Sign-Extended 16-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = RS
  cmp	   rax,0	      ; Compare RS To 0
  jle	   CPU_BGTZL_LIKELY   ; IF (RS > 0) Set Delay Slot, ELSE Do Not Store Delay Slot, PC += 4
  ; ELSE Store Delay Slot Program Counter Relative Offset Address
  mov	   eax,[CPU_PC]       ; Delay Slot = CPU_PC + (Offset << 2)
  shl	   ebx,2
  add	   eax,ebx
  mov	   [DELAY_SLOT],eax
  jmp	   CPU_INST_EMU       ; Execute Delay Slot
  CPU_BGTZL_LIKELY:
  add	   [CPU_PC],4	      ; Program Counter += 4
  jmp	   CPU_INST_EMU_END
CPU_DADDI: ; Op Code 24 - I-Instruction Format: DADDI RT,RS,Immediate - Doubleword Add Immediate
  movsx    rbx,ax	      ; RBX = Immediate (Sign-Extended 16-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RS]
  add	   rbx,rax	      ; RBX += RS (Signed Add)
  mov	   [rcx*8+CPU_R0],rbx ; RT = RBX
  jmp	   CPU_INST_EMU_END
CPU_DADDIU: ; Op Code 25 - I-Instruction Format: DADDIU RT,RS,Immediate - Doubleword Add Immediate Unsigned
  movsx    rbx,ax	      ; RBX = Immediate (Sign-Extended 16-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RS]
  adc	   rbx,rax	      ; RBX += RS (Unsigned Add)
  mov	   [rcx*8+CPU_R0],rbx ; RT = RBX
  jmp	   CPU_INST_EMU_END
CPU_LDL: ; Op Code 26: I-Instruction Format: LDL RT,Offset(Base) - Load Doubleword Left
  movsx    ebx,ax	      ; EBX = Immediate (Sign-Extended 16-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  add	   rbx,[rax*8+CPU_R0] ; RBX += RS
  and	   ebx,$1FFFFFFF      ; EBX &= MEM_MAP Mask
  mov	   rax,[MEM_MAP]      ; Load Doubleword
  mov	   rdx,[rbx+rax]
  bswap    rdx
  mov	   [rcx*8+CPU_R0],rdx ; RT = [Immediate+RS] Doubleword (RDX)
  jmp	   CPU_INST_EMU_END
CPU_LDR: ; Op Code 27: I-Instruction Format: LDR RT,Offset(Base) - Load Doubleword Right
  movsx    ebx,ax	      ; EBX = Immediate (Sign-Extended 16-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  add	   rbx,[rax*8+CPU_R0] ; RBX += RS
  and	   ebx,$1FFFFFFF      ; EBX &= MEM_MAP Mask
  mov	   rax,[MEM_MAP]      ; Load Doubleword
  mov	   rdx,[rbx+rax]
  bswap    rdx
  mov	   [rcx*8+CPU_R0],rdx ; RT = [Immediate+RS] Doubleword (RDX)
  jmp	   CPU_INST_EMU_END
CPU_LB: ; Op Code 32: I-Instruction Format: LB RT,Offset(Base) - Load Byte Signed
  movsx    ebx,ax	      ; EBX = Immediate (Sign-Extended 16-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  add	   rbx,[rax*8+CPU_R0] ; RBX += RS
  and	   ebx,$1FFFFFFF      ; EBX &= MEM_MAP Mask
  mov	   rax,[MEM_MAP]      ; Load Signed Byte
  mov	   dl,[rbx+rax]
  movsx    rdx,dl	      ; Sign-Extend 8-Bit Result
  mov	   [rcx*8+CPU_R0],rdx ; RT = [Immediate+RS] Signed Byte (RDX)
  jmp	   CPU_INST_EMU_END
CPU_LH: ; Op Code 33: I-Instruction Format: LH RT,Offset(Base) Load Halfword Signed
  movsx    ebx,ax	      ; EBX = Immediate (Sign-Extended 16-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  add	   rbx,[rax*8+CPU_R0] ; RBX += RS
  and	   ebx,$1FFFFFFF      ; EBX &= MEM_MAP Mask
  mov	   rax,[MEM_MAP]      ; Load Signed Halfword
  mov	   dl,[rbx+rax+1]
  mov	   dh,[rbx+rax+0]
  movsx    rdx,dx	      ; Sign-Extend 16-Bit Result
  mov	   [rcx*8+CPU_R0],rdx ; RT = [Immediate+RS] Halfword (RDX)
  jmp	   CPU_INST_EMU_END
CPU_LWL: ; Op Code 34: I-Instruction Format: LWL RT,Offset(Base) - Load Word Left
  movsx    ebx,ax	      ; EBX = Immediate (Sign-Extended 16-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  add	   rbx,[rax*8+CPU_R0] ; RBX += RS
  and	   ebx,$1FFFFFFF      ; EBX &= MEM_MAP Mask
  mov	   rax,[MEM_MAP]      ; Load Word Left
  mov	   edx,[rbx+rax]
  bswap    edx
  movsxd   rdx,edx	      ; Sign-Extend 32-Bit Result
  mov	   [rcx*8+CPU_R0],rdx ; RT = [Immediate+RS] Word Left (RDX)
  jmp	   CPU_INST_EMU_END
CPU_LW: ; Op Code 35: I-Instruction Format: LW RT,Offset(Base) - Load Word Signed
  movsx    ebx,ax	      ; EBX = Immediate (Sign-Extended 16-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  add	   rbx,[rax*8+CPU_R0] ; RBX += RS
  and	   ebx,$1FFFFFFF      ; EBX &= MEM_MAP Mask
  mov	   rax,[MEM_MAP]      ; Load Signed Word
  mov	   edx,[rbx+rax]
  bswap    edx
  movsxd   rdx,edx	      ; Sign-Extend 32-Bit Result
  mov	   [rcx*8+CPU_R0],rdx ; RT = [Immediate+RS] Signed Word (RDX)
  jmp	   CPU_INST_EMU_END
CPU_LBU: ; Op Code 36: I-Instruction Format: LBU RT,Offset(Base) - Load Byte Unsigned
  movsx    ebx,ax	      ; EBX = Immediate (Sign-Extended 16-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  add	   rbx,[rax*8+CPU_R0] ; RBX += RS
  and	   ebx,$1FFFFFFF      ; EBX &= MEM_MAP Mask
  mov	   rax,[MEM_MAP]      ; Load Unsigned Byte
  mov	   dl,[rbx+rax]
  movzx    rdx,dl	      ; Zero-Extend 8-Bit Result
  mov	   [rcx*8+CPU_R0],rdx ; RT = [Immediate+RS] Unsigned Byte (RDX)
  jmp	   CPU_INST_EMU_END
CPU_LHU: ; Op Code 37: I-Instruction Format: LHU RT,Offset(Base) - Load Halfword Unsigned
  movsx    ebx,ax	      ; EBX = Immediate (Sign-Extended 16-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  add	   rbx,[rax*8+CPU_R0] ; RBX += RS
  and	   ebx,$1FFFFFFF      ; EBX &= MEM_MAP Mask
  mov	   rax,[MEM_MAP]      ; Load Unsigned Halfword
  mov	   dl,[rbx+rax+1]
  mov	   dh,[rbx+rax+0]
  movzx    rdx,dx	      ; Zero-Extend 16-Bit Result
  mov	   [rcx*8+CPU_R0],rdx ; RT = [Immediate+RS] Unsigned Halfword (RDX)
  jmp	   CPU_INST_EMU_END
CPU_LWR: ; Op Code 38: I-Instruction Format: LWR RT,Offset(Base) - Load Word Right
  movsx    ebx,ax	      ; EBX = Immediate (Sign-Extended 16-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  add	   rbx,[rax*8+CPU_R0] ; RBX += RS
  and	   ebx,$1FFFFFFF      ; EBX &= MEM_MAP Mask
  mov	   rax,[MEM_MAP]      ; Load Word Right
  mov	   edx,[rbx+rax]
  bswap    edx
  movsxd   rdx,edx	      ; Sign-Extend 32-Bit Result
  mov	   [rcx*8+CPU_R0],rdx ; RT = [Immediate+RS] Word Right (RDX)
  jmp	   CPU_INST_EMU_END
CPU_LWU: ; Op Code 39: I-Instruction Format: LHU RT,Offset(Base) - LWU RT,Offset(Base) - Load Word Unsigned
  movsx    ebx,ax	      ; EBX = Immediate (Sign-Extended 16-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  add	   rbx,[rax*8+CPU_R0] ; RBX += RS
  and	   ebx,$1FFFFFFF      ; EBX &= MEM_MAP Mask
  mov	   rax,[MEM_MAP]      ; Load Unsigned Halfword
  mov	   rdx,0	      ; Clear RDX (Zero-Extend 32-Bit Result)
  mov	   edx,[rbx+rax]
  bswap    edx
  mov	   [rcx*8+CPU_R0],rdx ; RT = [Immediate+RS] Unsigned Word (RDX)
  jmp	   CPU_INST_EMU_END
CPU_SB: ; Op Code 40 - I-Instruction Format: SB RT,Offset(Base) - Store Byte
  movsx    ebx,ax	      ; EBX = Immediate (Sign-Extended 16-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  add	   rbx,[rax*8+CPU_R0] ; RBX += RS
  and	   ebx,$1FFFFFFF      ; EBX &= MEM_MAP Mask
  mov	   rcx,[rcx*8+CPU_R0] ; RCX = RT
  mov	   rax,[MEM_MAP]      ; Store Byte
  mov	   [rbx+rax],cl       ; [Immediate+RS] = RT Byte (CL)
  jmp	   CPU_INST_EMU_END
CPU_SH: ; Op Code 41 - I-Instruction Format: SH RT,Offset(Base) - Store Halfword
  movsx    ebx,ax	      ; EBX = Immediate (Sign-Extended 16-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  add	   rbx,[rax*8+CPU_R0] ; RBX += RS
  and	   ebx,$1FFFFFFF      ; EBX &= MEM_MAP Mask
  mov	   rcx,[rcx*8+CPU_R0] ; RCX = RT
  mov	   rax,[MEM_MAP]      ; Store Halfword
  mov	   [rbx+rax+1],cl
  mov	   [rbx+rax+0],ch     ; [Immediate+RS] = RT Halfword (CX)
  jmp	   CPU_INST_EMU_END
CPU_SWL: ; Op Code 42 - I-Instruction Format: SWL RT,Offset(Base) - Store Word Left
  movsx    ebx,ax	      ; EBX = Immediate (Sign-Extended 16-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  add	   rbx,[rax*8+CPU_R0] ; RBX += RS
  and	   ebx,$1FFFFFFF      ; EBX &= MEM_MAP Mask
  mov	   rcx,[rcx*8+CPU_R0] ; RCX = RT
  mov	   rax,[MEM_MAP]      ; Store Word
  bswap    ecx
  mov	   [rbx+rax],ecx      ; [Immediate+RS] = RT Word (ECX)
  jmp	   CPU_INST_EMU_END
CPU_SW: ; Op Code 43 - I-Instruction Format: SW RT,Offset(Base) - Store Word
  movsx    ebx,ax	      ; EBX = Immediate (Sign-Extended 16-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  add	   rbx,[rax*8+CPU_R0] ; RBX += RS
  and	   ebx,$1FFFFFFF      ; EBX &= MEM_MAP Mask
  mov	   rcx,[rcx*8+CPU_R0] ; RCX = RT
  mov	   rax,[MEM_MAP]      ; Store Word
  bswap    ecx
  mov	   [rbx+rax],ecx      ; [Immediate+RS] = RT Word (ECX)
  jmp	   CPU_INST_EMU_END
CPU_SDL: ; Op Code 44 - I-Instruction Format: SDL RT,Offset(Base) - Store Doubleword Left
  movsx    ebx,ax	      ; EBX = Immediate (Sign-Extended 16-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  add	   rbx,[rax*8+CPU_R0] ; RBX += RS
  and	   ebx,$1FFFFFFF      ; EBX &= MEM_MAP Mask
  mov	   rcx,[rcx*8+CPU_R0] ; RCX = RT
  mov	   rax,[MEM_MAP]      ; Store Doubleword
  bswap    rcx
  mov	   [rbx+rax],rcx      ; [Immediate+RS] = RT Doubleword (RCX)
  jmp	   CPU_INST_EMU_END
CPU_SDR: ; Op Code 45 - I-Instruction Format: SDR RT,Offset(Base) - Store Doubleword Right
  movsx    ebx,ax	      ; EBX = Immediate (Sign-Extended 16-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  add	   rbx,[rax*8+CPU_R0] ; RBX += RS
  and	   ebx,$1FFFFFFF      ; EBX &= MEM_MAP Mask
  mov	   rcx,[rcx*8+CPU_R0] ; RCX = RT
  mov	   rax,[MEM_MAP]      ; Store Doubleword
  bswap    rcx
  mov	   [rbx+rax],rcx      ; [Immediate+RS] = RT Doubleword (RCX)
  jmp	   CPU_INST_EMU_END
CPU_SWR: ; Op Code 46 - I-Instruction Format: SWR RT,Offset(Base) - Store Word Right
  movsx    ebx,ax	      ; EBX = Immediate (Sign-Extended 16-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  add	   rbx,[rax*8+CPU_R0] ; RBX += RS
  and	   ebx,$1FFFFFFF      ; EBX &= MEM_MAP Mask
  mov	   rcx,[rcx*8+CPU_R0] ; RCX = RT
  mov	   rax,[MEM_MAP]      ; Store Word
  bswap    ecx
  mov	   [rbx+rax],ecx      ; [Immediate+RS] = RT Word (ECX)
  jmp	   CPU_INST_EMU_END
CPU_CACHE: ; Op Code 47 - I-Instruction Format: CACHE OP,Offset(Base) - Cache
  jmp	   CPU_INST_EMU_END
CPU_LWC1: ; Op Code 49: I-Instruction Format: LWC1 FT,Offset(Base) - Load Word To Floating-Point
  movsx    ebx,ax	      ; EBX = Immediate (Sign-Extended 16-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = FT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  add	   rbx,[rax*8+CPU_R0] ; RBX += RS
  and	   ebx,$1FFFFFFF      ; EBX &= MEM_MAP Mask
  mov	   rax,[MEM_MAP]      ; Load Unsigned Halfword
  mov	   rdx,0	      ; Clear RDX (Zero-Extend 32-Bit Result)
  mov	   edx,[rbx+rax]
  bswap    edx
  mov	   [rcx*8+CP1_F0],rdx ; FT = [Immediate+RS] Unsigned Word (RDX)
  jmp	   CPU_INST_EMU_END
CPU_LDC1: ; Op Code 53: I-Instruction Format: LDC1 FT,Offset(Base) - Load Doubleword To Floating-Point
  movsx    ebx,ax	      ; EBX = Immediate (Sign-Extended 16-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = FT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  add	   rbx,[rax*8+CPU_R0] ; RBX += RS
  and	   ebx,$1FFFFFFF      ; EBX &= MEM_MAP Mask
  mov	   rax,[MEM_MAP]      ; Load Doubleword
  mov	   rdx,[rbx+rax]
  bswap    rdx
  mov	   [rcx*8+CP1_F0],rdx ; FT = [Immediate+RS] Doubleword (RDX)
  jmp	   CPU_INST_EMU_END
CPU_LD: ; Op Code 55: I-Instruction Format: LD RT,Offset(Base) - Load Doubleword
  movsx    ebx,ax	      ; EBX = Immediate (Sign-Extended 16-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  add	   rbx,[rax*8+CPU_R0] ; RBX += RS
  and	   ebx,$1FFFFFFF      ; EBX &= MEM_MAP Mask
  mov	   rax,[MEM_MAP]      ; Load Doubleword
  mov	   rdx,[rbx+rax]
  bswap    rdx
  mov	   [rcx*8+CPU_R0],rdx ; RT = [Immediate+RS] Doubleword (RDX)
  jmp	   CPU_INST_EMU_END
CPU_SWC1: ; Op Code 57 - I-Instruction Format: SWC1 FT,Offset(Base) - Store Word From Floating-Point
  movsx    ebx,ax	      ; EBX = Immediate (Sign-Extended 16-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = FT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  add	   rbx,[rax*8+CPU_R0] ; RBX += RS
  and	   ebx,$1FFFFFFF      ; EBX &= MEM_MAP Mask
  mov	   rcx,[rcx*8+CP1_F0] ; RCX = FT
  mov	   rax,[MEM_MAP]      ; Store Word
  bswap    ecx
  mov	   [rbx+rax],ecx      ; [Immediate+RS] = FT Word (ECX)
  jmp	   CPU_INST_EMU_END
CPU_SDC1: ; Op Code 61 - I-Instruction Format: SDC1 FT,Offset(Base) - Store Doubleword From Floating-Point
  movsx    ebx,ax	      ; EBX = Immediate (Sign-Extended 16-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = FT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  add	   rbx,[rax*8+CPU_R0] ; RBX += RS
  and	   ebx,$1FFFFFFF      ; EBX &= MEM_MAP Mask
  mov	   rcx,[rcx*8+CP1_F0] ; RCX = FT
  mov	   rax,[MEM_MAP]      ; Store Doubleword
  bswap    rcx
  mov	   [rbx+rax],rcx      ; [Immediate+RS] = RT Doubleword (RCX)
  jmp	   CPU_INST_EMU_END
CPU_SD: ; Op Code 63 - I-Instruction Format: SD RT,Offset(Base) - Store Doubleword
  movsx    ebx,ax	      ; EBX = Immediate (Sign-Extended 16-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  add	   rbx,[rax*8+CPU_R0] ; RBX += RS
  and	   ebx,$1FFFFFFF      ; EBX &= MEM_MAP Mask
  mov	   rcx,[rcx*8+CPU_R0] ; RCX = RT
  mov	   rax,[MEM_MAP]      ; Store Doubleword
  bswap    rcx
  mov	   [rbx+rax],rcx      ; [Immediate+RS] = RT Doubleword (RCX)
  jmp	   CPU_INST_EMU_END

CPU_FUNCTION_JUMP_TABLE:
  dq CPU_SLL,	  CPU_RESERVED,CPU_SRL,     CPU_SRA,	 CPU_SLLV,    CPU_RESERVED,CPU_SRLV,	CPU_SRAV     ; Op Code 00:00..00:07
  dq CPU_JR,	  CPU_JALR,    CPU_RESERVED,CPU_RESERVED,CPU_SYSCALL, CPU_BREAK,   CPU_RESERVED,CPU_SYNC     ; Op Code 00:08..00:15
  dq CPU_MFHI,	  CPU_MTHI,    CPU_MFLO,    CPU_MTLO,	 CPU_DSLLV,   CPU_RESERVED,CPU_DSRLV,	CPU_DSRAV    ; Op Code 00:16..00:23
  dq CPU_MULT,	  CPU_MULTU,   CPU_DIV,     CPU_DIVU,	 CPU_DMULT,   CPU_DMULTU,  CPU_DDIV,	CPU_DDIVU    ; Op Code 00:24..00:31
  dq CPU_ADD,	  CPU_ADDU,    CPU_SUB,     CPU_SUBU,	 CPU_AND,     CPU_OR,	   CPU_XOR,	CPU_NOR      ; Op Code 00:32..00:39
  dq CPU_RESERVED,CPU_RESERVED,CPU_SLT,     CPU_SLTU,	 CPU_DADD,    CPU_DADDU,   CPU_DSUB,	CPU_DSUBU    ; Op Code 00:40..00:47
  dq CPU_RESERVED,CPU_RESERVED,CPU_RESERVED,CPU_RESERVED,CPU_RESERVED,CPU_RESERVED,CPU_RESERVED,CPU_RESERVED ; Op Code 00:48..00:55
  dq CPU_DSLL,	  CPU_RESERVED,CPU_DSRL,    CPU_DSRA,	 CPU_DSLL32,  CPU_RESERVED,CPU_DSRL32,	CPU_DSRA32   ; Op Code 00:56..00:63

CPU_SLL: ; Op Code 00:00 - R-Instruction Format + Function: SLL RD,RT,SA - Shift Word Left Logical
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,6	      ; ECX >>= 6
  and	   ecx,$1F	      ; ECX = SA (5-Bit)
  mov	   ebx,eax	      ; EBX = Instruction
  shr	   ebx,11	      ; EBX >>= 11
  and	   ebx,$1F	      ; EBX = RD (5-Bit)
  shr	   eax,16	      ; EAX >>= 16
  and	   eax,$1F	      ; EAX = RT (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RT]
  shl	   eax,cl	      ; EAX <<= SA
  mov	   [rbx*8+CPU_R0],rax ; RD = RAX
  jmp	   CPU_INST_EMU_END
CPU_SRL: ; Op Code 00:02 - R-Instruction Format + Function: SRL RD,RT,SA - Shift Word Right Logical
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,6	      ; ECX >>= 6
  and	   ecx,$1F	      ; ECX = SA (5-Bit)
  mov	   ebx,eax	      ; EBX = Instruction
  shr	   ebx,11	      ; EBX >>= 11
  and	   ebx,$1F	      ; EBX = RD (5-Bit)
  shr	   eax,16	      ; EAX >>= 16
  and	   eax,$1F	      ; EAX = RT (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RT]
  shr	   eax,cl	      ; EAX >>= SA
  mov	   [rbx*8+CPU_R0],rax ; RD = RAX
  jmp	   CPU_INST_EMU_END
CPU_SRA: ; Op Code 00:03 - R-Instruction Format + Function: SRA RD,RT,SA - Shift Word Right Arithmetic
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,6	      ; ECX >>= 6
  and	   ecx,$1F	      ; ECX = SA (5-Bit)
  mov	   ebx,eax	      ; EBX = Instruction
  shr	   ebx,11	      ; EBX >>= 11
  and	   ebx,$1F	      ; EBX = RD (5-Bit)
  shr	   eax,16	      ; EAX >>= 16
  and	   eax,$1F	      ; EAX = RT (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RT]
  sar	   eax,cl	      ; EAX >>= SA
  mov	   [rbx*8+CPU_R0],rax ; RD = RAX
  jmp	   CPU_INST_EMU_END
CPU_SLLV: ; Op Code 00:04 - R-Instruction Format + Function: SLLV RD,RT,RS - Shift Word Left Logical Variable
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,21	      ; ECX >>= 21
  and	   ecx,$1F	      ; ECX = RS (5-Bit)
  mov	   ebx,eax	      ; EBX = Instruction
  shr	   ebx,11	      ; EBX >>= 11
  and	   ebx,$1F	      ; EBX = RD (5-Bit)
  shr	   eax,16	      ; EAX >>= 16
  and	   eax,$1F	      ; EAX = RT (5-Bit)
  mov	   rcx,[rcx*8+CPU_R0] ; RCX = [RS]
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RT]
  shl	   eax,cl	      ; EAX <<= SA
  mov	   [rbx*8+CPU_R0],rax ; RD = RAX
  jmp	   CPU_INST_EMU_END
CPU_SRLV: ; Op Code 00:06 - R-Instruction Format + Function: SRLV RD,RT,RS - Shift Word Right Logical Variable
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,21	      ; ECX >>= 21
  and	   ecx,$1F	      ; ECX = RS (5-Bit)
  mov	   ebx,eax	      ; EBX = Instruction
  shr	   ebx,11	      ; EBX >>= 11
  and	   ebx,$1F	      ; EBX = RD (5-Bit)
  shr	   eax,16	      ; EAX >>= 16
  and	   eax,$1F	      ; EAX = RT (5-Bit)
  mov	   rcx,[rcx*8+CPU_R0] ; RCX = [RS]
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RT]
  shr	   eax,cl	      ; EAX >>= SA
  mov	   [rbx*8+CPU_R0],rax ; RD = RAX
  jmp	   CPU_INST_EMU_END
CPU_SRAV: ; Op Code 00:07 - R-Instruction Format + Function: SRAV RD,RT,RS - Shift word Right Arithmetic Variable
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,21	      ; ECX >>= 21
  and	   ecx,$1F	      ; ECX = RS (5-Bit)
  mov	   ebx,eax	      ; EBX = Instruction
  shr	   ebx,11	      ; EBX >>= 11
  and	   ebx,$1F	      ; EBX = RD (5-Bit)
  shr	   eax,16	      ; EAX >>= 16
  and	   eax,$1F	      ; EAX = RT (5-Bit)
  mov	   rcx,[rcx*8+CPU_R0] ; RCX = [RS]
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RT]
  sar	   eax,cl	      ; EAX >>= SA
  mov	   [rbx*8+CPU_R0],rax ; RD = RAX
  jmp	   CPU_INST_EMU_END
CPU_JR: ; Op Code 00:08 - R-Instruction Format + Function: JR RS - Jump Register
  ; Store RS Address To Delay Slot
  shr	   eax,21		   ; EAX >>= 21
  and	   eax,$1F		   ; EAX = RS (5-Bit)
  mov	   eax,dword[rax*8+CPU_R0] ; Delay Slot = RS
  and	   eax,$1FFFFFFF	   ; EAX &= MEM_MAP Mask
  mov	   [DELAY_SLOT],eax
  jmp	   CPU_INST_EMU 	   ; Execute Delay Slot
CPU_JALR: ; Op Code 00:09 - R-Instruction Format + Function: JALR RS,RD - Jump And Link Register
  ; Store Link To RD (Instruction After Delay Slot)
  mov	   ebx,eax		   ; EBX = Instruction
  shr	   ebx,11		   ; EBX >>= 11
  and	   ebx,$1F		   ; EBX = RD (5-Bit)
  mov	   rcx,0		   ; RCX = 0 (Zero-Extend 64-Bit)
  mov	   ecx,[CPU_PC] 	   ; ECX = PC
  add	   rcx,4		   ; RCX += 4
  movsxd   rcx,ecx		   ; Sign-Extend 64-Bit Result
  mov	   [rbx*8+CPU_R0],rcx	   ; RD = RCX
  ; Store RS Address To Delay Slot
  shr	   eax,21		   ; EAX >>= 21
  and	   eax,$1F		   ; EAX = RS (5-Bit)
  mov	   eax,dword[rax*8+CPU_R0] ; Delay Slot = RS
  and	   eax,$1FFFFFFF	   ; EAX &= MEM_MAP Mask
  mov	   [DELAY_SLOT],eax
  jmp	   CPU_INST_EMU 	   ; Execute Delay Slot
CPU_SYSCALL: ; Op Code 00:12 - R-Instruction Format + Function: SYSCALL - System Call
  jmp CPU_INST_EMU_END
CPU_BREAK: ; Op Code 00:13 - R-Instruction Format + Function: BREAK - Breakpoint
  jmp CPU_INST_EMU_END
CPU_SYNC: ; Op Code 00:15 - R-Instruction Format + Function: SYNC - Synchronize Shared Memory
  jmp CPU_INST_EMU_END
CPU_MFHI: ; Op Code 00:16 - R-Instruction Format + Function: MFHI RD Move From HI Register
  shr	   eax,11	      ; EAX >>= 11
  and	   eax,$1F	      ; EAX = RD (5-Bit)
  mov	   rbx,[CPU_HI]       ; RBX = [HI]
  mov	   [rax*8+CPU_R0],rbx ; RD = RBX
  jmp	   CPU_INST_EMU_END
CPU_MTHI: ; Op Code 00:17 - R-Instruction Format + Function: MTHI RS Move To HI Register
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RS]
  mov	   [CPU_HI],rax       ; HI = RAX
  jmp	   CPU_INST_EMU_END
CPU_MFLO: ; Op Code 00:18 - R-Instruction Format + Function: MFLO RD - Move From LO Register
  shr	   eax,11	      ; EAX >>= 11
  and	   eax,$1F	      ; EAX = RD (5-Bit)
  mov	   rbx,[CPU_LO]       ; RBX = [LO]
  mov	   [rax*8+CPU_R0],rbx ; RD = RBX
  jmp	   CPU_INST_EMU_END
CPU_MTLO: ; Op Code 00:19 - R-Instruction Format + Function: MTLO RS - Move To LO Register
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RS]
  mov	   [CPU_LO],rax       ; LO = RAX
  jmp	   CPU_INST_EMU_END
CPU_DSLLV: ; Op Code 00:20 - R-Instruction Format + Function: DSLLV RD,RT,RS - Doubleword Shift Left Logical Variable
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,21	      ; ECX >>= 21
  and	   ecx,$1F	      ; ECX = RS (5-Bit)
  mov	   ebx,eax	      ; EBX = Instruction
  shr	   ebx,11	      ; EBX >>= 11
  and	   ebx,$1F	      ; EBX = RD (5-Bit)
  shr	   eax,16	      ; EAX >>= 16
  and	   eax,$1F	      ; EAX = RT (5-Bit)
  mov	   rcx,[rcx*8+CPU_R0] ; RCX = [RS]
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RT]
  shl	   rax,cl	      ; RAX <<= SA
  mov	   [rbx*8+CPU_R0],rax ; RD = RAX
  jmp	   CPU_INST_EMU_END
CPU_DSRLV: ; Op Code 00:22 - R-Instruction Format + Function: DSRLV RD,RT,RS - Doubleword Shift Right Logical Variable
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,21	      ; ECX >>= 21
  and	   ecx,$1F	      ; ECX = RS (5-Bit)
  mov	   ebx,eax	      ; EBX = Instruction
  shr	   ebx,11	      ; EBX >>= 11
  and	   ebx,$1F	      ; EBX = RD (5-Bit)
  shr	   eax,16	      ; EAX >>= 16
  and	   eax,$1F	      ; EAX = RT (5-Bit)
  mov	   rcx,[rcx*8+CPU_R0] ; RCX = [RS]
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RT]
  shr	   rax,cl	      ; RAX >>= SA
  mov	   [rbx*8+CPU_R0],rax ; RD = RAX
  jmp	   CPU_INST_EMU_END
CPU_DSRAV: ; Op Code 00:23 - R-Instruction Format + Function: DSRAV RD,RT,RS - Doubleword Shift Right Arithmetic Variable
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,21	      ; ECX >>= 21
  and	   ecx,$1F	      ; ECX = RS (5-Bit)
  mov	   ebx,eax	      ; EBX = Instruction
  shr	   ebx,11	      ; EBX >>= 11
  and	   ebx,$1F	      ; EBX = RD (5-Bit)
  shr	   eax,16	      ; EAX >>= 16
  and	   eax,$1F	      ; EAX = RT (5-Bit)
  mov	   rcx,[rcx*8+CPU_R0] ; RCX = [RS]
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RT]
  sar	   rax,cl	      ; RAX >>= SA
  mov	   [rbx*8+CPU_R0],rax ; RD = RAX
  jmp	   CPU_INST_EMU_END
CPU_MULT: ; Op Code 00:24 - R-Instruction Format + Function: MULT RS,RT - Multiply Signed Word
  mov	   ebx,eax	      ; EBX = Instruction
  shr	   ebx,16	      ; EBX >>= 16
  and	   ebx,$1F	      ; EBX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RS]
  mov	   rbx,[rbx*8+CPU_R0] ; RBX = [RT]
  imul	   rbx		      ; EAX *= RT (Signed Multiply)
  mov	   rbx,rax	      ; RBX = RAX
  movsxd   rax,eax	      ; RAX = LO (Sign-Extend LO 32-Bit Result)
  sar	   rbx,32	      ; RBX = HI (Sign-Shift  HI 32-Bit Result)
  mov	   [CPU_LO],rax       ; LO = RAX
  mov	   [CPU_HI],rbx       ; HI = RBX
  jmp	   CPU_INST_EMU_END
CPU_MULTU: ; Op Code 00:25 - R-Instruction Format + Function: MULTU RS,RT - Multiply Unsigned Word
  mov	   ebx,eax	      ; EBX = Instruction
  shr	   ebx,16	      ; EBX >>= 16
  and	   ebx,$1F	      ; EBX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RS]
  mov	   rbx,[rbx*8+CPU_R0] ; RBX = [RT]
  mul	   rbx		      ; EAX *= RT (Unsigned Multiply)
  mov	   rbx,rax	      ; RBX = RAX
  movsxd   rax,eax	      ; RAX = LO (Sign-Extend LO 32-Bit Result)
  sar	   rbx,32	      ; RBX = HI (Sign-Shift  HI 32-Bit Result)
  mov	   [CPU_LO],rax       ; LO = RAX
  mov	   [CPU_HI],rbx       ; HI = RBX
  jmp	   CPU_INST_EMU_END
CPU_DIV: ; Op Code 00:26 - R-Instruction Format + Function: DIV RS,RT Divide Signed Word
  mov	   ebx,eax	      ; EBX = Instruction
  shr	   ebx,16	      ; EBX >>= 16
  and	   ebx,$1F	      ; EBX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RS]
  cqo			      ; Sign-Extend RAX Into RDX
  mov	   rbx,[rbx*8+CPU_R0] ; RBX = [RT]
  cmp	   rbx,0	      ; Compare RT To 0
  je	   CPU_DIV_ZERO       ; IF (RT == 0) Divide By Zero
  idiv	   rbx		      ; EDX:EAX /= RT (Signed Divide)
  mov	   [CPU_LO],rax       ; LO = RAX (Quotient)
  mov	   [CPU_HI],rdx       ; HI = RDX (Remainder)
  jmp	   CPU_INST_EMU_END
  CPU_DIV_ZERO:
    mov      [CPU_HI],rax     ; HI = RS (Remainder)
    cmp      rax,0	      ; Compare RS To 0
    jl	     CPU_DIV_ZERO_NEG ; IF (RS < 0) LO = 1, ELSE LO = -1
    mov      [CPU_LO],-1      ; LO = -1 (Quotient)
    jmp      CPU_INST_EMU_END
    CPU_DIV_ZERO_NEG:
    mov      [CPU_LO],1       ; LO = 1 (Quotient)
    jmp      CPU_INST_EMU_END
CPU_DIVU: ; Op Code 00:27 - R-Instruction Format + Function: DIVU RS,RT Divide Unsigned Word
  mov	   ebx,eax	      ; EBX = Instruction
  shr	   ebx,16	      ; EBX >>= 16
  and	   ebx,$1F	      ; EBX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RS]
  cqo			      ; Sign-Extend RAX Into RDX
  mov	   rbx,[rbx*8+CPU_R0] ; RBX = [RT]
  cmp	   rbx,0	      ; Compare RT To 0
  je	   CPU_DIVU_ZERO      ; IF (RT == 0) Divide By Zero
  div	   rbx		      ; EDX:EAX /= RT (Unsigned Divide)
  mov	   [CPU_LO],rax       ; LO = RAX (Quotient)
  mov	   [CPU_HI],rdx       ; HI = RDX (Remainder)
  jmp	   CPU_INST_EMU_END
  CPU_DIVU_ZERO:
    mov      [CPU_HI],rax     ; HI = RS (Remainder)
    mov      [CPU_LO],-1      ; LO = -1 (Quotient)
    jmp      CPU_INST_EMU_END
CPU_DMULT: ; Op Code 00:28 - R-Instruction Format + Function: DMULT RS,RT - Doubleword Multiply Signed
  mov	   ebx,eax	      ; EBX = Instruction
  shr	   ebx,16	      ; EBX >>= 16
  and	   ebx,$1F	      ; EBX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RS]
  mov	   rbx,[rbx*8+CPU_R0] ; RBX = [RT]
  imul	   rbx		      ; RAX *= RT (Signed Multiply)
  mov	   [CPU_LO],rax       ; LO = RAX
  mov	   [CPU_HI],rdx       ; HI = RDX
  jmp	   CPU_INST_EMU_END
CPU_DMULTU: ; Op Code 00:29 - R-Instruction Format + Function: DMULTU RS,RT - Doubleword Multiply Unsigned
  mov	   ebx,eax	      ; EBX = Instruction
  shr	   ebx,16	      ; EBX >>= 16
  and	   ebx,$1F	      ; EBX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RS]
  mov	   rbx,[rbx*8+CPU_R0] ; RBX = [RT]
  mul	   rbx		      ; RAX *= RT (Unsigned Multiply)
  mov	   [CPU_LO],rax       ; LO = RAX
  mov	   [CPU_HI],rdx       ; HI = RDX
  jmp	   CPU_INST_EMU_END
CPU_DDIV: ; Op Code 00:30 - R-Instruction Format + Function: DDIV RS,RT - Doubleword Divide Signed
  mov	   ebx,eax	      ; EBX = Instruction
  shr	   ebx,16	      ; EBX >>= 16
  and	   ebx,$1F	      ; EBX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RS]
  cqo			      ; Sign-Extend RAX Into RDX
  mov	   rbx,[rbx*8+CPU_R0] ; RBX = [RT]
  cmp	   rbx,0	      ; Compare RT To 0
  je	   CPU_DDIV_ZERO      ; IF (RT == 0) Divide By Zero

  mov	   rcx,-9223372036854775808 ; RCX = INT_MIN
  cmp	   rax,rcx		    ; Compare RS To INT_MIN
  jne	   CPU_DDIV_DIV 	    ; IF (RS != INT_MIN) Divide
  cmp	   rbx,-1		    ; Compare RT To -1
  jne	   CPU_DDIV_DIV 	    ; IF (RT != -1) Divide
  mov	   rcx,$8000000000000000    ; ELSE Special Case INT_MIN / -1 = INT_MIN
  mov	   [CPU_LO],rcx 	    ; LO = $8000000000000000 (Quotient)
  mov	   [CPU_HI],0		    ; HI = 0 (Remainder)
  jmp	   CPU_INST_EMU_END

  CPU_DDIV_DIV:
  idiv	   rbx		      ; RDX:RAX /= RT (Signed Divide)
  mov	   [CPU_LO],rax       ; LO = RAX (Quotient)
  mov	   [CPU_HI],rdx       ; HI = RDX (Remainder)
  jmp	   CPU_INST_EMU_END
  CPU_DDIV_ZERO:
    mov      [CPU_HI],rax      ; HI = RS (Remainder)
    cmp      rax,0	       ; Compare RS To 0
    jl	     CPU_DDIV_ZERO_NEG ; IF (RS < 0) LO = 1, ELSE LO = -1
    mov      [CPU_LO],-1       ; LO = -1 (Quotient)
    jmp      CPU_INST_EMU_END
    CPU_DDIV_ZERO_NEG:
    mov      [CPU_LO],1        ; LO = 1 (Quotient)
    jmp      CPU_INST_EMU_END
CPU_DDIVU: ; Op Code 00:31 - R-Instruction Format + Function: DDIVU RS,RT - Doubleword Divide Unsigned
  mov	   ebx,eax	      ; EBX = Instruction
  shr	   ebx,16	      ; EBX >>= 16
  and	   ebx,$1F	      ; EBX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RS]
  cqo			      ; Sign-Extend RAX Into RDX
  mov	   rbx,[rbx*8+CPU_R0] ; RBX = [RT]
  cmp	   rbx,0	      ; Compare RT To 0
  je	   CPU_DDIVU_ZERO     ; IF (RT == 0) Divide By Zero

  mov	   rcx,-9223372036854775808 ; RCX = INT_MIN
  cmp	   rax,rcx		    ; Compare RS To INT_MIN
  jne	   CPU_DDIVU_DIV	    ; IF (RS != INT_MIN) Divide
  cmp	   rbx,-1		    ; Compare RT To -1
  jne	   CPU_DDIVU_DIV	    ; IF (RT != -1) Divide
  mov	   rcx,$8000000000000000    ; ELSE Special Case INT_MIN / -1 = INT_MIN
  mov	   [CPU_LO],rcx 	    ; LO = $8000000000000000 (Quotient)
  mov	   [CPU_HI],0		    ; HI = 0 (Remainder)
  jmp	   CPU_INST_EMU_END

  CPU_DDIVU_DIV:
  div	   rbx		      ; RDX:RAX /= RT (Unsigned Divide)
  mov	   [CPU_LO],rax       ; LO = RAX (Quotient)
  mov	   [CPU_HI],rdx       ; HI = RDX (Remainder)
  jmp	   CPU_INST_EMU_END
  CPU_DDIVU_ZERO:
    mov      [CPU_HI],rax     ; HI = RS (Remainder)
    mov      [CPU_LO],-1      ; LO = -1 (Quotient)
    jmp      CPU_INST_EMU_END
CPU_ADD: ; Op Code 00:32 - R-Instruction Format + Function: ADDU RD,RS,RT - Add Signed Word
  mov	   ebx,eax	      ; EBX = Instruction
  shr	   ebx,11	      ; EBX >>= 11
  and	   ebx,$1F	      ; EBX = RD (5-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RS]
  mov	   rcx,[rcx*8+CPU_R0] ; RCX = [RT]
  add	   eax,ecx	      ; EAX += RT (Signed Add)
  movsxd   rax,eax	      ; Sign-Extend 32-Bit Result
  mov	   [rbx*8+CPU_R0],rax ; RD = RAX
  jmp	   CPU_INST_EMU_END
CPU_ADDU: ; Op Code 00:33 - R-Instruction Format + Function: ADDU RD,RS,RT - Add Unsigned Word
  mov	   ebx,eax	      ; EBX = Instruction
  shr	   ebx,11	      ; EBX >>= 11
  and	   ebx,$1F	      ; EBX = RD (5-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RS]
  mov	   rcx,[rcx*8+CPU_R0] ; RCX = [RT]
  adc	   eax,ecx	      ; EAX += RT (Unsigned Add)
  movsxd   rax,eax	      ; Sign-Extend 32-Bit Result
  mov	   [rbx*8+CPU_R0],rax ; RD = RAX
  jmp	   CPU_INST_EMU_END
CPU_SUB: ; Op Code 00:34 - R-Instruction Format + Function: SUB RD,RS,RT - Subtract Signed Word
  mov	   ebx,eax	      ; EBX = Instruction
  shr	   ebx,11	      ; EBX >>= 11
  and	   ebx,$1F	      ; EBX = RD (5-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RS]
  mov	   rcx,[rcx*8+CPU_R0] ; RCX = [RT]
  sub	   eax,ecx	      ; EAX += RT (Signed Sub)
  movsxd   rax,eax	      ; Sign-Extend 32-Bit Result
  mov	   [rbx*8+CPU_R0],rax ; RD = RAX
  jmp	   CPU_INST_EMU_END
CPU_SUBU: ; Op Code 00:35 - R-Instruction Format + Function: SUBU RD,RS,RT - Subtract Unsigned Word
  mov	   ebx,eax	      ; EBX = Instruction
  shr	   ebx,11	      ; EBX >>= 11
  and	   ebx,$1F	      ; EBX = RD (5-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RS]
  mov	   rcx,[rcx*8+CPU_R0] ; RCX = [RT]
  sbb	   eax,ecx	      ; EAX += RT (Unsigned Sub)
  movsxd   rax,eax	      ; Sign-Extend 32-Bit Result
  mov	   [rbx*8+CPU_R0],rax ; RD = RAX
  jmp	   CPU_INST_EMU_END
CPU_AND: ; Op Code 00:36 - R-Instruction Format + Function: AND RD,RS,RT - AND Doubleword
  mov	   ebx,eax	      ; EBX = Instruction
  shr	   ebx,11	      ; EBX >>= 11
  and	   ebx,$1F	      ; EBX = RD (5-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RS]
  and	   rax,[rcx*8+CPU_R0] ; RAX &= RT
  mov	   [rbx*8+CPU_R0],rax ; RD = RAX
  jmp	   CPU_INST_EMU_END
CPU_OR: ; Op Code 00:37 - R-Instruction Format + Function: OR RD,RS,RT - OR Doubleword
  mov	   ebx,eax	      ; EBX = Instruction
  shr	   ebx,11	      ; EBX >>= 11
  and	   ebx,$1F	      ; EBX = RD (5-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RS]
  or	   rax,[rcx*8+CPU_R0] ; RAX |= RT
  mov	   [rbx*8+CPU_R0],rax ; RD = RAX
  jmp	   CPU_INST_EMU_END
CPU_XOR: ; Op Code 00:38 - R-Instruction Format + Function: XOR RD,RS,RT - Exclusive OR Doubleword
  mov	   ebx,eax	      ; EBX = Instruction
  shr	   ebx,11	      ; EBX >>= 11
  and	   ebx,$1F	      ; EBX = RD (5-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RS]
  xor	   rax,[rcx*8+CPU_R0] ; RAX ^= RT
  mov	   [rbx*8+CPU_R0],rax ; RD = RAX
  jmp	   CPU_INST_EMU_END
CPU_NOR: ; Op Code 00:39 - R-Instruction Format + Function: NOR RD,RS,RT - Not OR Doubleword
  mov	   ebx,eax	      ; EBX = Instruction
  shr	   ebx,11	      ; EBX >>= 11
  and	   ebx,$1F	      ; EBX = RD (5-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RS]
  or	   rax,[rcx*8+CPU_R0] ; RAX ^= RT
  not	   rax		      ; RAX != RAX
  mov	   [rbx*8+CPU_R0],rax ; RD = RAX
  jmp	   CPU_INST_EMU_END
CPU_SLT: ; Op Code 00:42 - R-Instruction Format + Function: SLT RD,RS,RT - Set On Less Than
  mov	   ebx,eax	      ; EBX = Instruction
  shr	   ebx,11	      ; EBX >>= 11
  and	   ebx,$1F	      ; EBX = RD (5-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RS]
  cmp	   rax,[rcx*8+CPU_R0] ; Compare RS To RT
  setl	   al		      ; Set Byte IF Less (Signed)
  movzx    rax,al	      ; Zero-Extend 64-Bit Result
  mov	   [rbx*8+CPU_R0],rax ; RD = RAX
  jmp	   CPU_INST_EMU_END
CPU_SLTU: ; Op Code 00:43 - R-Instruction Format + Function: SLTU RD,RS,RT - Set On Less Than Unsigned
  mov	   ebx,eax	      ; EBX = Instruction
  shr	   ebx,11	      ; EBX >>= 11
  and	   ebx,$1F	      ; EBX = RD (5-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RS]
  cmp	   rax,[rcx*8+CPU_R0] ; Compare RS To RT
  setb	   al		      ; Set Byte IF Below (Unsigned)
  movzx    rax,al	      ; Zero-Extend 64-Bit Result
  mov	   [rbx*8+CPU_R0],rax ; RD = RAX
  jmp	   CPU_INST_EMU_END
CPU_DADD: ; Op Code 00:44 - R-Instruction Format + Function: DADD RD,RS,RT - Doubleword Add Signed
  mov	   ebx,eax	      ; EBX = Instruction
  shr	   ebx,11	      ; EBX >>= 11
  and	   ebx,$1F	      ; EBX = RD (5-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RS]
  mov	   rcx,[rcx*8+CPU_R0] ; RCX = [RT]
  add	   rax,rcx	      ; RAX += RT (Signed Add)
  mov	   [rbx*8+CPU_R0],rax ; RD = RAX
  jmp	   CPU_INST_EMU_END
CPU_DADDU: ; Op Code 00:45 - R-Instruction Format + Function: DADDU RD,RS,RT - Doubleword Add Unsigned
  mov	   ebx,eax	      ; EBX = Instruction
  shr	   ebx,11	      ; EBX >>= 11
  and	   ebx,$1F	      ; EBX = RD (5-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RS]
  mov	   rcx,[rcx*8+CPU_R0] ; RCX = [RT]
  adc	   rax,rcx	      ; RAX += RT (Unsigned Add)
  mov	   [rbx*8+CPU_R0],rax ; RD = RAX
  jmp	   CPU_INST_EMU_END
CPU_DSUB: ; Op Code 00:46 - R-Instruction Format + Function: DSUB RD,RS,RT - Doubleword Subtract Signed
  mov	   ebx,eax	      ; EBX = Instruction
  shr	   ebx,11	      ; EBX >>= 11
  and	   ebx,$1F	      ; EBX = RD (5-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RS]
  mov	   rcx,[rcx*8+CPU_R0] ; RCX = [RT]
  sub	   rax,rcx	      ; RAX += RT (Signed Sub)
  mov	   [rbx*8+CPU_R0],rax ; RD = RAX
  jmp	   CPU_INST_EMU_END
CPU_DSUBU: ; Op Code 00:47 - R-Instruction Format + Function: DSUBU RD,RS,RT - Doubleword Subtract Unsigned
  mov	   ebx,eax	      ; EBX = Instruction
  shr	   ebx,11	      ; EBX >>= 11
  and	   ebx,$1F	      ; EBX = RD (5-Bit)
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,16	      ; ECX >>= 16
  and	   ecx,$1F	      ; ECX = RT (5-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RS]
  mov	   rcx,[rcx*8+CPU_R0] ; RCX = [RT]
  sbb	   rax,rcx	      ; RAX += RT (Unsigned Sub)
  mov	   [rbx*8+CPU_R0],rax ; RD = RAX
  jmp	   CPU_INST_EMU_END
CPU_DSLL: ; Op Code 00:56 - R-Instruction Format + Function: DSLL RD,RT,SA - Doubleword Shift Left Logical
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,6	      ; ECX >>= 6
  and	   ecx,$1F	      ; ECX = SA (5-Bit)
  mov	   ebx,eax	      ; EBX = Instruction
  shr	   ebx,11	      ; EBX >>= 11
  and	   ebx,$1F	      ; EBX = RD (5-Bit)
  shr	   eax,16	      ; EAX >>= 16
  and	   eax,$1F	      ; EAX = RT (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RT]
  shl	   rax,cl	      ; RAX <<= SA
  mov	   [rbx*8+CPU_R0],rax ; RD = RAX
  jmp	   CPU_INST_EMU_END
CPU_DSRL: ; Op Code 00:58 - R-Instruction Format + Function: DSRL RD,RT,SA - Doubleword Shift Right Logical
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,6	      ; ECX >>= 6
  and	   ecx,$1F	      ; ECX = SA (5-Bit)
  mov	   ebx,eax	      ; EBX = Instruction
  shr	   ebx,11	      ; EBX >>= 11
  and	   ebx,$1F	      ; EBX = RD (5-Bit)
  shr	   eax,16	      ; EAX >>= 16
  and	   eax,$1F	      ; EAX = RT (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RT]
  shr	   rax,cl	      ; RAX >>= SA
  mov	   [rbx*8+CPU_R0],rax ; RD = RAX
  jmp	   CPU_INST_EMU_END
CPU_DSRA: ; Op Code 00:59 - R-Instruction Format + Function: DSRA RD,RT,SA - Doubleword Shift Right Arithmetic
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,6	      ; ECX >>= 6
  and	   ecx,$1F	      ; ECX = SA (5-Bit)
  mov	   ebx,eax	      ; EBX = Instruction
  shr	   ebx,11	      ; EBX >>= 11
  and	   ebx,$1F	      ; EBX = RD (5-Bit)
  shr	   eax,16	      ; EAX >>= 16
  and	   eax,$1F	      ; EAX = RT (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RT]
  sar	   rax,cl	      ; RAX >>= SA
  mov	   [rbx*8+CPU_R0],rax ; RD = RAX
  jmp	   CPU_INST_EMU_END
CPU_DSLL32: ; Op Code 00:60 - R-Instruction Format + Function: DSLL32 RD,RT,SA - Doubleword Shift Left Logical + 32
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,6	      ; ECX >>= 6
  and	   ecx,$1F	      ; ECX = SA (5-Bit)
  mov	   ebx,eax	      ; EBX = Instruction
  shr	   ebx,11	      ; EBX >>= 11
  and	   ebx,$1F	      ; EBX = RD (5-Bit)
  shr	   eax,16	      ; EAX >>= 16
  and	   eax,$1F	      ; EAX = RT (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RT]
  add	   cl,32	      ; SA += 32
  shl	   rax,cl	      ; RAX <<= SA
  mov	   [rbx*8+CPU_R0],rax ; RD = RAX
  jmp	   CPU_INST_EMU_END
CPU_DSRL32: ; Op Code 00:62 - R-Instruction Format + Function: DSRL32 RD,RT,SA - Doubleword Shift Right Logical + 32
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,6	      ; ECX >>= 6
  and	   ecx,$1F	      ; ECX = SA (5-Bit)
  mov	   ebx,eax	      ; EBX = Instruction
  shr	   ebx,11	      ; EBX >>= 11
  and	   ebx,$1F	      ; EBX = RD (5-Bit)
  shr	   eax,16	      ; EAX >>= 16
  and	   eax,$1F	      ; EAX = RT (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RT]
  add	   cl,32	      ; SA += 32
  shr	   rax,cl	      ; RAX >>= SA
  mov	   [rbx*8+CPU_R0],rax ; RD = RAX
  jmp	   CPU_INST_EMU_END
CPU_DSRA32: ; Op Code 00:63 - R-Instruction Format + Function: DSRA32 RD,RT,SA - Doubleword Shift Right Arithmetic + 32
  mov	   ecx,eax	      ; ECX = Instruction
  shr	   ecx,6	      ; ECX >>= 6
  and	   ecx,$1F	      ; ECX = SA (5-Bit)
  mov	   ebx,eax	      ; EBX = Instruction
  shr	   ebx,11	      ; EBX >>= 11
  and	   ebx,$1F	      ; EBX = RD (5-Bit)
  shr	   eax,16	      ; EAX >>= 16
  and	   eax,$1F	      ; EAX = RT (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = [RT]
  add	   cl,32	      ; SA += 32
  sar	   rax,cl	      ; RAX >>= SA
  mov	   [rbx*8+CPU_R0],rax ; RD = RAX
  jmp	   CPU_INST_EMU_END

CPU_REGIMM_JUMP_TABLE:
  dq CPU_BLTZ,	  CPU_BGEZ,    CPU_BLTZL,   CPU_BGEZL,	 CPU_RESERVED,CPU_RESERVED,CPU_RESERVED,CPU_RESERVED ; RT Code 00..07
  dq CPU_RESERVED,CPU_RESERVED,CPU_RESERVED,CPU_RESERVED,CPU_RESERVED,CPU_RESERVED,CPU_RESERVED,CPU_RESERVED ; RT Code 08..15
  dq CPU_BLTZAL,  CPU_BGEZAL,  CPU_BLTZALL, CPU_BGEZALL, CPU_RESERVED,CPU_RESERVED,CPU_RESERVED,CPU_RESERVED ; RT Code 16..23
  dq CPU_RESERVED,CPU_RESERVED,CPU_RESERVED,CPU_RESERVED,CPU_RESERVED,CPU_RESERVED,CPU_RESERVED,CPU_RESERVED ; RT Code 24..31

CPU_BLTZ: ; Op Code 01:00 - I-Instruction Format: BLTZ RS,Offset - Branch On Less Than Zero
  movsx    ebx,ax	      ; EBX = Offset (Sign-Extended 16-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = RS
  cmp	   rax,0	      ; Compare RS To 0
  jge	   CPU_INST_EMU_END   ; IF (RS < 0) Set Delay Slot, ELSE Do Not Store Delay Slot
  ; ELSE Store Delay Slot Program Counter Relative Offset Address
  mov	   eax,[CPU_PC]       ; Delay Slot = CPU_PC + (Offset << 2)
  shl	   ebx,2
  add	   eax,ebx
  mov	   [DELAY_SLOT],eax
  jmp	   CPU_INST_EMU       ; Execute Delay Slot
CPU_BGEZ: ; Op Code 01:01 - I-Instruction Format: BGEZ RS,Offset - Branch On Greater Than Or Equal To Zero
  movsx    ebx,ax	      ; EBX = Offset (Sign-Extended 16-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = RS
  cmp	   rax,0	      ; Compare RS To 0
  jl	   CPU_INST_EMU_END   ; IF (RS >= 0) Set Delay Slot, ELSE Do Not Store Delay Slot
  ; ELSE Store Delay Slot Program Counter Relative Offset Address
  mov	   eax,[CPU_PC]       ; Delay Slot = CPU_PC + (Offset << 2)
  shl	   ebx,2
  add	   eax,ebx
  mov	   [DELAY_SLOT],eax
  jmp	   CPU_INST_EMU       ; Execute Delay Slot
CPU_BLTZL: ; Op Code 01:02 - I-Instruction Format: BLTZL RS,Offset - Branch On Less Than Zero Likely
  movsx    ebx,ax	      ; EBX = Offset (Sign-Extended 16-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = RS
  cmp	   rax,0	      ; Compare RS To 0
  jge	   CPU_BLTZL_LIKELY   ; IF (RS < 0) Set Delay Slot, ELSE Do Not Store Delay Slot, PC += 4
  ; ELSE Store Delay Slot Program Counter Relative Offset Address
  mov	   eax,[CPU_PC]       ; Delay Slot = CPU_PC + (Offset << 2)
  shl	   ebx,2
  add	   eax,ebx
  mov	   [DELAY_SLOT],eax
  jmp	   CPU_INST_EMU       ; Execute Delay Slot
  CPU_BLTZL_LIKELY:
  add	   [CPU_PC],4	      ; Program Counter += 4
  jmp	   CPU_INST_EMU_END
CPU_BGEZL: ; Op Code 01:03 - I-Instruction Format: BGEZL RS,Offset - Branch On Greater Than or Equal To Zero Likely
  movsx    ebx,ax	      ; EBX = Offset (Sign-Extended 16-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = RS
  cmp	   rax,0	      ; Compare RS To 0
  jl	   CPU_BGEZL_LIKELY   ; IF (RS >= 0) Set Delay Slot, ELSE Do Not Store Delay Slot, PC += 4
  ; ELSE Store Delay Slot Program Counter Relative Offset Address
  mov	   eax,[CPU_PC]       ; Delay Slot = CPU_PC + (Offset << 2)
  shl	   ebx,2
  add	   eax,ebx
  mov	   [DELAY_SLOT],eax
  jmp	   CPU_INST_EMU       ; Execute Delay Slot
  CPU_BGEZL_LIKELY:
  add	   [CPU_PC],4	      ; Program Counter += 4
  jmp	   CPU_INST_EMU_END
CPU_BLTZAL: ; Op Code 01:16 - I-Instruction Format: BLTZAL RS,Offset - Branch On Less Than Zero And Link
  ; Store Link To RA (Instruction After Delay Slot)
  mov	   rbx,0	; RBX = 0 (Zero-Extend 64-Bit)
  mov	   ebx,[CPU_PC] ; EBX = PC
  add	   rbx,4	; RBX += 4
  movsxd   rbx,ebx	; Sign-Extend 64-Bit Result
  mov	   [CPU_RA],rbx ; RA = RBX
  movsx    ebx,ax	      ; EBX = Offset (Sign-Extended 16-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = RS
  cmp	   rax,0	      ; Compare RS To 0
  jge	   CPU_INST_EMU_END   ; IF (RS < 0) Set Delay Slot, ELSE Do Not Store Delay Slot
  ; ELSE Store Delay Slot Program Counter Relative Offset Address
  mov	   eax,[CPU_PC]       ; Delay Slot = CPU_PC + (Offset << 2)
  shl	   ebx,2
  add	   eax,ebx
  mov	   [DELAY_SLOT],eax
  jmp	   CPU_INST_EMU       ; Execute Delay Slot
CPU_BGEZAL: ; Op Code 01:17 - I-Instruction Format: BGEZAL RS,Offset - Branch On Greater Than Or Equal To Zero And Link
  ; Store Link To RA (Instruction After Delay Slot)
  mov	   rbx,0	; RBX = 0 (Zero-Extend 64-Bit)
  mov	   ebx,[CPU_PC] ; EBX = PC
  add	   rbx,4	; RBX += 4
  movsxd   rbx,ebx	; Sign-Extend 64-Bit Result
  mov	   [CPU_RA],rbx ; RA = RBX
  movsx    ebx,ax	      ; EBX = Offset (Sign-Extended 16-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = RS
  cmp	   rax,0	      ; Compare RS To 0
  jl	   CPU_INST_EMU_END   ; IF (RS >= 0) Set Delay Slot, ELSE Do Not Store Delay Slot
  ; ELSE Store Delay Slot Program Counter Relative Offset Address
  mov	   eax,[CPU_PC]       ; Delay Slot = CPU_PC + (Offset << 2)
  shl	   ebx,2
  add	   eax,ebx
  mov	   [DELAY_SLOT],eax
  jmp	   CPU_INST_EMU       ; Execute Delay Slot
CPU_BLTZALL: ; Op Code 01:18 - I-Instruction Format: BLTZALL RS,Offset - Branch On Less Than Zero And Link Likely
  ; Store Link To RA (Instruction After Delay Slot)
  mov	   rbx,0	; RBX = 0 (Zero-Extend 64-Bit)
  mov	   ebx,[CPU_PC] ; EBX = PC
  add	   rbx,4	; RBX += 4
  movsxd   rbx,ebx	; Sign-Extend 64-Bit Result
  mov	   [CPU_RA],rbx ; RA = RBX
  movsx    ebx,ax	      ; EBX = Offset (Sign-Extended 16-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = RS
  cmp	   rax,0	      ; Compare RS To 0
  jge	   CPU_BLTZALL_LIKELY ; IF (RS < 0) Set Delay Slot, ELSE Do Not Store Delay Slot, PC += 4
  ; ELSE Store Delay Slot Program Counter Relative Offset Address
  mov	   eax,[CPU_PC]       ; Delay Slot = CPU_PC + (Offset << 2)
  shl	   ebx,2
  add	   eax,ebx
  mov	   [DELAY_SLOT],eax
  jmp	   CPU_INST_EMU       ; Execute Delay Slot
  CPU_BLTZALL_LIKELY:
  add	   [CPU_PC],4	      ; Program Counter += 4
  jmp	   CPU_INST_EMU_END
CPU_BGEZALL: ; Op Code 01:19 - I-Instruction Format: BGEZALL RS,Offset - Branch On Greater Than Or Equal To Zero And Link Likely
  ; Store Link To RA (Instruction After Delay Slot)
  mov	   rbx,0	; RBX = 0 (Zero-Extend 64-Bit)
  mov	   ebx,[CPU_PC] ; EBX = PC
  add	   rbx,4	; RBX += 4
  movsxd   rbx,ebx	; Sign-Extend 64-Bit Result
  mov	   [CPU_RA],rbx ; RA = RBX
  movsx    ebx,ax	      ; EBX = Offset (Sign-Extended 16-Bit)
  shr	   eax,21	      ; EAX >>= 21
  and	   eax,$1F	      ; EAX = RS (5-Bit)
  mov	   rax,[rax*8+CPU_R0] ; RAX = RS
  cmp	   rax,0	      ; Compare RS To 0
  jl	   CPU_BGEZALL_LIKELY ; IF (RS >= 0) Set Delay Slot, ELSE Do Not Store Delay Slot, PC += 4
  ; ELSE Store Delay Slot Program Counter Relative Offset Address
  mov	   eax,[CPU_PC]       ; Delay Slot = CPU_PC + (Offset << 2)
  shl	   ebx,2
  add	   eax,ebx
  mov	   [DELAY_SLOT],eax
  jmp	   CPU_INST_EMU       ; Execute Delay Slot
  CPU_BGEZALL_LIKELY:
  add	   [CPU_PC],4	      ; Program Counter += 4
  jmp	   CPU_INST_EMU_END

CPU_RESERVED: ; CPU Op Code: Reserved
  invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY+BACKGROUND_RED ; HANDLE, Console Text Attribute
  cinvoke  printf,<10,'ERROR:     '>
  invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY+BACKGROUND_RED+BACKGROUND_INTENSITY ; HANDLE, Console Text Attribute
  mov	   edx,[CPU_PC]
  mov	   eax,edx
  mov	   eax,[CPU_PC]
  and	   eax,$1FFFFFFF ; EAX &= MEM_MAP Mask
  add	   rax,[MEM_MAP]
  mov	   r8d,dword[rax-4]
  bswap    r8d
  cinvoke  printf,<'Unknown CPU opcode at PC $%08X: $%08X'>
  jmp	   CPU_INST_EMU_END