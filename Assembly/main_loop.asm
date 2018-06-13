//setup
MOVI 1 $r10 //counter for fircoi loop

Main:
//Coeff calculation


//Move coeff to filter 
FIRCOR $r3 //maybe change r3 to reg that holds coeff

//Loop check
ADDI $r10 1 $r10
CMPI $r10 64 //# of tabs
JMPLE #Main //loop main if under # of tabs

//Loop reset
MOVI 1 $r10

//Idle loop
Loop:
NOP
JMP #Loop

//Halt for safety
HALT

//ISR and stuff goes here - probably also "main loop"