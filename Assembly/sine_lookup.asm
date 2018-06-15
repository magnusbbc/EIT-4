//sine setup start
ADDI $pc 3 $r17
PUSH $r17
JMP #tableSetup
NOP

//other setup/code goes here

Loop:
NOP
NOP
JMP #Loop

HALT

//table setup
tableSetup:
NOP
MOVI 60000 $r19 //start value for table address
JMP #sine

tableStore:
NOP
STORE $r18 [$r19] //store sine value in current table address
ADDI $r19 1 $r19 //increment table address
//return to sine
POP $pc

sine:
NOP
MOVI 12 $r18 //12 is sine val placeholder
ADDI $pc 3 $r17
PUSH $r17
JMP #tableStore
//repeat line 30 to 34