module rx_ctrl
(
    //reset,active low;
    input                    rst_n          ,
    //clk
    input                    clk            ,                         //125m
    //fifo  interface
    output   reg             wr_en          ,
    output       [15:0]      wdata          ,
    output   reg             rst_fifo       ,
    //check sum interface                   
    output   reg             check_init     ,
    output   reg [15:0]      check_data     ,
    output   reg             check_en       ,
    input        [31:0]      check_in       ,
    //flash interface
    output   reg [13:0]      row            ,
    output   reg             write_en       ,
    output   reg             erase_en       ,
    input                    ready          ,
    input                    done           ,
    //tx_interface
    output   reg             rx_flag        ,
    output   reg [7:0]       rx_type        ,
    output   reg [15:0]      rx_row         ,
    output   reg [7:0]       rx_pic         ,
    //rx_toe_interface
    input                    rx             ,
    input        [7:0]       rx_data        ,
    input        [2:0]       rx_chan        ,
    output   reg [7:0]       rx_full        ,
    //working state
    output   reg             busy           
);

//parameter
parameter             FSM_IDLE        = 4'd0;
parameter             FSM_RX          = 4'd1;
parameter             FSM_CHECK       = 4'd2;
parameter             FSM_DONE        = 4'd3;
parameter             FSM_ERASE       = 4'd4;
parameter             FSM_WAIT        = 4'd5;
parameter             FSM_JUDGEFLASH  = 4'd6;

//reg or net
reg   [12:0] cnt;
reg   [12:0] cnt1;
reg   [3:0]  fsm_current_state;
reg   [3:0]  fsm_next_state;
reg   [7:0]  type;
reg   [7:0]  ledid; 
reg   [7:0]  iln_h;
reg   [7:0]  iln_l;
reg          reload;
reg          receive_en;
reg          check_len;
reg   [31:0] csum;
reg   [15:0] rdata;
reg   [7:0]  idata;

wire  [15:0] w_sdata_out;

