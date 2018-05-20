module bus_read_1(
input addr_read_reg,
input [7:0]rx_buf_rdata,
input clk,
input reset,

output reg rx_buf_rden,
output reg [10:0]rx_buf_raddr,
output reg [23:0]ADDR,
output reg addr_read_done
);
reg [3:0]count3;
reg [1:0]i;

always @(posedge clk or posedge reset)
   begin
   if(reset)
   begin
   count3<=4'd0;
   i<=2'd0;
   rx_buf_rden<=1'd0;
   rx_buf_raddr<=11'd0;
   ADDR<=24'd0;
   end
   else begin
   case(i)
   0:
   begin
   if(addr_read_reg)
   begin
   rx_buf_rden<=1'b1;
   rx_buf_raddr<=11'd6;
   i<=i+1'b1;
   end
   end
   
   1: 
   begin
   if(addr_read_reg && count3<3'd4)
       begin
         count3<=count3+1'b1;
         rx_buf_rden<=1'b1;
         rx_buf_raddr<=rx_buf_raddr+1'b1;
         ADDR<={ADDR[15:0],rx_buf_rdata};
       end
     else if(count3>=3'd4)
       begin
         rx_buf_rden<=1'b0;
         rx_buf_raddr<=11'd0;
         addr_read_done<=1'b1;
         count3<=3'd0;
         i<=2'd0;
       end
   end
	endcase
	end
	end
	endmodule