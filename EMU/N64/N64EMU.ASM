format PE64 console
entry start

DEBUG = 1

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
  cinvoke  printf,<'N64 Emulator by Peter Lemon (krom) 2019'>

  ; Command-Line Parameters
  invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY+BACKGROUND_GREEN ; HANDLE, Console Text Attribute
  cinvoke  printf,<10,'ROM FILE:  '>
  invoke   SetConsoleTextAttribute,[hcn],BACKGROUND_GREEN+BACKGROUND_INTENSITY ; HANDLE, Console Text Attribute

  ; Find Start Of Command-Line String Parameter (ROM File)
  invoke   GetCommandLine ; RAX = Pointer To Command-Line String
  LoopCMD_START:
  mov	   bl,[rax]	 ; BL = Text Byte
  inc	   rax		 ; Pointer To Command-Line String++
  cmp	   bl,' '	 ; Compare Text Byte (BL) To Space " " Character
  jnz	   LoopCMD_START ; IF (Text Byte != $20) Loop
  inc	   rax		 ; Pointer To Command-Line String++
  mov	   rdx,rax	 ; RAX,RDX = Pointer To Command-Line String (Strip 1st Command-Line String Parameter)

  ; Find End Of Command-Line String Parameter (ROM File)
  ; 1st Double Quote Check
  mov	   bl,[rax]    ; BL = Text Byte
  cmp	   bl,'"'      ; Compare Text Byte (BL) To Double Quote  '"' Character
  jnz	   LoopCMD_END ; IF (Text Byte != Double Quote Character) End
  inc	   rax	       ; Pointer To Command-Line String++
  inc	   rdx	       ; Pointer To Command-Line String++
  LoopCMD_END:
  ; 2nd Double Quote Check
  mov	   bl,[rax]    ; BL = Text Byte
  cmp	   bl,'"'      ; Compare Text Byte (BL) To Double Quote  '"' Character
  jnz	   LoopCMD_END_DOUBLE_QUOTE ; IF (Text Byte != Double Quote Character) End
  mov	   bl,$00      ; ELSE Replace Double Quote Character With Zero Byte
  mov	   [rax],bl    ; Pointer To Command-Line String = BL
  LoopCMD_END_DOUBLE_QUOTE:
  ; Zero Byte Check
  inc	   rax	       ; Pointer To Command-Line String++
  cmp	   bl,$00      ; Compare Text Byte (BL) To Zero
  jnz	   LoopCMD_END ; IF (Text Byte != $00) Loop
  mov	   rdi,rdx     ; RDX,RDI = Pointer To Command-Line String (Strip 1st Command-Line String Parameter)
  cinvoke  printf,<'%s'>

  ; Check Command-Line String Parameter ROM File
  invoke   GetFileAttributes,rdi ; EAX = FILE_ATTRIBUTES
  cmp	   eax,-1 ; Compare EAX To INVALID_FILE_ATTRIBUTES
  jne	   ROM_Found ; IF (EAX != INVALID_FILE_ATTRIBUTES) ROM Found
  ; ELSE Print Error/Usage & Quit
  ; Print Error
  invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY+BACKGROUND_RED ; HANDLE, Console Text Attribute
  cinvoke  printf,<10,'ERROR:     '>
  invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY+BACKGROUND_RED+BACKGROUND_INTENSITY ; HANDLE, Console Text Attribute
  cinvoke  printf,<'ROM FILE NOT FOUND'>
  ; Print Usage
  invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY+BACKGROUND_BLUE+BACKGROUND_GREEN ; HANDLE, Console Text Attribute
  cinvoke  printf,<10,'USAGE:     '>
  invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY+BACKGROUND_BLUE+BACKGROUND_INTENSITY ; HANDLE, Console Text Attribute
  cinvoke  printf,<'N64EMU.EXE ROM.N64'>
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
    cinvoke  printf,<10,'ROM TITLE: '>
    invoke   SetConsoleTextAttribute,[hcn],BACKGROUND_BLUE+BACKGROUND_GREEN+BACKGROUND_RED+BACKGROUND_INTENSITY ; HANDLE, Console Text Attribute
    mov      rdx,CART_DOM1_ADDR2+32
    add      rdx,[MEM_MAP] ; RDX = ROM Address
    cinvoke  printf,<'%27s'>

    invoke   SetConsoleTextAttribute,[hcn],BACKGROUND_BLUE+BACKGROUND_GREEN+BACKGROUND_RED ; HANDLE, Console Text Attribute
    cinvoke  printf,<10,'ROM START: '>
    invoke   SetConsoleTextAttribute,[hcn],BACKGROUND_BLUE+BACKGROUND_GREEN+BACKGROUND_RED+BACKGROUND_INTENSITY ; HANDLE, Console Text Attribute
    mov      rdx,[MEM_MAP]
    mov      edx,[rdx+CART_DOM1_ADDR2+8] ; EDX = ROM Data (Little-Endian 32-Bit)
    bswap    edx
    cinvoke  printf,<'$%08X'>

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
    include 'vi.asm'  ; Run Video Interface
    ret
  .wmkeydown:
    cmp      r8d,VK_ESCAPE
    jne      .defwndproc
  .wmdestroy:
    invoke   wglMakeCurrent,0,0
    invoke   wglDeleteContext,[hrc]
    invoke   ReleaseDC,[hwnd],[hdc]
    invoke   PostQuitMessage,0

if DEBUG
    include 'debug.asm' ; Debug Console Printing
end if

    ; Reset Console Text Attribute
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_GREEN+FOREGROUND_RED ; HANDLE, Console Text Attribute
    xor      eax,eax
    ret
