
module AXI_slave(
input	clk, resetn,
axi.slave axis,

output logic [4095:0] [7:0] slave_mem
);


/////////////// VARIABLES FOR WRITE ADDRESS SLAVE ///////////////////////////////////
enum logic [1:0] { WA_IDLE_S=2'b00, WA_START_S, WA_READY_S } WAState_S, WANext_state_S;


////////////// VARIABLES FOR WRITE DATA SLAVE /////////////////////////////////////
logic [31:0]	AWADDR_reg;
integer first_time, first_time_next, wrap_boundary; 
logic [31:0] address_master, address_master_reg, address_master_temp;
enum logic [1:0]{W_INIT_S=2'b00, W_START_S, W_READY_S, W_VALID_S} WState_S, WNext_state_S;


////////////// VARIABLES FOR WRITE RESPONSE SLAVE /////////////////////////////////////
enum logic [2:0] { B_IDLE_S=3'b000, B_LAST_S, B_START_S, B_WAIT_S, B_VALID_S } BState_S, BNext_state_S;


////////////// VARIABLES FOR READ ADDRESS SLAVE /////////////////////////////////////
enum logic [1:0] {AR_IDLE_S=2'b00, AR_WAIT_S, AR_READY_S} ARState_S,ARNext_state_S;


///////////// VARIABLES FOR READ DATA SLAVE ///////////////////////////////////////
enum logic [2:0] {R_CLEAR_S=3'b000, R_START_S, R_WAIT_S, R_VALID_S, R_ERROR_S } RState_S, RNext_state_S;
integer wrap_boundary2, first_time2, first_time2_next;
logic [4:0] counter, next_counter;
logic [31:0] ARADDR_reg1, address_read,address_read_reg, address_read_temp;



///////////////////// WRITE ADDRESS CHANNEL SLAVE ////////////////////////////////////
always_ff @(posedge clk or negedge resetn)	
begin	
	if(!resetn)	begin
		WAState_S <= WA_IDLE_S;
	end
	else begin
		WAState_S <= WANext_state_S;
	end	
end


always_comb	
begin	
	case(WAState_S)
  WA_IDLE_S:begin
                axis.AWREADY = '0;
                WANext_state_S = WA_START_S;
			end		
            
 WA_START_S:begin
				if(axis.AWVALID) begin
                    WANext_state_S = WA_READY_S;	
				end
				else
                    WANext_state_S = WA_START_S;
			end
            
 WA_READY_S:begin	
                axis.AWREADY = 1'b1;
				WANext_state_S = WA_IDLE_S;
			end
	endcase
end



//////////////////////////// WRITE DATA CHANNEL SLAVE //////////////////////////////////////


always_ff @(posedge clk or negedge resetn)
begin
	if(!resetn) begin
		WState_S <= W_INIT_S;	
	end
	else begin
		WState_S <= WNext_state_S;
		first_time <= first_time_next;
	end
end

always_comb
begin
	if(axis.AWVALID == 1)
		AWADDR_reg =  axis.AWADDR; 	
	
    case(WState_S)
   W_INIT_S:begin
                axis.WREADY = 1'b0;
                WNext_state_S = W_START_S;
                first_time_next = 0;
                address_master_reg = '0;
                address_master = '0;
            end

  W_START_S:begin
                if(axis.WVALID) begin
                    WNext_state_S = W_READY_S;
                    address_master = address_master_reg;
                end
                else begin
                    WNext_state_S = W_START_S;
                end
			end		
	
  W_READY_S:begin
				if(axis.WLAST) begin
					WNext_state_S = W_INIT_S;
				end
				else
                    WNext_state_S = W_VALID_S;
					axis.WREADY = 1'b1;
                    
                unique case(axis.AWBURST)
                  2'b00:begin
                            address_master = AWADDR_reg;
                            
                            unique case (axis.WSTRB)
                            4'b0001:begin	
                                        slave_mem[address_master] = axis.WDATA[7:0];
                                    end
                                    
                            4'b0010:begin	
                                        slave_mem[address_master] =  axis.WDATA[15:8];
                                    end
                                    
                            4'b0100:begin	
                                        slave_mem[address_master] =  axis.WDATA[23:16];
                                    end
                                    
                            4'b1000:begin
                                        slave_mem[address_master] =  axis.WDATA[31:24];
                                    end
                                    
                            4'b0011:begin	
                                        slave_mem[address_master] =  axis.WDATA[7:0];
                                        slave_mem[address_master+1] =  axis.WDATA[15:8];
                                    end
                                    
