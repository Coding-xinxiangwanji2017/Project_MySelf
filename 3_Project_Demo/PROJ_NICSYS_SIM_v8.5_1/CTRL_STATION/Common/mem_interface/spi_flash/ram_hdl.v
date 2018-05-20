`timescale 1ns/100ps

module ram_hdl(
    input  wire         clk    ,
    input  wire         a_wen  ,
    input  wire [22:00] a_addr ,
    input  wire [07:00] a_din  ,
    output reg  [07:00] a_dout
);

reg [07:00] r_a_data [0:8388607];


always @ (posedge clk)
begin
  if(a_wen)
    r_a_data[a_addr] <= a_din;
  else
    r_a_data[a_addr] <= r_a_data[a_addr];
end

always @ (posedge clk)
begin
  if(a_wen == 1'b0)
    a_dout <= r_a_data[a_addr];
  else
    a_dout <= a_dout;
end

endmodule