//receive_en
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      receive_en <= 1'b0;
    else if(w_sdata_out == 16'hf50a)
      receive_en <= 1'b1;
    else if((type == 8'h10 || type == 8'h11)&& cnt1 == 13'd33)
      receive_en <= 1'b0;
    else if(type == 8'h01 && cnt1 == 13'd3115)
      receive_en <= 1'b0;
    else if(cnt1 == 13'd4139)
      receive_en <= 1'b0;
  end

//cnt
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      cnt <= 13'd2;
    else if(rx && receive_en)
      cnt <= cnt + 1'b1;
    else if((type == 8'h10 || type == 8'h11)&& cnt == 13'd33)
      cnt <= 13'd2;
    else if(type == 8'h01 && cnt == 13'd3115)
      cnt <= 13'd2;
    else if(cnt == 13'd4139)
      cnt <= 13'd2;
  end

//cnt1
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      cnt1 <= 13'd0;
    else 
      cnt1 <= cnt;
  end 
//idata
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      idata <= 8'd0;
    else 
      idata <= rx_data;
  end

//type
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      type <= 8'd0;
    else if(cnt == 13'd15)
      type <= idata;
    else if(fsm_current_state == FSM_DONE)
      type <= 8'd0;
  end

//ledid
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      ledid <= 8'd0;
    else if(cnt == 13'd31)
      ledid <= idata;
    else if(fsm_current_state == FSM_DONE)
      ledid <= 8'd0;
  end
  
//iln_h
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      iln_h <= 8'd0;
    else if(cnt == 13'd16)
      iln_h <= idata;
    else if(fsm_current_state == FSM_DONE)
      iln_h <= 8'd0;
  end
  
//iln_l
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      iln_l <= 8'd0;
    else if(cnt == 13'd17)
      iln_l <= idata;
    else if(fsm_current_state == FSM_DONE)
      iln_l <= 8'd0;
  end

//csum  
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      csum <= 32'd0;
    else if((type == 8'h10 || type == 8'h11) && (cnt == 13'd31 || cnt == 13'd33))
      csum <= {csum[15:0],w_sdata_out};
    else if(type == 8'h01 && (cnt == 13'd3113 || cnt == 13'd3115))
      csum <= {csum[15:0],w_sdata_out};
    else if((type != 8'h10 && type != 8'h11) && (cnt == 13'd4137 || cnt == 13'd4139))
      csum <= {csum[15:0],w_sdata_out};
  end
  
//reload
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      reload <= 1'b0;
    else if((type == 8'h10 || type == 8'h11)&& cnt1 == 13'd33)
      reload <= 1'b1;
    else if(type == 8'h01 && cnt1 == 13'd3115)
      reload <= 1'b1;
    else if(cnt1 == 13'd4139)
      reload <= 1'b1;
    else if(cnt == 13'd2)
      reload <= 1'b0;
  end
    
//busy
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      busy <= 1'b0;
    else if(type == 8'h10)
      busy <= 1'b1;
    else if(type == 8'h11)
      busy <= 1'b0;
  end   
  
//check length
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      check_len <= 1'b1;
    else if(cnt == 13'd7)
      check_len <= 1'b1;
    else if(cnt == 13'd31 && (type == 8'h10 || type == 8'h11))
      check_len <= 1'b0;
    else if(cnt == 13'd4136 && (type == 8'h02 || type == 8'h03))
      check_len <= 1'b0;
    else if(cnt == 13'd3112 && type == 8'h01)
      check_len <= 1'b0;
  end   

//check enable
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      check_en <= 1'b0;
    else if(cnt> 13'd8 && check_len && (cnt[0]!= 1'b1) && (cnt != cnt1))
      check_en <= 1'b1;
    else if(cnt1 > 13'd8 && (cnt1[0] != 1'b1))
      check_en <= 1'b0;      
  end
//rdata
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      rdata <= 16'd0;
    else 
      rdata <= w_sdata_out;
  end

//check data
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      check_data <= 16'd0;
    else 
      check_data <= rdata;
  end
 
//current state
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      fsm_current_state <= 4'd0;
    else 
      fsm_current_state <= fsm_next_state;
  end
  
//check init
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      check_init <= 1'b0;
    else if(fsm_current_state == FSM_DONE)
      check_init <= 1'b1;
    else if(fsm_current_state == FSM_IDLE)
      check_init <= 1'b0;
    else if(fsm_current_state == FSM_CHECK && fsm_next_state == FSM_IDLE)
      check_init <= 1'b1;
  end
  
//next state
always@(*)
  begin
    case(fsm_current_state)
      
      FSM_IDLE:
        begin
          if(receive_en)
            fsm_next_state = FSM_RX;
          else
            fsm_next_state = FSM_IDLE;
        end
      
      FSM_RX:
        begin
          if(reload)
            fsm_next_state = FSM_CHECK;
          else
            fsm_next_state = FSM_RX;
        end
        
      FSM_CHECK:
        begin
          if(check_in == csum && type == 8'h10)
            fsm_next_state = FSM_JUDGEFLASH;
          else if(check_in == csum && type == 8'h11)
            fsm_next_state = FSM_DONE;
          else if(check_in == csum && (type !=8'h10 && type != 8'h11))
            fsm_next_state = FSM_WAIT;
          else 
            fsm_next_state = FSM_IDLE;
        end
        
      FSM_JUDGEFLASH:
        begin
          if(ready == 1'b0)
            fsm_next_state = FSM_ERASE;
          else
            fsm_next_state = FSM_JUDGEFLASH;
        end 
        
      FSM_ERASE:
        begin
          fsm_next_state = FSM_WAIT;
        end
      
      FSM_WAIT:
        begin
          if(done == 1'b1)
            fsm_next_state = FSM_DONE;
          else 
            fsm_next_state = FSM_WAIT;
        end    
        
      FSM_DONE:
        begin
          fsm_next_state = FSM_IDLE;
        end
        
      default: fsm_next_state = FSM_IDLE;
      
      
    endcase
  end

assign wdata = check_data;

//wr_en
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      wr_en <= 1'b0;
    else if(receive_en && cnt[0] == 1'b0 && (cnt != cnt1 || cnt ==13'd2))
      wr_en <= 1'b1;
    else if(cnt1[0] == 1'b0)
      wr_en <= 1'b0;
  end

//row
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      row <= 14'd0;
    else if(fsm_current_state == FSM_ERASE && iln_h == 8'h00)
      row <= {3'd1,11'd0};
    else if(fsm_current_state == FSM_ERASE && iln_h == 8'h01)
      row <= {3'd2,11'd0};
    else if(fsm_current_state == FSM_ERASE && iln_h == 8'h02)
      row <= {3'd3,11'd0};
    else if(fsm_current_state == FSM_CHECK && fsm_next_state == FSM_WAIT && type == 8'd02 && ledid == 8'h00)
      row <= {3'd1,iln_h[2:0],iln_l[7:0]};
    else if(fsm_current_state == FSM_CHECK && fsm_next_state == FSM_WAIT && type == 8'd02 && ledid == 8'h01)
      row <= {3'd2,iln_h[2:0],iln_l[7:0]};
    else if(fsm_current_state == FSM_CHECK && fsm_next_state == FSM_WAIT && type == 8'd01)
      row <= {3'd3,iln_h[2:0],iln_l[7:0]};
    else if(fsm_current_state == FSM_WAIT && fsm_next_state == FSM_DONE)
      row <= 14'd0;
  end

//erase enable
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      erase_en <= 1'b0;
    else if(fsm_current_state == FSM_ERASE && fsm_next_state == FSM_WAIT)
      erase_en <= 1'b1;
    else if(fsm_current_state == FSM_WAIT)
      erase_en <= 1'b0;
  end
  
//write enable
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      write_en <= 1'b0;
    else if(fsm_current_state == FSM_CHECK && fsm_next_state == FSM_WAIT)
      write_en <= 1'b1;
    else if(fsm_current_state == FSM_WAIT)
      write_en <= 1'b0;
  end
  
//rst_fifo
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      rst_fifo <= 1'b0;
    else if(fsm_current_state == FSM_CHECK && fsm_next_state == FSM_JUDGEFLASH)
      rst_fifo <= 1'b1;
    else if(fsm_current_state == FSM_CHECK && fsm_next_state == FSM_DONE)
      rst_fifo <= 1'b1;
    else if(fsm_current_state == FSM_DONE)
      rst_fifo <= 1'b0;
    else if(fsm_current_state == FSM_WAIT)
      rst_fifo <= 1'b0;
  end
  
//rx_full
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      rx_full <= 8'b0;
    else if(fsm_current_state == FSM_JUDGEFLASH)
      rx_full <= {8{1'b1}};
    else if(fsm_current_state == FSM_CHECK && fsm_next_state == FSM_WAIT)
      rx_full <= {8{1'b1}};
    else if(fsm_current_state == FSM_IDLE)
      rx_full <= 8'b0;
  end
  
//rx_flag
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      rx_flag <= 1'b0;
    else if(fsm_current_state == FSM_CHECK )
      rx_flag <= 1'b1;
    else if(fsm_current_state == FSM_JUDGEFLASH || fsm_current_state == FSM_DONE || fsm_current_state == FSM_WAIT || fsm_current_state == FSM_IDLE)
      rx_flag <= 1'b0;
  end
  
//rx_type
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      rx_type <= 8'd0;
    else if(fsm_current_state == FSM_CHECK && fsm_next_state == FSM_IDLE)
      rx_type <= 8'hff;
    else if(fsm_current_state == FSM_CHECK && fsm_next_state == FSM_WAIT)
      rx_type <= 8'h12;
    else if(fsm_current_state == FSM_CHECK && (fsm_next_state == FSM_JUDGEFLASH || fsm_next_state == FSM_DONE))
      rx_type <= type;
    else if(fsm_current_state == FSM_IDLE)
      rx_type <= 8'd0;
  end
  
//rx_row
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      rx_row <= 16'd0;
    else if(fsm_current_state == FSM_CHECK && fsm_next_state == FSM_WAIT)
      rx_row <= {iln_h,iln_l};
    else if(fsm_current_state == FSM_CHECK && (fsm_next_state == FSM_DONE || fsm_next_state == FSM_IDLE || fsm_next_state == FSM_JUDGEFLASH))
      rx_row <= 16'd0;
    else if(fsm_current_state == FSM_IDLE)
      rx_row <= 16'd0;
  end

//rx_pic
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      rx_pic <= 8'd0;
    else if(fsm_current_state == FSM_CHECK && (fsm_next_state ==FSM_JUDGEFLASH || fsm_next_state == FSM_DONE))
      rx_pic <= iln_h;
    else if(fsm_current_state == FSM_CHECK && fsm_next_state == FSM_WAIT)
      rx_pic <= type;
    else if(fsm_current_state == FSM_CHECK && fsm_next_state == FSM_IDLE)
      rx_pic <= 8'd0;
    else if(fsm_current_state == FSM_IDLE)
      rx_pic <= 8'd0;
  end  
  
srl32 u1_srl32(.clk(clk),
               .rst_n(rst_n),
               .data_in(rx_data),
               .data_valid(rx),
               .sdata(w_sdata_out));       

          
endmodule

    