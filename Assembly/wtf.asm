MOVI 31 $r1
STORE $r1 [65001]

ADDI $pc 3 $r4
PUSH $r4
POP $pc
NOP

ADDI $pc 3 $r4
PUSH $r4
POP $pc
NOP

STORE $r1 [65000]
HALT