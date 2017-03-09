`include"//khensu/Home06/anurag/Desktop/SV_AXI_finlly_final/axi_driver.sv"
`include"//khensu/Home06/anurag/Desktop/SV_AXI_finlly_final/AXI_Interface.sv"

`timescale 1ns/1ns


`ifndef mon
`define mon
class monitor;
   virtual axi intf;   
   driver dv;
      
   function new(virtual axi intf); 
      begin
	 this.intf = intf;
	end
   endfunction // new
   
    
   task start();      
      forever
	@(posedge top.clk)
	begin
	   $display("***************************  MONITOR OUTPUT  ********************************************* ");		
	   $display("Write Data     : %b",intf.WDATA);	   
	   $display("Read Data     : %b",intf.RDATA);
	   $display("***************************************************************************************** ");
	end
      
   endtask
endclass

`endif