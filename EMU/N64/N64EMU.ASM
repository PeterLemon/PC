format PE64 console
entry start

include 'win64a.inc'
include 'opengl.inc'
include 'console.inc'
include 'mem.inc'

section '.text' code readable executable

start:
  sub	   rsp,8

  ; Store Console Handle
  invoke   GetStdHandle,STD_OUTPUT_HANDLE ; RAX = CONSOLE HANDLE
  mov	   [hcn],rax ; Store CONSOLE HANDLE (RAX)

  ; Print Program Title
  invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY+BACKGROUND_BLUE+BACKGROUND_RED+COMMON_LVB_UNDERSCORE ; HANDLE, Console Text Attribute
  invoke   WriteFile,[hcn],'N64 Emulator by Peter Lemon (krom) 2019',39,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

  ; Command-Line Parameters
  invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY+BACKGROUND_GREEN ; HANDLE, Console Text Attribute
  invoke   WriteFile,[hcn],ROMFile,12,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
  invoke   SetConsoleTextAttribute,[hcn],BACKGROUND_GREEN+BACKGROUND_INTENSITY ; HANDLE, Console Text Attribute
  invoke   GetCommandLine ; RAX = Pointer To Command-Line String
  mov	   rdx,rax	  ; RDX = Pointer To Command-Line String (Strip .EXE Name Length)

  ; Find Start Of Command-Line String Parameter (ROM File)
  mov	   rbx,0 ; RBX = Space Byte Count
  LoopCMD_START: ; Store Length Of 1st Command-Line String Parameter In Bytes To RBX
    mov      cl,[rdx] ; CL = Text Byte
    inc      rdx ; Pointer To Command-Line String++
    inc      rbx ; Space Byte Count++
    cmp      cl,$20	   ; Compare Text Byte (CL) To Space " " Character
    jnz      LoopCMD_START ; IF (Text Byte != $20) Loop
  inc	   rbx	   ; RBX = Length Of 1st Command-Line String Parameter In Bytes (Strip Space Byte From Length)
  add	   rax,rbx ; RAX = Pointer To Command-Line String (Strip 1st Command-Line String Parameter)
  mov	   rdx,rax ; RDX = Pointer To Command-Line String (Strip 1st Command-Line String Parameter)

  ; Find End Of Command-Line String Parameter (ROM File)
  mov	   rbx,0 ; RBX = Zero Byte Count
  ; Start Double Quote Check
  mov	   cl,[rdx] ; CL = Text Byte
  cmp	   cl,'"'
  jnz	   LoopCMD_END
  inc	   rax ; Pointer To Command-Line String++
  inc	   rdx ; Pointer To Command-Line String++
  LoopCMD_END: ; Store Length Of Command-Line String In Bytes To RBX
    mov      cl,[rdx] ; CL = Text Byte
    ; End Double Quote Check
    cmp      cl,'"' ; Compare Text Byte (CL) To Double Quote  '"' Character
    jnz      LoopCMD_END_DOUBLE_QUOTE ; IF (Text Byte != Double Quote Character) End
    mov      cl,$00 ; ELSE Replace Double Quote Character With Zero Byte
    mov      [rdx],cl ; Pointer To Command-Line String = CL
    LoopCMD_END_DOUBLE_QUOTE:
    ; Zero Byte Check
    inc      rdx ; Pointer To Command-Line String++
    inc      rbx ; Zero Byte Count++
    cmp      cl,$00	 ; Compare Text Byte (CL) To Zero
    jnz      LoopCMD_END ; IF (Text Byte != $00) Loop
  dec	   rbx ; RBX = Length Of Command-Line String In Bytes (Strip Zero Byte From Length)
  mov	   rdi,rax ; RDX = Pointer To Command-Line String (Strip 1st Command-Line String Parameter)

  invoke   WriteFile,[hcn],rax,rbx,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

  ; Check Command-Line String Parameter ROM File
  invoke   GetFileAttributes,rdi ; EAX = FILE_ATTRIBUTES
  cmp	   eax,-1 ; Compare EAX To INVALID_FILE_ATTRIBUTES
  jne	   ROM_Found ; IF (EAX != INVALID_FILE_ATTRIBUTES) ROM Found
  ; ELSE Print Error/Usage & Quit
  ; Print Error
  invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY+BACKGROUND_RED ; HANDLE, Console Text Attribute
  invoke   WriteFile,[hcn],ProgramError,12,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
  invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY+BACKGROUND_RED+BACKGROUND_INTENSITY ; HANDLE, Console Text Attribute
  invoke   WriteFile,[hcn],'ROM FILE NOT FOUND',18,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
  ; Print Usage
  invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY+BACKGROUND_BLUE+BACKGROUND_GREEN ; HANDLE, Console Text Attribute
  invoke   WriteFile,[hcn],ProgramUsage,12,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
  invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY+BACKGROUND_BLUE+BACKGROUND_INTENSITY ; HANDLE, Console Text Attribute
  invoke   WriteFile,[hcn],'N64EMU.EXE ROM.N64',18,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
  ; Reset Console Text Attribute
  invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_GREEN+FOREGROUND_RED ; HANDLE, Console Text Attribute
  invoke   ExitProcess,0

