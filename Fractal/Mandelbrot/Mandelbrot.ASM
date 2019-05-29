; Keyboard Controls:
; Escape Key = Quit

; Mouse Controls:
; Left Click = Zoom In
; Right Click = Zoom Out
; Move Pointer = Zoom In/Out Center

format PE64 GUI 5.0
entry start

include 'win64a.inc'
include 'ddraw64.inc'

ScreenX = 640 ; Screen X Resolution
ScreenY = 480 ; Screen Y Resolution
BPP = 4       ; Bytes Per Pixel

section '.text' code readable executable

start:
  sub      rsp,8

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
  cominvk  DDSPrimary,Lock,NULL,ddsd,DDLOCK_SURFACEMEMORYPTR,NULL ; Lock DDraw Surface Before Plotting Pixels

  mov	   r9,ScreenY ; Reset Screen Y Position

  mov	   rax,[ddsd.lpSurface] ; Load Surface Start Position To RAX
  mov	   ebx,[ddsd.lPitch]	; Load Surface Pitch (Y) To RBX
  imul	   rbx,r9		; Multiply Pitch By R9 (Screen Y Position)
  add	   rax,rbx		; Add Pitch To Surface Start Position
  sub	   rax,BPP		; Add Last Screen X Pixel Position

  LoopY:
    mov      r8,ScreenX ; Reset Screen X Position

    cvtsi2sd xmm0,r9   ; Load Y Screen Position To XMM0
    movlhps  xmm0,xmm0 ; Move XMM0 Low Quad To XMM0 High Quad

    LoopX:
      cvtsi2sd xmm0,r8 ; Load The X Screen Position To XMM0 Low Quad

      movapd   xmm1,[XYMax] ; CX = XMin + ((X% * (XMax - XMin)) / SX)
      subpd    xmm1,[XYMin] ; CY = YMin + ((Y% * (YMax - YMin)) / SY)
      mulpd    xmm1,xmm0
      divpd    xmm1,[SXY]
      addpd    xmm1,[XYMin] ; XMM1 = CXY

      mov      ecx,[Iterations] ; Reset ECX (IT) To 192
      subpd    xmm2,xmm2	; Reset XMM2 (ZXY) to 0.0

      Iterate:
	movapd	 xmm3,xmm2 ; XMM3 = ZXY
	movhlps  xmm4,xmm2 ; Move XMM2 High Quad To XMM4 Low Quad
	movlhps  xmm4,xmm2 ; Move XMM2 Low Quad To XMM4 High Quad (XMM4 = ZYX)

	mulpd	 xmm2,xmm2	     ; XN = ((ZX * ZX) - (ZY * ZY)) + CX
	hsubpd	 xmm2,xmm2	     ; XMM2 = (ZX * ZX) - (ZY * ZY)
	dppd	 xmm3,xmm4,00110001b ; YN = (2 * ZX * ZY) + CY
	movlhps  xmm2,xmm3	     ; Move XMM3 Low Quad To XMM2 High Quad
	addpd	 xmm2,xmm1	     ; XMM2 = XNYN

	movapd	 xmm3,xmm2 ; Preserve XMM2 For Next Iteration

	dppd	 xmm3,xmm3,00110001b ; R = (XN * XN) + (YN * YN)

	comisd	 xmm3,[RMax] ; IF (R > 4) Plot
	ja	 Plot

	loopne	 Iterate ; IF (IT% != 0) Iterate (IT% = IT% - 1)

	Plot:
	  imul	   ecx,0x231AF9 ; Set Color In ECX
	  mov	   [rax],ecx	; Store Pixel Color In ECX To DDraw VRAM Area
	  sub	   rax,BPP	; Subtract BPP Size From Video Memory

	  dec	   r8
	  jg	   LoopX ; IF (X Screen Position > 0) LoopX
	  dec	   r9
	  jg	   LoopY ; IF (Y Screen Position == 0) Finish

  cominvk  DDSPrimary,Unlock,NULL ; Unlock DDraw Surface After Plotting Pixels

