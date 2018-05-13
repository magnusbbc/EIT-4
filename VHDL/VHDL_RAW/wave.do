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
add wave -noupdate -label {Dram Address} -radix unsigned /cpu_v1_tb/MAIN/dram_address_index
add wave -noupdate -label {Dram Out} -radix unsigned /cpu_v1_tb/MAIN/dram_data_out
add wave -noupdate -label {Dram In} -radix unsigned /cpu_v1_tb/MAIN/dram_data_in
add wave -noupdate -label Registers -radix unsigned /cpu_v1_tb/MAIN/REGS/reg
add wave -noupdate -divider {Peripheral Control}
add wave -noupdate -label {Seven Seg Data} -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/SevenSegmentDisplayDriver/input_data
add wave -noupdate -label BTN -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/ButtonDriver/btn
add wave -noupdate -label BTN_INT /cpu_v1_tb/MAIN/MEMCNT/ButtonDriver/interrupt_on
add wave -noupdate -label I2S_INT /cpu_v1_tb/MAIN/MEMCNT/I2SMonoIn/interrupt
add wave -noupdate -divider {Interrupt Controller}
add wave -noupdate -label INT_CPU -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/InterruptDriver/interrupt_cpu
add wave -noupdate -label LOCAL_INT_BTN /cpu_v1_tb/MAIN/MEMCNT/InterruptDriver/interrupt_btn
add wave -noupdate -label LOCAL_INT_i2S /cpu_v1_tb/MAIN/MEMCNT/InterruptDriver/interrupt_i2s
add wave -noupdate -label INT_ENABLE /cpu_v1_tb/MAIN/MEMCNT/InterruptDriver/interrupt_enable
add wave -noupdate -label INT_NEST_ENABLE /cpu_v1_tb/MAIN/MEMCNT/InterruptDriver/interrupt_nest_enable
add wave -noupdate -label {Interrupt Address} -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/interrupt_address
add wave -noupdate -label INT_Regs -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/InterruptDriver/REG
add wave -noupdate -divider Filter
add wave -noupdate -label reset -radix decimal /cpu_v1_tb/MAIN/FIR/reset
add wave -noupdate -label load_input -radix decimal /cpu_v1_tb/MAIN/FIR/load_system_input
add wave -noupdate -label {system input} -radix decimal /cpu_v1_tb/MAIN/FIR/system_input
add wave -noupdate -label coefficient_in -radix decimal /cpu_v1_tb/MAIN/FIR/coefficient_in
add wave -noupdate -label Coefficients -radix decimal /cpu_v1_tb/MAIN/FIR/coefficient_array
add wave -noupdate -label system_out -radix decimal /cpu_v1_tb/MAIN/FIR/system_output
add wave -noupdate -label {product array} -radix decimal /cpu_v1_tb/MAIN/FIR/product_array
add wave -noupdate -label {adder array} -radix decimal /cpu_v1_tb/MAIN/FIR/adder_array
add wave -noupdate -label {Temp Input} -radix decimal /cpu_v1_tb/MAIN/FIR/input_data_temp
add wave -noupdate -label {Full output} -radix decimal /cpu_v1_tb/MAIN/FIR/full_output
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {644498 ps} 0}
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
WaveRestoreZoom {602911 ps} {707923 ps}
