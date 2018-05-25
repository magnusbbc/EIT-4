MOVI 65100 $r1 //Button Interrupt Service routine 
MOVI #BUTISR $r2
STORE $r2 [$r1]
MOVI 512 $r2 //Enable interrupt, disable nesting
STORE $r2 [$r1+1]

MOVI 65001 $r1
MOVI 15 $r2 //Disable BCD, Disable dots
STORE $r2 [$r1]
MOVI 1 $r3
MOVI 65000 $r1
STORE $r3 [$r1]

MOVI 65102 $r1 //I2S Interrupt serivce routine
MOVI #I2SISR $r2
STORE $r2 [$r1]
MOVI 512 $r2
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
STORE $r5 [$r10+65010]
POP $pc