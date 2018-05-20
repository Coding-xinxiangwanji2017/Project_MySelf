`define    CH_NUM      32 
module DI_CH_TOP( 
                  clk          ,
                  rst          ,
                  i_parwren    ,
                  im_paraddr   ,
                  im_pardata   ,
                  i_rdren      ,
                  im_rdaddr    ,
                  om_rddata    ,
                  i_din        , 
                  o_test_open  ,            // output 
                  led_ctrl     ,
                  o_test_close

                 );
input                       clk         ;
input                       rst         ;
input    [11:0]             im_paraddr  ; 
input                       i_parwren   ; 
input    [7:0]              im_pardata  ; 
input    [11:0]             im_rdaddr   ; 
output   [7:0]              om_rddata   ; 
input                       i_rdren     ; 
input    [`CH_NUM-1:0]      i_din       ;                  
output   [`CH_NUM-1:0]      o_test_open ;            // output 
output   [`CH_NUM-1:0]      o_test_close;
output   [`CH_NUM*2-1:0]    led_ctrl    ;
generate
genvar i;
for(i=0;i<`CH_NUM;i=i+1)
    begin:di_ch
       di_ch#(.CH_ADD(i*64))
       DI_CH
       (
             .i_clk       (clk            ),
             .i_rst_n     (rst            ),
             .i_din       (i_din[i]       ),                  // input 
             .im_paraddr  (im_paraddr     ),
             .i_parwren   (i_parwren      ),
             .im_pardata  (im_pardata     ),
             .im_rdaddr   (im_rdaddr      ), 
             .om_rddata   (om_rddata      ),
             .i_rdren     (i_rdren        ), 
             .o_test_open (o_test_open[i] ),            // output 
             .o_test_close(o_test_close[i]),
             .led_ctrl    (led_ctrl[(`CH_NUM-i)*2-1:(`CH_NUM-i)*2-2])
);                                        
 
    end
endgenerate 
                 
endmodule
                 