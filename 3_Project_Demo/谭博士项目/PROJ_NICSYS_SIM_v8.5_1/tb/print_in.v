
`timescale 1ns / 100ps

module print_in(
    Rst,

    Clk,

    din,
    din_v

    );

  //=========================================================
  //-- I/O declaration
  //=========================================================

    input            Rst;

    input            Clk;
    input      [ 15: 0] din;
    input    din_v  ;
    
    integer    file_wr_id0;

  //=========================================================
  //-- 
  //=========================================================

  initial
    begin
      //------   open file operation   ---------------------------
      file_wr_id0    = $fopen("test_print.txt", "w");
  end

  always @(posedge Clk )
    begin
      if (din_v )
      begin
          $fdisplay(file_wr_id0, "%h",  din  );
      end
    end



endmodule

