`include"//khensu/Home06/anurag/Desktop/SV_AXI_finlly_final/axi_driver.sv"
`include"//khensu/Home06/anurag/Desktop/SV_AXI_finlly_final/AXI_Interface.sv"
`include"//khensu/Home06/anurag/Desktop/SV_AXI_finlly_final/axi_monitor.sv"
`include"//khensu/Home06/anurag/Desktop/SV_AXI_finlly_final/axi_scoreboard_update.sv"



`timescale 1ns/1ns

`ifndef env_sv
`define env_sv
class environment; 
   driver drvr; 
   Scoreboard sb; 
   monitor mntr; 
   virtual axi intf; 
   
   function new(virtual axi intf); 
      this.intf = intf;
      sb = new(intf); 
      drvr = new(intf); 
      mntr = new(intf); 
   endfunction 
   
   
   
endclass 
`endif