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
module gtwizard_v2_7_exdes #
(
    parameter EXAMPLE_CONFIG_INDEPENDENT_LANES     =   1,//configuration for frame gen and check
    parameter STABLE_CLOCK_PERIOD                  =   10, // Period of the stable clock driving this init module, unit is [ns]
    parameter EXAMPLE_LANE_WITH_START_CHAR         =   0,         // specifies lane with unique start frame char
    parameter EXAMPLE_WORDS_IN_BRAM                =   512,       // specifies amount of data in BRAM
    parameter EXAMPLE_SIM_GTRESET_SPEEDUP          =   "TRUE",    // simulation setting for GT SecureIP model
    parameter EXAMPLE_USE_CHIPSCOPE                =   1,         // Set to 1 to use Chipscope to drive resets
    parameter EXAMPLE_SIMULATION                   =   0          // Set to 1 for Simulation

)
(//   input wire  SYSTEM_RESET,
    input wire  Q0_CLK1_GTREFCLK_PAD_N_IN,
    input wire  Q0_CLK1_GTREFCLK_PAD_P_IN,
    input wire  DRP_CLK_IN,
    output wire TRACK_DATA_OUT,
    input  wire         RXN_IN,
    input  wire         RXP_IN,
    output wire         TXN_OUT,
    output wire         TXP_OUT,
//************************** user interface ****************************
    output wire            GT0_TXUSRCLK2,
    output wire            GT0_RXUSRCLK2,
    
    input  wire  [15:0]    TX_DATA_OUT,
    input  wire  [1:0]     TXCTRL_OUT,
    
    output wire [15:0]     RX_DATA_IN,
    output wire [1:0]      RXCTRL_IN ,
    inout  wire [35:0]     CONTROL0,
    inout  wire [35:0]     CONTROL1,
    inout  wire [35:0]     CONTROL2,
    inout  wire [35:0]     CONTROL3,
    inout  wire [35:0]     CONTROL4,
    inout  wire [35:0]     CONTROL5      
//    input  wire            RXENMCOMMADET_OUT,
//    input  wire            RXENPCOMMADET_OUT
    
    

);


//************************** Register Declarations ****************************
//
//    wire            GT0_TXUSRCLK2;
//    wire            GT0_RXUSRCLK2;
//    
//    wire  [15:0]    TX_DATA_OUT;
//    wire  [1:0]     TXCTRL_OUT;
//    
//    wire [15:0]     RX_DATA_IN;
//    wire [1:0]      RXCTRL_IN ;
//    wire            RXENMCOMMADET_OUT;
//    wire            RXENPCOMMADET_OUT;
//    




    wire            gt0_txfsmresetdone_i;
    wire            gt0_rxfsmresetdone_i;
    reg             gt0_txfsmresetdone_r;
    reg             gt0_txfsmresetdone_r2;
    reg             gt0_rxresetdone_r;
    reg             gt0_rxresetdone_r2;
    reg             gt0_rxresetdone_r3;

    reg [5:0] reset_counter = 0;
    reg     [3:0]   reset_pulse;

