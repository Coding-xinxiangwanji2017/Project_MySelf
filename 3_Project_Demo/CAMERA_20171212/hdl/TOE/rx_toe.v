module rx_toe
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
    //--  flash interface
    //------------------------------------------ 
    output                      wr_en           ,
    output       [15:0]         wdata           ,
    output                      rst_fifo        , 
    output       [13:0]         row             ,
    output                      write_en        ,
    output                      erase_en        ,
    input                       ready           , 
    input                       done            ,
    //------------------------------------------
    //--  rx toe interface
    //------------------------------------------ 
    input                       rx              ,
    input        [7:0]          rx_data         ,
    input        [2:0]          rx_chan         ,
    output       [7:0]          rx_full         ,
    //------------------------------------------
    //--  tx interface
    //------------------------------------------
    output                      rx_flag         ,
    output       [7:0]          rx_type         ,
    output       [15:0]         rx_row          ,
    output       [7:0]          rx_pic          ,
    //------------------------------------------
    //--  working state
    //------------------------------------------
    output                      busy
);

wire           w_check_init ;
wire  [15:0]   w_check_data ;
wire           w_check_en   ;
wire  [31:0]   W_check_in   ;


rx_ctrl rx_ctrl(.rst_n       (rst_n)         ,
                .clk         (clk)           ,                         //125m
                .wr_en       (wr_en)         ,
                .wdata       (wdata)         ,
                .rst_fifo    (rst_fifo)      ,         
                .check_init  (w_check_init)  ,
                .check_data  (w_check_data)  ,
                .check_en    (w_check_en)    ,
                .check_in    (W_check_in)    ,
                .row         (row)           ,
                .write_en    (write_en)      ,
                .erase_en    (erase_en)      ,
                .ready       (ready)         ,
                .done        (done)          ,
                .rx_flag     (rx_flag)       ,
                .rx_type     (rx_type)       ,
                .rx_row      (rx_row)        ,
                .rx_pic      (rx_pic)        ,
                .rx          (rx)            ,
                .rx_data     (rx_data)       ,
                .rx_chan     (rx_chan)       ,
                .rx_full     (rx_full)       ,
                .busy        (busy)  
);


check_sum check_sum(.clk(clk)                ,
	                  .rst_n(rst_n)            ,
	                  .init(w_check_init)      ,
	                  .en(w_check_en)          ,
	                  .data(w_check_data)      ,
	                  .data_out(W_check_in)
                   );  

endmodule