endp

include 'cpu.asm' ; CPU Instruction Emulation
include 'cp1.asm' ; CP1 Instruction Emulation (Coprocessor 1: FPU)

section '.data' data readable writeable

  _title db 'N64 Emulator: VI Output',0
  _class db 'FASMN64EMU',0

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
  CPU_R0 dq 0 ; CPU Register R0/R0
  CPU_AT dq 0 ; CPU Register R1/AT
  CPU_V0 dq 0 ; CPU Register R2/V0
  CPU_V1 dq 0 ; CPU Register R3/V1
  CPU_A0 dq 0 ; CPU Register R4/A0
  CPU_A1 dq 0 ; CPU Register R5/A1
  CPU_A2 dq 0 ; CPU Register R6/A2
  CPU_A3 dq 0 ; CPU Register R7/A3
  CPU_T0 dq 0 ; CPU Register R8/T0
  CPU_T1 dq 0 ; CPU Register R9/T1
  CPU_T2 dq 0 ; CPU Register R10/T2
  CPU_T3 dq 0 ; CPU Register R11/T3
  CPU_T4 dq 0 ; CPU Register R12/T4
  CPU_T5 dq 0 ; CPU Register R13/T5
  CPU_T6 dq 0 ; CPU Register R14/T6
  CPU_T7 dq 0 ; CPU Register R15/T7
  CPU_S0 dq 0 ; CPU Register R16/S0
  CPU_S1 dq 0 ; CPU Register R17/S1
  CPU_S2 dq 0 ; CPU Register R18/S2
  CPU_S3 dq 0 ; CPU Register R19/S3
  CPU_S4 dq 0 ; CPU Register R20/S4
  CPU_S5 dq 0 ; CPU Register R21/S5
  CPU_S6 dq 0 ; CPU Register R22/S6
  CPU_S7 dq 0 ; CPU Register R23/S7
  CPU_T8 dq 0 ; CPU Register R24/T8
  CPU_T9 dq 0 ; CPU Register R25/T9
  CPU_K0 dq 0 ; CPU Register R26/K0
  CPU_K1 dq 0 ; CPU Register R27/K1
  CPU_GP dq 0 ; CPU Register R28/GP
  CPU_SP dq 0 ; CPU Register R29/SP
  CPU_S8 dq 0 ; CPU Register R30/S8
  CPU_RA dq 0 ; CPU Register R31/RA
  CPU_LO dq 0 ; CPU Register LO
  CPU_HI dq 0 ; CPU Register HI

  ; CPU System Registers (Coprocessor 0)
  CP0_Index    dd 0 ; CP0 Register R0/Index
  CP0_Random   dd 0 ; CP0 Register R1/Random
  CP0_EntryLo0 dd 0 ; CP0 Register R2/EntryLo0
  CP0_EntryLo1 dd 0 ; CP0 Register R3/EntryLo1
  CP0_Context  dd 0 ; CP0 Register R4/Context
  CP0_PageMask dd 0 ; CP0 Register R5/PageMask
  CP0_Wired    dd 0 ; CP0 Register R6/Wired
  CP0_R7       dd 0 ; CP0 Register R7/*RESERVED*
  CP0_BadVAddr dd 0 ; CP0 Register R8/BadVAddr
  CP0_Count    dd 0 ; CP0 Register R9/Count
  CP0_EntryHi  dd 0 ; CP0 Register R10/EntryHi
  CP0_Compare  dd 0 ; CP0 Register R11/Compare
  CP0_Status   dd 0 ; CP0 Register R12/Status
  CP0_Cause    dd 0 ; CP0 Register R13/Cause
  CP0_EPC      dd 0 ; CP0 Register R14/EPC
  CP0_PRevID   dd 0 ; CP0 Register R15/PRevID
  CP0_Config   dd 0 ; CP0 Register R16/Config
  CP0_LLAddr   dd 0 ; CP0 Register R17/LLAddr
  CP0_WatchLo  dd 0 ; CP0 Register R18/WatchLo
  CP0_WatchHi  dd 0 ; CP0 Register R19/WatchHi
  CP0_XContext dd 0 ; CP0 Register R20/XContext
  CP0_R21      dd 0 ; CP0 Register R21/*RESERVED*
  CP0_R22      dd 0 ; CP0 Register R22/*RESERVED*
  CP0_R23      dd 0 ; CP0 Register R23/*RESERVED*
  CP0_R24      dd 0 ; CP0 Register R24/*RESERVED*
  CP0_R25      dd 0 ; CP0 Register R25/*RESERVED*
  CP0_PErr     dd 0 ; CP0 Register R26/PErr
  CP0_CacheErr dd 0 ; CP0 Register R27/CacheErr
  CP0_TagLo    dd 0 ; CP0 Register R28/TagLo
  CP0_TagHi    dd 0 ; CP0 Register R29/TagHi
  CP0_ErrorEPC dd 0 ; CP0 Register R30/ErrorEPC
  CP0_R31      dd 0 ; CP0 Register R31/*RESERVED*

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
  CP1_FD  dq 0 ; CP1 Floating Point Double Convert
  CP1_FP  db 0 ; CP1 Floating Point Condition Code (Boolean)

section '.idata' import data readable writeable

  library kernel32,'KERNEL32.DLL',\
	  user32,'USER32.DLL',\
	  gdi32,'GDI32.DLL',\
	  opengl32,'OPENGL32.DLL',\
	  msvcrt,'MSVCRT.DLL'

  import  msvcrt,printf,'printf'

  include 'api/kernel32.inc'
  include 'api/user32.inc'
  include 'api/gdi32.inc'
  include 'api/opengl32.inc'