                            4'b0101:begin	
                                        slave_mem[address_master] =  axis.WDATA[7:0];											
                                        slave_mem[address_master+1] =  axis.WDATA[23:16];
                                    end
                                    
                            4'b1001:begin	
                                        slave_mem[address_master] =  axis.WDATA[7:0];											
                                        slave_mem[address_master+1] =  axis.WDATA[31:24];
                                    end
                                    
                            4'b0110:begin
                                        slave_mem[address_master] =  axis.WDATA[15:0];												
                                        slave_mem[address_master+1] =  axis.WDATA[23:16];
                                    end
                                    
                            4'b1010:begin
                                        slave_mem[address_master] =  axis.WDATA[15:8];										
                                        slave_mem[address_master+1] =  axis.WDATA[31:24];
                                    end
                                    
                            4'b1100:begin	
                                        slave_mem[address_master] =  axis.WDATA[23:16];
                                        slave_mem[address_master+1] =  axis.WDATA[31:24];
                                    end
                                    
                            4'b0111:begin										
                                        slave_mem[address_master] =  axis.WDATA[7:0];
                                        slave_mem[address_master+1] =  axis.WDATA[15:8];											
                                        slave_mem[address_master+2] =  axis.WDATA[23:16];
                                    end
                                    
                            4'b1110:begin	
                                        slave_mem[address_master] =  axis.WDATA[15:8];
                                        slave_mem[address_master+1] =  axis.WDATA[23:16];										
                                        slave_mem[address_master+2] =  axis.WDATA[31:24];
                                    end
                                    
                            4'b1011:begin	
                                        slave_mem[address_master] =  axis.WDATA[7:0];
                                        slave_mem[address_master+1] =  axis.WDATA[15:8];											
                                        slave_mem[address_master+2] =  axis.WDATA[31:24];
                                    end
                                    
                            4'b1101:begin	
                                        slave_mem[address_master] =  axis.WDATA[7:0];										
                                        slave_mem[address_master+1] =  axis.WDATA[23:16];											
                                        slave_mem[address_master+2] =  axis.WDATA[31:24];
                                    end
                                    
                            4'b1111:begin	
                                        slave_mem[address_master] =  axis.WDATA[7:0];										
                                        slave_mem[address_master+1] =  axis.WDATA[15:8];										
                                        slave_mem[address_master+2] =  axis.WDATA [23:16];										
                                        slave_mem[address_master+3] =  axis.WDATA [31:24];
                                    end
                            default: begin
				end	

                                endcase
			end
									
                  2'b01:begin
                            if(first_time == 0) 
                            begin
                                address_master = AWADDR_reg;
                                first_time_next = 1;
                            end	
                            else	
                                first_time_next = first_time;
                            
                            if(axis.BREADY == 1)
                                first_time_next = 0;
                            else 
                                first_time_next = first_time;
                            
                            unique case (axis.WSTRB)
                            4'b0001:begin	
                                        slave_mem[address_master] =  axis.WDATA [7:0];
                                        address_master_reg = address_master + 1;				
                                    end
                                    
                            4'b0010:begin	
                                        slave_mem[address_master] =  axis.WDATA [15:8];
                                        address_master_reg = address_master + 1;
                                    end
                                    
                            4'b0100:begin	
                                        slave_mem[address_master] =  axis.WDATA [23:16];
                                        address_master_reg = address_master + 1;
                                    end
                                    
                            4'b1000:begin
                                        slave_mem[address_master] =  axis.WDATA [31:24];
                                        address_master_reg = address_master + 1;
                                    end
                                    
                            4'b0011:begin	
                                        slave_mem[address_master] =  axis.WDATA [7:0];												
                                        slave_mem[address_master+1] =  axis.WDATA [15:8];
                                        address_master_reg = address_master + 2;
                                    end
                                    
                            4'b0101:begin	
                                        slave_mem[address_master] =  axis.WDATA [7:0];										
                                        slave_mem[address_master+1] =  axis.WDATA [23:16];
                                        address_master_reg = address_master + 2;
                                    end
                                    
                            4'b1001:begin	
                                        slave_mem[address_master] =  axis.WDATA [7:0];													
                                        slave_mem[address_master+1] =  axis.WDATA [31:24];
                                        address_master_reg = address_master + 2;
                                    end
                                    
                            4'b0110:begin
                                        slave_mem[address_master] =  axis.WDATA [15:0];													
                                        slave_mem[address_master+1] =  axis.WDATA [23:16];
                                        address_master_reg = address_master + 2;
                                    end
                                    
                            4'b1010:begin
                                        slave_mem[address_master] =  axis.WDATA [15:8];											
                                        slave_mem[address_master+1] =  axis.WDATA [31:24];
                                        address_master_reg = address_master + 2;
                                    end
                                    
