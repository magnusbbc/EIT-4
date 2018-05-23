onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Status
add wave -noupdate -label {Clock Count} /cpu_v1_tb/cnt
add wave -noupdate -label {Sys Clock} /cpu_v1_tb/TbClock
add wave -noupdate -label PC -radix unsigned /cpu_v1_tb/MAIN/PC
add wave -noupdate -label {Pram Address Index} -radix unsigned /cpu_v1_tb/MAIN/pram_address_index
add wave -noupdate -label PC_ALT -radix unsigned /cpu_v1_tb/MAIN/PC_ALT
add wave -noupdate -label PRAM_OUT -radix hexadecimal /cpu_v1_tb/MAIN/pram_data_out
add wave -noupdate -divider Peripheral
add wave -noupdate -label BTN_RAW /cpu_v1_tb/btn
add wave -noupdate -label LED /cpu_v1_tb/led
add wave -noupdate -label {Word Select In} /cpu_v1_tb/wsIn
add wave -noupdate -label {I2S Data In} /cpu_v1_tb/I2SDataIn
add wave -noupdate -label {I2S Counter} /cpu_v1_tb/I2SCnt
add wave -noupdate -divider Main
add wave -noupdate -label ALU_Out -radix unsigned /cpu_v1_tb/MAIN/alu_output
add wave -noupdate -label {ALU Operand A} -radix unsigned /cpu_v1_tb/MAIN/operand_a
add wave -noupdate -label {ALU Operand B} -radix unsigned /cpu_v1_tb/MAIN/operand_b
add wave -noupdate -label {Processing Output} -radix unsigned /cpu_v1_tb/MAIN/processing_output
add wave -noupdate -label Registers -radix unsigned /cpu_v1_tb/MAIN/REGS/reg
add wave -noupdate /cpu_v1_tb/MAIN/parity_flag
add wave -noupdate /cpu_v1_tb/MAIN/signed_flag
add wave -noupdate /cpu_v1_tb/MAIN/overflow_flag
add wave -noupdate /cpu_v1_tb/MAIN/zero_flag
add wave -noupdate /cpu_v1_tb/MAIN/carry_flag
add wave -noupdate /cpu_v1_tb/MAIN/parity_flag_latch
add wave -noupdate /cpu_v1_tb/MAIN/signed_flag_latch
add wave -noupdate /cpu_v1_tb/MAIN/overflow_flag_latch
add wave -noupdate /cpu_v1_tb/MAIN/zero_flag_latch
add wave -noupdate /cpu_v1_tb/MAIN/carry_flag_latch
add wave -noupdate /cpu_v1_tb/MAIN/control_signals
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {211933106 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 404
configure wave -valuecolwidth 116
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
WaveRestoreZoom {211843706 ps} {212013490 ps}
