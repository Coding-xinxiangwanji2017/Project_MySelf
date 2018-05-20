module bread(
	input  wire       clk        ,
	input  wire       rst_n      ,
	input  wire       read_en    ,

	input  wire[24:0] read_addr  ,
	input  wire[16:0] read_length,
	output reg[15:0]  read_data  ,
	output reg        read_valid ,
	output reg        read_done  ,
	
  output reg        wr_en      ,
  output reg[24:0]  wr_addr    ,
  output reg[15:0]  wr_data    ,
  input  wire       wr_done    ,  
                               
  output reg        rd_en      ,
  output reg[24:0]  rd_addr    ,
  output reg[16:0]  rd_length  ,
  input  wire[15:0] rd_data    ,
  input  wire       rd_valid   ,
  input  wire       rd_done    	

);

  parameter IDLE        = 6'b000001;
  parameter SREAD_SET   = 6'b000010;
  parameter SREAD_CONF  = 6'b000100;
  parameter BURST_READ  = 6'b001000;
  parameter AREAD_SET   = 6'b010000;
  parameter AREAD_CONF  = 6'b100000;
    
  reg [5:0]  fsm_current_state;
  reg [5:0]  fsm_next_state;
  reg        w_enable_flag;
  reg [24:0] r_addr;
  reg [16:0] r_length;
    
  wire      w_flag;
  wire      w_state_flag;

  assign w_state_flag  = (fsm_current_state == fsm_next_state)? 0 : 1;
  assign w_flag = (fsm_next_state == IDLE)? 0 : w_state_flag;


  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  read_data <= 0;
  	else if(fsm_current_state == BURST_READ)
  	  read_data <= rd_data;
  	else
  	  read_data <= 0;  		
  end 
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  read_valid <= 0;
  	else if(fsm_current_state == BURST_READ)
  	  read_valid <= rd_valid;
  	else
  	  read_valid <= 0;
  end 
    
//  assign read_data  = rd_data;
//  assign read_valid = rd_valid;
  
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
  	else if(fsm_current_state == BURST_READ)
  	  wr_en <= 0;
  	else
  	  wr_en <= w_enable_flag;
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  rd_en <= 0;
  	else if(fsm_current_state == BURST_READ)
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
    	    if(read_en)
    	      fsm_next_state = SREAD_SET;
    	    else
    	      fsm_next_state = IDLE;
        end
    
    	SREAD_SET	:	
    	  begin
    	    if(wr_done)
    	      fsm_next_state = SREAD_CONF;
    	    else
    	      fsm_next_state = SREAD_SET;
        end 
        
    	SREAD_CONF	:	
    	  begin
    	    if(wr_done)
    	      fsm_next_state = BURST_READ;
    	    else
    	      fsm_next_state = SREAD_CONF;
        end 
        
    	BURST_READ	:	
    	  begin
    	    if(rd_done)
    	      fsm_next_state = AREAD_SET;
    	    else
    	      fsm_next_state = BURST_READ;
        end        
        
    	AREAD_SET	:	
    	  begin
    	    if(wr_done)
    	      fsm_next_state = AREAD_CONF;
    	    else
    	      fsm_next_state = AREAD_SET;
        end        

    	AREAD_CONF	:	
    	  begin
    	    if(wr_done)
    	      fsm_next_state = IDLE;
    	    else
    	      fsm_next_state = AREAD_CONF;
        end
                 
    endcase
        
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  read_done <= 0;
  	else if(wr_done && fsm_current_state == AREAD_CONF)
  	  read_done <= 1;
  	else
  	  read_done <= 0;
  end

  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  r_addr <= 0;
  	else if(read_en)
  	  r_addr <= read_addr;
  	else
  	  r_addr <= r_addr;
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  r_length <= 0;
  	else if(read_en)
  	  r_length <= read_length;
  	else
  	  r_length <= r_length;
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  wr_addr <= 0;
  	else if(w_enable_flag && fsm_current_state == SREAD_SET)
  	  wr_addr <= 25'h6407;//h6407
  	else if(w_enable_flag && fsm_current_state == SREAD_CONF)
  	  wr_addr <= 25'h6407;
  	else if(w_enable_flag && fsm_current_state == AREAD_SET)
  	  wr_addr <= 25'h8000;
  	else if(w_enable_flag && fsm_current_state == AREAD_CONF)
  	  wr_addr <= 25'h8000;
  	else
  	  wr_addr <= 0;
  end  
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  rd_addr <= 0;
  	else if(w_enable_flag && fsm_current_state == BURST_READ)
  	  rd_addr <= r_addr;
  	else
  	  rd_addr <= 0;
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  rd_length <= 0;
  	else if(w_enable_flag && fsm_current_state == BURST_READ)
  	  rd_length <= r_length;
  	else
  	  rd_length <= 0;
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  wr_data <= 0;
  	else if(w_enable_flag && fsm_current_state == SREAD_SET)
  	  wr_data <= 16'h0060;
  	else if(w_enable_flag && fsm_current_state == SREAD_CONF)
  	  wr_data <= 16'h0003;
  	else if(w_enable_flag && fsm_current_state == AREAD_SET)
  	  wr_data <= 16'h0060;
  	else if(w_enable_flag && fsm_current_state == AREAD_CONF)
  	  wr_data <= 16'h0003;
  	else
  	  wr_data <= 0;
  end
    
endmodule