                            4'b1100:begin
                                        slave_mem[address_master] =  axis.WDATA [23:16];												
                                        slave_mem[address_master+1] =  axis.WDATA [31:24];
                                        address_master_reg = address_master + 2;
                                    end
                                    
                            4'b0111:begin										
                                        slave_mem[address_master] =  axis.WDATA [7:0];												
                                        slave_mem[address_master+1] =  axis.WDATA [15:8];												
                                        slave_mem[address_master+2] =  axis.WDATA [23:16];
                                        address_master_reg = address_master + 3;
                                    end
                                    
                            4'b1110:begin	
                                        slave_mem[address_master] =  axis.WDATA [15:8];												
                                        slave_mem[address_master+1] =  axis.WDATA [23:16];												
                                        slave_mem[address_master+2] =  axis.WDATA [31:24];
                                        address_master_reg = address_master + 3;
                                    end
                                    
                            4'b1011:begin	
                                        slave_mem[address_master] =  axis.WDATA [7:0];												
                                        slave_mem[address_master+1] =  axis.WDATA [15:8];												
                                        slave_mem[address_master+2] =  axis.WDATA [31:24];
                                        address_master_reg = address_master + 3;
                                    end
                                    
                            4'b1101:begin	
                                        slave_mem[address_master] =  axis.WDATA [7:0];												
                                        slave_mem[address_master+1] =  axis.WDATA [23:16];												
                                        slave_mem[address_master+2] =  axis.WDATA [31:24];
                                        address_master_reg = address_master + 3;
                                    end
                                    
                            4'b1111:begin	
                                        slave_mem[address_master] =  axis.WDATA [7:0];												
                                        slave_mem[address_master+1] =  axis.WDATA [15:8];													
                                        slave_mem[address_master+2] =  axis.WDATA [23:16];													
                                        slave_mem[address_master+3] =  axis.WDATA [31:24];
                                        address_master_reg = address_master + 4;
                                    end
			    default: begin	end
                            endcase
                        end
									
				  2'b10:begin
                            if(first_time == 0) begin
                                address_master = AWADDR_reg;
                                first_time_next = 1;
                            end	
                            else 
                                first_time_next = first_time;								
                            if(axis.BREADY == 1)
                                first_time_next = 0;
                            else 
                                first_time_next = first_time;
								
                            unique case(axis.AWLEN)
							4'b0001:begin
                                        unique case(axis.AWSIZE)
                                        3'b000: begin
                                                    wrap_boundary = 2 * 1; 
                                                end
                                        3'b001: begin
                                                    wrap_boundary = 2 * 2;																		
                                                end	
                                        3'b010: begin
                                                    wrap_boundary = 2 * 4;																		
                                                end
                                         default: begin end
                                        endcase			
                                    end
                                    
                            4'b0011:begin
                                        unique case(axis.AWSIZE)
                                        3'b000: begin
                                                    wrap_boundary = 4 * 1;
                                                end
                                        3'b001: begin
                                                    wrap_boundary = 4 * 2;																		
                                                end	
                                        3'b010: begin
                                                    wrap_boundary = 4 * 4;																		
                                                end
                                        default: begin	end
                                        endcase			
                                    end
													
                            4'b0111:begin
                                        unique case(axis.AWSIZE)
                                        3'b000: begin
                                                    wrap_boundary = 8 * 1;
                                                end
                                        3'b001: begin
                                                    wrap_boundary = 8 * 2;																		
                                                end	
                                        3'b010: begin
                                                    wrap_boundary = 8 * 4;																		
                                                end
                                        default: begin	end
                                        endcase			
                                    end	
											
                            4'b1111:begin
                                        unique case(axis.AWSIZE)
                                        3'b000: begin
                                                    wrap_boundary = 16 * 1;
                                                    
                                                end
                                        3'b001: begin
                                                    wrap_boundary = 16 * 2;																		
                                                end	
                                        3'b010: begin
                                                    wrap_boundary = 16 * 4;																		
                                                end
                                        default: begin	end
                                        endcase			
                                    end
                            endcase						
										
                            unique case(axis.WSTRB)
                            4'b0001:begin	    
                                        slave_mem[address_master] =  axis.WDATA [7:0];
                                        address_master_temp = address_master + 1;
                                        
                                        if(address_master_temp % wrap_boundary == 0)
                                            address_master_reg = address_master_temp - wrap_boundary;
                                        else		
                                            address_master_reg = address_master_temp;	
                                    end
                                    
