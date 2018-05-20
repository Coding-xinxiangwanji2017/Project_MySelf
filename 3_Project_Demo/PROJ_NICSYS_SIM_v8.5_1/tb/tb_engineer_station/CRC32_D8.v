////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 1999-2008 Easics NV.
// This source file may be used and distributed without restriction
// provided that this copyright statement is not removed from the file
// and that any derivative work contains the original copyright notice
// and the associated disclaimer.
//
// THIS SOURCE FILE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS
// OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
// WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
//
// Purpose : synthesizable CRC function
//   * polynomial: (0 1 2 4 5 7 8 10 11 12 16 22 23 26 32)
//   * data width: 8
//
// Info : tools@easics.be
//        http://www.easics.com
////////////////////////////////////////////////////////////////////////////////
module CRC32_D8(nextCRC32_D8,Data,crc,final);

  // polynomial: (0 1 2 4 5 7 8 10 11 12 16 22 23 26 32)
  // data width: 8
  // convention: the first serial bit is D[7]
  output [31:0] nextCRC32_D8;
  output [31:0] final;
    input [7:0] Data;
    input [31:0] crc;
    wire [7:0] d;
    wire [31:0] c;
    wire [31:0] newcrc;

  //  always@(*)
 // begin
  assign  d = Data;
  assign  c = crc;

  assign  newcrc[0] = d[7] ^ d[1] ^ c[24] ^ c[30];
  assign  newcrc[1] = d[7] ^ d[6] ^ d[1] ^ d[0] ^ c[24] ^ c[25] ^ c[30] ^ c[31];
  assign  newcrc[2] = d[7] ^ d[6] ^ d[5] ^ d[1] ^ d[0] ^ c[24] ^ c[25] ^ c[26] ^ c[30] ^ c[31];
  assign  newcrc[3] = d[6] ^ d[5] ^ d[4] ^ d[0] ^ c[25] ^ c[26] ^ c[27] ^ c[31];
  assign  newcrc[4] = d[7] ^ d[5] ^ d[4] ^ d[3] ^ d[1] ^ c[24] ^ c[26] ^ c[27] ^ c[28] ^ c[30];
  assign  newcrc[5] = d[7] ^ d[6] ^ d[4] ^ d[3] ^ d[2] ^ d[1] ^ d[0] ^ c[24] ^ c[25] ^ c[27] ^ c[28] ^ c[29] ^ c[30] ^ c[31];
  assign  newcrc[6] = d[6] ^ d[5] ^ d[3] ^ d[2] ^ d[1] ^ d[0] ^ c[25] ^ c[26] ^ c[28] ^ c[29] ^ c[30] ^ c[31];
  assign  newcrc[7] = d[7] ^ d[5] ^ d[4] ^ d[2] ^ d[0] ^ c[24] ^ c[26] ^ c[27] ^ c[29] ^ c[31];
  assign  newcrc[8] = d[7] ^ d[6] ^ d[4] ^ d[3] ^ c[0] ^ c[24] ^ c[25] ^ c[27] ^ c[28];
  assign  newcrc[9] = d[6] ^ d[5] ^ d[3] ^ d[2] ^ c[1] ^ c[25] ^ c[26] ^ c[28] ^ c[29];
  assign  newcrc[10] = d[2] ^ d[7] ^ d[5] ^ d[4] ^ c[2] ^ c[24] ^ c[26] ^ c[27] ^ c[29];
  assign  newcrc[11] = d[7] ^ d[6] ^ d[4] ^ d[3] ^ c[3] ^ c[24] ^ c[25] ^ c[27] ^ c[28];
  assign  newcrc[12] = d[7] ^ d[6] ^ d[5] ^ d[3] ^ d[2] ^ d[1] ^ c[4] ^ c[24] ^ c[25] ^ c[26] ^ c[28] ^ c[29] ^ c[30];
  assign  newcrc[13] = d[6] ^ d[5] ^ d[4] ^ d[2] ^ d[1] ^ d[0] ^ c[5] ^ c[25] ^ c[26] ^ c[27] ^ c[29] ^ c[30] ^ c[31];
  assign  newcrc[14] = d[5] ^ d[4] ^ d[3] ^ d[1] ^ d[0] ^ c[6] ^ c[26] ^ c[27] ^ c[28] ^ c[30] ^ c[31];
  assign  newcrc[15] = d[4] ^ d[3] ^ d[2] ^ d[0] ^ c[7] ^ c[27] ^ c[28] ^ c[29] ^ c[31];
  assign  newcrc[16] = d[7] ^ d[3] ^ d[2] ^ c[8] ^ c[24] ^ c[28] ^ c[29];
  assign  newcrc[17] = d[6] ^ d[2] ^ d[1] ^ c[9] ^ c[25] ^ c[29] ^ c[30];
  assign  newcrc[18] = d[5] ^ d[1] ^ d[0] ^ c[10] ^ c[26] ^ c[30] ^ c[31];
  assign  newcrc[19] = d[4] ^ d[0] ^ c[11] ^ c[27] ^ c[31];
  assign  newcrc[20] = d[3] ^ c[12] ^ c[28];
  assign  newcrc[21] = d[2] ^ c[13] ^ c[29];
  assign  newcrc[22] = d[7] ^ c[14] ^ c[24];
  assign  newcrc[23] = d[7] ^ d[6] ^ d[1] ^ c[15] ^ c[24] ^ c[25] ^ c[30];
  assign  newcrc[24] = d[6] ^ d[5] ^ d[0] ^ c[16] ^ c[25] ^ c[26] ^ c[31];
  assign  newcrc[25] = d[5] ^ d[4] ^ c[17] ^ c[26] ^ c[27];
  assign  newcrc[26] = d[7] ^ d[4] ^ d[3] ^ d[1] ^ c[18] ^ c[24] ^ c[27] ^ c[28] ^ c[30];
  assign  newcrc[27] = d[6] ^ d[3] ^ d[2] ^ d[0] ^ c[19] ^ c[25] ^ c[28] ^ c[29] ^ c[31];
  assign  newcrc[28] = d[5] ^ d[2] ^ d[1] ^ c[20] ^ c[26] ^ c[29] ^ c[30];
  assign  newcrc[29] = d[4] ^ d[1] ^ d[0] ^ c[21] ^ c[27] ^ c[30] ^ c[31];
  assign  newcrc[30] = d[3] ^ d[0] ^ c[22] ^ c[28] ^ c[31];
  assign  newcrc[31] = d[2] ^ c[23] ^ c[29];
  assign  nextCRC32_D8 = newcrc;
  
  
  
  wire [31:0]  final;