//**************************** Wire Declarations ******************************//
    //------------------------ GT Wrapper Wires ------------------------------
    //________________________________________________________________________
    //________________________________________________________________________
    //GT0   (X1Y0)
    //------------------------------- CPLL Ports -------------------------------
    wire            gt0_cpllfbclklost_i;
    wire            gt0_cplllock_i;
    wire            gt0_cpllrefclklost_i;
    wire            gt0_cpllreset_i;
    //-------------------------- Channel - DRP Ports  --------------------------
    wire    [8:0]   gt0_drpaddr_i;
    wire    [15:0]  gt0_drpdi_i;
    wire    [15:0]  gt0_drpdo_i;
    wire            gt0_drpen_i;
    wire            gt0_drprdy_i;
    wire            gt0_drpwe_i;
    //----------------------------- Loopback Ports -----------------------------
    wire    [2:0]   gt0_loopback_i;
    //---------------------------- Power-Down Ports ----------------------------
    wire    [1:0]   gt0_rxpd_i;
    wire    [1:0]   gt0_txpd_i;
    //------------------- RX Initialization and Reset Ports --------------------
    wire            gt0_rxuserrdy_i;
    //------------------------ RX Margin Analysis Ports ------------------------
    wire            gt0_eyescandataerror_i;
    //----------------------- Receive Ports - CDR Ports ------------------------
    wire            gt0_rxcdrlock_i;
    //----------------- Receive Ports - Clock Correction Ports -----------------
    wire    [1:0]   gt0_rxclkcorcnt_i;
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
    wire    [15:0]  gt0_rxdata_i;
    //---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
    wire    [1:0]   gt0_rxdisperr_i;
    wire    [1:0]   gt0_rxnotintable_i;
    //------------------------- Receive Ports - RX AFE -------------------------
    wire            gt0_gtxrxp_i;
    //---------------------- Receive Ports - RX AFE Ports ----------------------
    wire            gt0_gtxrxn_i;
    //----------------- Receive Ports - RX Buffer Bypass Ports -----------------
    wire    [2:0]   gt0_rxbufstatus_i;
    //------------ Receive Ports - RX Byte and Word Alignment Ports ------------
    wire            gt0_rxbyterealign_i;
    wire            gt0_rxmcommaalignen_i;
    wire            gt0_rxpcommaalignen_i;
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    wire            gt0_rxoutclk_i;
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
    wire            gt0_gtrxreset_i;
    wire            gt0_rxpmareset_i;
    //--------------- Receive Ports - RX Polarity Control Ports ----------------
    wire            gt0_rxpolarity_i;
    //----------------- Receive Ports - RX8B/10B Decoder Ports -----------------
    wire    [1:0]   gt0_rxchariscomma_i;
    wire    [1:0]   gt0_rxcharisk_i;
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
    wire            gt0_rxresetdone_i;
    //------------------- TX Initialization and Reset Ports --------------------
    wire            gt0_gttxreset_i;
    wire            gt0_txuserrdy_i;
    //-------------------- Transmit Ports - TX Buffer Ports --------------------
    wire    [1:0]   gt0_txbufstatus_i;
    //---------------- Transmit Ports - TX Data Path interface -----------------
    wire    [15:0]  gt0_txdata_i;
    //-------------- Transmit Ports - TX Driver and OOB signaling --------------
    wire            gt0_gtxtxn_i;
    wire            gt0_gtxtxp_i;
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
    wire            gt0_txoutclk_i;
    wire            gt0_txoutclkfabric_i;
    wire            gt0_txoutclkpcs_i;
    //------------------- Transmit Ports - TX Gearbox Ports --------------------
    wire    [1:0]   gt0_txcharisk_i;
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
    wire            gt0_txresetdone_i;

    //____________________________COMMON PORTS________________________________
    //----------------------- Common Block - QPLL Ports ------------------------
    wire            gt0_qplllock_i;
    wire            gt0_qpllrefclklost_i;
    wire            gt0_qpllreset_i;


    //----------------------------- Global Signals -----------------------------

    wire            drpclk_in_i;
    wire            gt0_tx_system_reset_c;
    wire            gt0_rx_system_reset_c;
    wire            tied_to_ground_i;
    wire    [63:0]  tied_to_ground_vec_i;
    wire            tied_to_vcc_i;
    wire    [7:0]   tied_to_vcc_vec_i;
    wire            GTTXRESET_IN;
    wire            GTRXRESET_IN;
    wire            CPLLRESET_IN;
    wire            QPLLRESET_IN;

     //--------------------------- User Clocks ---------------------------------
    (* keep = "TRUE" *) wire            gt0_txusrclk_i;
    (* keep = "TRUE" *) wire            gt0_txusrclk2_i;
    (* keep = "TRUE" *) wire            gt0_rxusrclk_i;
    (* keep = "TRUE" *) wire            gt0_rxusrclk2_i;

    //--------------------------- Reference Clocks ----------------------------

    wire            q0_clk1_refclk_i;


    //--------------------- Frame check/gen Module Signals --------------------
    wire            gt0_matchn_i;

    wire    [5:0]   gt0_txcharisk_float_i;

    wire    [15:0]  gt0_txdata_float16_i;
    wire    [47:0]  gt0_txdata_float_i;


    wire            gt0_block_sync_i;
    wire            gt0_track_data_i;
    wire    [7:0]   gt0_error_count_i;
    wire            gt0_frame_check_reset_i;
    wire            gt0_inc_in_i;
    wire            gt0_inc_out_i;
    wire    [15:0]  gt0_unscrambled_data_i;

    wire            reset_on_data_error_i;
    wire            track_data_out_i;


    //--------------------- Chipscope Signals ---------------------------------

    wire    [35:0]  tx_data_vio_control_i;
    wire    [35:0]  rx_data_vio_control_i;
    wire    [35:0]  shared_vio_control_i;
    wire    [35:0]  ila_control_i;
    wire    [35:0]  channel_drp_vio_control_i;
    wire    [35:0]  common_drp_vio_control_i;
    wire    [31:0]  tx_data_vio_async_in_i;
    wire    [31:0]  tx_data_vio_sync_in_i;
    wire    [31:0]  tx_data_vio_async_out_i;
    wire    [31:0]  tx_data_vio_sync_out_i;
    wire    [31:0]  rx_data_vio_async_in_i;
    wire    [31:0]  rx_data_vio_sync_in_i;
    wire    [31:0]  rx_data_vio_async_out_i;
    wire    [31:0]  rx_data_vio_sync_out_i;
    wire    [31:0]  shared_vio_in_i;
    wire    [31:0]  shared_vio_out_i;
    wire    [163:0] ila_in_i;
    wire    [31:0]  channel_drp_vio_async_in_i;
    wire    [31:0]  channel_drp_vio_sync_in_i;
    wire    [31:0]  channel_drp_vio_async_out_i;
    wire    [31:0]  channel_drp_vio_sync_out_i;
    wire    [31:0]  common_drp_vio_async_in_i;
    wire    [31:0]  common_drp_vio_sync_in_i;
    wire    [31:0]  common_drp_vio_async_out_i;
    wire    [31:0]  common_drp_vio_sync_out_i;

    wire    [31:0]  gt0_tx_data_vio_async_in_i;
    wire    [31:0]  gt0_tx_data_vio_sync_in_i;
    wire    [31:0]  gt0_tx_data_vio_async_out_i;
    wire    [31:0]  gt0_tx_data_vio_sync_out_i;
    wire    [31:0]  gt0_rx_data_vio_async_in_i;
    wire    [31:0]  gt0_rx_data_vio_sync_in_i;
    wire    [31:0]  gt0_rx_data_vio_async_out_i;
    wire    [31:0]  gt0_rx_data_vio_sync_out_i;
    wire    [163:0] gt0_ila_in_i;
    wire    [31:0]  gt0_channel_drp_vio_async_in_i;
    wire    [31:0]  gt0_channel_drp_vio_sync_in_i;
    wire    [31:0]  gt0_channel_drp_vio_async_out_i;
    wire    [31:0]  gt0_channel_drp_vio_sync_out_i;
    wire    [31:0]  gt0_common_drp_vio_async_in_i;
    wire    [31:0]  gt0_common_drp_vio_sync_in_i;
    wire    [31:0]  gt0_common_drp_vio_async_out_i;
    wire    [31:0]  gt0_common_drp_vio_sync_out_i;


    wire            gttxreset_i;
    wire            gtrxreset_i;

    wire            user_tx_reset_i;
    wire            user_rx_reset_i;
    wire            tx_vio_clk_i;
    wire            tx_vio_clk_mux_out_i;
    wire            rx_vio_ila_clk_i;
    wire            rx_vio_ila_clk_mux_out_i;

    wire            cpllreset_i;



