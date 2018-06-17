//Display
MOVI 24 $r1           // Display mode- 15 for hex and 24 for decimal
STORE $r1 [65001]
//ISR
MOVI 65102 $r1
MOVI #I2SISR $r2 // I2S_out Interrupt serivce routine
STORE $r2 [$r1]
MOVI 512 $r2
STORE $r2 [$r1+1]

MOVI 65100 $r1
MOVI #BTNISR $r2      // Button ISR
STORE $r2 [$r1]
MOVI 512 $r2 //Enable interrupt, disable nesting
STORE $r2 [$r1+1]

//GRAPH
//64000 - 64639 addresses for Graph points
//Colors black: 546 , white : 2594 , blue: 2713 , red:554
MOVI 546 $r1        //64641 bckgrnd colour 12 lsb 4B 4G 4R
STORE $r1 [64641] 
MOVI 554 $r1       //64642 paint colour 12 lsb 4B 4G 4R
STORE $r1 [64642] 
MOVI 2713 $r1       //64643 grid colour 12 lsb 4B 4G 4R
STORE $r1 [64643] 
MOVI 20 $r1         //64644 h grid space
STORE $r1 [64644] 
MOVI 20 $r1         //64645 v grid space
STORE $r1 [64645] 
MOVI 2 $r1          //64646 line thickness
STORE $r1 [64646] 
MOVI 1 $r1          //64647 line mode on lsb
STORE $r1 [64647] 
JMP #main//Go to main


I2SISR:
NOP
LOAD $r5 [65011]
ADDI $r6 1 $r6
MOVI 639 $r7
CMP $r6 $r7
JMPLE #nr
MOVI 0 $r6
nr:
NOP
MOV $r6 $r8
ADDI $r8 64000 $r8
MULTI $r5 3 $r9
STORE $r9 [$r8]

STORE $r5 [65010]
POP $pc

BTNISR:
NOP
ADDI $r10 1 $r10
STORE $r10 [64647]
POP $pc




main:
NOP
NOP
JMP #main