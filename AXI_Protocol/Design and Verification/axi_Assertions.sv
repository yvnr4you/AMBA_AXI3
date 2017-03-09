`include"//khensu/Home06/anurag/Desktop/SV_AXI_finlly_final/AXI_Interface.sv"

module axi_Assertions(
input	logic	clk,
input	logic	resetn,
	
axi intf

);

//**************************** Write Address Channel *********************************************************

// WA MAster signals must remain stable when AWVALID is asserted and AWREADY is low.

property AXI_WAMAster_STABLE_p;
@(posedge clk)	
		(intf.AWVALID && !intf.AWREADY)|=> ($stable(intf.AWID) && $stable(intf.AWADDR) && $stable(intf.AWLEN) && $stable(intf.AWSIZE) && $stable(intf.AWBURST)); 
		
endproperty

// WA Master signals must not be undefined when AWVALID is asserted

property AXI_AWID_X_p;
@(posedge clk)
		disable iff (!resetn)
		(intf.AWVALID) |-> (!$isunknown(intf.AWID) && !$isunknown(intf.AWADDR) && !$isunknown(intf.AWLEN) && !$isunknown(intf.AWSIZE) && !$isunknown(intf.AWBURST));
endproperty

// AWLEN should have value 2, 4, 8, 16 in case of wrapping burst.

property AXI_AWLEN_WRAP_p;
@(posedge clk)
disable iff (!resetn)
		(intf.AWBURST == 2'b10) |-> (intf.AWLEN == 4'b1 || intf.AWLEN == 4'b0011 || intf.AWLEN == 4'b0111 || intf.AWLEN == 4'b1111);
endproperty

// size of data transfer must not exceed the width of data interface

property AXI_AWSIZE_p;
@(posedge clk)
		##1 intf.AWSIZE < 3'b011;
		
endproperty

// AWBURST cannot be 2'b11	

property AXI_AWBURST_p;
@(posedge clk)
		##1 intf.AWBURST != 2'b11;
endproperty

// when awvalid is asserted, then it remains asserted until awready is high

property AXI_AWVALID_AWREADY_p;
@(posedge clk)
	(intf.AWVALID && !intf.AWREADY) |=>  (intf.AWVALID &&intf.AWREADY) ##1 (!intf.AWVALID && !intf.AWREADY);
endproperty

// AWVALID and AWREADY cannot be x unless resetn
property AXI_AWVALID_AWREADY_X_p;
@(posedge clk)
		resetn|=>!$isunknown(intf.AWVALID) && !$isunknown(intf.AWREADY);
endproperty


AXI_WAMAster_STABLE_a: assert property(AXI_WAMAster_STABLE_p);	
AXI_AWID_X_a: assert property(AXI_AWID_X_p);
AXI_AWLEN_WRAP_a: assert property(AXI_AWLEN_WRAP_p);
AXI_AWSIZE_a: assert property(AXI_AWSIZE_p);
AXI_AWBURST_a: assert property(AXI_AWBURST_p);
AXI_AWVALID_AWREADY_a: assert property(AXI_AWVALID_AWREADY_p);
AXI_AWVALID_AWREADY_X_a: assert property(AXI_AWVALID_AWREADY_X_p);

// Write Data Channel Assertions
// When WVALID is asserted WID and AWID should match
property AXI_WVALID_WID_p;
@(posedge clk)
		intf.WVALID |=> (intf.WID == intf.AWID);
endproperty

// When WVALID is asserted and WREADY is not asserted WDATA, WSTRB,WLAST,WID should remain stable
property AXI_WVALID_STABLE_p;
@(posedge clk)
		(intf.WVALID && !intf.WREADY) |=> ($stable(intf.WDATA) && $stable(intf.WSTRB) && $stable(intf.WID)); 
endproperty

// When WVALID is asserted and WREADY is not asserted WDATA, WSTRB,WLAST,WID should not have any X's or Z's
property AXI_WVALID_X_p;
@(posedge clk)
		##1 (intf.WVALID) |=> (!$isunknown(intf.WDATA) && !$isunknown(intf.WSTRB) && !$isunknown(intf.WID)); 
endproperty

// After WVALID is asserted WREADY becomes 1 after 1 clock cycle
property AXI_WVALID_WREADY_p;
@(posedge clk)
		(intf.WVALID && !intf.WREADY) |=>  (intf.WVALID &&intf.WREADY) ##1 (!intf.WVALID && !intf.WREADY);
endproperty


// Transfer size and strobe must be valid combination
property AXI_SIZE_STRB_p;
@(posedge clk)
		disable iff ($countones(intf.WSTRB) == 0)
		##1 ($countones(intf.WSTRB) < 3) ? (($countones(intf.WSTRB) != 1) ? (intf.AWSIZE == 2 || intf.AWSIZE == 1) : (intf.AWSIZE == 2 || intf.AWSIZE == 1 || intf.AWSIZE == 0)) : intf.AWSIZE == 2 ;
endproperty


AXI_WVALID_WID_a: assert property (AXI_WVALID_WID_p);
AXI_WVALID_STABLE_a: assert property (AXI_WVALID_STABLE_p);
AXI_WVALID_X_a: assert property (AXI_WVALID_X_p);
AXI_WVALID_WREADY_a: assert property (AXI_WVALID_WREADY_p);
AXI_SIZE_STRB_a: assert property (AXI_SIZE_STRB_p);


// Assertions for Write Response Channel
property AXI_BVALID_BID_p;
@(posedge clk)
		intf.BVALID |=> (intf.BID == intf.AWID);
endproperty

property AXI_BVALID_BRESP_p;
@(posedge clk)
 		##1 intf.BVALID |=> $stable(intf.BRESP);
endproperty

// After BVALID is asserted BREADY becomes 1 after 1 clock cycle
property AXI_BVALID_BREADY_p;
@(posedge clk)
		(intf.BVALID && !intf.BREADY) |=>  (intf.BVALID &&intf.BREADY) ##1 (!intf.BVALID && !intf.BREADY);
endproperty

// After WLAST is asserted, slave should initiate response
property AXI_WLAST_BVALID_p;
@(posedge clk)
		intf.WLAST |=> intf.BVALID;
endproperty


AXI_BVALID_BID_a: assert property (AXI_BVALID_BID_p);
AXI_BVALID_BRESP_a: assert property (AXI_BVALID_BRESP_p);
AXI_BVALID_BREADY_a: assert property (AXI_BVALID_BREADY_p);
AXI_WLAST_BVALID_a: assert property (AXI_WLAST_BVALID_p);


// Read Address Channel Assertions
// When WVALID is asserted and WREADY is not asserted WDATA, WSTRB,WLAST,WID should remain stable
property AXI_ARVALID_STABLE_p;
@(posedge clk)
		(intf.ARVALID && !intf.ARREADY) |=> ($stable(intf.ARID) && $stable(intf.ARADDR) && $stable(intf.ARLEN) && $stable(intf.ARSIZE) && $stable(intf.ARBURST)); 
endproperty

// When not reset X on ARVALID, ARREADY is not permitted
property AXI_ARVALID_ARREADY_X_p;
@(posedge clk)
		(resetn)|=> (!$isunknown(intf.ARVALID) && !$isunknown(intf.ARREADY));
endproperty


// After ARVALID is asserted ARREADY becomes 1 after 1 clock cycle
property AXI_ARVALID_ARREADY_p;
@(posedge clk)
		(intf.ARVALID && !intf.ARREADY) |=>  (intf.ARVALID &&intf.ARREADY) ##1 (!intf.ARVALID && !intf.ARREADY);
endproperty


AXI_ARVALID_STABLE_a: assert property (AXI_ARVALID_STABLE_p);
AXI_ARVALID_ARREADY_X_a: assert property (AXI_ARVALID_ARREADY_X_p);
AXI_ARVALID_ARREADY_a: assert property (AXI_ARVALID_ARREADY_p);

//Read Data Channel Assertions
//When RVALID is asserted 
property AXI_RVALID_RID_p;
@(posedge clk)
		intf.RVALID |=> (intf.RID == intf.ARID);
endproperty

property AXI_RVALID_STABLE_p;
@(posedge clk)
		(intf.RVALID && !intf.RREADY) |=> ($stable(intf.RID) && $stable(intf.RDATA) && $stable(intf.RRESP)); 
endproperty

// When not reset X on RVALID, RREADY is not permitted
property AXI_RVALID_RREADY_X_p;
@(posedge clk)
		(resetn)|=> (!$isunknown(intf.RVALID) && !$isunknown(intf.RREADY));
endproperty

// After RVALID is asserted RREADY becomes 1 after 1 clock cycle
property AXI_RVALID_RREADY_p;
@(posedge clk)
		(intf.RVALID && !intf.RREADY) |=>  (intf.RVALID &&intf.RREADY) ##1 (!intf.RVALID && !intf.RREADY);
endproperty


AXI_RVALID_RID_a: assert property (AXI_RVALID_RID_p);
AXI_RVALID_STABLE_a: assert property (AXI_RVALID_STABLE_p);
AXI_RVALID_RREADY_X_a: assert property (AXI_RVALID_RREADY_X_p);
AXI_RVALID_RREADY_a: assert property (AXI_RVALID_RREADY_p);


endmodule
		