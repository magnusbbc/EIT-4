MOVI 31 $r1
STORE $r1 [65001]
MOVI 1234 $r1
STORE $r1 [65000]

//64000 - 64639
//64641 bckgrnd colour 12 lsb 4B 4G 4R
//64642 paint colour 12 lsb 4B 4G 4R
//64643 grid col
//64644 h grid space
//64645 v grid space
//64646 line thickness
//64647 line mode on lsb

HALT