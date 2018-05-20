//////////////////////////////////////////////////////////////////////////////////
// Company: Bixing-tech
// Engineer: Zhang xueyan
//
// Create Date:    2016/7/12
// Design Name:
// Module Name:
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//
//////////////////////////////////////////////////////////////////////////////////

//`define SIMULATION


`timescale 1ns/100ps

module CAMERA_SIM(

    //-----------------------------------------------------------
    //-- reset, clocks
    //-----------------------------------------------------------

    input  wire         w_CLK_100M        ,
    input  wire         FPGA_RST_N        ,
    output wire         o_CLK_100M        ,
    inout  wire[35:0]   CONTROL0          , 
    inout  wire[35:0]   CONTROL1          , 

    //-----------------------------------------------------------
    //-- GTX interface
    //-----------------------------------------------------------
//    input  wire         FPGA_GTX115_0P    ,//clock
//    input  wire         FPGA_GTX115_0N    ,
//    input  wire         Q0_CLK1_GTREFCLK_PAD_P_IN    ,
//    input  wire         Q0_CLK1_GTREFCLK_PAD_N_IN    ,
//
//    output wire         TXP_OUT        ,
//    output wire         TXN_OUT        ,
//    input wire          RXP_IN        ,
//    input wire          RXN_IN        ,
//
//    input  wire         FPGA_GTX118_0P    ,//clock
//    input  wire         FPGA_GTX118_0N    ,
//    input  wire         FPGA_GTX118_1P    ,
//    input  wire         FPGA_GTX118_1N    ,
//
//    output wire         MGTX0_TX_P        ,
//    output wire         MGTX0_TX_N        ,
//    input  wire         MGTX0_RX_P        ,
//    input  wire         MGTX0_RX_N        , 
//    
//    
    
     input  wire             GT0_TXUSRCLK2,
     input  wire             GT0_RXUSRCLK2,
                                         
     output  reg  [15:0]    TX_DATA_OUT, 
     output  reg  [1:0]     TXCTRL_OUT , 
                                        
     input wire    [15:0]    RX_DATA_IN , 
     input wire    [1:0]     RXCTRL_IN  , 
    
    


    //-----------------------------------------------------------
    //-- SYNC  interface
    //-----------------------------------------------------------
    input  wire         FPGA_LVDS_0_P     ,
    input  wire         FPGA_LVDS_0_N     ,

    input  wire         FPGA_LVDS_1_P     ,
    input  wire         FPGA_LVDS_1_N     ,

    //-----------------------------------------------------------
    //-- TOE
    //-----------------------------------------------------------
    input  wire         TOE_CLK_125M_P    ,
    input  wire         TOE_CLK_125M_N    ,
    inout  wire         TOE_HS0_CLK       ,
    input  wire         TOE_HS0_INTn      ,//High Speed Interface Interrupt

    input  wire [7:0]   TOE_Q             ,//Read data
    output wire [7:0]   TOE_D             ,//Transfer data
    output wire [2:0]   TOE_TC            ,//Transfer channal address
    input  wire [2:0]   TOE_RC            ,//Read channal address
    output wire         TOE_nTX           ,//Transfer enable, active low
    input  wire         TOE_nRX           ,//Read enable flag, active low
    input  wire [7:0]   TOE_nTF           ,//Transfer full flag, active low
    output wire [7:0]   TOE_nRF           ,//Read full flag, active low

    /*
    output wire         TOE_HS0_CTS_SCSn      ,// Active low ,slave SPI chip select.
    output wire         TOE_HS0_RTS_SSCK      ,//Slave SPI clock signal.
    input  wire         TOE_HS0_TXD_SMOSI     ,
    output wire         TOE_HS0_RXD_SMISO     ,
    */



    //-----------------------------------------------------------
    //-- FLASH
    //-----------------------------------------------------------
    output wire [26:0]  FPGA_A            ,
    inout  wire [15:0]  FPGA_D            ,
    output wire         FPGA_FWE_N        ,//write enable,active low
    output wire         FPGA_FPE_N        ,//write protect,active low
    output wire         FPGA_ADV_B        ,//address valid,active low
    output wire         FPGA_INIT_B_1     ,//reset,active low
    output wire         FPGA_FOE_N        ,//output enable,active low
    output wire         FPGA_FCS          ,//chip enable,active low
    input  wire         FPGA_WAIT         ,
    output wire         FPGA_CCLK_1       ,

    //-----------------------------------------------------------
    //-- SRAM
    //-----------------------------------------------------------
    output wire         SBRAM_CLK        ,
    output wire [20:0 ] SBRAM_A          ,
    inout  wire [127:0] SBRAM_DQ         ,//data
    inout  wire [15:0 ] SBRAM_DQP        ,//parity data

    output wire [3:0]   SBRAM_nCE1       ,
    output wire [3:0]   SBRAM_CE2        ,
    output wire [3:0]   SBRAM_nCE2       ,
    output wire         SBRAM_nBWA       ,//byte write control
    output wire         SBRAM_nBWB       ,
    output wire         SBRAM_nBWC       ,
    output wire         SBRAM_nBWD       ,
    output wire         SBRAM_nBWE       ,//write enable
    output wire         SBRAM_nADSC      ,//address status Controller
    output wire         SBRAM_nADSP      ,//address status processor
    output wire         SBRAM_nADV       ,//
    output wire         SBRAM_nGW        ,//global write enable
    output wire         SBRAM_nOE        ,
    output wire         TRACK_DATA_OUT 

    /*
    //-----------------------------------------------------------
    //-- TEST AND LED indacate
    //-----------------------------------------------------------
    output wire [4:1]   LED               ,// Active high
    output wire [7:0]   FPGA_LED          ,
    output wire [7:0]   FPGA_GPIO         ,

    //-----------------------------------------------------------
    //-- TEST UART
    //-----------------------------------------------------------
    output wire         FPGA_TXD          ,
    output wire         FPGA_RTS          ,
    input  wire         FPGA_RXD          ,
    input  wire         FPGA_CTS
    */

    /*
    //-----------------------------------------------------------
    //-- TEST GTX interface
    //-----------------------------------------------------------
    input  wire         FPGA_GTX116_0P    ,//clock
    input  wire         FPGA_GTX116_0N    ,
    input  wire         FPGA_GTX116_1P    ,
    input  wire         FPGA_GTX116_1N    ,

    output wire         SATA_TXP0         ,
    output wire         SATA_TXN0         ,
    input wire          SATA_RXP0         ,
    input wire          SATA_RXN0         ,

    input  wire         FPGA_GTX117_0P    ,//clock
    input  wire         FPGA_GTX117_0N    ,
    input  wire         FPGA_GTX117_1P    ,
    input  wire         FPGA_GTX117_1N    ,

    output wire         SATA_TXP1         ,
    output wire         SATA_TXN1         ,
    input  wire         SATA_RXP1         ,
    input  wire         SATA_RXN1         ,
    */

    /*
    //-----------------------------------------------------------
    //-- DDR3
    //-----------------------------------------------------------
    input  wire         DDR3_CLK_200M_P   ,
    input  wire         DDR3_CLK_200M_N   ,
    output wire         Group_DDR3_ECKP   ,
    output wire         Group_DDR3_ECKN   ,
    output wire         Group_DDR3_ECKE   ,
    output wire         Group_DDR3_RESETN ,
    output wire [14:0]  Group_DDR3_EA     ,
    inout  wire [63:0]  GROUP_DDR3_EDQ1   ,
    output wire [ 2:0]  Group_DDR3_BA     ,
    output wire         Group_DDR3_EWE    ,//active low
    output wire         Group_DDR3_ECAS   ,//active low
    output wire         Group_DDR3_ERAS   ,//active low
    output wire         Group_DDR3_ECS    ,//active low
    inout  wire [7:0]   Group_DDR3_EDQSP_ ,
    inout  wire [7:0]   Group_DDR3_EDQSN_ ,
    output wire [7:0]   Group_DDR3_EDM_   ,
    input  wire         Group_DDR3_EODT   ,
    */

    /*
    //-----------------------------------------------------------
    //-- SPI flash
    //-----------------------------------------------------------
    output wire         FPGA_CCLK         ,
    output wire         FCS               ,//reset
    inout  wire [ 3:0]  D0                ,
    */

    /*
    //-----------------------------------------------------------
    //-- config
    //-----------------------------------------------------------
    input  wire [2:0]  FPGA_M             ,//SPI/QSPI MODE M[2:0] = 001
    output wire        FPGA_CONFIG_DONE   ,
    */

);


    //-----------------------------------------------------------
    //
    //-----------------------------------------------------------
    wire             w_CLK_125M             ;
//    wire             w_CLK_100M             ;
    wire             w_rst_n                ;
    wire             w_temp_rst_m           ;

    wire             w_sync_out             ;
    wire             w_sync_in              ;
//    wire             GT0_TXUSRCLK2           ;

    wire   [15:0]     r_TX_DATA              ;
    wire   [1:0]      r_TXCTRL               ;

    wire  [15:0]     w_TX_DATA_CMD          ;
    wire  [1:0]      w_TXCTRL_CMD           ;
    
    wire  [15:0]     w_TX_DATA_CMD1         ;
    wire  [1:0]      w_TXCTRL_CMD1          ;
    
    wire             vio_0                  ;
    wire  [7:0]      ASYNC_OUT              ;
//    wire  [15:0]     TX_DATA_OUT         ;
//    wire  [1:0]      TXCTRL_OUT           ;

//    wire  [15:0]     RX_DATA_IN              ;
//    wire  [1:0]      RXCTRL_IN               ;

//    wire             w_RXENMCOMMADET_OUT    ;
//    wire             w_RXENPCOMMADET_OUT    ;

    wire             w_TOE_Tx               ;
    wire  [2:0]      w_TOE_TxChan           ;
    wire  [7:0]      w_TOE_TxData           ;
    wire  [7:0]      w_TOE_RxFull           ;
    wire             w_TOE_Rx               ;
    wire  [2:0]      w_TOE_RxChan           ;
    wire  [7:0]      w_TOE_RxData           ;
    wire  [7:0]      w_TOE_TxFull           ;
    wire             w_TOE_Interrupt        ;
    
   wire  [7:0]      w_send_data						;
//		wire             w_rx                   ;
//		wire  [1:0]      w_rx_full                 ;

    wire              w_timing_telemetry    ;
    wire              w_timing_lightdiag    ;
    wire              w_timing_stardiag     ;
    wire              w_transmit_done       ;
    //wire  [15:0]      w_tx_data             ;
    //wire  [1:0]       w_tx_control          ;
    wire              w_rd_req              ;
    wire  [23:0]      w_sram_raddr          ;
    wire              w_fifo_wr_en          ;
    wire  [31:0]      w_fifo_wdata          ;
    wire  [31:0]      w_fifo_wdata_n        ;
    wire              w_starparam_ram_rd    ;
    wire  [11:0]      w_starparam_ram_addr  ;
    wire  [15:0]      w_starparam_ram_data  ;

    wire              w_rst_wfifo           ;
    wire              w_rst_rfifo           ;
    wire              w_wr_fifo             ;
    wire              w_rd_fifo             ;
    wire  [15:0]      w_data_in             ;
    wire  [15:0]      w_data_out            ;
    wire              w_data_valid          ;
    wire  [13:0]      w_row                 ;
    wire              w_done_toe            ;
    wire              w_done_move           ;
    wire              w_era                 ;
    wire              w_wr_flash            ;
    wire              w_rd_flash            ;

    wire              w_enable              ;
    wire              w_flash_busy          ;
    wire              w_move_done           ;
    wire  [15:0]      w_flash_in            ;
    wire              w_fifo_rd_en          ;
    wire              w_d_move_busy         ;
    wire              w_rd_en               ;
    wire              w_wr_req              ;
    wire  [23:0]      w_sram_waddr          ;
    wire  [31:0]      w_sram_rdata          ;
    wire              w_ram_wr              ;
    wire  [11:0]      w_ram_addr            ;
    wire  [15:0]      w_ram_data            ;

    wire              w_CMD_TX              ;
    wire  [ 1:0]      w_CMD_Type            ;
    wire              w_CMD_Done            ;

    wire              w_CMD_Cfg_Done;
    wire              w_CMD_ShutDown;
    wire  [31: 0]     w_Reg_Second;
    wire  [31: 0]     w_Reg_MicroSecond;
    wire  [15: 0]     w_Reg_StarImageSend;
    wire  [15: 0]     w_Reg_SendFreq;
    wire  [15: 0]     w_Reg_SpotSend;
    wire  [15: 0]     w_Reg_TdiLevel;
    wire  [15: 0]     w_Reg_TdiTime;

    wire              w_Frm_Tx_En;
    wire              w_TOE_Busy;

    wire  [13:0]      w_row1               ;
    wire  [13:0]      w_row2               ; 

    wire              timing_stardiag      ;
    wire              timing_lightdiag     ;
    wire              timing_telemetry     ;

    reg               timing_stardiag1     ;
    reg               timing_lightdiag1    ;
    reg               timing_telemetry1    ;
    reg               timing_stardiag2     ;
    reg               timing_lightdiag2    ;
    reg               timing_telemetry2    ; 
       
    wire              frm_end_d3           ;
    wire  [16:0]      check_sum            ;
    wire  [15:0]      OpCode_1             ;
    wire  [15:0]      ChechSum_1           ;
    
    wire  [10:0]      data_cnt             ;
    wire  [1:0]       p_choose             ;
    
    wire  [31:0]      cnt;
    wire  [15:0]      reg_Freq;
    wire              send_en;

    wire  [15:0]      read_data;      
    wire              read_valid;      

    assign w_row = w_row1 | w_row2;
    assign w_clk50 = GT0_TXUSRCLK2;
//    assign o_CLK_100M = w_CLK_100M;
////---------------------------------------------------------------
////PLLµ÷ÓÃ
////---------------------------------------------------------------
//     clk_ctrl u1_clk_ctrl(
//        .clk_100m_p         (SYS_CLK_100M_P ),
//        .clk_100m_n         (SYS_CLK_100M_N ),
//        .clk_100m_out       (w_CLK_100M     ),
//        .rst_n              (1'b1           ),
//        .locked             (w_temp_rst_m   )
//    );

    assign  w_rst_n = FPGA_RST_N ;

   //----------------------------------------
   //
   //----------------------------------------
//   wire     w_clk50;
//
//     //-- 20MHz clock
//   sysclkgen
//   #(
//    .CLK_PERIOD   (20 ),
//    .HIGH_PERIOD  (10 )
//   )
//   u1_sysclkgen
//   (
//    .clk      (w_clk50 )
//   );

   //-----------------------------------------------------------
   //-- Main Control
   //-----------------------------------------------------------
	wire [5:0] fsm_curr;
   MAIN_CTRL u1_MAIN_CTRL(

    //-----------------------------------------------------------
    //-- reset, clocks
    //-----------------------------------------------------------
    .clk          (w_CLK_125M),
    .rst_n        (w_rst_n),

    //-----------------------------------------------------------
    //-- GTX interface
    //-----------------------------------------------------------
    .TOE_Busy           (w_TOE_Busy),
    .Data_Move_En       (Data_Move_En),
    .Data_Move_Busy     (w_d_move_busy),
    .Data_Move_Done     (w_move_done),
    //-- rx signal
    .CMD_Cfg_Done       (w_CMD_Cfg_Done),
    .CMD_ShutDown       (w_CMD_ShutDown),

    //-- tx control
    .CMD_TX             (w_CMD_TX  ),
    .CMD_Type           (w_CMD_Type),
    .CMD_Done           (w_CMD_Done  ),
	 .fsm_curr           (fsm_curr    ),
    
    .Frm_Tx_En          (w_Frm_Tx_En)
    );

  //-----------------------------------------------------------
  //-- Timing control
  //-----------------------------------------------------------

  TIMING_NEW u1_TIMING(

    //-----------------------------------------------------------
    //-- reset, clocks
    //-----------------------------------------------------------
    .clk          (w_CLK_100M  ),  // 100MHz
    .rst_n        (FPGA_RST_N),

    //-----------------------------------------------------------
    //-- GTX interface
    //-----------------------------------------------------------
    //
    .pps_pulse                 (w_sync_out          ),
                                                    
    .CMD_Cfg_Done              (w_CMD_Cfg_Done      ),
    
    .Reg_Second                (w_Reg_Second        ),
    .Reg_MicroSecond           (w_Reg_MicroSecond   ),
    .Reg_StarImageSend         (w_Reg_StarImageSend ),
    .Reg_SendFreq              (w_Reg_SendFreq      ),
    .Reg_SpotSend              (w_Reg_SpotSend      ),
    .Reg_TdiLevel              (w_Reg_TdiLevel      ),
    .Reg_TdiTime               (w_Reg_TdiTime       ),

    .Frm_Tx_En                 (w_Frm_Tx_En),
    .cnt                       (cnt        ),
    .reg_Freq                  (reg_Freq   ),
    .send_en                   (send_en    ),
         
    .Transmit_Done             (w_transmit_done   ),
    .Timing_Stardiag           (timing_stardiag   ),
    .Timing_lightdiag          (timing_lightdiag  ),
    .Timing_Telemetry          (timing_telemetry  )

);

    always @ (posedge w_CLK_100M)
    begin
    	timing_stardiag1   <= timing_stardiag ;
      timing_lightdiag1  <= timing_lightdiag;
      timing_telemetry1  <= timing_telemetry;
      
    	timing_stardiag2   <= timing_stardiag1 ;
      timing_lightdiag2  <= timing_lightdiag1;
      timing_telemetry2  <= timing_telemetry1;             
    end

    assign w_timing_stardiag  = timing_stardiag  | timing_stardiag1  | timing_stardiag2;
    assign w_timing_lightdiag = timing_lightdiag | timing_lightdiag1 | timing_lightdiag2;
    assign w_timing_telemetry = timing_telemetry | timing_telemetry1 | timing_telemetry2;



   //-----------------------------------------------------------
   //-- GTX Module
   //-----------------------------------------------------------



    CMD_PROC_TX u1_CMD_PROC_TX(
    //-----------------------------------------------------------
    //-- reset, clocks
    //-----------------------------------------------------------
    .clk             (w_clk50),
    .rst_n           (w_rst_n),

    //-----------------------------------------------------------
    //-- GTX interface
    //-----------------------------------------------------------
    .TX_DATA         (w_TX_DATA_CMD1 ),
    .TXCTRL          (w_TXCTRL_CMD1  ),    // data: 00, ox02bc: 01
                     
    .CMD_TX          (w_CMD_TX  ),
    .CMD_Type        (w_CMD_Type),
    .CMD_Done        (w_CMD_Done)
    );

    assign w_TX_DATA_CMD = (vio_0)? w_TX_DATA_CMD1 : 16'h02bc; 
    assign w_TXCTRL_CMD  = (vio_0)? w_TXCTRL_CMD1 : 2'd1; 

    CMD_PROC_RX u1_CMD_PROC_RX(

    //-----------------------------------------------------------
    //-- reset, clocks
    //-----------------------------------------------------------
    .clk                  (w_clk50),
    .rst_n                (w_rst_n),

    //-----------------------------------------------------------
    //-- GTX interface
    //-----------------------------------------------------------
    .RX_DATA              (RX_DATA_IN),
    .RXCTRL               (RXCTRL_IN ),    // data: 00, ox02bc: 01

    .Reg_Second_p         (w_Reg_Second         ),
    .Reg_MicroSecond_p    (w_Reg_MicroSecond    ),
    .Reg_StarImageSend_p  (w_Reg_StarImageSend  ),
    .Reg_SendFreq_p       (w_Reg_SendFreq       ),
    .Reg_SpotSend_p       (w_Reg_SpotSend       ),
    .Reg_TdiLevel_p       (w_Reg_TdiLevel       ),
    .Reg_TdiTime_p        (w_Reg_TdiTime        ),

    
    .frm_end_d3            (frm_end_d3),
    .check_sum             (check_sum),
    .OpCode_1              (OpCode_1),
    .ChechSum_1            (ChechSum_1),

    .CMD_Cfg_Done         (w_CMD_Cfg_Done),
    .CMD_ShutDown         (w_CMD_ShutDown)
);






//-----------------------------------------------------------
//-- GTX Module
//-----------------------------------------------------------

//   IBUFGDS u1_BUFG_100M (
//       .O (w_CLK_100M),
//       .I (SYS_CLK_100M_P),
//       .IB (SYS_CLK_100M_N)
//       );
//
   IBUFGDS u2_BUFG_125M (
       .O (w_CLK_125M),
       .I (TOE_CLK_125M_P),
       .IB (TOE_CLK_125M_N)
       );


   always @(posedge GT0_TXUSRCLK2 or negedge w_rst_n)
   begin
      if ( w_rst_n == 1'b0 )
      begin
          TX_DATA_OUT <=   16'h02bc;
          TXCTRL_OUT  <=    2'b01;
      end
      else
      begin
          if (w_TXCTRL_CMD == 2'b00)
          begin
                TX_DATA_OUT <=   w_TX_DATA_CMD;
                TXCTRL_OUT  <=   w_TXCTRL_CMD;
          end
          else if (r_TXCTRL == 2'b00)
          begin
                TX_DATA_OUT <=   r_TX_DATA;
                TXCTRL_OUT  <=   r_TXCTRL;
          end
          else
          begin
                TX_DATA_OUT <=   16'h02bc;
                TXCTRL_OUT  <=    2'b01;
          end

      end
   end

//   assign w_tx_data_choose = (TXCTRL_OUT == 2'b00)? r_TX_DATA : 16'h02bc;
//   assign w_tx_ctrl_choose = (TXCTRL_OUT == 2'b00)? r_TXCTRL  : 2'b01;
   
//`ifdef SIMULATION
//
//`else
//
//
//   gtwizard_v2_7_exdes
//   #(
//     .EXAMPLE_CONFIG_INDEPENDENT_LANES     (1     ),  //configuration for frame gen and check
//     .STABLE_CLOCK_PERIOD                  (10    ),  // Period of the stable clock driving this init module, unit is [ns]
//     .EXAMPLE_LANE_WITH_START_CHAR         (0     ),  // specifies lane with unique start frame char
//     .EXAMPLE_WORDS_IN_BRAM                (512   ),  // specifies amount of data in BRAM
//     .EXAMPLE_SIM_GTRESET_SPEEDUP          ("TRUE"),  // simulation setting for GT SecureIP model
//     .EXAMPLE_USE_CHIPSCOPE                (0     ),  // Set to 1 to use Chipscope to drive resets
//     .EXAMPLE_SIMULATION                   (0     )   // Set to 1 for Simulation
//
//   )
//   u1_gtwizard_v2_7_exdes
//     (
//      //-- Reset, active low
//          //.SYSTEM_RESET                  ( w_rst_n            ),
//      //-- Clock
//          .Q0_CLK1_GTREFCLK_PAD_N_IN     (Q0_CLK1_GTREFCLK_PAD_N_IN      ),
//          .Q0_CLK1_GTREFCLK_PAD_P_IN     (Q0_CLK1_GTREFCLK_PAD_P_IN      ),
//          .DRP_CLK_IN                    (w_CLK_100M          ),
//          
//     //-- Data interface
//
//          .TRACK_DATA_OUT                (TRACK_DATA_OUT                    ),
//          .RXN_IN                        (RXN_IN          ),
//          .RXP_IN                        (RXP_IN          ),
//          .TXN_OUT                       (TXN_OUT          ),
//          .TXP_OUT                       (TXP_OUT          )
//    //--  user  interface
////          .GT0_TXUSRCLK2                 (GT0_TXUSRCLK2        ),
////          .TX_DATA_OUT                   (TX_DATA_OUT       ),
////          .TXCTRL_OUT                    (TXCTRL_OUT        ),
////
////          .GT0_RXUSRCLK2                 (        ),
////          .RX_DATA_IN                    (RX_DATA_IN           ),
////          .RXCTRL_IN                     (RXCTRL_IN            ),
////          .RXENMCOMMADET_OUT             (w_RXENMCOMMADET_OUT ),
////          .RXENPCOMMADET_OUT             (w_RXENPCOMMADET_OUT )
//      );
//
//`endif

  //-----------------------------------------------------------
  //-- Sync Detect
  //-----------------------------------------------------------

     sync_detect u1_sync_detect(
        .clk_100                (w_CLK_100M        ),
        .rst_n                  (w_rst_n           ),
        .sync_in_p              (FPGA_LVDS_1_P     ),
        .sync_in_n              (FPGA_LVDS_1_N     ),
        .o_sync_in              (w_sync_in         ),
        .sync_out               (w_sync_out        )
    );

     sync_detect u2_sync_detect(
        .clk_100                (w_CLK_100M        ),
        .rst_n                  (w_rst_n           ),
        .sync_in_p              (FPGA_LVDS_0_P     ),
        .sync_in_n              (FPGA_LVDS_0_N     ),
        .sync_out               (     )
    );

   //------------------------------------------------------------
   //-- TOE Module
   //------------------------------------------------------------
    toe_app u1_toe_app
    (

       .rst_n          (w_rst_n       ),
       .clk            (w_CLK_125M    ),
      //---------------------------------------------------------
      //--  flash interface
      //---------------------------------------------------------
       .wr_en          (w_wr_fifo     ),
       .wdata          (w_data_in     ),
       .rst_fifo       (w_rst_wfifo   ),
       .row            (w_row2        ),
       .write_en       (w_wr_flash    ),
       .erase_en       (w_era         ),
       .ready          (w_flash_busy  ),
       .done           (w_done_toe    ),    
    //-----------------------------------------------------------
    //--  toe interface
    //-----------------------------------------------------------
       .tx             (w_TOE_Tx      ),
       .tx_data        (w_TOE_TxData  ),
       .tx_chan        (w_TOE_TxChan  ),
       .tx_full        (w_TOE_TxFull  ),
    //-----------------------------------------------------------
    //--  rx toe interface
    //-----------------------------------------------------------
       .rx             (w_TOE_Rx     ), //w_rx
       .rx_data        (w_TOE_RxData ),//w_send_data
       .rx_chan        (w_TOE_RxChan ),
       .rx_full        (w_TOE_RxFull ),//w_rx_full
    //-----------------------------------------------------------
    //--  working state
    //-----------------------------------------------------------
       .busy           (w_TOE_Busy    )
);

   //RAM
   RAM_4096_16_SDP starparam(.clka   (w_CLK_100M)           ,
                             .ena    (w_ram_wr)             ,
                             .wea    (1'b1)                 ,
                             .addra  (w_ram_addr)           ,
                             .dina   (w_ram_data)           ,
                             .clkb   (w_clk50)              ,
                             .enb    (w_starparam_ram_rd)   ,
                             .addrb  (w_starparam_ram_addr) ,
                             .doutb  (w_starparam_ram_data)
                             );


   //------------------------------------------------------------
   //-- send Module
   //------------------------------------------------------------
//		data_send u1_send_data
//		(
//			.clk      (w_CLK_125M   ),
//			.rst_n    (w_rst_n      ),
//			.rx_full  (w_rx_full    ),
//			.rx       (w_rx         ),
//			.rx_data  (w_send_data  )
//		);
		
		
   //------------------------------------------------------------
   //-- FLASH Module
   //------------------------------------------------------------
   GigExPhyFIFO
    #(
        .CLOCK_RATE    ( 125000000  )
    )
    u1_GigExPhyFIFO (
        .CLK           (w_CLK_125M      ),

        //--------------------------------------
        //-- Interface to GigExpedite
        //--------------------------------------
        .GigEx_Clk     (TOE_HS0_CLK     ),   //: out std_logic;
        //-- Tx
        .GigEx_nTx     (TOE_nTX         ),   //: out std_logic;
        .GigEx_TxData  (TOE_D           ),   //: out std_logic_vector(7 downto 0);

        .GigEx_TxChan  (TOE_TC          ),   //: out std_logic_vector(2 downto 0);
        .GigEx_nTxFull (TOE_nTF         ),   //: in std_logic_vector(7 downto 0);

        //-- Rx
        .GigEx_nRx     (TOE_nRX         ),   //: in std_logic;
        .GigEx_RxData  (TOE_Q           ),   //: in std_logic_vector(7 downto 0);

        .GigEx_RxChan  (TOE_RC          ),   //: in std_logic_vector(2 downto 0);
        .GigEx_nRxFull (TOE_nRF         ),   //: out std_logic_vector(7 downto 0);
        .GigEx_nInt    (TOE_HS0_INTn    ),   //: in std_logic;

        //--------------------------------------
        //-- Application interface
        //--------------------------------------
        .UserTx        (w_TOE_Tx        ),    //: in std_logic;
        .UserTxChan    (w_TOE_TxChan    ),    //: in std_logic_vector(2 downto 0);
        .UserTxData    (w_TOE_TxData    ),    //: in std_logic_vector(7 downto 0);
        .UserRxFull    (w_TOE_RxFull    ),    //: in std_logic_vector(7 downto 0);
        .UserRx        (w_TOE_Rx        ),    //: out std_logic;
        .UserRxChan    (w_TOE_RxChan    ),    //: out std_logic_vector(2 downto 0);
        .UserRxData    (w_TOE_RxData    ),    //: out std_logic_vector(7 downto 0);
        .UserTxFull    (w_TOE_TxFull    ),    //: out std_logic_vector(7 downto 0);
        .UserInterrupt (w_TOE_Interrupt )    //: out std_logic
    );




   //-----------------------------------------------------------
   //-- TX Module
   //-----------------------------------------------------------
   
      reg r_move_done;
      reg r_move_done1;
      reg r_move_done2;
      
     data_tx u1_data_tx(
        .rst_n              (w_rst_n              ),
        .sys_clk            (w_clk50              ), //50m
        .sys_clk_100m       (w_CLK_100M           ),
        .timing_telemetry   (w_timing_telemetry   ),
        .timing_lightdiag   (w_timing_lightdiag   ),
        .timing_stardiag    (w_timing_stardiag    ),//    )r_move_done
        .transmit_done      (w_transmit_done      ),
        .tx_data            (r_TX_DATA            ),
        .tx_control         (r_TXCTRL             ),
        .data_cnt           (data_cnt),
        .p_choose           (p_choose),
        .rd_req             (w_rd_req             ),
        .sram_raddr         (w_sram_raddr         ),
        .fifo_wr_en         (w_fifo_wr_en         ),
        .fifo_wdata         (w_fifo_wdata_n       ),
//        .control            (CONTROL0           ),
        .starparam_ram_rd   (w_starparam_ram_rd   ),
        .starparam_ram_addr (w_starparam_ram_addr ),
        .starparam_ram_data (w_starparam_ram_data )
       );

       assign w_fifo_wdata_n = {w_fifo_wdata[15:0],w_fifo_wdata[31:16]};
       
   //------------------------------------------------------------
   //-- FLASH Module
   //------------------------------------------------------------

   flash_control u1_flash_control(
        .clk            (w_CLK_125M    ),
        .wr_clk         (w_CLK_125M    ),
        .rd_clk         (w_CLK_100M    ),
        .rst_n          (w_rst_n       ),
        .wr_fifo        (w_wr_fifo     ),
        .rd_fifo        (w_rd_fifo     ),
        .data_in        (w_data_in     ),
        .data_out       (w_data_out    ),
        .data_valid     (w_data_valid  ),
        .row            (w_row         ),
        .era            (w_era         ),
        .wr_flash       (w_wr_flash    ),
        .rd_flash       (w_rd_flash    ),
        .A              (FPGA_A        ),
        .dq             (FPGA_D        ),
        .oe             (FPGA_FOE_N    ),
        .ce             (FPGA_FCS      ),
        .we             (FPGA_FWE_N    ),
        .adv            (FPGA_ADV_B    ),
        .wd             (FPGA_WAIT     ),
        .wp             (FPGA_FPE_N    ),
        .rst_f          (FPGA_INIT_B_1 ),
        .rst_wfifo      (w_rst_wfifo   ),
        .rst_rfifo      (w_rst_rfifo   ),
        .clk_f          (FPGA_CCLK_1   ),
        .o_read_data    (read_data     ),
        .o_read_valid   (read_valid    ),
        .busy           (w_flash_busy  ),
        .done_toe       (w_done_toe    ),
        .done_move      (w_done_move   )
      );
    wire  o_fifo_rd_en;
    wire  o_empty     ;
    wire [8:0] o_state;
    //-----------------------------------------------------------
    //-- DATA Move
    //-----------------------------------------------------------
    data_move u1_data_move(
      .clk               (w_CLK_100M    ),
      .rst_n             (w_rst_n       ),
      .enable            (Data_Move_En  ),
      .flash_done        (w_done_move   ),
      .flash_in          (w_data_out    ),
      .fifo_rd_en        (w_fifo_rd_en  ),
//		.CONTROL0          (CONTROL0      ),
      .busy              (w_d_move_busy ),
      .done              (w_move_done   ),
      .row               (w_row1        ),
      .rd_req            (w_rd_flash    ),
      .rd_en             (w_rd_fifo     ),
      .rst_rfifo         (w_rst_rfifo   ),
      .wr_req            (w_wr_req      ),
      .sram_waddr        (w_sram_waddr  ),
      .sram_rdata        (w_sram_rdata  ),
      .o_empty           (o_empty       ),
      .o_fifo_rd_en      (o_fifo_rd_en  ),
      .o_state           (o_state       ),
      .ram_wr            (w_ram_wr      ),
      .ram_addr          (w_ram_addr    ),
      .ram_data          (w_ram_data    )
      );
        
        always @ (posedge w_CLK_100M or negedge w_rst_n)
        if(!w_rst_n)
          r_move_done1 <= 0;
        else
          r_move_done1 <= w_move_done;
          
        always @ (posedge w_CLK_100M or negedge w_rst_n)
        if(!w_rst_n)
          r_move_done2 <= 0;
        else
          r_move_done2 <= r_move_done1; 
          
        always @ (posedge w_CLK_100M or negedge w_rst_n)
        if(!w_rst_n)
          r_move_done <= 0;
        else
          r_move_done <= r_move_done2;      
    //-----------------------------------------------------------
    //-- SRAM  Module
    //-----------------------------------------------------------
   m_sram_controller u1_sram_controller(
       .clk_in            (w_CLK_100M     ),
       .rst_n             (w_rst_n        ),
       .sram_clk_out      (SBRAM_CLK      ),
       .sram_adsp_n_out   (SBRAM_nADSP    ),
       .sram_adsc_n_out   (SBRAM_nADSC    ),
       .sram_adv_n_out    (SBRAM_nADV     ),
       .sram_ce1_n_out    (SBRAM_nCE1     ),
       .sram_ce2_p_out    (SBRAM_CE2      ),
       .sram_ce2_n_out    (SBRAM_nCE2     ),
       .sram_gw_n_out     (SBRAM_nGW      ),
       .sram_bwe_n_out    (SBRAM_nBWE     ),
       .sram_bwa_n_out    (SBRAM_nBWA     ),
       .sram_bwb_n_out    (SBRAM_nBWB     ),
       .sram_bwc_n_out    (SBRAM_nBWC     ),
       .sram_bwd_n_out    (SBRAM_nBWD     ),
       .sram_addr_out     (SBRAM_A        ),
       .sram_rd_en_out    (SBRAM_nOE      ),
       .sram_data_inout   (SBRAM_DQ       ),
       .sram_data_p_inout (               ),
//	   .CONTROL0          (CONTROL0       ),

        //-------------------------------------------------------
        //-- Application interface
        //-------------------------------------------------------

       .wr_req            (w_wr_req       ),
       .sram_waddr        (w_sram_waddr   ),
       .fifo_rd_en        (w_fifo_rd_en   ),
       .fifo_rdata        (w_sram_rdata   ),
       .rd_req            (w_rd_req       ),
       .sram_raddr        (w_sram_raddr   ),
       .fifo_wr_en        (w_fifo_wr_en   ),
       .fifo_wdata        (w_fifo_wdata   )
);



     
/*

   `ifdef SIMULATION
   //-- 50MHz clock
   sysclkgen
   #(
    .CLK_PERIOD   (20 ),
    .HIGH_PERIOD  (10 )
   )
   u1_sysclkgen
   (
    .clk      (w_clk50 )
   );

   
    //-----------------------------------------------------------
    //-- GTX interface simulation
    //-----------------------------------------------------------
     tb_GTX_sim u1_tb_GTX_sim(
       //-----------------------------------------------------------
       //-- reset, clocks
       //-----------------------------------------------------------
       .clk               (w_clk50),
       .rst_n             (w_rst_n),

       //-----------------------------------------------------------
       //-- GTX interface
       //-----------------------------------------------------------
       .TX_DATA          (RX_DATA_IN),
       .TXCTRL           (RXCTRL_IN ),    // data: 00, ox02bc: 01

       .RX_DATA          (r_TX_DATA ),
       .RXCTRL           (r_TXCTRL  )      // data: 00, ox02bc: 01
     );

   `endif
*/
//   wire [35:0]CONTROL0;


	wire [255:0]TRIG0;
	wire [255:0]TRIG1;
	wire [255:0]TRIG2;
	wire [255:0]TRIG3;
