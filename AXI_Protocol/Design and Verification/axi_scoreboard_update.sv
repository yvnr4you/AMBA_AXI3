`include"//khensu/Home06/anurag/Desktop/SV_AXI_finlly_final/axi_driver.sv"
`include"//khensu/Home06/anurag/Desktop/SV_AXI_finlly_final/AXI_Interface.sv"
`include"//khensu/Home06/anurag/Desktop/SV_AXI_finlly_final/axi_monitor.sv"
`include"//khensu/Home06/anurag/Desktop/SV_AXI_finlly_final/AXI_top_design.sv"

`timescale 1ns/1ns
`ifndef scoreboard_sv
`define scoreboard_sv

class Scoreboard; 
   int f,i,j;
	logic [31:0] address, address_incr, address_read;
	int wrap_boundary2;
   driver drvr; 
   monitor mntr;
   virtual axi intf; 
   
   function new(virtual axi intf); 
      this.intf = intf; 
      drvr = new(intf); 
      mntr = new(intf); 

      
   endfunction 

  logic [31:0] tx_data_expected, sb_tx_data;
logic [31:0] data_expected, data_received;


task data_transmission();
forever
begin	
	if(intf.AWREADY) begin
		address_read = top.awaddr;
		$display("************************* SCOREBOARD *******************************************");
		$display("The Write Operation");
		$display("The burst type is: %b",top.awburst);
		$display("The length of busrt is: %b",top.awlen);
		$display("The size of each beat is: %b",top.awsize);
		$display("Write the data at %h address",top.awaddr);
		$display("The strobe value is: %b",top.wstrb);
	end
	i=0;
	//data_expected = '0;		
	for (i =0; i<=top.awlen; i++)	begin
	if(intf.WVALID == '1)
	begin
	//	if(intf.WREADY === '1)
		//begin
		
			if(top.wstrb === 4'b0001) begin
				data_expected[31:8] = '0;
				data_expected[7:0] = top.wdata[7:0];
				end 
			if(top.wstrb === 4'b0010) begin
				data_expected[31:8] = '0;
				data_expected[7:0] = top.wdata[15:8];
				end
			if(top.wstrb === 4'b0011) begin
				data_expected[31:16] = '0;
				data_expected[15:0] = top.wdata[15:0];
				end
			if(top.wstrb === 4'b0100) begin
				data_expected[31:8] = '0;
				data_expected[7:0] = top.wdata[23:16];
			end
			if(top.wstrb === 4'b0101) begin
				data_expected[31:16] = '0;
				data_expected[15:8] = top.wdata[23:16];
				data_expected[7:0] = top.wdata[7:0];
			end
			if(top.wstrb === 4'b0110) begin
				data_expected[31:16] = '0;
				data_expected[15:0] = top.wdata[23:8];
			//	data_expected[7:0] = drvr.intf.WDATA[15:8];
			end
			if(top.wstrb === 4'b0111) begin
				data_expected[31:24] = '0;
				data_expected[23:0] = top.wdata[23:0];
				end
			if(top.wstrb === 4'b1000) begin
				data_expected[31:8] = '0;
				data_expected[7:0] = top.wdata[31:24];
				end
			if(top.wstrb === 4'b1001) begin
				data_expected[31:16] = '0;
				data_expected[15:8] = top.wdata[31:24];
				data_expected[7:0] = top.wdata[7:0];
				end
			if(top.wstrb === 4'b1010) begin
				data_expected[31:16] = '0;
				data_expected[15:8] = top.wdata[31:24];
				data_expected[7:0] = top.wdata[15:8];
				end
			if(top.wstrb === 4'b1011) begin
				data_expected[31:24] = '0;
				data_expected[23:16] = top.wdata[31:24];
				data_expected[15:0] = top.wdata[15:0];
				end
			if(top.wstrb === 4'b1100) begin
				data_expected[31:16] = '0;
				data_expected[15:0] = top.wdata[31:16];
				end
			if(top.wstrb === 4'b1101) begin
				data_expected[31:24] = '0;
				data_expected[23:8] = top.wdata[31:16];
				data_expected[7:0] = top.wdata[7:0];
				end
			if(top.wstrb === 4'b1110) begin
				data_expected[31:24] = '0;
				data_expected[23:0] = top.wdata[31:8];
				end
			if(top.wstrb === 4'b1111) 
				data_expected = top.wdata;
			$display("The expected data to be written is: %b",data_expected);	
		end	
#10;
		if(intf.WREADY) begin	
				if(top.awburst==2'b00) begin
							address_read = top.awaddr;
									if(top.awsize ==3'b000) begin	
													data_received[31:8] = '0;				
													data_received[7:0] = top.slave_mem[address_read];
													$display("1 byte transfered to slave");
///													$display("Data Received: %b",data_received);	
												end
									if(top.awsize == 3'b001) begin
													data_received[31:16] = '0;						
													data_received[7:0] = top.slave_mem[address_read];
													$display("1 byte transfered to slave");
													data_received[15:8] = top.slave_mem[address_read+1];		
													$display("2 bytes transfered to slave");
												end
									if(top.awsize == 3'b010) begin	
													data_received[7:0] = top.slave_mem[address_read];
													$display("1 byte transfered to slave");
													data_received[15:8] = top.slave_mem[address_read+1];
													$display("2 bytes transfered to slave");
													data_received[23:16] = top.slave_mem[address_read+2];
													$display("3 bytes transfered to slave");
													data_received[31:24] = top.slave_mem[address_read+3];
													$display("4 bytes transfered to slave");
												end
								  
									end
					if(top.awburst ==	2'b01) begin
							//		if(intf.AWREADY=='1) begin
							//			address_read = drvr.intf.AWADDR;
								//	end	
							//		else	
							//		address_slave = address_slave + 1;
									if(top.awsize == 3'b000) begin	
													data_received[31:8] = '0;	
													$display("address read from : %h and value of i = %d",address_read,i);			
													data_received[7:0] = top.slave_mem[address_read];
													address_read = address_read + 1;
													$display("1 byte transfered to slave");
												end
									if(top.awsize == 3'b001) begin	
													data_received[31:16] = '0;				
													data_received[7:0] = top.slave_mem[address_read];
													$display("1 byte transfered to slave");
													data_received[15:8] = top.slave_mem[address_read+1];
													$display("2 bytes transfered to slave");
													address_read = address_read + 2;
												end
									if(top.awsize == 3'b010) begin	
													data_received[7:0] = top.slave_mem[address_read];
													$display("1 byte transfered to slave");
													data_received[15:8] = top.slave_mem[address_read+1];
													$display("2 bytes transfered to slave");
													data_received[23:16] = top.slave_mem[address_read+1];
													$display("3 bytes transfered to slave");
													data_received[31:24] = top.slave_mem[address_read+1];
													$display("4 bytes transfered to slave");
													address_read = address_read + 4;
												end
									end
									
					if(top.awburst ==	2'b10) begin
							//			if(intf.AWREADY) begin
							//			address_read = drvr.intf.AWADDR;
							//		end	
									if(top.awlen == 4'b0001) begin
														if(top.awsize == 3'b000) begin
																	wrap_boundary2 = 2 * 1;
																	
																end
														if(top.awsize == 3'b001) begin
																	wrap_boundary2 = 2 * 2;																		
																end	
														if(top.awsize == 3'b010) begin
																	wrap_boundary2 = 2 * 4;																		
																end		
													end
									if(top.awlen == 4'b0011) begin
														if(top.awsize == 3'b000) begin
																	wrap_boundary2 = 4 * 1;
																	
																end
														if(top.awsize == 3'b001) begin
																	wrap_boundary2 = 4 * 2;																		
																end	
														if(top.awsize == 3'b010) begin
																	wrap_boundary2 = 4 * 4;																		
																end		
													end
													
									if(top.awlen == 4'b0111) begin
														if(top.awsize == 3'b000) begin
																	wrap_boundary2 = 8 * 1;	
																end
														if(top.awsize == 3'b001) begin
																	wrap_boundary2 = 8 * 2;																		
																end	
														if(top.awsize == 3'b010) begin
																	wrap_boundary2 = 8 * 4;																		
																end	
													end	
											
									if(top.awlen == 4'b1111) begin
														if(top.awsize == 3'b000) begin
																	wrap_boundary2 = 16 * 1;
																	
																end
														if(top.awsize == 3'b001) begin
																	wrap_boundary2 = 16 * 2;																		
																end	
														if(top.awsize == 3'b010) begin
																	wrap_boundary2 = 16 * 4;																		
																end
													end	
									if(top.awsize == 3'b000) begin	
													data_received[31:8] = '0;																		
													data_received[7:0] = top.slave_mem[address_read];
													$display("1 byte transfered to slave");
													address_read = address_read + 1;
													if(address_read % wrap_boundary2 == 0)
														address_read = address_read - wrap_boundary2;
													else		
														address_read = address_read;	
												end
									if(top.awsize == 3'b001) begin	
													data_received[31:16] = '0;				
													data_received[7:0] = top.slave_mem[address_read];
													$display("1 byte transfered to slave");
													address_read = address_read + 1;
													if(address_read % wrap_boundary2 == 0)
														address_read = address_read - wrap_boundary2;
													else
														address_read = address_read;
													data_received[15:8] = top.slave_mem[address_read];
													$display("2 bytes transfered to slave");
													address_read = address_read + 1;
													if(address_read % wrap_boundary2 == 0)
														address_read = address_read - wrap_boundary2;
													else
														address_read = address_read;
												end
									if(top.awsize == 3'b010) begin	
													data_received[7:0] = top.slave_mem[address_read];
													$display("1 byte transfered to slave");
													address_read = address_read + 1;
													if(address_read % wrap_boundary2 == 0)
														address_read = address_read - wrap_boundary2;
													else
														address_read = address_read;
													data_received[15:8] = top.slave_mem[address_read];
													$display("2 bytes transfered to slave");
													address_read = address_read + 1;
													if(address_read % wrap_boundary2 == 0)
														address_read = address_read - wrap_boundary2;
													else
														address_read = address_read;
													data_received[23:16] = top.slave_mem[address_read];
													$display("3 bytes transfered to slave");
													address_read = address_read + 1;
													if(address_read % wrap_boundary2 == 0)
														address_read = address_read - wrap_boundary2;
													else
														address_read = address_read;
													data_received[31:24] = top.slave_mem[address_read];
													$display("4 bytes transfered to slave");
													address_read = address_read + 1;
													if(address_read % wrap_boundary2 == 0)
														address_read = address_read - wrap_boundary2;
													else
														address_read = address_read;														
												end

									end		
				$display("Data Saved to slave: %b",data_received);	
	if(data_expected == data_received)
	     $display(" %0d : Scoreboard :Transmitted Data Saved Succesfully to the slave",$time); 
	   else 
	     $display(" %0d : Scoreboard :Transmitted, data is  altered  ",$time); 	      
 end
//address_read = address_read + 1;
wait(!intf.WREADY);
end	
if(intf.BREADY)
$display("Write Response from slave: %b",intf.BRESP);
end	
endtask
	

task tx_rx_readdata();
	forever		
	begin
			
			j=0;
		for (j =0; j<=top.arlen; j++)	begin
	if(intf.ARREADY) begin
		address_incr = top.araddr;
		$display("************************* SCOREBOARD *******************************************");
		$display("The Read Operation");	
		$display("The burst type is: %b",top.arburst);
		$display("The length of busrt is: %b",top.arlen);
		$display("The size of each beat is: %b",top.arsize);
		$display("Read the data from %h address",top.araddr);
		end	

		
//		j=0;
//		for (j =0; j<=drvr.intf.ARLEN; j++)	begin
		wait(intf.RLAST)
		//	if(intf.RREADY == '1) begin	
				if(top.arlen == 4'b0001) begin
					if(top.awsize == 3'b000) begin
						wrap_boundary2 = 2 * 1;
					end
					if(top.awsize == 3'b001) begin
						wrap_boundary2 = 2 * 2;																		
					end
					if(top.awsize == 3'b010) begin
						wrap_boundary2 = 2 * 4;																		
					end		
				end
				if(top.arlen == 4'b0011) begin
					if(top.awsize == 3'b000) begin
						wrap_boundary2 = 4 * 1;
					end
					if(top.awsize == 3'b001) begin
						wrap_boundary2 = 4 * 2;																		
					end	
					if(top.awsize == 3'b010) begin
						wrap_boundary2 = 4 * 4;																		
					end		
				end							
				if(top.arlen == 4'b0111) begin
					if(top.awsize == 3'b000) begin
						wrap_boundary2 = 8 * 1;	
					end
					if(top.awsize == 3'b001) begin
						wrap_boundary2 = 8 * 2;																		
					end	
					if(top.awsize == 3'b010) begin
						wrap_boundary2 = 8 * 4;																		
					end	
				end	
				if(top.arlen == 4'b1111) begin
					if(top.awsize == 3'b000) begin
						wrap_boundary2 = 16 * 1;											
					end
					if(top.awsize == 3'b001) begin
						wrap_boundary2 = 16 * 2;																		
					end
					if(top.awsize == 3'b010) begin
						wrap_boundary2 = 16 * 4;																		
					end
				end	
			
				if(top.arburst==2'b00) begin
					address = top.araddr;
				 	for (int i =0; i<top.awsize; i++)	begin	
						if (top.master_mem [address] == top.slave_mem [address] ) begin
								f=0;
				 		    end
			   			else  begin
								f=1;
								break;
						end	
						address = address +32'b1;
					end
					if(f==0) begin
							$display(" %0d : Scoreboard :Transmitted and Received Data Matched ",$time); 
						end
					else
							$display(" %0d : Scoreboard :Transmitted and Received Data NOT Matched ",$time);
				end
		
				if(top.arburst==2'b01) begin
					for (int i =0; i<wrap_boundary2; i++)	begin	
						if (top.master_mem [address_incr] == top.slave_mem [address_incr] )
							f=0;		 		    
		   				else  begin
							f=1;
							break;
						end	
						address_incr = address_incr +32'b1;
					end
					if(f==0) begin
							$display(" %0d : Scoreboard :Transmitted and Received Data Matched ",$time); 
						end
					else
							$display(" %0d : Scoreboard :Transmitted and Received Data NOT Matched ",$time);
				end
			
			
				if(top.arburst == 2'b10) begin
						for (int i =0; i<wrap_boundary2; i++)	begin	
							if (top.master_mem [address_incr] == top.slave_mem [address_incr] )
								f=0;	    
		   					else  begin
								f=1;
								break;
							end	
							address_incr = address_incr +32'b1;
							if(address_incr % wrap_boundary2 == 0)
								address_incr = address_incr - wrap_boundary2;
							else
								address_incr = address_incr;
						end
						if(f==0) begin
								
								$display(" %0d : Scoreboard :Transmitted and Received Data Matched ",$time); 
						end
						else
								$display(" %0d : Scoreboard :Transmitted and Received Data NOT Matched ",$time);
				end
			end
		wait(!intf.RLAST)
	$display("Read Response from the slave: %b",intf.RRESP);	
end
	endtask
	
	
endclass 
`endif