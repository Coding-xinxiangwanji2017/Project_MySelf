`timescale 1ns/1ps

module flash_control
(											
	input           clk       ,
	output          clk_f     ,
	input           wr_clk    ,
	input	          rd_clk    ,
	input           rst_n     ,
	input           wr_fifo   ,
	input           rd_fifo   ,
	input   [15:0]  data_in   ,
	output  [15:0]  data_out  ,
	input   [13:0]  row       ,	
	output          done_toe  ,
	output          done_move ,	
	input           era       ,
	input           wr_flash  ,
	input           rd_flash  ,
	output  [24:0]  A         ,
	inout   [15:0]  dq        ,
	output          oe        ,
	output          ce        ,
	output          we        ,
	output          adv       ,
	input           wd        ,
	output          wp        ,
	output          rst_f     ,
	input          rst_wfifo  ,
	input          rst_rfifo  ,
	output         io_en      ,
	output  [15:0] dq_i       ,
	output         unlock_dqe ,
	output         erase_dqe ,
	output         write_dqe ,
	output         read_dqe ,
	output  [7:0]  read_cnt ,
	output  [4:0]  read_st  ,
	output         busy       
);
	
//	wire           io_en          ;///////////////
	wire           rst            ;
	
	wire   [15:0]  write_in       ;
	wire   [15:0]  read_out       ;
                 
	wire   [24:0]  rd_addr        ;
	wire   [24:0]  wr_addr        ;
	wire   [24:0]  block_addr     ;
	
	wire   [24:0]  unlock_A       ;
	wire   [15:0]  unlock_dq      ;
	wire           unlock_oe      ;
	wire           unlock_ce      ;
	wire           unlock_we      ;
	wire           unlock_adv     ;
	wire           unlock_wd      ;
	wire           unlock_wp      ;
//	wire           unlock_dqe     ;
	wire           unlock_rst     ;
	
	wire   [24:0]  erase_A        ;
	wire   [15:0]  erase_dq       ;
	wire           erase_oe       ;
	wire           erase_ce       ;
	wire           erase_we       ;
	wire           erase_adv      ;
	wire           erase_wd       ;
	wire           erase_wp       ;
//	wire           erase_dqe      ;
	wire           erase_rst      ;
		
	wire   [24:0]  read_A         ;
	wire   [15:0]  read_dq        ;
	wire           read_oe        ;
	wire           read_ce        ;
	wire           read_we        ;
	wire           read_adv       ;
	wire           read_wd        ;
	wire           read_wp        ;
//	wire           read_dqe       ;
	wire           read_rst       ;
	
	wire   [24:0]  write_A        ;
	wire   [15:0]  write_dq       ;
	wire           write_oe       ; 
	wire           write_ce       ;
	wire           write_we       ;
	wire           write_adv      ;
	wire           write_wd       ;
	wire           write_wp       ;
//	wire           write_dqe      ;
	wire           write_rst      ;	
	
	wire   [24:0]  lock_A         ;
	wire   [15:0]  lock_dq        ;
	wire           lock_oe        ;
	wire           lock_ce        ;
	wire           lock_we        ;
	wire           lock_adv       ;
	wire           lock_wd        ;
	wire           lock_wp        ;
//	wire           lock_dqe       ;
	wire           lock_rst       ;
	
	wire           unlock_en      ;
	wire           erase_en       ;
	wire           read_en        ;
	wire           write_en       ;
	wire           lock_en        ;
	
	wire           unlock_done    ;
	wire           erase_done     ;
	wire           read_done      ;
	wire           write_done     ;
	wire           lock_done      ;
	
//	wire   [15:0]  dq_i           ;///////////////////////////
	wire   [15:0]  dq_r           ;
	wire   [13:0]  w_row          ;
	
	wire           done_toe1      ;
	reg            done_toe2      ;
	reg            done_toe3      ;	
	wire           done_move1     ;
	reg            done_move2     ;
	reg            done_move3     ;
                 
	assign io_en = unlock_dqe | erase_dqe | write_dqe | read_dqe;
	assign flash_wr_clk = clk;
	assign flash_rd_clk = clk;
	assign clk_f = clk;
	
	assign rst = ~rst_n;
	assign dq_i = dq;
	assign dq = (io_en == 1)? dq_r : 16'dz;
	assign busy = unlock_en | erase_en | write_en | read_en; 
	
	assign  dq_r = unlock_dq | erase_dq | write_dq | read_dq;
	assign  A = unlock_A | erase_A | write_A | read_A;
	
	assign  oe = unlock_oe & erase_oe & write_oe & read_oe;
	assign  ce = unlock_ce & erase_ce & write_ce & read_ce;
	assign  we = unlock_we & erase_we & write_we & read_we;
	assign  adv = unlock_adv & erase_adv & write_adv & read_adv;
	assign  wp = unlock_wp & erase_wp & write_wp & read_wp;
	assign  rst_f = unlock_rst & erase_rst & write_rst & read_rst;
	
	always @ (posedge clk)
	begin
		done_toe2 <= done_toe1;
		done_move2 <= done_move1;	
	end
	
	always @ (posedge clk)
	begin
		done_toe3 <= done_toe2;
		done_move3 <= done_move2;			
	end		
	
	assign done_toe = done_toe1 | done_toe2 | done_toe3;		
	assign done_move = done_move1 | done_move2 | done_move3;
	
	flash_fsm fsm_inst(                  
		.clk              (clk         ), 
		.rst_n            (rst_n       ), 
		.unlock_done      (unlock_done ),  
		.erase_done       (erase_done  ), 
		.read_done        (read_done   ),
		.write_done       (write_done  ),
		.lock_done        (lock_done   ), 
		.wr_flash         (wr_flash    ),
		.rd_flash         (rd_flash    ),
		.era              (era         ),
		.row_in           (row         ),
		.unlock_en        (unlock_en   ),
		.erase_en         (erase_en    ), 		 
		.read_en          (read_en     ), 		
		.write_en         (write_en    ),  		 
		.lock_en          (lock_en     ),
		.row              (w_row       ),
		.done_toe         (done_toe1   ),
		.done_move        (done_move1  ) 
	);

	flash_unlock unlock_inst(
		.clk(clk), 
		.rst_n(rst_n), 
		.unlock_en(unlock_en), 
		.unlock_done(unlock_done), 
		.block_addr(block_addr), 
		.A(unlock_A), 
		.dq_i(dq_i),
		.dq_o(unlock_dq),
		.dqe(unlock_dqe),
		.oe(unlock_oe),
		.ce(unlock_ce), 
		.we(unlock_we), 
		.adv(unlock_adv), 
		.wp(unlock_wp), 
		.wd(wd),
		.rst_f(unlock_rst)
   );

	flash_erase erase_inst(
		.clk(clk), 
		.rst_n(rst_n), 
		.erase_en(erase_en), 
		.erase_done(erase_done), 
		.block_addr(block_addr), 
		.A(erase_A), 
		.dq_i(dq_i), 
		.dq_o(erase_dq),
		.dqe(erase_dqe),
		.oe(erase_oe), 
		.ce(erase_ce), 
		.we(erase_we), 
		.adv(erase_adv), 
		.wp(erase_wp), 
		.wd(wd),
		.rst_f(erase_rst)

	);

	flash_write write_inst(
		.clk(clk), 
		.rst_n(rst_n), 
		.write_en(write_en), 
		.write_done(write_done), 
		.wr_addr(wr_addr), 
		.block_addr(block_addr), 
		.write_in(write_in), 
		.fifo_rd(flash_rd), 
		.A(write_A), 
		.dq_i(dq_i),
		.dq_o(write_dq),
		.dqe(write_dqe), 
		.oe(write_oe), 
		.ce(write_ce), 
		.we(write_we), 
		.adv(write_adv), 
		.wp(write_wp),
		.wd(wd),
		.rst_f(write_rst)
	);

	flash_read read_inst(
		.clk(clk), 
		.rst_n(rst_n), 
		.read_en(read_en), 
		.read_st(read_st),
		.read_cnt (read_cnt),
		.read_done(read_done),
		.rd_addr(rd_addr), 
		.read_out(read_out), 
		.fifo_wr(flash_wr), 
		.A(read_A), 
		.dq_i(dq_i), 
		.dq_o(read_dq), 
		.dqe(read_dqe),
		.oe(read_oe), 
		.ce(read_ce), 
		.we(read_we), 
		.adv(read_adv), 
		.wp(read_wp), 
		.wd(wd),
		.rst_f(read_rst)
	);

	addr_gen addr_inst(
		.clk              (clk         ), 
		.rst_n            (rst_n       ), 
		.row              (w_row       ), 
		.rd_addr          (rd_addr     ), 
		.wr_addr          (wr_addr     ), 
		.block_addr       (block_addr  )
	);

	flash_fifo_4096_16 flash_fifo_wr(
		.rst              (rst_wfifo   ),
		.wr_clk           (wr_clk      ),
		.rd_clk           (flash_rd_clk),
		.din              (data_in     ),
		.wr_en            (wr_fifo     ),
	  .rd_en            (flash_rd    ),
	  .dout             (write_in    ),
	  .full             (            ),
    .empty            ()
	);

	flash_fifo_4096_16 flash_fifo_rd(
		.rst(rst_rfifo),
		.wr_clk(flash_wr_clk),
		.rd_clk(rd_clk),
		.din(read_out),
		.wr_en(flash_wr),
	  .rd_en(rd_fifo),
	  .dout(data_out),
    .full(),
    .empty()
	);
	
//	wire [127:0]TRIG0;
//		
//	assign TRIG0[15:0] = dq_i;
//	assign TRIG0[41:16] = erase_A;
//	assign TRIG0[42] = erase_oe;
//	assign TRIG0[43] = erase_ce;	
//	assign TRIG0[44] = erase_we;
//	assign TRIG0[45] = adv;
//	assign TRIG0[46] = wd;
//	assign TRIG0[62:47] = erase_dq;
//	assign TRIG0[63] = erase_en;
//	assign TRIG0[64] = read_en;
//	assign TRIG0[65] = unlock_en;
//	assign TRIG0[66] = write_en;
//	assign TRIG0[67] = erase_dqe;
//	assign TRIG0[68] = read_dqe;
//	assign TRIG0[69] = unlock_dqe;
//	assign TRIG0[70] = write_dqe;	
//	assign TRIG0[71] = erase_adv;
//	assign TRIG0[72] = read_adv;
//	assign TRIG0[73] = unlock_adv;
//	assign TRIG0[74] = write_adv;	
//	assign TRIG0[75] = oe;
//	assign TRIG0[76] = ce;	
//	assign TRIG0[77] = we;
//	assign TRIG0[103:78] = block_addr;
//	assign TRIG0[108:104] = erase_sta;
//	assign TRIG0[109] = unlock_done;
//	assign TRIG0[110] = erase_done;
//	assign TRIG0[111] = write_done;
//	assign TRIG0[112] = read_done;
//		
//	ila ila1 (
//	 .CONTROL(ctrl), // INOUT BUS [35:0]
//	 .CLK(clk), // IN
//	 .TRIG0(TRIG0) // IN BUS [127:0]
//	);	
endmodule 