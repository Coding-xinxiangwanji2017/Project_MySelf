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
// Name of module : LVD206D
// Project        : NicSys8000
// Func           : LVD206D
// Author         : Tan Xingye
// Simulator      : Modelsim Microsemi 10.3c / Windows 7 32bit
// Synthesizer    : Libero SoC v11.5 SP2 / Windows 7 32bit
// FPGA/CPLD type : M2GL050-FG484
// version 1.0    : made in Date: 2015.12.01
// Modification Logs:
// -----------------------------------------------------------------------------
//   Version   Date         Description(Recorder)
// -----------------------------------------------------------------------------
//     1.0   2016/04/12   Initial version(Tan Xingye)
//
//
//
////////////////////////////////////////////////////////////////////////////////

module LVD206D(
    input   wire         D,
    input   wire         DE,

    output  wire         R,
    input   wire         RE_n,  
      
    inout   wire         A,
    inout   wire         B
    );


//always@(RE_n)
//    if(RE_n==0) R<= (A && (!B));
    
    
//assign R = (RE_n == 0)?  (A && (!B)) : 1'bz;   
assign R = (RE_n == 0)?  A  : 1'bz;   

assign A = (DE == 1)?  D : 1'bz;
assign B = (DE == 1)? !D : 1'bz;

endmodule
