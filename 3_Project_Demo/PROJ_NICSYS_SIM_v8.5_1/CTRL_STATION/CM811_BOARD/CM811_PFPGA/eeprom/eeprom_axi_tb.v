`timescale 1ns/100ps

module eeprom_axi_tb(
    input  wire         sys_clk        ,
    input  wire         glbl_rst_n     ,

    input  wire         flash_rden     ,
    input  wire         flash_wren     ,
    input  wire [16:00] flash_addr     ,
    input  wire [16:00] flash_length   ,
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

parameter SPI_WREN  = 8'h06;
parameter SPI_WRDI  = 8'h04;
parameter SPI_RDSR  = 8'h05;
parameter SPI_WRSR  = 8'h01;
parameter SPI_READ  = 8'h03;
parameter SPI_WRITE = 8'h02;

parameter FSM_IDLE    = 3'h0;//IDLE state
parameter FSM_RD_CMD  = 3'h1;//READ CMD
parameter FSM_WR_CMD  = 3'h2;//
parameter FSM_RD_REG  = 3'h3;//
parameter FSM_WR_REG  = 3'h4;//
parameter FSM_WR_ADDR = 3'h5;//
parameter FSM_RD_DATA = 3'h6;//
parameter FSM_WR_DATA = 3'h7;//

//============================================================================//

reg          r_fsm_idle_en    ;
reg  [07:00] r_data_cmd       ;
reg  [20:00] r_data_len       ;
reg  [15:00] r_data_addr      ;
reg  [16:00] r_flash_length   ;

reg  [07:00] r_flash_wr_data  ;
reg          r_flash_wr_valid ;
reg          r_txfifo_rd      ;
reg  [07:00] r_txfifo_rdata   ;
wire [07:00] w_txfifo_rdata   ;
wire         w_txfifo_empty   ;

reg  [04:00] r_cmd_cnt        ;
reg  [04:00] r_reg_cnt        ;
reg  [19:00] r_data_cnt       ;
reg  [16:00] r_flash_rd_cnt   ;

reg  [02:00] fsm_curr         ;
reg  [02:00] fsm_next         ;

reg          a_wen            ;
reg  [15:00] a_addr           ;
reg  [07:00] a_din            ;
wire [07:00] a_dout           ;

//============================================================================//
assign flash_ready = (flash_wren || flash_rden || r_fsm_idle_en) ? 1'b0 :((fsm_curr == FSM_IDLE) ? 1'b1 : 1'b0);

//判读flash读、写、擦除状态机是否开始工作
always @ (posedge sys_clk)
begin
  if(!glbl_rst_n)
    r_fsm_idle_en <= 1'b0;
  else
    if(flash_wren || flash_rden)
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
      if((flash_addr[16] == 1'b1) && (flash_wren == 1'b1))
        r_data_cmd <= SPI_WREN;
      else if((flash_addr[16] == 1'b1) && (flash_rden == 1'b1))
        r_data_cmd <= SPI_RDSR;
      else if(flash_wren == 1'b1)
        r_data_cmd <= SPI_WRITE;
      else if(flash_rden == 1'b1)
        r_data_cmd <= SPI_READ;
      else
        r_data_cmd <= r_data_cmd;
    end
end

//将数据长度、地址信息所存
always @ (posedge sys_clk)
begin
  if(!glbl_rst_n)
    begin
      r_data_len <= 21'd0;
      r_data_addr <= 16'd0;
      r_flash_length <= 17'd0;
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

//地址发生完成或者，上次读出的8bit数据写完则继续读取数据
always @ (posedge sys_clk)
begin
  if(!glbl_rst_n)
    begin
      r_txfifo_rd <= 1'b0;
      r_txfifo_rdata <= 8'd0;
    end
  else
    begin
      if((fsm_curr == FSM_WR_DATA) && (r_data_cnt[3:0] == 4'd5) && (r_data_cnt != r_data_len - 2'd3))
        r_txfifo_rd <= ~w_txfifo_empty;
      else
        r_txfifo_rd <= 1'b0;
      if(r_txfifo_rd)
        r_txfifo_rdata <= w_txfifo_rdata;
      else
        r_txfifo_rdata <= r_txfifo_rdata;
    end
end
///////////////////////////////////////////////////////////////
//写命令参数计数
always @ (posedge sys_clk)
begin
  if(!glbl_rst_n)
    begin
      r_cmd_cnt <= 5'd0;
    end
  else
    begin
      if(fsm_curr == FSM_WR_CMD)
        r_cmd_cnt <= r_cmd_cnt + 1'b1;
      else
        r_cmd_cnt <= 5'd0;
    end
end

//读写寄存器参数计数
always @ (posedge sys_clk)
begin
  if(!glbl_rst_n)
    begin
      r_reg_cnt <= 5'd0;
    end
  else
    begin
      if((fsm_curr == FSM_RD_REG) || (fsm_curr == FSM_WR_ADDR))
        r_reg_cnt <= r_reg_cnt + 1'b1;
      else
        r_reg_cnt <= 5'd0;
    end
end

//读、写数据计数
always @ (posedge sys_clk)
begin
  if(!glbl_rst_n)
    begin
      r_data_cnt <= 20'd0;
    end
  else
    begin
      if((fsm_curr == FSM_RD_DATA) || (fsm_curr == FSM_WR_DATA))
        r_data_cnt <= r_data_cnt + 1'b1;
      else
        r_data_cnt <= 20'd0;
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
          fsm_next = FSM_RD_CMD;
        else
          fsm_next = FSM_IDLE;
      end
    FSM_RD_CMD:
      begin
        fsm_next = FSM_WR_CMD;
      end
    FSM_WR_CMD:
      begin
        if(r_cmd_cnt == 5'd17)
          begin
            if(r_data_cmd == SPI_RDSR)
              fsm_next = FSM_RD_REG;
            else if((r_data_cmd == SPI_READ) || (r_data_cmd == SPI_WRITE))
              fsm_next = FSM_WR_ADDR;
            else
              fsm_next = FSM_IDLE;
          end
        else
          begin
            fsm_next = FSM_WR_CMD;
          end
      end
    FSM_RD_REG:
      begin
        if(r_reg_cnt == 5'd15)
          fsm_next = FSM_IDLE;
        else
          fsm_next = FSM_RD_REG;
      end
    FSM_WR_ADDR:
      begin
        if(r_reg_cnt == 5'd31)
          begin
            if(r_data_cmd == SPI_WRITE)
              fsm_next = FSM_WR_DATA;
            else if(r_data_cmd == SPI_READ)
              fsm_next = FSM_RD_DATA;
            else
              fsm_next = FSM_IDLE;
          end
        else
          fsm_next = FSM_WR_ADDR;
      end
    FSM_RD_DATA:
      begin
        if(r_data_cnt == r_data_len - 1'b1)
          fsm_next = FSM_IDLE;
        else
          fsm_next = FSM_RD_DATA;
      end
    FSM_WR_DATA:
      begin
        if(r_data_cnt == r_data_len - 1'b1)
          fsm_next = FSM_IDLE;
        else
          fsm_next = FSM_WR_DATA;
      end
    default: fsm_next = FSM_IDLE;
  endcase
end

always @ (posedge sys_clk)
begin
  if(!glbl_rst_n)
    begin
      a_wen  <= 1'b0;
      a_addr <= 16'd0;
      a_din  <= 8'd0;
      flash_rd_valid <= 'b0;
    end
  else
    begin
      case(fsm_curr)
        FSM_WR_ADDR:
          begin
            a_wen  <= 1'b0;
            a_addr <= r_data_addr - 1'b1;
            a_din  <= 8'd0;
            flash_rd_valid <= 'b0;
          end
        FSM_RD_DATA:
          begin
            a_wen  <= 1'b0;
            if(r_data_cnt[3:0] == 4'd14)
              a_addr <= a_addr + 1'b1;
            else
              a_addr <= a_addr;
            if(r_data_cnt[3:0] == 4'd15)
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
            a_addr <= 16'd0;
            a_din  <= 8'd0;
            flash_rd_valid <= 'b0;
          end
      endcase
    end
end

ram_eeprom u_ram_eeprom (
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
      flash_rd_last <= 1'b0;
    end
  else
    begin
      if(fsm_curr == FSM_RD_DATA)
        begin
          if((r_data_cnt[3:0] == 4'd15) && (r_flash_rd_cnt == r_flash_length - 1'b1))
            flash_rd_last <= 1'b1;
          else
            flash_rd_last <= 1'b0;
        end
      else
        begin
          flash_rd_last <= 1'b0;
        end
    end
end

always @ (posedge sys_clk)
begin
  if(!glbl_rst_n)
    begin
      r_flash_rd_cnt <= 17'd0;
    end
  else
    begin
      if(r_flash_rd_cnt == r_flash_length)
        r_flash_rd_cnt <= 17'd0;
      else if(flash_rd_valid)
        r_flash_rd_cnt <= r_flash_rd_cnt + 1'b1;
      else
        r_flash_rd_cnt <= r_flash_rd_cnt;
    end
end

endmodule