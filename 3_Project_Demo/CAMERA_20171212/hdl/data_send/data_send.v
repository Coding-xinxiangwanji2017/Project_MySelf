module data_send
(
	input            clk      ,
	input            rst_n    ,
	input   [1:0]    rx_full  ,
	output           rx       ,
	output  [7:0]    rx_data
);

	wire rom_rd;
	wire data_flag;
	wire rst;
	wire [12:0] rom_addr;
	wire [7:0] data_change;
	wire [7:0] rom_data;
	
	assign rst = ~rst_n;
	assign rx_data = (data_flag)? data_change : rom_data;
	
	send_fsm send_fsm_inst(
    .clk         (clk        ),
    .rst_n       (rst_n      ),
    .rx_full     (rx_full    ),
    .rx          (rx         ),
    .rom_rd      (rom_rd     ),
    .rom_addr    (rom_addr   ),
	 .data_change (data_change),
	 .data_flag   (data_flag  )
   );
	
	rom rom_inst (
	  .clka       (clk        ), 
	  .rsta       (rst        ), 
	  .ena        (rom_rd     ), 
	  .addra      (rom_addr   ), 
	  .douta      (rom_data   ) 
	);
		
endmodule