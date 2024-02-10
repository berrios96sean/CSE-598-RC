cd ~/repos/lab1/sim/
vlib work 
vlog ../srcs/lab1.v 
vlog ../srcs/lab1_tb.v 
vsim work.lab1_tb -voptargs=+acc

do ./wave.do

run -all



