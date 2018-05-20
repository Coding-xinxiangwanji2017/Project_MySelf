`define    CH_NUM      12 
module AI_CH_TOP( 
                  clk,
                  rst,
                  i_parwren ,
                  im_paraddr,
                  im_pardata,
                  i_rdren   ,
                  im_rdaddr,
                  om_rddata,
                  
                  spi_clk  ,
                  spi_miso ,
                  spi_mosi ,
                  spi_low  ,
                  led_ctrl
                 );
input                         clk       ;
input                         rst       ;                 
input    [11:0]               im_paraddr; 
input                         i_parwren ; 
input    [7:0]                im_pardata; 
input    [11:0]               im_rdaddr ; 
output   [7:0]                om_rddata ; 
input                         i_rdren   ; 
                 
output  [`CH_NUM-1:0]         spi_clk   ;  
input   [`CH_NUM-1:0]         spi_miso  ;  
output  [`CH_NUM-1:0]         spi_mosi  ;  
output  [`CH_NUM-1:0]         spi_low   ;

output  [`CH_NUM*2-1:0]       led_ctrl  ;
generate
genvar i;
for(i=0;i<`CH_NUM;i=i+1)
    begin:ai_ch
       ai_ch #(.CH_ADD(i*128))  
       AI_CH                                  
                   (
                  .clk         (clk         ),
                  .rst_n       (rst         ),
                  .i_parwren   (i_parwren   ),
                  .im_paraddr  (im_paraddr  ),
                  .im_pardata  (im_pardata  ),
                  .i_rdren     (i_rdren     ),
                  .im_rdaddr   (im_rdaddr   ),
                  .om_rddata   (om_rddata   ),
                  .spi_clk     (spi_clk[i]  ),
                  .spi_miso    (spi_miso[i] ),
                  .spi_mosi    (spi_mosi[i] ),
                  .spi_low     (spi_low[i]  ),
				  .led_ctrl    (led_ctrl[(`CH_NUM-i)*2-1:(`CH_NUM-i)*2-2])				  
                    );                                           
 
    end
endgenerate 
                 
endmodule
                 