//
//	assign TRIG0[7:0]     = read_cnt     ;
	assign TRIG0[8]       = w_era        ;
                                       
	assign TRIG0[10]      = w_rd_fifo    ;
	assign TRIG0[11]      = w_wr_fifo    ;
	assign TRIG0[12]      = w_rd_flash   ;
	assign TRIG0[13]      = w_wr_flash   ;	
//	assign TRIG0[45:14]   = w_sram_rdata ;
	
	assign TRIG0[40:14]   = FPGA_A       ;
	assign TRIG0[41]      = w_data_valid ;
	assign TRIG0[42]      = w_rd_fifo	   ;
	assign TRIG0[43]      = w_wr_fifo	   ;
	assign TRIG0[77:46]   = w_fifo_wdata ;

	assign TRIG0[78]      = w_wr_req     ;
	assign TRIG0[79]      = w_fifo_rd_en ;	
	assign TRIG0[80]      = w_fifo_wr_en ;
	assign TRIG0[81]      = w_rd_req     ;
	assign TRIG0[97:82]   = w_data_in    ; 
	assign TRIG0[113:98]  = w_data_out   ;
	assign TRIG0[114]     = w_done_toe   ;
	
	assign TRIG0[128:115] = w_row1;	
  assign TRIG0[131]     = frm_end_d3;
  assign TRIG0[148:132] = check_sum;  
  assign TRIG0[164:149] = FPGA_D; 
  //assign TRIG0[164:149] = ChechSum_1;
