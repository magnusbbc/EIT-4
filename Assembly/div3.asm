MOVI 31 $r1 
STORE $r1 [65001]

MOVI 16222 $r20
MOVI 7 $r21 

NOP
MOVI 0 $r22 //Q=0
MOV $r20 $r23 //R=N

lol:
NOP
ADDI $r22 1 $r22 //Q=Q+1
SUBR $r23 $r21 $r23 // R=R-D

CMP $r21 $r23 //D<=R => R>=D (?)
JMPLE #lol
CMP $r21 $r23
JMPEQ #lol

STORE $r22 [65000]
HALT