module prog(
	input  wire       clk          ,
	input  wire       rst_n        ,
	input  wire       prog_en      ,
                                 
	input  wire[24:0] prog_addr    ,
	input  wire[9:0]  prog_length  ,
	output reg        prog_done    ,
	                               
	output reg        fifo_rd_en   ,
	input  wire[15:0] fifo_rd_data ,
	input  wire       fifo_rd_valid,
	
  output reg        wr_en        ,
  output reg[24:0]  wr_addr      ,
  output reg[15:0]  wr_data      ,
  input  wire       wr_done      ,  
                                 
  output reg        rd_en        ,
  output reg[24:0]  rd_addr      ,
  input  wire[15:0] rd_data      ,
  input  wire       rd_done      	

);

  parameter IDLE        = 8'b00000001;
  parameter PROG_SET    = 8'b00000010;
  parameter PROG_COUNT  = 8'b00000100;
  parameter PROG_WORD   = 8'b00001000;
  parameter PROG_CONF   = 8'b00010000;
  parameter READ_STATE  = 8'b00100000;
  parameter READ_AGAIN  = 8'b01000000;
  parameter READ_ARRAY  = 8'b10000000;
  
  parameter READ_WAIT   = 8'b11111111;
  
  reg [7:0]  fsm_current_state;
  reg [7:0]  fsm_next_state;
  reg        w_enable_flag;
  reg [24:0] r_addr;
  reg [9:0]  r_length;
  reg [9:0]  r_length_cnt;
  reg [24:0] r_block_addr;
  reg [24:0] r_start_addr;
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
  	else if(fsm_current_state == PROG_WORD)
  	  wr_en <= fifo_rd_valid;
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
    	    if(prog_en)
    	      fsm_next_state = PROG_SET;
    	    else
    	      fsm_next_state = IDLE;
        end
    
    	PROG_SET	:	
    	  begin
    	    if(wr_done)
    	      fsm_next_state = PROG_COUNT;
    	    else
    	      fsm_next_state = PROG_SET;
        end 
        
    	PROG_COUNT	:	
    	  begin
    	    if(wr_done)
    	      fsm_next_state = PROG_WORD;
    	    else
    	      fsm_next_state = PROG_COUNT;
        end        
        
    	PROG_WORD	:	
    	  begin
    	    if(r_length_cnt == r_length + 1)
    	      fsm_next_state = PROG_CONF;
    	    else
    	      fsm_next_state = PROG_WORD;
        end 
        
    	PROG_CONF	:	
    	  begin
    	    if(wr_done)
    	      fsm_next_state = READ_WAIT;
    	    else
    	      fsm_next_state = PROG_CONF;
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
  	  prog_done <= 0;
  	else if(wr_done && fsm_current_state == READ_ARRAY)
  	  prog_done <= 1;
  	else
  	  prog_done <= 0;
  end

  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  r_addr <= 0;
  	else if(prog_en)
  	  r_addr <= prog_addr;
  	else if(wr_done && fsm_current_state == PROG_WORD) 
  	  r_addr <= r_addr + 1;
  	else if(!wr_done && fsm_current_state == PROG_WORD) 
  	  r_addr <= r_addr;  	
  	else if(fsm_current_state == READ_STATE)
  	  r_addr <= 0; 
  	else
  	  r_addr <= r_addr; 	  
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  r_start_addr <= 0;
  	else if(prog_en)
  	  r_start_addr <= prog_addr;
  	else
  	  r_start_addr <= r_start_addr; 	  
  end  
    
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  r_block_addr <= 0;
  	else if(prog_en)
  	  r_block_addr <= {prog_addr[24:17],17'd0};
  	else
  	  r_block_addr <= r_block_addr;
  end  
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  r_length <= 0;
  	else if(prog_en)
  	  r_length <= prog_length;
  	else
  	  r_length <= r_length;
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  wr_addr <= 0;
  	else if(w_enable_flag && fsm_current_state == PROG_SET)
  	  wr_addr <= r_block_addr;
  	else if(w_enable_flag && fsm_current_state == PROG_COUNT)
  	  wr_addr <= r_start_addr;
  	else if(fifo_rd_valid && fsm_current_state == PROG_WORD)
  	  wr_addr <= r_addr;  
  	else if(w_enable_flag && fsm_current_state == PROG_CONF)
  	  wr_addr <= r_start_addr;
  	else
  	  wr_addr <= 0;
  end  
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  rd_addr <= 0;
  	else if(w_enable_flag && (fsm_current_state == READ_STATE || fsm_current_state == READ_AGAIN))
  	  rd_addr <= r_block_addr;
  	else
  	  rd_addr <= 0;
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  wr_data <= 0;
  	else if(w_enable_flag && fsm_current_state == PROG_SET)
  	  wr_data <= 16'h00e9;
  	else if(w_enable_flag && fsm_current_state == PROG_COUNT)
  	  wr_data <= r_length;
  	else if(w_enable_flag && fsm_current_state == PROG_CONF)
  	  wr_data <= 16'h00d0;
  	else if(w_enable_flag && fsm_current_state == READ_ARRAY)
  	  wr_data <= 16'h00ff;
  	else if(fsm_current_state == PROG_WORD)
  	  wr_data <= fifo_rd_data;
  	else
  	  wr_data <= 0;
  end

  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  fifo_rd_en <= 0;
  	else if(fsm_current_state == PROG_COUNT)
  	  fifo_rd_en <= wr_done;
  	else if(r_length_cnt != r_length && fsm_current_state == PROG_WORD)
  	  fifo_rd_en <= wr_done;
  	else
  	  fifo_rd_en <= 0;
  end

  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  r_length_cnt <= 0;
  	else if(fsm_current_state == PROG_WORD && wr_done)
  	  r_length_cnt <= r_length_cnt + 1;
  	else if(fsm_current_state == PROG_WORD && !wr_done)
  	  r_length_cnt <= r_length_cnt;
  	else
  	  r_length_cnt <= 0;
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