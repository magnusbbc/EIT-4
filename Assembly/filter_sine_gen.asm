MOVI 65102 $r1 //I2S Interrupt serivce routine
MOVI #I2SISR $r2
STORE $r2 [$r1]
MOVI $r7 #SineStart //Used to store sinewave index
MOVI $r2 512
STORE $r2 [$r1+1]

LOOP:
NOP
NOP
NOP
NOP
NOP
NOP
JMP #LOOP

I2SISR:
NOP
NOP
JMPR $r7 
NOP
SineStart:
MOVI 16000 $r5
JMP  #OUT
MOVI 21419 $r5
JMP  #OUT
MOVI 26198 $r5
JMP  #OUT
MOVI 29771 $r5
JMP  #OUT
MOVI 31716 $r5
JMP  #OUT
MOVI 31803 $r5
JMP  #OUT
MOVI 30020 $r5
JMP  #OUT
MOVI 26580 $r5
JMP  #OUT
MOVI 21889 $r5
JMP  #OUT
MOVI 16502 $r5
JMP  #OUT
MOVI 11055 $r5
JMP  #OUT
MOVI 6193 $r5
JMP  #OUT
MOVI 2490 $r5
JMP  #OUT
MOVI 385 $r5
JMP  #OUT
MOVI 126 $r5
JMP  #OUT
MOVI 1743 $r5
JMP  #OUT
MOVI 5047 $r5
JMP  #OUT
MOVI 9645 $r5
JMP  #OUT
MOVI 14995 $r5
MOVI #SineStart $r7
SUBI $r7 2 $r7
OUT:
ADDI $r7 2 $r7
STORE $r5 [$r10+65010]
POP $pc