ROM_Found:
  ; Allocate MEM_MAP Memory ($20000000 Bytes)
  invoke   VirtualAlloc,0,$20000000,MEM_COMMIT+MEM_RESERVE,4 ; Address, Size In Bytes, File Allocation Type, File Protect
  mov	   [MEM_MAP],rax ; Store Address Of Allocated Memory (RAX)

  ; Copy Full ROM To MEM_MAP
  invoke   CreateFile,rdi,GENERIC_READ,0,0,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0 ; Open The File To Read
  mov	   [hFile],rax ; Store FILE HANDLE (RAX)
  invoke   GetFileSize,[hFile],0 ; RAX = FILE SIZE
  mov	   rdx,CART_DOM1_ADDR2
  add	   rdx,[MEM_MAP] ; RDX = MEM_MAP ROM Address
  invoke   ReadFile,[hFile],rdx,rax,0,0 ; FILE HANDLE, Buffer, Number Of Bytes To Read, Number Of Bytes Read, Overlapped

  invoke   GetModuleHandle,0
  mov	   [wc.hInstance],rax
  invoke   LoadIcon,0,IDI_APPLICATION
  mov	   [wc.hIcon],rax
  invoke   LoadCursor,0,IDC_ARROW
  mov	   [wc.hCursor],rax
  invoke   RegisterClass,wc
  invoke   CreateWindowEx,0,_class,_title,WS_VISIBLE+WS_OVERLAPPEDWINDOW+WS_CLIPCHILDREN+WS_CLIPSIBLINGS,16,16,656,519,NULL,NULL,[wc.hInstance],NULL

  msg_loop:
    invoke   GetMessage,addr msg,NULL,0,0
    cmp      rax,1
    jb	     end_loop
    jne      msg_loop
    invoke   TranslateMessage,addr msg
    invoke   DispatchMessage,addr msg
    jmp      msg_loop

  end_loop:
    invoke   ExitProcess,[msg.wParam]

