view wave
dataset open ./veloce.wave/wave1.stw wave1
#wave add -d wave1 top.clk {top.resetn} {top.rdata}  {top.axi_intf} 
wave add -d wave1 AXI_top_design.clk {AXI_top_design.resetn} {AXI_top_design.awid} {AXI_top_design.awaddr} {AXI_top_design.awlen}
wave add -d wave1 {AXI_top_design.awsize} {AXI_top_design.awburst} {AXI_top_design.wdata} {AXI_top_design.wstrb} {AXI_top_design.wdata}
wave add -d wave1 {AXI_top_design.AWVALID_tb_s} {AXI_top_design.AWBURST_tb_s} {AXI_top_design.AWSIZE_tb_s} {AXI_top_design.AWLEN_tb_s} 
wave add -d wave1 {AXI_top_design.AWADDR_tb_s} {AXI_top_design.AWID_tb_s} {AXI_top_design.WVALID_tb_s} {AXI_top_design.WLAST_tb_s} 
wave add -d wave1 {AXI_top_design.WSTRB_tb_s} {AXI_top_design.WDATA_tb_s} {AXI_top_design.WID_tb_s} {AXI_top_design.BREADY_tb_s} 
wave add -d wave1 {AXI_top_design.ARID_tb_s} {AXI_top_design.ARADDR_tb_s} {AXI_top_design.ARLEN_tb_s} {AXI_top_design.ARSIZE_tb_s} 
wave add -d wave1 {AXI_top_design.ARBURST_tb_s} {AXI_top_design.ARVALID_tb_s} {AXI_top_design.RREADY_tb_s} {AXI_top_design.AWREADY_tb_m} 
wave add -d wave1 {AXI_top_design.WREADY_tb_m} {AXI_top_design.BID_tb_m} {AXI_top_design.BRESP_tb_m} {AXI_top_design.BVALID_tb_m} 
wave add -d wave1 {AXI_top_design.ARREADY_tb_m} {AXI_top_design.RID_tb_m} {AXI_top_design.RDATA_tb_m} {AXI_top_design.RRESP_tb_m} 
wave add -d wave1 {AXI_top_design.RLAST_tb_m} {AXI_top_design.RVALID_tb_m} 
echo "wave1.stw loaded and signals added. Open the Wave window to observe outputs."


	