module sread(

	input  wire       clk      , 
	input  wire       rst_n    ,
                    
  input  wire       rd_en    ,
  input  wire[24:0] rd_addr  ,
  input  wire[16:0] rd_length,
  output reg [15:0] rd_data  ,
  output reg        rd_valid ,
  output reg        rd_done  , 
  output wire       dq_oe    , 

  input  wire[15:0] dq_i     ,                 
  output reg [24:0] a        ,
  output reg        ce_n     ,
  output reg        oe_n     ,
  output reg        adv_n    ,
  output wire       we_n     ,
  input  wire       wt_n
);

  reg        r_cnt_en;
  reg        r_valid;
  reg        r_valid1;
  reg [16:0] r_cnt;
  reg [16:0] rd_cnt;
  reg [24:0] r_addr;
  reg [15:0] r_data;
  reg [16:0] r_length;
  reg [15:0] dq_ii;
   
  assign we_n = 1;
  assign dq_oe = 0; 

  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  r_data <= 0;
  	else
  	  r_data <= dq_ii;	  
  end

  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  dq_ii <= 0;
  	else
  	  dq_ii <= dq_i;	  
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  r_length <= 0;
  	else if(rd_en)
  	  r_length <= rd_length;
  	else
  		r_length <= r_length;	  
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  rd_data <= 0;
  	else if(wt_n)
  	  rd_data <= r_data;
  	else
  	  rd_data <= 0;  	  
  end 
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  rd_valid <= 0;
  	else if(wt_n && r_cnt >= 16 && r_cnt <= r_length + 16)
  	  rd_valid <= 1;
  	else
  	  rd_valid <= 0;  	  
  end 

//  always @ (posedge clk or negedge rst_n)
//  begin
//  	if(!rst_n)
//  	  r_valid1 <= 0;
//  	else
//  	  r_valid1 <= r_valid;  	  
//  end

//  always @ (posedge clk or negedge rst_n)
//  begin
//  	if(!rst_n)
//  	  rd_valid <= 0;
//  	else
//  	  rd_valid <= r_valid;  	  
//  end
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  rd_cnt <= 0;
  	else if(r_valid && rd_cnt == r_length)
  	  rd_cnt <= rd_cnt;
  	else if(r_valid)
  	  rd_cnt <= rd_cnt + 1;  
  	else if(rd_done)
  		rd_cnt <= 0;
  	else
  		rd_cnt <= 0;	  
  end   
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  r_cnt <= 0;
  	else if(r_cnt_en)
  	  r_cnt <= r_cnt + 1;
  	else
  	  r_cnt <= 0;  	  
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  r_cnt_en <= 0;
  	else if(rd_en)
  	  r_cnt_en <= 1;
  	else if(r_cnt == 10'd18 + r_length)
  	  r_cnt_en <= 0;  	  
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  rd_done <= 0;
  	else if(r_cnt == 10'd18 + r_length)
  	  rd_done <= 1;  
  	else
  	  rd_done <= 0;	  
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  r_addr <= 0;
  	else if(rd_en)
  	  r_addr <= rd_addr;
  	else
  	  r_addr <= r_addr;  	  
  end

  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  a <= 0;
  	else if(r_cnt == 10'd0 && r_cnt_en == 1)
  	  a <= r_addr;   
  	else if(r_cnt == 10'd17 + r_length && r_cnt_en == 1)
  	  a <= 0; 
  	else
  	  a <= a; 	  
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  ce_n <= 1;
  	else if(r_cnt == 10'd0 && r_cnt_en == 1)
  	  ce_n <= 0;     
  	else if(r_cnt == 10'd17 + r_length && r_cnt_en == 1)
  	  ce_n <= 1; 
  	else
  	  ce_n <= ce_n; 	  
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  oe_n <= 1;
  	else if(r_cnt == 10'd0 && r_cnt_en == 1)
  	  oe_n <= 0;
  	else if(r_cnt == 10'd17 + r_length && r_cnt_en == 1)
  	  oe_n <= 1; 
  	else
  	  oe_n <= oe_n; 	  
  end  

  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  adv_n <= 1;
  	else if(r_cnt == 10'd0 && r_cnt_en == 1)
  	  adv_n <= 0;
  	else
  	  adv_n <= 1; 	  
  end  

endmodule