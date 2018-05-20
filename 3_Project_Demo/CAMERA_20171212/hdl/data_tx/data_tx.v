module data_tx
(
    //------------------------------------------
    //--  Global Reset, active low
    //------------------------------------------
    input               rst_n                   ,
    //------------------------------------------
    //--  Global clocks
    //------------------------------------------
    input               sys_clk                 ,                            //50m
    input               sys_clk_100m            ,
    //------------------------------------------
    //--  main control interface
    //------------------------------------------
    input               timing_telemetry        ,
    input               timing_lightdiag        ,
    input               timing_stardiag         ,
    output              transmit_done           ,
    //------------------------------------------
    //--  gtx interface
    //------------------------------------------ 
    output     [15:0]   tx_data                 ,
    output     [1:0]    tx_control              ,
    output     [10:0]   data_cnt                ,
    output     [1:0]    p_choose                ,
    //------------------------------------------
    //--  SRAM interface
    //------------------------------------------
    output              rd_req                  ,
    output     [23:0]   sram_raddr              ,
    input               fifo_wr_en              ,
    input      [31:0]   fifo_wdata              ,
//    inout      [35:0]   control                 ,
    //------------------------------------------
    //--  starparam interface
    //------------------------------------------
    output              starparam_ram_rd        ,
    output     [11:0]   starparam_ram_addr      ,
    input      [15:0]   starparam_ram_data      
);

wire          w_start_read    ;
wire   [10:0] w_row           ;
wire   [1:0]  w_picture_choose;
wire          w_read_done     ;
wire   [31:0] w_pkbl          ;
wire   [15:0] w_pkpck         ;

wire          w_rd_en         ;
wire          w_empty         ;
wire   [31:0] w_data_in       ;

wire          up_timing_telemetry;
wire          up_timing_lightdiag;
wire          up_timing_stardiag ;

reg           timing_telemetry1;
reg           timing_lightdiag1;
reg           timing_stardiag1;
                              
reg           timing_telemetry2;
reg           timing_lightdiag2;
reg           timing_stardiag2;
 
assign p_choose = w_picture_choose;

always @ (sys_clk)
begin
  timing_telemetry1 <= timing_telemetry ;
  timing_lightdiag1 <= timing_lightdiag ;
  timing_stardiag1  <= timing_stardiag  ;	
  
  timing_telemetry2 <= timing_telemetry1 ; 
  timing_lightdiag2 <= timing_lightdiag1 ; 
  timing_stardiag2  <= timing_stardiag1  ;	  
end

assign up_timing_telemetry = timing_telemetry1 & (~timing_telemetry2);
assign up_timing_lightdiag = timing_lightdiag1 & (~timing_lightdiag2);
assign up_timing_stardiag  = timing_stardiag1  & (~timing_stardiag2 );

tx_ctrl u1_tx_ctrl(.rst_n             (rst_n              )  ,
                   .clk               (sys_clk            )  ,
                   .timing_telemetry  (timing_telemetry)  ,///
                   .timing_lightdiag  (timing_lightdiag)  ,///
                   .timing_stardiag   (timing_stardiag )  ,///
                   .transmit_done     (transmit_done      )  ,
                   .start_read        (w_start_read       )  ,
                   .row               (w_row              )  ,
                   .picture_choose    (w_picture_choose   )  ,
                   .read_done         (w_read_done        )  ,
                   .pkbl              (w_pkbl             )  ,
                   .pkpck             (w_pkpck            )
                   );
                   
data_read u1_data_read(.rst_n              (rst_n             )   ,
                       .sys_clk            (sys_clk           )   ,
                       .start_read         (w_start_read      )   ,
                       .row                (w_row             )   ,
                       .picture_choose     (w_picture_choose  )   ,
                       .read_done          (w_read_done       )   ,
                       .pkbl               (w_pkbl            )   ,
                       .pkpck              (w_pkpck           )   ,
                       .rd_req             (rd_req            )   ,
                       .sram_raddr         (sram_raddr        )   ,
                       .rd_en              (w_rd_en           )   ,                                  
                       .empty              (w_empty           )   ,
                       .data_in            (w_data_in         )   ,
                       .tx_data            (tx_data           )   ,
                       .tx_control         (tx_control        )   ,
                       .data_cnt           (data_cnt          )   ,
                       .starparam_ram_rd   (starparam_ram_rd  )   ,
 //      				   .control(control),
                       .starparam_ram_addr (starparam_ram_addr)   ,
                       .starparam_ram_data (starparam_ram_data)
                       );
                       
fifo_4096_32 U1_fifo_4096_32(.rst    (~rst_n       )     ,   
                             .wr_clk (sys_clk_100m )     ,
                             .rd_clk (sys_clk      )     ,
                             .din    (fifo_wdata   )     ,   
                             .wr_en  (fifo_wr_en   )     , 
                             .rd_en  (w_rd_en      )     , 
                             .dout   (w_data_in    )     ,  
                             .full   (             )     ,  
                             .empty  (w_empty      )
                             );

endmodule