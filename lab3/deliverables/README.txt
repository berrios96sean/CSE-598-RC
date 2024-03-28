For each directory we have each part in a seperate folder e.g. part1, part2, part3

to re-run vtr cd into the directory for the part you want to run 

once in the directory you can use the run_vtr_task.py method to run each task. 
we have seperated out each task and their config files in seperate directories 
for example part three we have routing_alu_1 and routing_alu_2. Here the first 
directory is the first part for the routing study and the second directory is
repeat of step one with --astar_fac set to 0. 

NOTE: the directory for the architecture and config files need to be updated to work correctly 
right now they are pointing to an exact location where we ran them locally. 

EX. 

cd part3/ 
/packages/apps/vtr/8.0.0-git/vtr_flow/scripts/run_vtr_task.py routing_alu_1/ 
