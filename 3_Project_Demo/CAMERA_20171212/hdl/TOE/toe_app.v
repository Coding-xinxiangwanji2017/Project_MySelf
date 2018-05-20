module toe_app
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
    //--  toe interface
    //------------------------------------------ 
    output                      tx              ,
    output        [7:0]         tx_data         ,
    output        [2:0]         tx_chan         ,
    input         [1:0]         tx_full         ,
    //------------------------------------------
    //--  rx toe interface
    //------------------------------------------ 
    input                       rx              ,
    input        [7:0]          rx_data         ,
    input        [2:0]          rx_chan         ,
    output       [7:0]          rx_full         , 
    //------------------------------------------
    //--  working state
    //------------------------------------------
    output                      busy
);

wire                  w_rx_flag;
wire      [7:0]       w_rx_type;
wire      [15:0]      w_rx_row;
wire      [7:0]       w_rx_pic;


rx_toe rx_toe(.rst_n           (rst_n)        ,    
              .clk             (clk)          ,
              .wr_en           (wr_en)        ,
              .wdata           (wdata)        ,
              .rst_fifo        (rst_fifo)     ,
              .row             (row)          ,
              .write_en        (write_en)     ,
              .erase_en        (erase_en)     ,
              .ready           (ready)        ,
              .done            (done     )    ,
              .rx              (rx)           ,
              .rx_data         (rx_data)      ,
              .rx_chan         (rx_chan)      ,
              .rx_full         (rx_full)      ,
              .rx_flag         (w_rx_flag)    ,
              .rx_type         (w_rx_type)    ,
              .rx_row          (w_rx_row)     ,
              .rx_pic          (w_rx_pic)     ,
              .busy            (busy)
              );
              
tx_toe tx_toe(.rst_n           (rst_n)         ,  
              .clk             (clk)           ,
              .rx_flag         (w_rx_flag)     ,
              .rx_type         (w_rx_type)     ,
              .rx_row          (w_rx_row)      ,
              .rx_pic          (w_rx_pic)      ,
              .tx              (tx)            ,
              .tx_data         (tx_data)       ,
              .tx_chan         (tx_chan)       ,
              .tx_full         (tx_full)       ,
              .flash_done      (done   )
              );
              
endmodule