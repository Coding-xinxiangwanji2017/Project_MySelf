module cmd(

	input  wire       clk      , 
	input  wire       rst_n    ,
                    
  input  wire       wr_en    ,
  input  wire[24:0] wr_addr  ,
  input  wire[15:0] wr_data  ,
  output wire       wr_done  ,  

  input  wire       rd_en      ,
  input  wire[24:0] rd_addr    ,
  output wire[15:0] rd_data    ,
  output wire       rd_done    ,
                               
  input  wire       brd_en     ,
  input  wire[24:0] brd_addr   ,
  input  wire[16:0] brd_length ,
  output wire[15:0] brd_data   ,
  output wire       brd_valid  ,
  output wire       brd_done   ,
                               
  output wire[24:0] a          ,
  inout  wire[15:0] dq         ,
  input  wire       wt_n       ,
  output wire       ce_n       ,
  output wire       we_n       ,
  output wire       adv_n      ,
  output wire       oe_n       ,
  output wire       clk_f      ,
  output wire       rst_f    

);
 
  wire       wr_oe_n   ; 
  wire       wr_ce_n   ; 
  wire       wr_we_n   ; 
  wire       wr_adv_n  ; 
  wire[24:0] wr_a      ;
  wire[15:0] wr_dq_o   ;
                       
  wire       rd_oe_n   ;
  wire       rd_ce_n   ;
  wire       rd_we_n   ;
  wire       rd_adv_n  ;
  wire[24:0] rd_a      ;
  wire[15:0] rd_dq_i   ;
  
  wire       brd_oe_n  ;
  wire       brd_ce_n  ;
  wire       brd_we_n  ;
  wire       brd_adv_n ;
  wire[24:0] brd_a     ;
  wire[15:0] brd_dq_i  ;
      
  wire       dq_en    ;
  wire       wr_dq_en ;
  wire       rd_dq_en ;
  wire       brd_dq_en;
  
  assign clk_f = ~clk;
  assign rst_f = rst_n;
  assign dq_en = wr_dq_en | rd_dq_en | brd_dq_en;
  assign dq = (dq_en)? wr_dq_o : 16'dz;
  assign rd_dq_i = dq;
  assign brd_dq_i = dq;

	assign a     = wr_a     | rd_a     | brd_a    ;
	assign oe_n  = wr_oe_n  & rd_oe_n  & brd_oe_n ;
	assign ce_n  = wr_ce_n  & rd_ce_n  & brd_ce_n ;
	assign we_n  = wr_we_n  & rd_we_n  & brd_we_n ;
	assign adv_n = wr_adv_n & rd_adv_n & brd_adv_n;

	write write_inst(
	.clk      (clk       ), 
	.rst_n    (rst_n     ),
  .wr_en    (wr_en     ),
  .wr_addr  (wr_addr   ),
  .wr_data  (wr_data   ),
  .wr_done  (wr_done   ),  
  .dq_oe    (wr_dq_en  ), 
  .a        (wr_a      ),
  .dq_o     (wr_dq_o   ),
  .ce_n     (wr_ce_n   ),
  .we_n     (wr_we_n   ),
  .adv_n    (wr_adv_n  ),
  .oe_n     (wr_oe_n   )
  );

	aread aread_inst(
	.clk      (clk       ), 
	.rst_n    (rst_n     ), 
  .rd_en    (rd_en     ), 
  .rd_addr  (rd_addr   ), 
  .rd_data  (rd_data   ), 
  .rd_done  (rd_done   ), 
  .dq_oe    (rd_dq_en  ), 
  .dq_i     (rd_dq_i   ),                 
  .a        (rd_a      ),
  .ce_n     (rd_ce_n   ),
  .oe_n     (rd_oe_n   ),
  .adv_n    (rd_adv_n  ),
  .we_n     (rd_we_n   ),
  .wt_n     (wt_n      )
  );

	sread sread(
	.clk      (clk       ), 
	.rst_n    (rst_n     ),
	.rd_en    (brd_en    ),
	.rd_addr  (brd_addr  ),
	.rd_length(brd_length),
	.rd_data  (brd_data  ),
	.rd_valid (brd_valid ),
	.rd_done  (brd_done  ), 
	.dq_oe    (brd_dq_en ),           
	.dq_i     (brd_dq_i  ),                 
	.a        (brd_a     ),
	.ce_n     (brd_ce_n  ),
	.oe_n     (brd_oe_n  ),
	.adv_n    (brd_adv_n ),
	.we_n     (brd_we_n  ),
	.wt_n     (wt_n      )
  );
 
endmodule