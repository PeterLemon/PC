#!/usr/bin/env sh
if [ -n "$FASMPATH"]; then
FASMPATH="$HOME/bin/fasm"
fi
INCLUDE="$FASMPATH/INCLUDE" wine "$FASMPATH/FASM.EXE" N64EMU.ASM