                            4'b0010:begin	
                                        slave_mem[address_master] =  axis.WDATA [15:8];
                                        address_master_temp = address_master + 1;
                                        
                                        if(address_master_temp % wrap_boundary == 0)
                                            address_master_reg = address_master_temp - wrap_boundary;
                                        else
                                            address_master_reg = address_master_temp;
                                    end
                                    
                            4'b0100:begin	
                                        slave_mem[address_master] =  axis.WDATA [23:16];
                                        address_master_temp = address_master + 1;
                                        
                                        if(address_master_temp % wrap_boundary == 0)
                                            address_master_reg = address_master_temp - wrap_boundary;
                                        else
                                            address_master_reg = address_master_temp;
                                    end
                                    
                            4'b1000:begin	
                                        slave_mem[address_master] =  axis.WDATA [31:24];
                                        address_master_temp = address_master + 1;
                                        
                                        if(address_master_temp % wrap_boundary == 0)
                                            address_master_reg = address_master_temp - wrap_boundary;
                                        else
                                            address_master_reg = address_master_temp;
                                    end
                                    
                            4'b0011:begin	
                                        slave_mem[address_master] =  axis.WDATA [7:0];
                                        address_master_temp = address_master + 1;
                                    
                                        if(address_master_temp % wrap_boundary == 0)
                                            address_master_reg = address_master_temp - wrap_boundary;
                                        else
                                            address_master_reg = address_master_temp;
                                            
                                        slave_mem[address_master_reg] =  axis.WDATA [15:8];
                                        address_master_temp = address_master_reg + 1;
                                        
                                        if(address_master_temp % wrap_boundary == 0)
                                            address_master_reg = address_master_temp - wrap_boundary;
                                        else
                                            address_master_reg = address_master_temp;
                                    end
                                    
                            4'b0101:begin	
                                        slave_mem[address_master] =  axis.WDATA [7:0];
                                        address_master_temp = address_master + 1;
                                        
                                        if(address_master_temp % wrap_boundary == 0)
                                            address_master_reg = address_master_temp - wrap_boundary;
                                        else
                                            address_master_reg = address_master_temp;
                                        slave_mem[address_master_reg] =  axis.WDATA [23:16];
                                        address_master_temp = address_master_reg + 1;
                                        
                                        if(address_master_temp % wrap_boundary == 0)
                                            address_master_reg = address_master_temp - wrap_boundary;
                                        else
                                            address_master_reg = address_master_temp;
                                    end
                                    
                            4'b1001:begin	
                                        slave_mem[address_master] =  axis.WDATA [7:0];
                                        address_master_temp = address_master + 1;
                                        
                                        if(address_master_temp % wrap_boundary == 0)
                                            address_master_reg = address_master_temp - wrap_boundary;
                                        else
                                            address_master_reg = address_master_temp;
                                        
                                        slave_mem[address_master_reg] =  axis.WDATA [31:24];
                                        address_master_temp = address_master_reg + 1;
                                        
                                        if(address_master_temp % wrap_boundary == 0)
                                            address_master_reg = address_master_temp - wrap_boundary;
                                        else
                                            address_master_reg = address_master_temp;
                                    end
                                    
                            4'b0110:begin	
                                        slave_mem[address_master] =  axis.WDATA [15:0];
                                        address_master_temp = address_master + 1;
                                        
                                        if(address_master_temp % wrap_boundary == 0)
                                            address_master_reg = address_master_temp - wrap_boundary;
                                        else
                                            address_master_reg = address_master_temp;
                                        
                                        slave_mem[address_master_reg] =  axis.WDATA [23:16];
                                        address_master_temp = address_master_reg + 1;
                                        
                                        if(address_master_temp % wrap_boundary == 0)
                                            address_master_reg = address_master_temp - wrap_boundary;
                                        else
                                            address_master_reg = address_master_temp;
                                    end
                                    
                            4'b1010:begin	
                                        slave_mem[address_master] =  axis.WDATA [15:8];
                                        address_master_temp = address_master + 1;
                                        
                                        if(address_master_temp % wrap_boundary == 0)
                                            address_master_reg = address_master_temp - wrap_boundary;
                                        else
                                            address_master_reg = address_master_temp;
                                        
                                        slave_mem[address_master_reg] =  axis.WDATA [31:24];
                                        address_master_temp = address_master_reg + 1;
                                        
                                        if(address_master_temp % wrap_boundary == 0)
                                            address_master_reg = address_master_temp - wrap_boundary;
                                        else
                                            address_master_reg = address_master_temp;
                                    end
                                    
                            4'b1100:begin	
                                        slave_mem[address_master] =  axis.WDATA [23:16];
                                        address_master_temp = address_master + 1;
                                        
