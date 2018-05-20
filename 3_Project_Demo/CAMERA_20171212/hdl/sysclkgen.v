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
// Name of module : syscligen
// Project        : NicSys8000
// Func           : clock signal generator
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

module sysclkgen #
(
    parameter CLK_PERIOD = 10,
    parameter HIGH_PERIOD = 5
)
(
    output clk
);
    reg clk_reg;
    assign clk = clk_reg;
    initial clk_reg = 1'b1;
    always 
      begin
        #(CLK_PERIOD - HIGH_PERIOD) clk_reg = 0;
        #HIGH_PERIOD clk_reg = 1;
      end

endmodule