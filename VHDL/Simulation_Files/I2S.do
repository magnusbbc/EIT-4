onerror {resume}
quietly virtual signal -install /cpu_v1_tb/MAIN { /cpu_v1_tb/MAIN/CONTROL(9 downto 8)} Jump
quietly virtual signal -install /cpu_v1_tb/MAIN { /cpu_v1_tb/MAIN/CONTROL(12 downto 10)} Jump001
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpu_v1_tb/wsIn
add wave -noupdate /cpu_v1_tb/I2SDataIn
add wave -noupdate /cpu_v1_tb/TbClockI2S
add wave -noupdate /cpu_v1_tb/I2SCnt
add wave -noupdate /cpu_v1_tb/MAIN/bclkO
add wave -noupdate /cpu_v1_tb/MAIN/wsO
add wave -noupdate /cpu_v1_tb/MAIN/DOut
add wave -noupdate /cpu_v1_tb/MAIN/MEMCNT/I2SMonoOut/int
add wave -noupdate /cpu_v1_tb/MAIN/MEMCNT/I2SMonoOut/intr
add wave -noupdate /cpu_v1_tb/MAIN/MEMCNT/I2SMonoOut/DIn_temp
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/WE
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/Address
add wave -noupdate -radix unsigned /cpu_v1_tb/MAIN/MEMCNT/DI
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {24831 ps} 0}
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
WaveRestoreZoom {0 ps} {124432 ps}
