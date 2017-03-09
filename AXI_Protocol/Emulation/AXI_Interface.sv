
interface axi;
// pragma attribute axi partition_interface_xif

//logic		 resetn;
logic		AWREADY;
logic		AWVALID;
logic	[1:0]	AWBURST;
logic	[2:0]	AWSIZE;
logic	[3:0]	AWLEN;
logic	[31:0]	AWADDR;
logic	[3:0]	AWID;

// DATA WRITE CHANNEL
logic		WREADY;
logic		WVALID;
logic		WLAST;
logic	[3:0]	WSTRB;
logic	[31:0]	WDATA;
logic	[3:0]	WID;

// WRITE RESPONSE CHANNEL
logic	[3:0]	BID;
logic	[1:0]	BRESP;
logic		BVALID;
logic		BREADY;

// READ ADDRESS CHANNEL
logic		ARREADY;
logic	[3:0]	ARID;
logic	[31:0]	ARADDR;
logic	[3:0]	ARLEN;
logic	[2:0]	ARSIZE;
logic	[1:0]	ARBURST;
logic		ARVALID;

// READ DATA CHANNEL
logic	[3:0]	RID;
logic	[31:0]	RDATA;
logic	[1:0]	RRESP;
logic		RLAST;
logic		RVALID;
logic		RREADY;



modport master(
	//input	resetn,
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
