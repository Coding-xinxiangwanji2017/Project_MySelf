
`timescale 1ns / 100ps

module print_fun(
    Rst,

    Clk,

    din,
    din_v

    );

    parameter  FILE_NAME = "teat_file.txt";
    parameter  data_width = 16;
    parameter  pirnt_format = "%h";
  //=========================================================
  //-- I/O declaration
  //=========================================================

    input            Rst;

    input            Clk;
    input      [ data_width -1 : 0] din;
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
        //  $fdisplay(file_wr_id0, "%h",  din  );
           if ( pirnt_format == "%h" ) 
               $fdisplay(file_wr_id0, "%h",  din  );    
           else if ( pirnt_format == "%d" ) 
               $fdisplay(file_wr_id0, "%d",  din  );  
           else if ( pirnt_format == "%b" ) 
               $fdisplay(file_wr_id0, "%b",  din  );        
          
      end
    end



endmodule