                                        if(address_master_temp % wrap_boundary == 0)
                                            address_master_reg = address_master_temp - wrap_boundary;
                                        else
                                            address_master_reg = address_master_temp;
                                        
                                        slave_mem[address_master_reg] =  axis.WDATA [31:24];
                                        address_master_temp = address_master_reg + 1;
                                        
                                        if(address_master_temp % wrap_boundary == 0)
                                            address_master_reg = address_master_temp - wrap_boundary;
                                        else
                                            address_master_reg = address_master_temp;
                                    end
                                    
                            4'b0111:begin	
                                        slave_mem[address_master] =  axis.WDATA [7:0];
                                        address_master_temp = address_master + 1;
                                        
                                        if(address_master_temp % wrap_boundary == 0)
                                            address_master_reg = address_master_temp - wrap_boundary;
                                        else
                                            address_master_reg = address_master_temp;
                                        
                                        slave_mem[address_master_reg] =  axis.WDATA [15:8];
                                        address_master_temp = address_master_reg + 1;
                                        
                                        if(address_master_temp % wrap_boundary == 0)
                                            address_master_reg = address_master_temp - wrap_boundary;
                                        else
                                            address_master_reg = address_master_temp;
                                        
                                        slave_mem[address_master_reg] =  axis.WDATA [23:16];
                                        address_master_temp = address_master_reg + 1;
                                        
                                        if(address_master_temp % wrap_boundary == 0)
                                            address_master_reg = address_master_temp - wrap_boundary;
                                        else
                                            address_master_reg = address_master_temp;
                                    end
                                    
                            4'b1110:begin	
                                        slave_mem[address_master] =  axis.WDATA [15:8];
                                        address_master_temp = address_master + 1;
                                        
                                        if(address_master_temp % wrap_boundary == 0)
                                            address_master_reg = address_master_temp - wrap_boundary;
                                        else
                                            address_master_reg = address_master_temp;
                                        
                                        slave_mem[address_master_reg] =  axis.WDATA [23:16];
                                        address_master_temp = address_master_reg + 1;
                                        
                                        if(address_master_temp % wrap_boundary == 0)
                                            address_master_reg = address_master_temp - wrap_boundary;
                                        else
                                            address_master_reg = address_master_temp;
                                        
                                        slave_mem[address_master_reg] =  axis.WDATA [31:24];
                                        address_master_temp = address_master_reg + 1;
                                        
                                        if(address_master_temp % wrap_boundary == 0)
                                            address_master_reg = address_master_temp - wrap_boundary;
                                        else
                                            address_master_reg = address_master_temp;
                                    end
                                    
                            4'b1011:begin	
                                        slave_mem[address_master] =  axis.WDATA [7:0];
                                        address_master_temp = address_master + 1;
                                        
                                        if(address_master_temp % wrap_boundary == 0)
                                            address_master_reg = address_master_temp - wrap_boundary;
                                        else
                                            address_master_reg = address_master_temp;
                                        
                                        slave_mem[address_master_reg] =  axis.WDATA [15:8];
                                        address_master_temp = address_master_reg + 1;
                                        
                                        if(address_master_temp % wrap_boundary == 0)
                                            address_master_reg = address_master_temp - wrap_boundary;
                                        else
                                            address_master_reg = address_master_temp;
                                        
                                        slave_mem[address_master_reg] =  axis.WDATA [31:24];
                                        address_master_temp = address_master_reg + 1;
                                        
                                        if(address_master_temp % wrap_boundary == 0)
                                            address_master_reg = address_master_temp - wrap_boundary;
                                        else
                                            address_master_reg = address_master_temp;
                                    end
                            4'b1101:begin	
                                        slave_mem[address_master] =  axis.WDATA [7:0];
                                        address_master_temp = address_master + 1;
                                        
                                        if(address_master_temp % wrap_boundary == 0)
                                            address_master_reg = address_master_temp - wrap_boundary;
                                        else
                                            address_master_reg = address_master_temp;
                                        
                                        slave_mem[address_master_reg] =  axis.WDATA [23:16];
                                        address_master_temp = address_master_reg + 1;
                                        
                                        if(address_master_temp % wrap_boundary == 0)
                                            address_master_reg = address_master_temp - wrap_boundary;
                                        else
                                            address_master_reg = address_master_temp;
                                        
                                        slave_mem[address_master_reg] =  axis.WDATA [31:24];
                                        address_master_temp = address_master_reg + 1;
                                        
