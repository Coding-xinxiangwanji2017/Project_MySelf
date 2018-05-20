module flash_control(											
	input  wire          clk       ,
	input  wire          rst_n     ,
	
	input  wire          wr_clk    ,
	input  wire          rst_wfifo ,	
	input  wire          wr_fifo   ,
	input  wire[15:0]    data_in   ,	
	input  wire          wr_flash  ,
	       
	input  wire          rd_clk    ,	
	input  wire          rst_rfifo ,
	input  wire          rd_fifo   ,
	output wire[15:0]    data_out  ,
	output wire          data_valid,
	input  wire          rd_flash  ,

	input  wire          era       ,	
	input  wire[13:0]    row       ,	
	output wire          done_toe  ,
	output wire          done_move ,	
	output wire          busy      ,
	
	output wire[15:0]    o_read_data,
	output wire          o_read_valid,

	output wire[24:0]    A         ,
	inout  wire[15:0]    dq        ,
	output wire          oe        ,
	output wire          ce        ,
	output wire          we        ,
	output wire          adv       ,
	input  wire          wd        ,
	output wire          wp        ,
	output wire          clk_f     ,
	output wire          rst_f          
);

   wire         erase_en     ;
   wire[24:0]   erase_addr   ;
   wire         erase_done   ;

   wire         prog_en      ;
   wire[24:0]   prog_addr    ;
   wire[9:0]    prog_length  ;
   wire         prog_done    ;
   
   wire         read_en      ;   
   wire[24:0]   read_addr    ;    
   wire[16:0]   read_length  ;    
   wire         read_done    ;
   wire[15:0]   read_data    ;
   wire         read_valid   ; 
   
   wire         fifo_rd_en   ;   
   wire[15:0]   fifo_rd_data ;   
   wire         fifo_rd_valid;  
   
   reg          w_done_move1 ;
   reg          w_done_move2 ; 

   assign o_read_data  = read_data ;
   assign o_read_valid = read_valid;   
       
	flash_fifo_4k_16 flash_fifo_wr(
		.rst              (rst_wfifo    ),
		.wr_clk           (wr_clk       ),
		.rd_clk           (clk          ),
		.din              (data_in      ),
		.wr_en            (wr_fifo      ),
	  .rd_en            (fifo_rd_en   ),
	  .dout             (fifo_rd_data ),
	  .valid            (fifo_rd_valid),
	  .full             (             ),
    .empty            (             )
	);                                
                                    
	flash_fifo_4k_16 flash_fifo_rd( 
		.rst              (rst_rfifo    ),
		.wr_clk           (clk          ),
		.rd_clk           (rd_clk       ),
		.din              (read_data    ),
		.wr_en            (read_valid   ),
	  .rd_en            (rd_fifo      ),
	  .dout             (data_out     ),
	  .valid            (data_valid   ),
    .full             (             ),
    .empty            (             )
	);
	
	flash flash_intf(	
    .clk              (clk          ),
    .rst_n            (rst_n        ),
                                    
    .erase_en         (erase_en     ),
    .erase_addr       (erase_addr   ),
    .erase_done       (erase_done   ), 
                                    
    .prog_en          (prog_en      ),
    .prog_addr        (prog_addr    ),
    .prog_length      (prog_length  ),
    .prog_done        (prog_done    ),

    .fifo_rd_en       (fifo_rd_en   ),
    .fifo_rd_data     (fifo_rd_data ),
    .fifo_rd_valid    (fifo_rd_valid),

    .read_en          (read_en      ),  
    .read_addr        (read_addr    ),  
    .read_length      (read_length  ),  
    .read_data        (read_data    ),  
    .read_valid       (read_valid   ),  
    .read_done        (read_done    ),  
                                    
    .a                (A            ),
    .dq               (dq           ),
    .wt_n             (wd           ),
    .ce_n             (ce           ),
    .we_n             (we           ),
    .adv_n            (adv          ),
    .oe_n             (oe           ),
    .clk_f            (clk_f        ),
    .rst_f            (rst_f        )
  );	                              
	  assign wp = 1;                  
                                    
  control flash_control(						 					
	  .clk              (clk          ),
	  .rst_n            (rst_n        ),
                                    
	  .wr_flash         (wr_flash     ),
	  .rd_flash         (rd_flash     ),
                                    
	  .era              (era          ),	
	  .row              (row          ),
                                    
	  .erase_en         (erase_en     ),
	  .erase_addr       (erase_addr   ),
	  .erase_done       (erase_done   ),	
                                    
	  .prog_en          (prog_en      ),
	  .prog_addr        (prog_addr    ),
	  .prog_length      (prog_length  ), 
	  .prog_done        (prog_done    ),
                                    
	  .read_en          (read_en      ),
	  .read_addr        (read_addr    ),
	  .read_length      (read_length  ),
	  .read_done        (read_done    ),	
                                    
	  .toe_done         (done_toe     ),
	  .move_done        (w_done_move  ),	
	  .busy             (busy         )   
);	 

    always @ (posedge clk)
    begin
      w_done_move1 <= w_done_move;
    end

    always @ (posedge clk)
    begin
      w_done_move2 <= w_done_move1;
    end

    assign done_move = w_done_move1 | w_done_move2;

endmodule