module tx_control 
(
    //------------------------------------------
    //--  Global Reset, active low
    //------------------------------------------
    input                       rst_n           ,
    //------------------------------------------
    //--  Global clocks
    //------------------------------------------
    input                       clk             ,
    //------------------------------------------
    //--  rom interface
    //------------------------------------------ 
    output    reg               ena             ,
    output    reg [5:0]         addra           ,
    input         [7:0]         douta           ,
    //------------------------------------------
    //--  rx interface
    //------------------------------------------ 
    input                       rx_flag         ,
    input         [7:0]         rx_type         ,
    input         [15:0]        rx_row          ,
    input         [7:0]         rx_pic          ,
    //------------------------------------------
    //--  sum code interface
    //------------------------------------------
    output    reg               check_init      ,
    output    reg               check_en        ,
    output    reg [15:0]        check_data      ,
    input         [31:0]        check_in        , 
    //------------------------------------------
    //--  toe interface
    //------------------------------------------ 
    output    reg               tx              ,
    output    reg [7:0]         tx_data         ,
    output    reg [2:0]         tx_chan         ,
    input         [1:0]         tx_full         ,
    input                       flash_done      
);

//paramter
parameter  FSM_IDLE              = 4'd0;
parameter  FSM_TXDATA1           = 4'd1;
parameter  FSM_TXDATA2           = 4'd2;  
parameter  FSM_DELAY             = 4'd3;
parameter  FSM_TXCSUM            = 4'd4;
parameter  FSM_DONE              = 4'd5;
parameter  FSM_WAIT              = 4'd6;


//reg or net
reg      [3:0] fsm_current_state;  
reg      [3:0] fsm_next_state   ;
reg      [5:0] cnt              ;
reg      [3:0] cnt1             ;
reg      [7:0] type             ;
reg      [15:0]row              ;
reg      [7:0] pic              ;
reg            rd_en            ;
reg      [7:0] rdata            ;
reg            r_tx             ;


//current state 
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      fsm_current_state <= 4'd0;
    else
      fsm_current_state <= fsm_next_state;      
  end
  
