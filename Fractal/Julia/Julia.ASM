; Keyboard Controls:
; Escape Key = Quit

; Mouse Controls:
; Move Pointer = Change Julia Shape

format PE64 GUI 5.0
entry start

include 'win64a.inc'
include 'ddraw64.inc'

ScreenX = 640 ; Screen X Resolution
ScreenY = 480 ; Screen Y Resolution
BPP = 4       ; Bytes Per Pixel

section '.text' code readable executable

start:
  sub rsp,8

  invoke   GetModuleHandle,NULL
  mov	   [hinstance],rax
  mov	   [wc.hInstance],rax

  invoke   LoadIcon,NULL,IDI_APPLICATION
  mov	   [wc.hIcon],rax
  invoke   LoadCursor,NULL,IDC_ARROW
  mov	   [wc.hCursor],rax
  invoke   RegisterClassEx,wc

  invoke   CreateWindowEx,0,_class,_title,WS_POPUP+WS_VISIBLE,0,0,0,0,NULL,NULL,[hinstance],NULL

  mov	   [hwnd],rax

  invoke   DirectDrawCreate,NULL,DDraw,NULL

  cominvk  DDraw,SetCooperativeLevel,[hwnd],DDSCL_EXCLUSIVE+DDSCL_FULLSCREEN

  cominvk  DDraw,SetDisplayMode,ScreenX,ScreenY,BPP*8

  mov	   [ddsd.dwSize],sizeof.DDSURFACEDESC
  mov	   [ddsd.ddsCaps.dwCaps],DDSCAPS_PRIMARYSURFACE
  cominvk  DDraw,CreateSurface,ddsd,DDSPrimary,NULL

  ; Boost Process Priority Class
  invoke   GetCurrentProcess
  invoke   SetPriorityClass, rax, REALTIME_PRIORITY_CLASS

  mov	   r8,ScreenX
  cvtsi2sd xmm0,r8
  movsd    [SX],xmm0

  mov	   r8,ScreenY
  cvtsi2sd xmm0,r8
  movsd    [SY],xmm0

refresh:
  invoke   GetCursorPos,curs ; Get Mouse Position

  mov	   ecx,[curs.x] ; Get Mouse X
  mov	   edx,[curs.y] ; Get Mouse Y

  cvtsi2sd xmm0,rcx ; Store Mouse X To XMM0
  cvtsi2sd xmm1,rdx ; Store Mouse Y To XMM1

  movlhps  xmm0,xmm1 ; Move XMM0 Low Quad To XMM0 High Quad

  movapd   xmm1,[XYMax] ; MX = XMin + ((X% * (XMax - XMin)) / SX)
  subpd    xmm1,[XYMin] ; MY = YMin + ((Y% * (YMax - YMin)) / SY)
  mulpd    xmm1,xmm0
  divpd    xmm1,[SXY]
  addpd    xmm1,[XYMin] ; XMM1 = MXY

  movapd   [CXY],xmm1 ; Store CXY


  cominvk  DDSPrimary,Lock,NULL,ddsd,DDLOCK_SURFACEMEMORYPTR,NULL ; Lock DDraw Surface Before Plotting Pixels

  mov	   r9,ScreenY ; Reset Screen Y Position

  mov	   rax,[ddsd.lpSurface] ; Load Surface Start Position To RAX
  mov	   ebx,[ddsd.lPitch]	; Load Surface Pitch (Y) To RBX
  imul	   rbx,r9		; Multiply Pitch By R9 (Screen Y Position)
  add	   rax,rbx		; Add Pitch To Surface Start Position
  sub	   rax,BPP		; Add Last Screen X Pixel Position

  mov	   rbx,[ddsd.lpSurface] ; Load Surface Start Position To RAX

  LoopY:
    mov      r8,ScreenX ; Reset Screen X Position
    cvtsi2sd xmm0,r9	; Load Y Screen Position To XMM0
    movlhps  xmm0,xmm0	; Move XMM0 Low Quad To XMM0 High Quad

    LoopX:
      cvtsi2sd xmm0,r8 ; Load X Screen Position To XMM0

      movapd   xmm1,[XYMax] ; ZX = XMin + ((X% * (XMax - XMin)) / SX)
      subpd    xmm1,[XYMin] ; ZY = YMin + ((Y% * (YMax - YMin)) / SY)
      mulpd    xmm1,xmm0
      divpd    xmm1,[SXY]
      addpd    xmm1,[XYMin] ; XMM1 = ZXY

      mov      ecx,[Iterations] ; Reset ECX (IT) To 192
      movapd   xmm2,[CXY] ; Reset XMM2 (CXY)

      Iterate:
	movapd	 xmm3,xmm1 ; XMM3 = ZXY
	movhlps  xmm4,xmm1 ; Move XMM1 High Quad To XMM4 Low Quad
	movlhps  xmm4,xmm1 ; Move XMM1 Low Quad To XMM4 High Quad (XMM4 = ZYX)

	mulpd	 xmm1,xmm1	     ; XN = ((ZX * ZX) - (ZY * ZY)) + CX
	hsubpd	 xmm1,xmm1	     ; XMM2 = (ZX * ZX) - (ZY * ZY)
	dppd	 xmm3,xmm4,00110001b ; YN = (2 * ZX * ZY) + CY
	movlhps  xmm1,xmm3	     ; Move XMM3 Low Quad To XMM1 High Quad
	addpd	 xmm1,xmm2	     ; XMM1 = XNYN

	movapd	 xmm3,xmm1 ; Preserve XMM1 For Next Iteration

	dppd	 xmm3,xmm3,00110001b ; R = (XN * XN) + (YN * YN)

	comisd	 xmm3,[RMax] ; IF (R > 4) Plot
	ja	 Plot

	loopne	 Iterate ; IF (IT% != 0) Iterate (IT% = IT% - 1)

	Plot:
	  imul	   ecx,0x231AF9 ; Set Color In ECX
	  if BPP = 4
	    mov      [rax],ecx ; Store 32-Bit Pixel Color In ECX To DDraw Bottom Scanline VRAM Area
	    mov      [rbx],ecx ; Store 32-Bit Pixel Color In ECX To DDraw Top Scanline VRAM Area
	  end if
	  if BPP = 2
	    mov      [rax],cx ; Store 16-Bit Pixel Color In CX To DDraw Bottom Scanline VRAM Area
	    mov      [rbx],cx ; Store 16-Bit Pixel Color In CX To DDraw Top Scanline VRAM Area
	  end if
	  sub	   rax,BPP ; Subtract BPP Size From Bottom Half Of Video Memory
	  add	   rbx,BPP ; Adds BPP Size To Top Half Of Video Memory

	  dec	   r8
	  jg	   LoopX ; IF (X Screen Position > 0) LoopX
	  dec	   r9
	  cmp	   r9,ScreenY/2 ; Compare Scanline Position To Middle Of Screen
	  jne	   LoopY ; IF (Scanline Screen Position Is In The Middle) Finish

  cominvk  DDSPrimary,Unlock,NULL ; Unlock DDraw Surface After Plotting Pixels