proc WindowProc uses rbx rsi rdi, hwnd,wmsg,wparam,lparam
  mov	   [hwnd],rcx
  cmp	   rdx,WM_CREATE
  je	   .wmcreate
  cmp	   rdx,WM_SIZE
  je	   .wmsize
  cmp	   rdx,WM_PAINT
  je	   .wmpaint
  cmp	   rdx,WM_KEYDOWN
  je	   .wmkeydown
  cmp	   rdx,WM_DESTROY
  je	   .wmdestroy
  .defwndproc:
    invoke   DefWindowProc,rcx,rdx,r8,r9
    ret
  .wmcreate:
    invoke   GetDC,rcx
    mov      [hdc],rax
    mov      [pfd.dwFlags],PFD_SUPPORT_OPENGL+PFD_DOUBLEBUFFER+PFD_DRAW_TO_WINDOW
    invoke   ChoosePixelFormat,[hdc],addr pfd
    invoke   SetPixelFormat,[hdc],rax,addr pfd
    invoke   wglCreateContext,[hdc]
    mov      [hrc],rax
    invoke   wglMakeCurrent,[hdc],[hrc]

    ; Create A 256x256x24BPP Texture From The Resource Texture (RAW File)
    invoke   glTexParameteri,GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR ; Set The Texture Filter While Decreasing (Linear)
    invoke   glTexParameteri,GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR ; Set The Texture Filter While Increasing (Linear)
    invoke   glEnable,GL_TEXTURE_2D ; Enable Texturing
    invoke   glPixelStorei,GL_UNPACK_SWAP_BYTES,GL_TRUE ; Tell OpenGL that the byte order is swapped

    ; Print ROM Info
    invoke   SetConsoleTextAttribute,[hcn],BACKGROUND_BLUE+BACKGROUND_GREEN+BACKGROUND_RED ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],ROMTitle,12,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   SetConsoleTextAttribute,[hcn],BACKGROUND_BLUE+BACKGROUND_GREEN+BACKGROUND_RED+BACKGROUND_INTENSITY ; HANDLE, Console Text Attribute
    mov      rax,CART_DOM1_ADDR2+32
    add      rax,[MEM_MAP] ; RAX = ROM Address
    invoke   WriteFile,[hcn],rax,27,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],BACKGROUND_BLUE+BACKGROUND_GREEN+BACKGROUND_RED ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],ROMStart,12,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CART_DOM1_ADDR2+8
    add      rax,[MEM_MAP] ; RAX = ROM Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,4 ; CX = Loop Count
    call     NUM2STRBE
    invoke   SetConsoleTextAttribute,[hcn],BACKGROUND_BLUE+BACKGROUND_GREEN+BACKGROUND_RED+BACKGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,9,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    ; Copy 1MB Of ROM To MEM_MAP (Dirty Hack Before PIF Data Emulation)
    mov      rax,CART_DOM1_ADDR2
    add      rax,[MEM_MAP] ; RAX = ROM Address
    mov      rcx,1052672 ; RCX = ROM Size In Bytes
    mov      rdx,[MEM_MAP] ; RDX = MEM_MAP Start Address
    .CopyROM1MB:
      mov      bl,[rax]
      add      rax,1
      mov      [rdx],bl
      add      rdx,1
      loopnz   .CopyROM1MB

    ; Set Program Counter (Dirty Hack Before PIF Data Emulation)
    mov      rax,CART_DOM1_ADDR2
    add      rax,[MEM_MAP] ; RAX = MEM_MAP ROM Address
    mov      bl,[rax+9] ; Convert ROM Start Address To Little Endian
    mov      bh,[rax+8]
    shl      ebx,16
    mov      bl,[rax+11]
    mov      bh,[rax+10] ; RAX = ROM Start Address
    mov      [CPU_PC],ebx

    ret
  .wmsize:
    invoke   GetClientRect,[hwnd],addr rc
    invoke   glViewport,0,0,[rc.right],[rc.bottom]
    ret
  .wmpaint:
    call CPU_INST_EMU ; Run CPU Instruction

    ; VI Width
    mov      rbx,[MEM_MAP] ; RBX = MEM_MAP Address
    mov      al,[rbx+VI_WIDTH+3]
    mov      ah,[rbx+VI_WIDTH+2] ; AX = VI: Width Register Halfword (LSH)
    movzx    r9,ax ; R9 = OpenGL Width

    ; VI Height
    mov      al,[rbx+VI_Y_SCALE+3] ; Height = (VI_Y_SCALE * 60) / 256
    mov      ah,[rbx+VI_Y_SCALE+2] ; AX = VI: Y-Scale Register Halfword (LSH)
    movzx    eax,ax ; Zero-Extend 16-Bit Result
    mov      ecx,60 ; ECX = 60
    mul      ecx    ; EAX *= ECX
    shr      eax,8  ; EAX /= 256
    movzx    r10,ax ; R10 = OpenGL Height

    ; VI Origin (Frame Buffer Start Address)
    mov      al,[rbx+VI_ORIGIN+1] ; Convert Video Interface (VI) Base Register Address Word To Little Endian
    mov      ah,[rbx+VI_ORIGIN+0]
    shl      eax,16
    mov      al,[rbx+VI_ORIGIN+3]
    mov      ah,[rbx+VI_ORIGIN+2] ; EAX = VI Origin Register Word (32-Bit)
    and      rax,$1FFFFFFF ; RAX &= MEM_MAP Mask
    add      rax,rbx ; RAX = OpenGL Texture Address

    ; VI Color Depth
    mov      bl,[rbx+VI_STATUS+3] ; BL = VI Status/Control Register Byte (LSB)
    and      bl,7 ; BL = VI Status/Control: Color Depth (3 Bits)
    cmp      bl,2 ; IF (VI Status/Control: Color Depth == 2) Color Depth = 16-BPP
    je	     .VI_16BPP ; ELSE Color Depth = 32-BPP
    mov      ebx,GL_UNSIGNED_BYTE ; EBX = OpenGL Color Depth 32-BPP Attribute
    jmp      .VI_BPP_END
    .VI_16BPP:
    mov      ebx,GL_UNSIGNED_SHORT_5_5_5_1 ; EBX = OpenGL Color Depth 16-BPP Attribute
    .VI_BPP_END:

    invoke   glTexImage2D,GL_TEXTURE_2D,0,GL_RGBA,r9,r10,0,GL_RGBA,ebx,rax

    invoke   glTexImage2D,GL_TEXTURE_2D,0,GL_RGBA,r9,r10,0,GL_RGBA,GL_UNSIGNED_SHORT_5_5_5_1,[MEM_MAP]

    invoke   glClear,GL_COLOR_BUFFER_BIT
    invoke   glBegin,GL_QUADS
    invoke   glTexCoord2f,float dword 0.0,float dword 1.0
    invoke   glVertex3d,float -1.0,float -1.0,float 0.0
    invoke   glTexCoord2f,float dword 1.0,float dword 1.0
    invoke   glVertex3d,float 1.0,float -1.0,float 0.0
    invoke   glTexCoord2f,float dword 1.0,float dword 0.0
    invoke   glVertex3d,float 1.0,float 1.0,float 0.0
    invoke   glTexCoord2f,float dword 0.0,float dword 0.0
    invoke   glVertex3d,float -1.0,float 1.0,float 0.0
    invoke   glEnd
    invoke   SwapBuffers,[hdc]
    ret
  .wmkeydown:
    cmp      r8d,VK_ESCAPE
    jne      .defwndproc
  .wmdestroy:
    invoke   wglMakeCurrent,0,0
    invoke   wglDeleteContext,[hrc]
    invoke   ReleaseDC,[hwnd],[hdc]
    invoke   PostQuitMessage,0

