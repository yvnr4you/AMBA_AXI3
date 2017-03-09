`include"//khensu/Home06/anurag/Desktop/SV_AXI_finlly_final/axi_driver.sv"
`include"//khensu/Home06/anurag/Desktop/SV_AXI_finlly_final/AXI_Interface.sv"
`include"//khensu/Home06/anurag/Desktop/SV_AXI_finlly_final/axi_env.sv"
`include"//khensu/Home06/anurag/Desktop/SV_AXI_finlly_final/axi_scoreboard_update.sv"
`include"//khensu/Home06/anurag/Desktop/SV_AXI_finlly_final/axi_Assertions.sv"
`include"//khensu/Home06/anurag/Desktop/SV_AXI_finlly_final/AXI_top_design.sv"

module top(); 
timeunit 1ns;
timeprecision 100ps;

   environment env; 
   Scoreboard sb;
logic clk; 
logic resetn;
logic [4095:0][7:0] slave_mem;
logic [4095:0][7:0] master_mem;

bit [31:0] awaddr;
bit [3:0]   awlen;
bit	[3:0] wstrb;
bit	[2:0]	awsize;
bit	[1:0]	awburst;
bit	[31:0]	wdata;
bit	[3:0]	awid;

bit	[31:0]	araddr;
bit	[3:0]	arid;
bit	[3:0]	arlen;
bit	[2:0]	arsize;
bit	[1:0]	arburst;




   
initial begin
clk ='1;
forever #5 clk = ~clk;
end			

// Interface instance
   axi intf();
	driver drvr=new(intf);
	testcase test(intf);

// Top design instance
 
AXI_top_design #(.WIDTH(32),.SIZE(3))
	top_inst	(.clk(clk),
				 .resetn(resetn),
				 .slave_mem(slave_mem),
				 .master_mem(master_mem),
				.awaddr(awaddr),
				.awlen(awlen),
				.wstrb(wstrb),
				.awsize(awsize),
				.awburst(awburst),
				.wdata(wdata),
				.awid(awid),
				.araddr(araddr),
				.arid(arid),
				.arlen(arlen),
				.arsize(arsize),
				.arburst(arburst),
				 .intf(intf)
				//inp_intf(inintf)
);


// Binding the assertions module with the dut.
bind AXI_top_design axi_Assertions  axi_b(clk,resetn,intf);
endmodule

			
