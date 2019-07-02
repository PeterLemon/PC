@echo off
if not defined FASMPATH (
set FASMPATH=C:\home\bin\fasm
)
set INCLUDE=%FASMPATH%\include
%FASMPATH%\fasm N64EMU.ASM N64EMU.EXE
