module Clink_rx(clk,
                reset,
                ch1_rxbuf_wren,
                ch1_rxbuf_waddr,
                ch1_rxbuf_wdata,
                ch1_sn_err,
                ch1_crc_err,
                ch1_DA_err,
                rx_buf_rden,
                rx_buf_raddr,
                rx_buf_rdata,
                rx_crc_rslt,
                rx_start,
                rx_done,
                //rx_data_len,
                ini_done,
                station_id,
                slot_id);
//port
input clk;                                                        //system clock
input reset;                                                      //global reset
input [7:0]rx_buf_rdata;
input [1:0]rx_crc_rslt;                                           //crc result
input rx_start;                                                   //begin to receive
input rx_done;                                                    //receive done
input ini_done;
input [3:0]station_id;
input [3:0]slot_id;

output reg ch1_rxbuf_wren;
output reg [10:0]ch1_rxbuf_waddr;
output reg [7:0]ch1_rxbuf_wdata;
output reg ch1_sn_err;
output reg ch1_crc_err;
output reg ch1_DA_err;
output reg rx_buf_rden;
output reg [10:0]rx_buf_raddr;

//parameter ch1_davalid=8'd1;

//wire or reg
reg [1:0]ini_done_edge;
reg [3:0]station_ID;
reg [3:0]slot_ID;
reg [1:0]CRC;
reg [1:0]start_edge;
reg [1:0]done_edge;
reg [4:0]i;
reg [23:0]DA;
reg [23:0]SA;
reg [7:0]oldSN;
reg [7:0]newSN;
reg [7:0]count;
reg count1;

always@(posedge clk or posedge reset)
begin
  if(reset)
    begin
    ini_done_edge<=2'b00;
    done_edge<=2'b00;
    start_edge<=2'b00;   
  end
  else begin
    ini_done_edge<={ini_done_edge[0],ini_done};
    done_edge<={done_edge[0],rx_done};
    start_edge<={start_edge[0],rx_start};
  end
end

always@(posedge clk or posedge reset)
if(reset)
  begin
  CRC<=2'b00;
  oldSN<=8'h0;
  i<=5'd0;
  rx_buf_rden<=1'b0;
  rx_buf_raddr<=11'h0;
  ch1_rxbuf_wren<=1'b0;
  ch1_rxbuf_waddr<=11'h0;
  ch1_rxbuf_wdata<=8'h0;
  ch1_sn_err<=1'b0;
  ch1_crc_err<=1'b0;
  ch1_DA_err<=1'b0;
  newSN<=8'h0;
  DA<=24'h0;
  SA<=24'h0;
  slot_ID<=4'h0;
  station_ID<=4'h0;
  count1<=1'b0;
  count<=8'd0; 
end
else
  begin
  case(i)
    0:
    begin
      if(ini_done_edge==2'b01)
        begin
        station_ID<=station_id;
        slot_ID<=slot_id;
        i<=i+1'b1;
      end
    end                                                               //wait initial
    
    1:
    begin
      SA<={8'd0,4'd0,station_ID[3:0],4'd0,slot_ID[3:0]};
      ch1_sn_err<=1'b0;
      ch1_crc_err<=1'b0;
      ch1_DA_err<=1'b0;
      if(rx_done)
        begin
        rx_buf_rden<=1'b1;
        CRC<=rx_crc_rslt;
        i<=i+1'b1;                                                   //wait receive done
      end
    end
    
    2:
    begin
      if(CRC==2'b01)
        begin
          i<=i+1'b1;
        end
      else if(CRC==2'b10)
        begin
          ch1_crc_err<=1'b1;
          i<=4'd1;
        end
    end                                                                //examine CRC
  
    3:
    begin
      if(rx_buf_raddr<=11'd2)
      begin
      rx_buf_raddr<=rx_buf_raddr+1'b1;
      i<=i+1'b1;
      end
    else begin
    i<=4'd5;
    rx_buf_raddr<=11'd0;
    rx_buf_rden<=1'b0;
    end
    end
    
    4:
    begin
    if(count1<1'b1)
      count1<=count1+1'b1;
    else begin
    DA<={DA[15:0],rx_buf_rdata};
    i<=4'd3;
    count1<=1'b0;
    end
    end                                                       //read DA
    
    5:
    begin
    if(DA==SA)
    begin
    i<=i+1'b1;
    count<=count+1;
    rx_buf_rden<=1'b1;
    rx_buf_raddr<=11'd6;                                      //compare DA and SA
    end
    else begin
    i<=4'b1;
    ch1_DA_err<=1'b1;
    end
    end
    
    6,7,8:
    begin i<=i+1'b1;end
    
    
    9:
    begin
    if(count==8'd1)
    begin
    oldSN<=rx_buf_rdata;
    i<=i+1'b1;
    end
    else begin
    newSN<=rx_buf_rdata;
    i<=4'd11;
    end  
    end  
    
    10:
    begin
      rx_buf_rden<=1'b0;
      if(count<=8'd1 && oldSN==8'd0)
        i<=4'd12;
      else begin
        i<=4'd1;
        ch1_sn_err<=1'b1;
      end
    end
    
    11:
    begin
      rx_buf_rden<=1'b0;
      if((newSN-oldSN)==8'd1)
        begin
        i<=4'd12;
        oldSN<=newSN;
      end
      else begin
        ch1_sn_err<=1'b1;
        i<=4'd1;
      end                                                          //compare SN
    end
    
    12:
    begin
      rx_buf_rden<=1'b1;
      rx_buf_raddr<=11'd11;
      i<=i+1'b1;                                                    //read data
    end
    
    13:
    begin
      ch1_rxbuf_wren<=1'b1;
      if(rx_buf_raddr<11'd12)
        begin
        rx_buf_raddr<=rx_buf_raddr+1'b1;
        i<=i+1'b1;
        end
      else if(rx_buf_raddr<=11'd1037&& rx_buf_raddr>=11'd13)
        begin
        rx_buf_raddr<=rx_buf_raddr+1'b1;
        ch1_rxbuf_waddr<=ch1_rxbuf_waddr+1'b1;
        ch1_rxbuf_wdata<=rx_buf_rdata;
        i<=4'd13;
        end                                                          //store data to another RAM
      else begin
        i<=4'd1;
        ch1_rxbuf_wren<=1'b0;
        ch1_rxbuf_waddr<=11'd0;
        ch1_rxbuf_wdata<=8'd0;
        rx_buf_rden<=1'b0;
        rx_buf_raddr<=11'd0;                                          //return and wait new data 
      end
    end
    
    14:
    begin
      rx_buf_raddr<=rx_buf_raddr+1'b1;
      i<=i+1'b1;
    end                                                              //delay two clock
    
    15:
    begin
      rx_buf_raddr<=rx_buf_raddr+1'b1;
      ch1_rxbuf_waddr<=11'd0;
      ch1_rxbuf_wdata<=rx_buf_rdata;
      i<=4'd13;
    end
    
    default:;
  endcase
end

endmodule
      
      
      
      
        
  
  
  
  
