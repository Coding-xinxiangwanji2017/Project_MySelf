
//`timescale <time_units> / <precision>

module RX_4B5B_1ch(
        input                  clk,            // system clock
        input                  clk_dr1,        // phase1 clock
        input                  clk_dr2,        // phase2 clock
        input                  clk_dr3,        // phase3 clock
        input                  reset,          // system reset
        input                  RX,             // serial rx
        input                  rxEn,           // rx port enable
        
        //output      [12:0]     debug,          // debug port
        output reg             phaseLock,
        output reg             rdy,            // ready
        output reg             frame,          // frame
        output      [7:0]        dataO,         // data
        output reg             done          // done
        //output reg             errFlag         // error
);


//-----------------------------------------------------------------------------------------------------//
//                                      parameter definition                                           //
//-----------------------------------------------------------------------------------------------------//
parameter stIdle  = 2'h0;       // FSM idle state
parameter stStart = 2'h1;       // FSM receive start state
parameter stRecv  = 2'h2;       // FSM receive state
parameter numBit  = 4'h9;       // bit counter threshold


//-----------------------------------------------------------------------------------------------------//
//                                      reg/wire definition                                            //
//-----------------------------------------------------------------------------------------------------//
wire [9:0]            rx_sym;         /* synthesis syn_keep=1 alspreserve=1 */            // 10 bit reg data in
reg                   JK;             /* synthesis syn_preserve=1 alspreserve=1 */        // JK symble flag
reg                   TT;             /* synthesis syn_preserve=1 alspreserve=1 */        // TT symble flag
reg                   II;             /* synthesis syn_preserve=1 alspreserve=1 */        // II  symble flag
//reg                   phaseLock;      // phase lock flag
reg  [4:0]            rxH5B;          /* synthesis syn_preserve=1 alspreserve=1 */        // high 5B
reg  [4:0]            rxL5B;          /* synthesis syn_preserve=1 alspreserve=1 */        // low 5B
reg  [3:0]            bitCnt;         /* synthesis syn_preserve=1 alspreserve=1 */        // bit counter
reg  [1:0]            rxState;        /* synthesis syn_preserve=1 alspreserve=1 */        // state reg
//wire [3:0]            rxDebug;        /* synthesis syn_keep=1 alspreserve=1 */            // debug signal


//-----------------------------------------------------------------------------------------------------//
//                                      statement                                                      //
//-----------------------------------------------------------------------------------------------------//
// 5B/4B decoder function
function [4:0] decodemap_5B4B;
input        [4:0] data_5B;
begin
    case(data_5B)
        5'b11110: decodemap_5B4B = 5'h0;        // hex '0'
        5'b01001: decodemap_5B4B = 5'h1;        // hex '1'
        5'b10100: decodemap_5B4B = 5'h2;        // hex '2'
        5'b10101: decodemap_5B4B = 5'h3;        // hex '3'
        5'b01010: decodemap_5B4B = 5'h4;        // hex '4'
        5'b01011: decodemap_5B4B = 5'h5;        // hex '5'
        5'b01110: decodemap_5B4B = 5'h6;        // hex '6'
        5'b01111: decodemap_5B4B = 5'h7;        // hex '7'
        5'b10010: decodemap_5B4B = 5'h8;        // hex '8'
        5'b10011: decodemap_5B4B = 5'h9;        // hex '9'
        5'b10110: decodemap_5B4B = 5'hA;        // hex 'A'
        5'b10111: decodemap_5B4B = 5'hB;        // hex 'B'
        5'b11010: decodemap_5B4B = 5'hC;        // hex 'C'
        5'b11011: decodemap_5B4B = 5'hD;        // hex 'D'
        5'b11100: decodemap_5B4B = 5'hE;        // hex 'E'
        5'b11101: decodemap_5B4B = 5'hF;        // hex 'F'
        default: decodemap_5B4B = 5'h10;
    endcase
end
endfunction

// JK/TT/II symbol detection
always@(posedge clk) begin
    if(reset) begin
        TT <= 1'b0;
        JK <= 1'b0;
        II <= 1'b1;
    end
    else begin
        JK <= (rx_sym[9:5] == 5'b11000) && (rx_sym[4:0] == 5'b10001);   //symJ & symK;
        TT <= (rx_sym[9:5] == 5'b01101) && (rx_sym[4:0] == 5'b01101);   //symT1 & symT2;
        II <= (rx_sym[4:0] == 5'h1F);   // symII
    end
end

// FSM
always@(posedge clk) begin
    if(reset | ~rxEn) begin     // reset
        rxState <= stIdle;
        done <= 1'b0;
        //errFlag <= 1'b0;
        rdy <= 1'b0;
        frame <= 1'b0;
        phaseLock <= 1'b0;
        bitCnt <= 4'h0;
    end
    else begin
        case(rxState)
            stIdle : begin      // idle wait for msg start
                done <= 1'b0;
                //errFlag <= 1'b0;
                rdy <= 1'b0;
                if(JK) begin    // jk detected
                    rxState <= stStart;
                    bitCnt <= numBit;
                    frame <= 1'b1;
                    phaseLock <= 1'b1;
                end
            end
            stStart : begin     // count 10 bits
                //errFlag <= 1'b0;
                done <= 1'b0;
                if(bitCnt > 4'h0) begin
                    bitCnt <= bitCnt - 1;
                    rdy <= 1'b0;
                end
                else begin
                    rxL5B <= decodemap_5B4B(rx_sym[4:0]);
                    rxH5B <= decodemap_5B4B(rx_sym[9:5]);
                    rxState <= stRecv;
                end
            end
            stRecv : begin      // 5B/4B decode
                if(TT) begin    // msg end
                    done <= 1'b1;
                    rxState <= stIdle;
                    frame <= 1'b0;
                    phaseLock <= 1'b0;
                end
                else begin
                    if( JK || II || rxL5B[4] || rxH5B[4]) begin     // error symbol detected
                        rxState <= stIdle;
                        //errFlag <= 1'b1;
                        frame <= 1'b0;
                        phaseLock <= 1'b0;
                    end
                    else begin  // go to receive next byte
                        rxState <= stStart;
                        bitCnt <= numBit;
                        rdy <= 1'b1;
                    end
                end
            end
            default: begin
                rxState <= stIdle;
            end
        endcase                        
    end
end
assign dataO = {rxH5B[3:0],rxL5B[3:0]};

// phase detection module
BPH_SYNC Rx_dut
    (
    .clk(clk), 
    .reset(reset), 
    .clk90(clk_dr1), 
    .clk180(clk_dr2), 
    .clk270(clk_dr3),
    .lock(phaseLock),
    .datain(RX), 
    .debug(rxDebug),
    .sdataout(rx_sym)
    );

// debug port
//assign debug = {
//    rxState,
 //   JK,
 //   TT,
//    rx_sym[4:0],
//    rxDebug[3:0]    
//};

endmodule 