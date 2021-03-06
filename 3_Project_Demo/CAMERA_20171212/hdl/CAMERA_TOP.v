////////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version : 2.7
//  \   \         Application : 7 Series FPGAs Transceivers Wizard
//  /   /         Filename : gtwizard_v2_7_exdes.v
// /___/   /\
// \   \  /  \
//  \___\/\___\
//
//
// Module gtwizard_v2_7_exdes
// Generated by Xilinx 7 Series FPGAs Transceivers Wizard
//
//
// (c) Copyright 2010-2012 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.


`timescale 1ns / 1ps
`define DLY #1


//***********************************Entity Declaration************************
(* CORE_GENERATION_INFO = "gtwizard_v2_7,gtwizard_v2_7,{protocol_file=aurora_8b10b_single_lane_2byte}" *)
module CAMERA_TOP
(

    //-----------------------------------------------------------
    //-- reset, clocks
    //-----------------------------------------------------------

    input  wire         SYS_CLK_100M_P    ,
    input  wire         SYS_CLK_100M_N    ,
    input  wire         FPGA_RST_N        ,

    //-----------------------------------------------------------
    //-- GTX interface
    //-----------------------------------------------------------
    input  wire         FPGA_GTX115_0P    ,//clock
    input  wire         FPGA_GTX115_0N    ,
    input  wire         Q0_CLK1_GTREFCLK_PAD_P_IN    ,
    input  wire         Q0_CLK1_GTREFCLK_PAD_N_IN    ,

    output wire         TXP_OUT        ,
    output wire         TXN_OUT        ,
    input wire          RXP_IN        ,
    input wire          RXN_IN        ,

    input  wire         FPGA_GTX118_0P    ,//clock
    input  wire         FPGA_GTX118_0N    ,
    input  wire         FPGA_GTX118_1P    ,
    input  wire         FPGA_GTX118_1N    ,

    output wire         MGTX0_TX_P        ,
    output wire         MGTX0_TX_N        ,
    input  wire         MGTX0_RX_P        ,
    input  wire         MGTX0_RX_N        ,


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
    wire             w_CLK_100M;
    wire             w_temp_rst_m;
    wire             GT0_TXUSRCLK2;
    wire             GT0_RXUSRCLK2;

    wire    [15:0]    TX_DATA_OUT;
    wire    [1:0]     TXCTRL_OUT ;

    wire    [15:0]    RX_DATA_IN ;
    wire    [1:0]     RXCTRL_IN  ;
    wire              DRP_CLK_IN ;
	 
	 wire    [35:0]    CONTROL0   ; 
	 wire    [35:0]    CONTROL1   ; 	 
	 wire    [35:0]    CONTROL2   ; 	 
	 wire    [35:0]    CONTROL3   ; 	 
	 wire    [35:0]    CONTROL4   ; 	 
	 wire    [35:0]    CONTROL5   ; 	 
   wire    [35:0]    CONTROL6   ;  
   wire    [35:0]    CONTROL7   ;  
 assign  DRP_CLK_IN = w_CLK_100M ;
 
 
 //---------------------------------------------------------------
//PLL����
//---------------------------------------------------------------
     clk_ctrl u1_clk_ctrl(
        .clk_100m_p         (SYS_CLK_100M_P ),
        .clk_100m_n         (SYS_CLK_100M_N ),
        .clk_100m_out       (w_CLK_100M     ),
        .rst_n              (1'b1           ),
        .locked             (w_temp_rst_m   )
    );

 CAMERA_SIM u1_CAMERA_SIM(

    //-----------------------------------------------------------
    //-- reset, clocks
    //-----------------------------------------------------------

   
    .w_CLK_100M     (w_CLK_100M     ),
    .FPGA_RST_N        (FPGA_RST_N     ),
	  .CONTROL0          (CONTROL6       ),
	  .CONTROL1          (CONTROL7       ),
    //-----------------------------------------------------------
    //-- GTX interface
    //-----------------------------------------------------------

    .GT0_TXUSRCLK2     (GT0_TXUSRCLK2 ),
    .GT0_RXUSRCLK2     (GT0_RXUSRCLK2 ),
    .TX_DATA_OUT       (TX_DATA_OUT   ),
    .TXCTRL_OUT        (TXCTRL_OUT    ),
    .RX_DATA_IN        (RX_DATA_IN    ),
    .RXCTRL_IN         (RXCTRL_IN     ),


    //-----------------------------------------------------------
    //-- SYNC  interface
    //-----------------------------------------------------------
    .FPGA_LVDS_0_P              ( FPGA_LVDS_0_P   ),
    .FPGA_LVDS_0_N              ( FPGA_LVDS_0_N   ),

    .FPGA_LVDS_1_P              ( FPGA_LVDS_1_P   ),
    .FPGA_LVDS_1_N              ( FPGA_LVDS_1_N   ),

    //-----------------------------------------------------------
    //-- TOE
    //-----------------------------------------------------------
    .TOE_CLK_125M_P    (TOE_CLK_125M_P     ),
    .TOE_CLK_125M_N    (TOE_CLK_125M_N     ),
    .TOE_HS0_CLK       (TOE_HS0_CLK        ),
    .TOE_HS0_INTn      (TOE_HS0_INTn       ),//High Speed Interface Interrupt
    .TOE_Q             (TOE_Q              ),//Read data
    .TOE_D             (TOE_D              ),//Transfer data
    .TOE_TC            (TOE_TC             ),//Transfer channal address
    .TOE_RC            (TOE_RC             ),//Read channal address
    .TOE_nTX           (TOE_nTX            ),//Transfer enable, active low
    .TOE_nRX           (TOE_nRX            ),//Read enable flag, active low
    .TOE_nTF           (TOE_nTF            ),//Transfer full flag, active low
    .TOE_nRF           (TOE_nRF            ),//Read full flag, active low

    /*
    output wire         TOE_HS0_CTS_SCSn      ,// Active low ,slave SPI chip select.
    output wire         TOE_HS0_RTS_SSCK      ,//Slave SPI clock signal.
    input  wire         TOE_HS0_TXD_SMOSI     ,
    output wire         TOE_HS0_RXD_SMISO     ,
    */



    //-----------------------------------------------------------
    //-- FLASH
    //-----------------------------------------------------------
    .FPGA_A            (FPGA_A       ),
    .FPGA_D            (FPGA_D       ),
    .FPGA_FWE_N        (FPGA_FWE_N   ),//write enable,active low
    .FPGA_FPE_N        (FPGA_FPE_N   ),//write protect,active low
    .FPGA_ADV_B        (FPGA_ADV_B   ),//address valid,active low
    .FPGA_INIT_B_1     (FPGA_INIT_B_1),//reset,active low
    .FPGA_FOE_N        (FPGA_FOE_N   ),//output enable,active low
    .FPGA_FCS          (FPGA_FCS     ),//chip enable,active low
    .FPGA_WAIT         (FPGA_WAIT    ),
    .FPGA_CCLK_1       (FPGA_CCLK_1  ),

    //-----------------------------------------------------------
    //-- SRAM
    //-----------------------------------------------------------
    .SBRAM_CLK        (SBRAM_CLK     ),
    .SBRAM_A          (SBRAM_A       ),
    .SBRAM_DQ         (SBRAM_DQ      ),//data
    .SBRAM_DQP        (SBRAM_DQP     ),//parity data
    .SBRAM_nCE1       (SBRAM_nCE1    ),
    .SBRAM_CE2        (SBRAM_CE2     ),
    .SBRAM_nCE2       (SBRAM_nCE2    ),
    .SBRAM_nBWA       (SBRAM_nBWA    ),//byte write control
    .SBRAM_nBWB       (SBRAM_nBWB    ),
    .SBRAM_nBWC       (SBRAM_nBWC    ),
    .SBRAM_nBWD       (SBRAM_nBWD    ),
    .SBRAM_nBWE       (SBRAM_nBWE    ),//write enable
    .SBRAM_nADSC      (SBRAM_nADSC   ),//address status Controller
    .SBRAM_nADSP      (SBRAM_nADSP   ),//address status processor
    .SBRAM_nADV       (SBRAM_nADV    ),//
    .SBRAM_nGW        (SBRAM_nGW     ),//global write enable
    .SBRAM_nOE        (SBRAM_nOE     ),
    .TRACK_DATA_OUT   (TRACK_DATA_OUT)

);





  gtwizard_v2_7_exdes  #
 (
     .EXAMPLE_CONFIG_INDEPENDENT_LANES    (1      ),//configuration for frame gen and check
     .STABLE_CLOCK_PERIOD                 (10     ), // Period of the stable clock driving this init module, unit is [ns]
     .EXAMPLE_LANE_WITH_START_CHAR        (0      ), // specifies lane with unique start frame char
     .EXAMPLE_WORDS_IN_BRAM               (512    ), // specifies amount of data in BRAM
     .EXAMPLE_SIM_GTRESET_SPEEDUP         ("TRUE" ), // simulation setting for GT SecureIP model
     .EXAMPLE_USE_CHIPSCOPE               (1      ), // Set to 1 to use Chipscope to drive resets
     .EXAMPLE_SIMULATION                  (0      )  // Set to 1 for Simulation

 )
 u1_gtwizard_v2_7_exdes
 (//   input wire  SYSTEM_RESET,
      .Q0_CLK1_GTREFCLK_PAD_N_IN (Q0_CLK1_GTREFCLK_PAD_N_IN),
      .Q0_CLK1_GTREFCLK_PAD_P_IN (Q0_CLK1_GTREFCLK_PAD_P_IN),
      .DRP_CLK_IN                (DRP_CLK_IN               ),
      .TRACK_DATA_OUT            (TRACK_DATA_OUT           ),
      .RXN_IN                    (RXN_IN                   ),
      .RXP_IN                    (RXP_IN                   ),
      .TXN_OUT                   (TXN_OUT                  ),
      .TXP_OUT                   (TXP_OUT                  ),

     .GT0_TXUSRCLK2              (GT0_TXUSRCLK2            ),
     .GT0_RXUSRCLK2              (GT0_RXUSRCLK2            ),
     .TX_DATA_OUT                (TX_DATA_OUT              ),
     .TXCTRL_OUT                 (TXCTRL_OUT               ),
     .RX_DATA_IN                 (RX_DATA_IN               ),
     .RXCTRL_IN                  (RXCTRL_IN                ),
     .CONTROL0                   (CONTROL0),
     .CONTROL1                   (CONTROL1),
     .CONTROL2                   (CONTROL2),
     .CONTROL3                   (CONTROL3),
     .CONTROL4                   (CONTROL4),
     .CONTROL5                   (CONTROL5)
 //    .RXENMCOMMADET_OUT          (RXENMCOMMADET_OUT        ),
 //    .RXENPCOMMADET_OUT          (RXENPCOMMADET_OUT        )
 //



 );

	ICON_TOP icon (
		.CONTROL0(CONTROL0),
		.CONTROL1(CONTROL1),	 // INOUT BUS [35:0]
	  .CONTROL2(CONTROL2),
	  .CONTROL3(CONTROL3),
	  .CONTROL4(CONTROL4),
	  .CONTROL5(CONTROL5),
	  .CONTROL6(CONTROL6),
	  .CONTROL7(CONTROL7)
	);

















endmodule













