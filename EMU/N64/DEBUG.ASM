
; Debug End Console Printing
  invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
  cinvoke  printf,<10,10,'CPU Registers:',10>

  invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_RED+FOREGROUND_GREEN+FOREGROUND_BLUE ; HANDLE, Console Text Attribute
  cinvoke  printf,<'PC: $%08X',10>,[CPU_PC]

  cinvoke  printf,<'AT: $%016llX',10>,[CPU_AT]
  cinvoke  printf,<'V0: $%016llX',10>,[CPU_V0]
  cinvoke  printf,<'V1: $%016llX',10>,[CPU_V1]
  cinvoke  printf,<'A0: $%016llX',10>,[CPU_A0]
  cinvoke  printf,<'A1: $%016llX',10>,[CPU_A1]
  cinvoke  printf,<'A2: $%016llX',10>,[CPU_A2]
  cinvoke  printf,<'A3: $%016llX',10>,[CPU_A3]
  cinvoke  printf,<'T0: $%016llX',10>,[CPU_T0]
  cinvoke  printf,<'T1: $%016llX',10>,[CPU_T1]
  cinvoke  printf,<'T2: $%016llX',10>,[CPU_T2]
  cinvoke  printf,<'T3: $%016llX',10>,[CPU_T3]
  cinvoke  printf,<'T4: $%016llX',10>,[CPU_T4]
  cinvoke  printf,<'T5: $%016llX',10>,[CPU_T5]
  cinvoke  printf,<'T6: $%016llX',10>,[CPU_T6]
  cinvoke  printf,<'T7: $%016llX',10>,[CPU_T7]
  cinvoke  printf,<'S0: $%016llX',10>,[CPU_S0]
  cinvoke  printf,<'S1: $%016llX',10>,[CPU_S1]
  cinvoke  printf,<'S2: $%016llX',10>,[CPU_S2]
  cinvoke  printf,<'S3: $%016llX',10>,[CPU_S3]
  cinvoke  printf,<'S4: $%016llX',10>,[CPU_S4]
  cinvoke  printf,<'S5: $%016llX',10>,[CPU_S5]
  cinvoke  printf,<'S6: $%016llX',10>,[CPU_S6]
  cinvoke  printf,<'S7: $%016llX',10>,[CPU_S7]
  cinvoke  printf,<'T8: $%016llX',10>,[CPU_T8]
  cinvoke  printf,<'T9: $%016llX',10>,[CPU_T9]
  cinvoke  printf,<'K0: $%016llX',10>,[CPU_K0]
  cinvoke  printf,<'K1: $%016llX',10>,[CPU_K1]
  cinvoke  printf,<'GP: $%016llX',10>,[CPU_GP]
  cinvoke  printf,<'SP: $%016llX',10>,[CPU_SP]
  cinvoke  printf,<'S8: $%016llX',10>,[CPU_S8]
  cinvoke  printf,<'RA: $%016llX',10>,[CPU_RA]
  cinvoke  printf,<'LO: $%016llX',10>,[CPU_LO]
  cinvoke  printf,<'HI: $%016llX',10>,[CPU_HI]

  invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_GREEN+FOREGROUND_RED+FOREGROUND_INTENSITY ; HANDLE, Console Text Attribute
  cinvoke  printf,<10,'CP1 Registers:',10>

  invoke   SetConsoleTextAttribute,[hcn],FOREGROUND_RED+FOREGROUND_GREEN+FOREGROUND_BLUE ; HANDLE, Console Text Attribute
  fld	   dword[CP1_F0]  ; ST(0) = [F0] (Single)
  fstp	   [CP1_FD]	  ; FD = ST(0) (Double)
  cinvoke  printf,<'F0:  $%016llX %.8f %.4f',10>,[CP1_F0],[CP1_F0],[CP1_FD]
  fld	   dword[CP1_F1]  ; ST(0) = [F1] (Single)
  fstp	   [CP1_FD]	  ; FD = ST(0) (Double)
  cinvoke  printf,<'F1:  $%016llX %.8f %.4f',10>,[CP1_F1],[CP1_F1],[CP1_FD]
  fld	   dword[CP1_F2]  ; ST(0) = [F2] (Single)
  fstp	   [CP1_FD]	  ; FD = ST(0) (Double)
  cinvoke  printf,<'F2:  $%016llX %.8f %.4f',10>,[CP1_F2],[CP1_F2],[CP1_FD]
  fld	   dword[CP1_F3]  ; ST(0) = [F3] (Single)
  fstp	   [CP1_FD]	  ; FD = ST(0) (Double)
  cinvoke  printf,<'F3:  $%016llX %.8f %.4f',10>,[CP1_F3],[CP1_F3],[CP1_FD]
  fld	   dword[CP1_F4]  ; ST(0) = [F4] (Single)
  fstp	   [CP1_FD]	  ; FD = ST(0) (Double)
  cinvoke  printf,<'F4:  $%016llX %.8f %.4f',10>,[CP1_F4],[CP1_F4],[CP1_FD]
  fld	   dword[CP1_F5]  ; ST(0) = [F5] (Single)
  fstp	   [CP1_FD]	  ; FD = ST(0) (Double)
  cinvoke  printf,<'F5:  $%016llX %.8f %.4f',10>,[CP1_F5],[CP1_F5],[CP1_FD]
  fld	   dword[CP1_F6]  ; ST(0) = [F6] (Single)
  fstp	   [CP1_FD]	  ; FD = ST(0) (Double)
  cinvoke  printf,<'F6:  $%016llX %.8f %.4f',10>,[CP1_F6],[CP1_F6],[CP1_FD]
  fld	   dword[CP1_F7]  ; ST(0) = [F7] (Single)
  fstp	   [CP1_FD]	  ; FD = ST(0) (Double)
  cinvoke  printf,<'F7:  $%016llX %.8f %.4f',10>,[CP1_F7],[CP1_F7],[CP1_FD]
  fld	   dword[CP1_F8]  ; ST(0) = [F8] (Single)
  fstp	   [CP1_FD]	  ; FD = ST(0) (Double)
  cinvoke  printf,<'F8:  $%016llX %.8f %.4f',10>,[CP1_F8],[CP1_F8],[CP1_FD]
  fld	   dword[CP1_F9]  ; ST(0) = [F9] (Single)
  fstp	   [CP1_FD]	  ; FD = ST(0) (Double)
  cinvoke  printf,<'F9:  $%016llX %.8f %.4f',10>,[CP1_F9],[CP1_F9],[CP1_FD]
  fld	   dword[CP1_F10] ; ST(0) = [F10] (Single)
  fstp	   [CP1_FD]	  ; FD = ST(0) (Double)
  cinvoke  printf,<'F10: $%016llX %.8f %.4f',10>,[CP1_F10],[CP1_F10],[CP1_FD]
  fld	   dword[CP1_F11] ; ST(0) = [F11] (Single)
  fstp	   [CP1_FD]	  ; FD = ST(0) (Double)
  cinvoke  printf,<'F11: $%016llX %.8f %.4f',10>,[CP1_F11],[CP1_F11],[CP1_FD]
  fld	   dword[CP1_F12] ; ST(0) = [F12] (Single)
  fstp	   [CP1_FD]	  ; FD = ST(0) (Double)
  cinvoke  printf,<'F12: $%016llX %.8f %.4f',10>,[CP1_F12],[CP1_F12],[CP1_FD]
  fld	   dword[CP1_F13] ; ST(0) = [F13] (Single)
  fstp	   [CP1_FD]	  ; FD = ST(0) (Double)
  cinvoke  printf,<'F13: $%016llX %.8f %.4f',10>,[CP1_F13],[CP1_F13],[CP1_FD]
  fld	   dword[CP1_F14] ; ST(0) = [F14] (Single)
  fstp	   [CP1_FD]	  ; FD = ST(0) (Double)
  cinvoke  printf,<'F14: $%016llX %.8f %.4f',10>,[CP1_F14],[CP1_F14],[CP1_FD]
  fld	   dword[CP1_F15] ; ST(0) = [F15] (Single)
  fstp	   [CP1_FD]	  ; FD = ST(0) (Double)
  cinvoke  printf,<'F15: $%016llX %.8f %.4f',10>,[CP1_F15],[CP1_F15],[CP1_FD]
  fld	   dword[CP1_F16] ; ST(0) = [F16] (Single)
  fstp	   [CP1_FD]	  ; FD = ST(0) (Double)
  cinvoke  printf,<'F16: $%016llX %.8f %.4f',10>,[CP1_F16],[CP1_F16],[CP1_FD]
  fld	   dword[CP1_F17] ; ST(0) = [F17] (Single)
  fstp	   [CP1_FD]	  ; FD = ST(0) (Double)
  cinvoke  printf,<'F17: $%016llX %.8f %.4f',10>,[CP1_F17],[CP1_F17],[CP1_FD]
  fld	   dword[CP1_F18] ; ST(0) = [F18] (Single)
  fstp	   [CP1_FD]	  ; FD = ST(0) (Double)
  cinvoke  printf,<'F18: $%016llX %.8f %.4f',10>,[CP1_F18],[CP1_F18],[CP1_FD]
  fld	   dword[CP1_F19] ; ST(0) = [F19] (Single)
  fstp	   [CP1_FD]	  ; FD = ST(0) (Double)
  cinvoke  printf,<'F19: $%016llX %.8f %.4f',10>,[CP1_F19],[CP1_F19],[CP1_FD]
  fld	   dword[CP1_F20] ; ST(0) = [F20] (Single)
  fstp	   [CP1_FD]	  ; FD = ST(0) (Double)
  cinvoke  printf,<'F20: $%016llX %.8f %.4f',10>,[CP1_F20],[CP1_F20],[CP1_FD]
  fld	   dword[CP1_F21] ; ST(0) = [F21] (Single)
  fstp	   [CP1_FD]	  ; FD = ST(0) (Double)
  cinvoke  printf,<'F21: $%016llX %.8f %.4f',10>,[CP1_F21],[CP1_F21],[CP1_FD]
  fld	   dword[CP1_F22] ; ST(0) = [F22] (Single)
  fstp	   [CP1_FD]	  ; FD = ST(0) (Double)
  cinvoke  printf,<'F22: $%016llX %.8f %.4f',10>,[CP1_F22],[CP1_F22],[CP1_FD]
  fld	   dword[CP1_F23] ; ST(0) = [F23] (Single)
  fstp	   [CP1_FD]	  ; FD = ST(0) (Double)
  cinvoke  printf,<'F23: $%016llX %.8f %.4f',10>,[CP1_F23],[CP1_F23],[CP1_FD]
  fld	   dword[CP1_F24] ; ST(0) = [F24] (Single)
  fstp	   [CP1_FD]	  ; FD = ST(0) (Double)
  cinvoke  printf,<'F24: $%016llX %.8f %.4f',10>,[CP1_F24],[CP1_F24],[CP1_FD]
  fld	   dword[CP1_F25] ; ST(0) = [F25] (Single)
  fstp	   [CP1_FD]	  ; FD = ST(0) (Double)
  cinvoke  printf,<'F25: $%016llX %.8f %.4f',10>,[CP1_F25],[CP1_F25],[CP1_FD]
  fld	   dword[CP1_F26] ; ST(0) = [F26] (Single)
  fstp	   [CP1_FD]	  ; FD = ST(0) (Double)
  cinvoke  printf,<'F26: $%016llX %.8f %.4f',10>,[CP1_F26],[CP1_F26],[CP1_FD]
  fld	   dword[CP1_F27] ; ST(0) = [F27] (Single)
  fstp	   [CP1_FD]	  ; FD = ST(0) (Double)
  cinvoke  printf,<'F27: $%016llX %.8f %.4f',10>,[CP1_F27],[CP1_F27],[CP1_FD]
  fld	   dword[CP1_F28] ; ST(0) = [F28] (Single)
  fstp	   [CP1_FD]	  ; FD = ST(0) (Double)
  cinvoke  printf,<'F28: $%016llX %.8f %.4f',10>,[CP1_F28],[CP1_F28],[CP1_FD]
  fld	   dword[CP1_F29] ; ST(0) = [F29] (Single)
  fstp	   [CP1_FD]	  ; FD = ST(0) (Double)
  cinvoke  printf,<'F29: $%016llX %.8f %.4f',10>,[CP1_F29],[CP1_F29],[CP1_FD]
  fld	   dword[CP1_F30] ; ST(0) = [F30] (Single)
  fstp	   [CP1_FD]	  ; FD = ST(0) (Double)
  cinvoke  printf,<'F30: $%016llX %.8f %.4f',10>,[CP1_F30],[CP1_F30],[CP1_FD]
  fld	   dword[CP1_F31] ; ST(0) = [F31] (Single)
  fstp	   [CP1_FD]	  ; FD = ST(0) (Double)
  cinvoke  printf,<'F31: $%016llX %.8f %.4f',10>,[CP1_F31],[CP1_F31],[CP1_FD]

  movzx    edx,[CP1_FP]
  cinvoke  printf,<'FP:  $%02X',10>