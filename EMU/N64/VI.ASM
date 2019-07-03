; VI Width
mov	 rbx,[MEM_MAP] ; RBX = MEM_MAP Address
mov	 al,[rbx+VI_WIDTH+3]
mov	 ah,[rbx+VI_WIDTH+2] ; AX = VI: Width Register Halfword (LSH)
movzx	 r9,ax ; R9 = OpenGL Width

; VI Height
mov	 al,[rbx+VI_Y_SCALE+3] ; Height = (VI_Y_SCALE * 60) / 256
mov	 ah,[rbx+VI_Y_SCALE+2] ; AX = VI: Y-Scale Register Halfword (LSH)
movzx	 eax,ax ; Zero-Extend 16-Bit Result
mov	 ecx,60 ; ECX = 60
mul	 ecx	; EAX *= ECX
shr	 eax,8	; EAX /= 256
movzx	 r10,ax ; R10 = OpenGL Height

; VI Origin (Frame Buffer Start Address)
mov	 al,[rbx+VI_ORIGIN+1] ; Convert Video Interface (VI) Base Register Address Word To Little Endian
mov	 ah,[rbx+VI_ORIGIN+0]
shl	 eax,16
mov	 al,[rbx+VI_ORIGIN+3]
mov	 ah,[rbx+VI_ORIGIN+2] ; EAX = VI Origin Register Word (32-Bit)
and	 rax,$1FFFFFFF ; RAX &= MEM_MAP Mask
add	 rax,rbx ; RAX = OpenGL Texture Address

; VI Color Depth
mov	 bl,[rbx+VI_STATUS+3] ; BL = VI Status/Control Register Byte (LSB)
and	 bl,7 ; BL = VI Status/Control: Color Depth (3 Bits)
cmp	 bl,2 ; IF (VI Status/Control: Color Depth == 2) Color Depth = 16-BPP
je	 .VI_16BPP ; ELSE Color Depth = 32-BPP
mov	 ebx,GL_UNSIGNED_BYTE ; EBX = OpenGL Color Depth 32-BPP Attribute
jmp	 .VI_BPP_END
.VI_16BPP:
mov	 ebx,GL_UNSIGNED_SHORT_5_5_5_1 ; EBX = OpenGL Color Depth 16-BPP Attribute
.VI_BPP_END:

invoke	 glTexImage2D,GL_TEXTURE_2D,0,GL_RGBA,r9,r10,0,GL_RGBA,ebx,rax

invoke	 glTexImage2D,GL_TEXTURE_2D,0,GL_RGBA,r9,r10,0,GL_RGBA,GL_UNSIGNED_SHORT_5_5_5_1,[MEM_MAP]

invoke	 glClear,GL_COLOR_BUFFER_BIT
invoke	 glBegin,GL_QUADS
invoke	 glTexCoord2f,float dword 0.0,float dword 1.0
invoke	 glVertex3d,float -1.0,float -1.0,float 0.0
invoke	 glTexCoord2f,float dword 1.0,float dword 1.0
invoke	 glVertex3d,float 1.0,float -1.0,float 0.0
invoke	 glTexCoord2f,float dword 1.0,float dword 0.0
invoke	 glVertex3d,float 1.0,float 1.0,float 0.0
invoke	 glTexCoord2f,float dword 0.0,float dword 0.0
invoke	 glVertex3d,float -1.0,float 1.0,float 0.0
invoke	 glEnd
invoke	 SwapBuffers,[hdc]