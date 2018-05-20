module data_read
(
    //------------------------------------------
    //--  Global Reset, active low
    //------------------------------------------
    input               rst_n                   ,
    //------------------------------------------
    //--  Global clocks
    //------------------------------------------
    input               sys_clk                 ,
    //------------------------------------------
    //--  tx_ctrl interface
    //------------------------------------------
    input               start_read              ,
    input      [10:0]   row                     ,
    input      [1:0]    picture_choose          ,
    output reg          read_done               ,
    input      [31:0]   pkbl                    ,
    input      [15:0]   pkpck                   ,
    //------------------------------------------
    //--  SRAM interface
    //------------------------------------------
    output reg          rd_req                  ,
    output reg [23:0]   sram_raddr              ,
       
    //------------------------------------------
    //--  fifo interface
    //------------------------------------------
    output reg          rd_en                   ,
    input               empty                   ,
    input      [31:0]   data_in                 ,  
    //------------------------------------------
    //--  gtx interface
    //------------------------------------------ 
    output reg [15:0]   tx_data                 ,
    output reg [1:0]    tx_control              , 
    output wire[10:0]   data_cnt                ,
//    inout   [35:0]      control                 ,	 
    //------------------------------------------
    //--  starparam interface
    //------------------------------------------
    output reg          starparam_ram_rd        ,
    output reg [11:0]   starparam_ram_addr      ,
    input      [15:0]   starparam_ram_data      
);

//parameter define
parameter FSM_IDLE           = 4'd0       ;
parameter FSM_GETADDR        = 4'd1       ;
parameter FSM_WAITRD         = 4'd2       ;
parameter FSM_GETDATA        = 4'd3       ;
parameter FSM_WRDATA         = 4'd4       ;
parameter FSM_DONE           = 4'd5       ;
parameter FSM_WRDATA1        = 4'd6       ;
                                          
parameter endcount           = 12'd1036   ;
parameter endcount1          = 13'd3118   ;

parameter second             = 24'd4194304;