assign final[31] = ~nextCRC32_D8[0];
assign final[30] = ~nextCRC32_D8[1 ];
assign final[29] = ~nextCRC32_D8[2 ];
assign final[28] = ~nextCRC32_D8[3 ];
assign final[27] = ~nextCRC32_D8[4 ];
assign final[26] = ~nextCRC32_D8[5 ];
assign final[25] = ~nextCRC32_D8[6 ];
assign final[24] = ~nextCRC32_D8[7 ];
assign final[23] = ~nextCRC32_D8[8 ];
assign final[22] = ~nextCRC32_D8[9 ];
assign final[21] = ~nextCRC32_D8[10];
assign final[20] = ~nextCRC32_D8[11];
assign final[19] = ~nextCRC32_D8[12];
assign final[18] = ~nextCRC32_D8[13];
assign final[17] = ~nextCRC32_D8[14];
assign final[16] = ~nextCRC32_D8[15];
assign final[15] = ~nextCRC32_D8[16];
assign final[14] = ~nextCRC32_D8[17];
assign final[13] = ~nextCRC32_D8[18];
assign final[12] = ~nextCRC32_D8[19];
assign final[11] = ~nextCRC32_D8[20];
assign final[10] = ~nextCRC32_D8[21];
assign final[9 ] = ~nextCRC32_D8[22];
assign final[8 ] = ~nextCRC32_D8[23];
assign final[7 ] = ~nextCRC32_D8[24];
assign final[6 ] = ~nextCRC32_D8[25];
assign final[5 ] = ~nextCRC32_D8[26];
assign final[4 ] = ~nextCRC32_D8[27];
assign final[3 ] = ~nextCRC32_D8[28];
assign final[2 ] = ~nextCRC32_D8[29];
assign final[1 ] = ~nextCRC32_D8[30];
assign final[0 ] = ~nextCRC32_D8[31];
//  end
//  endfunction
endmodule