//  assign TRIG0[152:149] = o_state;

  assign TRIG0[166:165] = p_choose;  
  assign TRIG0[167]     = w_sync_out;
  assign TRIG0[168]     = w_sync_in;
  assign TRIG0[169]     = w_done_move;  
  assign TRIG0[170]     = o_empty;
  assign TRIG0[171]     = o_fifo_rd_en;    
  assign TRIG0[180:172] = o_state;
	assign TRIG0[194:181] = w_row2;	
	
	assign TRIG0[195]     = FPGA_WAIT;
  assign TRIG0[196]     = Data_Move_En; 

  assign TRIG0[197]     = FPGA_FOE_N; 
  assign TRIG0[198]     = FPGA_FCS;     
  assign TRIG0[199]     = FPGA_FWE_N; 
  assign TRIG0[200]     = FPGA_ADV_B; 
       
//	assign TRIG0[155:154] = TXCTRL_OUT    ;
//	assign TRIG0[171:156] = TX_DATA_OUT   ;
//  assign TRIG0[173:172] = r_TXCTRL      ;
//	assign TRIG0[189:174] = r_TX_DATA     ;
//	assign TRIG0[191:190] = w_TXCTRL_CMD  ;
//	assign TRIG0[207:192] = w_TX_DATA_CMD ;
	assign TRIG0[208]     = w_CMD_Cfg_Done  ;
	assign TRIG0[209]     = w_CMD_ShutDown ;	
	assign TRIG0[210]     = w_TOE_Busy     ;
	assign TRIG0[211]     = w_d_move_busy  ;
	assign TRIG0[212]     = w_move_done ;
	assign TRIG0[213]     = w_CMD_TX  ;
	assign TRIG0[215:214] = w_CMD_Type ;	
	assign TRIG0[216]     = w_CMD_Done ;
	assign TRIG0[222:217] = fsm_curr  ;
	assign TRIG0[223]     = w_Frm_Tx_En ;			
	assign TRIG0[224]     = w_sync_out ;
	assign TRIG0[225]     = w_timing_lightdiag  ;
	assign TRIG0[226]     = w_timing_stardiag ;			
	assign TRIG0[227]     = w_timing_telemetry ;

  assign TRIG0[243:228] = read_data;
  assign TRIG0[244]     = read_valid;	
