`define    CH_NUM      8 
module AO_CH_TOP( 
                  clk       ,
                  rst       ,
                  i_parwren ,
                  im_paraddr,
                  im_pardata,
                  i_rdren   ,
                  im_rdaddr ,
                  om_rddata ,
                  i_fault   ,
                  
                  a_spi_clk  ,
                  a_spi_miso ,
                  a_spi_mosi ,
                  a_spi_low  ,
                   
                  d_spi_clk  ,
                  d_spi_miso ,
                  d_spi_mosi ,
                  d_spi_low  ,
                  led_ctrl  
                 );
input                 clk           ;  
input                 rst           ;  
                 
input    [11:0]               im_paraddr; 
input                         i_parwren ; 
input    [7:0]                im_pardata; 
input    [11:0]                im_rdaddr ; 
output   [7:0]                om_rddata ; 
input                         i_rdren    ; 
input                         i_fault   ;                 
output  [`CH_NUM-1:0]         a_spi_clk   ;  
input   [`CH_NUM-1:0]         a_spi_miso  ;  
output  [`CH_NUM-1:0]         a_spi_mosi  ;  
output  [`CH_NUM-1:0]         a_spi_low   ;
output  [`CH_NUM-1:0]         d_spi_clk   ;  
input   [`CH_NUM-1:0]         d_spi_miso  ;  
output  [`CH_NUM-1:0]         d_spi_mosi  ;  
output  [`CH_NUM-1:0]         d_spi_low   ;
output  [`CH_NUM*2-1:0]       led_ctrl    ;
wire    [(`CH_NUM)*16-1:0]    ao_data     ;
generate
genvar i;
for(i=0;i<`CH_NUM;i=i+1)
    begin:ao_ch
    	
       AO_DA #(.CH_ADD(i*128)) 
        ao_da                                 
                   (
                  .clk         (clk           ),
                  .rst_n       (rst           ),
                  .i_parwren   (i_parwren     ),
                  .im_paraddr  (im_paraddr    ),
                  .im_pardata  (im_pardata    ),
                  .fault       (i_fault       ),
                  .i_rdren     (i_rdren       ),   
                  .im_rdaddr   (im_rdaddr     ), 
                  .om_rddata   (om_rddata     ),
                  .AO_data     (ao_data[16*(i+1)-1:16*i]),
                  .spi_clk     (d_spi_clk[i]  ),
                  .spi_miso    (d_spi_miso[i] ),
                  .spi_mosi    (d_spi_mosi[i] ),
                  .spi_cs      (d_spi_low[i]  ) 						  
                    ); 
       AO_AD #(.CH_ADD(i*128))   
        ao_ad                                                     
                   (
                  .clk         (clk           ),
                  .rst_n       (rst           ),
                  .i_parwren   (i_parwren     ),
                  .im_paraddr  (im_paraddr    ),
                  .im_pardata  (im_pardata    ),
                  .i_rdren     (i_rdren       ),
                  .im_rdaddr   (im_rdaddr     ),
                  .om_rddata   (om_rddata     ),
                  .ao_data     (ao_data[16*(i+1)-1:16*i]),
                  .spi_clk     (a_spi_clk[i]  ),
                  .spi_miso    (a_spi_miso[i] ),
                  .spi_mosi    (a_spi_mosi[i] ),
                  .spi_cs_low  (a_spi_low[i]  ),
	              .led_ctrl    (led_ctrl[(`CH_NUM-i)*2-1:(`CH_NUM-i)*2-2])				  
                    );                                           
 
    end
endgenerate 
                 
endmodule
                 