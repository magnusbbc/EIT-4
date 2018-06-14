//using division "function"
MOVI 10 $r20 //N
MOVI 2 $r21 //D
//result Q will be in register r20
//set return point for function
ADDI $pc 2 $r25
PUSH $r25
JMP #signDiv

MOVI 31 $r1 
STORE $r1 [65001]
STORE $r20 [65000]


HALT

//unsigned division start
div:
MOVI 0 $r22 //Q
MOV $r21 $r23 //R

divLoop:
ADDI 1 $r22 $r22 //Q=Q+1
SUBR $r23 $r21 $r23 // R=R-D

CMP $r21 $r23 //D<=R => R>=D (?)
JMPLE #divLoop

POP $pc //return to signDiv
//unsigned division end

//signed division start
signDiv:
CMPI 0 $r20 //-N
JMPLE #negN
CMPI 0 $r21 //-D
JMPLE #negD
//else
JMP #posBoth 

posBoth: //+N/+D
ADDI $pc 2 $r25
PUSH $r25
JMP #div
JMP #divEnd

negN: //-N/+D
CMPI 0 $r21 //-D
JMPLE #negBoth
//else
MULTI $r20 -1 $r20 //N=-N

ADDI $pc 2 $r25
PUSH $r25
JMP #div //divide
//convert back to neg
MULTI $r20 -1 $r20 //N=-N
MULTI $r21 -1 $r21 //D=-D
JMP #divEnd

negD: //+N/-D
CMPI 0 $r20 //-N
JMPLE #negBoth
//else
MULTI $r21 -1 $r21 //D=-D

ADDI $pc 2 $r25
PUSH $r25
JMP #div //divide
//convert back to neg
MULTI $r20 -1 $r20 //N=-N
MULTI $r21 -1 $r21 //D=-D
JMP #divEnd

negBoth: //-N/-D
MULTI $r20 -1 $r20 //N=-N
MULTI $r21 -1 $r21 //D=-D

ADDI $pc 2 $r25
PUSH $r25
JMP #div
JMP #divEnd

divEnd:
POP $pc //return to signDiv Call
//signed division end



