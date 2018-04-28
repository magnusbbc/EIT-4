MOVI $r1 65100 //Address for I2S interrupt
MOVI $r2 #I2SISR
STORE $r2 [$r1]
MOVI $r2 512
STORE $r2 [$r1+1] //Enables Button Interrupts
LOOP:
NOP
NOP
NOP
NOP
NOP
NOP
JMP #LOOP
HALT
I2SISR:
NOP
NOP
NOP
NOP
POP $pc
