MOVI 65001 $r1
MOVI 15 $r2 //Disable BCD, Disable dots
STORE $r2 [$r1]
MOVI 0 $r3
MOVI 65000 $r8
STORE $r3 [$r8]

MOVI 65102 $r1 //I2S Interrupt serivce routine
MOVI #I2SISR $r2
STORE $r2 [$r1]
MOVI 512 $r2
STORE $r2 [$r1+1]

MOVI 101 $r9
LOOP:
NOP
NOP
NOP
JMP #LOOP

I2SISR:
LOAD $r5 [$r10+65011]
MOV $r5 $r5
JMPPA #PARITY
JMP #END
PARITY:
ADDI $r22 1 $r22
STORE $r22 [$r8]
END:
ADDI $r25 1 $r25
//CMPI $r25 48000
//JMPEQ #STOP
NOP
NOP
STORE $r5 [$r10+65010]
POP $pc

STOP:
NOP
NOP
HALT