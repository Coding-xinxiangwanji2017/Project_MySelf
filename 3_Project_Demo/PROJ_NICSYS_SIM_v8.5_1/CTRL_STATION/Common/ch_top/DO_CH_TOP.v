`define    CH_NUM      16 
module DO_CH_TOP( 
                  clk           ,
                  rst           ,
                  i_parwren     ,
                  im_paraddr    ,
                  im_pardata    ,
                  i_fault       ,
                  i_rdren       ,
                  im_rdaddr     ,
                  om_rddata     ,
                  i_din_feedback, 
                  o_fd_channel  ,         // output 
                  led_ctrl  

                 );
input                     clk            ;
input                     rst            ;
input    [11:0]           im_paraddr     ; 
input                     i_parwren      ; 
input    [7:0]            im_pardata     ; 
input    [11:0]           im_rdaddr      ; 
output   [7:0]            om_rddata      ; 
input                     i_rdren        ; 
input                     i_fault        ;
input    [`CH_NUM-1:0]    i_din_feedback ;                  
output   [`CH_NUM-1:0]    o_fd_channel   ;            // output 
output   [`CH_NUM*2-1:0]  led_ctrl       ;

generate
genvar i;
for(i=0;i<`CH_NUM;i=i+1)
    begin:do_ch
       do_ch #(.CH_ADD(i*64))
       DO_CH 
       (
                     .i_clk         (clk              ),
                     .i_rst_n       (rst              ),
                     .i_din_feedback(i_din_feedback[i]),
                     .fault         (i_fault          ),
                     .im_paraddr    (im_paraddr       ),
                     .i_parwren     (i_parwren        ),
                     .im_pardata    (im_pardata       ),
                     .im_rdaddr     (im_rdaddr        ), 
                     .om_rddata     (om_rddata        ),
                     .i_rden        (i_rdren          ),          
                     .o_fd_channel  (o_fd_channel[i]  ),
                     .led_ctrl    (led_ctrl[(`CH_NUM-i)*2-1:(`CH_NUM-i)*2-2])
);                                        
 
    end
endgenerate 
                 
endmodule
                 