module tx_ctrl
(
    //------------------------------------------
    //--  Global Reset, active low
    //------------------------------------------
    input             rst_n                    ,
    //------------------------------------------
    //--  Global clocks
    //------------------------------------------
    input             clk                      ,
    //------------------------------------------
    //--  main control interface
    //------------------------------------------    
    input             timing_telemetry         ,
    input             timing_lightdiag         ,
    input             timing_stardiag          ,
    output reg        transmit_done            ,
    //------------------------------------------
    //--  data read interface
    //------------------------------------------
    output reg        start_read               ,
    output reg[10:0]  row                      ,
    output reg[1:0]   picture_choose           ,
    input             read_done                ,
    //------------------------------------------
    //--  tx interface
    //------------------------------------------
    output reg[31:0]  pkbl                     ,
    output reg[15:0]  pkpck                    
);

//parameter
parameter FSM_IDLE          = 4'd0;
parameter FSM_GETROW        = 4'd1;
parameter FSM_TX            = 4'd2;
parameter FSM_WAITTX        = 4'd3;
parameter FSM_DONE          = 4'd4;
parameter FSM_JUDGECOUNT    = 4'd5;
parameter FSM_WAIT          = 4'd6;

parameter waiting           = 20;
//reg or net
reg      [12:0] count             ;
reg      [11:0] cnt               ;
reg      [3:0]  fsm_current_state ;
reg      [3:0]  fsm_next_state    ;
reg             telemetry_en      ;
reg             stardiag_en       ;
reg             lightdiag_en      ;

//telemetry_en register
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      telemetry_en <= 1'b0;
    else if(timing_telemetry)
      telemetry_en <= 1'b1;
    else if(fsm_current_state == FSM_DONE && fsm_next_state == FSM_IDLE) 
      telemetry_en <= 1'b0;
  end

//stardiag_en register
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      stardiag_en <= 1'b0;
    else if(timing_stardiag)
      stardiag_en <= 1'b1;
    else if(fsm_current_state == FSM_DONE && fsm_next_state == FSM_IDLE) 
      stardiag_en <= 1'b0;
  end
  
//lightdiag_en register
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      lightdiag_en <= 1'b0;
    else if(timing_lightdiag)
      lightdiag_en <= 1'b1;
    else if(fsm_current_state == FSM_DONE && fsm_next_state == FSM_IDLE)
      lightdiag_en <= 1'b0;
  end
       
//current state
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      fsm_current_state <= 4'd0;
    else
      fsm_current_state <= fsm_next_state;
  end
  
//next_state
always@(*)
  begin
    case(fsm_current_state)
      
      FSM_IDLE:
        begin
          if(timing_telemetry | timing_lightdiag | timing_stardiag)
            fsm_next_state = FSM_GETROW;
          else
            fsm_next_state = FSM_IDLE;
        end
      
      FSM_JUDGECOUNT:
        begin
          if(telemetry_en && count == 12'd1)
            fsm_next_state = FSM_DONE;
          else if((lightdiag_en | stardiag_en) && count == 12'd2048)    //2048
            fsm_next_state = FSM_DONE;
          else 
            fsm_next_state = FSM_GETROW;
        end
        
      FSM_GETROW:
        begin
          fsm_next_state = FSM_TX;
        end
        
      FSM_TX:
        begin
          fsm_next_state = FSM_WAITTX;
        end
        
      FSM_WAITTX:
        begin
          if(read_done)
            fsm_next_state = FSM_WAIT;
          else
            fsm_next_state = FSM_WAITTX;
        end
        
      FSM_WAIT:
        begin
          if(cnt == waiting)
            fsm_next_state = FSM_JUDGECOUNT;
          else
            fsm_next_state = FSM_WAIT;
        end
      
      FSM_DONE:
        begin
          fsm_next_state = FSM_IDLE;
        end
      
      default:fsm_next_state = FSM_IDLE;
    endcase
  end
  
//count
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      count <= 12'd0;
    else if(read_done)
      count <= count + 1'b1;
    else if(fsm_current_state == FSM_DONE && fsm_next_state == FSM_IDLE)
      count <= 12'd0;
  end
//cnt
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      cnt <= 11'd0;
    else if(fsm_current_state == FSM_WAIT && cnt < waiting)
      cnt <= cnt +1'b1;
    else if(cnt == waiting)
      cnt <= 11'd0;
  end
  
//row
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      row <= 11'd2047;
    else if(fsm_current_state == FSM_GETROW)
      row <= row +1'b1;
    else if(fsm_current_state == FSM_DONE && fsm_next_state == FSM_IDLE)
      row <= 11'd2047;
  end
  
//start_read
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      start_read <= 1'b0;
    else if(fsm_current_state == FSM_TX)
      start_read <= 1'b1;
    else if(fsm_current_state == FSM_WAITTX)
      start_read <= 1'b0;
  end

//picture choose
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      picture_choose <= 2'd0;
    else if(fsm_current_state == FSM_TX && telemetry_en)
      picture_choose <= 2'd3;
    else if(fsm_current_state == FSM_TX && stardiag_en)
      picture_choose <= 2'd1;
    else if(fsm_current_state == FSM_TX && lightdiag_en)
      picture_choose <= 2'd2;
    else if(fsm_current_state == FSM_DONE)
      picture_choose <= 2'd0;
  end
  
//transmit done
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      transmit_done <= 1'b0;
    else if(fsm_current_state == FSM_DONE && fsm_next_state == FSM_IDLE)
      transmit_done <= 1'b1;
    else if(fsm_current_state == FSM_IDLE)
      transmit_done <= 1'b0;
  end
  
//pkbl                                  
always@(posedge clk or negedge rst_n)
  begin 
    if(!rst_n)
      pkbl <= 32'd0;
    else if(fsm_current_state == FSM_TX)
      pkbl <= pkbl + 1'b1;
    else if(fsm_current_state == FSM_DONE)
      pkbl <= 32'd0;
  end                                                                           //data frame count
  
//pkpck
always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      pkpck <= 16'd0;
    else if(telemetry_en)
      pkpck <= 16'd1;
    else if(stardiag_en)
      pkpck <= 16'd2;
    else if(lightdiag_en)
      pkpck <= 16'd3;
    else if(fsm_current_state == FSM_DONE)
      pkpck <= 16'd0;                                         
  end                                                                             //data type 
  
endmodule
      