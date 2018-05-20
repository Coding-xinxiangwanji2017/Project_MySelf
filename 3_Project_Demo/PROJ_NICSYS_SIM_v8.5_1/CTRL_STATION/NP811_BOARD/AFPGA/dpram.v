`timescale 1ns / 100ps
module dpram(
             clk_a  ,
             wren_a ,
             addr_a ,
             wdata_a,
             rdata_a,
             
             clk_b  ,
             wren_b ,
             addr_b ,
             wdata_b,
             rdata_b,             
             );
                  

parameter                  DEPTH          = 1024 ; 
parameter                  DATA_WIDTH     = 8    ;
parameter                  ADDR_WIDTH     = 10   ;

input                       clk_a                ;
input                       wren_a               ;
input  [ADDR_WIDTH - 1 : 0] addr_a               ;  
input  [DATA_WIDTH - 1 : 0] wdata_a              ;
output [DATA_WIDTH - 1 : 0] rdata_a              ; 
                                                 
input                       clk_b                ;
input                       wren_b               ;
input  [ADDR_WIDTH - 1 : 0] addr_b               ;  
input  [DATA_WIDTH - 1 : 0] wdata_b              ;
output [DATA_WIDTH - 1 : 0] rdata_b              ; 
                                                 
reg    [DATA_WIDTH - 1 : 0] rdata_a              ;
reg    [DATA_WIDTH - 1 : 0] rdata_b              ;

reg    [DATA_WIDTH - 1 : 0] mem[ 0 : DEPTH - 1]  ; 
	
//write data into mem
  always 
  begin
    @(posedge clk_a or posedge clk_b) 
      if ( wren_a )
        mem[ addr_a ] <= wdata_a ;
      if ( wren_b )
        mem[ addr_b ] <= wdata_b ;
  end      

//read data from mem
  always @(posedge clk_a)
  begin
      rdata_a <= mem[ addr_a ];
  end        
  always @(posedge clk_b)
  begin         
      rdata_b <= mem[ addr_b ];  
  end  
    
    
    
    
    
    
endmodule    