//function
function [23:0]first_addr;
  input [10:0] row;
  input [1:0]  picture_choose;
  begin
     if(picture_choose == 2'd2)
       first_addr = second+{2'd0,row,11'd0};
     else
       first_addr = {2'd0,row,11'd0};
  end
endfunction

//reg or net
reg         [3:0]   fsm_current_state  ;
reg         [3:0]   fsm_next_state     ;
reg         [10:0]  count              ;
reg         [12:0]  count1             ;
reg         [1:0]   rden               ;   
reg         [15:0]  tx_data_h          ;                   //high 8 bits register
reg         [1:0]   fifo_rden          ;
reg         [15:0]  rdata              ;
reg         [15:0]  rdata1             ;
reg                 data_valid         ;
reg                 data_valid1        ;
reg                 check_en           ;
reg                 check_init         ;

wire        [31:0]  check_in           ;           

assign data_cnt = count;

//current state
always@(posedge sys_clk or negedge rst_n)
  begin
    if(!rst_n)
      fsm_current_state <= 4'd0;
    else
      fsm_current_state <= fsm_next_state;
  end 
  
//next state
always@(*)
  begin
    case(fsm_current_state)
      FSM_IDLE:
        begin
          if(start_read)
            fsm_next_state = FSM_GETADDR;
          else
            fsm_next_state = FSM_IDLE;
        end
        
      FSM_GETADDR:
        begin
          if(picture_choose == 2'd3)
            fsm_next_state = FSM_WRDATA1;
          else
            fsm_next_state = FSM_WAITRD;
        end
      
      FSM_WAITRD:
        begin
          if(!empty)
            fsm_next_state = FSM_GETDATA;
          else
            fsm_next_state = FSM_WAITRD;
        end
      
      FSM_GETDATA:
        begin
          if(count == endcount)
            fsm_next_state = FSM_DONE;
          else if(count == 0 && fifo_rden[0])
            fsm_next_state = FSM_WRDATA;
          else if(count >0 && count < endcount)
            fsm_next_state = FSM_WRDATA;
          else
            fsm_next_state = FSM_GETDATA;
        end
      
      FSM_WRDATA:
        begin
          fsm_next_state = FSM_GETDATA;
        end
        
        
      FSM_WRDATA1:
        begin
          if(count1 == endcount1)
            fsm_next_state = FSM_DONE;
          else
            fsm_next_state = FSM_WRDATA1;
        end
        
      FSM_DONE:
        begin
          fsm_next_state = FSM_IDLE;
        end
        
      default:; 
    endcase    
  end

//read_done
always@(posedge sys_clk or negedge rst_n)
  begin
    if(!rst_n)
      read_done <= 1'b0;
    else if(fsm_current_state == FSM_DONE)
      read_done <= 1'b1;
    else if(fsm_current_state == FSM_IDLE)
      read_done <= 1'b0;
  end
  
  
//starparam_ram_rd
always@(posedge sys_clk or negedge rst_n)
  begin
    if(!rst_n)
      starparam_ram_rd <= 1'b0;
    else if(fsm_current_state == FSM_GETADDR && fsm_next_state == FSM_WRDATA1)
      starparam_ram_rd <= 1'b1;
    else if(fsm_current_state == FSM_WRDATA1 && count1 == 3116)
      starparam_ram_rd <= 1'b0;
  end
  
//rden
always@(posedge sys_clk or negedge rst_n)
  begin
    if(!rst_n)
      rden <= 2'd0;
    else
      rden <= {rden[0],starparam_ram_rd};
  end
//fifo_rden
always@(posedge sys_clk or negedge rst_n)
  begin
    if(!rst_n)
      fifo_rden <= 2'd0;
    else
      fifo_rden <= {fifo_rden[0],rd_en};
  end

//rd_en
always@(posedge sys_clk or negedge rst_n)
  begin
    if(!rst_n)
      rd_en <= 1'b0;
    else if(fsm_current_state == FSM_WAITRD && fsm_next_state == FSM_GETDATA)
      rd_en <= 1'b1;
    else if(fsm_current_state == FSM_GETDATA && fsm_next_state == FSM_GETDATA)
      rd_en <= 1'b0;
    else if(fsm_current_state == FSM_GETDATA && fsm_next_state == FSM_WRDATA)
      rd_en <= 1'b1;
    else if(fsm_current_state == FSM_WRDATA)
      rd_en <= 1'b0;
  end
  
//starparam_ram_addr
always@(posedge sys_clk or negedge rst_n)
  begin
    if(!rst_n)
      starparam_ram_addr <= 12'd0;
    else if(fsm_current_state == FSM_GETADDR && fsm_next_state == FSM_WRDATA1)
      starparam_ram_addr <= 12'd0;
    else if(fsm_current_state == FSM_WRDATA1 && fsm_next_state == FSM_WRDATA1)
      starparam_ram_addr <= starparam_ram_addr + 1'b1;
    else if(fsm_current_state == FSM_WRDATA1 && fsm_next_state == FSM_DONE)
      starparam_ram_addr <= 12'd0;
  end
  

//count
always@(posedge sys_clk or negedge rst_n)
  begin
    if(!rst_n)
      count <= 11'd0;
    else if(fsm_current_state == FSM_WRDATA && fsm_next_state == FSM_GETDATA)
      count <= count + 1'b1;
    else if(fsm_current_state == FSM_DONE)
      count <= 11'd0;
  end
  
//count1
always@(posedge sys_clk or negedge rst_n)
  begin
    if(!rst_n)
      count1 <= 13'd0;
    else if(fsm_current_state == FSM_WRDATA1 && rden[0])
      count1 <= count1 + 1'b1;
    else if(fsm_current_state == FSM_WRDATA1 && fsm_next_state == FSM_DONE)
      count1 <= 13'd0;
  end

//tx_data_h
always@(posedge sys_clk or negedge rst_n)
  begin
    if(!rst_n)
      tx_data_h <= 16'd0;
    else if(fsm_current_state == FSM_GETDATA && fsm_next_state == FSM_WRDATA)
      tx_data_h <= data_in[31:16];
    else if(fsm_current_state == FSM_GETDATA && fsm_next_state == FSM_DONE)
      tx_data_h <= 16'd0;
  end
  
  
//rdata
always@(posedge sys_clk or negedge rst_n)
  begin
    if(!rst_n)
      rdata <= 16'd0;
    else if(fsm_current_state == FSM_GETDATA && (count < 11'd2 || (count > 11'd3 && count < 11'd1034)))
      rdata <= data_in[15:0];
    else if(fsm_current_state == FSM_WRDATA && (count < 11'd2 || (count > 11'd3 && count < 11'd1034)))
      rdata <= tx_data_h;
    else if(fsm_current_state == FSM_GETDATA && count ==11'd2)
      rdata <= pkbl[15:0];
    else if(fsm_current_state == FSM_WRDATA && count ==11'd2)
      rdata <= pkbl[31:16];
    else if(fsm_current_state == FSM_GETDATA && count ==11'd3)
      rdata <= pkpck;
    else if(fsm_current_state == FSM_WRDATA && count ==11'd3)
      rdata <= 16'h0102;
    else if(fsm_current_state == FSM_GETDATA && count ==11'd1034)
      rdata <= 16'd0;
  end

//rdata1
always@(posedge sys_clk or negedge rst_n)
  begin
    if(!rst_n)
      rdata1 <= 16'd0;
    else 
      rdata1 <= rdata;
  end

//data_valid
always@(posedge sys_clk or negedge rst_n)
  begin
    if(!rst_n)
      data_valid <= 1'b0;
    else if(fsm_current_state == FSM_GETDATA && fsm_next_state == FSM_WRDATA && count < 11'd1034)
      data_valid <= 1'b1;
    else if(count == 11'd1034)
      data_valid <= 1'b0;
  end

//data_valid1
always@(posedge sys_clk or negedge rst_n)
  begin
    if(!rst_n)
      data_valid1 <= 1'd0;
    else 
      data_valid1 <= data_valid;    
  end

//tx_data
always@(posedge sys_clk or negedge rst_n)
  begin
    if(!rst_n)
      tx_data <= 16'd0 ;
    else if(data_valid1)
      tx_data <= rdata1;
    else if(fsm_current_state == FSM_GETDATA && count == 11'd1035)
      tx_data <= check_in[31:16];
    else if(fsm_current_state == FSM_WRDATA && count == 11'd1035)
      tx_data <= check_in[15:0];
    else if(fsm_current_state == FSM_GETDATA && count == 11'd1036)
      tx_data <= 16'd0 ;
    else if(fsm_current_state == FSM_WRDATA1 && rden[0])
      tx_data <= starparam_ram_data;
    else if(fsm_current_state == FSM_DONE)
      tx_data <= 16'd0 ;
  end

//tx_control
always@(posedge sys_clk or negedge rst_n)
  begin
    if(!rst_n)
      tx_control <= 2'd1;
    else if(data_valid1)
      tx_control <= 2'd0;
    else if(rden[0])
      tx_control <= 2'd0;
    else if(fsm_current_state == FSM_DONE)
      tx_control <= 2'd1;
    else if(fsm_current_state == FSM_GETDATA && count == 11'd1036)
      tx_control <= 2'd1;
  end

//rd_req
always@(posedge sys_clk or negedge rst_n)
  begin
    if(!rst_n)
      rd_req <= 1'b0;
    else if(fsm_current_state == FSM_GETADDR && fsm_next_state == FSM_WAITRD)
      rd_req <= 1'b1;
    else if(fsm_current_state == FSM_WAITRD)
      rd_req <= 1'b0; 
  end  
  
//sram_raddr
always@(posedge sys_clk or negedge rst_n)
  begin
    if(!rst_n)
      sram_raddr <= 24'd0;
    else if(fsm_current_state == FSM_GETADDR && fsm_next_state == FSM_WAITRD)
      sram_raddr <= first_addr(row,picture_choose);
    else if(fsm_current_state == FSM_WAITRD && fsm_next_state == FSM_GETDATA)
      sram_raddr <= 24'd0; 
  end
  
//check_init
always@(posedge sys_clk or negedge rst_n)
  begin
    if(!rst_n)
      check_init <= 1'b0;
    else if(fsm_current_state == FSM_DONE)
      check_init <= 1'b1;
    else if(fsm_current_state == FSM_IDLE)
      check_init <= 1'b0;
  end
  
//check_en
always@(posedge sys_clk or negedge rst_n)
  begin
    if(!rst_n)
      check_en <= 1'b0;
    else if(fsm_current_state == FSM_GETDATA && (count >=11'd2 && count < 11'd1034))
      check_en <= 1'b1;
    else if(fsm_current_state == FSM_GETDATA && count ==11'd1034)
      check_en <= 1'b0;
  end

 
//wire [255:0]  trig0;
//wire [255:0]  trig1;
//wire [255:0]  trig2;
//wire [255:0]  trig3;
//
//assign trig0[3:0]  = fsm_current_state;
//assign trig0[7:4]  = fsm_next_state;
//assign trig0[8]    = empty;
//assign trig0[9]    = start_read;
//assign trig0[11:10]= picture_choose;
//assign trig0[12]   = fifo_rden;
//assign trig0[28:13]= tx_data;
//assign trig0[30:29]= tx_control;
//assign trig0[46:31]= rdata;

//ILA1 ila
//(
// .CONTROL(control),
// .CLK(sys_clk),
// .TRIG0(trig0),
// .TRIG1(TRIG1),
// .TRIG2(TRIG2),
// .TRIG3(TRIG3)
//);

check_sum check_sum(.clk(sys_clk)          ,
	                  .rst_n(rst_n)          ,
	                  .init(check_init)      ,
	                  .en(check_en)          ,
	                  .data(rdata)           ,
	                  .data_out(check_in)
                   );  
  
endmodule


      
      