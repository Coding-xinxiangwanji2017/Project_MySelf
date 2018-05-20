
//`timescale 1 ps/1 ps

module SRL16E (
    input       clk  ,  // clock
    input       reset,  // reset
    input [1:0] addr,   // address
    input       D,      // data in
    output      Q
    );                  // data out

//-----------------------------------------------------------------------------------------------------//
//                                      parameter definition                                           //
//-----------------------------------------------------------------------------------------------------//


//-----------------------------------------------------------------------------------------------------//
//                                      reg/wire definition                                            //
//-----------------------------------------------------------------------------------------------------//
reg  [7:0] data;        // data reg



//-----------------------------------------------------------------------------------------------------//
//                                      statement                                                      //
//-----------------------------------------------------------------------------------------------------//
assign Q = data[addr];  // output data bit

always @(posedge clk or posedge reset) begin
  if(reset) 
    data <= 8'h0;
  else 
    data <= {data[6:0], D};
end

endmodule
//���ݽ���