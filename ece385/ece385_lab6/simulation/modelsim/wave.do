onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/S
add wave -noupdate /testbench/Clk
add wave -noupdate /testbench/Reset
add wave -noupdate /testbench/Run
add wave -noupdate /testbench/Continue
add wave -noupdate /testbench/LED
add wave -noupdate /testbench/HEX0
add wave -noupdate /testbench/HEX1
add wave -noupdate /testbench/HEX2
add wave -noupdate /testbench/HEX3
add wave -noupdate /testbench/HEX4
add wave -noupdate /testbench/HEX5
add wave -noupdate /testbench/HEX6
add wave -noupdate /testbench/HEX7
add wave -noupdate /testbench/CE
add wave -noupdate /testbench/UB
add wave -noupdate /testbench/LB
add wave -noupdate /testbench/OE
add wave -noupdate /testbench/WE
add wave -noupdate -radix hexadecimal /testbench/ADDR
add wave -noupdate -radix hexadecimal /testbench/Data
add wave -noupdate -label hex_4 -radix hexadecimal /testbench/lab6/my_slc/hex_4
add wave -noupdate -label state /testbench/lab6/my_slc/state_controller/State
add wave -noupdate -label reg_array -radix hexadecimal /testbench/lab6/my_slc/d0/reg_file/reg_file/reg_array
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1344756 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 143
configure wave -valuecolwidth 100
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
configure wave -timelineunits ns
update
WaveRestoreZoom {1195963 ps} {1451213 ps}
