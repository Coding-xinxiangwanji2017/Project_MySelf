module addr_gen
(
	input            clk         ,
	input            rst_n       , 
	input  [13:0]    row         ,
	                             
	output reg[24:0] rd_addr     ,
	output reg[24:0] wr_addr     ,
	output reg[24:0] block_addr  
);

	always @ (posedge clk)
	if(!rst_n)
		begin
			rd_addr <= 25'd0;
			wr_addr <= 25'd0;
			block_addr <= 25'd0;
		end
	else
		case(row[13:11])
			1	:	begin
						block_addr <= {2'd0,row[10:5],17'd0};
						rd_addr <= {2'd0,row[10:0],12'd0};
						wr_addr <= {2'd0,row[10:0],12'd0};
					end
			2	:	begin
						block_addr <= {2'd0,row[10:5],17'd0} + 25'h800000;
						rd_addr <= {2'd0,row[10:0],12'd0} + 25'h800000;
						wr_addr <= {2'd0,row[10:0],12'd0} + 25'h800000;
					end
			3	:	begin
						block_addr <= {2'd0,row[10:5],17'd0} + 25'h1000000;
						rd_addr <= {2'd0,row[10:0],12'd0} + 25'h1000000;
						wr_addr <= {2'd0,row[10:0],12'd0} + 25'h1000000;
					end
		
		endcase

endmodule