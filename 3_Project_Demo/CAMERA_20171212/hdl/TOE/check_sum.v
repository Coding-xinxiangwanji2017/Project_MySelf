module check_sum(

	input clk,
	input rst_n,
	input init,
	input en,
	input [15:0] data,
	output reg [31:0] data_out
	
);
	
	always @ (posedge clk)
	if(!rst_n)
		data_out <= 0;
	else if(init)
		data_out <= 0;
	else if(en)
		data_out <= data_out + {16'd0,data};

endmodule