`timescale 1 ns / 1 ns


module m_crc32en8_eth(rst_n, sys_clk, i_cpsl_init, im_cpsv_data, i_cpsl_crcen, om_cpsv_crcresult);

   input         rst_n               ;
   input         sys_clk             ;
                                   
   input         i_cpsl_init         ;
   input  [07:0] im_cpsv_data        ;
   input         i_cpsl_crcen        ;
   output [31:0] om_cpsv_crcresult   ;
   
                                        
   reg  [31:0]   om_cpsv_crcresult   ;   
   wire [07:0]   w_prsv_d_s          ;
   reg  [31:0]   r_prsv_c_s          ;
   
   assign w_prsv_d_s[0] = im_cpsv_data[7];
   assign w_prsv_d_s[1] = im_cpsv_data[6];
   assign w_prsv_d_s[2] = im_cpsv_data[5];
   assign w_prsv_d_s[3] = im_cpsv_data[4];
   assign w_prsv_d_s[4] = im_cpsv_data[3];
   assign w_prsv_d_s[5] = im_cpsv_data[2];
   assign w_prsv_d_s[6] = im_cpsv_data[1];
   assign w_prsv_d_s[7] = im_cpsv_data[0];
   
   
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
      end
   
   
   always @(negedge rst_n or posedge sys_clk)
      if (!rst_n == 1'b1)
         om_cpsv_crcresult <= {32{1'b0}};
      else 
      begin
         om_cpsv_crcresult[31] <= (~r_prsv_c_s[24]);
         om_cpsv_crcresult[30] <= (~r_prsv_c_s[25]);
         om_cpsv_crcresult[29] <= (~r_prsv_c_s[26]);
         om_cpsv_crcresult[28] <= (~r_prsv_c_s[27]);
         om_cpsv_crcresult[27] <= (~r_prsv_c_s[28]);
         om_cpsv_crcresult[26] <= (~r_prsv_c_s[29]);
         om_cpsv_crcresult[25] <= (~r_prsv_c_s[30]);
         om_cpsv_crcresult[24] <= (~r_prsv_c_s[31]);
         
         om_cpsv_crcresult[23] <= (~r_prsv_c_s[16]);
         om_cpsv_crcresult[22] <= (~r_prsv_c_s[17]);
         om_cpsv_crcresult[21] <= (~r_prsv_c_s[18]);
         om_cpsv_crcresult[20] <= (~r_prsv_c_s[19]);
         om_cpsv_crcresult[19] <= (~r_prsv_c_s[20]);
         om_cpsv_crcresult[18] <= (~r_prsv_c_s[21]);
         om_cpsv_crcresult[17] <= (~r_prsv_c_s[22]);
         om_cpsv_crcresult[16] <= (~r_prsv_c_s[23]);
         
         om_cpsv_crcresult[15] <= (~r_prsv_c_s[8]);
         om_cpsv_crcresult[14] <= (~r_prsv_c_s[9]);
         om_cpsv_crcresult[13] <= (~r_prsv_c_s[10]);
         om_cpsv_crcresult[12] <= (~r_prsv_c_s[11]);
         om_cpsv_crcresult[11] <= (~r_prsv_c_s[12]);
         om_cpsv_crcresult[10] <= (~r_prsv_c_s[13]);
         om_cpsv_crcresult[9] <= (~r_prsv_c_s[14]);
         om_cpsv_crcresult[8] <= (~r_prsv_c_s[15]);
         
         om_cpsv_crcresult[7] <= (~r_prsv_c_s[0]);
         om_cpsv_crcresult[6] <= (~r_prsv_c_s[1]);
         om_cpsv_crcresult[5] <= (~r_prsv_c_s[2]);
         om_cpsv_crcresult[4] <= (~r_prsv_c_s[3]);
         om_cpsv_crcresult[3] <= (~r_prsv_c_s[4]);
         om_cpsv_crcresult[2] <= (~r_prsv_c_s[5]);
         om_cpsv_crcresult[1] <= (~r_prsv_c_s[6]);
         om_cpsv_crcresult[0] <= (~r_prsv_c_s[7]);
      end
   
endmodule