//**************************** Main Body of Code *******************************

    //  Static signal Assigments
    assign tied_to_ground_i             = 1'b0;
    assign tied_to_ground_vec_i         = 64'h0000000000000000;
    assign tied_to_vcc_i                = 1'b1;
    assign tied_to_vcc_vec_i            = 8'hff;
    assign GT0_TXUSRCLK2                = gt0_txusrclk_i;
    assign GT0_RXUSRCLK2                = gt0_txusrclk_i;
    assign gt0_txdata_i                 = TX_DATA_OUT;//
    assign gt0_txcharisk_i              = TXCTRL_OUT;//TXCTRL_OUT
    assign RX_DATA_IN                   = gt0_rxdata_i;
    assign RXCTRL_IN                    = gt0_rxcharisk_i;
//    assign RXENMCOMMADET_OUT            = gt0_rxmcommaalignen_i;
//    assign RXENPCOMMADET_OUT            = gt0_rxpcommaalignen_i;


    gtwizard_v2_7_GT_USRCLK_SOURCE gt_usrclk_source
   (
    .Q0_CLK1_GTREFCLK_PAD_N_IN  (Q0_CLK1_GTREFCLK_PAD_N_IN),
    .Q0_CLK1_GTREFCLK_PAD_P_IN  (Q0_CLK1_GTREFCLK_PAD_P_IN),
    .Q0_CLK1_GTREFCLK_OUT       (q0_clk1_refclk_i),

    .GT0_TXUSRCLK_OUT    (gt0_txusrclk_i),
    .GT0_TXUSRCLK2_OUT   (gt0_txusrclk2_i),
    .GT0_TXOUTCLK_IN     (gt0_txoutclk_i),
    .GT0_RXUSRCLK_OUT    (gt0_rxusrclk_i),
    .GT0_RXUSRCLK2_OUT   (gt0_rxusrclk2_i),

    .DRPCLK_IN (DRP_CLK_IN),
    .DRPCLK_OUT(drpclk_in_i)
);
    
    
    //***********************************************************************//
    //                                                                       //
    //--------------------------- The GT Wrapper ----------------------------//
    //                                                                       //
    //***********************************************************************//

    // Use the instantiation template in the example directory to add the GT wrapper to your design.
    // In this example, the wrapper is wired up for basic operation with a frame generator and frame
    // checker. The GTs will reset, then attempt to align and transmit data. If channel bonding is
    // enabled, bonding should occur after alignment.

    gtwizard_v2_7_init #
    (
        .EXAMPLE_SIM_GTRESET_SPEEDUP    (EXAMPLE_SIM_GTRESET_SPEEDUP),
        .EXAMPLE_SIMULATION             (EXAMPLE_SIMULATION),
        .STABLE_CLOCK_PERIOD            (STABLE_CLOCK_PERIOD),
        .EXAMPLE_USE_CHIPSCOPE          (EXAMPLE_USE_CHIPSCOPE)
    )
    gtwizard_v2_7_init_i
    (
        .SYSCLK_IN                      (drpclk_in_i),
        .SOFT_RESET_IN                  (tied_to_ground_i),
        .DONT_RESET_ON_DATA_ERROR_IN    (tied_to_ground_i),
        .GT0_TX_FSM_RESET_DONE_OUT      (gt0_txfsmresetdone_i),
        .GT0_RX_FSM_RESET_DONE_OUT      (gt0_rxfsmresetdone_i),
        .GT0_DATA_VALID_IN              (gt0_track_data_i),



        //_____________________________________________________________________
        //_____________________________________________________________________
        //GT0  (X1Y0)

        //------------------------------- CPLL Ports -------------------------------
        .GT0_CPLLFBCLKLOST_OUT          (gt0_cpllfbclklost_i),
        .GT0_CPLLLOCK_OUT               (gt0_cplllock_i),
        .GT0_CPLLLOCKDETCLK_IN          (drpclk_in_i),
        .GT0_CPLLRESET_IN               (gt0_cpllreset_i),
        //------------------------ Channel - Clocking Ports ------------------------
        .GT0_GTREFCLK0_IN               (q0_clk1_refclk_i),
        //-------------------------- Channel - DRP Ports  --------------------------
        .GT0_DRPADDR_IN                 (gt0_drpaddr_i),
        .GT0_DRPCLK_IN                  (drpclk_in_i),
        .GT0_DRPDI_IN                   (gt0_drpdi_i),
        .GT0_DRPDO_OUT                  (gt0_drpdo_i),
        .GT0_DRPEN_IN                   (gt0_drpen_i),
        .GT0_DRPRDY_OUT                 (gt0_drprdy_i),
        .GT0_DRPWE_IN                   (gt0_drpwe_i),
        //----------------------------- Loopback Ports -----------------------------
        .GT0_LOOPBACK_IN                (gt0_loopback_i),
        //---------------------------- Power-Down Ports ----------------------------
        .GT0_RXPD_IN                    (gt0_rxpd_i),
        .GT0_TXPD_IN                    (gt0_txpd_i),
        //------------------- RX Initialization and Reset Ports --------------------
        .GT0_RXUSERRDY_IN               (gt0_rxuserrdy_i),
        //------------------------ RX Margin Analysis Ports ------------------------
        .GT0_EYESCANDATAERROR_OUT       (gt0_eyescandataerror_i),
        //----------------------- Receive Ports - CDR Ports ------------------------
        .GT0_RXCDRLOCK_OUT              (gt0_rxcdrlock_i),
        //----------------- Receive Ports - Clock Correction Ports -----------------
        .GT0_RXCLKCORCNT_OUT            (gt0_rxclkcorcnt_i),
        //---------------- Receive Ports - FPGA RX Interface Ports -----------------
        .GT0_RXUSRCLK_IN                (gt0_txusrclk_i),
        .GT0_RXUSRCLK2_IN               (gt0_txusrclk_i),
        //---------------- Receive Ports - FPGA RX interface Ports -----------------
        .GT0_RXDATA_OUT                 (gt0_rxdata_i),
        //---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
        .GT0_RXDISPERR_OUT              (gt0_rxdisperr_i),
        .GT0_RXNOTINTABLE_OUT           (gt0_rxnotintable_i),
        //------------------------- Receive Ports - RX AFE -------------------------
        .GT0_GTXRXP_IN                  (RXP_IN),
        //---------------------- Receive Ports - RX AFE Ports ----------------------
        .GT0_GTXRXN_IN                  (RXN_IN),
        //----------------- Receive Ports - RX Buffer Bypass Ports -----------------
        .GT0_RXBUFSTATUS_OUT            (gt0_rxbufstatus_i),
        //------------ Receive Ports - RX Byte and Word Alignment Ports ------------
        .GT0_RXBYTEREALIGN_OUT          (gt0_rxbyterealign_i),
        .GT0_RXMCOMMAALIGNEN_IN         (gt0_rxmcommaalignen_i),
        .GT0_RXPCOMMAALIGNEN_IN         (gt0_rxpcommaalignen_i),
        //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .GT0_GTRXRESET_IN               (gt0_gtrxreset_i),
        .GT0_RXPMARESET_IN              (gt0_rxpmareset_i),
        //--------------- Receive Ports - RX Polarity Control Ports ----------------
        .GT0_RXPOLARITY_IN              (gt0_rxpolarity_i),
        //----------------- Receive Ports - RX8B/10B Decoder Ports -----------------
        .GT0_RXCHARISCOMMA_OUT          (gt0_rxchariscomma_i),
        .GT0_RXCHARISK_OUT              (gt0_rxcharisk_i),
        //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .GT0_RXRESETDONE_OUT            (gt0_rxresetdone_i),
        //------------------- TX Initialization and Reset Ports --------------------
        .GT0_GTTXRESET_IN               (gt0_gttxreset_i),
        .GT0_TXUSERRDY_IN               (gt0_txuserrdy_i),
        //---------------- Transmit Ports - FPGA TX Interface Ports ----------------
        .GT0_TXUSRCLK_IN                (gt0_txusrclk_i),
        .GT0_TXUSRCLK2_IN               (gt0_txusrclk_i),
        //-------------------- Transmit Ports - TX Buffer Ports --------------------
        .GT0_TXBUFSTATUS_OUT            (gt0_txbufstatus_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .GT0_TXDATA_IN                  (gt0_txdata_i),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .GT0_GTXTXN_OUT                 (TXN_OUT),
        .GT0_GTXTXP_OUT                 (TXP_OUT),
        //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .GT0_TXOUTCLK_OUT               (gt0_txoutclk_i),
        .GT0_TXOUTCLKFABRIC_OUT         (gt0_txoutclkfabric_i),
        .GT0_TXOUTCLKPCS_OUT            (gt0_txoutclkpcs_i),
        //------------------- Transmit Ports - TX Gearbox Ports --------------------
        .GT0_TXCHARISK_IN               (gt0_txcharisk_i),
        //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .GT0_TXRESETDONE_OUT            (gt0_txresetdone_i),




    //____________________________COMMON PORTS________________________________
        //-------------------- Common Block  - Ref Clock Ports ---------------------
        .GT0_GTREFCLK0_COMMON_IN        (q0_clk1_refclk_i),
        //----------------------- Common Block - QPLL Ports ------------------------
        .GT0_QPLLLOCK_OUT               (gt0_qplllock_i),
        .GT0_QPLLLOCKDETCLK_IN          (drpclk_in_i),
        .GT0_QPLLRESET_IN               (gt0_qpllreset_i)

    );


    //***********************************************************************//
    //                                                                       //
    //--------------------------- User Module Resets-------------------------//
    //                                                                       //
    //***********************************************************************//
    // All the User Modules i.e. FRAME_GEN, FRAME_CHECK and the sync modules
    // are held in reset till the RESETDONE goes high.
    // The RESETDONE is registered a couple of times on *USRCLK2 and connected
    // to the reset of the modules

    always @(posedge gt0_txusrclk_i or negedge gt0_rxresetdone_i)

    begin
        if (!gt0_rxresetdone_i)
        begin
            gt0_rxresetdone_r    <=   `DLY 1'b0;
            gt0_rxresetdone_r2   <=   `DLY 1'b0;
        end
        else
        begin
            gt0_rxresetdone_r    <=   `DLY gt0_rxresetdone_i;
            gt0_rxresetdone_r2   <=   `DLY gt0_rxresetdone_r;
            gt0_rxresetdone_r3   <=   `DLY gt0_rxresetdone_r2;
        end
    end



    always @(posedge gt0_txusrclk_i or negedge gt0_txfsmresetdone_i)

    begin
        if (!gt0_txfsmresetdone_i)
        begin
            gt0_txfsmresetdone_r    <=   `DLY 1'b0;
            gt0_txfsmresetdone_r2   <=   `DLY 1'b0;
        end
        else
        begin
            gt0_txfsmresetdone_r    <=   `DLY gt0_txfsmresetdone_i;
            gt0_txfsmresetdone_r2   <=   `DLY gt0_txfsmresetdone_r;
        end
    end



//    //***********************************************************************//
//    //                                                                       //
//    //------------------------  Frame Generators  ---------------------------//
//    //                                                                       //
//    //***********************************************************************//
//    // The example design uses Block RAM based frame generators to provide test
//    // data to the GTs for transmission. By default the frame generators are
//    // loaded with an incrementing data sequence that includes commas/alignment
//    // characters for alignment. If your protocol uses channel bonding, the
//    // frame generator will also be preloaded with a channel bonding sequence.
//
//    // You can modify the data transmitted by changing the INIT values of the frame
//    // generator in this file. Pay careful attention to bit order and the spacing
//    // of your control and alignment characters.


//    gtwizard_v2_7_GT_FRAME_GEN #
//   (
//        .WORDS_IN_BRAM(EXAMPLE_WORDS_IN_BRAM)
//   )
//    gt0_frame_gen
//    (
//        // User Interface
//        .TX_DATA_OUT                    ({gt0_txdata_float_i,gt0_txdata_i,gt0_txdata_float16_i}),
//        .TXCTRL_OUT                     ({gt0_txcharisk_float_i,gt0_txcharisk_i}),
//
//        // System Interface
//        .USER_CLK                       (gt0_txusrclk_i),
//        .SYSTEM_RESET                   (gt0_tx_system_reset_c)
//    );

    //***********************************************************************//
    //                                                                       //
    //------------------------  Frame Checkers  -----------------------------//
    //                                                                       //
    //***********************************************************************//
    // The example design uses Block RAM based frame checkers to verify incoming
    // data. By default the frame generators are loaded with a data sequence that
    // matches the outgoing sequence of the frame generators for the TX ports.

    // You can modify the expected data sequence by changing the INIT values of the frame
    // checkers in this file. Pay careful attention to bit order and the spacing
    // of your control and alignment characters.

    // When the frame checker receives data, it attempts to synchronise to the
    // incoming pattern by looking for the first sequence in the pattern. Once it
    // finds the first sequence, it increments through the sequence, and indicates an
    // error whenever the next value received does not match the expected value.

//
    assign gt0_frame_check_reset_i = (EXAMPLE_CONFIG_INDEPENDENT_LANES==0)?reset_on_data_error_i:gt0_matchn_i;
//
//    // gt0_frame_check0 is always connected to the lane with the start of char
//    // and this lane starts off the data checking on all the other lanes. The INC_IN port is tied off
    assign gt0_inc_in_i = 1'b0;

    gtwizard_v2_7_GT_FRAME_CHECK #
    (
        .RX_DATA_WIDTH(16),
        .RXCTRL_WIDTH(2),
        .COMMA_DOUBLE(16'h02bc),
        .WORDS_IN_BRAM(EXAMPLE_WORDS_IN_BRAM),
        .START_OF_PACKET_CHAR(16'h02bc)
    )
    gt0_frame_check
    (
        // GT Interface
        .RX_DATA_IN                     (gt0_rxdata_i),
        .RXCTRL_IN                      (gt0_rxcharisk_i),
        .RXENMCOMMADET_OUT              (gt0_rxmcommaalignen_i),
        .RXENPCOMMADET_OUT              (gt0_rxpcommaalignen_i),
        .RX_ENCHAN_SYNC_OUT             ( ),
        .RX_CHANBOND_SEQ_IN             (tied_to_ground_i),
        // Control Interface
        .INC_IN                         (gt0_inc_in_i),
        .INC_OUT                        (gt0_inc_out_i),
        .PATTERN_MATCHB_OUT             (gt0_matchn_i),
        .RESET_ON_ERROR_IN              (gt0_frame_check_reset_i),
        // System Interface
        .USER_CLK                       (gt0_txusrclk_i),
        .SYSTEM_RESET                   (gt0_rx_system_reset_c),
        .ERROR_COUNT_OUT                (gt0_error_count_i),
        .TRACK_DATA_OUT                 (gt0_track_data_i)
    );


    assign TRACK_DATA_OUT = track_data_out_i;

    assign track_data_out_i =
                                gt0_track_data_i ;








////-------------------------------------------------------------------------------------
//

    assign  gt0_rxpd_i                           =  tied_to_ground_vec_i[1:0];
    assign  gt0_txpd_i                           =  tied_to_ground_vec_i[1:0];



    //***********************************************************************//
    //                                                                       //
    //--------------------- Chipscope Connections ---------------------------//
    //                                                                       //
    //***********************************************************************//
    // When the example design is run in hardware, it uses chipscope to allow the
    // example design and GT wrapper to be controlled and monitored. The 
    // EXAMPLE_USE_CHIPSCOPE parameter allows chipscope to be removed for simulation.
generate
if (EXAMPLE_USE_CHIPSCOPE==1) 
begin : chipscope

//    // ICON for all VIOs
//    icon icon_i
//    (
//      .CONTROL0                         (shared_vio_control_i),
//      .CONTROL1                         (tx_data_vio_control_i),
//      .CONTROL2                         (rx_data_vio_control_i),
//      .CONTROL3                         (ila_control_i),
//      .CONTROL4                         (channel_drp_vio_control_i),
//      .CONTROL5                         (common_drp_vio_control_i),
//      .CONTROL6                         (CONTROL6 )
//    );      

    // Shared VIO for Channel DRP  
    data_vio channel_drp_i
    (
      .CONTROL                          (CONTROL4),//channel_drp_vio_control_i
      .ASYNC_IN                         (channel_drp_vio_async_in_i),
      .ASYNC_OUT                        (channel_drp_vio_async_out_i),
      .SYNC_IN                          (channel_drp_vio_sync_in_i),
      .SYNC_OUT                         (channel_drp_vio_sync_out_i),
      .CLK                              (drpclk_in_i)
    );

    // Shared VIO for Quad common DRP  
    data_vio common_drp_i
    (
      .CONTROL                          (CONTROL5),//common_drp_vio_control_i
      .ASYNC_IN                         (common_drp_vio_async_in_i),
      .ASYNC_OUT                        (common_drp_vio_async_out_i),
      .SYNC_IN                          (common_drp_vio_sync_in_i),
      .SYNC_OUT                         (common_drp_vio_sync_out_i),
      .CLK                              (drpclk_in_i)
    );

    // Shared VIO for all GTs
    data_vio shared_vio_i
    (
      .CONTROL                          (CONTROL0),//shared_vio_control_i
      .ASYNC_IN                         (shared_vio_in_i),
      .ASYNC_OUT                        (shared_vio_out_i),
      .SYNC_IN                          (tied_to_ground_vec_i[31:0]),
      .SYNC_OUT                         (),
      .CLK                              (tied_to_ground_i)
    );


    // TX VIO
    data_vio tx_data_vio_i
    (
      .CONTROL                          (CONTROL1),//tx_data_vio_control_i
      .ASYNC_IN                         (tx_data_vio_async_in_i),
      .ASYNC_OUT                        (tx_data_vio_async_out_i),
      .SYNC_IN                          (tx_data_vio_sync_in_i),
      .SYNC_OUT                         (tx_data_vio_sync_out_i),
      .CLK                              (gt0_txusrclk_i)
    );
    
    // RX VIO
    data_vio rx_data_vio_i
    (
      .CONTROL                          (CONTROL2),//rx_data_vio_control_i
      .ASYNC_IN                         (rx_data_vio_async_in_i),
      .ASYNC_OUT                        (rx_data_vio_async_out_i),
      .SYNC_IN                          (rx_data_vio_sync_in_i),
      .SYNC_OUT                         (rx_data_vio_sync_out_i),
      .CLK                              (gt0_txusrclk_i)
    );
    
    // RX ILA
    ila ila_i
    (
      .CONTROL                          (CONTROL3),//ila_control_i
      .CLK                              (gt0_txusrclk_i),
      .TRIG0                            (ila_in_i)
    );



    // assign resets for frame_gen modules
    assign  gt0_tx_system_reset_c = !gt0_txfsmresetdone_r2 || user_tx_reset_i;

    // assign resets for frame_check modules
    assign  gt0_rx_system_reset_c = !gt0_rxresetdone_r3 || user_rx_reset_i;

    assign  gt0_gtrxreset_i = gtrxreset_i || !gt0_cplllock_i;
    assign  gt0_gttxreset_i = gttxreset_i || !gt0_cplllock_i;


    	assign  gt0_cpllreset_i = cpllreset_i;


    // Shared VIO Outputs
    assign  gttxreset_i                          =  shared_vio_out_i[31];
    assign  gtrxreset_i                          =  shared_vio_out_i[30];
    assign  user_tx_reset_i                      =  shared_vio_out_i[29];
    assign  user_rx_reset_i                      =  shared_vio_out_i[28];
    assign  cpllreset_i                          =  shared_vio_out_i[27];

    // Shared VIO Inputs
    assign  shared_vio_in_i[31:0]                =  32'b00000000000000000000000000000000;

    // Chipscope connections on GT 0
    assign  gt0_tx_data_vio_async_in_i[31:0]     =  32'b00000000000000000000000000000000;
    assign  gt0_tx_data_vio_sync_in_i[31]        =  gt0_txresetdone_i;
    assign  gt0_tx_data_vio_sync_in_i[30:29]     =  gt0_txbufstatus_i;
    assign  gt0_tx_data_vio_sync_in_i[28:0]      =  29'b00000000000000000000000000000;
    assign  gt0_loopback_i                       =  tx_data_vio_async_out_i[31:29];
    assign  gt0_txuserrdy_i                      =  tx_data_vio_sync_out_i[31];
    assign  gt0_rx_data_vio_async_in_i[31:0]     =  32'b00000000000000000000000000000000;
    assign  gt0_rx_data_vio_sync_in_i[31]        =  gt0_rxresetdone_i;
    assign  gt0_rx_data_vio_sync_in_i[30:0]      =  31'b0000000000000000000000000000000;
    assign  gt0_rxuserrdy_i                      =  rx_data_vio_async_out_i[31];
    assign  gt0_rxpmareset_i                     =  rx_data_vio_async_out_i[30];
    assign  gt0_rxpolarity_i                     =  rx_data_vio_sync_out_i[31];
    assign  gt0_ila_in_i[163:162]                =  gt0_rxchariscomma_i;
    assign  gt0_ila_in_i[161:160]                =  gt0_rxcharisk_i;
    assign  gt0_ila_in_i[159:158]                =  gt0_rxdisperr_i;
    assign  gt0_ila_in_i[157:156]                =  gt0_rxnotintable_i;
    assign  gt0_ila_in_i[155:154]                =  gt0_rxclkcorcnt_i;
    assign  gt0_ila_in_i[153]                    =  gt0_rxbyterealign_i;
    assign  gt0_ila_in_i[152:137]                =  gt0_rxdata_i;
    assign  gt0_ila_in_i[136:134]                =  gt0_rxbufstatus_i;
    assign  gt0_ila_in_i[133:126]                =  gt0_error_count_i;
    assign  gt0_ila_in_i[125]                    =  gt0_track_data_i;

    assign  gt0_ila_in_i[124:123]                =  gt0_txcharisk_i;
    assign  gt0_ila_in_i[122:107]                =  gt0_txdata_i ;
    assign  gt0_ila_in_i[106:0]                  =  107'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    assign  gt0_channel_drp_vio_async_in_i[31]   =  gt0_drprdy_i;
    assign  gt0_channel_drp_vio_async_in_i[30:15]=  gt0_drpdo_i;
    assign  gt0_channel_drp_vio_async_in_i[14:0] =  15'b000000000000000;
    assign  gt0_channel_drp_vio_sync_in_i[31:0]  =  32'b00000000000000000000000000000000;
    assign  gt0_drpaddr_i                        =  channel_drp_vio_async_out_i[31:23];
    assign  gt0_drpdi_i                          =  channel_drp_vio_async_out_i[22:7];
    assign  gt0_drpen_i                          =  channel_drp_vio_async_out_i[6];
    assign  gt0_drpwe_i                          =  channel_drp_vio_async_out_i[5];
    assign  gt0_common_drp_vio_async_in_i[31:0]  =  32'b00000000000000000000000000000000;
    assign  gt0_common_drp_vio_sync_in_i[31:0]   =  32'b00000000000000000000000000000000;


    assign  tx_data_vio_async_in_i =                       gt0_tx_data_vio_async_in_i;

    assign  tx_data_vio_sync_in_i =                        gt0_tx_data_vio_sync_in_i;


    assign  rx_data_vio_async_in_i =                       gt0_rx_data_vio_async_in_i;

    assign  rx_data_vio_sync_in_i =                        gt0_rx_data_vio_sync_in_i;

    assign  ila_in_i =                                     gt0_ila_in_i;

    

    assign  channel_drp_vio_async_in_i =                   gt0_channel_drp_vio_async_in_i;

    assign  channel_drp_vio_sync_in_i =                    gt0_channel_drp_vio_sync_in_i;

    assign common_drp_vio_async_in_i = 32'h0;
    assign common_drp_vio_sync_in_i  = 32'h0;
end //end EXAMPLE_USE_CHIPSCOPE=1 generate section
else 
begin: no_chipscope 

    // assign resets for frame_gen modules
    assign  gt0_tx_system_reset_c = !gt0_txfsmresetdone_r2;

    // assign resets for frame_check modules
    assign  gt0_rx_system_reset_c = !gt0_rxresetdone_r3;

//-------------------------------------------------------------
    assign  gttxreset_i                          =  tied_to_ground_i;
    assign  gtrxreset_i                          =  tied_to_ground_i;
    assign  user_tx_reset_i                      =  tied_to_ground_i;
    assign  user_rx_reset_i                      =  tied_to_ground_i;
    assign  gt0_loopback_i                       =  tied_to_ground_vec_i[2:0];
    assign  gt0_rxpmareset_i                     =  tied_to_ground_i;
    assign  gt0_rxpolarity_i                     =  tied_to_ground_i;
    assign  gt0_drpaddr_i                        =  tied_to_ground_vec_i[8:0];
    assign  gt0_drpdi_i                          =  tied_to_ground_vec_i[15:0];
    assign  gt0_drpen_i                          =  tied_to_ground_i;
    assign  gt0_drpwe_i                          =  tied_to_ground_i;

end
endgenerate //End generate for EXAMPLE_USE_CHIPSCOPE

endmodule
    
//-------------------------------------------------------------------
//
//  VIO core module declaration
//
//-------------------------------------------------------------------
module data_vio
  (
    CONTROL,
    CLK,
    ASYNC_IN,
    ASYNC_OUT,
    SYNC_IN,
    SYNC_OUT
  );
  inout  [35:0] CONTROL;
  input         CLK;
  input  [31:0] ASYNC_IN;
  output [31:0] ASYNC_OUT;
  input  [31:0] SYNC_IN;
  output [31:0] SYNC_OUT;
endmodule


//-------------------------------------------------------------------
//
//  ICON core module declaration
//
//-------------------------------------------------------------------
//module icon
//  (
//      CONTROL0,
//      CONTROL1,
//      CONTROL2,
//      CONTROL3,
//      CONTROL4,
//      CONTROL5,
//      CONTROL6
//      
//  );
//  inout [35:0] CONTROL0;
//  inout [35:0] CONTROL1;
//  inout [35:0] CONTROL2;
//  inout [35:0] CONTROL3;
//  inout [35:0] CONTROL4;
//  inout [35:0] CONTROL5;
////  inout [35:0] CONTROL6;  
//endmodule


//-------------------------------------------------------------------
//
//  ILA core module declaration
//  This is used to allow RX signals to be monitored
//
//-------------------------------------------------------------------
module ila
  (
    CONTROL,
    CLK,
    TRIG0
  );
  inout [35:0]  CONTROL;
  input         CLK    ;
  input [163:0] TRIG0  ;
endmodule


