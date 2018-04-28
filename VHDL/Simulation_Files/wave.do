onerror {resume}
quietly virtual signal -install /cpu_v1_tb/MAIN { /cpu_v1_tb/MAIN/CONTROL(9 downto 8)} Jump
quietly virtual signal -install /cpu_v1_tb/MAIN { /cpu_v1_tb/MAIN/CONTROL(12 downto 10)} Jump001
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
add wave -noupdate -divider Button
add wave -noupdate /cpu_v1_tb/MAIN/JMP_SELECT
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/PC_ALT
add wave -noupdate /cpu_v1_tb/MAIN/Jump001
add wave -noupdate /cpu_v1_tb/MAIN/Interrupt_CPU
add wave -noupdate /cpu_v1_tb/MAIN/Interrupt_latch
add wave -noupdate /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(2)
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(1)
add wave -noupdate /cpu_v1_tb/MAIN/JMP_SELECT_LATCH
add wave -noupdate /cpu_v1_tb/MAIN/Interrupt_addr
add wave -noupdate /cpu_v1_tb/MAIN/MEMCNT/control
add wave -noupdate /cpu_v1_tb/MAIN/MEMCNT/InterruptDriver/Control
add wave -noupdate /cpu_v1_tb/MAIN/MEMCNT/InterruptDriver/REG
add wave -noupdate /cpu_v1_tb/MAIN/MEMCNT/InterruptDriver/Write_enable
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/R2O
add wave -noupdate -divider Mem
add wave -noupdate /cpu_v1_tb/MAIN/MEMCNT/InterruptDriver/Address
add wave -noupdate /cpu_v1_tb/MAIN/MEMCNT/InterruptDriver/Data
add wave -noupdate /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/DI
add wave -noupdate /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/DO
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/Address
add wave -noupdate /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/WE
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {27591 ps} 0}
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
WaveRestoreZoom {0 ps} {66632 ps}
