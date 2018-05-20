`timescale 1ns/100ps

module flash_axi_tb(
    input  wire         sys_clk        ,
    input  wire         glbl_rst_n     ,

    input  wire         flash_rden     ,
    input  wire         flash_wren     ,
    input  wire         flash_era      ,
    input  wire [24:00] flash_addr     ,
    input  wire [24:00] flash_length   ,
    output wire         flash_ready    ,
    input  wire [07:00] flash_wr_data  ,
    input  wire         flash_wr_valid ,
    input  wire         flash_wr_last  ,
    output wire [07:00] flash_rd_data  ,
    output reg          flash_rd_valid ,
    output reg          flash_rd_last  ,
    
    output reg          status_reg_en  ,
    output reg  [07:00] status_reg
);

parameter ERASE_TIME  = 33'd5;//0_0000_0000;//50MHz delay 100s

parameter SPI_WR_EN  = 8'h06;//写使能
parameter SPI_RD_SR  = 8'h05;//读寄存器
parameter SPI_WDATA  = 8'h02;//写数据
parameter SPI_CH_ERA = 8'h60;//片擦除
parameter SPI_RDATA  = 8'h03;//读数据

parameter FSM_IDLE    = 4'h0;//IDLE state
parameter FSM_RD_CMD  = 4'h1;//READ CMD
parameter FSM_WR_CMD  = 4'h2;//
parameter FSM_RD_REG  = 4'h3;//
parameter FSM_WR_REG  = 4'h4;//
parameter FSM_ERASE   = 4'h5;//
parameter FSM_WR_ADDR = 4'h6;//
parameter FSM_RD_DATA = 4'h7;//
parameter FSM_WR_DATA = 4'h8;//
parameter FSM_WR_WAIT = 4'h9;//

//============================================================================//
reg          r_fsm_idle_en    ;
reg  [07:00] r_data_cmd       ;
reg  [28:00] r_data_len       ;
reg  [23:00] r_data_addr      ;
reg  [24:00] r_flash_length   ;

reg  [07:00] r_flash_wr_data  ;
reg          r_flash_wr_valid ;

reg          r_txfifo_rd      ;
reg  [07:00] r_txfifo_rdata   ;
wire [07:00] w_txfifo_rdata   ;
wire         w_txfifo_empty   ;

reg  [04:00] r_cmd_cnt        ;
reg  [05:00] r_reg_cnt        ;
reg  [32:00] r_erase_cnt      ;
reg  [28:00] r_rdata_cnt      ;
reg  [28:00] r_wdata_cnt      ;
reg  [24:00] r_flash_rd_cnt   ;

reg  [03:00] fsm_curr         ;

reg          a_wen            ;
reg  [22:00] a_addr           ;
reg  [07:00] a_din            ;
wire [07:00] a_dout           ;

//============================================================================//
assign flash_ready = (flash_wren || flash_rden || flash_era || r_fsm_idle_en) ? 1'b0 :((fsm_curr == FSM_IDLE) ? 1'b1 : 1'b0);

//判读flash读、写、擦除状态机是否开始工作
always @ (posedge sys_clk)
begin
  if(!glbl_rst_n)
    r_fsm_idle_en <= 1'b0;
  else
    if(flash_wren || flash_rden || flash_era)
      r_fsm_idle_en <= 1'b1;
    else
      r_fsm_idle_en <= 1'b0;
end

//将数据长度、地址信息所存
always @ (posedge sys_clk)
begin
  if(!glbl_rst_n)
    r_data_cmd <= 'd0;
  else
    begin
      if((flash_addr[24] == 1'b1) && (flash_wren == 1'b1))
        r_data_cmd <= SPI_WR_EN;
      else if((flash_addr[24] == 1'b1) && (flash_rden == 1'b1))
        r_data_cmd <= SPI_RD_SR;
      else if(flash_wren == 1'b1)
        r_data_cmd <= SPI_WDATA;
      else if(flash_rden == 1'b1)
        r_data_cmd <= SPI_RDATA;
      else if(flash_era == 1'b1)
        r_data_cmd <= SPI_CH_ERA;
      else
        r_data_cmd <= r_data_cmd;
    end
end

//将数据长度、地址信息所存
always @ (posedge sys_clk)
begin
  if(!glbl_rst_n)
    begin
      r_data_len <= 29'd0;
      r_data_addr <= 24'd0;
      r_flash_length <= 25'd0;
    end
  else
    begin
      if(flash_wren || flash_rden)
        begin
          r_data_len <= {flash_length,4'd0};
          r_data_addr <= flash_addr;
          r_flash_length <= flash_length;
        end
      else
        begin
          r_data_len <= r_data_len;
          r_data_addr <= r_data_addr;
          r_flash_length <= r_flash_length;
        end
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
FIFO_4096_8_FWFT u_FIFO_4096_8_FWFT(
    .RESET      (!glbl_rst_n      ),
    .CLK        (sys_clk          ),
    .WE         (r_flash_wr_valid ),
    .DATA       (r_flash_wr_data  ),
    .FULL       (txfifo_afull     ),
    .RE         (r_txfifo_rd      ),
    .Q          (w_txfifo_rdata   ),
    .EMPTY      (w_txfifo_empty   )
);

//地址发生完成或者，上次读出的8bit数据写完则继续读取数据
always @ (posedge sys_clk)
begin
  if(!glbl_rst_n)
    begin
      r_txfifo_rd <= 'b0;
      r_txfifo_rdata <= 'd0;
    end
  else
    begin
      if((fsm_curr == FSM_WR_DATA) && (r_wdata_cnt[3:0] == 4'd2))
        r_txfifo_rd <= ~w_txfifo_empty;
      else
        r_txfifo_rd <= 'b0;
      if(r_txfifo_rd)
        r_txfifo_rdata <= w_txfifo_rdata;
      else
        r_txfifo_rdata <= r_txfifo_rdata;
    end
end

//写命令参数计数
always @ (posedge sys_clk)
begin
  if(!glbl_rst_n)
    begin
      r_cmd_cnt <= 'd0;
    end
  else
    begin
      if(fsm_curr == FSM_WR_CMD)
        r_cmd_cnt <= r_cmd_cnt + 1'b1;
      else
        r_cmd_cnt <= 'd0;
    end
end

//读写寄存器参数计数
always @ (posedge sys_clk)
begin
  if(!glbl_rst_n)
    begin
      r_reg_cnt <= 'd0;
    end
  else
    begin
      if((fsm_curr == FSM_RD_REG) || (fsm_curr == FSM_WR_ADDR))
        r_reg_cnt <= r_reg_cnt + 1'b1;
      else
        r_reg_cnt <= 'd0;
    end
end

//擦除延时计数
always @ (posedge sys_clk)
begin
  if(!glbl_rst_n)
    begin
      r_erase_cnt <= 'd0;
    end
  else
    begin
      if(fsm_curr == FSM_ERASE)
        r_erase_cnt <= r_erase_cnt + 1'b1;
      else
        r_erase_cnt <= 'd0;
    end
end

//读数据计数
always @ (posedge sys_clk)
begin
  if(!glbl_rst_n)
    begin
      r_rdata_cnt <= 'd0;
    end
  else
    begin
      if(fsm_curr == FSM_RD_DATA)
        r_rdata_cnt <= r_rdata_cnt + 1'b1;
      else
        r_rdata_cnt <= 'd0;
    end
end

//写数据计数，包括最大256字节计数及发生全部数据计数
always @ (posedge sys_clk)
begin
  if(!glbl_rst_n)
    begin
      r_wdata_cnt <= 'd0;
    end
  else
    begin
      if(fsm_curr == FSM_WR_DATA)
        r_wdata_cnt <= r_wdata_cnt + 1'b1;
      else
        r_wdata_cnt <= 'd0;
    end
end

//============================================================================//
//状态机跳转
always @ (posedge sys_clk)
begin
  if(!glbl_rst_n)
    begin
      fsm_curr <= FSM_IDLE;
    end
  else
    begin
      case(fsm_curr)
        FSM_IDLE:
          begin
            if(r_fsm_idle_en == 1'b1)
              fsm_curr <= FSM_RD_CMD;
            else
              fsm_curr <= FSM_IDLE;
          end
        FSM_RD_CMD:
          begin
            fsm_curr <= FSM_WR_CMD;
          end
        FSM_WR_CMD:
          begin
            if(r_cmd_cnt == 5'd17)
              begin
                if(r_data_cmd == SPI_RD_SR)
                  fsm_curr <= FSM_RD_REG;
                else if(r_data_cmd == SPI_CH_ERA)
                  fsm_curr <= FSM_ERASE;
                else if((r_data_cmd == SPI_WDATA) || (r_data_cmd == SPI_RDATA))
                  fsm_curr <= FSM_WR_ADDR;
                else
                  fsm_curr <= FSM_IDLE;
              end
            else
              begin
                fsm_curr <= FSM_WR_CMD;
              end
          end
        FSM_RD_REG:
          begin
            if(r_reg_cnt == 6'd15)
              fsm_curr <= FSM_IDLE;
            else
              fsm_curr <= FSM_RD_REG;
          end
        FSM_ERASE:
          begin
            if(r_erase_cnt == ERASE_TIME)
              fsm_curr <= FSM_IDLE;
            else
              fsm_curr <= FSM_ERASE;
          end
        FSM_WR_ADDR:
          begin
            if(r_reg_cnt == 6'd47)
              begin
                if(r_data_cmd == SPI_WDATA)
                  fsm_curr <= FSM_WR_DATA;
                else if(r_data_cmd == SPI_RDATA)
                  fsm_curr <= FSM_RD_DATA;
                else
                  fsm_curr <= FSM_IDLE;
              end
            else
              fsm_curr <= FSM_WR_ADDR;
          end
        FSM_RD_DATA:
          begin
            if(r_rdata_cnt == r_data_len - 1'b1)
              fsm_curr <= FSM_IDLE;
            else
              fsm_curr <= FSM_RD_DATA;
          end
        FSM_WR_DATA:
          begin
            if(r_wdata_cnt == r_data_len - 1'b1)
              fsm_curr <= FSM_IDLE;
            else
              fsm_curr <= FSM_WR_DATA;
          end
        default: fsm_curr <= FSM_IDLE;
      endcase
    end
end

//状态机跳转
always @ (posedge sys_clk)
begin
  if(!glbl_rst_n)
    begin
      a_wen  <= 1'b0;
      a_addr <= 23'd0;
      a_din  <= 8'd0;
      flash_rd_valid <= 'b0;
    end
  else
    begin
      case(fsm_curr)
        FSM_ERASE:
          begin
            a_wen  <= 1'b1;
            a_addr <= a_addr + 1'b1;
            a_din  <= 8'd0;
            flash_rd_valid <= 'b0;
          end
        FSM_WR_ADDR:
          begin
            a_wen  <= 1'b0;
            a_addr <= r_data_addr[22:0] - 1'b1;
            a_din  <= 8'd0;
            flash_rd_valid <= 'b0;
          end
        FSM_RD_DATA:
          begin
            a_wen  <= 1'b0;
            if(r_rdata_cnt[3:0] == 4'd14)
              a_addr <= a_addr + 1'b1;
            else
              a_addr <= a_addr;
            if(r_rdata_cnt[3:0] == 4'd15)
              flash_rd_valid <= 'b1;
            else
              flash_rd_valid <= 'b0;
            a_din  <= 8'd0;
          end
        FSM_WR_DATA:
          begin
            a_wen  <= r_txfifo_rd;
            if(r_txfifo_rd)
              a_addr <= a_addr + 1'b1;
            else
              a_addr <= a_addr;
            a_din  <= w_txfifo_rdata;
            flash_rd_valid <= 'b0;
          end
        default:
          begin
            a_wen  <= 1'b0;
            a_addr <= 23'd0;
            a_din  <= 8'd0;
            flash_rd_valid <= 'b0;
          end
      endcase
    end
end

ram_hdl u_ram_hdl (
    .clk       (sys_clk   ),
    .a_wen     (a_wen     ),
    .a_addr    (a_addr    ),
    .a_din     (a_din     ),
    .a_dout    (a_dout    )
);

assign flash_rd_data = a_dout;

//读数据
always @ (posedge sys_clk)
begin
  if(!glbl_rst_n)
    begin
      flash_rd_last <= 'b0;
    end
  else
    begin
      if(fsm_curr == FSM_RD_DATA)
        begin
          if((r_rdata_cnt[3:0] == 4'd15) && (r_flash_rd_cnt == r_flash_length - 1'b1))
            flash_rd_last <= 'b1;
          else
            flash_rd_last <= 'b0;
        end
      else
        begin
          flash_rd_last <= 'b0;
        end
    end
end

always @ (posedge sys_clk)
begin
  if(!glbl_rst_n)
    begin
      r_flash_rd_cnt <= 'd0;
    end
  else
    begin
      if(r_flash_rd_cnt == r_flash_length)
        r_flash_rd_cnt <= 'd0;
      else if(flash_rd_valid)
        r_flash_rd_cnt <= r_flash_rd_cnt + 1'b1;
      else
        r_flash_rd_cnt <= r_flash_rd_cnt;
    end
end

endmodule
