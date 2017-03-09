
`ifndef drvr_sv
`define drvr_sv


class sti;
rand 	bit	[3:0]	rand_awid;
rand 	bit	[31:0]	rand_awaddr_valid;		// Valid write address
constraint c1{
	rand_awaddr_valid > 32'h5ff;
	rand_awaddr_valid <=32'hfff;
		}
rand	bit	[31:0]	rand_awaddr_readonly;		// Read-only address
constraint c2{
	rand_awaddr_readonly > 32'h1ff;
	rand_awaddr_readonly <= 32'h5ff;
		}
rand	bit	[31:0]	rand_awaddr_invalid;		// InValid write address
constraint c3{
	rand_awaddr_invalid <= 32'h1ff;
		}
rand	bit	[31:0]	rand_wdata;
rand	bit	[31:0]	rand_araddr_valid;		// Valid read address
constraint c4{
	rand_araddr_valid > 32'h1ff;
	rand_araddr_valid <= 32'hfff;
		}
rand	bit	[31:0]	rand_araddr_invalid;		// InValid read address	
constraint c5{
	rand_araddr_invalid <= 32'h1ff;
		}
rand 	bit	[3:0]	rand_arid;
	
endclass








class driver;

	sti val=new();
	virtual axi intf;
	
	function new(virtual axi intf);
		this.intf = intf;
	endfunction

	int	status;
	//logic resetn;	
	logic [3:0] STRB = '0;
	logic [3:0] p;
	int i,n;
	bit [1:0] b,x;
	bit [2:0] k,y;
	bit [3:0] j,l,z,s;
	task stimulus;
		output bit [3:0]	rand_awid;
		output bit [31:0]	rand_awaddr_valid;
		output bit [31:0]	rand_awaddr_invalid;
		output bit [31:0]	rand_awaddr_readonly;
		output bit [31:0]	rand_wdata;
		output bit [31:0]	rand_araddr_valid;
		output bit [31:0]	rand_araddr_invalid;
		output bit [3:0]	rand_arid;
						
		sti val					= 	new();
		status 					= 	val.randomize();
		rand_awid				=	val.rand_awid;
		rand_awaddr_valid		=	val.rand_awaddr_valid;
		rand_awaddr_invalid		=	val.rand_awaddr_invalid;
		rand_awaddr_readonly	=	val.rand_awaddr_readonly;
		rand_wdata		=	val.rand_wdata;
		rand_araddr_valid		=	val.rand_araddr_valid;
		rand_araddr_invalid		=	val.rand_araddr_invalid;
		rand_arid				=	val.rand_arid;
	
		$display("\nIn Driver:-");
	endtask
	



	task reset_enable;
		top.resetn   		=	1'b0;
		intf.AWREADY		=	'0; 
		intf.AWVALID		=	'0;
		intf.AWBURST		=	'0;
		intf.AWSIZE		=	'0;
		intf.AWLEN		=	'0;
		intf.AWADDR		=	'0;
		intf.AWID		=	'0;
		intf.WREADY		=	'0;
		intf.WVALID		=	'0;
		intf.WLAST		=	'0;
		intf.WSTRB		=	'0;
		intf.WDATA		=	'0;
		intf.WID		=	'0;
		intf.BID		=	'0;	
		intf.BRESP		=	'0;
		intf.BVALID		=	'0;
		intf.BREADY		=	'0;
		intf.ARREADY		=	'0;
		intf.ARID		=	'0;
		intf.ARADDR		=	'0;	
		intf.ARLEN		=	'0;
		intf.ARSIZE		=	'0;
		intf.ARBURST		=	'0;
		intf.ARVALID		=	'0;
		intf.RID		=	'0;
		intf.RDATA		=	'0;
		intf.RRESP		=	'0;
		intf.RLAST		=	'0;
		intf.RVALID		=	'0;
		intf.RREADY		=	'0;
		top.awaddr	=	'0;
		top.awid	=	'0;
		top.awsize	=	'0;
		top.awlen	=	'0;	
		top.wstrb	=	'0;
		top.awburst	=	'0;
		top.wdata	=	'0;
		top.arid	=	'0;	
		top.araddr	=	'0;
		top.arlen	=	'0;
		top.arsize	=	'0;
		top.arburst	=	'0;
		#10;
		top.resetn		=	1'b1;		
	endtask
	

