`timescale 1 ns / 1 ns

module m_crc32de8_eth(rst_n, sys_clk, i_cpsl_init, im_cpsv_data, i_cpsl_crcen, i_cpsl_crcend, o_cpsl_crcerr);

   input         rst_n         ;
   input         sys_clk       ;
                               
   input         i_cpsl_init   ;
   input  [07:0] im_cpsv_data  ;
   input         i_cpsl_crcen  ;
   input         i_cpsl_crcend ;
   output        o_cpsl_crcerr ;
   reg           o_cpsl_crcerr ;
                 
   wire [07:0]   w_prsv_d_s    ;
   reg  [31:0]   r_prsv_c_s    ;
   
   assign w_prsv_d_s[7] = im_cpsv_data[0];
   assign w_prsv_d_s[6] = im_cpsv_data[1];
   assign w_prsv_d_s[5] = im_cpsv_data[2];
   assign w_prsv_d_s[4] = im_cpsv_data[3];
   assign w_prsv_d_s[3] = im_cpsv_data[4];
   assign w_prsv_d_s[2] = im_cpsv_data[5];
   assign w_prsv_d_s[1] = im_cpsv_data[6];
   assign w_prsv_d_s[0] = im_cpsv_data[7];
   
   
   always @(negedge rst_n or posedge sys_clk)
      if (!rst_n == 1'b1)
         r_prsv_c_s <= 32'hFFFFFFFF;
      else 
      begin
         if (i_cpsl_init == 1'b1)
            r_prsv_c_s <= 32'hFFFFFFFF;
         else if (i_cpsl_crcen == 1'b1)
         begin
            r_prsv_c_s[0] <= w_prsv_d_s[6] ^ w_prsv_d_s[0] ^ r_prsv_c_s[24] ^ r_prsv_c_s[30];
            r_prsv_c_s[1] <= w_prsv_d_s[7] ^ w_prsv_d_s[6] ^ w_prsv_d_s[1] ^ w_prsv_d_s[0] ^ r_prsv_c_s[24] ^ r_prsv_c_s[25] ^ r_prsv_c_s[30] ^ r_prsv_c_s[31];
            r_prsv_c_s[2] <= w_prsv_d_s[7] ^ w_prsv_d_s[6] ^ w_prsv_d_s[2] ^ w_prsv_d_s[1] ^ w_prsv_d_s[0] ^ r_prsv_c_s[24] ^ r_prsv_c_s[25] ^ r_prsv_c_s[26] ^ r_prsv_c_s[30] ^ r_prsv_c_s[31];
            r_prsv_c_s[3] <= w_prsv_d_s[7] ^ w_prsv_d_s[3] ^ w_prsv_d_s[2] ^ w_prsv_d_s[1] ^ r_prsv_c_s[25] ^ r_prsv_c_s[26] ^ r_prsv_c_s[27] ^ r_prsv_c_s[31];
            r_prsv_c_s[4] <= w_prsv_d_s[6] ^ w_prsv_d_s[4] ^ w_prsv_d_s[3] ^ w_prsv_d_s[2] ^ w_prsv_d_s[0] ^ r_prsv_c_s[24] ^ r_prsv_c_s[26] ^ r_prsv_c_s[27] ^ r_prsv_c_s[28] ^ r_prsv_c_s[30];
            r_prsv_c_s[5] <= w_prsv_d_s[7] ^ w_prsv_d_s[6] ^ w_prsv_d_s[5] ^ w_prsv_d_s[4] ^ w_prsv_d_s[3] ^ w_prsv_d_s[1] ^ w_prsv_d_s[0] ^ r_prsv_c_s[24] ^ r_prsv_c_s[25] ^ r_prsv_c_s[27] ^ r_prsv_c_s[28] ^ r_prsv_c_s[29] ^ r_prsv_c_s[30] ^ r_prsv_c_s[31];
            r_prsv_c_s[6] <= w_prsv_d_s[7] ^ w_prsv_d_s[6] ^ w_prsv_d_s[5] ^ w_prsv_d_s[4] ^ w_prsv_d_s[2] ^ w_prsv_d_s[1] ^ r_prsv_c_s[25] ^ r_prsv_c_s[26] ^ r_prsv_c_s[28] ^ r_prsv_c_s[29] ^ r_prsv_c_s[30] ^ r_prsv_c_s[31];
            r_prsv_c_s[7] <= w_prsv_d_s[7] ^ w_prsv_d_s[5] ^ w_prsv_d_s[3] ^ w_prsv_d_s[2] ^ w_prsv_d_s[0] ^ r_prsv_c_s[24] ^ r_prsv_c_s[26] ^ r_prsv_c_s[27] ^ r_prsv_c_s[29] ^ r_prsv_c_s[31];
            
            r_prsv_c_s[8] <= w_prsv_d_s[4] ^ w_prsv_d_s[3] ^ w_prsv_d_s[1] ^ w_prsv_d_s[0] ^ r_prsv_c_s[0] ^ r_prsv_c_s[24] ^ r_prsv_c_s[25] ^ r_prsv_c_s[27] ^ r_prsv_c_s[28];
            r_prsv_c_s[9] <= w_prsv_d_s[5] ^ w_prsv_d_s[4] ^ w_prsv_d_s[2] ^ w_prsv_d_s[1] ^ r_prsv_c_s[1] ^ r_prsv_c_s[25] ^ r_prsv_c_s[26] ^ r_prsv_c_s[28] ^ r_prsv_c_s[29];
            r_prsv_c_s[10] <= w_prsv_d_s[5] ^ w_prsv_d_s[3] ^ w_prsv_d_s[2] ^ w_prsv_d_s[0] ^ r_prsv_c_s[2] ^ r_prsv_c_s[24] ^ r_prsv_c_s[26] ^ r_prsv_c_s[27] ^ r_prsv_c_s[29];
            r_prsv_c_s[11] <= w_prsv_d_s[4] ^ w_prsv_d_s[3] ^ w_prsv_d_s[1] ^ w_prsv_d_s[0] ^ r_prsv_c_s[3] ^ r_prsv_c_s[24] ^ r_prsv_c_s[25] ^ r_prsv_c_s[27] ^ r_prsv_c_s[28];
            r_prsv_c_s[12] <= w_prsv_d_s[6] ^ w_prsv_d_s[5] ^ w_prsv_d_s[4] ^ w_prsv_d_s[2] ^ w_prsv_d_s[1] ^ w_prsv_d_s[0] ^ r_prsv_c_s[4] ^ r_prsv_c_s[24] ^ r_prsv_c_s[25] ^ r_prsv_c_s[26] ^ r_prsv_c_s[28] ^ r_prsv_c_s[29] ^ r_prsv_c_s[30];
            r_prsv_c_s[13] <= w_prsv_d_s[7] ^ w_prsv_d_s[6] ^ w_prsv_d_s[5] ^ w_prsv_d_s[3] ^ w_prsv_d_s[2] ^ w_prsv_d_s[1] ^ r_prsv_c_s[5] ^ r_prsv_c_s[25] ^ r_prsv_c_s[26] ^ r_prsv_c_s[27] ^ r_prsv_c_s[29] ^ r_prsv_c_s[30] ^ r_prsv_c_s[31];
            r_prsv_c_s[14] <= w_prsv_d_s[7] ^ w_prsv_d_s[6] ^ w_prsv_d_s[4] ^ w_prsv_d_s[3] ^ w_prsv_d_s[2] ^ r_prsv_c_s[6] ^ r_prsv_c_s[26] ^ r_prsv_c_s[27] ^ r_prsv_c_s[28] ^ r_prsv_c_s[30] ^ r_prsv_c_s[31];
            r_prsv_c_s[15] <= w_prsv_d_s[7] ^ w_prsv_d_s[5] ^ w_prsv_d_s[4] ^ w_prsv_d_s[3] ^ r_prsv_c_s[7] ^ r_prsv_c_s[27] ^ r_prsv_c_s[28] ^ r_prsv_c_s[29] ^ r_prsv_c_s[31];
            
            r_prsv_c_s[16] <= w_prsv_d_s[5] ^ w_prsv_d_s[4] ^ w_prsv_d_s[0] ^ r_prsv_c_s[8] ^ r_prsv_c_s[24] ^ r_prsv_c_s[28] ^ r_prsv_c_s[29];
            r_prsv_c_s[17] <= w_prsv_d_s[6] ^ w_prsv_d_s[5] ^ w_prsv_d_s[1] ^ r_prsv_c_s[9] ^ r_prsv_c_s[25] ^ r_prsv_c_s[29] ^ r_prsv_c_s[30];
            r_prsv_c_s[18] <= w_prsv_d_s[7] ^ w_prsv_d_s[6] ^ w_prsv_d_s[2] ^ r_prsv_c_s[10] ^ r_prsv_c_s[26] ^ r_prsv_c_s[30] ^ r_prsv_c_s[31];
            r_prsv_c_s[19] <= w_prsv_d_s[7] ^ w_prsv_d_s[3] ^ r_prsv_c_s[11] ^ r_prsv_c_s[27] ^ r_prsv_c_s[31];
            r_prsv_c_s[20] <= w_prsv_d_s[4] ^ r_prsv_c_s[12] ^ r_prsv_c_s[28];
            r_prsv_c_s[21] <= w_prsv_d_s[5] ^ r_prsv_c_s[13] ^ r_prsv_c_s[29];
            r_prsv_c_s[22] <= w_prsv_d_s[0] ^ r_prsv_c_s[14] ^ r_prsv_c_s[24];
            r_prsv_c_s[23] <= w_prsv_d_s[6] ^ w_prsv_d_s[1] ^ w_prsv_d_s[0] ^ r_prsv_c_s[15] ^ r_prsv_c_s[24] ^ r_prsv_c_s[25] ^ r_prsv_c_s[30];
            
            r_prsv_c_s[24] <= w_prsv_d_s[7] ^ w_prsv_d_s[2] ^ w_prsv_d_s[1] ^ r_prsv_c_s[16] ^ r_prsv_c_s[25] ^ r_prsv_c_s[26] ^ r_prsv_c_s[31];
            r_prsv_c_s[25] <= w_prsv_d_s[3] ^ w_prsv_d_s[2] ^ r_prsv_c_s[17] ^ r_prsv_c_s[26] ^ r_prsv_c_s[27];
            r_prsv_c_s[26] <= w_prsv_d_s[6] ^ w_prsv_d_s[4] ^ w_prsv_d_s[3] ^ w_prsv_d_s[0] ^ r_prsv_c_s[18] ^ r_prsv_c_s[24] ^ r_prsv_c_s[27] ^ r_prsv_c_s[28] ^ r_prsv_c_s[30];
            r_prsv_c_s[27] <= w_prsv_d_s[7] ^ w_prsv_d_s[5] ^ w_prsv_d_s[4] ^ w_prsv_d_s[1] ^ r_prsv_c_s[19] ^ r_prsv_c_s[25] ^ r_prsv_c_s[28] ^ r_prsv_c_s[29] ^ r_prsv_c_s[31];
            r_prsv_c_s[28] <= w_prsv_d_s[6] ^ w_prsv_d_s[5] ^ w_prsv_d_s[2] ^ r_prsv_c_s[20] ^ r_prsv_c_s[26] ^ r_prsv_c_s[29] ^ r_prsv_c_s[30];
            r_prsv_c_s[29] <= w_prsv_d_s[7] ^ w_prsv_d_s[6] ^ w_prsv_d_s[3] ^ r_prsv_c_s[21] ^ r_prsv_c_s[27] ^ r_prsv_c_s[30] ^ r_prsv_c_s[31];
            r_prsv_c_s[30] <= w_prsv_d_s[7] ^ w_prsv_d_s[4] ^ r_prsv_c_s[22] ^ r_prsv_c_s[28] ^ r_prsv_c_s[31];
            r_prsv_c_s[31] <= w_prsv_d_s[5] ^ r_prsv_c_s[23] ^ r_prsv_c_s[29];
         end
         else
            ;
      end
   
   
   always @(negedge rst_n or posedge sys_clk)
      if (!rst_n == 1'b1)
         o_cpsl_crcerr <= 1'b0;
      else 
      begin
         if (i_cpsl_init == 1'b1)
            o_cpsl_crcerr <= 1'b0;
         else if (i_cpsl_crcend == 1'b1 & r_prsv_c_s == 32'hC704DD7B)
            o_cpsl_crcerr <= 1'b1;
         else
            o_cpsl_crcerr <= 1'b0;
      end
   
endmodule
