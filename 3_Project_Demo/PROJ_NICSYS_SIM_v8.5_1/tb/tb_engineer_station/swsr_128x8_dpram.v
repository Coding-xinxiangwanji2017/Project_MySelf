// THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE of CNCS Inc.                //      
// The copyright notice above does not evidence any actual or intended     //      
// publication of such source code.                                        //      
// No part of this code may be reproduced, stored in a retrieval system,   //      
// or transmitted, in any form or by any means, electronic, mechanical,    //      
// photocopying, recording, or otherwise, without the prior written        //      
// permission of CNCS                                                      //      
/////////////////////////////////////////////////////////////////////////////      
/////////////////////////////////////////////////////////////////////////////      
// Name of module : swsr_128x8_dpram                                       //      
// Project        : NicSys8000                                             //      
// Func           : afpga for dpram                                        //      
// Author         : Liu Zhikai                                             //      
// Simulator      : Modelsim ME 10.2c / Windows xp                         //      
// Synthesizer    : Libero SoC v11.3 / Windows xp                          //      
// FPGA/CPLD type : IGLOO2 M2GL050                                         //      
// version 1.0    : made in Date: 2014.09.10                               //      
/////////////////////////////////////////////////////////////////////////////  

module     swsr_128x8_dpram    (
                                   clk  ,
                                   wren ,
                                   waddr,
                                   wdata,
                                   rden ,
                                   raddr,
                                   rdata
                                  );
                  

parameter                  DEPTH          = 138  ; 
parameter                  DATA_WIDTH     = 8    ;
parameter                  ADDR_WIDTH     = 8    ;

input                       clk                  ;
input                       wren                 ;
input  [ADDR_WIDTH - 1 : 0] waddr                ;  
input  [DATA_WIDTH - 1 : 0] wdata                ;
input                       rden                 ;                                               
input  [ADDR_WIDTH - 1 : 0] raddr                ;
output [DATA_WIDTH - 1 : 0] rdata                ; 
                                                 
                                                 
reg    [DATA_WIDTH - 1 : 0] rdata                ;

reg    [DATA_WIDTH - 1 : 0] mem[ 0 : DEPTH - 1]  ; 
	
    ////write data into mem
        always @ ( posedge clk )
	    begin    
	    if ( wren )
	        mem[ waddr ] <= wdata ;
	    end 
    ////read data from mem
        always @ ( posedge clk )
            begin
            if ( rden )
                rdata <= mem[ raddr ] ;
            end
endmodule    
            