main_loop:
  invoke   PeekMessage,msg,NULL,0,0,PM_NOREMOVE
  or	   rax,rax
  jz	   refresh
  invoke   GetMessage,msg,NULL,0,0
  cmp	   rax,1
  jb	   end_loop
  jne	   main_loop
  invoke   TranslateMessage,msg
  invoke   DispatchMessage,msg
  jmp	   main_loop

end_loop:
  invoke   ExitProcess,[msg.wParam]

proc WindowProc uses rbx rsi rdi, hwnd,wmsg,wparam,lparam
  cmp	   rdx,WM_DESTROY
  je	   .wmdestroy
  cmp	   rdx,WM_KEYDOWN
  je	   .wmkeydown
  .defwindowproc:
    invoke   DefWindowProc,rcx,rdx,r8,r9
    ret
  .wmkeydown:
    cmp      r8d,VK_UP
    jne      .endUP
    inc      [Iterations]
    jmp      refresh
  .endUP:
    cmp      r8d,VK_DOWN
    jne      .endDOWN
    dec      [Iterations]
    jmp      refresh
  .endDOWN:
    cmp      r8d,VK_ESCAPE
    jne      .defwindowproc
  .wmdestroy:
    cominvk  DDraw,RestoreDisplayMode
    cominvk  DDraw,Release
    invoke   PostQuitMessage,0
    xor      eax,eax
    ret
endp

section '.data' data readable writeable

  wc WNDCLASSEX sizeof.WNDCLASSEX,0,WindowProc,0,0,NULL,NULL,NULL,NULL,NULL,_class,NULL

  _title db 'flat assembler DirectDraw application',0
  _class db 'FDDRAW64',0

  align 16 ; SSE Data
  label SXY dqword
   SX dq 0.0
   SY dq 0.0
  label XYMax dqword
   XMax dq 2.7
   YMax dq 1.8
  label XYMin dqword
   XMin dq -2.7
   YMin dq -1.8
  label CXY dqword
   CXFloat dq 1.0
   CYFloat dq -2.0
  Anim dq 0.001
  RMax dq 4.0 ; SSE Data End

  Iterations dd 192
  curs POINT ; Mouse Coordinate

section '.bss' readable writeable

  hinstance dq ?
  hwnd dq ?
  msg MSG

  ddsd DDSURFACEDESC

  DDraw DirectDraw
  DDSPrimary DirectDrawSurface

section '.idata' import data readable

  library kernel32,'KERNEL32.DLL',user32,'USER32.DLL',ddraw,'DDRAW.DLL'

  include 'api\kernel32.inc'
  include 'api\user32.inc'

  import ddraw,DirectDrawCreate,'DirectDrawCreate'