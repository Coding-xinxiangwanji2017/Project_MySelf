//add delay register
module di_ch(
input             i_clk       ,
input             i_rst_n     ,
input             i_din       ,                  // input 
                              
                              
input  [11:0]    im_paraddr   ,
input            i_parwren    ,
input  [7:0]     im_pardata   ,
input  [11:0]    im_rdaddr    , 
output reg[7:0]  om_rddata    ,
input            i_rdren      , 
                              
                              
output reg        o_test_open ,            // output 
output reg        o_test_close,

output  [1:0]     led_ctrl    ,
output     [7:0]  test                    // test
);










reg      [7:0]  im_channel_on       ;           // channel on or not
reg      [7:0]  im_diag_on          ;             // diag on or not
reg      [7:0]  im_time_dejitter_reg;    // dejitter time
reg      [7:0]  im_diag_cycle_reg   ;       // cycle diag time
reg      [7:0]  im_delay            ;                // add delay time

//output reg [7:0]  om_dout,







reg               om_diag_result;          // diag result of continuous diag 5 times
reg               din           ;
reg               din_reg       ;
reg        [1:0]  din_reg_1     ;
           
reg        [23:0] cnt_high      ;              // count high level
reg        [23:0] cnt_low       ;               // count low level

reg        [20:0] cnt_open      ;              // count open 
reg        [20:0] cnt_close     ;             // count close 
reg        [32:0] cnt_diag      ;              // count diag 
           
reg               open_flag     ;             // the start of test open state
reg               close_flag    ;            // the start of test close state
reg               diag_flag     ;             // the start of diag cycle state
                                
reg        [3:0]  state         ;
reg        [1:0]  diag_state    ;          
reg               diag_error    ;            // one time diag result: 1 error,0 right
reg        [4:0]  diag_error_reg;
           
wire       [23:0] time_dejitter_cnt;     // count dejitter time
wire       [32:0] diag_cycle_cnt   ;        // count diag time
           
reg        [20:0] cnt              ;
reg               diag_error_temp  ;

parameter INITIAL   = 4'b0000;           //initial
parameter WAIT_DE   = 4'b0001;           //dejitter
parameter DIAG      = 4'b0010;           //diag

parameter DIAG_open  = 2'b10;            //{close,open}    //test open
parameter DIAG_close = 2'b01;            // test close          
parameter DIAG_com   = 2'b11;            // run
parameter DIAG_wait  = 2'b00;            // cycle diag wait 
parameter CH_ADD    = 12'd0 ;
parameter    LED_ON      = 2'b00        ;
parameter    LED_OFF     = 2'b01        ;
parameter    LED_BLINK   = 2'b10        ;
wire      [19:0]   CNT_delay0;           //delay
wire      [19:0]   CNT_delay ;


