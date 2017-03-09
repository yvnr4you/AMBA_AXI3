
module AXI_master #(parameter WIDTH, SIZE)
	(
input clk, resetn,
axi.master  axim,

//Sending inputs to master which will the transfered through AXI protocol.
input logic [WIDTH-1:0]  awaddr,
input logic [(WIDTH/8)-1:0]   awlen,
input logic	[(WIDTH/8)-1:0]   wstrb,
input logic	[SIZE-1:0]	awsize,
input logic	[SIZE-2:0]	awburst,
input logic	[WIDTH-1:0]	wdata,
input logic	[(WIDTH/8)-1:0]	awid,

input logic	[WIDTH-1:0]	araddr,
input logic	[(WIDTH/8)-1:0]	arid,
input logic	[(WIDTH/8)-1:0]	arlen,
input logic	[SIZE-1:0]	arsize,
input logic	[SIZE-2:0]	arburst,
//creating the master's local ram of 4096 Bytes(4 KB).
output logic	[4095:0] [7:0] read_mem 
);


/////////////// VARIABLES FOR WRITE ADDRESS MASTER ////////////////////////////////////
enum logic [1:0] { WA_IDLE_M=2'b00, WA_START_M, WA_WAIT_M, WA_VALID_M } WAState_M, WANext_state_M;

////////////// VARIABLES FOR WRITE DATA MASTER /////////////////////////////////////
logic [4:0] count, count_next;
enum logic [2:0] {W_INIT_M=3'b000, W_TRANSFER_M, W_READY_M, W_VALID_M, W_ERROR_M} WState_M, WNext_state_M;

////////////// VARIABLES FOR WRITE RESPONSE MASTER /////////////////////////////////////
enum logic [1:0] { B_IDLE_M=2'b00, B_START_M, B_READY_M } BState_M, BNext_state_M;


////////////// VARIABLES FOR READ ADDRESS MASTER /////////////////////////////////////
enum logic [2:0] {AR_IDLE_M=3'b000, AR_WAIT_M, AR_READY_M, AR_VALID_M, AR_EXTRA_M} ARState_M,ARNext_state_M;

////////////// VARIABLES FOR READ DATA MASTER /////////////////////////////////////
logic [31:0] address_slave, address_slave_reg, address_slave_temp, ARADDR_reg;        
enum logic [1:0] {R_CLEAR_M=2'b00, R_START_M, R_READ_M, R_VALID_M } RState_M,RNext_state_M;
integer wrap_boundary1, first_time1, first_time1_next;

//////////////// WRITE ADDRESS CHANNEL MASTER//////////////////////////////////
always_ff @(posedge clk or negedge resetn)	
begin	
	if(!resetn)	begin
		WAState_M <= WA_IDLE_M;
	end
	else begin
		WAState_M <= WANext_state_M;
	end	
end

always_comb	
begin	
	case(WAState_M)
      WA_IDLE_M:begin
                 axim.AWVALID = '0;
                 axim.AWBURST = '0;
                 axim.AWSIZE = '0;
                 axim.AWLEN = '0;
                 axim.AWADDR = '0;
                 axim.AWID = '0;
                 WANext_state_M = WA_START_M;
                end		
                
