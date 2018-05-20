module write(

	input  wire       clk      , 
	input  wire       rst_n    ,
                    
  input  wire       wr_en    ,
  input  wire[24:0] wr_addr  ,
  input  wire[15:0] wr_data  ,
  output reg        wr_done  ,  
  output wire       dq_oe    , 
                   
  output reg [24:0] a        ,
  output reg [15:0] dq_o     ,
  output reg        ce_n     ,
  output reg        we_n     ,
  output reg        adv_n    ,
  output wire       oe_n     
);

  reg        r_cnt_en;
  reg [3:0]  r_cnt;
  reg [24:0] r_addr;
  reg [15:0] r_data;
  
  assign oe_n = 1;
  assign dq_oe = r_cnt_en;
    
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
  	else if(wr_en)
  	  r_cnt_en <= 1;
  	else if(r_cnt == 4'd6)
  	  r_cnt_en <= 0;  	  
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  wr_done <= 0;
  	else if(r_cnt == 4'd6)
  	  wr_done <= 1;  
  	else
  	  wr_done <= 0;	  
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  r_addr <= 0;
  	else if(wr_en)
  	  r_addr <= wr_addr;
  	else
  	  r_addr <= r_addr;  	  
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  r_data <= 0;
  	else if(wr_en)
  	  r_data <= wr_data;
  	else
  	  r_data <= r_data;  	  
  end

  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  a <= 0;
  	else if(r_cnt == 4'd0 && r_cnt_en == 1)
  	  a <= r_addr;
  	else if(r_cnt == 4'd6 && r_cnt_en == 1)
  	  a <= 0; 
  	else
  	  a <= a; 	  
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  dq_o <= 0;
  	else if(r_cnt == 4'd0 && r_cnt_en == 1)
  	  dq_o <= r_data;
  	else if(r_cnt == 4'd6 && r_cnt_en == 1)
  	  dq_o <= 0; 
  	else
  	  dq_o <= dq_o; 	  
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  ce_n <= 1;
  	else if(r_cnt == 4'd0 && r_cnt_en == 1)
  	  ce_n <= 0;
  	else if(r_cnt == 4'd5 && r_cnt_en == 1)
  	  ce_n <= 1; 
  	else
  	  ce_n <= ce_n; 	  
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
  	if(!rst_n)
  	  we_n <= 1;
  	else if(r_cnt == 4'd0 && r_cnt_en == 1)
  	  we_n <= 0;
  	else if(r_cnt == 4'd5 && r_cnt_en == 1)
  	  we_n <= 1; 
  	else
  	  we_n <= we_n; 	  
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