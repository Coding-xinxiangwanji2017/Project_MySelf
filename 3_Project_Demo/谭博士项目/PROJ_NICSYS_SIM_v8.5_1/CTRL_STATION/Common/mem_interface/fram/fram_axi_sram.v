`timescale 1ns/100ps

module fram_axi(
    input  wire         sys_clk        ,
    input  wire         glbl_rst_n     ,

    input  wire         flash_wren     ,
    input  wire         flash_rden     ,
    input  wire [15:00] flash_addr     ,
    input  wire [15:00] flash_length   ,
    output wire         flash_ready    ,
    input  wire [07:00] flash_wr_data  ,
    input  wire         flash_wr_valid ,
    input  wire         flash_wr_last  ,
    output reg  [07:00] flash_rd_data  ,
    output reg          flash_rd_valid ,
    output reg          flash_rd_last  ,

    input  wire [15:00] fram_data_in   ,
    output reg  [15:00] fram_data      ,
    output reg          fram_data_en   ,
    output reg  [15:00] fram_addr      ,
    output reg          fram_lbn       ,
    output reg          fram_ubn       ,
    output reg          fram_cen       ,
    output reg          fram_oen       ,
    output reg          fram_wen
);

//============================================================================//
parameter FRAM_WREN = 2'd1;
parameter FRAM_RDEN = 2'd2;

parameter FSM_IDLE  = 4'h0;
parameter FSM_WAIT  = 4'h1;
parameter FSM_CEN   = 4'h2;
parameter FSM_OEN   = 4'h3;
parameter FSM_WEN   = 4'h4;
parameter FSM_DOUT  = 4'h5;
parameter FSM_DIN   = 4'h6;
parameter FSM_HOLD  = 4'h7;
parameter FSM_KEEP  = 4'h8;
parameter FSM_OVER  = 4'h9;

//============================================================================//
reg          r_fsm_idle_en    ;
reg  [01:00] r_data_cmd       ;
reg  [15:00] r_data_len       ;
reg  [15:00] r_data_addr      ;

reg  [07:00] r_flash_wr_data  ;
reg          r_flash_wr_valid ;
reg          r_txfifo_rd      ;
reg  [15:00] r_txfifo_rdata   ;
wire [07:00] w_txfifo_rdata   ;
wire         w_txfifo_empty   ;
reg  [15:00] r_data_cnt       ;

reg  [03:00] fsm_curr         ;
reg  [03:00] fsm_next         ;

reg          r_fram_data_en   ;
//============================================================================//
assign flash_ready = (flash_wren || flash_rden || r_fsm_idle_en) ? 1'b0 :((fsm_curr == FSM_IDLE) ? 1'b1 : 1'b0);

//判读flash读、写状态机是否开始工作
always @ (posedge sys_clk)
begin
  if(!glbl_rst_n)
    begin
      r_fsm_idle_en <= 1'b0;
    end
  else
    begin
      if(flash_wren || flash_rden)
        r_fsm_idle_en <= 1'b1;
      else
        r_fsm_idle_en <= 1'b0;
    end
end

//将数据长度、地址信息所存
always @ (posedge sys_clk)
begin
  if(!glbl_rst_n)
    begin
      r_data_cmd <= 2'd0;
    end
  else
    begin
      if(flash_wren == 1'b1)
        r_data_cmd <= FRAM_WREN;
      else if(flash_rden == 1'b1)
        r_data_cmd <= FRAM_RDEN;
      else
        r_data_cmd <= r_data_cmd;
    end
end

//将数据长度、地址信息所存
always @ (posedge sys_clk)
begin
  if(!glbl_rst_n)
    begin
      r_data_len <= 16'd0;
    end
  else
    begin
      if(flash_wren || flash_rden)
        r_data_len <= flash_length;
      else
        r_data_len <= r_data_len;
    end
end

//将数据长度、地址信息所存
always @ (posedge sys_clk)
begin
  if(!glbl_rst_n)
    begin
      r_data_addr <= 16'd0;
    end
  else
    begin
      if(flash_wren || flash_rden)
        r_data_addr <= flash_addr;
      else if(fsm_curr == FSM_HOLD)
        r_data_addr <= r_data_addr + 1'b1;
      else
        r_data_addr <= r_data_addr;
    end
end

//输入数据缓存一级
always @ (posedge sys_clk)
begin
  if(!glbl_rst_n)
    begin
      r_flash_wr_valid <= 1'b0;
      r_flash_wr_data <= 8'd0;
    end
  else
    begin
      r_flash_wr_valid <= flash_wr_valid;
      r_flash_wr_data <= flash_wr_data;
    end
end

//写入flash的数据经fifo缓存
FIFO_4096_8_FWFT u_tx_fifo(
    .RESET      (!glbl_rst_n      ),
    .CLK        (sys_clk          ),
    .WE         (r_flash_wr_valid ),
    .DATA       (r_flash_wr_data  ),
    .FULL       (txfifo_afull     ),
    .RE         (r_txfifo_rd      ),
    .Q          (w_txfifo_rdata   ),
    .EMPTY      (w_txfifo_empty   )
);

//状态机处于发送状态时进行读数据
always @ (posedge sys_clk)
begin
  if(!glbl_rst_n)
    begin
      r_txfifo_rd <= 1'b0;
      r_txfifo_rdata <= 16'd0;
    end
  else
    begin
      if(fsm_curr == FSM_WEN)
        r_txfifo_rd <= ~w_txfifo_empty;
      else
        r_txfifo_rd <= 1'b0;
      if(r_txfifo_rd)
        r_txfifo_rdata <= {w_txfifo_rdata,w_txfifo_rdata};
      else
        r_txfifo_rdata <= r_txfifo_rdata;
    end
end

//读\写数据计数
always @ (posedge sys_clk)
begin
  if(!glbl_rst_n)
    begin
      r_data_cnt <= 16'd0;
    end
  else
    begin
      if(fsm_curr == FSM_IDLE)
        r_data_cnt <= 16'd0;
      else if(fsm_curr == FSM_HOLD)
        r_data_cnt <= r_data_cnt + 1'b1;
      else
        r_data_cnt <= r_data_cnt;
    end
end

//============================================================================//
//状态机跳转
always @ (posedge sys_clk)
begin
  if(!glbl_rst_n)
    fsm_curr <= FSM_IDLE;
  else
    fsm_curr <= fsm_next;
end

always @ ( * )
begin
  case(fsm_curr)
    FSM_IDLE:
      begin
        if(r_fsm_idle_en == 1'b1)
          fsm_next = FSM_WAIT;
        else
          fsm_next = FSM_IDLE;
      end
    FSM_WAIT:
      begin
        if(((!w_txfifo_empty) && (r_data_cmd == FRAM_WREN)) || (r_data_cmd == FRAM_RDEN))
          fsm_next = FSM_CEN;
        else
          fsm_next = FSM_WAIT;
      end
    FSM_CEN:
      begin
        if(r_data_cmd == FRAM_RDEN)
          fsm_next = FSM_OEN;
        else if(r_data_cmd == FRAM_WREN)
          fsm_next = FSM_WEN;
        else
          fsm_next = FSM_IDLE;
      end
    FSM_OEN:
      begin
        fsm_next = FSM_DIN;
      end
    FSM_DIN:
      begin
        fsm_next = FSM_HOLD;
      end
    FSM_WEN:
      begin
        fsm_next = FSM_DOUT;
      end
    FSM_DOUT:
      begin
        fsm_next = FSM_HOLD;
      end
    FSM_HOLD:
      begin
        fsm_next = FSM_KEEP;
      end
    FSM_KEEP:
      begin
        fsm_next = FSM_OVER;
      end
    FSM_OVER:
      begin
        if(r_data_cnt == r_data_len)
          fsm_next = FSM_IDLE;
        else
          fsm_next = FSM_WAIT;
      end
    default: fsm_next = FSM_IDLE;
  endcase
end

always @ (posedge sys_clk)
begin
  if(!glbl_rst_n)
    begin
      fram_addr <= 16'd0;
      fram_lbn <= 1'b1;
      fram_ubn <= 1'b1;
      fram_cen <= 1'b1;
      fram_oen <= 1'b1;
      fram_wen <= 1'b1;
    end
  else
    begin
      case(fsm_curr)
        FSM_IDLE:
          begin
            fram_addr <= 16'd0;
            fram_lbn <= 1'b1;
            fram_ubn <= 1'b1;
            fram_cen <= 1'b1;
            fram_oen <= 1'b1;
            fram_wen <= 1'b1;
          end
        FSM_CEN:
          begin
            fram_addr <= r_data_addr;
            fram_lbn <= 1'b0;
            fram_ubn <= 1'b0;
            fram_cen <= 1'b0;
            fram_oen <= 1'b1;
            fram_wen <= 1'b1;
          end
        FSM_OEN:
          begin
            fram_addr <= fram_addr;
            fram_lbn <= 1'b0;
            fram_ubn <= 1'b0;
            fram_cen <= 1'b0;
            fram_oen <= 1'b0;
            fram_wen <= 1'b1;
          end
        FSM_WEN:
          begin
            fram_addr <= r_data_addr;
            fram_lbn <= 1'b0;
            fram_ubn <= 1'b0;
            fram_cen <= 1'b0;
            fram_oen <= 1'b1;
            fram_wen <= 1'b0;
          end
        FSM_KEEP:
          begin
            fram_addr <= fram_addr;
            fram_lbn <= 1'b0;
            fram_ubn <= 1'b0;
            fram_cen <= 1'b0;
            fram_oen <= fram_oen;
            fram_wen <= 1'b1;
          end
        FSM_OVER:
          begin
            fram_addr <= 16'd0;
            fram_lbn <= 1'b1;
            fram_ubn <= 1'b1;
            fram_cen <= 1'b1;
            fram_oen <= 1'b1;
            fram_wen <= 1'b1;
          end
        default:
          begin
            fram_addr<= fram_addr;
            fram_lbn <= fram_lbn ;
            fram_ubn <= fram_ubn ;
            fram_cen <= fram_cen ;
            fram_oen <= fram_oen ;
            fram_wen <= fram_wen ;
          end
      endcase
    end
end

always @ (posedge sys_clk)
begin
  if(!glbl_rst_n)
    begin
      r_fram_data_en <= 1'b0;
    end
  else
    begin
      if(fsm_curr == FSM_DOUT)
        r_fram_data_en <= 1'b1;
      else if(fsm_curr == FSM_OVER)
        r_fram_data_en <= 1'b0;
      else
        r_fram_data_en <= r_fram_data_en;
    end
end

//assign fram_data = (r_fram_data_en == 1'b1) ? r_txfifo_rdata : 16'hZZZZ;

always @ (posedge sys_clk)
begin
  if(!glbl_rst_n)
    begin
      fram_data_en <= 1'b0;
      fram_data <= 16'd0;
    end
  else
    begin
      fram_data_en <= r_fram_data_en;
      if(r_fram_data_en)
        fram_data <= r_txfifo_rdata;
      else
        fram_data <= 16'd0;
    end
end

//读数据
always @ (posedge sys_clk)
begin
  if(!glbl_rst_n)
    begin
      flash_rd_valid <= 1'b0;
      flash_rd_last <= 1'b0;
      flash_rd_data <= 8'd0;
    end
  else
    begin
      if((fsm_curr == FSM_KEEP) && (r_data_cmd == FRAM_RDEN))
        begin
          flash_rd_valid <= 1'b1;
          flash_rd_data <= fram_data_in[7:0];
          
          if(r_data_cnt == r_data_len)
            flash_rd_last <= 1'b1;
          else
            flash_rd_last <= 1'b0;
        end
      else
        begin
          flash_rd_valid <= 1'b0;
          flash_rd_last <= 1'b0;
          flash_rd_data <= flash_rd_data;
        end
    end
end

endmodule

