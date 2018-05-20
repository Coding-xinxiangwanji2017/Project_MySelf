module flash(
	
	input  wire        clk           ,
	input  wire        rst_n         ,
	                                 
	input  wire        erase_en      ,
	input  wire[24:0]  erase_addr    ,
	output wire        erase_done    , 
                                   
	input  wire        prog_en       ,
  input  wire[24:0]  prog_addr     ,
	input  wire[9:0]   prog_length   ,
	output wire        prog_done     ,

	output wire        fifo_rd_en    ,
	input  wire[15:0]  fifo_rd_data  ,
	input  wire        fifo_rd_valid ,
	
  input  wire        read_en       ,  
  input  wire[24:0]  read_addr     ,  
  input  wire[16:0]  read_length   ,  
  output wire[15:0]  read_data     ,  
  output wire        read_valid    ,  
  output wire        read_done     ,  

  output wire[24:0]  a             ,
  inout  wire[15:0]  dq            ,
  input  wire        wt_n          ,
  output wire        ce_n          ,
  output wire        we_n          ,
  output wire        adv_n         ,
  output wire        oe_n          ,
  output wire        clk_f         ,
  output wire        rst_f         
);

  wire        cmd_wr_en     ;
  wire[24:0]  cmd_wr_addr   ;
  wire[15:0]  cmd_wr_data   ;
  wire        cmd_wr_done   ;  
             
  wire        cmd_rd_en     ;
  wire[24:0]  cmd_rd_addr   ;
  wire[15:0]  cmd_rd_data   ;
  wire        cmd_rd_done   ;
  
  wire        brd_en        ;  
  wire[24:0]  brd_addr      ;  
  wire[16:0]  brd_length    ;  
  wire[15:0]  brd_data      ;  
  wire        brd_valid     ;  
  wire        brd_done      ;  
 
  wire        erase_wr_en   ;
  wire[24:0]  erase_wr_addr ;
  wire[15:0]  erase_wr_data ;
  wire        erase_wr_done ;  
                            
  wire        erase_rd_en   ;
  wire[24:0]  erase_rd_addr ;
  wire[15:0]  erase_rd_data ;
  wire        erase_rd_done ;
  
  wire        prog_wr_en    ;
  wire[24:0]  prog_wr_addr  ;
  wire[15:0]  prog_wr_data  ;
  wire        prog_wr_done  ;  
              
  wire        prog_rd_en    ;
  wire[24:0]  prog_rd_addr  ;
  wire[15:0]  prog_rd_data  ;
  wire        prog_rd_done  ;
  
  wire        read_wr_en    ; 
  wire[24:0]  read_wr_addr  ; 
  wire[15:0]  read_wr_data  ; 
  wire        read_wr_done  ; 

  
  assign cmd_wr_en     =  erase_wr_en   | prog_wr_en   | read_wr_en   ;
  assign cmd_wr_addr   =  erase_wr_addr | prog_wr_addr | read_wr_addr ;
  assign cmd_wr_data   =  erase_wr_data | prog_wr_data | read_wr_data ;
  assign erase_wr_done = cmd_wr_done;
  assign prog_wr_done  = cmd_wr_done;
  assign read_wr_done  = cmd_wr_done;  
                        
  assign cmd_rd_en     =  erase_rd_en   | prog_rd_en  ;
  assign cmd_rd_addr   =  erase_rd_addr | prog_rd_addr;
  assign erase_rd_data = cmd_rd_data;
  assign prog_rd_data  = cmd_rd_data;
  assign erase_rd_done = cmd_rd_done;
  assign prog_rd_done  = cmd_rd_done; 

	erase erase(
	.clk          (clk          ),
	.rst_n        (rst_n        ),
	.erase_en     (erase_en     ),
                              
	.erase_addr   (erase_addr   ),
	.erase_done   (erase_done   ),
                
  .wr_en        (erase_wr_en  ),
  .wr_addr      (erase_wr_addr),
  .wr_data      (erase_wr_data),
  .wr_done      (erase_wr_done),  
                              
  .rd_en        (erase_rd_en  ),
  .rd_addr      (erase_rd_addr),
  .rd_data      (erase_rd_data),
  .rd_done      (erase_rd_done)	
  );

	prog prog(
	.clk          (clk          ),
	.rst_n        (rst_n        ),
	.prog_en      (prog_en      ),   
                              
	.prog_addr    (prog_addr    ),
	.prog_length  (prog_length  ),
	.prog_done    (prog_done    ),

	.fifo_rd_en   (fifo_rd_en   ),
	.fifo_rd_data (fifo_rd_data ),
	.fifo_rd_valid(fifo_rd_valid),

  .wr_en        (prog_wr_en   ),
  .wr_addr      (prog_wr_addr ),
  .wr_data      (prog_wr_data ),
  .wr_done      (prog_wr_done ),  
                              
  .rd_en        (prog_rd_en   ),
  .rd_addr      (prog_rd_addr ),
  .rd_data      (prog_rd_data ),
  .rd_done      (prog_rd_done )	
  );
  
  bread bread(
	.clk          (clk          ),
	.rst_n        (rst_n        ),
	.read_en      (read_en      ),

	.read_addr    (read_addr    ),
	.read_length  (read_length  ),
	.read_data    (read_data    ),
	.read_valid   (read_valid   ),
	.read_done    (read_done    ),
	
  .wr_en        (read_wr_en   ),
  .wr_addr      (read_wr_addr ),
  .wr_data      (read_wr_data ),
  .wr_done      (read_wr_done ),  
                               
  .rd_en        (brd_en       ),
  .rd_addr      (brd_addr     ),
  .rd_length    (brd_length   ),
  .rd_data      (brd_data     ),
  .rd_valid     (brd_valid    ),
  .rd_done      (brd_done     )	
  );  	

	cmd cmd(
	.clk          (clk          ), 
	.rst_n        (rst_n        ),
                              
	.wr_en        (cmd_wr_en    ),
	.wr_addr      (cmd_wr_addr  ),
	.wr_data      (cmd_wr_data  ),
	.wr_done      (cmd_wr_done  ),  
                              
	.rd_en        (cmd_rd_en    ),
	.rd_addr      (cmd_rd_addr  ),
	.rd_data      (cmd_rd_data  ),
	.rd_done      (cmd_rd_done  ),
	
	.brd_en       (brd_en       ),
	.brd_addr     (brd_addr     ),
	.brd_length   (brd_length   ),
	.brd_data     (brd_data     ),
	.brd_valid    (brd_valid    ),
	.brd_done     (brd_done     ),
                              
	.a            (a            ),
	.dq           (dq           ),
	.wt_n         (wt_n         ),
	.ce_n         (ce_n         ),
	.we_n         (we_n         ),
	.adv_n        (adv_n        ),
	.oe_n         (oe_n         ),
	.clk_f        (clk_f        ),
	.rst_f        (rst_f        )
  );

endmodule