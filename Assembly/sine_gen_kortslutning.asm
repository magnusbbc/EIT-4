MOVI 65104 $r1 //I2S_out Interrupt serivce routine
MOVI #I2SREADYISR $r2
STORE $r2 [$r1]
MOVI 512 $r2 //Enable interrupt, disable nesting
STORE $r2 [$r1+1]

//Write 0 to 7seg, disable dots
MOVI 0 $r3
MOVI 65000 $r1
STORE $r3 [$r1]
MOVI 15 $r2 
STORE $r2 [65001]

MOVI 1 $r5
STORE $r5 [65009]

MOVI 7853 $r5
STORE $r5 [65010]
MOVI #SineStart $r7
LOOP:
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
JMP #LOOP

I2SREADYISR:
NOP
JMPR $r7 
SineStart:
NOP
MOVI 500 $r5
JMP  #OUT
NOP
MOVI 120 $r5
JMP  #OUT
NOP
NOP
NOP
NOP
MOVI -150 $r5
MOVI #SineStart $r7
SUBI $r7 2 $r7
OUT:
NOP
NOP
ADDI $r7 3 $r7
STORE $r5 [65010]
POP $pc