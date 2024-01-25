# Including helpful commands to speed up workflow

# ex. format vsim -c -l 'logfile_name' -do "do 'tcl script' 'tcl script'" 

sim: 
	/packages/apps/fpga/Quartus_Pro/23.4/questa_fe/bin/vsim -gui -l simlog.log -do "do sim.tcl"

clean:
	rm -rf work/
	rm -rf *.txt
	rm -rf *.log
	rm -rf *.wlf
