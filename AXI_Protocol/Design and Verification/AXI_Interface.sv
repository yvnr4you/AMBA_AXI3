
interface axi#(parameter WIDTH=32, SIZE=3);

//logic		 resetn;
logic		AWREADY;
logic		AWVALID;
logic	[SIZE-2:0]	AWBURST;
logic	[SIZE-1:0]	AWSIZE;
logic	[(WIDTH/8)-1:0]	AWLEN;
logic	[WIDTH-1:0]	AWADDR;
logic	[(WIDTH/8)-1:0]	AWID;

// DATA WRITE CHANNEL
logic		WREADY;
logic		WVALID;
logic		WLAST;
logic	[(WIDTH/8)-1:0]	WSTRB;
logic	[WIDTH:0]	WDATA;
logic	[(WIDTH/8)-1:0]	WID;

// WRITE RESPONSE CHANNEL
logic	[(WIDTH/8)-1:0]	BID;
logic	[SIZE-2:0]	BRESP;
logic		BVALID;
logic		BREADY;

// READ ADDRESS CHANNEL
logic		ARREADY;
logic	[(WIDTH/8)-1:0]	ARID;
logic	[WIDTH-1:0]	ARADDR;
logic	[(WIDTH/8)-1:0]	ARLEN;
logic	[SIZE-1:0]	ARSIZE;
logic	[SIZE-2:0]	ARBURST;
logic		ARVALID;

// READ DATA CHANNEL
logic	[(WIDTH/8)-1:0]	RID;
logic	[WIDTH-1:0]	RDATA;
logic	[SIZE-2:0]	RRESP;
logic		RLAST;
logic		RVALID;
logic		RREADY;



modport master(
	//input 	clk,
	//input	resetn,
	
// ADDRESS WRITE CHANNEL	
	input	AWREADY,
	output	AWVALID,
	output	AWBURST,
	output	AWSIZE,
	output	AWLEN,
	output	AWADDR,
	output	AWID,
	
// DATA WRITE CHANNEL
	input	WREADY,
	output	WVALID,
	output	WLAST,
	output	WSTRB,
	output	WDATA,
	output	WID,
	
// WRITE RESPONSE CHANNEL
	input	BID,
	input	BRESP,
	input	BVALID,
	output	BREADY,

// READ ADDRESS CHANNEL
	input	ARREADY,
	output	ARID,
	output	ARADDR,
	output	ARLEN,
	output	ARSIZE,
	output	ARBURST,
	output	ARVALID,

// READ DATA CHANNEL
	input	RID,
	input	RDATA,
	input	RRESP,
	input	RLAST,
	input	RVALID,
	output	RREADY
);



modport slave(
	//input 	clk,
	//input	resetn,
	
// ADDRESS WRITE CHANNEL
	output	AWREADY,
	input	AWVALID,
	input	AWBURST,
	input	AWSIZE,
	input	AWLEN,
	input	AWADDR,
	input	AWID,

// DATA WRITE CHANNEL
	output	WREADY,
	input	WVALID,
	input	WLAST,
	input	WSTRB,
	input	WDATA,
	input	WID,

// WRITE RESPONSE CHANNEL
	output	BID,
	output	BRESP,
	output	BVALID,
	input	BREADY,

// READ ADDRESS CHANNEL
	output	ARREADY,
	input	ARID,
	input	ARADDR,
	input	ARLEN,
	input	ARSIZE,
	input	ARBURST,
	input	ARVALID,

// READ DATA CHANNEL
	output	RID,
	output	RDATA,
	output	RRESP,
	output	RLAST,
	output	RVALID,
	input	RREADY
);
endinterface
