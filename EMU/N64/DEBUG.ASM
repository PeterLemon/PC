; Debug End Console Printing
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CPU_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'PC: ',4,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CPU_PC ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,4 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,9,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CPU_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'R0: ',4,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CPU_R0 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CPU_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'AT: ',4,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CPU_AT ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CPU_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'V0: ',4,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CPU_V0 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CPU_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'V1: ',4,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CPU_V1 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CPU_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'A0: ',4,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CPU_A0 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CPU_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'A1: ',4,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CPU_A1 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CPU_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'A2: ',4,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CPU_A2 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CPU_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'A3: ',4,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CPU_A3 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CPU_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'T0: ',4,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CPU_T0 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CPU_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'T1: ',4,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CPU_T1 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CPU_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'T2: ',4,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CPU_T2 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CPU_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'T3: ',4,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CPU_T3 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CPU_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'T4: ',4,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CPU_T4 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CPU_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'T6: ',4,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CPU_T5 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CPU_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'T6: ',4,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CPU_T6 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CPU_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'T7: ',4,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CPU_T7 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CPU_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'S0: ',4,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CPU_S0 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CPU_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'S1: ',4,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CPU_S1 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CPU_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'S2: ',4,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CPU_S2 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CPU_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'S3: ',4,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CPU_S3 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CPU_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'S4: ',4,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CPU_S4 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CPU_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'S5: ',4,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CPU_S5 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CPU_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'S6: ',4,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CPU_S6 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CPU_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'S7: ',4,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CPU_S7 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CPU_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'T8: ',4,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CPU_T8 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CPU_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'T9: ',4,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CPU_T9 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CPU_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'K0: ',4,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CPU_K0 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CPU_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'K1: ',4,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CPU_K1 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CPU_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'GP: ',4,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CPU_GP ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CPU_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'SP: ',4,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CPU_SP ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CPU_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'S8: ',4,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CPU_S8 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CPU_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'RA: ',4,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CPU_RA ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CPU_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'LO: ',4,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CPU_LO ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CPU_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'HI: ',4,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CPU_HI ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped


    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CP1_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'F0 : ',5,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CP1_F0 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CP1_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'F1 : ',5,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CP1_F1 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CP1_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'F2 : ',5,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CP1_F2 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CP1_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'F3 : ',5,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CP1_F3 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CP1_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'F4 : ',5,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CP1_F4 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CP1_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'F5 : ',5,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CP1_F5 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CP1_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'F6 : ',5,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CP1_F6 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CP1_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'F7 : ',5,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CP1_F7 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CP1_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'F8 : ',5,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CP1_F8 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CP1_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'F9 : ',5,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CP1_F9 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CP1_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'F10: ',5,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CP1_F10 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CP1_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'F11: ',5,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CP1_F11 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CP1_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'F12: ',5,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CP1_F12 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CP1_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'F13: ',5,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CP1_F13 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CP1_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'F14: ',5,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CP1_F14 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CP1_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'F15: ',5,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CP1_F15 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CP1_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'F16: ',5,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CP1_F16 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CP1_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'F17: ',5,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CP1_F17 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CP1_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'F18: ',5,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CP1_F18 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CP1_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'F19: ',5,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CP1_F19 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CP1_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'F20: ',5,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CP1_F20 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CP1_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'F21: ',5,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CP1_F21 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CP1_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'F22: ',5,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CP1_F22 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CP1_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'F23: ',5,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CP1_F23 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CP1_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'F24: ',5,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CP1_F24 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CP1_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'F25: ',5,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CP1_F25 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CP1_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'F26: ',5,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CP1_F26 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CP1_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'F27: ',5,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CP1_F27 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CP1_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'F28: ',5,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CP1_F28 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CP1_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'F29: ',5,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CP1_F29 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CP1_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'F30: ',5,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CP1_F30 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CP1_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'F31: ',5,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CP1_F31 ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,8 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,17,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped

    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_BLUE+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],CP1_Register,16,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    invoke   WriteFile,[hcn],'FP : ',5,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped
    mov      rax,CP1_FP ; RAX = Value Address
    mov      rbx,NUMTEXT ; RBX = Text Buffer
    mov      cx,1 ; CX = Loop Count
    call     NUM2STRLE
    invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
    invoke   WriteFile,[hcn],HEXTEXT,3,0,0 ; HANDLE, Buffer, Number Of Bytes To Write, Number Of Bytes Written, Overlapped