module do_ch(
input            i_clk         ,
input            i_rst_n       ,
input            i_din_feedback,
input            fault         ,
input  [11:0]    im_paraddr    ,
input            i_parwren     ,
input  [7:0]     im_pardata    ,
input  [11:0]     im_rdaddr    , 
output reg[7:0]  om_rddata     ,
input            i_rden        ,          
output reg       o_fd_channel  ,
output [1:0]     led_ctrl
);
reg      [7:0]    im_channel_on       ;
reg      [7:0]    im_feedback_on      ;
reg      [7:0]    im_cycle_feedback   ;
reg      [7:0]    im_delay            ;
reg      [7:0]    im_din              ;
reg               om_feedback_result  ;
reg      [1:0]    r_din_reg           ;
                                      
reg               feedback_error      ;
reg      [4:0]    feedback_error_reg  ;
                                      
reg      [21:0]   cnt_delay           ;
reg               feedback_flag       ;
reg               cycle_flag          ;
                                      
reg      [31:0]   cnt_cycle_feedback  ;
wire     [31:0]   CYCLE_feedback      ;
reg      [3:0 ]   state               ;
                  
reg               feedback_error_temp ;
reg      [15:0]   cnt_low             ;
reg      [15:0]   cnt_high            ;

//parameter CNT_delay1  = 50000;        //1ms
//parameter CNT_delay2  = 100000;       //2ms 100,000 1.3ms   1ms 50,000 0.9ms 45000 0.8ms 40000 0.6ms 30000 0.5ms 25000  

parameter CNT_low     = 5;
parameter CNT_high    = 5;

parameter INITIAL         = 4'b0000;
parameter FEEDBACK_close  = 4'b0001;
parameter FEEDBACK_open   = 4'b0010;
parameter WAIT            = 4'b0011;
parameter DO_MIN    = 8'h00;
parameter DO_MAX    = 8'h01;
parameter DO_KEEP   = 8'h02;
parameter DO_SET    = 8'h03;
parameter CH_ADD    = 12'd0;
parameter LED_ON    = 2'b00;
parameter LED_OFF   = 2'b01;
parameter LED_BLINK = 2'b10;
reg       temp            ;
reg       din_feedback_reg;

reg [1:0]   temp_fault  ;
reg [7:0]   ctrl_data   ;
reg [7:0]   safe_value  ;  
reg [7:0]   temp_do_data; 
reg [7:0]   safe_type   ;

