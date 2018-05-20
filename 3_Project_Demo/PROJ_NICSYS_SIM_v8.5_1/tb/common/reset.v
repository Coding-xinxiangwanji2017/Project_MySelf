
`timescale 1ns / 100ps

module reset(  
    rst
    );
 
    parameter RESET_START     = 30.5;   // Unit: ns
    parameter RESET_DURATION  = 203.5;  // Unit: ns

    output        rst;
    reg           rst;

    initial
      begin
        rst      = 0;
  
        #(RESET_START)        rst = 1;
        #(RESET_DURATION)     rst = 0;
  
      end

endmodule
