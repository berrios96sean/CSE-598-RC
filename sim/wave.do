onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lab1_tb/clk
add wave -noupdate /lab1_tb/i_ready
add wave -noupdate /lab1_tb/i_valid
add wave -noupdate /lab1_tb/i_x
add wave -noupdate /lab1_tb/o_ready
add wave -noupdate /lab1_tb/o_valid
add wave -noupdate /lab1_tb/o_y
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1966870546 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 177
configure wave -valuecolwidth 40
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
WaveRestoreZoom {0 ps} {728974751400 ps}
