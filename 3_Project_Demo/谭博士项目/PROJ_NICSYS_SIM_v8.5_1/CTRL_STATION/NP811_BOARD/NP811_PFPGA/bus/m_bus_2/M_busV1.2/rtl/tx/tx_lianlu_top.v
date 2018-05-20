module tx_lianlu_top(wclk,
                     Rclk,
                     rst,
                     tx_buf_wren,
                     tx_buf_waddr,
                     tx_buf_wdata,
                     tx_data_len,
                     tx_start,
                     lb_txen,
                     lb_txd);
//port

input wclk;
input Rclk;
input rst;
input tx_buf_wren;
input [10:0]tx_buf_waddr;
input [7:0]tx_buf_wdata;
input [10:0]tx_data_len;
input tx_start;

output lb_txen;
output lb_txd;

//wire or reg
wire wr_en;
wire ctrl_en;
wire [10:0]RADDR;
wire REN;
wire [7:0]RD;
wire [7:0]RD1;
wire TX_RDY;
wire CRC_en;
wire [31:0]CRC_in;
wire [7:0]data;
wire CRC_init;

reg [4:0]tx_start_d;
wire tx_start_or;
reg o_tx_start;
reg tx_start_or_d1;

assign RD1=data;

TX_control U1(.clk(Rclk),
              .reset(rst),
              .data_length(tx_data_len),          //input from input
              .tx_start(o_tx_start),                //input from input
              .TX_RDY(TX_RDY),                    //input from K1
              .RDen(REN),                         //output to Y1
              .RDaddr(RADDR),                     //output to Y1
              .RDdata(RD),                        //input from Y1
              .data_out(data),                    //output to K1
              .CRC_in(CRC_in),                    //input from L1
              .CRC_Enable(CRC_en),                //output to L1
              .wr_en_out(wr_en),                  //output to K1
              .ctrl_en_out(ctrl_en),              //output to K1
              .CRC_init(CRC_init));               //output to L1
              
TX_4B5B_preamble K1(.clk(Rclk),
                   .reset(rst),
                   .data_in(data),                //input from U1
                   .wr_en(wr_en),                 //input from U1
                   .ctrl_en(ctrl_en),             //input from U1
                   .TX_RDY(TX_RDY),               //output to U1
                   .TX(lb_txd),
                   .tx_frame(lb_txen));                   //output
                   
M_Crc32En8 L1(.CpSv_Data_i(RD1),                             //input from Y1
            .CpSl_Rst_i(rst),
            .CpSl_CrcEn_i(CRC_en),                      //input from U1
            .CpSv_CrcResult_o(CRC_in),                      //output to U1
            .CpSl_Clk_i(Rclk),
            .CpSl_Init_i(CRC_init));                        //input from Y1
            
RAM_2048_8_SDP Y1(.WD(tx_buf_wdata),                    //input
            .RD(RD),                              //output to U1 and L1
            .WEN(tx_buf_wren),                    //input
            .REN(REN),                            //input from U1
            .WADDR(tx_buf_waddr),                 //input
            .RADDR(RADDR),                        //input from U1
            .WCLK(wclk),
            .RCLK(Rclk));



//assign lb_txen=~TX_RDY;
always @ (posedge wclk)
begin
	if(rst)
		begin
			tx_start_d<=5'd0;
		end
	else begin
      tx_start_d<={tx_start_d[3:0],tx_start};
	end
end

assign tx_start_or = tx_start_d[0] |tx_start_d[1] | tx_start_d[2] | tx_start_d[3] | tx_start_d[4];

always @ (posedge Rclk)
begin
	if(rst)
		tx_start_or_d1 <= 0;
	else
		tx_start_or_d1 <= tx_start_or;
end

always @ (posedge Rclk)
begin
	if(rst)
		o_tx_start <= 0;
	else
		o_tx_start <= tx_start_or & ~tx_start_or_d1;
end

endmodule


                     