;    include 'debug.asm' ; Debug Console Printing

    ; Reset Console Text Attribute
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_GREEN+FOREGROUND_RED ; HANDLE, Console Text Attribute
    xor      eax,eax
    ret
endp

include 'cpu.asm' ; CPU Instruction Emulation
include 'cp1.asm' ; CP1 Instruction Emulation (Coprocessor 1: FPU)

NUM2STRBE: ; RAX = Value Address, RBX = Text Buffer Address, CX = Loop Count
  mov	   dl,[rax] ; DL = Value
  mov	   dh,dl ; DH = Value
  and	   dl,$F ; DL = Value Lo
  shr	   dh,4 ; DH = Value Hi

  cmp	   dl,10
  jnge	   NUM2STRBELO
  add	   dl,$07
  NUM2STRBELO:
  add	   dl,$30

  cmp	   dh,10
  jnge	   NUM2STRBEHI
  add	   dh,$07
  NUM2STRBEHI:
  add	   dh,$30

  mov	   [rbx+1],dl ; DL = Value
  mov	   [rbx+0],dh ; DH = Value
  inc	   rax ; RAX++ (Increment Value Address)
  add	   rbx,2 ; RBX += 2 (Increment Text Buffer Address)
  loopne   NUM2STRBE
  ret

NUM2STRLE: ; RAX = Value Address, RBX = Text Buffer Address, CX = Loop Count
  add	   rbx,rcx
  add	   rbx,rcx
  sub	   rbx,2
NUM2STRLELOOP:
  mov	   dl,[rax] ; DL = Value
  mov	   dh,dl ; DH = Value
  and	   dl,$F ; DL = Value Lo
  shr	   dh,4 ; DH = Value Hi

  cmp	   dl,10
  jnge	   NUM2STRLELO
  add	   dl,$07
  NUM2STRLELO:
  add	   dl,$30

  cmp	   dh,10
  jnge	   NUM2STRLEHI
  add	   dh,$07
  NUM2STRLEHI:
  add	   dh,$30

  mov	   [rbx+1],dl ; DL = Value
  mov	   [rbx+0],dh ; DH = Value
  inc	   rax ; RAX++ (Increment Value Address)
  sub	   rbx,2 ; RBX -= 2 (Decrement Text Buffer Address)
  loopne   NUM2STRLELOOP
  ret

