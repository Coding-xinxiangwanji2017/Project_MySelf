`timescale 1ns/1ps
module m_sram_rd_ctrl(

    //------------------------------------------------------
    //--  Global clocks,Reset, active low
    //------------------------------------------------------
    input               clk_in             ,
    input               rst_n              ,

    //------------------------------------------------------
    //--  sram write interface
    //------------------------------------------------------
    output reg          sram_rd_adsp_n_out ,
    output              sram_rd_adsc_n_out ,
    output reg  [ 3:0]  sram_rd_ce1_n_out  ,
    output      [ 3:0]  sram_rd_ce2_p_out  ,
    output      [ 3:0]  sram_rd_ce2_n_out  ,

    output reg  [20:0]  sram_rd_addr_out   ,
    input       [127:0] sram_rd_data_in    ,
    output reg          sram_rd_en_out     ,

    //------------------------------------------------------
    //--user interface : read data
    //------------------------------------------------------
    input                rd_req            ,
    input       [23:0]   sram_raddr        ,
    output  reg          fifo_wr_en        ,
    output  reg [31:0]   fifo_wdata        


);
    //------------------------------------------------------
    //--internal signals
    //------------------------------------------------------

    wire    [ 1:0 ] sram_rd_ce        ;
    wire    [20:0]  data_rd_addr_valid;

    reg     [23:0]  rd_sram_raddr     ;
    reg             sram_rd_en        ;
    reg             sram_rd_en_dly    ;
    reg             sram_rd_en_dly1    ;
    reg             sram_rd_req       ;
    reg             sram_rd_req_dly;
    reg     [10:0]  cnt_0             ;
    reg             data_rd_in_valid  ;
    reg    [31:0]   data_rd_data_in   ;
    
    
    wire  [35:0]    TRIG0;
    wire  [35:0]    TRIG1;

//----------------------------------------------------------
//--setp 2 :read the addr
//----------------------------------------------------------

assign  sram_rd_ce = rd_sram_raddr[22:21];
assign  data_rd_addr_valid = rd_sram_raddr[20:0];
assign  sram_rd_adsc_n_out = 1;
assign  sram_rd_ce2_p_out  = 4'b1111;
assign  sram_rd_ce2_n_out  = 4'b0000;


//rd_req,different clock
always @(posedge clk_in or negedge rst_n)
  begin
    if(!rst_n)
      begin
       sram_rd_req     <= 1'b0;
       sram_rd_req_dly <= 1'b0;
     end
    else
      begin
       sram_rd_req     <= rd_req ;
       sram_rd_req_dly <= sram_rd_req;
      end
  end

always @(posedge clk_in or negedge rst_n)
  begin
    if(!rst_n)
      cnt_0 <= 0;
    else if( cnt_0>=1 && cnt_0<=1035)
      cnt_0 <= cnt_0 + 1;
    else if (sram_rd_req_dly)
      cnt_0 <= 1;
  end

//data_rd_in_valid
always @(posedge clk_in or negedge rst_n)
  begin
    if(!rst_n)
      data_rd_in_valid <= 1'b0;
    else if ( cnt_0>=1 && cnt_0<=1035 )
      data_rd_in_valid <=  1 ;
    else
      data_rd_in_valid <=  0 ;
end

always @(posedge clk_in or negedge rst_n)
  begin
    if(!rst_n)
      rd_sram_raddr <= 0;
    else if(rd_req)
      rd_sram_raddr <= sram_raddr;
    else if (data_rd_in_valid )
      rd_sram_raddr <= rd_sram_raddr +1;
  end


//fifo_rd_en
always @(posedge clk_in or negedge rst_n)
  begin
    if(!rst_n)
      fifo_wr_en <= 1'b0;
    else if ( sram_rd_en_dly1 )
      fifo_wr_en <= 1'b1;
    else
      fifo_wr_en <= 1'b0;
  end


//sram_rd_adsp_n_out
always @(posedge clk_in or negedge rst_n)
  begin
    if(!rst_n)
      sram_rd_adsp_n_out <= 1'b1;
    else if(data_rd_in_valid)
      sram_rd_adsp_n_out <= 1'b0;
    else
      sram_rd_adsp_n_out <= 1'b1;
  end

//sram_rd_ce*_*_out

always @(posedge clk_in or negedge rst_n)
  begin
    if(!rst_n)
      begin
          sram_rd_ce1_n_out <= 4'b1111;

      end
    else
      case(sram_rd_ce)

        2'b00:  sram_rd_ce1_n_out <= 4'b1110;
        2'b01:  sram_rd_ce1_n_out <= 4'b1101;
        2'b10:  sram_rd_ce1_n_out <= 4'b1011;
        2'b11:  sram_rd_ce1_n_out <= 4'b0111;
        default:sram_rd_ce1_n_out <= 4'b1111;

      endcase
  end

//sram_rd_addr_out
always @(posedge clk_in or negedge rst_n)
  begin
    if(!rst_n)
      sram_rd_addr_out <= 21'd0;
    else
      sram_rd_addr_out <= data_rd_addr_valid;
  end

//----------------------------------------------------------
//--setp 2 :read the addr
//----------------------------------------------------------
//sram_rd_en
always @(posedge clk_in or negedge rst_n)
  begin
    if(!rst_n)
      sram_rd_en <= 1'b0;
    else
      sram_rd_en <= data_rd_in_valid;
  end

always @(posedge clk_in or negedge rst_n)
  begin
    if(!rst_n)
      sram_rd_en_dly <= 1'b0;
    else
      sram_rd_en_dly <= sram_rd_en;
  end
always @(posedge clk_in or negedge rst_n)
  begin
    if(!rst_n)
      sram_rd_en_dly1 <= 1'b0;
    else
      sram_rd_en_dly1 <=sram_rd_en_dly ;
  end

//sram_rd_en_out
always @(posedge clk_in or negedge rst_n)
  begin
    if(!rst_n)
      sram_rd_en_out <= 1'b1;
    else if(sram_rd_en||sram_rd_en_dly  )
      sram_rd_en_out <= 1'b0;
    else
      sram_rd_en_out <= 1'b1;
  end
always @(posedge clk_in or negedge rst_n)
  begin
    if(!rst_n)
        begin
            fifo_wdata <= 32'd0;
        end
  else if(!sram_rd_en_dly1)
    fifo_wdata <= 32'd0;
  else begin
    case(sram_rd_ce)

      2'b00:    fifo_wdata <= sram_rd_data_in[31:0];
      2'b01:    fifo_wdata <= sram_rd_data_in[63:32];
      2'b10:    fifo_wdata <= sram_rd_data_in[95:64];
      2'b11:    fifo_wdata <= sram_rd_data_in[127:96];
      default:  ;
    endcase
  end
end




endmodule