//	assign TRIG0[229:228] = RXCTRL_IN  ;
//	assign TRIG0[245:230] = RX_DATA_IN  ;
//	assign TRIG0[250:246] = read_st;
	assign TRIG0[251]     = w_flash_busy;
  

	   
  assign TRIG1[1] = w_done_move;     
  assign TRIG1[17:2] = w_data_out;
  assign TRIG1[18] = w_fifo_rd_en;
  assign TRIG1[19] = w_flash_busy;
  assign TRIG1[20] = w_move_done;
  assign TRIG1[34:21] = w_row1;
  assign TRIG1[35] = w_rd_flash;
  assign TRIG1[36] = w_rd_fifo;
  assign TRIG1[37] = w_wr_req;
  assign TRIG1[61:38] = w_sram_waddr;
  assign TRIG1[93:62] = w_sram_rdata;
  assign TRIG1[94] = w_ram_wr;
  assign TRIG1[110:95] = w_ram_data;
  assign TRIG1[111] = Data_Move_En;
  assign TRIG1[112] = w_TOE_Busy;
  assign TRIG1[113] = w_d_move_busy;
  assign TRIG1[119:114] = fsm_curr;

  
   assign  TRIG2[0]   = w_wr_req;
	assign  TRIG2[24:1] = w_sram_waddr;
	assign  TRIG2[25] = w_fifo_rd_en;
	assign  TRIG2[57:26] = w_sram_rdata;
	
	assign  TRIG2[78:58]  =  SBRAM_A;	          
	assign  TRIG2[79]      =  w_rd_req;
	assign  TRIG2[103:80]  =  w_sram_raddr;
	assign  TRIG2[104]     =  w_fifo_wr_en;
   assign  TRIG2[136:105] =  w_fifo_wdata; 
  
	assign  TRIG2[137]    =  SBRAM_nOE;	 
	assign  TRIG2[138]    =  SBRAM_nADSP;
	assign  TRIG2[139]    =  SBRAM_nADSC;
	assign  TRIG2[140]    =  SBRAM_nADV;
	assign  TRIG2[141]    =  SBRAM_nCE1;
	assign  TRIG2[142]    =  SBRAM_CE2;
	assign  TRIG2[143]    =  SBRAM_nCE2;
	assign  TRIG2[144]    =  SBRAM_nGW;
	assign  TRIG2[145]    =  SBRAM_nBWE;
	assign  TRIG2[146]    =  SBRAM_nBWA;
	assign  TRIG2[147]    =  SBRAM_nBWB;
	assign  TRIG2[148]    =  SBRAM_nBWC;
	assign  TRIG2[149]    =  SBRAM_nBWD;
	assign  TRIG2[150]    =  SBRAM_nGW;
	
	assign  TRIG3[127:0]  =  SBRAM_DQ;	
	
	assign  TRIG3[128]  =  w_wr_fifo;   
   assign  TRIG3[144:129]  =  w_data_in;   
 
   assign  TRIG3[159:146]  =  w_row2;     
   assign  TRIG3[160]  =  w_wr_flash;
   assign  TRIG3[161]  =  w_era;
   assign  TRIG3[162]  =  w_flash_busy;   
   assign  TRIG3[164:163] = w_TOE_RxFull;
	


	ILA1 ila1 (
		 .CONTROL(CONTROL0), // INOUT BUS [35:0]
		 .CLK(w_CLK_125M), // IN
		 .TRIG0(TRIG0), // IN BUS 
		 .TRIG1(TRIG1), // IN BUS 
		 .TRIG2(TRIG2), // IN BUS 
		 .TRIG3(TRIG3)  // IN BUS 
	);
	
  vio vio (
    .CONTROL(CONTROL1), // INOUT BUS [35:0]
    .ASYNC_IN(8'd0 ), // IN BUS [7:0]
    .ASYNC_OUT(ASYNC_OUT) // OUT BUS [7:0]
);

    assign vio_0 = ASYNC_OUT[0]; 
endmodule