section '.data' data readable writeable

  _title db 'N64 Emulator: VI Output',0
  _class db 'FASMN64EMU',0

  theta GLfloat 0.6

  wc WNDCLASS 0,WindowProc,0,0,NULL,NULL,NULL,NULL,NULL,_class

  hcn dq ?
  hdc dq ?
  hrc dq ?
  hFile dq ?

  msg MSG
  rc RECT
  pfd PIXELFORMATDESCRIPTOR

  MEM_MAP dq ? ; $00000000..$1FFFFFFF MEM_MAP

  CYCLES dd 0 ; Cycle Counter

  DELAY_SLOT dd 0 ; Delay Slot

  FPU_CTRL dw 0 ; FPU Control

  ; CPU Registers
  CPU_PC dd 0 ; CPU Register Program Counter
  CPU_R0 dq 0 ; CPU Register R0
  CPU_AT dq 0 ; CPU Register R1
  CPU_V0 dq 0 ; CPU Register R2
  CPU_V1 dq 0 ; CPU Register R3
  CPU_A0 dq 0 ; CPU Register R4
  CPU_A1 dq 0 ; CPU Register R5
  CPU_A2 dq 0 ; CPU Register R6
  CPU_A3 dq 0 ; CPU Register R7
  CPU_T0 dq 0 ; CPU Register R8
  CPU_T1 dq 0 ; CPU Register R9
  CPU_T2 dq 0 ; CPU Register R10
  CPU_T3 dq 0 ; CPU Register R11
  CPU_T4 dq 0 ; CPU Register R12
  CPU_T5 dq 0 ; CPU Register R13
  CPU_T6 dq 0 ; CPU Register R14
  CPU_T7 dq 0 ; CPU Register R15
  CPU_S0 dq 0 ; CPU Register R16
  CPU_S1 dq 0 ; CPU Register R17
  CPU_S2 dq 0 ; CPU Register R18
  CPU_S3 dq 0 ; CPU Register R19
  CPU_S4 dq 0 ; CPU Register R20
  CPU_S5 dq 0 ; CPU Register R21
  CPU_S6 dq 0 ; CPU Register R22
  CPU_S7 dq 0 ; CPU Register R23
  CPU_T8 dq 0 ; CPU Register R24
  CPU_T9 dq 0 ; CPU Register R25
  CPU_K0 dq 0 ; CPU Register R26
  CPU_K1 dq 0 ; CPU Register R27
  CPU_GP dq 0 ; CPU Register R28
  CPU_SP dq 0 ; CPU Register R29
  CPU_S8 dq 0 ; CPU Register R30
  CPU_RA dq 0 ; CPU Register R31
  CPU_LO dq 0 ; CPU Register LO
  CPU_HI dq 0 ; CPU Register HI

  ; FPU Registers (Coprocessor 1)
  CP1_F0  dq 0 ; CP1 Register F0
  CP1_F1  dq 0 ; CP1 Register F1
  CP1_F2  dq 0 ; CP1 Register F2
  CP1_F3  dq 0 ; CP1 Register F3
  CP1_F4  dq 0 ; CP1 Register F4
  CP1_F5  dq 0 ; CP1 Register F5
  CP1_F6  dq 0 ; CP1 Register F6
  CP1_F7  dq 0 ; CP1 Register F7
  CP1_F8  dq 0 ; CP1 Register F8
  CP1_F9  dq 0 ; CP1 Register F9
  CP1_F10 dq 0 ; CP1 Register F10
  CP1_F11 dq 0 ; CP1 Register F11
  CP1_F12 dq 0 ; CP1 Register F12
  CP1_F13 dq 0 ; CP1 Register F13
  CP1_F14 dq 0 ; CP1 Register F14
  CP1_F15 dq 0 ; CP1 Register F15
  CP1_F16 dq 0 ; CP1 Register F16
  CP1_F17 dq 0 ; CP1 Register F17
  CP1_F18 dq 0 ; CP1 Register F18
  CP1_F19 dq 0 ; CP1 Register F19
  CP1_F20 dq 0 ; CP1 Register F20
  CP1_F21 dq 0 ; CP1 Register F21
  CP1_F22 dq 0 ; CP1 Register F22
  CP1_F23 dq 0 ; CP1 Register F23
  CP1_F24 dq 0 ; CP1 Register F24
  CP1_F25 dq 0 ; CP1 Register F25
  CP1_F26 dq 0 ; CP1 Register F26
  CP1_F27 dq 0 ; CP1 Register F27
  CP1_F28 dq 0 ; CP1 Register F28
  CP1_F29 dq 0 ; CP1 Register F29
  CP1_F30 dq 0 ; CP1 Register F30
  CP1_F31 dq 0 ; CP1 Register F31
  CP1_FP  db 0 ; CP1 Floating Point Condition Code (Boolean)

  HEXTEXT db '$'
  NUMTEXT: rept 32 {db 0}

  ProgramError db 10,'ERROR:     '
  ProgramUsage db 10,'USAGE:     '
  ROMFile      db 10,'ROM FILE:  '
  ROMTitle     db 10,'ROM TITLE: '
  ROMStart     db 10,'ROM START: '
  CPU_Register db 10,'CPU Register - '
  CP1_Register db 10,'CP1 Register - '

section '.idata' import data readable writeable

  library kernel32,'KERNEL32.DLL',\
	  user32,'USER32.DLL',\
	  gdi32,'GDI32.DLL',\
	  opengl32,'OPENGL32.DLL'

  include 'api/kernel32.inc'
  include 'api/user32.inc'
  include 'api/gdi32.inc'
  include 'api/opengl32.inc'