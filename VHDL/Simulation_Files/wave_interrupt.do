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
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(6)
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(5)
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(4)
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(3)
add wave -noupdate -label {M2
} -radix unsigned -childformat {{/cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(2)(15) -radix unsigned} {/cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(2)(14) -radix unsigned} {/cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(2)(13) -radix unsigned} {/cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(2)(12) -radix unsigned} {/cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(2)(11) -radix unsigned} {/cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(2)(10) -radix unsigned} {/cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(2)(9) -radix unsigned} {/cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(2)(8) -radix unsigned} {/cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(2)(7) -radix unsigned} {/cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(2)(6) -radix unsigned} {/cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(2)(5) -radix unsigned} {/cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(2)(4) -radix unsigned} {/cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(2)(3) -radix unsigned} {/cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(2)(2) -radix unsigned} {/cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(2)(1) -radix unsigned} {/cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(2)(0) -radix unsigned}} -subitemconfig {/cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(2)(15) {-height 15 -radix unsigned} /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(2)(14) {-height 15 -radix unsigned} /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(2)(13) {-height 15 -radix unsigned} /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(2)(12) {-height 15 -radix unsigned} /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(2)(11) {-height 15 -radix unsigned} /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(2)(10) {-height 15 -radix unsigned} /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(2)(9) {-height 15 -radix unsigned} /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(2)(8) {-height 15 -radix unsigned} /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(2)(7) {-height 15 -radix unsigned} /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(2)(6) {-height 15 -radix unsigned} /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(2)(5) {-height 15 -radix unsigned} /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(2)(4) {-height 15 -radix unsigned} /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(2)(3) {-height 15 -radix unsigned} /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(2)(2) {-height 15 -radix unsigned} /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(2)(1) {-height 15 -radix unsigned} /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(2)(0) {-height 15 -radix unsigned}} /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(2)
add wave -noupdate -label {M1
} -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(1)
add wave -noupdate -label {M0
} -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/MemoryDriver/RAM(0)
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/REGS/REG(5)
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/REGS/REG(2)
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/Sevensegdriver/dat
add wave -noupdate -divider MemController
add wave -noupdate -label Address -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/Address
add wave -noupdate -label WE /cpu_v1_tb/MAIN/MEMCNT/WE
add wave -noupdate -label RE /cpu_v1_tb/MAIN/MEMCNT/RE
add wave -noupdate -label DI -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/DI
add wave -noupdate -label DO -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/DO
add wave -noupdate -divider Button
add wave -noupdate /cpu_v1_tb/MAIN/MEMCNT/InterruptDriver/Interrupt_btn
add wave -noupdate /cpu_v1_tb/MAIN/MEMCNT/InterruptDriver/Interrupt_btn_off
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/InterruptDriver/Control
add wave -noupdate /cpu_v1_tb/MAIN/MEMCNT/InterruptDriver/Interrupt_cpu
add wave -noupdate /cpu_v1_tb/MAIN/MEMCNT/ButtonDriver/interrupt_on
add wave -noupdate /cpu_v1_tb/MAIN/MEMCNT/ButtonDriver/interrupt_off
add wave -noupdate /cpu_v1_tb/MAIN/MEMCNT/ButtonDriver/int_toggle
add wave -noupdate /cpu_v1_tb/MAIN/MEMCNT/ButtonDriver/dbtn
add wave -noupdate /cpu_v1_tb/MAIN/Interrupt_latch
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/PC_ALT
add wave -noupdate /cpu_v1_tb/MAIN/JMP_SELECT
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {303758 ps} 0}
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
WaveRestoreZoom {267301 ps} {333933 ps}
