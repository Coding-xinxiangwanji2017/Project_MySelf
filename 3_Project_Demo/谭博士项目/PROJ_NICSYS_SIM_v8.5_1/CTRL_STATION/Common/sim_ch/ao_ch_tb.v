module ao_ch_tb
(
             i_rst_n        ,
             i_ad_spi_clk   ,
             o_ad_spi_mosi  ,
             i_ad_spi_miso  ,
             i_ad_spi_cs    ,
             i_da_spi_clk   ,
             o_da_spi_mosi  ,
             i_da_spi_miso  ,
             i_da_spi_cs
);
input      i_rst_n        ; 
input      i_ad_spi_clk   ; 
output reg o_ad_spi_mosi  ; 
input      i_ad_spi_miso  ; 
input      i_ad_spi_cs    ; 
input      i_da_spi_clk   ; 
output     o_da_spi_mosi  ; 
input      i_da_spi_miso  ; 
input      i_da_spi_cs    ; 
reg [7:0]         r_ad_cnt       ;
reg [2:0]         r_ad_bitcnt    ;
reg [7:0]         r_ad_spi_data  ;

reg [7:0]         r_da_cnt       ;
reg [2:0]         r_da_bitcnt    ;
reg [31:0]        r_da_spi_data  ;
reg [15:0]        r_ao_data      ;
wire[15:0]         w_ao_data      ;
always @ (posedge i_da_spi_clk or negedge i_rst_n)
begin
    if(!i_rst_n)
      r_da_bitcnt <= 'd7;
    else
      r_da_bitcnt <= r_da_bitcnt + 1'b1;    
end
always @ (negedge i_da_spi_clk or negedge i_rst_n)
begin
    if(!i_rst_n)
        r_da_cnt <= 'd0;
    else begin
        if(r_da_cnt > 8'd0)
          r_da_cnt <= r_da_cnt - 1'b1;
       else if((r_da_spi_data[7:0] == 8'h01)&(r_da_spi_data[31:24] == 8'h55)&(r_da_bitcnt == 'd7))
          r_da_cnt <= 'd15 ;
       else 
          r_da_cnt <= r_da_cnt ;
    end   
end

always @ (posedge i_da_spi_clk or negedge i_rst_n)
begin
    if(!i_rst_n)
      r_da_spi_data <= 'd0;
    else
      r_da_spi_data <= {r_da_spi_data[30:0],i_da_spi_miso};    
end

always @ (negedge i_da_spi_clk or negedge i_rst_n)
begin
    if(!i_rst_n)
      r_ao_data <= 'd0;
    else if((r_da_cnt != 'd0)|((r_da_spi_data[7:0] == 8'h01)&(r_da_spi_data[31:24] == 8'h55)&(r_da_bitcnt == 'd7)))
      r_ao_data <= {r_ao_data[14:0],i_da_spi_miso};     
end
assign w_ao_data={r_ao_data[15:1],1'b0};
/////////////////////////////////////////////////////////////////////////////

always @ (posedge i_ad_spi_clk or negedge i_rst_n)
begin
    if(!i_rst_n)
      r_ad_bitcnt <= 'd7;
    else
      r_ad_bitcnt <= r_ad_bitcnt + 1'b1;    
end
always @ (negedge i_ad_spi_clk or negedge i_rst_n)
begin
    if(!i_rst_n)
        r_ad_cnt <= 'd0;
    else begin
       if((r_ad_spi_data == 8'h58)&(r_ad_bitcnt == 'd7))
          r_ad_cnt <= 'd15 ;
       else if(r_ad_cnt != 'd0)
          r_ad_cnt <= r_ad_cnt - 1'b1;
    end   
end

always @ (posedge i_ad_spi_clk or negedge i_rst_n)
begin
    if(!i_rst_n)
      r_ad_spi_data <= 'd0;
    else
      r_ad_spi_data <= {r_ad_spi_data[6:0],i_ad_spi_miso};    
end

always @ (negedge i_ad_spi_clk or negedge i_rst_n)
begin
    if(!i_rst_n)
      o_ad_spi_mosi <= 'd0;
    else if((r_ad_cnt != 'd0)|(r_ad_spi_data == 8'h58))
      o_ad_spi_mosi <= w_ao_data[(r_ad_cnt>0)?(r_ad_cnt-1):15];
    else
      o_ad_spi_mosi <= 'd0;      
end



endmodule