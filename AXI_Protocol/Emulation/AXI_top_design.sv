

module AXI_top_design(
	input	logic	clk,
	input	logic	resetn,

input logic [31:0]  awaddr,
input logic [3:0]   awlen,
input logic	[3:0]   wstrb,
input logic	[2:0]	awsize,
input logic	[1:0]	awburst,
input logic	[31:0]	wdata,
input logic	[3:0]	awid,

input logic	[31:0]	araddr,
input logic	[3:0]	arid,
input logic	[3:0]	arlen,
input logic	[2:0]	arsize,
input logic	[1:0]	arburst,

//viewing inputs of slave at testbench as output.
output logic		AWVALID_tb_s,
output logic	[1:0]	AWBURST_tb_s,
output logic	[2:0]	AWSIZE_tb_s,
output logic	[3:0]	AWLEN_tb_s,
output logic	[31:0]	AWADDR_tb_s,
output logic	[3:0]	AWID_tb_s,
output logic		WVALID_tb_s,
output logic		WLAST_tb_s,
output logic	[3:0]	WSTRB_tb_s,
output logic	[31:0]	WDATA_tb_s,
output logic	[3:0]	WID_tb_s,
output logic		BREADY_tb_s,
output logic	[3:0]	ARID_tb_s,
output logic	[31:0]	ARADDR_tb_s,
output logic	[3:0]	ARLEN_tb_s,
output logic	[2:0]	ARSIZE_tb_s,
output logic	[1:0]	ARBURST_tb_s,
output logic	        ARVALID_tb_s,
output logic		RREADY_tb_s,

//viewing inputs of master at testbench as output.
output logic		AWREADY_tb_m,
output logic		WREADY_tb_m,
output logic	[3:0]	BID_tb_m,
output logic	[1:0]	BRESP_tb_m,
output logic		BVALID_tb_m,
output logic		ARREADY_tb_m,
output logic	[3:0]	RID_tb_m,
output logic	[31:0]	RDATA_tb_m,
output logic	[1:0]	RRESP_tb_m,
output logic		RLAST_tb_m,
output logic		RVALID_tb_m

);

//interface declaration
axi bus();



logic		    AWREADY;
logic		    AWVALID;
logic	[1:0]	AWBURST;
logic	[2:0]	AWSIZE;
logic	[3:0]	AWLEN;
logic	[31:0]	AWADDR;
logic	[3:0]	AWID;

// DATA WRITE CHANNEL
logic		    WREADY;
logic		    WVALID;
logic		    WLAST;
logic	[3:0]	WSTRB;
logic	[31:0]	WDATA;
logic	[3:0]	WID;

// WRITE RESPONSE CHANNEL
logic	[3:0]	BID;
logic	[1:0]	BRESP;
logic		    BVALID;
logic		    BREADY;

// READ ADDRESS CHANNEL
logic		    ARREADY;
logic	[3:0]	ARID;
logic	[31:0]	ARADDR;
logic	[3:0]	ARLEN;
logic	[2:0]	ARSIZE;
logic	[1:0]	ARBURST;
logic		    ARVALID;

// READ DATA CHANNEL
logic	[3:0]	RID;
logic	[31:0]	RDATA;
logic	[1:0]	RRESP;
logic		    RLAST;
logic		    RVALID;
logic		    RREADY;



AXI_master master_inst(
	// GLOBAL SIGNALS
			.clk(clk),
			.resetn(resetn),
			.axim(bus),
			
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
            
         
//slave(output) to master(input) signals for verifying.
            .AWREADY_tb_m(AWREADY_tb_m), 
            .WREADY_tb_m(WREADY_tb_m), 
            .BID_tb_m(BID_tb_m), 
            .BRESP_tb_m(BRESP_tb_m), 
            .BVALID_tb_m(BVALID_tb_m), 
            .ARREADY_tb_m(ARREADY_tb_m), 
            .RID_tb_m(RID_tb_m), 
            .RDATA_tb_m(RDATA_tb_m), 
            .RRESP_tb_m(RRESP_tb_m), 
            .RLAST_tb_m(RLAST_tb_m), 
            .RVALID_tb_m(RVALID_tb_m)


);
			
			
AXI_slave slave_inst(.clk(clk),
			.resetn(resetn),
			.axis(bus),
		
//master(output) to slave(input) signals for verifying.        
            .AWVALID_tb_s(AWVALID_tb_s), 
            .AWBURST_tb_s(AWBURST_tb_s), 
            .AWSIZE_tb_s(AWSIZE_tb_s), 
            .AWLEN_tb_s(AWLEN_tb_s), 
            .AWADDR_tb_s(AWADDR_tb_s), 
            .AWID_tb_s(AWID_tb_s),
            .WVALID_tb_s(WVALID_tb_s), 
            .WLAST_tb_s(WLAST_tb_s), 
            .WSTRB_tb_s(WSTRB_tb_s), 
            .WDATA_tb_s(WDATA_tb_s), 
            .WID_tb_s(WID_tb_s),  
            .BREADY_tb_s(BREADY_tb_s), 
            .ARID_tb_s(ARID_tb_s), 
            .ARADDR_tb_s(ARADDR_tb_s), 
            .ARLEN_tb_s(ARLEN_tb_s), 
            .ARSIZE_tb_s(ARSIZE_tb_s), 
            .ARBURST_tb_s(ARBURST_tb_s), 
            .ARVALID_tb_s(ARVALID_tb_s), 
            .RREADY_tb_s(RREADY_tb_s)
);



endmodule	
