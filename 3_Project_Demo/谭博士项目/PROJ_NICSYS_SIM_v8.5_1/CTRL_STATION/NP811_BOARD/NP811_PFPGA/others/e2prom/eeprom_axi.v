`timescale 1ns/100ps

module eeprom_axi(
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
    output reg  [07:00] flash_rd_data  ,
    output reg          flash_rd_valid ,
    output reg          flash_rd_last  ,

    output reg          status_reg_en  ,
    output reg  [07:00] status_reg     ,

    output reg          spi_clk        ,
    output reg          spi_cs_n       ,
    input  wire         spi_di         ,
    output reg          spi_do         ,
    output wire         spi_wp_n       ,
    output wire         spi_hold_n
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
      if((fsm_curr == FSM_WR_ADDR) && (r_reg_cnt == 5'd29))
        r_txfifo_rd <= ~w_txfifo_empty;
      else if((fsm_curr == FSM_WR_DATA) && (r_data_cnt[3:0] == 4'd13) && (r_data_cnt != r_data_len - 2'd3))
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
      spi_clk <= 1'b0;
      spi_cs_n <= 1'b1;
      spi_do <= 1'b0;
    end
  else
    begin
      case(fsm_curr)
        FSM_WR_CMD:
          begin
            if((spi_cs_n == 1'b0) && (r_cmd_cnt > 1))
              spi_clk <= ~spi_clk;
            else
              spi_clk <= 1'b0;

            spi_cs_n <= 1'b0;

            case(r_cmd_cnt)
              5'd1:  spi_do <= r_data_cmd[7];
              5'd3:  spi_do <= r_data_cmd[6];
              5'd5:  spi_do <= r_data_cmd[5];
              5'd7:  spi_do <= r_data_cmd[4];
              5'd9:  spi_do <= r_data_cmd[3];
              5'd11: spi_do <= r_data_cmd[2];
              5'd13: spi_do <= r_data_cmd[1];
              5'd15: spi_do <= r_data_cmd[0];
              5'd17:
                begin
                  if((r_data_cmd == SPI_READ) || (r_data_cmd == SPI_WRITE))
                    spi_do <= r_data_addr[15];
                  else
                    spi_do <= 1'b0;
                end
              default: spi_do <= spi_do;
            endcase
          end
        FSM_RD_REG:
          begin
            if(r_reg_cnt == 5'd15)
              spi_clk <= 1'b0;
            else
              spi_clk <= ~spi_clk;

            spi_cs_n <= 1'b0;
            spi_do <= 1'b0;
          end
        FSM_WR_ADDR:
          begin
            if(r_reg_cnt == 5'd31)
              spi_clk <= 1'b0;
            else
              spi_clk <= ~spi_clk;

            spi_cs_n <= 1'b0;

            case(r_reg_cnt)
              5'd1:  spi_do <= r_data_addr[14];
              5'd3:  spi_do <= r_data_addr[13];
              5'd5:  spi_do <= r_data_addr[12];
              5'd7:  spi_do <= r_data_addr[11];
              5'd9:  spi_do <= r_data_addr[10];
              5'd11: spi_do <= r_data_addr[9];
              5'd13: spi_do <= r_data_addr[8];
              5'd15: spi_do <= r_data_addr[7];
              5'd17: spi_do <= r_data_addr[6];
              5'd19: spi_do <= r_data_addr[5];
              5'd21: spi_do <= r_data_addr[4];
              5'd23: spi_do <= r_data_addr[3];
              5'd25: spi_do <= r_data_addr[2];
              5'd27: spi_do <= r_data_addr[1];
              5'd29: spi_do <= r_data_addr[0];
              5'd31:
                begin
                  if(r_data_cmd == SPI_WRITE)
                    spi_do <= r_txfifo_rdata[7];
                  else
                    spi_do <= 1'b0;
                end
              default: spi_do <= spi_do;
            endcase
          end
        FSM_RD_DATA:
          begin
            if(r_data_cnt == r_data_len - 1'b1)
              spi_clk <= 1'b0;
            else
              spi_clk <= ~spi_clk;

            spi_cs_n <= 1'b0;
            spi_do <= 1'b0;
          end
        FSM_WR_DATA:
          begin
            if(r_data_cnt == r_data_len - 1'b1)
              spi_clk <= 1'b0;
            else
              spi_clk <= ~spi_clk;

            spi_cs_n <= 1'b0;

            case(r_data_cnt[3:0])
              4'd1:  spi_do <= r_txfifo_rdata[6];
              4'd3:  spi_do <= r_txfifo_rdata[5];
              4'd5:  spi_do <= r_txfifo_rdata[4];
              4'd7:  spi_do <= r_txfifo_rdata[3];
              4'd9:  spi_do <= r_txfifo_rdata[2];
              4'd11: spi_do <= r_txfifo_rdata[1];
              4'd13: spi_do <= r_txfifo_rdata[0];
              4'd15:
                begin
                  if(r_data_cnt == r_data_len - 1'b1)
                    spi_do <= 1'b0;
                  else
                    spi_do <= r_txfifo_rdata[7];
                end
              default: spi_do <= spi_do;
            endcase
          end
        default:
          begin
            spi_clk <= 1'b0;
            spi_cs_n <= 1'b1;
            spi_do <= 1'b0;
          end
      endcase
    end
end

assign spi_wp_n   = 1'b1;
assign spi_hold_n = 1'b1;

//读取状态寄存器
always @ (posedge sys_clk)
begin
  if(!glbl_rst_n)
    begin
      status_reg <= 8'd0;
      status_reg_en <= 1'b0;
    end
  else
    begin
      if(fsm_curr == FSM_RD_REG)
        begin
          case(r_reg_cnt)
            5'd0:  status_reg <= {spi_di,status_reg[6:0]};
            5'd2:  status_reg <= {status_reg[7],spi_di,status_reg[5:0]};
            5'd4:  status_reg <= {status_reg[7:6],spi_di,status_reg[4:0]};
            5'd6:  status_reg <= {status_reg[7:5],spi_di,status_reg[3:0]};
            5'd8:  status_reg <= {status_reg[7:4],spi_di,status_reg[2:0]};
            5'd10: status_reg <= {status_reg[7:3],spi_di,status_reg[1:0]};
            5'd12: status_reg <= {status_reg[7:2],spi_di,status_reg[0]};
            5'd14: status_reg <= {status_reg[7:1],spi_di};
            default: status_reg <= status_reg;
          endcase
          if(r_reg_cnt == 4'd15)
            status_reg_en <= 1'b1;
          else
            status_reg_en <= 1'b0;
        end
      else
        begin
          status_reg <= status_reg;
          status_reg_en <= 'b0;
        end
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
      if(fsm_curr == FSM_RD_DATA)
        begin
          if(r_data_cnt[3:0] == 4'd15)
            flash_rd_valid <= 1'b1;
          else
            flash_rd_valid <= 1'b0;
          
          if((r_data_cnt[3:0] == 4'd15) && (r_flash_rd_cnt == r_flash_length - 1'b1))
            flash_rd_last <= 1'b1;
          else
            flash_rd_last <= 1'b0;
            
          case(r_data_cnt[3:0])
            4'd0: flash_rd_data <= {spi_di,flash_rd_data[6:0]};
            4'd2: flash_rd_data <= {flash_rd_data[7],spi_di,flash_rd_data[5:0]};
            4'd4: flash_rd_data <= {flash_rd_data[7:6],spi_di,flash_rd_data[4:0]};
            4'd6: flash_rd_data <= {flash_rd_data[7:5],spi_di,flash_rd_data[3:0]};
            4'd8: flash_rd_data <= {flash_rd_data[7:4],spi_di,flash_rd_data[2:0]};
            4'd10:flash_rd_data <= {flash_rd_data[7:3],spi_di,flash_rd_data[1:0]};
            4'd12:flash_rd_data <= {flash_rd_data[7:2],spi_di,flash_rd_data[0]};
            4'd14:flash_rd_data <= {flash_rd_data[7:1],spi_di};
            default: flash_rd_data <= flash_rd_data;
          endcase
        end
      else
        begin
          flash_rd_valid <= 1'b0;
          flash_rd_last <= 1'b0;
          flash_rd_data <= flash_rd_data;
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