FIRCOI -32768
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0

MOVI $r1 65100 //Button Interrupt Service routine 
MOVI $r2 #BUTISR
STORE $r2 [$r1]
MOVI $r2 512 //Enable interrupt, disable nesting
STORE $r2 [$r1+1]

MOVI $r1 65104 //I2S Interrupt serivce routine
MOVI $r2 #I2SREADYISR
STORE $r2 [$r1]
MOVI $r2 512 //Enable interrupt, disable nesting
STORE $r2 [$r1+1]

//Write 3 to 7seg
MOVI $r3 3
MOVI $r1 65000
STORE $r3 [$r1]

MOVI $r5 232
STORE $r5 [$r10+65010]
MOVI $r7 #SineStart
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
JMPR $r7 
SineStart:
FIRSAI 0 $r5
JMP  #OUT
FIRSAI 11409 $r5
JMP  #OUT
FIRSAI 19195 $r5
JMP  #OUT
FIRSAI 21106 $r5
JMP  #OUT
FIRSAI 17112 $r5
JMP  #OUT
FIRSAI 9404 $r5
JMP  #OUT
FIRSAI 1548 $r5
JMP  #OUT
FIRSAI -2888 $r5
JMP  #OUT
FIRSAI -1707 $r5
JMP  #OUT
FIRSAI 5072 $r5
JMP  #OUT
FIRSAI 15216 $r5
JMP  #OUT
FIRSAI 25121 $r5
JMP  #OUT
FIRSAI 31185 $r5
JMP  #OUT
FIRSAI 31185 $r5
JMP  #OUT
FIRSAI 25121 $r5
JMP  #OUT
FIRSAI 15216 $r5
JMP  #OUT
FIRSAI 5072 $r5
JMP  #OUT
FIRSAI -1707 $r5
JMP  #OUT
FIRSAI -2888 $r5
JMP  #OUT
FIRSAI 1548 $r5
JMP  #OUT
FIRSAI 9404 $r5
JMP  #OUT
FIRSAI 17112 $r5
JMP  #OUT
FIRSAI 21106 $r5
JMP  #OUT
FIRSAI 19195 $r5
JMP  #OUT
FIRSAI 11409 $r5
JMP  #OUT
FIRSAI 0 $r5
JMP  #OUT
FIRSAI -11409 $r5
JMP  #OUT
FIRSAI -19195 $r5
JMP  #OUT
FIRSAI -21106 $r5
JMP  #OUT
FIRSAI -17112 $r5
JMP  #OUT
FIRSAI -9404 $r5
JMP  #OUT
FIRSAI -1548 $r5
JMP  #OUT
FIRSAI 2888 $r5
JMP  #OUT
FIRSAI 1707 $r5
JMP  #OUT
FIRSAI -5072 $r5
JMP  #OUT
FIRSAI -15216 $r5
JMP  #OUT
FIRSAI -25121 $r5
JMP  #OUT
FIRSAI -31185 $r5
JMP  #OUT
FIRSAI -31185 $r5
JMP  #OUT
FIRSAI -25121 $r5
JMP  #OUT
FIRSAI -15216 $r5
JMP  #OUT
FIRSAI -5072 $r5
JMP  #OUT
FIRSAI 1707 $r5
JMP  #OUT
FIRSAI 2888 $r5
JMP  #OUT
FIRSAI -1548 $r5
JMP  #OUT
FIRSAI -9404 $r5
JMP  #OUT
FIRSAI -17112 $r5
JMP  #OUT
FIRSAI -21106 $r5
JMP  #OUT
FIRSAI -19195 $r5
JMP  #OUT
FIRSAI -11409 $r5
MOVI $r7 #SineStart
SUBI $r7 2 $r7
OUT:
NOP
NOP
ADDI $r7 2 $r7
STORE $r5 [$r10+65010]
POP $pc

BUTISR:
LOAD $r4 [$r10+65002]
CMPI $r4 4
JMPEQ #AD
SUBI $r3 1 $r3
FIRCOI 20
FIRCOI 27
FIRCOI 31
FIRCOI 28
FIRCOI 17
FIRCOI -4
FIRCOI -34
FIRCOI -68
FIRCOI -97
FIRCOI -108
FIRCOI -91
FIRCOI -39
FIRCOI 46
FIRCOI 152
FIRCOI 253
FIRCOI 318
FIRCOI 316
FIRCOI 224
FIRCOI 39
FIRCOI -219
FIRCOI -502
FIRCOI -742
FIRCOI -861
FIRCOI -786
FIRCOI -466
FIRCOI 114
FIRCOI 922
FIRCOI 1882
FIRCOI 2882
FIRCOI 3791
FIRCOI 4483
FIRCOI 4857
FIRCOI 4857
FIRCOI 4483
FIRCOI 3791
FIRCOI 2882
FIRCOI 1882
FIRCOI 922
FIRCOI 114
FIRCOI -466
FIRCOI -786
FIRCOI -861
FIRCOI -742
FIRCOI -502
FIRCOI -219
FIRCOI 39
FIRCOI 224
FIRCOI 316
FIRCOI 318
FIRCOI 253
FIRCOI 152
FIRCOI 46
FIRCOI -39
FIRCOI -91
FIRCOI -108
FIRCOI -97
FIRCOI -68
FIRCOI -34
FIRCOI -4
FIRCOI 17
FIRCOI 28
FIRCOI 31
FIRCOI 27
FIRCOI 20
JMP #SAVE
CMPI $r4 10000
JMPNQ #SAVE
AD:
ADDI $r3 1 $r3
FIRCOI -32768
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
FIRCOI 0
SAVE:
NOP
STORE $r3 [$r10+65000]
POP $pc
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
NOP
NOP
NOP
NOP
NOP
NOP
MOVI $r1 65001
MOVI $r2 15 //Disable BCD, Disable dots
STORE $r2 [$r1]