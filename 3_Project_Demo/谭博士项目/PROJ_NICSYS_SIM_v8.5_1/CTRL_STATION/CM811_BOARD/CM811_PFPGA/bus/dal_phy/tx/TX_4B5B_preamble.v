
module  TX_4B5B_preamble(
    clk    ,     // i Main clock
    reset  ,     // i Transmitter Reset Signal
    data_in,     // i System side data input
    wr_en  ,     // i System side write enable
    ctrl_en,     // i System is transmitting control byte
    TX_RDY ,     // o System side report signal 
    TX     ,     // o Bus side output
    tx_frame
);


//-----------------------------------------------------------------------------------------------------//
//                                      parameter definition                                           //
//-----------------------------------------------------------------------------------------------------//
parameter dwidth    = 8    ;        // data width
parameter posEdge   = 2'b01;        // rising edge

parameter typeData  = 2'b0 ;        // data type normal data
parameter typeStart = 2'b01;        // data type start symbol
parameter typePre   = 2'b10;        // data type preamble symbol
parameter typeEnd   = 2'b11;        // data type end symbol

parameter pantData  = 2'b0 ;        // 4B/5B data
parameter pantJ     = 2'b01;        // 4B/5B J symbol
parameter pantK     = 2'b10;        // 4B/5B K symbol
parameter pantT     = 2'b11;        // 4B/5B T symbol

parameter Bidle     = 0    ;        // idle state
parameter Bshift1   = 1    ;        // shift1 state
parameter Bmap2     = 2    ;        // map2 state
parameter Bshift2   = 3    ;        // shift2 state
parameter Bpreamble = 4    ;        // preamble state


//-----------------------------------------------------------------------------------------------------//
//                                      port definition                                                //
//-----------------------------------------------------------------------------------------------------//
input                   clk    ;        // 
input                   reset  ;  
input                   wr_en  ;  
input                   ctrl_en;
input [dwidth - 1:0]    data_in;
output reg              TX_RDY ; 
output reg              TX     ;
output wire             tx_frame;     


//-----------------------------------------------------------------------------------------------------//
//                                      reg/wire definition                                            //
//-----------------------------------------------------------------------------------------------------//
reg [dwidth/2:0]    pant       ;     /* synthesis syn_preserve=1 alspreserve=1 */    // Two 5B for transmitter
reg [dwidth/2:0]    bit_count  ;     /* synthesis syn_preserve=1 alspreserve=1 */    // bit counter
reg [4:0]           TX_state   ;     /* synthesis syn_preserve=1 alspreserve=1 */    // tx FSM state
reg [dwidth - 1:0]  data_buffer;     /* synthesis syn_preserve=1 alspreserve=1 */    // tx data buffer
reg [1:0]           data_type  ;     /* synthesis syn_preserve=1 alspreserve=1 */    // tx data type
reg [1:0]           wr_edge    ;     /* synthesis syn_preserve=1 alspreserve=1 */    // tx write edge
reg [1:0]           ctrl_edge  ;     /* synthesis syn_preserve=1 alspreserve=1 */    // tx control edge
//reg                 tx_frame   ;     /* synthesis syn_preserve=1 alspreserve=1 */    // Shows enable for entire frame
reg                 preamble   ;     /* synthesis syn_preserve=1 alspreserve=1 */    // preamble flag
reg [1:0]           preambleCnt;     /* synthesis syn_preserve=1 alspreserve=1 */    // preamble counter

reg tx_frame_d1;
reg r_tx_frame;