assign led_ctrl = (im_channel_on==8'h01)?(om_diag_result?LED_BLINK:LED_ON):LED_OFF;
/*
parameter CNT_dejitter = 500,000;     //10ms
parameter diag_cycle_cnt   = 3,250,000,000;    //65s   5000000 100ms
parameter CNT_delay  = 150000;        //3ms   75000 1.5ms
*/

always @ (posedge i_clk or negedge i_rst_n)
begin
    if(!i_rst_n)
        om_rddata <= 'd0;
    else if(i_rdren)
      begin
        case(im_rdaddr)
        	    CH_ADD          :om_rddata <= im_channel_on        ;//CH_EN
                CH_ADD + 01     :om_rddata <= im_diag_on           ;   
                CH_ADD + 02     :om_rddata <= 8'hzz                ;//MODE                       
                CH_ADD + 03     :om_rddata <= im_diag_cycle_reg    ;//diag_cycle
                CH_ADD + 04     :om_rddata <= 8'hzz                ;
                CH_ADD + 05     :om_rddata <= 8'hzz                ;//                
                CH_ADD + 06     :om_rddata <= 8'hzz                ;                    
                CH_ADD + 07     :om_rddata <= im_time_dejitter_reg ;
                CH_ADD + 08     :om_rddata <= im_delay             ; 
                CH_ADD + 09     :om_rddata <= 8'hzz                ;
                CH_ADD/32+2048  :om_rddata <= {7'd0,din_reg}       ;
                CH_ADD/32+2048+1:om_rddata <= {7'd0,om_diag_result};
           default:om_rddata <= 8'hzz;
        endcase
    end
end


always @ (posedge i_clk or negedge i_rst_n)
begin
    if(!i_rst_n)
        begin
        	im_channel_on        <= 'd0;
            im_diag_on              <= 'd0;
            im_diag_cycle_reg    <= 'd0;
            im_time_dejitter_reg <= 'd0;
            im_delay             <= 'd0; 
        end
    else if(i_parwren)
        begin
            case(im_paraddr)
                CH_ADD          :im_channel_on    <= im_pardata  ;//CH_EN
                CH_ADD + 01     :im_diag_on          <= im_pardata ;   
                CH_ADD + 02     :                            ;//MODE                     
                CH_ADD + 03     :im_diag_cycle_reg<= im_pardata ;//diag_cycle
                CH_ADD + 04     :;
                CH_ADD + 05     :;//                
                CH_ADD + 06     :;                           
                CH_ADD + 07     :im_time_dejitter_reg <= im_pardata ;
                CH_ADD + 08     :im_delay             <= im_pardata ; 
                CH_ADD + 09     :;
            default:;
            endcase
        end
end














//1ms/20ns=50,000=2^15+2^14+2^9+2^8+2^6+2^4    1s/20ns=50,000,000=2^25+ 2^23 + 2^22 + 2^21 + 2^20 + 2^19 + 2^17+ 2^15+ 2^14 + 2^13 + 2^12 + 2^7
assign time_dejitter_cnt = {{16'b0,im_time_dejitter_reg}<<15} + {{16'b0,im_time_dejitter_reg}<<14} + {{16'b0,im_time_dejitter_reg}<<9} + {{16'b0,im_time_dejitter_reg}<<8} + {{16'b0,im_time_dejitter_reg}<<6} + {{16'b0,im_time_dejitter_reg}<<4};

assign diag_cycle_cnt    = {{25'b0,im_diag_cycle_reg}<<25} + {{25'b0,im_diag_cycle_reg}<<23} + {{25'b0,im_diag_cycle_reg}<<22} 
+ {{25'b0,im_diag_cycle_reg}<<21} + {{25'b0,im_diag_cycle_reg}<<20} + {{25'b0,im_diag_cycle_reg}<<19} + 
{{25'b0,im_diag_cycle_reg}<<17} + {{25'b0,im_diag_cycle_reg}<<15} + {{25'b0,im_diag_cycle_reg}<<14} + {{25'b0,im_diag_cycle_reg}<<13} + {{25'b0,im_diag_cycle_reg}<<12} + {{25'b0,im_diag_cycle_reg}<<7}; 

assign CNT_delay  = im_delay[7:4]*16'd50000;//{{17'b0,im_delay[7:4]}<<15} + {{17'b0,im_delay[7:4]}<<14} + {{17'b0,im_delay[7:4]}<<9} + {{17'b0,im_delay[7:4]}<<8} + {{17'b0,im_delay[7:4]}<<6} + {{17'b0,im_delay[7:4]}<<4};
assign CNT_delay0 = im_delay[3:0]*16'd50000;//{{17'b0,im_delay[3:0]}<<15} + {{17'b0,im_delay[3:0]}<<14} + {{17'b0,im_delay[3:0]}<<9} + {{17'b0,im_delay[3:0]}<<8} + {{17'b0,im_delay[3:0]}<<6} + {{17'b0,im_delay[3:0]}<<4};


reg temp;

// input i_din delay 2 i_clk cycles
always @ (posedge i_clk or negedge i_rst_n) begin
  if (!i_rst_n) begin
    temp <= 0;
    din  <= 0;
  end	
  else begin	
    temp <= i_din;
    din  <= temp ;
  end
end

//dejitter
always @(posedge i_clk or negedge i_rst_n) begin
  if (!i_rst_n) begin
    cnt_high <= 0;
    cnt_low  <= 0;
  end
  else if (im_channel_on == 8'h01)begin
    if( din == 1 ) begin
      if(cnt_high < time_dejitter_cnt)begin
        cnt_high  <= cnt_high + 1'b1;
        cnt_low   <= 0;
      end
    end
    else begin
      if(cnt_low < time_dejitter_cnt) begin
        cnt_low  <= cnt_low + 1'b1;
        cnt_high <= 0;  
      end
    end
  end
  else begin
  	cnt_high <= 0;
    cnt_low  <= 0;
  end
end

always @ (posedge i_clk or negedge i_rst_n) begin
  if(!i_rst_n)
    din_reg <= 0;
  else begin
    if(cnt_high == time_dejitter_cnt)
      din_reg <= 1;
    else if(cnt_low == time_dejitter_cnt)
      din_reg <= 0;
    else
      din_reg <= din_reg;
  end
end

// din_reg change or not 
always @ (posedge i_clk or negedge i_rst_n) begin
  if(!i_rst_n)
    din_reg_1 <= 0;
  else if( cnt_high == time_dejitter_cnt | cnt_low == time_dejitter_cnt ) 
    din_reg_1 <= {din_reg_1[0], din_reg};
end


//continuous diag 5 times 
always @ ( posedge i_clk or negedge i_rst_n) begin
  if (!i_rst_n)
    om_diag_result <= 0;
  else if (im_diag_on == 8'h01 )begin
    if (diag_error_reg == 5'b11111)
      om_diag_result <= 'b1;
    else
      om_diag_result <= 0; 
  end
  else
      om_diag_result <= 0;
end  



// count in open state
always @(posedge i_clk or negedge i_rst_n) begin
  if(!i_rst_n) begin
    cnt_open  <= 0;
  end  
  else if(open_flag == 1)begin
    if(cnt_open < CNT_delay)
      cnt_open  <= cnt_open + 1'b1;
    else
      cnt_open  <= cnt_open; 
  end
  else
    cnt_open <= 0;
end

// count in close state
always @(posedge i_clk or negedge i_rst_n) begin
  if(!i_rst_n) begin
    cnt_close  <= 0;
  end  
  else if(close_flag == 1)begin
    if(cnt_close < CNT_delay)
      cnt_close  <= cnt_close + 1'b1;
    else
      cnt_close  <= cnt_close;
  end
  else
    cnt_close <= 0;
end

// count cycle_diag
always @(posedge i_clk or negedge i_rst_n) begin
  if(!i_rst_n) begin
    cnt_diag  <= 0;
  end  
  else if(diag_flag == 1)begin
    if(cnt_diag < diag_cycle_cnt)
      cnt_diag  <= cnt_diag + 1'b1;
    else
      cnt_diag  <= cnt_diag;
  end
  else
      cnt_diag <= 0;
end

always @ (posedge i_clk or negedge i_rst_n) begin
  if(!i_rst_n) begin
    o_test_open     <= 1;
    o_test_close    <= 1;
    state           <= INITIAL;
    diag_state      <= DIAG_com;
    diag_error      <= 0;
    open_flag       <= 0;
    close_flag      <= 0;
    diag_flag       <= 0;
    diag_error_reg  <= 0;
    cnt             <= 0;
    diag_error_temp <= 1'b1;
  end
  else begin
    case (state)
      INITIAL:  begin
                  o_test_open   <= 1;
                  o_test_close  <= 1;                  
                  diag_error  <= 0;
                  open_flag   <= 0;
                  close_flag  <= 0;
                  diag_flag   <= 0;
                  if (im_channel_on == 8'b01)
                    state     <= WAIT_DE;
                  else
                    state     <= INITIAL;
                end  
       WAIT_DE: begin 
                  if( cnt_high == time_dejitter_cnt | cnt_low == time_dejitter_cnt ) begin
                    state      <= DIAG;
                    diag_state <= DIAG_com;
                  end
                  else begin
                    state <= INITIAL;
                  end
                end
          DIAG: begin  
                  case(diag_state)
                     DIAG_com: begin
                                 o_test_open   <= 1;
                                 o_test_close  <= 1;
                                 if(im_diag_on == 8'h01) begin   //diag or not
                              //  if (din_reg_1==2'b01|din_reg_1==2'b10)begin
                                     if(din_reg == 0) begin                     //if input data is low, diag_state>> DIAG_open.
                                       diag_state      <= DIAG_open;
                                       o_test_open       <= 0;
                                       o_test_close      <= 1;
                                       open_flag       <= 1;                    //the start of test open state
                                       diag_error_temp <= 1;
                                     end
                                     else begin 
                                       diag_state      <= DIAG_close;           //if input data is high, diag_state>> DIAG_close.
                                       o_test_open       <= 1;
                                       o_test_close      <= 0;
                                       close_flag      <= 1;                    //the start of test close state
                                       diag_error_temp <= 1;
                                     end
                                   end
                                 else begin
                                   diag_state <= DIAG_com;
                                   state      <= INITIAL;
                                 end
                               end          
                     DIAG_open: begin
                                  open_flag  <= 1;
                                  diag_flag  <= 1;
                                  if(cnt_open >= CNT_delay0) begin               // delay time
                                    o_test_open  <= 1;
                                    o_test_close <= 1;
                                  end
                                  if(cnt_open < CNT_delay)begin
                                    if(din == 1) begin
                                      cnt <= cnt + 1'b1;
                                      if(cnt > 5)
                                      diag_error_temp <= 0;
                                    end
                                    else
                                      cnt <= 0;
                                   end
                                  else if(cnt_open == CNT_delay) begin
                                    diag_state <= DIAG_wait;
                                    open_flag  <= 0;                              //the end of test open state    
                                    diag_error <= diag_error_temp;
                                    cnt        <= 0;
                                  end 
                                end                           
                    DIAG_close: begin
                                  close_flag <= 1;
                                  diag_flag  <= 1;                                //the start of cycle diag
                                  if(cnt_close >= CNT_delay0) begin
                                    o_test_open  <= 1;
                                    o_test_close <= 1;
                                    end
                                  if(cnt_close < CNT_delay)begin
                                    if(din == 0) begin
                                      cnt <= cnt +1;
                                      if(cnt > 5)                                 // continuous 5 times
                                        diag_error_temp <= 0;
                                    end
                                    else
                                      cnt <= 0;
                                  end
                                  else if(cnt_close == CNT_delay) begin
                                    diag_state <= DIAG_wait;
                                    close_flag <= 0;                              //the end of test close state   
                                    diag_error <= diag_error_temp;
                                  end 
                                end  
                     DIAG_wait: begin
                                  if (cnt_diag == diag_cycle_cnt) begin
                                    diag_state      <= DIAG_com; 
                                    state           <= INITIAL;
                                    diag_flag       <= 0;
                                    diag_error_reg  <= {diag_error_reg[3:0], diag_error};
                                  end
                                  else if (cnt_diag < diag_cycle_cnt)begin
                                    if (din_reg_1 == 2'b10) begin                  // input high change to low 
                                      diag_state     <= DIAG_com; 
                                      state          <= DIAG;
                                      diag_flag      <= 0;
                                      o_test_open      <= 0;
                                      o_test_close     <= 1;
                                      open_flag      <= 0;
                                      diag_error_reg <= {diag_error_reg[3:0], diag_error};
                                    end
                                    else if (din_reg_1 == 2'b01) begin             // input low change to high 
                                      diag_state     <= DIAG_com;
                                      state          <= DIAG;
                                      o_test_open      <= 1;
                                      o_test_close     <= 0;
                                      close_flag     <= 0;
                                      diag_flag      <= 0;
                                      diag_error_reg <= {diag_error_reg[3:0], diag_error};
                                    end
                                    else
                                      diag_state <= DIAG_wait;  
                                  end
                                end
                       default: diag_state <= DIAG_com;
                  endcase
                end
      default: state <= INITIAL;
    endcase
  end
end 
 
assign test = {diag_error,o_test_close,o_test_open,din_reg,i_din};                 // test
 
endmodule



