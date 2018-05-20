module RX_link_top(clk,
                   wclk,
                   clk_phy_p0,
                   clk_phy_p90,
                   clk_phy_p180,
                   clk_phy_p270,
                   rst,
                   rx_buf_rden,
                   rx_buf_raddr,
                   rx_buf_rdata,
                   rx_crc_rslt,
                   rx_start,
                   rx_done,
                   tx_en,
                   lb_rxd);
                   
//parameter
parameter n=11;        //address width
parameter width=8;      //data width

//port
input clk;
input wclk;
input clk_phy_p0;
input clk_phy_p90;
input clk_phy_p180;
input clk_phy_p270;
input rst;
input rx_buf_rden;
input [n-1:0]rx_buf_raddr;
input lb_rxd;
input tx_en;

output rx_done;
output [width-1:0]rx_buf_rdata;
output [1:0]rx_crc_rslt;
output rx_start;

wire [n-1:0]WADDR;
wire [width-1:0]WD;
wire [width-1:0]WD1;
wire CRC_result;
wire WEN;
wire CRC_en;
wire CRC_init;
wire CRC_end;
wire rx_en;
wire rdy;
wire [width-1:0]data;
wire done;
wire frame;
wire phaselock;
wire rx_en1;

reg [1:0]CRC_out;
reg [1:0]CRC_edge;
reg [4:0]Done;

assign WD1=WD;
assign rx_done=Done[4];
assign rx_en1=rx_en & tx_en;

RX_4B5B_1ch U1(.clk(clk_phy_p0),
               .clk_dr1(clk_phy_p90),
               .clk_dr2(clk_phy_p180),
               .clk_dr3(clk_phy_p270),
               .reset(rst),
               .RX(lb_rxd),
               .rxEn(rx_en1),
               .phaseLock(phaselock),
               .rdy(rdy),
               .frame(frame),
               .dataO(data),
               .done(done));

RX_link_control K1(.clk(wclk),
                 .reset(rst),
                 .rx_en(rx_en),
                 .rx_start(rx_start),
                 .rdy(rdy),
                 .fram(frame),
                 .phaselock(phaselock),
                 .data(data),
                 .done(done),
                 .WADDR(WADDR),
                 .WD(WD),
                 .WEN(WEN),
                 .CRC_en(CRC_en),
                 .CRC_init(CRC_init),
                 .CRC_end(CRC_end));
                 
RAM_2048_8_SDP L1(.WD(WD),
            .RD(rx_buf_rdata),
            .WEN(WEN),
            .REN(rx_buf_rden),
            .WADDR(WADDR),
            .RADDR(rx_buf_raddr),
            .WCLK(wclk),
            .RCLK(clk));
            
M_Crc32De8 F1(.CpSl_Rst_i(rst),
              .CpSl_Clk_i(wclk),
              .CpSl_Init_i(CRC_init),
              .CpSv_Data_i(WD1),
              .CpSl_CrcEn_i(CRC_en),
              .CpSl_CrcEnd_i(CRC_end),
              .CpSl_CrcErr_o(CRC_result));

              
always @(posedge wclk or posedge rst)
begin
  if(rst)
    begin
    Done<=5'b0000;
    CRC_edge<=2'b00;
  end
  else begin
    Done<={Done[3:0],done};
    CRC_edge<={CRC_edge[0],CRC_result};
  end
end
  
always @(posedge wclk or posedge rst)
begin
if(rst)
CRC_out<=2'b00;
else if(Done[3]&&(CRC_edge==2'b01||CRC_edge==2'b10))
  CRC_out<=2'b01;
else if(Done[3]&&CRC_edge==2'b00)
  CRC_out<=2'b10;
else CRC_out<=2'b00;
end
      
assign rx_crc_rslt=CRC_out;

endmodule              
              
