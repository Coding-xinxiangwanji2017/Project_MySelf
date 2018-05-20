module  Clink_tx(clk,
                 reset,
                 ini_done,
                 station_id,
                 slot_id,
                 ch1_txbuf_rden,
                 ch1_txbuf_raddr,
                 ch1_txbuf_rdata,
                 da_valid,
                 ch1_da,
                 tx_buf_wren,
                 tx_buf_waddr,
                 tx_buf_wdata,
                 tx_data_len,
                 tx_start);

//port
input clk;
input reset;
input [7:0]ch1_txbuf_rdata;
input da_valid;
input [23:0]ch1_da;
input ini_done;
input [3:0]station_id;
input [3:0]slot_id;

output reg [10:0]ch1_txbuf_raddr;
output reg ch1_txbuf_rden;
output reg tx_buf_wren;
output reg [10:0]tx_buf_waddr;
output reg [7:0]tx_buf_wdata;
output reg [10:0]tx_data_len;
output reg tx_start;

//parameter
parameter chavalid =8'd1;

//reg
reg [3:0]i;                          //idle control
//reg ini_Done;                   //initial flag
reg [3:0]station_ID;                 //station ID
reg [3:0]slot_ID;                    //slot ID
reg [7:0]txbuf_data;                 //transmit DATA
reg [1:0]ini_done_edge;              //initial done detector
reg [7:0]SN;                    //SN
reg [23:0]DA;
reg [23:0]SA;
reg [15:0]TN;
reg [15:0]PN;
reg [23:0]da;              
reg [23:0]DA1;
reg [23:0]DA2;
reg [23:0]DA3;
reg [23:0]DA4;
reg [23:0]DA5;
reg [23:0]DA6;
reg [4:0]count;
reg time_done;
reg count1;
reg read_done;
reg [18:0]count2;
reg [1:0]ch1_da_edge;

always@(posedge clk or posedge reset)
begin
if(reset)
  begin
  ini_done_edge<=2'b00;
  ch1_da_edge<=2'b00;
end
else begin
  ini_done_edge<={ini_done_edge[0],ini_done};
  ch1_da_edge<={ch1_da_edge[0],da_valid};
end
end

always@(posedge clk or posedge reset)
begin
if(reset)
  begin
  i<=4'd0;
  station_ID<=4'd0;
  slot_ID<=4'd0;
  txbuf_data<=8'h0;
  tx_buf_waddr<=11'h0;
  tx_buf_wren<=1'b0;
  ch1_txbuf_raddr<=11'h0;
  ch1_txbuf_rden<=1'b0;
  SN<=8'd0;
  da<=24'd0;
  SA<=24'd0;
  TN<=16'd2;
  PN<=16'd0;
  SN<=8'd0;
  count<=4'd0;
  DA1<=24'd0;
  DA2<=24'd0;
  DA3<=24'd0;
  DA4<=24'd0;
  DA5<=24'd0;
  DA6<=24'd0;
  time_done<=1'b0;
  count1<=1'b0;
  read_done<=1'b0;
  count2<=19'h0;
  tx_start<=1'b0;
  tx_data_len<=11'd0;
