`timescale 1ns/1ns

module tx_bus_tb;
  reg clk;
  reg reset;
  reg rx_flag;
  reg [7:0]rx_mode;
  reg [23:0]rx_addr;
  reg ini_done;
  reg [3:0]card_id;
  
  wire lcudb_rden;
  wire [23:0]lcudb_raddr;
  wire [7:0]lcudb_rdata;
  wire lcucb_rden;
  wire [23:0]lcucb_raddr;
  wire [7:0]lcucb_rdata;
  wire ldub_rden;
  wire [23:0]ldub_raddr;
  wire [7:0]ldub_rdata;
  wire tx_buf_wren;
  wire [10:0]tx_buf_waddr;
  wire [7:0]tx_buf_wdata;
  wire [10:0]tx_data_len;
  wire tx_start;
  wire GND;
  wire [10:0]GND1;
  wire [7:0]GND2;
  wire [9:0]GND3;
  
assign GND=1'b0;
assign GND1=11'd0;
assign GND2=8'd0;
assign GND3=10'd0;
tx_bus U1(.reset(reset),
          .clk(clk),
          .lcudb_rdata(lcudb_rdata),
          .lcucb_rdata(lcucb_rdata),
          .ldub_rdata(ldub_rdata),
          .card_id(card_id),
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

RAM_2048_8_SDP K1(.RADDR(lcucb_raddr),
                  .RCLK(clk),
                  .REN(lcucb_rden),
                  .WADDR(GND1),
                  .WCLK(clk),
                  .WD(GND2),
                  .WEN(GND),
                  .RD(lcucb_rdata));
RAM_1024_8_SDP L1(.RADDR(lcudb_raddr),
                  .RCLK(clk),
                  .REN(lcudb_rden),
                  .WADDR(GND3),
                  .WCLK(clk),
                  .WD(GND2),
                  .WEN(GND),
                  .RD(lcudb_rdata));
                  
RAM_1024_8_SDP L2(.RADDR(ldub_raddr),
                  .RCLK(clk),
                  .REN(ldub_rden),
                  .WADDR(GND3),
                  .WCLK(clk),
                  .WD(GND2),
                  .WEN(GND),
                  .RD(ldub_rdata));
                  
initial
begin
#0 clk=1'b0;
   reset=1'b1;
#5 reset=1'b0;
forever #10 clk=~clk;
end

reg [3:0]i;
reg [3:0]count;

always @(posedge clk or posedge reset)
begin
if(reset)
  begin
    rx_flag<=1'b0;
    rx_mode<=8'd0;
    rx_addr<=24'd0;
    i<=4'd0;
    ini_done<=1'b0;
    card_id<=4'd0;
    count<=4'd0;
  end
else 
  case(i)
    0:
    begin
      ini_done<=1'b1;
      card_id<=4'd3;
      i<=i+1'b1;
    end
    
    1:
    begin
      i<=i+1'b1;
    end
    
    2:
    begin
      ini_done<=1'b0;
      card_id<=4'd0;
      i<=i+1'b1;
    end
    
    3:
    begin
      if(count<4'd5)
        count<=count+1'b1;
      else
        i<=i+1'b1;
    end
    
    4:
    begin
      rx_flag<=1'b1;
      rx_mode<=8'd1;
      rx_addr<=24'd0;
      i<=i+1'b1;
    end
    
    5:
    begin
      i<=i+1'b1;
    end
    
    6:
    begin
      rx_flag<=1'b0;
      rx_mode<=8'd0;
      rx_addr<=24'd0;
      i<=i+1'b1;
    end
    
    7:
    begin
      i<=4'd6;
    end
  endcase
end

endmodule
    
    

  

  
  
  