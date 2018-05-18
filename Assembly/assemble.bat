@echo off
SET /P variable=[Please Enter File to Assemble]
..\Assembler\Assembler.exe %variable% ..\VHDL\VHDL_RAW\MemInit.mif