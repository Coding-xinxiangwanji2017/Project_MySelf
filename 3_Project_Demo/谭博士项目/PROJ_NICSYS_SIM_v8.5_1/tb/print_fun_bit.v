
`timescale 1ns / 100ps

module print_fun_bit(
    Rst,

    Clk,

    din,
    din_v

    );

    parameter  FILE_NAME = "teat_file.txt";


  //=========================================================
  //-- I/O declaration
  //=========================================================

    input            Rst;

    input            Clk;
    input       din;
    input    din_v  ;
    
    integer    file_wr_id0;

  //=========================================================
  //-- 
  //=========================================================

  initial
    begin
      //------   open file operation   ---------------------------
      //file_wr_id0    = $fopen("test_print.txt", "w");
      file_wr_id0    = $fopen( FILE_NAME , "w");      
  end

  always @(posedge Clk )
    begin
      if (din_v )
      begin
          $fdisplay(file_wr_id0, "%b",  din  );         
      end
    end



endmodule