main_loop:
  invoke   PeekMessage,msg,NULL,0,0,PM_NOREMOVE
  or	   rax,rax
  jz	   main_loop
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
  cmp	   rdx,WM_LBUTTONDOWN
  je	   .wmlbuttondown
  cmp	   rdx,WM_RBUTTONDOWN
  je	   .wmrbuttondown
  cmp	   rdx,WM_KEYDOWN
  je	   .wmkeydown
  .defwindowproc:
    invoke   DefWindowProc,rcx,rdx,r8,r9
    ret
  .wmlbuttondown:
    movzx    eax,r9w   ; Get Mouse X
    cvtsi2sd xmm0,eax
    shr      r9,16
    movzx    eax,r9w
    cvtsi2sd xmm1,eax  ; Get Mouse Y
    movlhps  xmm0,xmm1 ; Move XMM0 Low Quad To XMM0 High Quad

    movapd   xmm1,[XYMax] ; MX = XMin + ((X% * (XMax - XMin)) / SX)
    subpd    xmm1,[XYMin] ; MY = YMin + ((Y% * (YMax - YMin)) / SY)
    mulpd    xmm1,xmm0
    divpd    xmm1,[SXY]
    addpd    xmm1,[XYMin] ; XMM1 = MXY

    movapd   xmm0,[XYMin]
    subpd    xmm0,xmm1	   ; XMM0 = XYMin - MXY
    mulpd    xmm0,[XYZoom] ; XMM0 = (XYMin - MXY) * XYZoom
    addpd    xmm0,xmm1	   ; XMM0 = MXY + ((XYMin - MXY) * XYZoom)
    movapd   [XYMin],xmm0  ; Store XYMin

    movapd   xmm0,[XYMax]
    subpd    xmm0,xmm1	   ; XMM0 = XYMax - MXY
    mulpd    xmm0,[XYZoom] ; XMM0 = (XYMax - MXY) * XYZoom
    addpd    xmm0,xmm1	   ; XMM0 = MXY + ((XYMax - MXY) * XYZoom)
    movapd   [XYMax],xmm0  ; Store XYMax
    jmp      refresh

  .wmrbuttondown:
    movzx    eax,r9w
    cvtsi2sd xmm0,eax  ; Get Mouse X
    shr      r9,16
    movzx    eax,r9w
    cvtsi2sd xmm1,eax  ; Get Mouse Y
    movlhps  xmm0,xmm1 ; Move XMM1 Low Quad To XMM0 High Quad

    movapd   xmm1,[XYMax] ; MX = XMin + ((X% * (XMax - XMin)) / SX)
    subpd    xmm1,[XYMin] ; MY = YMin + ((Y% * (YMax - YMin)) / SY)
    mulpd    xmm1,xmm0
    divpd    xmm1,[SXY]
    addpd    xmm1,[XYMin] ; XMM1 = MXY

    movapd   xmm0,[XYMin]
    subpd    xmm0,xmm1	   ; XMM0 = XYMin - MXY
    divpd    xmm0,[XYZoom] ; XMM0 = (XYMin - MXY) / XYZoom
    addpd    xmm0,xmm1	   ; XMM0 = MXY + ((XYMin - MXY) / XYZoom)
    movapd   [XYMin],xmm0  ; Store XYMin

    movapd   xmm0,[XYMax]
    subpd    xmm0,xmm1	   ; XMM0 = XYMax - MXY
    divpd    xmm0,[XYZoom] ; XMM0 = (XYMax - MXY) / XYZoom
    addpd    xmm0,xmm1	   ; XMM0 = MXY + ((XYMax - MXY) / XYZoom)
    movapd   [XYMax],xmm0  ; Store XYMax
    jmp      refresh

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
    XMax dq 0.85
    YMax dq 1.2
  label XYMin dqword
    XMin dq -2.15
    YMin dq -1.2
  label XYZoom dqword
    XZoom dq 0.5 ; X Zoom Value
    YZoom dq 0.5 ; Y Zoom Value
  RMax dq 4.0 ; SSE Data End

  Iterations dd 192

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