//next_state
always@( * )
  begin
    case(fsm_current_state)
      
      FSM_IDLE:
        begin
          if(rx_flag && rx_type != 8'h11 && rx_type != 8'hff)
            fsm_next_state = FSM_WAIT;
          else if(rx_flag && (rx_type == 8'h11 || rx_type == 8'hff))
            fsm_next_state = FSM_TXDATA1;
          else
            fsm_next_state = FSM_IDLE;
        end
        
      FSM_WAIT:
        begin
          if(flash_done)
            fsm_next_state = FSM_TXDATA1;
          else 
            fsm_next_state = FSM_WAIT;
        end
        
      FSM_TXDATA1:
        begin
          if(rd_en)
            fsm_next_state = FSM_TXDATA2;
          else 
            fsm_next_state = FSM_TXDATA1;
        end
        
      FSM_TXDATA2:
        begin
          if(cnt <= 6'd28)
            fsm_next_state = FSM_TXDATA1;
          else 
            fsm_next_state = FSM_DELAY;            
        end
      
      FSM_DELAY:
        begin
          fsm_next_state = FSM_TXCSUM;
        end
      
      FSM_TXCSUM:
        begin
          if(cnt1 <4'd4)
            fsm_next_state = FSM_TXCSUM;
          else 
            fsm_next_state = FSM_DONE;
        end
        
      FSM_DONE:
        begin
          fsm_next_state = FSM_IDLE;
        end
        
      default:fsm_next_state = FSM_IDLE;
    endcase
  end
  
//type
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      type <= 8'd0;
    else if(fsm_current_state == FSM_IDLE && fsm_next_state == FSM_WAIT)
      type <= rx_type;
    else if(fsm_current_state == FSM_DONE)
      type <= 8'd0; 
  end
  
//row
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      row <= 16'd0;
    else if(fsm_current_state == FSM_IDLE && fsm_next_state == FSM_WAIT)
      row <= rx_row;
    else if(fsm_current_state == FSM_DONE)
      row <= 16'd0;
  end
  
//pic
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      pic <= 8'd0;
    else if(fsm_current_state == FSM_IDLE && fsm_next_state == FSM_WAIT)
      pic <= rx_pic;
    else if(fsm_current_state == FSM_DONE)
      pic <= 8'd0;
  end
  
//cnt
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      cnt <= 6'd0;
    else if(rd_en)
      cnt <= cnt + 1'b1;
    else if(fsm_current_state == FSM_TXCSUM)
      cnt <= 6'd0;
  end
  
//cnt1
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      cnt1 <= 4'd0;
    else if(fsm_current_state == FSM_TXCSUM)
      cnt1 <= cnt1 +1'b1;
    else if(fsm_current_state == FSM_DONE)
      cnt1 <= 4'd0;
  end
  
//check_init
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      check_init <= 1'b0;
    else if(fsm_current_state == FSM_DONE)
      check_init <= 1'b1;
    else if(fsm_current_state == FSM_IDLE)
      check_init <= 1'b0;
  end
  
//check_en
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      check_en <= 1'b0;
    else if(cnt >6'd8 && fsm_current_state == FSM_TXDATA2)
      check_en <= 1'b1;
    else if(fsm_current_state == FSM_TXDATA1)
      check_en <= 1'b0;
    else if(fsm_current_state == FSM_DELAY)
      check_en <= 1'b0;
  end
  
//check data
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      check_data <= 16'd0;
    else if(fsm_current_state == FSM_TXDATA1 && fsm_next_state == FSM_TXDATA2 && (cnt < 6'd15 || cnt > 6'd19 ))
      check_data <= {check_data[7:0],douta};
    else if(cnt == 6'd16)
      check_data <= {check_data[7:0],type};
    else if(cnt == 6'd17)
      check_data <= {check_data[7:0],pic};
    else if(cnt == 6'd18)
      check_data <= {check_data[7:0],row[15:8]};
    else if(cnt == 6'd19)
      check_data <= {check_data[7:0],row[7:0]};
    else if(fsm_current_state == FSM_TXDATA2 &&(cnt!= 6'd16 || cnt != 6'd18))
      check_data <= {check_data[7:0],douta};
    else if(fsm_current_state == FSM_DONE)
      check_data <= 16'd0;
  end
  
//r_tx
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      r_tx <= 1'b0;
    else if(rd_en)
      r_tx <= 1'b1;
    else if(rd_en == 1'b0)
      r_tx <= 1'b0;
  end

//tx
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      tx <= 1'b0;
    else if(r_tx)
      tx <= r_tx;
    else if(cnt1 == 4'd0 && fsm_current_state == FSM_TXCSUM)
      tx <= 1'b1;
    else if(cnt1 == 4'd4)
      tx <= 1'b0;
  end

//rdata
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      rdata <= 8'd0;
    else if(rd_en &&(cnt <=6'd15 || cnt > 6'd19))
      rdata <= douta;
    else if(cnt == 6'd16)
      rdata <= type;
    else if(cnt == 6'd17)
      rdata <= pic;
    else if(cnt == 6'd18)
      rdata <= row[15:8];
    else if(cnt == 6'd19)
      rdata <= row[7:0];
   // else if(cnt1 == 4'd0)
   //   rdata <= check_in[31:24];
    else if(fsm_current_state == FSM_TXDATA2 && fsm_next_state == FSM_DELAY)
      rdata <= 8'd0;
   // else if(cnt1 == 4'd1)
   //   tx_data <= check_in[23:16];
   // else if(cnt1 == 4'd2)
   //   tx_data <= check_in[15:8];
   // else if(cnt1 == 4'd3)
   //   tx_data <= check_in[7:0];
   // else if(fsm_current_state == FSM_TXCSUM && fsm_next_state == FSM_DONE)
   //   tx_data <= 8'd0;
  end
  
//tx_data
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      tx_data <= 8'd0;
    else if(r_tx)
      tx_data <= rdata;
    else if(cnt1 == 4'd0 && fsm_current_state == FSM_TXCSUM)
      tx_data <= check_in[31:24] ;
    else if(cnt1 == 4'd1)
      tx_data <= check_in[23:16] ;
    else if(cnt1 == 4'd2)
      tx_data <= check_in[15:8]  ;
    else if(cnt1 == 4'd3)
      tx_data <= check_in[7:0]   ;
    else if(cnt1 == 4'd4)
      tx_data <= 8'd0            ;
  end
//tx chan
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      tx_chan <= 3'd0;
    else if(fsm_current_state == FSM_TXDATA1 && fsm_next_state == FSM_TXDATA2)
      tx_chan <= 3'd1;
    else if(fsm_current_state == FSM_DONE)
      tx_chan <= 3'd0;
  end

//ena
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      ena <= 1'b0;
    else if(fsm_current_state == FSM_WAIT && fsm_next_state == FSM_TXDATA1)
      ena <= 1'b1;
    else if(fsm_current_state == FSM_IDLE && fsm_next_state == FSM_TXDATA1)
      ena <= 1'b1;
    else if(fsm_current_state == FSM_TXDATA2 && fsm_next_state == FSM_DELAY)
      ena <= 1'b0;
  end
  
//rd en 
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      rd_en <= 1'b0;
    else 
      rd_en <= ena;
  end
  
//addra
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      addra <= 6'd0;
    else if(fsm_current_state == FSM_WAIT && fsm_next_state == FSM_TXDATA1)
      addra <= 6'd0;
    else if(fsm_current_state == FSM_TXDATA1 ||(fsm_current_state == FSM_TXDATA2 && fsm_next_state == FSM_TXDATA1))
      addra <= addra + 1'b1;
    else if(fsm_current_state == FSM_TXDATA2 && fsm_next_state == FSM_DELAY)
      addra <= 6'd0;
  end
endmodule