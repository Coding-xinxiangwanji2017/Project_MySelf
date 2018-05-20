module erase(
	input  wire       clk        ,
	input  wire       rst_n      ,
	input  wire       erase_en   ,

	input  wire[24:0] erase_addr ,
	output reg        erase_done ,
	
  output reg        wr_en      ,
  output reg[24:0]  wr_addr    ,
  output reg[15:0]  wr_data    ,
  input  wire       wr_done    ,  
                               
  output reg        rd_en      ,
  output reg[24:0]  rd_addr    ,
  input  wire[15:0] rd_data    ,
  input  wire       rd_done    	

);

  parameter IDLE        = 8'b00000001;
  parameter UNLOCK_SET  = 8'b00000010;
  parameter UNLOCK_CONF = 8'b00000100;
  parameter ERASE_SET   = 8'b00001000;
  parameter ERASE_CONF  = 8'b00010000;
  parameter READ_STATE  = 8'b00100000;
  parameter READ_AGAIN  = 8'b01000000;
  parameter READ_ARRAY  = 8'b10000000;
  
  parameter READ_WAIT   = 8'b11111111;
  
  reg [7:0]  fsm_current_state;
  reg [7:0]  fsm_next_state;
  reg        w_enable_flag;
  reg [24:0] r_addr;
  reg [9:0]  wait_cnt;
    
  wire      w_flag;
  wire      w_state_flag;

  assign w_state_flag  = (fsm_current_state == fsm_next_state)? 0 : 1;
  assign w_flag = (fsm_next_state == IDLE)? 0 : w_state_flag;
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  w_enable_flag <= 0;
  	else
  	  w_enable_flag <= w_flag;
  end 
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  wr_en <= 0;
  	else if(fsm_current_state == READ_STATE || fsm_current_state == READ_AGAIN)
  	  wr_en <= 0;
  	else
  	  wr_en <= w_enable_flag;
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  rd_en <= 0;
  	else if(fsm_current_state == READ_STATE || fsm_current_state == READ_AGAIN)
  	  rd_en <= w_enable_flag;
  	else
  	  rd_en <= 0;
  end

  always @ (posedge clk or negedge rst_n)
  begin 
    if(!rst_n)
      fsm_current_state <= IDLE;
    else
      fsm_current_state <= fsm_next_state;      
  end

  always @ (*)
  begin 
    if(!rst_n)
      fsm_next_state = IDLE;
    else case(fsm_current_state)
  
    	IDLE	:	
    	  begin
    	    if(erase_en)
    	      fsm_next_state = UNLOCK_SET;
    	    else
    	      fsm_next_state = IDLE;
        end
    
    	UNLOCK_SET	:	
    	  begin
    	    if(wr_done)
    	      fsm_next_state = UNLOCK_CONF;
    	    else
    	      fsm_next_state = UNLOCK_SET;
        end 
        
    	UNLOCK_CONF	:	
    	  begin
    	    if(wr_done)
    	      fsm_next_state = ERASE_SET;
    	    else
    	      fsm_next_state = UNLOCK_CONF;
        end        
        
    	ERASE_SET	:	
    	  begin
    	    if(wr_done)
    	      fsm_next_state = ERASE_CONF;
    	    else
    	      fsm_next_state = ERASE_SET;
        end 
        
    	ERASE_CONF	:	
    	  begin
    	    if(wr_done)
    	      fsm_next_state = READ_WAIT;
    	    else
    	      fsm_next_state = ERASE_CONF;
        end                

    	READ_WAIT	:	
    	  begin
    	    if(wait_cnt == 20)
    	      fsm_next_state = READ_STATE;
    	    else
    	      fsm_next_state = READ_WAIT;
        end
        
    	READ_STATE	:	
    	  begin
    	    if(rd_done && rd_data[7])
    	      fsm_next_state = READ_ARRAY;
    	    else if(rd_done && ~rd_data[7])
    	      fsm_next_state = READ_AGAIN;
    	    else
    	      fsm_next_state = READ_STATE;
        end 
        
    	READ_AGAIN	:	
    	  begin
    	    if(rd_done && rd_data[7])
    	      fsm_next_state = READ_ARRAY;
    	    else if(rd_done && ~rd_data[7])
    	      fsm_next_state = READ_STATE;
    	    else
    	      fsm_next_state = READ_AGAIN;
        end
        
    	READ_ARRAY	:	
    	  begin
    	    if(wr_done)
    	      fsm_next_state = IDLE;
    	    else
    	      fsm_next_state = READ_ARRAY;
        end         
          
    endcase
        
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  erase_done <= 0;
  	else if(wr_done && fsm_current_state == READ_ARRAY)
  	  erase_done <= 1;
  	else
  	  erase_done <= 0;
  end

  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  r_addr <= 0;
  	else if(erase_en)
  	  r_addr <= erase_addr;
  	else
  	  r_addr <= r_addr;
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  wr_addr <= 0;
  	else if(w_enable_flag && fsm_current_state != READ_STATE && fsm_current_state != READ_AGAIN)
  	  wr_addr <= r_addr;
  	else
  	  wr_addr <= 0;
  end  
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  rd_addr <= 0;
  	else if(w_enable_flag && (fsm_current_state == READ_STATE || fsm_current_state == READ_AGAIN))
  	  rd_addr <= r_addr;
  	else
  	  rd_addr <= 0;
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  wr_data <= 0;
  	else if(w_enable_flag && fsm_current_state == UNLOCK_SET)
  	  wr_data <= 16'h0060;
  	else if(w_enable_flag && fsm_current_state == UNLOCK_CONF)
  	  wr_data <= 16'h00d0;
  	else if(w_enable_flag && fsm_current_state == ERASE_SET)
  	  wr_data <= 16'h0020;
  	else if(w_enable_flag && fsm_current_state == ERASE_CONF)
  	  wr_data <= 16'h00d0;
  	else if(w_enable_flag && fsm_current_state == READ_ARRAY)
  	  wr_data <= 16'h00ff;
  	else
  	  wr_data <= 0;
  end

  //wait_cnt
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  wait_cnt <= 0;
  	else if(wait_cnt == 20 && fsm_current_state == READ_WAIT)
  	  wait_cnt <= 0;
  	else if(fsm_current_state == READ_WAIT)
  	  wait_cnt <= wait_cnt + 1;
  	else
  	  wait_cnt <= 0;
  end
      
endmodule