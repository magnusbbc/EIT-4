onerror {resume}
quietly virtual signal -install /cpu_v1_tb/MAIN { /cpu_v1_tb/MAIN/CONTROL(9 downto 8)} Jump
quietly WaveActivateNextPane {} 0
add wave -noupdate -label Clock /cpu_v1_tb/TbClock
add wave -noupdate -label PC -radix unsigned /cpu_v1_tb/MAIN/PC
add wave -noupdate -divider {Instruction and Control}
add wave -noupdate -label Instruction /cpu_v1_tb/MAIN/INSTRUCTION
add wave -noupdate -label Clock /cpu_v1_tb/MAIN/CONTROL
add wave -noupdate -divider Reg
add wave -noupdate -color Blue -label {Read 1 Index} -radix unsigned /cpu_v1_tb/MAIN/REGS/readOne
add wave -noupdate -color Blue -label {Read 2 Index} -radix unsigned /cpu_v1_tb/MAIN/REGS/readTwo
add wave -noupdate -color Blue -label {Write 1 Index} -radix unsigned /cpu_v1_tb/MAIN/REGS/WriteOne
add wave -noupdate -color Blue -label {Write 2 Index} -radix unsigned /cpu_v1_tb/MAIN/REGS/WriteTwo
add wave -noupdate -color Blue -label {Data in 1} -radix unsigned /cpu_v1_tb/MAIN/REGS/dataInOne
add wave -noupdate -color Blue -label {Data in 2} -radix unsigned /cpu_v1_tb/MAIN/REGS/dataInTwo
add wave -noupdate -color Blue -label {Data out 1} -radix unsigned /cpu_v1_tb/MAIN/REGS/dataOutOne
add wave -noupdate -color Blue -label {Data out 2} -radix unsigned /cpu_v1_tb/MAIN/REGS/dataOutTwo
add wave -noupdate -color Blue -label {PC In} -radix unsigned /cpu_v1_tb/MAIN/REGS/pcIn
add wave -noupdate -color Blue -label {Write Enable 1} /cpu_v1_tb/MAIN/REGS/WR1_E
add wave -noupdate -color Blue -label {Write Enable 2} /cpu_v1_tb/MAIN/REGS/WR2_E
add wave -noupdate -color Blue -label R25 /cpu_v1_tb/MAIN/REGS/REG(25)
add wave -noupdate -divider ALU
add wave -noupdate -color Yellow -label OP1 -radix unsigned /cpu_v1_tb/MAIN/ALU/Operand1
add wave -noupdate -color Yellow -label OP2 -radix unsigned /cpu_v1_tb/MAIN/ALU/Operand2
add wave -noupdate -color Yellow -label Operation -radix unsigned /cpu_v1_tb/MAIN/ALU/Operation
add wave -noupdate -color Yellow -label {ALU Output} -radix unsigned /cpu_v1_tb/MAIN/ALU/Result
add wave -noupdate -color Yellow -label Flags /cpu_v1_tb/MAIN/ALU/Flags
add wave -noupdate -divider Jump
add wave -noupdate -color Magenta -label {Jump Select} /cpu_v1_tb/MAIN/JMP_SELECT
add wave -noupdate -color Magenta -label Jump -subitemconfig {/cpu_v1_tb/MAIN/CONTROL(9) {-color Magenta} /cpu_v1_tb/MAIN/CONTROL(8) {-color Magenta}} /cpu_v1_tb/MAIN/Jump
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10899 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 225
configure wave -valuecolwidth 104
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {142275 ps}
