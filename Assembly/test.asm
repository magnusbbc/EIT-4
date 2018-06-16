//setup sseg
MOVI 31 $r1 //move 31 to r1
STORE $r1 [65001] //store 31 as sseg setup

//setup btn intr
MOVI #BTNISR $r1 //move isr address to r1
STORE $r1 [65100] //move r1 to intr controller
MOVI 512 $r1 //move 512 to r1
STORE $r1 [65101] //store 1 in tenth lsb to enable interrupts

MOVI 0 $r1 //set start value for counter
MOV $r1 $r2
loop:
NOP
ADDI $r2 1 $r2
CMPI $r2 30000
JMPEQ #display
JMP #loop //loop loop

display:
NOP
STORE $r1 [65000] //display r1 on sseg
ADDI $r1 1 $r1 //increment r1
JMP #loop

BTNISR:
NOP
MOVI 0 $r1 //reset counter
POP $pc //return from intr