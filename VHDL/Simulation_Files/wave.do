onerror {resume}
quietly virtual signal -install /cpu_v1_tb/MAIN { /cpu_v1_tb/MAIN/CONTROL(9 downto 8)} Jump
quietly WaveActivateNextPane {} 0
add wave -noupdate -label Clock /cpu_v1_tb/TbClock
add wave -noupdate -label PC -radix unsigned /cpu_v1_tb/MAIN/PC
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/ADDR
add wave -noupdate -divider {Instruction and Control}
add wave -noupdate -label Instruction -radix hexadecimal /cpu_v1_tb/MAIN/INSTRUCTION
add wave -noupdate -label Clock /cpu_v1_tb/MAIN/CONTROL
add wave -noupdate -divider ALU
add wave -noupdate -color Yellow -label OP1 -radix unsigned /cpu_v1_tb/MAIN/ALU/Operand1
add wave -noupdate -color Yellow -label OP2 -radix unsigned /cpu_v1_tb/MAIN/ALU/Operand2
add wave -noupdate -color Yellow -label Operation -radix unsigned /cpu_v1_tb/MAIN/ALU/Operation
add wave -noupdate -color Yellow -label {ALU Output} -radix unsigned /cpu_v1_tb/MAIN/ALU/Result
add wave -noupdate -divider Memory
add wave -noupdate -label R26 -radix unsigned /cpu_v1_tb/MAIN/REGS/REG(26)
add wave -noupdate -label R25 -radix unsigned /cpu_v1_tb/MAIN/REGS/REG(25)
add wave -noupdate -label R24 -radix unsigned /cpu_v1_tb/MAIN/REGS/REG(24)
add wave -noupdate -label {R23} -radix unsigned /cpu_v1_tb/MAIN/REGS/REG(23)
add wave -noupdate -label Mem -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(256)
add wave -noupdate -label {M2} -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(2)
add wave -noupdate -label {M1} -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(1)
add wave -noupdate -label {M0} -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(0)
add wave -noupdate -divider {Mem Signals}
add wave -noupdate -label Address -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/Address
add wave -noupdate -label WE /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/WE
add wave -noupdate -label RE /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RE
add wave -noupdate -label DI -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/DI
add wave -noupdate -label DO -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/DO
add wave -noupdate -divider MemController
add wave -noupdate -label Address -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/Address
add wave -noupdate -label WE /cpu_v1_tb/MAIN/MEMCNT/WE
add wave -noupdate -label RE /cpu_v1_tb/MAIN/MEMCNT/RE
add wave -noupdate -label DI -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/DI
add wave -noupdate -label DO -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/DO
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {42765 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 323
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
WaveRestoreZoom {0 ps} {133262 ps}
