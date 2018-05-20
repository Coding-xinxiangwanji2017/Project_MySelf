//*****************************************************************************
//*****************************************************************************
`timescale 1ns/1ps

module m_sram_wr_ctrl (

    //------------------------------------------------------
    //--  Global clocks,Reset, active low
    //------------------------------------------------------
    input               clk_in              ,
    input               rst_n               ,
    //------------------------------------------------------
    //--  sram write interface
    //------------------------------------------------------
    output              sram_wr_adsp_n_out  ,
    output reg          sram_wr_adsc_n_out  ,
    output reg [ 3:0]   sram_wr_ce1_n_out   ,
    output     [ 3:0]   sram_wr_ce2_p_out   ,
    output     [ 3:0]   sram_wr_ce2_n_out   ,

    output reg          sram_wr_gw_n_out    ,
    output              sram_wr_bwe_n_out   ,
    output              sram_wr_bwa_n_out   ,
    output              sram_wr_bwb_n_out   ,
    output              sram_wr_bwc_n_out   ,
    output              sram_wr_bwd_n_out   ,
    output reg [20:0]   sram_wr_addr_out    ,
    output     [127:0]  sram_wr_data_out    ,
    //------------------------------------------------------
    //--  sram user interface
    //------------------------------------------------------

    input               wr_req              ,
    input      [23:0]   sram_waddr          ,
    output reg          fifo_rd_en          ,
    input      [31:0]   fifo_rdata
);
    //------------------------------------------------------
    //--  internal signals
    //------------------------------------------------------
    wire    [ 1:0 ] sram_wr_ce        ;
    wire    [20:0]  data_wr_addr_valid;
    reg     [31:0]  sram0_wr_data_out ;
    reg     [31:0]  sram1_wr_data_out ;
    reg     [31:0]  sram2_wr_data_out ;
    reg     [31:0]  sram3_wr_data_out ;

    reg     [23:0]  r_sram_raddr      ;
    reg             sram_wr_req       ;
    reg             sram_wr_req_dly   ;
    reg     [10:0]  cnt_0             ;
    reg             fifo_rd_en_dly    ;
    reg             data_wr_in_valid  ;
    reg     [31:0]  data_wr_data_in   ;

//----------------------------------------------------------
//--  setp 1 : write the addr
//----------------------------------------------------------

assign  sram_wr_ce = r_sram_raddr[22:21];
assign  data_wr_addr_valid = r_sram_raddr[20:0];
assign  sram_wr_data_out   = { sram3_wr_data_out[31:0],sram2_wr_data_out[31:0],sram1_wr_data_out[31:0],sram0_wr_data_out[31:0]};
assign  sram_wr_adsp_n_out = 1;
assign  sram_wr_ce2_p_out  = 4'b1111;
assign  sram_wr_ce2_n_out  = 4'b0000;
assign  sram_wr_bwe_n_out  = 1'b1;
assign  sram_wr_bwa_n_out  = 1'b1;
assign  sram_wr_bwb_n_out  = 1'b1;
assign  sram_wr_bwc_n_out  = 1'b1;
assign  sram_wr_bwd_n_out  = 1'b1;

//sram_wr_req
always @(posedge clk_in or negedge rst_n)
  begin
    if(!rst_n)
      begin
        sram_wr_req     <= 1'b0;
        sram_wr_req_dly <= 1'b0;
      end
    else
      begin
        sram_wr_req     <= wr_req     ;
        sram_wr_req_dly <= sram_wr_req;
      end
 end

always @(posedge clk_in or negedge rst_n)
  begin
    if(!rst_n)
      cnt_0 <= 0;
    else if( cnt_0>= 1 && cnt_0 <= 1035)
      cnt_0 <= cnt_0 + 1;
    else if (sram_wr_req_dly)
      cnt_0 <= 1;
  end


//fifo_rd_en
always @(posedge clk_in or negedge rst_n)
  begin
    if(!rst_n)
      fifo_rd_en <= 1'b0;
    else if ( cnt_0>= 1 && cnt_0 <= 1035 )
      fifo_rd_en <= 1'b1;
    else
      fifo_rd_en <= 1'b0;
  end


//fifo_rd_en_dly
always @(posedge clk_in or negedge rst_n)
  begin
    if(!rst_n)
      fifo_rd_en_dly <= 1'b0;
    else if ( fifo_rd_en )
      fifo_rd_en_dly <= 1'b1;
    else
      fifo_rd_en_dly <= 1'b0;
  end


//data_wr_in_valid
always @(posedge clk_in or negedge rst_n)
  begin
    if(!rst_n)
      data_wr_in_valid <= 1'b0;
    else if( fifo_rd_en_dly )
      data_wr_in_valid <= 1'b1;
    else
      data_wr_in_valid <= 1'b0;
  end



always @(posedge clk_in or negedge rst_n)
  begin
    if(!rst_n)
      r_sram_raddr <= 0;
    else if(wr_req)
      r_sram_raddr <= sram_waddr;
    else if (data_wr_in_valid )
      r_sram_raddr <= r_sram_raddr +1;
  end

//sram_wr_adsc_n_out
always @(posedge clk_in or negedge rst_n)
  begin
    if(!rst_n)
      sram_wr_adsc_n_out <= 1'b1;
    else if(data_wr_in_valid)
      sram_wr_adsc_n_out <= 1'b0;
    else
      sram_wr_adsc_n_out <= 1'b1;
  end

//sram_wr_ce*_*_out
always @(posedge clk_in or negedge rst_n)
  begin
    if(!rst_n)
      begin
        sram_wr_ce1_n_out <= 4'b1111;

      end
    else
      case(sram_wr_ce)
        2'b00:  sram_wr_ce1_n_out <= 4'b1110;
        2'b01:  sram_wr_ce1_n_out <= 4'b1101;
        2'b10:  sram_wr_ce1_n_out <= 4'b1011;
        2'b11:  sram_wr_ce1_n_out <= 4'b0111;
        default:sram_wr_ce1_n_out <= 4'b1111;
      endcase
  end

//sram_wr_addr_out
always @(posedge clk_in or negedge rst_n)
 begin
   if(!rst_n)
     sram_wr_addr_out <= 21'd0;
   else
     sram_wr_addr_out <= data_wr_addr_valid;
 end

//----------------------------------------------------------
//--  setp 2 : write the data
//----------------------------------------------------------

//sram_wr_gw*_n_out
always @(posedge clk_in or negedge rst_n)
  begin
    if(!rst_n)
      sram_wr_gw_n_out <= 1;
    else if(data_wr_in_valid)
      sram_wr_gw_n_out <= 0;
    else
      sram_wr_gw_n_out <= 1;
end

//write data
always @(posedge clk_in or negedge rst_n)
  begin
    if(!rst_n)
      data_wr_data_in <= 32'b0;
    else if (fifo_rd_en_dly )
      data_wr_data_in <= fifo_rdata;
  end

always @(posedge clk_in or negedge rst_n)
  begin
    if(!rst_n)
      begin
          sram0_wr_data_out <= 32'd0;
          sram1_wr_data_out <= 32'd0;
          sram2_wr_data_out <= 32'd0;
          sram3_wr_data_out <= 32'd0;

      end
    else
      case(sram_wr_ce)
        2'b00: sram0_wr_data_out <= data_wr_data_in;
        2'b01: sram1_wr_data_out <= data_wr_data_in;
        2'b10: sram2_wr_data_out <= data_wr_data_in;
        2'b11: sram3_wr_data_out <= data_wr_data_in;
        default:
          begin
            sram0_wr_data_out <= sram0_wr_data_out;
            sram1_wr_data_out <= sram1_wr_data_out;
            sram2_wr_data_out <= sram2_wr_data_out;
            sram3_wr_data_out <= sram3_wr_data_out;
          end
      endcase
end

endmodule
