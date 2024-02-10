# Including helpful commands to speed up workflow

# ex. format vsim -c -l 'logfile_name' -do "do 'tcl script' 'tcl script'" 
VERSION=baseline

# baseline sim is default. to run other sims use make sim VERSION='pipe' or make sim VERSION='shared' 
# before running a new sim, always use make clean to clean up the sim directory

sim: 
ifeq ($(VERSION),baseline)
	/packages/apps/fpga/Quartus_Pro/23.4/questa_fe/bin/vsim -gui -l simlog.log -do "do sim.tcl"
else ifeq ($(VERSION),pipe)
	/packages/apps/fpga/Quartus_Pro/23.4/questa_fe/bin/vsim -gui -l simlog_pipe.log -do "do sim_pipe.tcl"
else ifeq ($(VERSION),shared)
	/packages/apps/fpga/Quartus_Pro/23.4/questa_fe/bin/vsim -gui -l simlog_shared.log -do "do sim_shared.tcl"
else
	@echo "Invalid version parameter"
endif


clean:
	rm -rf work/
	rm -rf *.txt
	rm -rf *.log
	rm -rf *.wlf
