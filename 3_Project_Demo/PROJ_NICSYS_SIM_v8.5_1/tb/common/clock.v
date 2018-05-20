
`timescale 1ns / 100ps

module clock(  
    clk
    );
    parameter INIT_PHASE      = 3;                // Unit: ns
    parameter SYS_CLK_FREQ    = 122.88;           // Unit: MHz
    
    real sysclk_period = (1000.0/(SYS_CLK_FREQ));
    
    
    output        clk;
    reg           clk;

    initial
      begin
        #(INIT_PHASE) clk      = 0;    
      end
      
    always  #(sysclk_period/2.0) clk = ~clk;      
      
  
endmodule


//  defparam clk_uut.SYS_CLK_FREQ  = 20;
//  clock clk_uut (
//    .clk(clk20)
//    );

