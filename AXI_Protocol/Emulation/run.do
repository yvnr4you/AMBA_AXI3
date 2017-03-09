configure -emul velocesolo1
reg setvalue AXI_top_design.resetn 1'b0
run 2
reg setvalue AXI_top_design.resetn 1'b1     
run 10
reg setvalue AXI_top_design.awid 4'b1
reg setvalue AXI_top_design.awaddr 32'he31
reg setvalue AXI_top_design.awlen 4'd3
reg setvalue AXI_top_design.awsize 3'b010
reg setvalue AXI_top_design.awburst 2'b00
reg setvalue AXI_top_design.wstrb 4'b1111
run 2
reg setvalue AXI_top_design.wdata 32'h0a0a0a0a
run 3
reg setvalue AXI_top_design.wdata 32'h0f4d0f0f
run 3
reg setvalue AXI_top_design.wdata 32'h0f0f3c0f
run 3
reg setvalue AXI_top_design.wdata 32'h0f0f0f2b
run 4
reg setvalue AXI_top_design.awid 4'b0
reg setvalue AXI_top_design.awaddr 32'h000
reg setvalue AXI_top_design.awlen 4'b0
reg setvalue AXI_top_design.awsize 3'b000
reg setvalue AXI_top_design.awburst 2'b00
run 10
reg setvalue AXI_top_design.awid 4'b0010           
reg setvalue AXI_top_design.arid 4'b1011
reg setvalue AXI_top_design.araddr 32'he31
reg setvalue AXI_top_design.awaddr 32'h7cf
reg setvalue AXI_top_design.awlen 4'd3
reg setvalue AXI_top_design.awsize 3'b010
reg setvalue AXI_top_design.awburst 2'b00
reg setvalue AXI_top_design.arburst 2'b00
reg setvalue AXI_top_design.arsize 3'b010
reg setvalue AXI_top_design.arlen 4'd3
reg setvalue AXI_top_design.wstrb 4'b1111
run 2
reg setvalue AXI_top_design.wdata 32'h234d59ab
run 3
reg setvalue AXI_top_design.wdata 32'h5489acde
run 3
reg setvalue AXI_top_design.wdata 32'h88762473
run 3
reg setvalue AXI_top_design.wdata 32'heef56382
run 4
reg setvalue AXI_top_design.awid 4'b0
reg setvalue AXI_top_design.awaddr 32'd0
reg setvalue AXI_top_design.awlen 4'b0
reg setvalue AXI_top_design.awsize 3'b000
reg setvalue AXI_top_design.awburst 2'b00
reg setvalue AXI_top_design.arid 4'b0
reg setvalue AXI_top_design.araddr 32'd0
reg setvalue AXI_top_design.arlen 4'b0
reg setvalue AXI_top_design.arsize 3'b000
reg setvalue AXI_top_design.arburst 2'b00
run 10


reg setvalue AXI_top_design.awid 4'b0110           
reg setvalue AXI_top_design.arid 4'b1010
reg setvalue AXI_top_design.araddr 32'h7cf
reg setvalue AXI_top_design.awaddr 32'he52
reg setvalue AXI_top_design.awlen 4'd2
reg setvalue AXI_top_design.awsize 3'b000
reg setvalue AXI_top_design.awburst 2'b01
reg setvalue AXI_top_design.arburst 2'b00
reg setvalue AXI_top_design.arsize 3'b010
reg setvalue AXI_top_design.arlen 4'd3
reg setvalue AXI_top_design.wstrb 4'b0100
run 2
reg setvalue AXI_top_design.wdata 32'h234d59ab
run 3
reg setvalue AXI_top_design.wdata 32'h5489acde
run 3
reg setvalue AXI_top_design.wdata 32'h88762473
run 4
reg setvalue AXI_top_design.awid 4'b0
reg setvalue AXI_top_design.awaddr 32'd0
reg setvalue AXI_top_design.awlen 4'b0
reg setvalue AXI_top_design.awsize 3'b000
reg setvalue AXI_top_design.awburst 2'b00
reg setvalue AXI_top_design.arid 4'b0
reg setvalue AXI_top_design.araddr 32'd0
reg setvalue AXI_top_design.arlen 4'b0
reg setvalue AXI_top_design.arsize 3'b000
reg setvalue AXI_top_design.arburst 2'b00
run 10

