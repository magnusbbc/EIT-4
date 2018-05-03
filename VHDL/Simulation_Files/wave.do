onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpu_v1_tb/MAIN/clk
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/pc
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/pram_address_index
add wave -noupdate -radix hexadecimal /cpu_v1_tb/MAIN/instruction
add wave -noupdate /cpu_v1_tb/MAIN/interrupt_cpu
add wave -noupdate /cpu_v1_tb/MAIN/Interrupt_latch
add wave -noupdate /cpu_v1_tb/MAIN/MEMCNT/InterruptDriver/interrupt_btn
add wave -noupdate /cpu_v1_tb/MAIN/MEMCNT/InterruptDriver/interrupt_btn_reset
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/ButtonDriver/btn
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/btn_data
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/operand_a
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/operand_b
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/ALU/operation
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/ALU/result
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/REGS/reg(6)
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/REGS/reg(5)
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/REGS/reg(4)
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/REGS/reg(3)
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/REGS/reg(2)
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/REGS/reg(1)
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(2)
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(1)
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/DO
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/SevenSegmentDisplayDriver/input_data
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/pc_alt
add wave -noupdate /cpu_v1_tb/MAIN/jmp_enable
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {51191970 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 419
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
WaveRestoreZoom {51145893 ps} {51208111 ps}