     WA_START_M:begin
				 if(awaddr > 32'h0)  begin
				  axim.AWBURST = awburst;
				  axim.AWSIZE = awsize;
				  axim.AWLEN = awlen;
				  axim.AWADDR = awaddr;
				  axim.AWID = awid;
				  axim.AWVALID = 1'b1;
				  WANext_state_M = WA_WAIT_M;	
				 end
				 else
				  WANext_state_M = WA_IDLE_M;
                end
             
	  WA_WAIT_M:begin	
				 if (axim.AWREADY)
				  WANext_state_M = WA_VALID_M;
				 else
				  WANext_state_M = WA_WAIT_M;
				end
	
	 WA_VALID_M:begin
				 axim.AWVALID = '0;
				 if(axim.BREADY)
				  WANext_state_M = WA_IDLE_M;			
				 else
				  WANext_state_M = WA_VALID_M;
			    end
	endcase
end



///////////////////////////// WRITE DATA CHANNEL MASTER //////////////////////////////////////

always_ff @(posedge clk or negedge resetn)
begin
	if(!resetn)
	 begin
		WState_M <= W_INIT_M;
		count <= 4'b0;
	 end
	else
	 begin
		WState_M <= WNext_state_M;
		count <= count_next;
	 end
end

always_comb
begin
	case(WState_M)
    
		W_INIT_M:begin
				 axim.WID = '0;
				 axim.WDATA = '0;
				 axim.WSTRB = '0;
				 axim.WLAST = '0;
				 axim.WVALID = '0;
				 count_next = '0;
                    if(axim.AWREADY == 1) WNext_state_M = W_TRANSFER_M;	
                    else WNext_state_M = W_INIT_M;
                end

   W_TRANSFER_M:begin	
                 if(awaddr > 32'h5ff && awaddr <=32'hfff && awsize <3'b100) 
                    begin
                      axim.WID =  axim.AWID;
                      axim.WVALID = '1;
                      axim.WSTRB = wstrb;
                      axim.WDATA = wdata;	
                      count_next = count + 4'b1;
                      WNext_state_M = W_READY_M;
				 end
				 else begin
					  count_next = count + 4'b1;
					  WNext_state_M = W_ERROR_M;
				 end
				end

	  W_READY_M:begin
				 if(axim.WREADY) begin
					  if(count_next == (awlen+1))  axim.WLAST = 1'b1;
					  else  axim.WLAST = 1'b0;
                    
					  WNext_state_M = W_VALID_M;
				 end			
				 else WNext_state_M = W_READY_M;	
			    end
	
	  W_VALID_M:begin
                 axim.WVALID = '0;
                      
				 if(count_next == awlen+1) begin
					  WNext_state_M = W_INIT_M;	
					  axim.WLAST='0;
				 end
				 else WNext_state_M = W_TRANSFER_M;
				end
	  
      W_ERROR_M:begin
				 if(count_next == (awlen+1)) begin
					  axim.WLAST = 1'b1;
					  WNext_state_M = W_VALID_M;
				 end
				 else begin
					  axim.WLAST = 1'b0;
					  WNext_state_M = W_TRANSFER_M;
				 end
			    end	
	endcase
end


/////////////////////// WRITE RESPONSE CHANNEL MASTER ////////////////////////////////////////////////////

always_ff @(posedge clk or negedge resetn)	begin
	if(!resetn)	begin
		BState_M <= B_IDLE_M;
	end
	else
		BState_M <= BNext_state_M;
end

always_comb	begin
	
	case(BState_M)
	
   B_IDLE_M:begin
			 axim.BREADY = '0;
			 BNext_state_M = B_START_M;
			end		
            
  B_START_M:begin
			 if(axim.BVALID) begin
			  BNext_state_M = B_READY_M;	
			 end
			end
            
  B_READY_M:begin	
			  axim.BREADY = 1'b1;
			  BNext_state_M = B_IDLE_M;
			end
	endcase
end



//**********************************************************************************************************************************************************



////////////////////////// READ ADDRESS CHANNEL MASTER /////////////////////////////////////////////////////


always_ff @(posedge clk or negedge resetn)
begin
	if (!resetn)	begin
		ARState_M <= AR_IDLE_M;
	end
	else	begin
		ARState_M <= ARNext_state_M;
	end
		
end


always_comb
begin 	
    case (ARState_M)
  AR_IDLE_M:begin
             axim.ARID = 0;
             axim.ARADDR = 0;
             axim.ARLEN = 0;
             axim.ARSIZE = 0;
             axim.ARBURST = 0;
             axim.ARVALID = 0;
            ARNext_state_M = AR_WAIT_M;
            end
            
  AR_WAIT_M:begin
            if(araddr > 32'h0) begin	
             axim.ARID = arid;
             axim.ARADDR = araddr;
             axim.ARLEN = arlen;
             axim.ARSIZE = arsize;
             axim.ARBURST = arburst;
             axim.ARVALID = 1'b1;
            ARNext_state_M = AR_READY_M;
            end
            else
             ARNext_state_M = AR_IDLE_M;
            end
            
 AR_READY_M:begin
            if (axim.ARREADY)
             ARNext_state_M = AR_VALID_M;
            else 					
             ARNext_state_M = AR_READY_M;
            end
            
 AR_VALID_M:begin
             axim.ARVALID = '0;
             if(axim.RLAST)
              ARNext_state_M = AR_EXTRA_M;
             else
              ARNext_state_M = AR_VALID_M;
            end	
            
 AR_EXTRA_M:begin
             ARNext_state_M = AR_IDLE_M;
            end
        endcase
end



/////////////////////////////// READ DATA CHANNEL MASTER ////////////////////////////////////////////

    //Sequential always block    
always_ff @(posedge clk or negedge resetn)
begin
    if(!resetn)
        RState_M       <= R_CLEAR_M;
    else begin
        RState_M       <= RNext_state_M;
        first_time1 <= first_time1_next;
    end
end
        
//Combinational always block        
always_comb
    begin	
        if(axim.ARREADY)
            ARADDR_reg = araddr;
  
        case(RState_M)
  R_CLEAR_M:begin
                RNext_state_M  = R_START_M;
                 axim.RREADY = '0;
                first_time1_next = 0;	
                address_slave = '0;
                address_slave_reg='0;
            end
                
  R_START_M:begin
                if(axim.RVALID) begin
                    RNext_state_M = R_READ_M;                    
                    address_slave = address_slave_reg;
                end
                else
                    RNext_state_M = R_START_M;	
            end
        
   R_READ_M:begin
                RNext_state_M = R_VALID_M;
                axim.RREADY= '1;        //setting RREADY to 1 to say to slave that master is ready to receive valid data.
                
                case(arburst)
                  2'b00:begin
                            address_slave = ARADDR_reg;
                            case (arsize)
                            3'b000: begin	
                                         read_mem[address_slave] =  axim.RDATA[7:0]; 
                                    end
                            3'b001: begin	
                                        read_mem[address_slave] =  axim.RDATA[7:0]; 
                                        read_mem[address_slave+1] =  axim.RDATA[15:8]; 		
                                    end
                            3'b010: begin	
                                        read_mem[address_slave] =  axim.RDATA[7:0];
                                        read_mem[address_slave+1] =  axim.RDATA[15:8];
                                        read_mem[address_slave+2] =  axim.RDATA[23:16];
                                        read_mem[address_slave+3] =  axim.RDATA[31:24];
                                    end
                            endcase
                        end
                                
                  2'b01:begin
                            if(first_time1 == 0) begin
                                address_slave = ARADDR_reg;
                                first_time1_next = 1;
                            end	
                            else	
                                first_time1_next = first_time1;
                                
                            if(axim.RLAST == 1)
                                first_time1_next = 0;
                            else 
                                first_time1_next = first_time1;
                            
                            case (arsize)
                            3'b000: begin	
                                        read_mem[address_slave] =  axim.RDATA[7:0];
                                    end
                            3'b001: begin	
                                        read_mem[address_slave] =  axim.RDATA[7:0];
                                        read_mem[address_slave+1] =  axim.RDATA[15:8];
                                        address_slave_reg = address_slave + 2;	
                                    end
                            3'b010: begin	
                                        read_mem[address_slave] =  axim.RDATA[7:0];
                                        read_mem[address_slave+1] =  axim.RDATA[15:8];
                                        read_mem[address_slave+2] =  axim.RDATA[23:16];
                                        read_mem[address_slave+3] =  axim.RDATA[31:24];
                                        address_slave_reg = address_slave + 4;
                                    end
                            endcase
                        end
                                
                   2'b10:begin
                            if(first_time1 == 0) begin
                                address_slave = ARADDR_reg;
                                first_time1_next = 1;
                            end	
                            else 
                                first_time1_next = first_time1;
                        
                            if(axim.RLAST == 1)
                                first_time1_next = 0;
                            else 
                                first_time1_next = first_time1;
                                
                            case(arlen)
                            4'b0001:begin
                                        case(arsize)
                                        3'b000: begin
                                                    wrap_boundary1 = 2 * 1;
                                                end
                                        3'b001: begin
                                                    wrap_boundary1 = 2 * 2;																		
                                                end	
                                        3'b010: begin
                                                    wrap_boundary1 = 2 * 4;																		
                                                end
                                        endcase			
                                    end
                                    
                            4'b0011: begin
                                        case(arsize)
                                        3'b000: begin
                                                    wrap_boundary1 = 4 * 1;
                                                end
                                        3'b001: begin
                                                    wrap_boundary1 = 4 * 2;																		
                                                end	
                                        3'b010: begin
                                                    wrap_boundary1 = 4 * 4;																		
                                                end
                                        endcase			
                                    end
                                    
                            4'b0111:begin
                                        case(arsize)
                                        3'b000: begin
                                                    wrap_boundary1 = 8 * 1;  
                                                end
                                        3'b001: begin
                                                    wrap_boundary1 = 8 * 2;																		
                                                end	
                                        3'b010: begin
                                                    wrap_boundary1 = 8 * 4;																		
                                                end
                                        endcase			
                                    end	
                            
                            4'b1111: begin
                                        case(arsize)
                                        3'b000: begin
                                                    wrap_boundary1 = 16 * 1;   
                                                end
                                        3'b001: begin
                                                    wrap_boundary1 = 16 * 2;																		
                                                end	
                                        3'b010: begin
                                                    wrap_boundary1 = 16 * 4;																		
                                                end
                                        endcase			
                                    end
                                endcase	
                                
                                case(arsize)
                                3'b000: begin	
                                            read_mem[address_slave] =  axim.RDATA[7:0];
                                            address_slave_temp = address_slave + 1;
                                            
                                            if(address_slave_temp % wrap_boundary1 == 0)
                                                address_slave_reg = address_slave_temp - wrap_boundary1;
                                            else		
                                                address_slave_reg = address_slave_temp;	
                                        end
                                        
                                3'b001: begin	
                                            read_mem[address_slave] =  axim.RDATA[7:0];
                                            address_slave_temp = address_slave + 1;
                                            
                                            if(address_slave_temp % wrap_boundary1 == 0)
                                                address_slave_reg = address_slave_temp - wrap_boundary1;
                                            else
                                                address_slave_reg = address_slave_temp;
                                                
                                            read_mem[address_slave_reg] =  axim.RDATA[15:8];
                                            address_slave_temp = address_slave_reg + 1;
                                            
                                            if(address_slave_temp % wrap_boundary1 == 0)
                                                address_slave_reg = address_slave_temp - wrap_boundary1;
                                            else
                                                address_slave_reg = address_slave_temp;
                                        end
                                        
                                3'b010: begin	
                                            read_mem[address_slave] =  axim.RDATA[7:0];
                                            address_slave_temp = address_slave + 1;
                                            
                                            if(address_slave_temp % wrap_boundary1 == 0)
                                                address_slave_reg = address_slave_temp - wrap_boundary1;
                                            else
                                                address_slave_reg = address_slave_temp;
                                                
                                            read_mem[address_slave_reg] =  axim.RDATA[15:8];
                                            address_slave_temp = address_slave_reg + 1;
                                            
                                            if(address_slave_temp % wrap_boundary1 == 0)
                                                address_slave_reg = address_slave_temp - wrap_boundary1;
                                            else
                                                address_slave_reg = address_slave_temp;
                                                
                                            read_mem[address_slave_reg] =  axim.RDATA[23:16];
                                            address_slave_temp = address_slave_reg + 1;
                                            
                                            if(address_slave_temp % wrap_boundary1 == 0)
                                                address_slave_reg = address_slave_temp - wrap_boundary1;
                                            else
                                                address_slave_reg = address_slave_temp;
                                                
                                            read_mem[address_slave_reg] =  axim.RDATA[31:24];
                                            address_slave_temp = address_slave_reg + 1;
                                            
                                            if(address_slave_temp % wrap_boundary1 == 0)
                                                address_slave_reg = address_slave_temp - wrap_boundary1;
                                            else
                                                address_slave_reg = address_slave_temp;														
                                        end
                                endcase
                        end
                endcase
            end
                
  R_VALID_M:begin
                axim.RREADY = 1'b0;
                if(axim.RLAST) begin
                    $display("MASTER Mem= %p",read_mem);
                    RNext_state_M = R_CLEAR_M;
                end
                else
                    RNext_state_M = R_START_M;	
            end
        endcase
    end
endmodule		