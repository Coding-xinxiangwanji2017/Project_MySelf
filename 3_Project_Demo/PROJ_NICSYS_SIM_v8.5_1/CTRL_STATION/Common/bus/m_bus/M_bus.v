module M_bus(
  
    //------------------------------------------
    //--  Global Reset, active low
    //------------------------------------------
    input reset                           ,
    //------------------------------------------
    //--  Global clocks
    //------------------------------------------
    input clk                             ,
    //------------------------------------------
    //--  input
    //-------------------------------------------
    input [7:0]lcudb_rdata                ,
    input [7:0]lcucb_rdata                ,
    input [7:0]ldub_rdata                 ,
    input [3:0]slot_id                    ,
    input [2:0]rack_id                    ,                        
    input ini_done                        ,
    //------------------------------------------
    //--  output
    //-------------------------------------------
    output  lcudb_rden                 ,
    output  [23:0]lcudb_raddr          ,
    output  lcucb_rden                 ,
    output  [23:0]lcucb_raddr          ,
    output  ldub_rden                  ,
    output  [23:0]ldub_raddr           ,
    output  tx_buf_wren                ,
    output  [10:0]tx_buf_waddr         ,
    output  [7:0]tx_buf_wdata          ,
    output  [10:0]tx_data_len          ,
    output  tx_start                   ,
    //------------------------------------------
    //--  local download RAM
    //------------------------------------------
    output  lddb_wren                               ,
    output  [23:0]lddb_waddr                        ,
    output  [7:0]lddb_wdata                         ,
    //------------------------------------------
    //--  local console order RAM
    //------------------------------------------
    output  lcdcb_wren                              ,
    output  [23:0]lcdcb_waddr                       ,
    output  [7:0]lcdcb_wdata                        ,
    //------------------------------------------
    //--  local console data  RAM
    //------------------------------------------
    output  lcddb_wren                              ,
    output  [23:0]lcddb_waddr                       ,
    output  [7:0]lcddb_wdata                       ,
    //------------------------------------------
    //--  link interface
    //------------------------------------------
    input [7:0]rx_buf_rdata                         ,
    input [1:0]rx_crc_rslt                          ,
    input rx_start                                  ,
    input rx_done                                   ,
    output  rx_buf_rden                             ,
    output  [10:0]rx_buf_raddr                      ,
    //------------------------------------------
    //--  output
    //------------------------------------------
    output card_reset_reg                           ,
    output wr_lddb_flag                             ,
    output CRC_err                                  ,
    output [7:0]mode_reg                                
);

   //=========================================================
   // Internal signal definition
   //=========================================================
   wire rx_flag;
   wire [7:0]rx_mode;
   wire [23:0]rx_addr;
   //=========================================================
   // module
   //=========================================================   
  rx_bus rx(.reset(reset),
            .clk(clk),
            .lddb_wren(lddb_wren),
            .lddb_waddr(lddb_waddr),
            .lddb_wdata(lddb_wdata),
            .lcddb_wren(lcddb_wren),
            .lcddb_waddr(lcddb_waddr),
            .lcddb_wdata(lcddb_wdata),
            .lcdcb_wren(lcdcb_wren),
            .lcdcb_waddr(lcdcb_waddr),
            .lcdcb_wdata(lcdcb_wdata),
            .rx_buf_rdata(rx_buf_rdata),
            .rx_crc_rslt(rx_crc_rslt),
            .rx_start(rx_start),
            .rx_done(rx_done),
            .ini_done(ini_done),
            .rx_buf_rden(rx_buf_rden),
            .rx_buf_raddr(rx_buf_raddr),
            .card_reset_reg(card_reset_reg),
            .wr_lddb_flag(wr_lddb_flag),
            .CRC_err(CRC_err),
            .mode_reg(mode_reg),
            .slot_id(slot_id),
            .rack_id(rack_id),
            .rx_flag(rx_flag),
            .rx_mode(rx_mode),
            .rx_addr(rx_addr));
            
    tx_bus tx(.reset(reset),
              .clk(clk),
              .lcudb_rdata(lcudb_rdata),
              .lcucb_rdata(lcucb_rdata),
              .ldub_rdata(ldub_rdata),
              .slot_id(slot_id),
              .rack_id(rack_id),
              .rx_flag(rx_flag),
              .rx_mode(rx_mode),
              .rx_addr(rx_addr),
              .ini_done(ini_done),
              .lcudb_rden(lcudb_rden),
              .lcudb_raddr(lcudb_raddr),
              .lcucb_rden(lcucb_rden),
              .lcucb_raddr(lcucb_raddr),
              .ldub_rden(ldub_rden),
              .ldub_raddr(ldub_raddr),
              .tx_buf_wren(tx_buf_wren),
              .tx_buf_waddr(tx_buf_waddr),
              .tx_buf_wdata(tx_buf_wdata),
              .tx_data_len(tx_data_len),
              .tx_start(tx_start));
              
endmodule
            