reg setvalue AXI_top_design.awid 4'b0101           
reg setvalue AXI_top_design.arid 4'b1100
reg setvalue AXI_top_design.araddr 32'he52
reg setvalue AXI_top_design.awaddr 32'h320
reg setvalue AXI_top_design.awlen 4'd0
reg setvalue AXI_top_design.awsize 3'b000
reg setvalue AXI_top_design.awburst 2'b00
reg setvalue AXI_top_design.arburst 2'b01
reg setvalue AXI_top_design.arsize 3'b000
reg setvalue AXI_top_design.arlen 4'd2
reg setvalue AXI_top_design.wstrb 4'b0100
run 2
reg setvalue AXI_top_design.wdata 32'h234d59ab
run 4
reg setvalue AXI_top_design.awid 4'b0
reg setvalue AXI_top_design.awaddr 32'd0
reg setvalue AXI_top_design.awlen 4'b0
reg setvalue AXI_top_design.awsize 3'b000
reg setvalue AXI_top_design.awburst 2'b00
reg setvalue AXI_top_design.arid 4'b0
reg setvalue AXI_top_design.araddr 32'd0
reg setvalue AXI_top_design.arlen 4'b0
reg setvalue AXI_top_design.arsize 3'b000
reg setvalue AXI_top_design.arburst 2'b00
run 10


reg setvalue AXI_top_design.awid 4'b0110           
reg setvalue AXI_top_design.arid 4'b0010
reg setvalue AXI_top_design.awaddr 32'h657
reg setvalue AXI_top_design.awlen 4'd7
reg setvalue AXI_top_design.awsize 3'b010
reg setvalue AXI_top_design.awburst 2'b10
reg setvalue AXI_top_design.wstrb 4'b1111
run 2
reg setvalue AXI_top_design.wdata 32'h234d1111
run 3
reg setvalue AXI_top_design.wdata 32'h000059ab
run 3
reg setvalue AXI_top_design.wdata 32'h114d00ab
run 3
reg setvalue AXI_top_design.wdata 32'h234489ab
run 3
reg setvalue AXI_top_design.wdata 32'h202479ab
run 3
reg setvalue AXI_top_design.wdata 32'h23ab4d3c
run 3
reg setvalue AXI_top_design.wdata 32'h21545221
run 3
reg setvalue AXI_top_design.wdata 32'h74541545
run 4
reg setvalue AXI_top_design.awid 4'b0
reg setvalue AXI_top_design.awaddr 32'd0
reg setvalue AXI_top_design.awlen 4'b0
reg setvalue AXI_top_design.awsize 3'b000
reg setvalue AXI_top_design.awburst 2'b00
reg setvalue AXI_top_design.arid 4'b0
reg setvalue AXI_top_design.araddr 32'd0
reg setvalue AXI_top_design.arlen 4'b0
reg setvalue AXI_top_design.arsize 3'b000
reg setvalue AXI_top_design.arburst 2'b00
run 10

reg setvalue AXI_top_design.awid 4'b0111           
reg setvalue AXI_top_design.arid 4'b1110
reg setvalue AXI_top_design.araddr 32'h657
reg setvalue AXI_top_design.awaddr 32'h240
reg setvalue AXI_top_design.awlen 4'd0
reg setvalue AXI_top_design.awsize 3'b000
reg setvalue AXI_top_design.awburst 2'b00
reg setvalue AXI_top_design.arburst 2'b10
reg setvalue AXI_top_design.arsize 3'b010
reg setvalue AXI_top_design.arlen 4'd7
reg setvalue AXI_top_design.wstrb 4'b0001
run 2
reg setvalue AXI_top_design.wdata 32'h234d59ab
run 4
reg setvalue AXI_top_design.awid 4'b0
reg setvalue AXI_top_design.awaddr 32'd0
reg setvalue AXI_top_design.awlen 4'b0
reg setvalue AXI_top_design.awsize 3'b000
reg setvalue AXI_top_design.awburst 2'b00
reg setvalue AXI_top_design.arid 4'b0
reg setvalue AXI_top_design.araddr 32'd0
reg setvalue AXI_top_design.arlen 4'b0
reg setvalue AXI_top_design.arsize 3'b000
reg setvalue AXI_top_design.arburst 2'b00
run 10
upload -tracedir ./veloce.wave/wave1
exit 
