module aread(

	input  wire       clk      , 
	input  wire       rst_n    ,
                    
  input  wire       rd_en    ,
  input  wire[24:0] rd_addr  ,
  output reg [15:0] rd_data  ,
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
  reg [3:0]  r_cnt;
  reg [24:0] r_addr;
  reg [15:0] r_data;
 
  assign we_n = 1;
  assign dq_oe = 0; 
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  r_data <= 0;
  	else if(wt_n && r_cnt == 6)
  	  r_data <= dq_i;
  	else
  	  r_data <= r_data;  	  
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
  	else if(r_cnt == 4'd11)
  	  r_cnt_en <= 0;  	  
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  rd_done <= 0;
  	else if(r_cnt == 4'd11)
  	  rd_done <= 1;  
  	else
  	  rd_done <= 0;	  
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  rd_data <= 0;
  	else if(r_cnt == 4'd11)
  	  rd_data <= r_data;  
  	else
  	  rd_data <= 0;	  
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
  	else if(r_cnt == 4'd0 && r_cnt_en == 1)
  	  a <= r_addr;
  	else if(r_cnt == 4'd10 && r_cnt_en == 1)
  	  a <= 0; 
  	else
  	  a <= a; 	  
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  ce_n <= 1;
  	else if(r_cnt == 4'd0 && r_cnt_en == 1)
  	  ce_n <= 0;
  	else if(r_cnt == 4'd10 && r_cnt_en == 1)
  	  ce_n <= 1; 
  	else
  	  ce_n <= ce_n; 	  
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  oe_n <= 1;
  	else if(r_cnt == 4'd0 && r_cnt_en == 1)
  	  oe_n <= 0;
  	else if(r_cnt == 4'd10 && r_cnt_en == 1)
  	  oe_n <= 1; 
  	else
  	  oe_n <= oe_n; 	  
  end  

  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  adv_n <= 1;
  	else if(r_cnt == 4'd0 && r_cnt_en == 1)
  	  adv_n <= 0;
  	else
  	  adv_n <= 1; 	  
  end  

endmodule