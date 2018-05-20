////////////////////////////////////////////////////////////////////////////////
// Copyright (c)2015 CNCS Incorporated
// All Rights Reserved
// THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE of CNCS Inc.
// The copyright notice above does not evidence any actual or intended
// publication of such source code.
// No part of this code may be reproduced, stored in a retrieval system,
// or transmitted, in any form or by any means, electronic, mechanical,
// photocopying, recording, or otherwise, without the prior written
// permission of CNCS
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// Name of module : rstgen
// Project        : NicSys8000
// Func           : reset signal generator
// Author         : Tan Xingye
// Simulator      : Modelsim Microsemi 10.3c / Windows 7 32bit
// Synthesizer    : Libero SoC v11.5 SP2 / Windows 7 32bit
// FPGA/CPLD type : M2GL050-FGG484
// version 1.0    : made in Date: 2016.4.21
// Modification Logs:
// -----------------------------------------------------------------------------
//   Version   Date         Description(Recorder)
// -----------------------------------------------------------------------------
//     1.0   2016/04/21   Initial version(Tan Xingye)
//
//
//
////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/100ps

module rstgen #
(
    parameter LEVEL = "HIGN",//HIGH,LOW
    parameter KEEP  = 5
)
(
    output rst
);
    localparam HIGH = 1'b1;
    localparam LOW = 1'b0;

    reg rst_reg;
    assign rst = rst_reg;
    generate 
      if(LEVEL == "HIGN")
        begin
            initial 
              begin
                rst_reg = HIGH;
                #KEEP;
                rst_reg = LOW;
              end
        end
      else if(LEVEL == "LOW")
        begin
          initial
            begin
                rst_reg = LOW;
                #KEEP;
                rst_reg = HIGH;
            end
        end
      else
        begin
          initial 
            begin
              dislay("Invalid parameter_");
              $stop;
            end
        end     
    endgenerate
endmodule