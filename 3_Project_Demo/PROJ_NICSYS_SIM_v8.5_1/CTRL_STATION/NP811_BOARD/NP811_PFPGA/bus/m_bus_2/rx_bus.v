module rx_bus(
    //------------------------------------------
    //--  Global Reset, active low
    //------------------------------------------
    input reset                                 ,
    //------------------------------------------
    //--  Global clocks
    //------------------------------------------
    input clk                                   ,
    //------------------------------------------
    //--  rx_bus_control
    //------------------------------------------
    output lddb_wren                            ,
    output [23:0]lddb_waddr                     ,
    output [7:0]lddb_wdata                      ,
    output lcdcb_wren                           ,
    output [23:0]lcdcb_waddr                    ,
    output [7:0]lcdcb_wdata                     ,
    output lcddb_wren                           ,
    output [23:0]lcddb_waddr                    ,
    output [7:0]lcddb_wdata                     ,
    input  [7:0]rx_buf_rdata                    ,
    input  [1:0]rx_crc_rslt                     ,
    input  rx_start                             ,
    input  rx_done                              ,
    input  ini_done                             ,
    output rx_buf_rden                          ,
    output [10:0]rx_buf_raddr                   ,        
    output [8:0]rx_mode                         ,
    output [23:0]rx_addr                        ,
    output rx_flag                              ,
    input [2:0]rack_id                          ,
    input [3:0]slot_id                          ,
    output card_reset_reg                       ,
    output wr_lddb_flag                         ,
    output CRC_err                                    
);


   //=========================================================
   // Internal signal definition
   //=========================================================
   wire read_done;
   wire [7:0]DA  ;
   wire [7:0]FC  ;
   wire [7:0]MODE;
   wire addr_read_reg;
   wire addr_read_done;
   wire [23:0]ADDR;
   wire [10:0]rx_buf_raddr1;
   wire rx_buf_rden1;
   wire [10:0]rx_buf_raddr2;
   wire rx_buf_rden2;
   wire rx_buf_rden3;
   wire [10:0]rx_buf_raddr3;
   
 rx_bus_control control(.clk(clk),
                        .reset(reset),
                        .lddb_wren(lddb_wren),
                        .lddb_waddr(lddb_waddr),
                        .lddb_wdata(lddb_wdata),
                        .lcdcb_wren(lcdcb_wren),
                        .lcdcb_waddr(lcdcb_waddr),
                        .lcdcb_wdata(lcdcb_wdata),
                        .lcddb_wren(lcddb_wren),
                        .lcddb_waddr(lcddb_waddr),
                        .lcddb_wdata(lcddb_wdata),
                        .rx_buf_rdata(rx_buf_rdata),
                        .rx_crc_rslt(rx_crc_rslt),
                        .rx_start(rx_start),
                        .rx_done(rx_done),
                        .ini_done(ini_done),
                        .rx_buf_rden(rx_buf_rden1),
                        .rx_buf_raddr(rx_buf_raddr1),
                        .rx_mode(rx_mode),
                        .rx_addr(rx_addr),
                        .rx_flag(rx_flag),
                        .rack_id(rack_id),
                        .slot_id(slot_id),
                        .card_reset_reg(card_reset_reg),
                        .wr_lddb_flag(wr_lddb_flag),
                        .CRC_err(CRC_err),
                        .read_done(read_done),
                        .DA(DA),
                        .FC(FC),
                        .MODE(MODE),
                        .addr_read_done(addr_read_done),
                        .ADDR(ADDR),
                        .addr_read_reg(addr_read_reg));
                        
  bus_read read(.clk(clk),
                .reset(reset),
                .rx_done(rx_done),
                .rx_buf_rdata(rx_buf_rdata),
                .rx_buf_rden(rx_buf_rden2),
                .rx_buf_raddr(rx_buf_raddr2),
                .DA(DA),
                .FC(FC),
                .MODE(MODE),
                .read_done(read_done));  
                
   bus_read_1 read1(.clk(clk),
                    .addr_read_reg(addr_read_reg),
                    .rx_buf_rdata(rx_buf_rdata),
                    .reset(reset),
                    .rx_buf_rden(rx_buf_rden3),
                    .rx_buf_raddr(rx_buf_raddr3),
                    .ADDR(ADDR),
                    .addr_read_done(addr_read_done));
                    
assign rx_buf_rden=rx_buf_rden3 | rx_buf_rden2 | rx_buf_rden1;
assign rx_buf_raddr=rx_buf_raddr3 | rx_buf_raddr2 | rx_buf_raddr1;

endmodule