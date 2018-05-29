MOVI 65535 $r1
ADDI $r1 1 $r2
GETFLAG $r3
RASI $r3 4 $r3
LSRR $r1 $r3 $r1
NEGR $r1 $r4
SUBR $r4 $r3 $r4
ADDI $r4 1 $r4
ADDR $r3 $r3 $r3
MULT $r4 $r3 $r4
PUSH $r4
POP $r5
MULTI $r5 500 $r4
NEGI 500 $r5
LSLI $r5 2 $r5
RASI $r5 1 $r5
ADDR $r4 $r5 $r4
SUBI $r4 1 $r4
ANDR $r4 $r5 $r4
ANDI $r4 -9 $r5
XORI $r5 -4081 $r4
XORR $r5 $r4 $r3
ORI $r3 0 $r4 
ORR $r4 $r1 $r2
SUBI $r2 16656 $r1
ADDI $r2 3 $r2
RASR $r1 $r2 $r1
MOVI 15 $r10
STORE $r10 [65001]
STORE $r1 [65000]

HALT