////////////////////////////////////////////////////////////////////////////////////////
//                BASIC OPERATION 
//////////////////////////////////////////////////////////////////////////////////////// 

//////////////// VALID WRITE OPERATION //////////////////////////////////

task burst_write(input bit [3:0] rand_awid, input bit [31:0] rand_awaddr_valid, input bit [31:0] rand_awaddr_invalid, input bit [31:0] rand_awaddr_readonly, input bit [31:0] rand_wdata,  input bit [31:0] rand_araddr_valid, input bit [31:0] rand_araddr_invalid, input bit [3:0] rand_arid );
	
	
	for(b=2'b00;b<2'b11;b++) begin
			for(j=4'b1;j<=4'b1111;j++) begin
					STRB = STRB + j;
				if(STRB == 4'b0001 || STRB == 4'b0010 || STRB == 4'b0100 || STRB == 4'b1000) begin
					for(k='0;k<= 3'b010;k++) begin
							if(b!= 2'b10) begin
							for(l='0;l<=4'b1111;l++) begin			
								stimulus(rand_awid,rand_awaddr_valid,rand_awaddr_invalid,rand_awaddr_readonly,rand_wdata,rand_araddr_valid,rand_araddr_invalid,rand_arid);
									top.awid 		=	rand_awid;	
									top.awaddr 	=	rand_awaddr_valid;
									top.awburst	=	top.awburst + b;
									top.awsize	=	top.awsize + k;
									top.awlen	=	top.awlen + l;
									top.wstrb	=	STRB;		
									for(i='0;i<=top.awlen;i=i+4'b1) begin
										//if(i=='0)
											wait(intf.WVALID)
									stimulus(rand_awid,rand_awaddr_valid,rand_awaddr_invalid,rand_awaddr_readonly,rand_wdata,rand_araddr_valid,rand_araddr_invalid,rand_arid);
									top.wdata  = rand_wdata;
										wait(!intf.WVALID);
									end//i_for
										wait(intf.BREADY)
									top.awid 		=	'0;	
									top.awaddr 	=	'0;
									top.awburst	=	'0;
									top.awsize	=	'0;
									top.awlen	=	'0;
									top.wstrb	=	'0;				
										repeat(2) @(posedge top.clk);
						//	l=l+4'b1;
							end//AWLEN_for
							end
						else begin
							for(p=4'b0;p<=4'b0100;p++) begin	
									l=((2**(p))-1);	
								stimulus(rand_awid,rand_awaddr_valid,rand_awaddr_invalid,rand_awaddr_readonly,rand_wdata,rand_araddr_valid,rand_araddr_invalid,rand_arid);
									top.awid 		=	rand_awid;	
									top.awaddr 	=	rand_awaddr_valid;
									top.awburst	=	top.awburst + b;
									top.awsize	=	top.awsize + k;
									top.awlen	=	top.awlen + l;
									top.wstrb	=	STRB;		
									for(i='0;i<=top.awlen;i=i+4'b1) begin
							//if(i=='0)
											wait(intf.WVALID)
									stimulus(rand_awid,rand_awaddr_valid,rand_awaddr_invalid,rand_awaddr_readonly,rand_wdata,rand_araddr_valid,rand_araddr_invalid,rand_arid);
									top.wdata  = rand_wdata;
										wait(!intf.WVALID);

										//if(i!=intf.AWLEN)
										//repeat(3)@(posedge top.clk);
									//	stimulus(rand_awid,rand_awaddr_valid,rand_awaddr_invalid,rand_awaddr_readonly,rand_wdata,rand_araddr_valid,rand_araddr_invalid,rand_arid);
									end//i_for
										wait(intf.BREADY)
										repeat(2) @(posedge top.clk);
					//	l=l+4'b1;
							end//AWLEN_fo
						end//else
						k=k+3'b1;
						$display("k=%b , b=%b",k,b);
					end//AWSIZE_for
					//j=j+4'b1;
				end//if_WSTRB
				
				else if(STRB == 4'b0011 || STRB == 4'b0101 || STRB == 4'b0110 || STRB == 4'b1001 || STRB == 4'b1010 || STRB == 4'b1100) begin
					for(k=3'b1;k<= 3'b010;k++) begin
							if(b!= 2'b10) begin
							for(l='0;l<=4'b1111;l++) begin		
								stimulus(rand_awid,rand_awaddr_valid,rand_awaddr_invalid,rand_awaddr_readonly,rand_wdata,rand_araddr_valid,rand_araddr_invalid,rand_arid);
									top.awid 		=	rand_awid;	
									top.awaddr 	=	rand_awaddr_valid;
									top.awburst	=	top.awburst + b;
									top.awsize	=	top.awsize + k;
									top.awlen	=	top.awlen + l;
									top.wstrb	=	STRB;		
									for(i='0;i<=top.awlen;i=i+4'b1) begin
										//if(i=='0)
											wait(intf.WVALID)
									stimulus(rand_awid,rand_awaddr_valid,rand_awaddr_invalid,rand_awaddr_readonly,rand_wdata,rand_araddr_valid,rand_araddr_invalid,rand_arid);
									top.wdata  = rand_wdata;
										wait(!intf.WVALID);

										//if(i!=intf.AWLEN)
										//repeat(3)@(posedge top.clk);
									//	stimulus(rand_awid,rand_awaddr_valid,rand_awaddr_invalid,rand_awaddr_readonly,rand_wdata,rand_araddr_valid,rand_araddr_invalid,rand_arid);
									end//i_for
										wait(intf.BREADY)
										repeat(2) @(posedge top.clk);
						//	l=l+4'b1;
							end//AWLEN_for
							end
						else begin
							for(p=4'b1;p<=4'b0100;p++) begin	
									l=((2**(p))-1);	
								stimulus(rand_awid,rand_awaddr_valid,rand_awaddr_invalid,rand_awaddr_readonly,rand_wdata,rand_araddr_valid,rand_araddr_invalid,rand_arid);
									top.awid 		=	rand_awid;	
									top.awaddr 	=	rand_awaddr_valid;
									top.awburst	=	top.awburst + b;
									top.awsize	=	top.awsize + k;
									top.awlen	=	top.awlen + l;
									top.wstrb	=	STRB;		
									for(i='0;i<=top.awlen;i=i+4'b1) begin
										//if(i=='0)
											wait(intf.WVALID)
									stimulus(rand_awid,rand_awaddr_valid,rand_awaddr_invalid,rand_awaddr_readonly,rand_wdata,rand_araddr_valid,rand_araddr_invalid,rand_arid);
									top.wdata  = rand_wdata;
										wait(!intf.WVALID);

										//if(i!=intf.AWLEN)
										//repeat(3)@(posedge top.clk);
									//	stimulus(rand_awid,rand_awaddr_valid,rand_awaddr_invalid,rand_awaddr_readonly,rand_wdata,rand_araddr_valid,rand_araddr_invalid,rand_arid);
									end//i_for
										wait(intf.BREADY)
										repeat(2) @(posedge top.clk);
						//	l=l+4'b1;
							end//AWLEN_fo
						end//else
				//		k=k+3'b1;
					end//AWSIZE
				//	j=j+4'b1;
				end//else_if_WSTRB

				else if(STRB == 4'b0111 || STRB == 4'b1011 || STRB == 4'b1101 || STRB == 4'b1110 || STRB == 4'b1111) begin
					top.awsize = 3'b010;
					if(b!= 2'b10) begin
							for(l='0;l<=4'b1111;l++) begin		
								stimulus(rand_awid,rand_awaddr_valid,rand_awaddr_invalid,rand_awaddr_readonly,rand_wdata,rand_araddr_valid,rand_araddr_invalid,rand_arid);
									top.awid 		=	rand_awid;	
									top.awaddr 	=	rand_awaddr_valid;
									top.awburst	=	top.awburst + b;
									top.awsize	=	top.awsize + k;
									top.awlen	=	top.awlen + l;
									top.wstrb	=	STRB;		
									for(i='0;i<=top.awlen;i=i+4'b1) begin
										//if(i=='0)
											wait(intf.WVALID)
									stimulus(rand_awid,rand_awaddr_valid,rand_awaddr_invalid,rand_awaddr_readonly,rand_wdata,rand_araddr_valid,rand_araddr_invalid,rand_arid);
									top.wdata  = rand_wdata;
										wait(!intf.WVALID);

										//if(i!=intf.AWLEN)
										//repeat(3)@(posedge top.clk);
									//	stimulus(rand_awid,rand_awaddr_valid,rand_awaddr_invalid,rand_awaddr_readonly,rand_wdata,rand_araddr_valid,rand_araddr_invalid,rand_arid);
									end//i_for
										wait(intf.BREADY)
										repeat(2) @(posedge top.clk);
						//	l=l+4'b1;
							end//AWLEN_for
							end
						else begin
							for(p=4'b1;p<=4'b0100;p++) begin	
									l=((2**(p))-1);	
								stimulus(rand_awid,rand_awaddr_valid,rand_awaddr_invalid,rand_awaddr_readonly,rand_wdata,rand_araddr_valid,rand_araddr_invalid,rand_arid);
									top.awid 		=	rand_awid;	
									top.awaddr 	=	rand_awaddr_valid;
									top.awburst	=	top.awburst + b;
									top.awsize	=	top.awsize + k;
									top.awlen	=	top.awlen + l;
									top.wstrb	=	STRB;		
									for(i='0;i<=top.awlen;i=i+4'b1) begin
										//if(i=='0)
											wait(intf.WVALID)
									stimulus(rand_awid,rand_awaddr_valid,rand_awaddr_invalid,rand_awaddr_readonly,rand_wdata,rand_araddr_valid,rand_araddr_invalid,rand_arid);
									top.wdata  = rand_wdata;
										wait(!intf.WVALID);

										//if(i!=intf.AWLEN)
										//repeat(3)@(posedge top.clk);
									//	stimulus(rand_awid,rand_awaddr_valid,rand_awaddr_invalid,rand_awaddr_readonly,rand_wdata,rand_araddr_valid,rand_araddr_invalid,rand_arid);
									end//i_for
										wait(intf.BREADY)
										repeat(2) @(posedge top.clk);
						//	l=l+4'b1;
							end//AWLEN_fo
						end//else
				end//else_if_WSTRB
				//j=j+4'b1;
			end//WSTRB
		//b=b+2'b1;
	end//AWBURST_for	
endtask



//////////////////////////////// Valid Read Operation ///////////////////////////////////////////////////////

task burst_read(input bit [3:0] rand_awid, input bit [31:0] rand_awaddr_valid, input bit [31:0] rand_awaddr_invalid, input bit [31:0] rand_awaddr_readonly, input bit [31:0] rand_wdata,  input bit [31:0] rand_araddr_valid, input bit [31:0] rand_araddr_invalid, input bit [3:0] rand_arid );


for(x='0;x<2'b11;x++) begin
	for(y='0;y<=3'b010;y++) begin
		if(x!=2'b10) begin	
		for(z='0;z<=4'b1111;z++) begin
		stimulus(rand_awid,rand_awaddr_valid,rand_awaddr_invalid,rand_awaddr_readonly,rand_wdata,rand_araddr_valid,rand_araddr_invalid,rand_arid);	
			top.arid	=	4'b1;//rand_arid;	
			top.araddr	=	32'hc2c;//rand_araddr_valid;
			top.arburst	=	top.arburst + x;
			top.arsize	=	top.arsize + y;
			top.arlen	=	top.arlen + z;	
			wait (intf.RLAST)
			repeat(3) @(posedge top.clk);
		end//ARLEN
		end//if_x
		else begin
			for(p=4'b1;p<=4'b0100;p++) begin
			l=((2**(p))-1);	
			stimulus(rand_awid,rand_awaddr_valid,rand_awaddr_invalid,rand_awaddr_readonly,rand_wdata,rand_araddr_valid,rand_araddr_invalid,rand_arid);	
			top.arid	=	4'b1;//rand_arid;	
			top.araddr	=	32'hc2c;//rand_araddr_valid;
			top.arburst	=	top.arburst + x;
			top.arsize	=	top.arsize + y;
			top.arlen	=	top.arlen + l;	
			wait (intf.RLAST)
			repeat(3) @(posedge top.clk);
		end//ARLEN
		end//else	
	end//ARSIZE
end//ARBURST	

endtask


///////////////////////////////// Writing to a read only location //////////////////////////////////////////////////

task burst_write_readonly(input bit [3:0] rand_awid, input bit [31:0] rand_awaddr_valid, input bit [31:0] rand_awaddr_invalid, input bit [31:0] rand_awaddr_readonly, input bit [31:0] rand_wdata,  input bit [31:0] rand_araddr_valid, input bit [31:0] rand_araddr_invalid, input bit [3:0] rand_arid );

	for(n=0;n<10;n++) begin
	for(b=2'b00;b<2'b11;b++) begin
			stimulus(rand_awid,rand_awaddr_valid,rand_awaddr_invalid,rand_awaddr_readonly,rand_wdata,rand_araddr_valid,rand_araddr_invalid,rand_arid);
				top.awid 		=	rand_awid;
				top.awaddr 	=	rand_awaddr_readonly;
				top.awburst	=	top.awburst + b;
				top.awsize	=	3'b010;
				top.awlen	=	4'b0011;
				top.wstrb	=	4'b1111;		
				for(i='0;i<=top.awlen;i=i+4'b1) begin
				
				stimulus(rand_awid,rand_awaddr_valid,rand_awaddr_invalid,rand_awaddr_readonly,rand_wdata,rand_araddr_valid,rand_araddr_invalid,rand_arid);
				top.wdata  = rand_wdata;

				end//i_for
				wait(intf.BREADY)
				repeat(2) @(posedge top.clk);
			end//for_b
	end//n_for	
endtask



/////////////////////////////////// Writing to invalid address   //////////////////////////////////////////////////////

task burst_write_invalid(input bit [3:0] rand_awid, input bit [31:0] rand_awaddr_valid, input bit [31:0] rand_awaddr_invalid, input bit [31:0] rand_awaddr_readonly, input bit [31:0] rand_wdata,  input bit [31:0] rand_araddr_valid, input bit [31:0] rand_araddr_invalid, input bit [3:0] rand_arid );

	for(n=0;n<10;n++) begin
	for(b=2'b00;b<2'b11;b++) begin
			stimulus(rand_awid,rand_awaddr_valid,rand_awaddr_invalid,rand_awaddr_readonly,rand_wdata,rand_araddr_valid,rand_araddr_invalid,rand_arid);
				top.awid 		=	rand_awid;
				top.awaddr 	=	rand_awaddr_invalid;
				top.awburst	=	top.awburst + b;
				top.awsize	=	3'b010;
				top.awlen	=	4'b0011;
				top.wstrb	=	4'b1111;		
				for(i='0;i<=top.awlen;i=i+4'b1) begin
				
				stimulus(rand_awid,rand_awaddr_valid,rand_awaddr_invalid,rand_awaddr_readonly,rand_wdata,rand_araddr_valid,rand_araddr_invalid,rand_arid);
				top.wdata  = rand_wdata;

				end//i_for
				wait(intf.BREADY)
				repeat(2) @(posedge top.clk);
			end//for_b
	end//n_for	
endtask



/////////////////////////////// Reading from invalid address  /////////////////////////////////////////////////////////////////

task burst_read_invalid(input bit [3:0] rand_awid, input bit [31:0] rand_awaddr_valid, input bit [31:0] rand_awaddr_invalid, input bit [31:0] rand_awaddr_readonly, input bit [31:0] rand_wdata,  input bit [31:0] rand_araddr_valid, input bit [31:0] rand_araddr_invalid, input bit [3:0] rand_arid );

for(n=0;n<10;n++) begin
for(x='0;x<2'b11;x++) begin
		stimulus(rand_awid,rand_awaddr_valid,rand_awaddr_invalid,rand_awaddr_readonly,rand_wdata,rand_araddr_valid,rand_araddr_invalid,rand_arid);	
		top.arid	=	rand_arid;	
		top.araddr	=	rand_araddr_invalid;
		top.arburst	=	top.arburst + x;
		top.arsize	=	3'b010;
		top.arlen	=	4'b0111;	
		wait (intf.RLAST)
		repeat(3) @(posedge top.clk);
	end//ARBURST
end//n

endtask



/////////////////////////////////// Alternate write and read /////////////////////////////////////////////////////////////////////

task burst_write_read(input bit [3:0] rand_awid, input bit [31:0] rand_awaddr_valid, input bit [31:0] rand_awaddr_invalid, input bit [31:0] rand_awaddr_readonly, input bit [31:0] rand_wdata,  input bit [31:0] rand_araddr_valid, input bit [31:0] rand_araddr_invalid, input bit [3:0] rand_arid );

for(b=2'b10;b<2'b11;b++) begin
				stimulus(rand_awid,rand_awaddr_valid,rand_awaddr_invalid,rand_awaddr_readonly,rand_wdata,rand_araddr_valid,rand_araddr_invalid,rand_arid);
				top.awid 	=	rand_awid;
				top.awaddr 	=	32'he31;//rand_awaddr_valid;
				top.awburst	=	top.awburst + b;
				top.awsize	=	3'b010;
				top.awlen	=	4'b0011;
				top.wstrb	=	4'b1111;		
				for(i='0;i<=top.awlen;i=i+4'b1) begin
				wait(intf.WVALID)
				stimulus(rand_awid,rand_awaddr_valid,rand_awaddr_invalid,rand_awaddr_readonly,rand_wdata,rand_araddr_valid,rand_araddr_invalid,rand_arid);
				top.wdata  = rand_wdata;
				wait(!intf.WVALID);
				end//i_for
				wait(intf.BREADY)
				repeat(2) @(posedge top.clk);
//for(b=2'b00;b<2'b11;b++) begin
				stimulus(rand_awid,rand_awaddr_valid,rand_awaddr_invalid,rand_awaddr_readonly,rand_wdata,rand_araddr_valid,rand_araddr_invalid,rand_arid);
				top.awid 	=	rand_awid;
				top.arid	=	rand_arid;	
				top.awaddr 	=	32'hd5d;//rand_awaddr_valid;
				top.araddr	=	32'he31;//rand_araddr_valid;
				top.awburst	=	top.awburst + b;
				top.arburst	=	top.arburst + b;
				top.awsize	=	3'b010;
				top.arsize	=	3'b010;
				top.awlen	=	4'b0011;
				top.arlen	=	4'b0011;	
				top.wstrb	=	4'b1111;
				for(i='0;i<=top.awlen;i=i+4'b1) begin
				wait(intf.WVALID)
				stimulus(rand_awid,rand_awaddr_valid,rand_awaddr_invalid,rand_awaddr_readonly,rand_wdata,rand_araddr_valid,rand_araddr_invalid,rand_arid);
				top.wdata  = rand_wdata;
				wait(!intf.WVALID);
				end//i_for
				wait(intf.BREADY)
				repeat(2) @(posedge top.clk);
			//	wait (intf.RLAST)
			//	repeat(3) @(posedge top.clk)

			

				stimulus(rand_awid,rand_awaddr_valid,rand_awaddr_invalid,rand_awaddr_readonly,rand_wdata,rand_araddr_valid,rand_araddr_invalid,rand_arid);
				top.awid 	=	rand_awid;
				top.arid	=	rand_arid;	
				top.awaddr 	=	32'h986;//rand_awaddr_valid;
				top.araddr	=	32'hd5d;//rand_araddr_valid;
				top.awburst	=	top.awburst + b;
				top.arburst	=	top.arburst + b;
				top.awsize	=	3'b010;
				top.arsize	=	3'b010;
				top.awlen	=	4'b0011;
				top.arlen	=	4'b0011;	
				top.wstrb	=	4'b1111;
				for(i='0;i<=top.awlen;i=i+4'b1) begin
				wait(intf.WVALID)
				stimulus(rand_awid,rand_awaddr_valid,rand_awaddr_invalid,rand_awaddr_readonly,rand_wdata,rand_araddr_valid,rand_araddr_invalid,rand_arid);
				top.wdata  = rand_wdata;
				wait(!intf.WVALID);
				end//i_for
				wait(intf.BREADY)
				repeat(2) @(posedge top.clk);
				


				stimulus(rand_awid,rand_awaddr_valid,rand_awaddr_invalid,rand_awaddr_readonly,rand_wdata,rand_araddr_valid,rand_araddr_invalid,rand_arid);
				top.awid 	=	rand_awid;
				top.arid	=	rand_arid;	
				top.awaddr 	=	32'h621;//rand_awaddr_valid;
				top.araddr	=	32'h986;//rand_araddr_valid;
				top.awburst	=	top.awburst + b;
				top.arburst	=	top.arburst + b;
				top.awsize	=	3'b010;
				top.arsize	=	3'b010;
				top.awlen	=	4'b0011;
				top.arlen	=	4'b0011;	
				top.wstrb	=	4'b1111;
				for(i='0;i<=top.awlen;i=i+4'b1) begin
				wait(intf.WVALID)
				stimulus(rand_awid,rand_awaddr_valid,rand_awaddr_invalid,rand_awaddr_readonly,rand_wdata,rand_araddr_valid,rand_araddr_invalid,rand_arid);
				top.wdata  = rand_wdata;
				wait(!intf.WVALID);
				end//i_for
				wait(intf.BREADY)
				repeat(2) @(posedge top.clk);
				
			
				stimulus(rand_awid,rand_awaddr_valid,rand_awaddr_invalid,rand_awaddr_readonly,rand_wdata,rand_araddr_valid,rand_araddr_invalid,rand_arid);
				top.awid 	=	rand_awid;
				top.arid	=	rand_arid;	
				top.awaddr 	=	32'ha43;//rand_awaddr_valid;
				top.araddr	=	32'h621;//rand_araddr_valid;
				top.awburst	=	top.awburst + b;
				top.arburst	=	top.arburst + b;
				top.awsize	=	3'b010;
				top.arsize	=	3'b010;
				top.awlen	=	4'b0011;
				top.arlen	=	4'b0011;	
				top.wstrb	=	4'b1111;
				for(i='0;i<=top.awlen;i=i+4'b1) begin
				wait(intf.WVALID)
				stimulus(rand_awid,rand_awaddr_valid,rand_awaddr_invalid,rand_awaddr_readonly,rand_wdata,rand_araddr_valid,rand_araddr_invalid,rand_arid);
				top.wdata  = rand_wdata;
				wait(!intf.WVALID);
				end//i_for
				wait(intf.BREADY)
				repeat(2) @(posedge top.clk);	
		
			end//for_b
endtask

//////////////////////////////////////// write size invalid /////////////////////////////////////////////////////////////////

task write_size_invalid(input bit [3:0] rand_awid, input bit [31:0] rand_awaddr_valid, input bit [31:0] rand_awaddr_invalid, input bit [31:0] rand_awaddr_readonly, input bit [31:0] rand_wdata,  input bit [31:0] rand_araddr_valid, input bit [31:0] rand_araddr_invalid, input bit [3:0] rand_arid );

for(b=2;b<2'b11;b++) begin
		for(s=3'b100;s<=3'b111;s++) begin
				stimulus(rand_awid,rand_awaddr_valid,rand_awaddr_invalid,rand_awaddr_readonly,rand_wdata,rand_araddr_valid,rand_araddr_invalid,rand_arid);
				top.awid 	=	rand_awid;
				top.awaddr 	=	rand_awaddr_valid;
				top.awburst	=	top.awburst + b;
				top.awsize	=	top.awsize + s;
				top.awlen	=	4'b0011;
				top.wstrb	=	4'b1111;		
				for(i='0;i<=top.awlen;i=i+4'b1) begin
				
				stimulus(rand_awid,rand_awaddr_valid,rand_awaddr_invalid,rand_awaddr_readonly,rand_wdata,rand_araddr_valid,rand_araddr_invalid,rand_arid);
				top.wdata  = rand_wdata;
				
				end//i_for
				wait(intf.BREADY)
				repeat(2) @(posedge top.clk);
		end//s_for
	end//b_for	
endtask

/////////////////////////////// read size invalid /////////////////////////////////////////////////////////////////

task read_size_invalid(input bit [3:0] rand_awid, input bit [31:0] rand_awaddr_valid, input bit [31:0] rand_awaddr_invalid, input bit [31:0] rand_awaddr_readonly, input bit [31:0] rand_wdata,  input bit [31:0] rand_araddr_valid, input bit [31:0] rand_araddr_invalid, input bit [3:0] rand_arid );


for(x='0;x<2'b11;x++) begin
	for(s=3'b100;s<=3'b111;s++) begin	
		stimulus(rand_awid,rand_awaddr_valid,rand_awaddr_invalid,rand_awaddr_readonly,rand_wdata,rand_araddr_valid,rand_araddr_invalid,rand_arid);	
		top.arid	=	rand_arid;	
		top.araddr	=	rand_araddr_valid;
		top.arburst	=	top.arburst + x;
		top.arsize	=	top.arsize + s;
		top.arlen	=	4'b0111;	
		wait (intf.RLAST)
		repeat(3) @(posedge top.clk);
	end//s
end//x

endtask


		
endclass
`endif		
