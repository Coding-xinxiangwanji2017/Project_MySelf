module bus_read(
input clk,
input reset,
input rx_done,
input [7:0]rx_buf_rdata,
output reg rx_buf_rden,
output reg [10:0]rx_buf_raddr,
output reg [7:0]DA,
output reg [7:0]FC,
output reg [7:0]MODE,
output reg read_done
);
reg [3:0]count2;
reg [31:0]BUFF;
reg BEGIN;
reg [1:0]i;

 always @(posedge clk or posedge reset)
   begin
   if(reset)
     begin
       rx_buf_rden<=1'b0;
       rx_buf_raddr<=11'd0;
       read_done<=1'b0;
       BUFF<=24'b0;
       BEGIN<=1'b0;
       count2<=3'd0;
       i<=2'd0;
     end
   else begin
   case(i)
   0:
   if(rx_done)
   begin
     BEGIN<=1'b1;
     rx_buf_rden<=1'b1;
     rx_buf_raddr<=11'd0;
     i<=i+1'b1;
   end
   
   1:
   begin
   if(BEGIN && count2<3'd6)
     begin
         count2<=count2+1'b1;
         rx_buf_rden<=1'b1;
         rx_buf_raddr<=rx_buf_raddr+1'b1;
         BUFF<={BUFF[23:0],rx_buf_rdata};
         i<=2'd1;
       end
   else if(count2>=3'd6)
     begin
         rx_buf_rden<=1'b0;
         rx_buf_raddr<=11'd0;
         read_done<=1'b1;
         BEGIN<=1'b0;
         DA<=BUFF[31:24];
         FC<=BUFF[15:8];
         MODE<=BUFF[7:0];
         count2<=3'd0;
         i<=2'd0;
      end
   end
	endcase
   end
	end
endmodule