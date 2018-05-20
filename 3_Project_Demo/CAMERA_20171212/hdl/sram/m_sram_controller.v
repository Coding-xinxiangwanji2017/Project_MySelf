//*****************************************************************************
//*****************************************************************************
`timescale 1ns/1ps
module m_sram_controller (

    //------------------------------------------------------
    //--  Global clocks,Reset, active low
    //------------------------------------------------------
    input                clk_in          ,
    input                rst_n           ,

    //------------------------------------------------------
    //-- sram interface
    //------------------------------------------------------
    output              sram_clk_out     ,
    output              sram_adsp_n_out  ,
    output              sram_adsc_n_out  ,
    output              sram_adv_n_out   ,
    output    [ 3:0]    sram_ce1_n_out   ,
    output    [ 3:0]    sram_ce2_p_out   ,
    output    [ 3:0]    sram_ce2_n_out   ,

    output              sram_gw_n_out    ,
    output              sram_bwe_n_out   ,
    output              sram_bwa_n_out   ,
    output              sram_bwb_n_out   ,
    output              sram_bwc_n_out   ,
    output              sram_bwd_n_out   ,

    output    [20:0]    sram_addr_out    ,
    output              sram_rd_en_out   ,
    inout     [127:0]   sram_data_inout  ,
    inout     [15:0]    sram_data_p_inout,

    //------------------------------------------------------
    //--user  interface
    //------------------------------------------------------

    //write
    input               wr_req           ,
    input     [23:0]    sram_waddr       ,
    output              fifo_rd_en       ,
    input     [31:0]    fifo_rdata       ,

    //read
    input               rd_req           ,
    input     [23:0]    sram_raddr       ,
    output              fifo_wr_en       ,
    output    [31:0]    fifo_wdata       
//    inout     [35:0]    CONTROL0
);
    //------------------------------------------------------
    //--  internal signals
    //------------------------------------------------------


    wire           sram_wr_adsp_n      ;
    wire           sram_wr_adsc_n      ;
    wire  [ 3:0]   sram_wr_ce1_n       ;
    wire  [ 3:0]   sram_wr_ce2_p       ;
    wire  [ 3:0]   sram_wr_ce2_n       ;
    
    wire  [20:0]   sram_wr_addr        ;
    wire  [127:0]  sram_wr_data_out    ;
            
    wire           sram_rd_adsp_n      ;
    wire           sram_rd_adsc_n      ;
    wire  [ 3:0]   sram_rd_ce1_n       ;
    wire  [ 3:0]   sram_rd_ce2_p       ;
    wire  [ 3:0]   sram_rd_ce2_n       ;
            
    wire  [20:0]   sram_rd_addr        ;
    wire  [127:0]  sram_rd_data_in     ;
    
    wire  [15:0]   sram_data_p_in      ;
    wire  [15:0]   sram_data_p_out     ;
    reg            sram_wr_en          ;


assign  sram_clk_out    = ~clk_in;

assign  sram_adsp_n_out = (sram_wr_en) ? sram_wr_adsp_n : sram_rd_adsp_n;
assign  sram_adsc_n_out = (sram_wr_en) ? sram_wr_adsc_n : sram_rd_adsc_n;
assign  sram_adv_n_out  = 1'b1;
assign  sram_ce1_n_out  = (sram_wr_en) ? sram_wr_ce1_n : sram_rd_ce1_n;
assign  sram_ce2_p_out  = (sram_wr_en) ? sram_wr_ce2_p : sram_rd_ce2_p;
assign  sram_ce2_n_out  = (sram_wr_en) ? sram_wr_ce2_n : sram_rd_ce2_n;

assign  sram_addr_out   = (sram_wr_en) ? sram_wr_addr : sram_rd_addr;
assign  sram_rd_data_in[127:0] = sram_data_inout;
assign  sram_data_inout = (sram_wr_en) ? sram_wr_data_out   : 128'dz;

//assign  sram_rd_data_in[144:128] = sram_data_p_inout;
//assign  sram_data_p_inout = (sram_wr_en) ? 16'd0   : 16'dz;

//sram_wr_en
always @( posedge clk_in or negedge rst_n )
  begin
    if(!rst_n)
      sram_wr_en <= 1'b0;
    else if(wr_req)
      sram_wr_en <= 1'b1;
    else if(rd_req)
      sram_wr_en <= 1'b0;
  end

//
m_sram_wr_ctrl i_m_sram_wr_ctrl (
    .clk_in                 (clk_in          ),
    .rst_n                  (rst_n           ),

    //sram write interface
    .sram_wr_adsp_n_out     (sram_wr_adsp_n  ),
    .sram_wr_adsc_n_out     (sram_wr_adsc_n  ),
    .sram_wr_ce1_n_out      (sram_wr_ce1_n   ),
    .sram_wr_ce2_p_out      (sram_wr_ce2_p   ),
    .sram_wr_ce2_n_out      (sram_wr_ce2_n   ),

    .sram_wr_gw_n_out       (sram_gw_n_out   ),
    .sram_wr_bwe_n_out      (sram_bwe_n_out  ),
    .sram_wr_bwa_n_out      (sram_bwa_n_out  ),
    .sram_wr_bwb_n_out      (sram_bwb_n_out  ),
    .sram_wr_bwc_n_out      (sram_bwc_n_out  ),
    .sram_wr_bwd_n_out      (sram_bwd_n_out  ),
    .sram_wr_addr_out       (sram_wr_addr    ),
    .sram_wr_data_out       (sram_wr_data_out),
    //user interface : write data
    .wr_req                 (wr_req          ),
    .sram_waddr             (sram_waddr      ),
    .fifo_rd_en             (fifo_rd_en      ),
    .fifo_rdata             (fifo_rdata      )
);
//
m_sram_rd_ctrl i_m_sram_rd_ctrl(
    .clk_in                 (clk_in          ),
    .rst_n	                (rst_n           ),
    //sram write interfac
    .sram_rd_adsp_n_out     (sram_rd_adsp_n  ),
    .sram_rd_adsc_n_out     (sram_rd_adsc_n  ),
    .sram_rd_ce1_n_out      (sram_rd_ce1_n   ),
    .sram_rd_ce2_p_out      (sram_rd_ce2_p   ),
    .sram_rd_ce2_n_out      (sram_rd_ce2_n   ),
    .sram_rd_addr_out       (sram_rd_addr    ),
    .sram_rd_data_in        (sram_rd_data_in ),
    .sram_rd_en_out         (sram_rd_en_out  ),
    //user interface : read data
    .rd_req                 (rd_req          ),
    .sram_raddr             (sram_raddr      ),
    .fifo_wr_en             (fifo_wr_en      ),
    .fifo_wdata             (fifo_wdata      )

);


wire [255:0] TRIG0;
wire [255:0] TRIG1;
wire [255:0] TRIG2;
wire [255:0] TRIG3;

//ILA1 ila1 (
//		 .CONTROL(CONTROL0), // INOUT BUS [35:0]
//		 .CLK(clk_in), // IN
//		 .TRIG0(TRIG0), // IN BUS 
//		 .TRIG1(TRIG1), // IN BUS 
//		 .TRIG2(TRIG2), // IN BUS 
//		 .TRIG3(TRIG3)  // IN BUS 
//	    );
//	    
//	    
//	    
//     assign  TRIG0[0]   = wr_req ;
//	 assign  TRIG0[24:1] = sram_waddr ;
//	 assign  TRIG0[25] = fifo_rd_en ;
//	 assign  TRIG0[57:26] = fifo_rdata ;
//	 	 
//	 assign  TRIG0[79]    =  rd_req ;
//	 assign  TRIG0[103:80]   =  sram_raddr ;
//	 assign  TRIG0[104] =  fifo_wr_en  ;
//     assign  TRIG0[136:105]=  fifo_wdata ;
//	 
//	 
//	 assign  TRIG0[138]    =  sram_adsp_n_out ;
//	 assign  TRIG0[139]    =  sram_adsc_n_out ;
//	 assign  TRIG0[140]    =  sram_adv_n_out ;
//	 assign  TRIG0[141]    =  sram_ce1_n_out ;
//	 assign  TRIG0[142]    =  sram_ce2_p_out ;
//	 assign  TRIG0[143]    =  sram_ce2_n_out ;
//	 assign  TRIG0[144]    =  sram_gw_n_out ;
//	 assign  TRIG0[145]    =  sram_bwe_n_out ;
//	 assign  TRIG0[146]    =  sram_bwa_n_out ;
//	 assign  TRIG0[147]    =  sram_bwb_n_out ;
//	 assign  TRIG0[148]    =  sram_bwc_n_out ;
//	 assign  TRIG0[149]    =  sram_bwd_n_out ;
//	 assign  TRIG0[150]    =  sram_gw_n_out ;
//	 assign  TRIG0[78:58] = sram_addr_out;
//	 assign  TRIG0[137]    =  sram_rd_en_out ;
//	 assign  TRIG1[127:0] = sram_data_inout;	 
//	 	    
	    
	    

endmodule
