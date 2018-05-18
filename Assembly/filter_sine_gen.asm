MOVI $r1 65102 //I2S Interrupt serivce routine
MOVI $r2 #I2SISR
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
MOVI $r5 16000
JMP  #OUT
MOVI $r5 21419
JMP  #OUT
MOVI $r5 26198
JMP  #OUT
MOVI $r5 29771
JMP  #OUT
MOVI $r5 31716
JMP  #OUT
MOVI $r5 31803
JMP  #OUT
MOVI $r5 30020
JMP  #OUT
MOVI $r5 26580
JMP  #OUT
MOVI $r5 21889
JMP  #OUT
MOVI $r5 16502
JMP  #OUT
MOVI $r5 11055
JMP  #OUT
MOVI $r5 6193
JMP  #OUT
MOVI $r5 2490
JMP  #OUT
MOVI $r5 385
JMP  #OUT
MOVI $r5 126
JMP  #OUT
MOVI $r5 1743
JMP  #OUT
MOVI $r5 5047
JMP  #OUT
MOVI $r5 9645
JMP  #OUT
MOVI $r5 14995
MOVI $r7 #SineStart
SUBI $r7 2 $r7
OUT:
ADDI $r7 2 $r7
STORE $r5 [$r10+65010]
POP $pc