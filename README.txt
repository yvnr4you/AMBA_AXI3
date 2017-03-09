The folder organization is as follows:

ECE571_Final_Project.zip
	|
	|---- README.txt
	|
	|---- AXI_Protocol_Report.pdf
	|	- It contains our presentation.
	|
	|---- AXI_Protocol
	|	|
	|	|
	|	|---- Design and Verification
	|	|	|
	|	|	|---- axi_Assertions.sv
	|	|	|
	|	|	|---- axi_driver.sv
	|	|	|
	|	|	|---- axi_env.sv
	|	|	|
	|	|	|---- AXI_Interface.sv
	|	|	|
	|	|	|---- AXI_Master.sv
	|	|	|
	|	|	|---- axi_monitor.sv
	|	|	|
	|	|	|---- axi_scoreboard_update.sv
	|	|	|
	|	|	|---- AXI_slave.sv
	|	|	|
	|	|	|---- axi_testcase.sv
	|	|	|
	|	|	|---- axi_top.sv
	|	|	|
	|	|	|---- AXI_top_design.sv	
	|	|
	|	|---- Emulation
	|	|	|
	|	|	|---- AXI_Interface.sv
	|	|	|
	|	|	|---- AXI_master.sv
	|	|	|
	|	|	|---- AXI_slave.sv
	|	|	|
	|	|	|---- AXI_top_design.sv
	|	|	|
	|	|	|---- Makefile
	|	|	|
	|	|	|---- run.do
	|	|	|
	|	|	|---- veloce
	|	|	|
	|	|	|---- view.do	
	|	|
	


Compilation/Simulation instructions:

For Task 1) Verification

1) Extract the contents of .zip file.
2) Create a new project in Questasim.
3) Add the files from Design and Verificatiion/ directory to the project.
4) Change the path of files those are `include in the modules.
4) Right click on Project window and select Compile all (All files are compiled successfully).
5) Go to the library window and open the work library(work is a by default name).
6) Right click on the testbench file(top.sv) and select the Simulate option.
7) After clicking on Simulate a sim window opens. Right click on the top file (top) and intf and select AddWave option.
8) The Wave window opens and all the signals are added to the wave.
9) Run the simulation and check the waveforms.


For Task 2) Emulation
1) Copy files into veloce login
2) Check if you have rwx permissions for all the files.
3) The terminal navigate to the directory where the files are present,and enter "make" command.
4) If you want to give other inputs and verify the design, make changes in run.do
5) Add all the input output signals in the timing setup while setting the clock.