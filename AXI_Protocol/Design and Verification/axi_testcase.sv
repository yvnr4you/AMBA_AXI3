`include"//khensu/Home06/anurag/Desktop/SV_AXI_finlly_final/axi_driver.sv"
`include"//khensu/Home06/anurag/Desktop/SV_AXI_finlly_final/AXI_Interface.sv"
`include"//khensu/Home06/anurag/Desktop/SV_AXI_finlly_final/axi_env.sv"


`timescale 1ns/1ns

program testcase(axi intf); 
   environment env = new(intf); 
	reg [3:0]	rand_awid;
	reg [31:0]	rand_awaddr_valid;
	reg [31:0]	rand_awaddr_invalid;
	reg [31:0]	rand_awaddr_readonly;
	reg [31:0]	rand_wdata;
	reg [31:0]	rand_araddr_valid;
	reg [31:0]	rand_araddr_invalid;
	reg [3:0]	rand_arid;
	
	initial begin
	env.drvr.reset_enable();
	env.drvr.burst_write(rand_awid, rand_awaddr_valid, rand_awaddr_invalid, rand_awaddr_readonly, rand_wdata, rand_araddr_valid, rand_araddr_invalid, rand_arid );
	#10;
	env.drvr.burst_read(rand_awid, rand_awaddr_valid, rand_awaddr_invalid, rand_awaddr_readonly, rand_wdata, rand_araddr_valid, rand_araddr_invalid, rand_arid );
	#10;
	env.drvr.burst_write_readonly(rand_awid, rand_awaddr_valid, rand_awaddr_invalid, rand_awaddr_readonly, rand_wdata, rand_araddr_valid, rand_araddr_invalid, rand_arid );
	#10;
	env.drvr.burst_write_invalid(rand_awid, rand_awaddr_valid, rand_awaddr_invalid, rand_awaddr_readonly, rand_wdata, rand_araddr_valid, rand_araddr_invalid, rand_arid );
	#10;
	env.drvr.burst_read_invalid(rand_awid, rand_awaddr_valid, rand_awaddr_invalid, rand_awaddr_readonly, rand_wdata, rand_araddr_valid, rand_araddr_invalid, rand_arid );
	#10;
	env.drvr.burst_write_read(rand_awid, rand_awaddr_valid, rand_awaddr_invalid, rand_awaddr_readonly, rand_wdata, rand_araddr_valid, rand_araddr_invalid, rand_arid );
	#10;
	env.drvr.write_size_invalid(rand_awid, rand_awaddr_valid, rand_awaddr_invalid, rand_awaddr_readonly, rand_wdata, rand_araddr_valid, rand_araddr_invalid, rand_arid );
	#10;
	env.drvr.read_size_invalid(rand_awid, rand_awaddr_valid, rand_awaddr_invalid, rand_awaddr_readonly, rand_wdata, rand_araddr_valid, rand_araddr_invalid, rand_arid );
	#10;
	$finish;
	end
	
	initial begin
		env.mntr.start();
	end	
	
	initial 
     begin
 	forever @(posedge top.clk)
	  begin
	     env.sb.data_transmission();
	  end
     end
	
	initial 
     begin
 	forever @(posedge top.clk)
	  begin
	     env.sb.tx_rx_readdata();
	  end
     end


endprogram 