end
else begin
  case(i)
      0:
      begin
      if(da_valid)
        begin
        da<=ch1_da;
        i<=i+1'b1;
        end
      end
      
      1:
      begin
        if(ini_done_edge==2'b01|| time_done==1'b1)
          begin
          count2<=count2+1'b1;
          tx_buf_wren<=1'b1;
          tx_buf_wdata<=da[23:16];
          station_ID<=station_id;
          slot_ID<=slot_id;
          i<=i+1'b1;
          time_done<=1'b0;
          DA1<=da;
          TN<=16'd2;
          case(count1)
            1'b0: PN<=16'd1;
            1'b1: PN<=16'd2;
          endcase         
        end
      end
      
      2:
      begin
        if(tx_buf_waddr<11'd2)
          begin
        count2<=count2+1'b1;
        DA1<={DA1[15:0],8'h0};
        tx_start<=1'b0;
        SA<={8'd0,4'd0,station_ID[3:0],4'h0,slot_ID[3:0]};                 //SA 8'd1
        i<=i+1'b1;
      end
      else if(tx_buf_waddr==11'd2)
      begin
        count2<=count2+1'b1;
        DA1<={DA1[15:0],8'h0};
        tx_buf_waddr<=tx_buf_waddr+1'b1;
        tx_buf_wdata<=SA[23:16];
        i<=4'd4;
      end          
      end
      
      3:
      begin
        count2<=count2+1'b1;
        if(tx_buf_waddr<11'd2)
          begin
            tx_buf_waddr<=tx_buf_waddr+1'b1;
            tx_buf_wdata<=DA1[23:16];
            i<=4'd2;
          end
        else begin
          i<=i+1'b1;
          tx_buf_wdata<=SA[23:16];
        end
      end
      
      4:
      begin
        count2<=count2+1'b1;
      case(tx_buf_waddr)
        0,1,2:;
        5,6,8:
        begin
          i<=i+1'b1;
        end        
        3,4:
        begin
          SA<={SA[15:0],8'h0};
          i<=i+1'b1;
        end
        7:
        begin
          i<=i+1'b1;
          TN<={TN[7:0],8'h0};
        end
        9:
        begin
          PN<={PN[7:0],8'h0};
          i<=i+1'b1;
          ch1_txbuf_rden<=1'b1;
        end
        10:
        begin
        if(PN==16'd256)
        begin
          i<=4'd7;
          ch1_txbuf_raddr<=ch1_txbuf_raddr+1'b1;
          //tx_buf_waddr<=tx_buf_waddr+1'b1;
          //tx_buf_wdata<=ch1_txbuf_rdata;
        end
        else begin
        i<=4'd8;
        ch1_txbuf_raddr<=11'd0;
        end
        end          
        default:;
      endcase
    end
      
      5:
      begin
        count2<=count2+1'b1;
        case(tx_buf_waddr)
          0,1,2:;
          3,4:
          begin
            tx_buf_wdata<=SA[23:16];
            tx_buf_waddr<=tx_buf_waddr+1'b1;
            i<=4'd4;
          end
          5:
          begin
            tx_buf_waddr<=tx_buf_waddr+1'b1;
            tx_buf_wdata<=SN[7:0];
            i<=4'd4;
          end
          6:
          begin
            tx_buf_waddr<=tx_buf_waddr+1'b1;
            tx_buf_wdata<=TN[15:8];
            i<=4'd4;
          end
          7:
          begin
            tx_buf_waddr<=tx_buf_waddr+1'b1;
            tx_buf_wdata<=TN[15:8];
            i<=4'd4;
          end
          8:
          begin
            tx_buf_waddr<=tx_buf_waddr+1'b1;
            tx_buf_wdata<=PN[15:8];
            i<=4'd4;
          end
          9:
          begin
            tx_buf_waddr<=tx_buf_waddr+1'b1;
            tx_buf_wdata<=PN[15:8];
            i<=4'd4;
            ch1_txbuf_raddr<=ch1_txbuf_raddr+1'b1;
          end
          default:;
        endcase
      end
        
        6:
        begin
          count2<=count2+1'b1;
          if(read_done==1'b1)
            begin
            ch1_txbuf_rden<=1'b0;
            ch1_txbuf_raddr<=11'd0;
            tx_buf_waddr<=tx_buf_waddr+1'b1;
            tx_buf_wdata<=ch1_txbuf_rdata;
            i<=4'd8;
            read_done<=1'b0;
          end
        end
        
        7:
        begin
        if(ch1_txbuf_raddr<11'd1024)
          begin
          count2<=count2+1'b1;
          ch1_txbuf_raddr<=ch1_txbuf_raddr+1'b1;
          tx_buf_waddr<=tx_buf_waddr+1'b1;
          tx_buf_wdata<=ch1_txbuf_rdata;
        end
        else if(ch1_txbuf_raddr==11'd1024)
          begin
          count2<=count2+1'b1;
          read_done<=1'b1;
          tx_buf_waddr<=tx_buf_waddr+1'b1;
          tx_buf_wdata<=ch1_txbuf_rdata;
          i<=4'd6;          
        end
        end
        
        8:
        begin 
        i<=i+1'b1;
        tx_start<=1'b1;
        tx_data_len<=11'd1035;
        count2<=count2+1'b1;
        end
          
        9:
        begin 
        i<=i+1'b1;
        tx_start<=1'b0;
        count2<=count2+1'b1;
        end
        
        10:
        begin
          tx_buf_wren<=1'b0;
          tx_buf_waddr<=11'h0;
          tx_buf_wdata<=8'h0;
          if(count2==19'd9000)
            begin
            time_done<=1'b1;
            SN<=SN+1'b1;
            i<=4'd1;
            count1<=count1+1'b1;
          end
          else if(count2==19'd374999)
            begin
            time_done<=1'b1;
            SN<=SN+1'b1;
            i<=4'd1;
            count2<=19'h0;
            count1<=count1+1'b1;
          end
          else 
            count2<=count2+1'b1;
        end
      endcase
    end
  end
  
endmodule
          
          
          
            

          
            
          

  
  
  




                 
                 