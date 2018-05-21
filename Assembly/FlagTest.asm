MOVI 65001 $r1
MOVI 15 $r2 //Disable BCD, Disable dots
STORE $r2 [$r1]
MOVI 0 $r3
MOVI 65000 $r8
STORE $r3 [$r8]


MOVI $r9 101
CMPI $r9 101
GETFLAG $r4
STORE $r4 [$r8]
HALT