//-----------------------------------------------------------------------------------------------------//
//                                      statement                                                      //
//-----------------------------------------------------------------------------------------------------//
// 4B5B Block Code Transform Function
function [dwidth/2:0] codemap_4B5B;
input [dwidth/2-1:0] data_4B  ;
input [1:0]          data_type;
begin
    case (data_type)  // 4B5B Block code encoding
        pantData: begin    // Regular Data
            case(data_4B)
                4'h0: codemap_4B5B = 5'b11110;  // HEX '0'
                4'h1: codemap_4B5B = 5'b01001;  // HEX '1'
                4'h2: codemap_4B5B = 5'b10100;  // HEX '2'
                4'h3: codemap_4B5B = 5'b10101;  // HEX '3'
                4'h4: codemap_4B5B = 5'b01010;  // HEX '4'
                4'h5: codemap_4B5B = 5'b01011;  // HEX '5'
                4'h6: codemap_4B5B = 5'b01110;  // HEX '6'
                4'h7: codemap_4B5B = 5'b01111;  // HEX '7'
                4'h8: codemap_4B5B = 5'b10010;  // HEX '8'
                4'h9: codemap_4B5B = 5'b10011;  // HEX '9'
                4'hA: codemap_4B5B = 5'b10110;  // HEX 'A'
                4'hB: codemap_4B5B = 5'b10111;  // HEX 'B'
                4'hC: codemap_4B5B = 5'b11010;  // HEX 'C'
                4'hD: codemap_4B5B = 5'b11011;  // HEX 'D'
                4'hE: codemap_4B5B = 5'b11100;  // HEX 'E'
                4'hF: codemap_4B5B = 5'b11101;  // HEX 'F'
                //default: codemap_4B5B = 5'b11111;  // default Unknown
                default: codemap_4B5B = 5'b11110;  // default Unknown
            endcase
        end
        pantJ: codemap_4B5B = 5'b11000;     // J Symbol
        pantK: codemap_4B5B = 5'b10001;     // K Symbol
        pantT: codemap_4B5B = 5'b01101;     // T Symbol
        default:;
    endcase
end
endfunction 

// Edge detector sequence for control signals
always @(posedge clk) begin// or posedge reset
    if(reset) begin
        wr_edge   <= 2'b00; 
        ctrl_edge <= 2'b00;
    end
    else begin
        wr_edge   <= {wr_edge[0], wr_en}   ;          // wr_en edge detector
        ctrl_edge <= {ctrl_edge[0], ctrl_en};        // ctrl_en edge detector
    end
end

// NRZ serial tx
always @(posedge clk) begin // or posedge reset
        if(reset) 
            TX <= 1'b1;
        else begin
            if(r_tx_frame) begin
                if(pant[dwidth/2])
                    TX <= ~TX;
            end
            else begin
                TX <= 1'b1;
            end
        end
end

