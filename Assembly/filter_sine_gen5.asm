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

MOVI 65100 $r1 //Button Interrupt Service routine 
MOVI #BUTISR $r2
STORE $r2 [$r1]
MOVI 512 $r2 //Enable interrupt, disable nesting
STORE $r2 [$r1+1]

MOVI 65104 $r1 //I2S Interrupt serivce routine
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

MOVI 232 $r5
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
JMPR $r7 
SineStart:
FIRSAI 0 $r5
JMP  #OUT
FIRSAI 13562 $r5
JMP  #OUT
FIRSAI 14782 $r5
JMP  #OUT
FIRSAI 6538 $r5
JMP  #OUT
FIRSAI 1796 $r5
JMP  #OUT
FIRSAI 5656 $r5
JMP  #OUT
FIRSAI 9378 $r5
JMP  #OUT
FIRSAI 4221 $r5
JMP  #OUT
FIRSAI -4702 $r5
JMP  #OUT
FIRSAI -4409 $r5
JMP  #OUT
FIRSAI 7999 $r5
JMP  #OUT
FIRSAI 20212 $r5
JMP  #OUT
FIRSAI 19919 $r5
JMP  #OUT
FIRSAI 10034 $r5
JMP  #OUT
FIRSAI 3565 $r5
JMP  #OUT
FIRSAI 5656 $r5
JMP  #OUT
FIRSAI 7608 $r5
JMP  #OUT
FIRSAI 725 $r5
JMP  #OUT
FIRSAI -9838 $r5
JMP  #OUT
FIRSAI -11059 $r5
JMP  #OUT
FIRSAI 0 $r5
JMP  #OUT
FIRSAI 11059 $r5
JMP  #OUT
FIRSAI 9838 $r5
JMP  #OUT
FIRSAI -725 $r5
JMP  #OUT
FIRSAI -7608 $r5
JMP  #OUT
FIRSAI -5656 $r5
JMP  #OUT
FIRSAI -3565 $r5
JMP  #OUT
FIRSAI -10034 $r5
JMP  #OUT
FIRSAI -19919 $r5
JMP  #OUT
FIRSAI -20212 $r5
JMP  #OUT
FIRSAI -8000 $r5
JMP  #OUT
FIRSAI 4409 $r5
JMP  #OUT
FIRSAI 4702 $r5
JMP  #OUT
FIRSAI -4221 $r5
JMP  #OUT
FIRSAI -9378 $r5
JMP  #OUT
FIRSAI -5656 $r5
JMP  #OUT
FIRSAI -1796 $r5
JMP  #OUT
FIRSAI -6538 $r5
JMP  #OUT
FIRSAI -14782 $r5
JMP  #OUT
FIRSAI -13562 $r5
MOVI #SineStart $r7
SUBI $r7 2 $r7
OUT:
NOP
NOP
ADDI $r7 2 $r7
STORE $r5 [65010]
POP $pc