                                        if(address_master_temp % wrap_boundary == 0)
                                            address_master_reg = address_master_temp - wrap_boundary;
                                        else
                                            address_master_reg = address_master_temp;
                                    end
                                    
                            4'b1111: begin	
                                        slave_mem[address_master] =  axis.WDATA [7:0];
                                        address_master_temp = address_master + 1;
                                        
                                        if(address_master_temp % wrap_boundary == 0)
                                            address_master_reg = address_master_temp - wrap_boundary;
                                        else
                                            address_master_reg = address_master_temp;
                                        
                                        slave_mem[address_master_reg] =  axis.WDATA [15:8];
                                        address_master_temp = address_master_reg + 1;
                                        
                                        if(address_master_temp % wrap_boundary == 0)
                                            address_master_reg = address_master_temp - wrap_boundary;
                                        else
                                            address_master_reg = address_master_temp;
                                        
                                        slave_mem[address_master_reg] =  axis.WDATA [23:16];
                                        address_master_temp = address_master_reg + 1;
                                        
                                        if(address_master_temp % wrap_boundary == 0)
                                            address_master_reg = address_master_temp - wrap_boundary;
                                        else
                                            address_master_reg = address_master_temp;
                                        
                                        slave_mem[address_master_reg] =  axis.WDATA [31:24];
                                        address_master_temp = address_master_reg + 1;
                                        
                                        if(address_master_temp % wrap_boundary == 0)
                                            address_master_reg = address_master_temp - wrap_boundary;
                                        else
                                            address_master_reg = address_master_temp;
                                    end
                            default: begin	end
                            endcase
                        end
                endcase
						$display("each beat Meme= %p",slave_mem);
						end
  W_VALID_S:begin
                axis.WREADY = 1'b0;
				WNext_state_S = W_START_S;
				end
		endcase
end



/////////////////////// WRITE RESPONSE CHANNEL SLAVE ////////////////////////////////////////////////////

always_ff @(posedge clk or negedge resetn)	
begin	
	if(!resetn)	begin
		BState_S <= B_IDLE_S;
	end
	else
		BState_S <= BNext_state_S;
end

// Write response Next State Logic
always_comb 
begin
	case(BState_S)
   B_IDLE_S:begin
                axis.BID = '0;
                axis.BRESP = '0;
                axis.BVALID = '0;
                BNext_state_S = B_LAST_S;
            end
            
   B_LAST_S:begin		
                if(axis.WLAST)
                    BNext_state_S = B_START_S;
                else
                    BNext_state_S = B_LAST_S;
                end

