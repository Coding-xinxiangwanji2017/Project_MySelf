//`define sim;
module control(											
	input  wire          clk         ,
	input  wire          rst_n       ,
		                               
	input  wire          wr_flash    ,
	input  wire          rd_flash    ,
                                   
	input  wire          era         ,	
	input  wire[13:0]    row         ,
	                                 
	output reg           erase_en    ,
	output reg[24:0]     erase_addr  ,
	input  wire          erase_done  ,	
	                                 
	output reg           prog_en     ,
	output reg[24:0]     prog_addr   ,
	output reg[9:0]      prog_length , 
	input  wire          prog_done   ,
	                                 
	output reg           read_en     ,
	output reg[24:0]     read_addr   ,
	output reg[16:0]     read_length ,
	input  wire          read_done   ,	
	                                 
	output wire          toe_done    ,
	output wire          move_done   ,	
	output reg           busy           
);

`ifdef sim 
  parameter ERASE_64 = 0; //1 - 1
  parameter ERASE_1  = 0 ; //1 - 1  
`else
  parameter ERASE_64 = 63 ;//64 - 1 
  parameter ERASE_1  = 0 ; //1 - 1
`endif

  parameter IDLE        = 7'b0000001;
  parameter ERASE_BEGIN = 7'b0000010;
  parameter ERASE_WAIT  = 7'b0000100;
  parameter WRITE_BEGIN = 7'b0001000;
  parameter WRITE_WAIT  = 7'b0010000;
  parameter READ_BEGIN  = 7'b0100000;
  parameter READ_WAIT   = 7'b1000000;
  
  reg[6:0]   c_state;
  reg[6:0]   n_state;
  wire[13:0] r_row;
  reg[9:0]   erase_cnt;
  reg[9:0]   r_erase_num;
  reg[24:0]  r_erase_addr;  
  wire       all_erase_done;
             
  reg[9:0]   write_cnt;
  reg[9:0]   r_write_num;
  reg[24:0]  r_write_addr; 
  wire       all_write_done;

  reg[24:0] r_read_addr; 
  
  assign toe_done  = all_erase_done || all_write_done;
  assign move_done = read_done;  
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  		c_state <= IDLE;
  	else
  		c_state <= n_state;
  end
  
  always @ (*)
  begin
  	if(!rst_n)
  		n_state = IDLE;
  	else case(c_state)
  		IDLE :
  		begin
  			if(era)
  				n_state = ERASE_BEGIN;
  			else if(wr_flash)
  				n_state = WRITE_BEGIN;
  		  else if(rd_flash)
  		  	n_state = READ_BEGIN;
  		  else
  		  	n_state = IDLE;
  		end

  		ERASE_BEGIN : 
  		begin
  		  	n_state = ERASE_WAIT;
  		end
  		
  		ERASE_WAIT : 
  		begin
  			if(all_erase_done)
  				n_state = IDLE;
  		  else if(erase_done)
  		  	n_state = ERASE_BEGIN;
  		  else
  		  	n_state = ERASE_WAIT;
  		end
  		  		
  		WRITE_BEGIN :
  		begin
  		  	n_state = WRITE_WAIT;
  		end

  		WRITE_WAIT : 
  		begin
  			if(all_write_done)
  				n_state = IDLE;
  		  else if(prog_done)
  		  	n_state = WRITE_BEGIN;
  		  else
  		  	n_state = WRITE_WAIT;
  		end
  		  		
  		READ_BEGIN :
  		begin
  		  	n_state = READ_WAIT;
  		end

  		READ_WAIT : 
  		begin
  			if(read_done)
  				n_state = IDLE;
  		  else if(read_done)
  		  	n_state = READ_BEGIN;
  		  else
  		  	n_state = READ_WAIT;
  		end
  		
  		default : n_state = IDLE;
  		  		
    endcase
  end

//  always @ (posedge clk or negedge rst_n)
//  begin
//  	if(!rst_n)
//  		r_row <= 0;
//  	else if(era || wr_flash || rd_flash)
//  		r_row <= row - 14'h800;
//  	else
//  		r_row <= r_row;
//  end

    assign r_row = row - 14'h800; 
  
  //²Á³ý  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  		r_erase_num <= 0;
  	else if(row[13:11] == 3'd1)
  		r_erase_num <= ERASE_64;
  	else if(row[13:11] == 3'd2)
  		r_erase_num <= ERASE_64;
  	else if(row[13:11] == 3'd3)
  		r_erase_num <= ERASE_1;  		
  	else
  		r_erase_num <= r_erase_num;
  end

  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  		erase_en <= 0;
  	else if(c_state == ERASE_BEGIN)
  		erase_en <= 1;
  	else
  		erase_en <= 0;
  end

  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  		erase_addr <= 0;
  	else if(c_state == ERASE_BEGIN)
  		erase_addr <= r_erase_addr;
  	else
  		erase_addr <= 0;
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  		r_erase_addr <= 0;
  	else if(era && row[13:11] == 3'd1)
  		r_erase_addr <= 25'h0000000;
  	else if(era && row[13:11] == 3'd2)
  		r_erase_addr <= 25'h0800000;
  	else if(era && row[13:11] == 3'd2)
  		r_erase_addr <= 25'h1000000;
  	else if(all_erase_done)
  		r_erase_addr <= 0;
  	else if(erase_done)
  		r_erase_addr <= r_erase_addr + 25'h0020000;
  	else
  		r_erase_addr <= r_erase_addr;
  end

  assign all_erase_done = (erase_cnt == r_erase_num && erase_done)? 1 : 0;

  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  		erase_cnt <= 0;
  	else if(erase_cnt == r_erase_num && erase_done)
  		erase_cnt <= 0;
  	else if(erase_done)
  		erase_cnt <= erase_cnt + 1;
  	else
  		erase_cnt <= erase_cnt;
  end

  //Ð´
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  		r_write_num <= 0;
  	else if(row[13:11] == 3'd1 || row[13:11] == 3'd2)
      r_write_num <= 4; 
  	else if(row[13:11] == 3'd3)
      r_write_num <= 3; 	
  	else
  		r_write_num <= r_write_num;
  end  
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  		prog_length <= 0;
  	else if(row[13:11] == 3'd1 || row[13:11] == 3'd2)
      begin
      	if(write_cnt <= 3)
  		    prog_length <= 511; 
  		  else
  		  	prog_length <= 21;     		
      end
  	else if(row[13:11] == 3'd3)
      begin
      	if(write_cnt <= 2)
  		    prog_length <= 511; 
  		  else
  		  	prog_length <= 21;     		
      end		
  	else
  		prog_length <= prog_length;
  end  
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  		prog_en <= 0;
  	else if(c_state == WRITE_BEGIN)
  		prog_en <= 1;
  	else
  		prog_en <= 0;
  end

  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  		prog_addr <= 0;
  	else if(c_state == WRITE_BEGIN)
  		prog_addr <= r_write_addr;
  	else
  		prog_addr <= 0;
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  		r_write_addr <= 0;
  	else if(wr_flash)
  		r_write_addr <= {r_row[12:0],12'd0};
  	else if(all_write_done)
  		r_write_addr <= 0;
  	else if(prog_done)
  		r_write_addr <= r_write_addr + 25'h0000200;
  	else
  		r_write_addr <= r_write_addr;
  end

  assign all_write_done = (write_cnt == r_write_num && prog_done)? 1 : 0;

  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  		write_cnt <= 0;
  	else if(write_cnt == r_write_num && prog_done)
  		write_cnt <= 0;
  	else if(prog_done)
  		write_cnt <= write_cnt + 1;
  	else
  		write_cnt <= write_cnt;
  end  

  //¶Á  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  		read_en <= 0;
  	else if(c_state == READ_BEGIN)
  		read_en <= 1;
  	else
  		read_en <= 0;
  end

  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  		read_addr <= 0;
  	else if(c_state == READ_BEGIN)
  		read_addr <= r_read_addr;
  	else
  		read_addr <= 0;
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  		r_read_addr <= 0;
  	else if(rd_flash)
  		r_read_addr <= {r_row[12:0],12'd0};
  	else if(read_done)
  		r_read_addr <= 0;
  	else
  		r_read_addr <= r_read_addr;
  end

  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  		read_length <= 0;
  	else if(row[13:11] == 3'd1 || row[13:11] == 3'd2)
      read_length <= 2069;
  	else if(row[13:11] == 3'd3)
      read_length <= 1557;	
  	else
  		read_length <= read_length;
  end 

  //busy
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  		busy <= 0;
  	else if(era || wr_flash || rd_flash)
      busy <= 1;
  	else if(toe_done || move_done)
      busy <= 0;	
  	else
  		busy <= busy;
  end
            
endmodule