assign led_ctrl = (im_channel_on==8'h01)?(om_feedback_result?LED_BLINK:LED_ON):LED_OFF;
always @ (posedge i_clk or negedge i_rst_n)
begin
	   if(!i_rst_n)
	   	  temp_fault        <= 0;
	   else 
	   	  temp_fault        <= {temp_fault[0],fault};
end
always @ (posedge i_clk or negedge i_rst_n)
begin
	   if(!i_rst_n)
	   	  temp_do_data        <= 0;
	   else if(temp_fault == 2'b01)
	   	  temp_do_data        <= ctrl_data;
end
always @ (posedge i_clk or negedge i_rst_n)
begin
	   if(!i_rst_n)
	   	  im_din        <= 0;
	   else begin
	   	if(temp_fault[1])
	   	  begin
	   	  	case(safe_type)
	   	  		DO_MIN   :im_din <= 8'd0        ;
                DO_MAX   :im_din <= 8'd1        ;
                DO_KEEP  :im_din <= temp_do_data;
                DO_SET   :im_din <= safe_value  ;
	   	  		default:  im_din <= im_din      ;
	   	  	endcase
	   	end
	   	 else
	   	         im_din       <= ctrl_data;
	  end
end



always @ (posedge i_clk or negedge i_rst_n)
begin
    if(!i_rst_n)
        om_rddata <= 'd0;
    else if(i_rden)
      begin
        case(im_rdaddr)  
          CH_ADD          :om_rddata<=   im_channel_on     ;//CH_EN          
          CH_ADD + 01     :om_rddata<=   im_feedback_on    ;                  
          CH_ADD + 02     :om_rddata <= 8'hzz              ;//MODE               
          CH_ADD + 03     :om_rddata<=   im_cycle_feedback ;//diag_cycle  
          CH_ADD + 04     :om_rddata <= 8'hzz              ;
          CH_ADD + 05     :om_rddata<=   safe_type         ;//                 
          CH_ADD + 06     :om_rddata<=   ctrl_data         ;                   
          CH_ADD + 07     :om_rddata <= 8'hzz              ;                                    
          CH_ADD + 08     :om_rddata<=   im_delay          ;                  
          CH_ADD + 09     :om_rddata <= 8'hzz              ;
          CH_ADD/32+2112   : om_rddata <= {7'd0,im_din[0]};
          CH_ADD/32+2112 +1: om_rddata <= {7'd0,om_feedback_result};
           default:om_rddata <= 8'hzz;
        endcase
    end
end


always @ (posedge i_clk or negedge i_rst_n)
begin
    if(!i_rst_n)
        begin
        	im_channel_on        <= 'd0;
            im_feedback_on       <= 'd0;
            im_cycle_feedback    <= 'd0;
            safe_type            <= 'd0;
            ctrl_data            <= 'd0;
            im_delay             <= 'd0; 
        end
    else if(i_parwren)
        begin
            case(im_paraddr)
                CH_ADD          :im_channel_on    <= im_pardata ;//CH_EN
                CH_ADD + 01     :im_feedback_on   <= im_pardata ;   
                CH_ADD + 02     :;//MODE                     
                CH_ADD + 03     :im_cycle_feedback<= im_pardata ;//diag_cycle
                CH_ADD + 04     :;
                CH_ADD + 05     :safe_type        <= im_pardata ;//                
                CH_ADD + 06     :safe_value       <= im_pardata ;                           
                CH_ADD + 07     :;
                CH_ADD + 08     :im_delay         <= im_pardata ;
                CH_ADD + 09     :;
                CH_ADD/32+2048   :ctrl_data       <= im_pardata ;
            default:;
            endcase
        end
end

always @(posedge i_clk) begin
  if(!i_rst_n)begin 
    temp             <= 0;
    din_feedback_reg <= 0;
  end
  else begin
    temp             <= i_din_feedback;
    din_feedback_reg <= temp;
  end
end


wire [21:0] CNT_delay1;
wire [21:0] CNT_delay2;

//1ms/20ns=50000  500us/20ns=25000
assign CNT_delay1 = ({{18'b0,im_delay[3:0]}<<15} + {{18'b0,im_delay[3:0]}<<14} + {{18'b0,im_delay[3:0]}<<9} 
+ {{18'b0,im_delay[3:0]}<<8} + {{18'b0,im_delay[3:0]}<<6} + {{18'b0,im_delay[3:0]}<<4})>>1;
assign CNT_delay2 = ({{18'b0,im_delay[7:4]}<<15} + {{18'b0,im_delay[7:4]}<<14} + {{18'b0,im_delay[7:4]}<<9} 
+ {{18'b0,im_delay[7:4]}<<8} + {{18'b0,im_delay[7:4]}<<6} + {{18'b0,im_delay[7:4]}<<4})>>1;



assign CYCLE_feedback = ({{24'b0,im_cycle_feedback}<<25} + {{24'b0,im_cycle_feedback}<<23} + {{24'b0,im_cycle_feedback}<<22} 
+ {{24'b0,im_cycle_feedback}<<21} + {{24'b0,im_cycle_feedback}<<20} + {{24'b0,im_cycle_feedback}<<19} + 
{{24'b0,im_cycle_feedback}<<17} + {{24'b0,im_cycle_feedback}<<15} + {{24'b0,im_cycle_feedback}<<14} + {{24'b0,im_cycle_feedback}<<13} + {{24'b0,im_cycle_feedback}<<12} + {{24'b0,im_cycle_feedback}<<7})>>2; 

always @ (posedge i_clk or negedge i_rst_n) begin
  if(!i_rst_n) 
    r_din_reg <= 0;
  else
    r_din_reg <= {r_din_reg[0],im_din[0]};   
end

//continuous feedback 5 times 
always @ ( posedge i_clk or negedge i_rst_n) begin
  if (!i_rst_n)
      om_feedback_result <= 0   ;
  else if (im_feedback_on == 8'h01 )begin
    if (feedback_error_reg == 5'b11111)
      om_feedback_result <= 1'b1;
    else
      om_feedback_result <= 0   ; 
  end
  else
      om_feedback_result <= 0   ;
end 

always@(posedge i_clk or negedge i_rst_n)begin
  if(!i_rst_n)begin
      cnt_cycle_feedback <= 0;
  end
  else begin
    if(cycle_flag) begin
      if (cnt_cycle_feedback < CYCLE_feedback)begin
        if(r_din_reg == 2'b01 | r_din_reg == 2'b10)
            cnt_cycle_feedback <= 0;
        else
            cnt_cycle_feedback <= cnt_cycle_feedback + 1'b1;
      end
      else
          cnt_cycle_feedback <= 0;
    end
    else
        cnt_cycle_feedback <= 0; 
  end
end



always @(posedge i_clk or negedge i_rst_n) begin
  if(!i_rst_n) begin
    cnt_delay  <= 0;
  end  
  else if(feedback_flag == 1)begin
    if(cnt_delay < CNT_delay2)
      cnt_delay  <= cnt_delay + 1'b1;
    else
      cnt_delay  <= 0; 
  end
  else
    cnt_delay <= 0;
end



always @ (posedge i_clk or negedge i_rst_n) begin
  if(!i_rst_n) begin
    state               <= INITIAL;
    feedback_error      <= 0;
    feedback_flag       <= 0;
    cycle_flag          <= 0;
    feedback_error_reg  <= 0;
    o_fd_channel        <= 0;
    feedback_error_temp <= 1'b1;
    cnt_low             <= 16'd0;
    cnt_high            <= 16'd0;
  end
  else if (im_channel_on == 8'b01)begin
    case (state)
      INITIAL :  begin              
                   o_fd_channel      <= im_din[0];
                   if(im_feedback_on == 8'h01) begin
                     if(r_din_reg == 2'b11 | r_din_reg == 2'b00) begin //add?
                       if(r_din_reg == 2'b11)begin         
                         state                <= FEEDBACK_close;
                         feedback_flag        <= 1'b1;
                         o_fd_channel         <= ~o_fd_channel; 
                         feedback_error_temp  <= 1'b1;
                         cnt_low              <= 16'd0;
                       end
                       else begin
                         state                <= FEEDBACK_open;
                         feedback_flag        <= 1'b1;
                         o_fd_channel         <= ~o_fd_channel; 
                         feedback_error_temp  <= 1'b1;
                         cnt_high             <= 16'd0;
                       end
                   end
                   else begin
                     o_fd_channel    <= im_din[0]; 
                     feedback_flag   <= 1'b0;
                     state           <= INITIAL;
                     feedback_error  <= 0;
                     feedback_flag   <= 0;
                   end							
                 end
                 else
                   state <= INITIAL;
                end  
    FEEDBACK_close: begin
                 if(cnt_delay >= CNT_delay1)  //1ms
                   o_fd_channel  <= im_din[0];
                   if(cnt_delay < CNT_delay2)begin //2ms
                     begin
                       if(din_feedback_reg == 1'b1)
                         cnt_low  <= 16'd0;
                       else begin
                         cnt_low  <= cnt_low + 16'd1;  
                         if( cnt_low >= CNT_low)
                           feedback_error_temp <= 0;
                       end
                     end
                   end 
                   else if (cnt_delay == CNT_delay2)begin
                     state              <= WAIT;
                     feedback_error_reg <= {feedback_error_reg[3:0], feedback_error_temp};
                     feedback_error     <= feedback_error_temp; 
                     cycle_flag         <= 1;
                     feedback_flag      <= 0;  
                     cnt_low            <= 16'd0;
                   end 
                end 
      FEEDBACK_open: begin
                 if(cnt_delay >= CNT_delay1)  //1ms
                   o_fd_channel  <= im_din[0];
                   if(cnt_delay < CNT_delay2)begin //2ms
                     begin
                       if(din_feedback_reg == 1'b0)
                         cnt_high  <= 16'd0;
                       else begin
                         cnt_high  <= cnt_high + 16'd1;  
                         if( cnt_high >= CNT_high)
                           feedback_error_temp <= 0;
                       end
                     end
                   end 
                   else if (cnt_delay == CNT_delay2)begin
                     state              <= WAIT;
                     feedback_error_reg <= {feedback_error_reg[3:0], feedback_error_temp};
                     feedback_error     <= feedback_error_temp; 
                     cycle_flag         <= 1;
                     feedback_flag      <= 0;  
                     cnt_high           <= 16'd0;
                   end 
                end 
      WAIT    : begin
                  o_fd_channel <= im_din[0];				 
                  if(cnt_cycle_feedback == CYCLE_feedback) begin
                    cycle_flag  <= 0;
                    state       <= INITIAL; 
                  end
                  else
                    state       <= WAIT; 
                end
     default  : state <= INITIAL;
    endcase
  end
  else begin
    state               <= INITIAL;
    feedback_error      <= 0;
    feedback_flag       <= 0;
    cycle_flag          <= 0;
    feedback_error_reg  <= 0;
    o_fd_channel        <= 0;
    feedback_error_temp <= 1'b1;
    cnt_low             <= 16'd0;
    cnt_high            <= 16'd0;
  end
end       

endmodule
                  