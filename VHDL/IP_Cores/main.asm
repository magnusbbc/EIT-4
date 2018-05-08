MOVI $r1 65100 //Button Interrupt Service routine 
MOVI $r2 #BUTISR
STORE $r2 [$r1]
MOVI $r2 512 //Enable interrupt, disable nesting
STORE $r2 [$r1+1]

MOVI $r1 65001
MOVI $r2 15 //Disable BCD, Disable dots
STORE $r2 [$r1]
MOVI $r3 1
MOVI $r1 65000
STORE $r3 [$r1]

MOVI $r1 65102 //I2S Interrupt serivce routine
MOVI $r2 #I2SISR
STORE $r2 [$r1]
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
HALT
BUTISR:
LOAD $r4 [$r10+65002]
CMPI $r4 4
JMPEQ #AD
SUBI $r3 1 $r3
JMP #SAVE
AD:
ADDI $r3 1 $r3
SAVE:
STORE $r3 [$r10+65000]
POP $pc
I2SISR:
LOAD $r5 [$r10+65011]
LSLR $r5 $r3 $r5
STORE $r5 [$r10+65010]
POP $pc