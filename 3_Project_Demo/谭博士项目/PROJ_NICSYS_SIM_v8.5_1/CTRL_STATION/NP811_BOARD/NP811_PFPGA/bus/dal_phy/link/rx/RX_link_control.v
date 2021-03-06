module RX_link_control(clk,
                       reset,
                       rx_en,
                       rx_start,
                       rdy,
                       fram,
                       phaselock,
                       data,
                       done,
                       WADDR,
                       WD,
                       WEN,
                       CRC_en,
                       CRC_init,
                       CRC_end);
                
//port
input clk;
input reset;               
input rdy;               //rx flag
input [7:0]data;
input done;              //rx done
input fram;              //begin
input phaselock;          //

output reg  rx_start;          //rx start
output reg [10:0]WADDR;            //write address
output [7:0]WD;               //write data
output reg WEN;              //write enable;
output reg CRC_en;           //CRC enable;
output reg CRC_init;         //CRC initial;
output reg CRC_end;          //CRC calculate end
output reg rx_en;             //rx enable

//reg or wire
reg RDY;
reg [7:0]data0;
reg [1:0]Done;
reg [3:0]i;
reg [3:0]count;
reg [1:0]fram_edge;

//edge detector
always @(posedge clk or posedge reset)
if(reset)
begin
  fram_edge<=2'b00;
  RDY<=1'b0;
  Done<=2'b00;
end
else
begin
  fram_edge={fram_edge[0],fram};
  RDY<=rdy;
  Done<={Done[0],done};
end

always @(posedge clk or posedge reset)
begin
  if(reset)
    begin
      WADDR<=11'h0;
      WEN<=1'b0;
      CRC_en<=1'b0;
      CRC_init<=1'b0;
      CRC_end<=1'b0;
      i<=4'd0;
      count<=4'd0;
      rx_en<=1'b0;
      rx_start<=1'b0;
    end
  else
    case(i)
      0:
      begin
        rx_en<=1'b1;
        CRC_end<=1'b0;
        if(fram_edge==2'b01 && phaselock==1'b1)
        begin
          WEN<=1'b1;
          CRC_init<=1'b1;
          i<=i+1'b1;
          count<=4'd8;
          rx_start<=1'b1;
        end
      end
      
      1:
      begin
        CRC_init<=1'b0;
        rx_start<=1'b0;
        if(RDY==1'b1 && Done==2'b00)
          begin
          data0<=data;
          WADDR<=11'h0;
          CRC_en<=1'b1;
          i<=i+1'b1;
        end
      end
      2��
      bgin
      CRC_en<=1'b0;
      i<=i+1'b1;
      end
      
      3:
      begin
        if(RDY==1'b1 && Done==2'b00)
          begin
          data0<=data;
          WADDR<=WADDR+1'b1;
          CRC_en<=1'b1;
          i<=i+1'b1;
        end
      else if(Done==2'b01)
          begin
          WADDR<=11'h0;
          CRC_end<=1'b1;
          i<=4'd0;
          WEN<=1'b0;
          rx_en<=1'b0;
        end
      end
        
      4:
      begin
        i<=4'd2;
        CRC_en<=1'b0;
      end          
      
    default:begin i<=4'd0;end
        
    endcase
end
assign WD=data0;

endmodule
        
          
          
        
        
      
    