BUTISR:
LOAD $r4 [65002]
CMPI $r4 4
JMPEQ #AD
CMPI $r4 2
JMPEQ #SUB
CMPI $r2 15
JMPEQ #DISABLE_DOT
MOVI $r2 15 //Disable BCD, Disable dots
JMP #SAVE
DISABLE_DOT:
MOVI $r2 0
JMP #SAVE
SUB:
CMPI $r3 0
JMPEQ #SAVE
SUBI $r3 1 $r3
CMPI $r3 0
JMPEQ #ALL_PASS
CMPI $r3 1
JMPEQ #LOW_PASS
CMPI $r3 2
JMPEQ #BAND_PASS
JMP #SAVE
AD:
CMPI $r3 3
JMPEQ #SAVE
ADDI $r3 1 $r3
CMPI $r3 1
JMPEQ #LOW_PASS
CMPI $r3 2
JMPEQ #BAND_PASS
CMPI $r3 3
JMPEQ #HIGH_PASS
SAVE:
NOP
NOP
STORE $r3 [65000]
STORE $r2 [65001]
POP $pc
NOP
NOP
NOP
LOW_PASS:
FIRCOI -12
FIRCOI -4
FIRCOI 5
FIRCOI 17
FIRCOI 31
FIRCOI 48
FIRCOI 65
FIRCOI 79
FIRCOI 86
FIRCOI 83
FIRCOI 64
FIRCOI 26
FIRCOI -31
FIRCOI -106
FIRCOI -194
FIRCOI -284
FIRCOI -366
FIRCOI -424
FIRCOI -442
FIRCOI -405
FIRCOI -300
FIRCOI -120
FIRCOI 139
FIRCOI 470
FIRCOI 862
FIRCOI 1295
FIRCOI 1744
FIRCOI 2182
FIRCOI 2578
FIRCOI 2904
FIRCOI 3137
FIRCOI 3257
FIRCOI 3257
FIRCOI 3137
FIRCOI 2904
FIRCOI 2578
FIRCOI 2182
FIRCOI 1744
FIRCOI 1295
FIRCOI 862
FIRCOI 470
FIRCOI 139
FIRCOI -120
FIRCOI -300
FIRCOI -405
FIRCOI -442
FIRCOI -424
FIRCOI -366
FIRCOI -284
FIRCOI -194
FIRCOI -106
FIRCOI -31
FIRCOI 26
FIRCOI 64
FIRCOI 83
FIRCOI 86
FIRCOI 79
FIRCOI 65
FIRCOI 48
FIRCOI 31
FIRCOI 17
FIRCOI 5
FIRCOI -4
FIRCOI -12
JMP #SAVE
NOP
NOP
NOP
NOP
BAND_PASS:
FIRCOI 44
FIRCOI 36
FIRCOI 26
FIRCOI 15
FIRCOI 3
FIRCOI -8
FIRCOI -13
FIRCOI -8
FIRCOI 12
FIRCOI 47
FIRCOI 95
FIRCOI 145
FIRCOI 183
FIRCOI 188
FIRCOI 140
FIRCOI 22
FIRCOI -173
FIRCOI -438
FIRCOI -753
FIRCOI -1080
FIRCOI -1370
FIRCOI -1569
FIRCOI -1627
FIRCOI -1505
FIRCOI -1187
FIRCOI -683
FIRCOI -32
FIRCOI 703
FIRCOI 1441
FIRCOI 2094
FIRCOI 2582
FIRCOI 2843
FIRCOI 2843
FIRCOI 2582
FIRCOI 2094
FIRCOI 1441
FIRCOI 703
FIRCOI -32
FIRCOI -683
FIRCOI -1187
FIRCOI -1505
FIRCOI -1627
FIRCOI -1569
FIRCOI -1370
FIRCOI -1080
FIRCOI -753
FIRCOI -438
FIRCOI -173
FIRCOI 22
FIRCOI 140
FIRCOI 188
FIRCOI 183
FIRCOI 145
FIRCOI 95
FIRCOI 47
FIRCOI 12
FIRCOI -8
FIRCOI -13
FIRCOI -8
FIRCOI 3
FIRCOI 15
FIRCOI 26
FIRCOI 36
FIRCOI 44
JMP #SAVE
NOP
HIGH_PASS:
FIRCOI -26
FIRCOI -23
FIRCOI -18
FIRCOI -7
FIRCOI 9
FIRCOI 30
FIRCOI 54
FIRCOI 78
FIRCOI 95
FIRCOI 98
FIRCOI 78
FIRCOI 33
FIRCOI -39
FIRCOI -130
FIRCOI -228
FIRCOI -314
FIRCOI -364
FIRCOI -357
FIRCOI -276
FIRCOI -112
FIRCOI 129
FIRCOI 425
FIRCOI 739
FIRCOI 1017
FIRCOI 1197
FIRCOI 1211
FIRCOI 983
FIRCOI 432
FIRCOI -566
FIRCOI -2287
FIRCOI -5757
FIRCOI -20465
FIRCOI 20465
FIRCOI 5757
FIRCOI 2287
FIRCOI 566
FIRCOI -432
FIRCOI -983
FIRCOI -1211
FIRCOI -1197
FIRCOI -1017
FIRCOI -739
FIRCOI -425
FIRCOI -129
FIRCOI 112
FIRCOI 276
FIRCOI 357
FIRCOI 364
FIRCOI 314
FIRCOI 228
FIRCOI 130
FIRCOI 39
FIRCOI -33
FIRCOI -78
FIRCOI -98
FIRCOI -95
FIRCOI -78
FIRCOI -54
FIRCOI -30
FIRCOI -9
FIRCOI 7
FIRCOI 18
FIRCOI 23
FIRCOI 26
JMP #SAVE
NOP
NOP
ALL_PASS:
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
JMP #SAVE