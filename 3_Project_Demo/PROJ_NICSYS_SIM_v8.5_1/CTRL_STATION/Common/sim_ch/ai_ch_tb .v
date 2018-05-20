module ai_ch_tb
(            
             i_rst_n     ,
             i_spi_clk   ,
             o_spi_mosi  ,
             i_spi_miso  ,
             i_spi_cs
);
input             i_rst_n     ;
input             i_spi_clk   ;
output reg        o_spi_mosi  ;
input             i_spi_miso  ;
input             i_spi_cs    ;
reg [7:0]         r_spi_data  ;
reg [23:0]        r_ai_data   ;
reg [7:0]         r_cnt       ;
reg [2:0]         r_bitcnt    ;
reg [23:0]        r_config    ;
always @ (posedge i_spi_clk or negedge i_rst_n)
begin
    if(!i_rst_n)
      r_bitcnt <= 'd7;
    else
      r_bitcnt <= r_bitcnt + 1'b1;    
end
     
always @ (posedge i_spi_clk or negedge i_rst_n)
begin
    if(!i_rst_n)
      r_spi_data <= 'd0;
    else
      r_spi_data <= {r_spi_data[6:0],i_spi_miso};    
end

always @ (negedge i_spi_clk or negedge i_rst_n)
begin
    if(!i_rst_n)
        r_config <= 'd0;
    else 
       if(r_bitcnt == 'd7)
          r_config <= {r_config[15:0],r_spi_data} ; 
end

always @ (negedge i_spi_clk or negedge i_rst_n)
begin
    if(!i_rst_n)
        r_cnt <= 'd0;
    else begin
       if((r_spi_data == 8'h58)&(r_bitcnt == 'd7))
          r_cnt <= 'd23 ;
       else if(r_cnt != 'd0)
          r_cnt <= r_cnt - 1'b1;
    end   
end

always @ (negedge i_spi_clk or negedge i_rst_n)
begin
    if(!i_rst_n)
      o_spi_mosi <= 'd0;
    else if((r_cnt !== 'd0)|((r_spi_data == 8'h58)&(r_bitcnt == 'd7)))
      o_spi_mosi <= r_ai_data[23];
    else
      o_spi_mosi <= 'd0;      
end

always @ (posedge i_spi_clk or negedge i_rst_n)
begin
    if(!i_rst_n)
     r_ai_data <= 'h123456;
    else
    begin   
     if((r_cnt !== 'd0)|((r_spi_data == 8'h58)))
      r_ai_data <= {{r_ai_data[22:1],1'b0},r_ai_data[23]}; 
     else if(r_config == 'h100092)  
      r_ai_data <= 'h100092;  

     else if(r_config[15:0] == 'h2810)
      r_ai_data <= 'h002810;

     else if(r_config[15:0] == 'h2850)
      r_ai_data <= 'h123456;

    end  
end

endmodule