// FSM
always @(posedge clk) begin// or posedge reset
        if(reset) begin
            pant <= 5'h1F;  // Idle character
            TX_RDY <= 1'b1;
            r_tx_frame <= 1'b0;
            TX_state <= 5'h1;
            preamble <= 1'b0;
        end
        else begin
            case(1'b1)
                TX_state[Bidle]: begin      // idle state
                    if({wr_edge[0], wr_en} == posEdge && !ctrl_en) begin  // data write edge detected, start to convert and tranmit data
                        data_buffer <= data_in;                  
                        data_type <= typeData;                      
                        pant <= codemap_4B5B(data_in[dwidth-1:dwidth/2], pantData);    // 4B/5B convert
                        bit_count <= 5'h4;
                        TX_RDY <= 1'b0;
                        TX_state[Bidle] <= 1'b0;
                        TX_state[Bshift1] <= 1'b1;
                    end
                    else if({ctrl_edge[0],ctrl_en} == posEdge && !wr_en) begin // The ctrl_edge rising edge detected, start to transmit preamble bytes or ending symbol
                        data_buffer <= 8'hF;                     
                        if(!data_in[0]) begin       // transmit preamble
                            TX_state[Bpreamble] <= 1'b1;
                            TX_state[Bidle] <= 1'b0;
                            preamble <= 1'b1;
                            preambleCnt <= 2'h0;
                        end
                        else begin                  // transmit ending symbol
                            data_type <= typeEnd;                 // LSB = 1 T symbol
                            pant <= codemap_4B5B(4'hF, pantT);
                            TX_state[Bidle] <= 1'b0;
                            TX_state[Bshift1] <= 1'b1;
                            bit_count <= 5'h4;
                        end
                        TX_RDY <= 1'b0;
                    end
                    else begin
                        TX_state[Bidle] <= 1'b1;
                    end
                end
            TX_state[Bshift1]: begin    // shift 1st 5 bits out
            if(bit_count <= 5'h1) begin     // bits done, go to next 4B/5B converting
                TX_state[Bshift1] <= 1'b0;
                TX_state[Bmap2] <= 1'b1;
            end 
            else begin                      // shift bits
                TX_state[Bshift1] <= 1'b1;
                bit_count <= bit_count - 1;
            end
            pant <= {pant[dwidth/2-1:0],1'b1};
            end
            TX_state[Bmap2]: begin      // map 2nd 4 bit
                case(data_type)
                    typeData: pant  <= codemap_4B5B(data_buffer[dwidth/2-1:0], pantData);    // Encode second half of data
                    typeStart: pant <= codemap_4B5B(4'hF, pantK);                           // Send K symbol 
                    typePre: pant   <= codemap_4B5B(4'h3, pantData);                          // Preamble
                    typeEnd: pant   <= codemap_4B5B(4'hF, pantT);                             // Send second T symbol 
                    default: pant   <= 5'h1F;                                                 // Error 
                endcase
                bit_count <= 5'h4;
                TX_state[Bmap2] <= 1'b0;
                TX_state[Bshift2] <= 1'b1;
            end
            TX_state[Bshift2]: begin    // shift the 2nd 5 bits
                if(bit_count <= 5'h1) begin     // shift done
                    if(data_type != typeEnd) begin    // not ending symbol
                        if(preamble == 1'b1) begin      // preamble
                            bit_count <= bit_count - 1;
                            TX_state[Bshift2] <= 1'b0;
                            TX_state[Bpreamble] <= 1'b1;
                        end
                        else begin                      // go back to idle
                            TX_state[Bidle] <= 1'b1;
                            TX_state[Bshift2] <= 1'b0;
                            bit_count <= bit_count - 1;
                        end
                    end
                    else begin                      // ending symbol
                        if(bit_count == 5'h0) begin // last bit done
                            TX_state[Bidle] <= 1'b1;
                            TX_state[Bshift2] <= 1'b0;
                            TX_RDY <= 1'b1;         // set ready
                            r_tx_frame <= 1'b0;       // clear frame
                        end
                        else
                            bit_count <= bit_count - 1;
                    end
                end
                else begin                      // shifting bits
                    TX_state[Bshift2] <= 1'b1;
                    bit_count <= bit_count - 1;
                    if(data_type != typeEnd && bit_count == 5'h2 && preamble == 1'b0) begin 
                        TX_RDY <= 1'b1;
                    end
                end
                pant <= {pant[dwidth/2-1:0],1'b1};
            end
            TX_state[Bpreamble]: begin  // preamble bytes
                case(preambleCnt)
                    2'h0 : begin        // 1st 4 bits preamble
                        data_type <= typePre;                  
                        pant <= codemap_4B5B(4'h3, pantData);
                        r_tx_frame <= 1'b1;
                        TX_state[Bshift1] <= 1'b1;
                        TX_state[Bpreamble] <= 1'b0;
                        preambleCnt <= preambleCnt + 1;
                        bit_count <= 5'h4;
                    end
                    2'h1 : begin        // 2nd 4 bits preamble
                        data_type <= typePre;                  
                        pant <= codemap_4B5B(4'h3, pantData);
                        r_tx_frame <= 1'b1;
                        TX_state[Bshift1] <= 1'b1;
                        TX_state[Bpreamble] <= 1'b0;
                        preambleCnt <= preambleCnt + 1;
                        bit_count <= 5'h4;
                    end
                    default: begin      // after preamble bits, send frame start symbol
                        preamble <= 1'b0;
                        data_type <= typeStart;                  // LSB = 0 J symbol at first cycle
                        pant <= codemap_4B5B(4'hF, pantJ);
                        r_tx_frame <= 1'b1;
                        bit_count <= 5'h4;
                        TX_RDY <= 1'b0;
                        r_tx_frame <= 1'b1;
                        TX_state[Bshift1] <= 1'b1;
                        TX_state[Bpreamble] <= 1'b0;
                        bit_count <= 5'h4;
                    end
                endcase
            end
      endcase
   end
end

always @ (posedge clk)
begin
	if(reset)
		tx_frame_d1 <= 0;
	else
		tx_frame_d1 <= r_tx_frame;
end

assign tx_frame = r_tx_frame | tx_frame_d1;

endmodule 
