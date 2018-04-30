onerror {resume}
quietly virtual signal -install /cpu_v1_tb/MAIN { /cpu_v1_tb/MAIN/CONTROL(9 downto 8)} Jump
quietly virtual signal -install /cpu_v1_tb/MAIN { /cpu_v1_tb/MAIN/CONTROL(12 downto 10)} Jump001
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/PC
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/ADDR
add wave -noupdate -radix hexadecimal /cpu_v1_tb/MAIN/INSTRUCTION
add wave -noupdate /cpu_v1_tb/MAIN/Interrupt_CPU
add wave -noupdate /cpu_v1_tb/MAIN/Interrupt_latch
add wave -noupdate /cpu_v1_tb/MAIN/MEMCNT/InterruptDriver/Interrupt_btn
add wave -noupdate /cpu_v1_tb/MAIN/MEMCNT/InterruptDriver/Interrupt_btn_reset
add wave -noupdate /cpu_v1_tb/MAIN/clk
add wave -noupdate /cpu_v1_tb/MAIN/MEMCNT/ButtonDriver/btn
add wave -noupdate /cpu_v1_tb/MAIN/MEMCNT/ButtonDriver/dbtn
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/ALU/Operand1
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/ALU/Operand2
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/ALU/Operation
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/ALU/Result
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/REGS/REG(6)
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/REGS/REG(5)
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/REGS/REG(4)
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/REGS/REG(3)
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/REGS/REG(2)
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/REGS/REG(1)
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/Sevensegdriver/dat
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(2)
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(1)
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/PC_ALT
add wave -noupdate /cpu_v1_tb/MAIN/JMP_SELECT
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1057154 ps} 0}
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
WaveRestoreZoom {1022944 ps} {1085162 ps}
