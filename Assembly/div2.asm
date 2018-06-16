MOVI 15 $r1 
STORE $r1 [65001]
//using division "function"
MOVI 30 $r20 //N
MOVI 3 $r21 //D
MOVI 32767 $r24
//result Q will be in register r22
//set return point for function
ADDI $pc 3 $r25
PUSH $r25
JMP #signDiv
NOP
STORE $r22 [65000]
HALT

//unsigned division start
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
//unsigned division end

//signed division start
signDiv:
NOP
ADDI $r20 32767 $r26
CMP $r26 $r24   //-N
JMPLE #negN
ADDI $r21 32767 $r26
CMP $r26 $r24   //-D
JMPLE #negD
//else
JMP #posBoth 

posBoth: //+N/+D
NOP
ADDI $pc 3 $r25
PUSH $r25
JMP #divvy
NOP
JMP #divEnd

negN: //-N/+D
NOP
ADDI $r21 32767 $r26
CMP $r26 $r24   //-D
JMPLE #negBoth
//else

MULTI $r20 -1 $r20 //N=-N

ADDI $pc 3 $r25
PUSH $r25
JMP #divvy //divide
//convert back to neg
NOP

MULTI $r22 -1 $r22 //Q=-Q
JMP #divEnd

negD: //+N/-D
NOP
ADDI $r20 32767 $r26
CMP $r26 $r24   //-N
JMPLE #negBoth
//else
MULTI $r21 -1 $r21 //D=-D

ADDI $pc 3 $r25
PUSH $r25
JMP #divvy //divide
//convert back to neg
NOP
MULTI $r22 -1 $r22 //Q=-Q
JMP #divEnd

negBoth: //-N/-D
NOP
MULTI $r20 -1 $r20 //N=-N
MULTI $r21 -1 $r21 //D=-D

ADDI $pc 3 $r25
PUSH $r25
JMP #divvy
NOP
JMP #divEnd

divEnd:
NOP
POP $pc //return to signDiv Call
//signed division end