  B_START_S:begin
                axis.BID =  axis.AWID;
                if ( axis.AWADDR > 32'h5ff &&  axis.AWADDR <=32'hfff &&  axis.AWSIZE < 3'b011 )
                    axis.BRESP = 2'b00;
                else if(( axis.AWADDR > 32'h1ff &&  axis.AWADDR <=32'h5ff) ||  axis.AWSIZE > 3'b010)
                    axis.BRESP = 2'b10;
                else 
                    axis.BRESP = 2'b11;
                
                axis.BVALID = 1'b1;
                BNext_state_S = B_WAIT_S;	
				end
                
   B_WAIT_S:begin	
				if (axis.BREADY)	begin
					BNext_state_S = B_IDLE_S;
				end
			end
	endcase
end	




/////////////////////// READ ADDRESS CHANNEL SLAVE //////////////////////////////////////////


always_ff @(posedge clk or negedge resetn)
begin
	if (!resetn)	begin
		ARState_S <= AR_IDLE_S;
	end
	else	begin
		ARState_S <= ARNext_state_S;
	end
end	

always_comb
begin 	
     case (ARState_S)
  AR_IDLE_S:begin
                axis.ARREADY = '0;
                ARNext_state_S = AR_WAIT_S;
            end
            
  AR_WAIT_S:begin
                if (axis.ARVALID)
                    ARNext_state_S = AR_READY_S;
                else
                    ARNext_state_S = AR_WAIT_S;
            end
            
 AR_READY_S:begin
                ARNext_state_S = AR_IDLE_S;
                axis.ARREADY = 1'b1;
            end
    endcase
end



///////////////////////////// READ DATA CHANNEL SLAVE /////////////////////////////////////////////////////

    
    //Sequential always block    
always_ff@(posedge clk or negedge resetn)
begin
    if(!resetn) begin
        RState_S    <= R_CLEAR_S;
        counter     <= '0;
    end
    else begin
        RState_S    <= RNext_state_S;
        counter     <= next_counter;
        first_time2 <= first_time2_next;
    end
end
        
always_comb
begin
    if(axis.ARVALID)
        ARADDR_reg1 =  axis.ARADDR;	
        
    unique case(RState_S)
  R_CLEAR_S:begin
                axis.RID = '0;           
                axis.RDATA = '0;         
                axis.RRESP = '0;         
                axis.RLAST = '0;         
                axis.RVALID = '0; 
                first_time2_next = 0;
                next_counter = '0;
                address_read_reg='0;
                address_read='0;
                if(axis.ARVALID) begin
                    RNext_state_S  = R_START_S;
                end
                else
                    RNext_state_S = R_CLEAR_S;
            end
            
  R_START_S:begin
                if( axis.ARADDR > 32'h1ff &&  axis.ARADDR <=32'hfff &&  axis.ARSIZE <3'b100) begin	
                    axis.RID    =  axis.ARID;
                    
                    unique case(axis.ARBURST)
                      2'b00:begin
                                address_read = ARADDR_reg1;
                                unique case (axis.ARSIZE)
                                 3'b000:begin	
                                             axis.RDATA[7:0] = slave_mem[address_read];
                                        end
                                        
                                 3'b001:begin	
                                             axis.RDATA[7:0] = slave_mem[address_read];
                                             axis.RDATA[15:8] = slave_mem[address_read+1];		
                                        end
                                        
                                3'b010:begin	
                                             axis.RDATA[7:0] = slave_mem[address_read];
                                             axis.RDATA[15:8] = slave_mem[address_read+1];
                                             axis.RDATA[23:16] = slave_mem[address_read+2];
                                             axis.RDATA[31:24] = slave_mem[address_read+3];
                                        end
                                endcase
                            end
                                
                      2'b01:begin
                                if(first_time2 == 0) begin
                                    address_read = ARADDR_reg1;
                                    first_time2_next = 1;
                                end	
                                else 
                                    first_time2_next = first_time2;	
                                    
                                if(next_counter ==  axis.ARLEN+4'b1)				
                                    first_time2_next = 0;
                                else 
                                    first_time2_next = first_time2;
                                    
                                unique case (axis.ARSIZE)
                                3'b000:begin	
                                             axis.RDATA[7:0] = slave_mem[address_read];
                                        end
                                        
                                3'b001: begin	
                                             axis.RDATA[7:0] = slave_mem[address_read];
                                             axis.RDATA[15:8] = slave_mem[address_read+1];
                                            address_read_reg = address_read + 2;
                                        end
                                3'b010: begin	
                                        axis.RDATA[7:0] = slave_mem[address_read];
                                        axis.RDATA[15:8] = slave_mem[address_read+1];
                                        axis.RDATA[23:16] = slave_mem[address_read+1];
                                        axis.RDATA[31:24] = slave_mem[address_read+1];
                                        address_read_reg = address_read + 4;
                                        end
                                    endcase
                                end
                                
                      2'b10:begin
                                if(first_time2 == 0) begin
                                    address_read = ARADDR_reg1;
                                    first_time2_next = 1;
                                end	
                                else 
                                    first_time2_next = first_time2;
                                
                                if(next_counter ==  axis.ARLEN+4'b1)				
                                    first_time2_next = 0;
                                else 
                                    first_time2_next = first_time2;
                                
                                unique case( axis.ARLEN)
                                4'b0001:begin
                                            unique case( axis.ARSIZE)
                                             3'b000:begin
                                                        wrap_boundary2 = 2 * 1; 
                                                    end
                                                    
                                             3'b001:begin
                                                        wrap_boundary2 = 2 * 2;																		
                                                    end	
                                                    
                                             3'b010:begin
                                                        wrap_boundary2 = 2 * 4;																		
                                                    end
                                             default: begin	end
                                            endcase			
                                        end
                                        
                                4'b0011:begin
                                            unique case(axis.ARSIZE)
                                             3'b000:begin
                                                        wrap_boundary2 = 4 * 1;
                                                    end
                                                    
                                             3'b001:begin
                                                        wrap_boundary2 = 4 * 2;																		
                                                    end
                                                    
                                             3'b010:begin
                                                        wrap_boundary2 = 4 * 4;																		
                                                    end
                                             default: begin	end
                                            endcase			
                                        end
                                                
                                4'b0111:begin
                                            unique case(axis.ARSIZE)
                                             3'b000:begin
                                                        wrap_boundary2 = 8 * 1;
                                                    end
                                                    
                                             3'b001:begin
                                                        wrap_boundary2 = 8 * 2;																		
                                                    end	
                                                    
                                             3'b010:begin
                                                        wrap_boundary2 = 8 * 4;																		
                                                    end
                                             default: begin	end
                                            endcase			
                                        end	
                                        
                                4'b1111:begin
                                            unique case(axis.ARSIZE)
                                             3'b000:begin
                                                        wrap_boundary2 = 16 * 1;
                                                    end
                                                    
                                             3'b001:begin
                                                        wrap_boundary2 = 16 * 2;																		
                                                    end	
                                                    
                                             3'b010:begin
                                                        wrap_boundary2 = 16 * 4;																		
                                                    end
                                             default: begin	end
                                            endcase			
                                        end
                                endcase						
                                    
                                unique case(axis.ARSIZE)
                                 3'b000:begin	    
                                            axis.RDATA[7:0] = slave_mem[address_read];
                                            address_read_temp = address_read + 1;
                                            
                                            if(address_read_temp % wrap_boundary2 == 0)
                                                address_read_reg = address_read_temp - wrap_boundary2;
                                            else		
                                                address_read_reg = address_read_temp;	
                                        end
                                        
                                 3'b001:begin	
                                            axis.RDATA[7:0] = slave_mem[address_read];
                                            address_read_temp = address_read + 1;
                                            
                                            if(address_read_temp % wrap_boundary2 == 0)
                                                address_read_reg = address_read_temp - wrap_boundary2;
                                            else
                                                address_read_reg = address_read_temp;
                                                
                                            axis.RDATA[15:8] = slave_mem[address_read_reg];
                                            address_read_temp = address_read_reg + 1;
                                            
                                            if(address_read_temp % wrap_boundary2 == 0)
                                                address_read_reg = address_read_temp - wrap_boundary2;
                                            else
                                                address_read_reg = address_read_temp;
                                        end
                                        
                                 3'b010:begin	
                                            axis.RDATA[7:0] = slave_mem[address_read];
                                            address_read_temp = address_read + 1;
                                            
                                            if(address_read_temp % wrap_boundary2 == 0)
                                                address_read_reg = address_read_temp - wrap_boundary2;
                                            else
                                                address_read_reg = address_read_temp;
                                            
                                            axis.RDATA[15:8] = slave_mem[address_read_reg];
                                            address_read_temp = address_read_reg + 1;
                                            
                                            if(address_read_temp % wrap_boundary2 == 0)
                                                address_read_reg = address_read_temp - wrap_boundary2;
                                            else
                                                address_read_reg = address_read_temp;
                                                
                                            axis.RDATA[23:16] = slave_mem[address_read_reg];
                                            address_read_temp = address_read_reg + 1;
                                            
                                            if(address_read_temp % wrap_boundary2 == 0)
                                                address_read_reg = address_read_temp - wrap_boundary2;
                                            else
                                                address_read_reg = address_read_temp;
                                                
                                            axis.RDATA[31:24] = slave_mem[address_read_reg];
                                            address_read_temp = address_read_reg + 1;
                                            
                                            if(address_read_temp % wrap_boundary2 == 0)
                                                address_read_reg = address_read_temp - wrap_boundary2;
                                            else
                                                address_read_reg = address_read_temp;														
                                        end
                                    default: begin	end
                                endcase
                            end
                    endcase
                    
                    axis.RVALID = '1; 
                    next_counter=counter+4'b1;
                    RNext_state_S = R_WAIT_S;
                    axis.RRESP  = 2'b00;
                end
                
                else begin
                    if (axis.ARSIZE >= 3'b011)				
                        axis.RRESP = 2'b10; 
                    else 
                        axis.RRESP = 2'b11; 
                        
                    next_counter=counter+4'b1;
                    RNext_state_S = R_ERROR_S;
                end	
            end
            
   R_WAIT_S:begin
                if(axis.RREADY) begin
                    if(next_counter == axis.ARLEN+4'b1) begin
                        axis.RLAST = '1;
                    end
                    else 
                        axis.RLAST = '0;
        
                RNext_state_S = R_VALID_S;  
                end
                else begin
                    RNext_state_S = R_WAIT_S;
                    end
            end    
            
  R_VALID_S:begin
                axis.RVALID = '0;
                
                if (next_counter == axis.ARLEN+4'b1) begin
                    RNext_state_S =  R_CLEAR_S;
                    axis.RLAST = '0;
                end
                else begin
                    address_read = address_read_reg;
                    RNext_state_S = R_START_S;
                end 
            end	

  R_ERROR_S:begin	
                if (next_counter ==  axis.ARLEN+4'b1) begin
                    axis.RLAST = '1;
                    RNext_state_S =  R_VALID_S;
                end
                else begin
                    axis.RLAST = '0;
                    RNext_state_S = R_START_S;
                end	
            end	
    endcase
end
        
endmodule 