`include"//khensu/Home06/anurag/Desktop/SV_AXI_finlly_final/AXI_Interface.sv"


module AXI_top_design #(parameter WIDTH, SIZE)
	(
	input	logic	clk,
	input	logic	resetn,
	output logic [4095:0][7:0] slave_mem,
	output logic [4095:0][7:0] master_mem,
	axi intf,

// inputs to master from tb
input logic [WIDTH-1:0] awaddr,
input logic [(WIDTH/8)-1:0] awlen,
input logic	[(WIDTH/8)-1:0] wstrb,
input logic	[SIZE-1:0]	awsize,
input	logic	[SIZE-2:0]	awburst,
input logic	[WIDTH-1:0]	wdata,
input logic	[(WIDTH/8)-1:0]	awid,

input logic	[WIDTH-1:0]	araddr,
input logic	[(WIDTH/8)-1:0]	arid,
input logic	[(WIDTH/8)-1:0]	arlen,
input logic	[SIZE-1:0]	arsize,
input logic	[SIZE-2:0]	arburst
	
);





// Master instance

AXI_master #(.WIDTH(32),.SIZE(3))
master_inst		(	.clk(clk),
	    		.resetn(resetn),	
			.axim(intf),
		
			.read_mem(master_mem),
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
			.arburst(arburst)
);

// Slave instance

AXI_slave slave_inst(.clk(clk),
		     .resetn(resetn),
		     .axis(intf),
                     .slave_mem(slave_mem)
);


endmodule	
