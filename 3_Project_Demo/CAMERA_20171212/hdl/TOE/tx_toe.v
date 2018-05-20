module tx_toe
(
    //------------------------------------------
    //--  Global Reset, active low
    //------------------------------------------
    input                       rst_n           ,
    //------------------------------------------
    //--  Global clocks
    //------------------------------------------
    input                       clk             ,
    //------------------------------------------
    //--  rx interface
    //------------------------------------------ 
    input                       rx_flag         ,
    input         [7:0]         rx_type         ,
    input         [15:0]        rx_row          ,
    input         [7:0]         rx_pic          ,
    //------------------------------------------
    //--  toe interface
    //------------------------------------------ 
    output                      tx              ,
    output        [7:0]         tx_data         ,
    output        [2:0]         tx_chan         ,
    input         [1:0]         tx_full         ,
    input                       flash_done      
);

wire                      w_ena       ;
wire       [5:0]          w_addra     ;
wire       [7:0]          w_douta     ;
//wire                      w_rx_flag   ;
//wire       [7:0]          w_rx_type   ;
//wire       [15:0]         w_rx_row    ;
//wire       [7:0]          w_rx_pic    ;
wire                      w_check_init;
wire                      w_check_en  ;
wire       [31:0]         w_check_in  ;
wire       [15:0]          w_check_data;
 


tx_control tx_control(.rst_n       (rst_n)             ,
                      .clk         (clk)               ,
                      .ena         (w_ena)             ,
                      .addra       (w_addra)           ,
                      .douta       (w_douta)           ,
                      .rx_flag     (rx_flag)           ,
                      .rx_type     (rx_type)           ,
                      .rx_row      (rx_row)            ,
                      .rx_pic      (rx_pic)            ,
                      .check_init  (w_check_init)      ,
                      .check_en    (w_check_en)        ,
                      .check_data  (w_check_data)      ,
                      .check_in    (w_check_in)        , 
                      .tx          (tx)                ,
                      .tx_data     (tx_data)           ,
                      .tx_chan     (tx_chan)           ,
                      .tx_full     (tx_full)           ,
                      .flash_done  (flash_done)        
                      );
                      
check_sum check_sum(.clk            (clk)              ,
	                  .rst_n          (rst_n)            ,
	                  .init           (w_check_init)     ,
	                  .en             (w_check_en)       ,
	                  .data           (w_check_data)     ,
	                  .data_out       (w_check_in)
                   );  
                   
rom_64_8_sdp rom_64_8_sdp(.clka      (clk)             ,
                          .ena       (w_ena)           ,
                          .addra     (w_addra)         ,
                          .douta     (w_douta)
                         );
                         
endmodule