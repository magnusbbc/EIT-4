MOVI 31 $r1
STORE $r1 [65001]
NOP
MOVI 876 $r13

MOVI 10 $r20
MOVI 2 $r21
MOVI 55 $r22

ADDI $pc 3 $r5
PUSH $r5
JMP #label
NOP

//STORE $r1 [65000]

HALT

label:
NOP

ADDI $pc 3 $r5
PUSH $r5
JMP #divvy
NOP

STORE $r22 [65000]

POP $pc

divvy:
NOP
MOVI 0 $r22 //Q=0   
MOV $r20 $r23 //R=N

dloop:
NOP
ADDI $r22 1 $r22 //Q=Q+1
SUBR $r23 $r21 $r23 // R=R-D

CMP $r21 $r23 //D<=R => R>=D (?)
JMPLE #dloop
CMP $r21 $r23
JMPEQ #dloop

POP $pc //return to signDiv