//s_link.v

module s_link(
	
	input  wire        sys_clk,
	input  wire        glb_rst,
      
	input  wire        syn_clk,
	input  wire        syn_clk_90,
	input  wire        syn_clk_180,
	input  wire        syn_clk_270,
       
	input  wire        i_console_en,
	input  wire        i_join_start,
	input  wire [3:0]  i_slot_id,
	input  wire        i_ini_dvalid,
	input  wire [7:0]  i_ini_data,
	output wire [1:0]  o_trans_rslt,
       
	output wire        sl_rxbuf_wren,
	output wire [10:0] sl_rxbuf_waddr,
	output wire [7:0]  sl_rxbuf_wdata,
       
	output wire        sl_txbuf_rden,
	output wire [10:0] sl_txbuf_raddr,
	input  wire [7:0]  sl_txbuf_rdata,
	//phy layer        
	input  wire        sl_rxd,
	output wire        sl_txd,
	output wire        sl_txen

);


	wire got_frame;
	wire [7:0] cmd_frame;
	wire rx_start;
	wire rx_done;
	wire [1:0] crc_rslt;
	wire rx_buf_rden;
	wire [10:0] rx_buf_raddr;
	wire [7:0] rx_buf_rdata;
	wire tx_start;
	wire [10:0] tx_data_len;
	wire tx_buf_wren;
	wire [10:0] tx_buf_waddr;
	wire [7:0] tx_buf_wdata;
	
//s_link app layer rx
	s_link_tx s_link_tx(
			
		.clk(sys_clk),							
		.rst(glb_rst),							
		
		.i_slot_id(i_slot_id),				
		.i_join_start(i_join_start),		
		.i_console_en(i_console_en),		
		.i_ini_dvalid(i_ini_dvalid),		
		.i_ini_data(i_ini_data),			
		.i_got_frame(got_frame),			
		.i_cmd_frame(cmd_frame),			
		.o_trans_rslt(o_trans_rslt),			
		
		.o_sl_txbuf_rden(sl_txbuf_rden),	
		.o_sl_txbuf_raddr(sl_txbuf_raddr),
		.i_sl_txbuf_rdata(sl_txbuf_rdata),
		
		.o_tx_start(tx_start),			
		.o_tx_data_len(tx_data_len),
		.o_txbuf_wren(tx_buf_wren),
		.o_txbuf_waddr(tx_buf_waddr),
		.o_txbuf_wdata(tx_buf_wdata)
		
	);


//s_link app layer rx
	s_link_rx s_link_rx(

		.clk(sys_clk),
		.rst(glb_rst),
		
		.i_rx_start(rx_start),
		.i_rx_done(rx_done),
		.i_crc_rslt(crc_rslt),
		.o_rx_buf_rden(rx_buf_rden),
		.o_rx_buf_raddr(rx_buf_raddr),
		.i_rx_buf_rdata(rx_buf_rdata),
		
		.o_got_frame(got_frame),
		.o_cmd_frame(cmd_frame),
		
		.o_sl_rxbuf_wren(sl_rxbuf_wren),
		.o_sl_rxbuf_waddr(sl_rxbuf_waddr),
		.o_sl_rxbuf_wdata(sl_rxbuf_wdata)
		
	);


//s_link phy&dal layer rx
rx_link rx_link(
	
	.sys_clk(sys_clk),
	.clk_phy_p0(syn_clk),
	.clk_phy_p90(syn_clk_90),
	.clk_phy_p180(syn_clk_180),
	.clk_phy_p270(syn_clk_270),
	.rst(glb_rst),
	.rx_buf_rden(rx_buf_rden),
	.rx_buf_raddr(rx_buf_raddr),
	.lb_rxd(sl_rxd),
	
	.o_rx_done(rx_done),
	.rx_buf_rdata(rx_buf_rdata),
	.o_rx_crc_rslt(crc_rslt),
	.o_rx_start(rx_start)
	
);

	tx_lianlu_top tx_lianlu_top(
		.wclk(sys_clk),
		.Rclk(syn_clk),
		.rst(glb_rst),
		.tx_buf_wren(tx_buf_wren),
		.tx_buf_waddr(tx_buf_waddr),
		.tx_buf_wdata(tx_buf_wdata),
		.tx_data_len(tx_data_len),
		.tx_start(tx_start),
		//lb_txen(),
		.lb_txd(sl_txd)
	);



endmodule