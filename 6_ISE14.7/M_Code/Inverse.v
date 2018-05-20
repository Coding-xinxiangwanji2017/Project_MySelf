`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:26:03 03/26/2018 
// Design Name: 
// Module Name:    Inverse 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Inverse(
					clk,
					rst,
					flag_out,
					flag_in,
					X_1_pass,	X_2_pass,	X_3_pass,	X_4_pass,	X_5_pass,
					L0_0_I,		
					L1_0_I,		L1_1_I,		
					L2_0_I,		L2_1_I,		L2_2_I,		
					L3_0_I,		L3_1_I,		L3_2_I,		L3_3_I,		
					L4_0_I,		L4_1_I,		L4_2_I,		L4_3_I,		L4_4_I,
					
					L0_0_O,		
					L1_0_O,		L1_1_O,		
					L2_0_O,		L2_1_O,		L2_2_O,		
					L3_0_O,		L3_1_O,		L3_2_O,		L3_3_O,	
					L4_0_O,		L4_1_O,		L4_2_O,		L4_3_O,		L4_4_O
					);
input	wire	signed	[31:0]	X_1_pass;
input	wire	signed	[31:0]	X_2_pass;
input	wire	signed	[31:0]	X_3_pass;
input	wire	signed	[31:0]	X_4_pass;
input	wire	signed	[31:0]	X_5_pass;

input	wire	signed	[31:0]	L0_0_I;		

input	wire	signed	[31:0]	L1_0_I;		
input	wire	signed	[31:0]	L1_1_I;		

input	wire	signed	[31:0]	L2_0_I;		
input	wire	signed	[31:0]	L2_1_I;		
input	wire	signed	[31:0]	L2_2_I;		

input	wire	signed	[31:0]	L3_0_I;		
input	wire	signed	[31:0]	L3_1_I;		
input	wire	signed	[31:0]	L3_2_I;		
input	wire	signed	[31:0]	L3_3_I;		

input	wire	signed	[31:0]	L4_0_I;		
input	wire	signed	[31:0]	L4_1_I;		
input	wire	signed	[31:0]	L4_2_I;		
input	wire	signed	[31:0]	L4_3_I;		
input	wire	signed	[31:0]	L4_4_I;

output   wire	signed	[31:0]	L0_0_O;		

output	wire	signed	[31:0]	L1_0_O;		
output	wire	signed	[31:0]	L1_1_O;		

output	wire	signed	[31:0]	L2_0_O;	
output	wire	signed	[31:0]	L2_1_O;		
output	wire	signed	[31:0]	L2_2_O;		

output	wire	signed	[31:0]	L3_0_O;		
output	wire	signed	[31:0]	L3_1_O;		
output	wire	signed	[31:0]	L3_2_O;		
output	wire	signed	[31:0]	L3_3_O;		

output	wire	signed	[31:0]	L4_0_O;		
output	wire	signed	[31:0]	L4_1_O;		
output	wire	signed	[31:0]	L4_2_O;		
output	wire	signed	[31:0]	L4_3_O;		
output	wire	signed	[31:0]	L4_4_O;
input	clk;
input	rst;
output	wire	flag_out;
input	wire	flag_in;

/*always@(posedge	clk	or	negedge	rst)
	begin
		if(!rst)
			begin
				state<=3'd0;
				flag_3_reg<=0;
			end
		else if(flag_2)
			begin
				flag_3_reg<=flag_3;
					if((!flag_3))
						case(state)
							3'b0:	//计数器计算乘法完成需要几个时钟->计算累加
								begin
									state<=3'd1;
								end
							3'b1:	//同样计数器->计算分子和分母
								begin
									state<=3'd2;
								end
							3'd2:	//同样时间计数器->计算商
									//结束取值，
								begin
									state<=3'd3;
								end
							3'd3:	//做减法获得输出
								begin
									state<=3'd4;
								end
							3'd4:
								begin
									//赋值到端口
									flag_3_reg<=1;
									state<=3'd0;
								end
						endcase
		end
	end*/
////////////////////////////////////////////////////////////////////
/*X乘以L*/
////////////////////////////////////////////////////////////////////
wire	signed	[63:0]	XT_1_1,	XT_1_2,	XT_1_3,	XT_1_4,	XT_1_5,
								XT_2_1,	XT_2_2,	XT_2_3,	XT_2_4,	XT_2_5,
								XT_3_1,	XT_3_2,	XT_3_3,	XT_3_4,	XT_3_5,
								XT_4_1,	XT_4_2,	XT_4_3,	XT_4_4,	XT_4_5,
								XT_5_1,	XT_5_2,	XT_5_3,	XT_5_4,	XT_5_5;
MUL MUL_1_1(.a(X_1_pass), .b(L0_0_I), .p(XT_1_1) );	
MUL MUL_1_2(.a(X_2_pass), .b(L1_0_I), .p(XT_1_2) );
MUL MUL_1_3(.a(X_3_pass), .b(L2_0_I), .p(XT_1_3) );
MUL MUL_1_4(.a(X_4_pass), .b(L3_0_I), .p(XT_1_4) );
MUL MUL_1_5(.a(X_5_pass), .b(L4_0_I), .p(XT_1_5) );

MUL MUL_2_1(.a(X_1_pass), .b(L1_0_I), .p(XT_2_1) );	
MUL MUL_2_2(.a(X_2_pass), .b(L1_1_I), .p(XT_2_2) );
MUL MUL_2_3(.a(X_3_pass), .b(L2_1_I), .p(XT_2_3) );
MUL MUL_2_4(.a(X_4_pass), .b(L3_1_I), .p(XT_2_4) );
MUL MUL_2_5(.a(X_5_pass), .b(L4_1_I), .p(XT_2_5) );

MUL MUL_3_1(.a(X_1_pass), .b(L2_0_I), .p(XT_3_1) );	
MUL MUL_3_2(.a(X_2_pass), .b(L2_1_I), .p(XT_3_2) );
MUL MUL_3_3(.a(X_3_pass), .b(L2_2_I), .p(XT_3_3) );
MUL MUL_3_4(.a(X_4_pass), .b(L3_2_I), .p(XT_3_4) );
MUL MUL_3_5(.a(X_5_pass), .b(L4_2_I), .p(XT_3_5) );

MUL MUL_4_1(.a(X_1_pass), .b(L3_0_I), .p(XT_4_1) );	
MUL MUL_4_2(.a(X_2_pass), .b(L3_1_I), .p(XT_4_2) );
MUL MUL_4_3(.a(X_3_pass), .b(L3_2_I), .p(XT_4_3) );
MUL MUL_4_4(.a(X_4_pass), .b(L3_3_I), .p(XT_4_4) );
MUL MUL_4_5(.a(X_5_pass), .b(L4_3_I), .p(XT_4_5) );

MUL MUL_5_1(.a(X_1_pass), .b(L4_0_I), .p(XT_5_1) );	
MUL MUL_5_2(.a(X_2_pass), .b(L4_1_I), .p(XT_5_2) );
MUL MUL_5_3(.a(X_3_pass), .b(L4_2_I), .p(XT_5_3) );
MUL MUL_5_4(.a(X_4_pass), .b(L4_3_I), .p(XT_5_4) );
MUL MUL_5_5(.a(X_5_pass), .b(L4_4_I), .p(XT_5_5) );

wire	signed	[63:0]	XT_1,	XT_2,	XT_3,	XT_4,	XT_5;
assign	XT_1=XT_1_1+XT_1_2+XT_1_3+XT_1_4+XT_1_5;
assign	XT_2=XT_2_1+XT_2_2+XT_2_3+XT_2_4+XT_2_5;
assign	XT_3=XT_3_1+XT_3_2+XT_3_3+XT_3_4+XT_3_5;
assign	XT_4=XT_4_1+XT_4_2+XT_4_3+XT_4_4+XT_4_5;
assign	XT_5=XT_5_1+XT_5_2+XT_5_3+XT_5_4+XT_5_5;
/*wire	signed	[63:0]	XT_1_1,	
								XT_2_1,	XT_2_2,
								XT_3_1,	XT_3_2,	XT_3_3,	
								XT_4_1,	XT_4_2,	XT_4_3,	XT_4_4,	
								XT_5_1,	XT_5_2,	XT_5_3,	XT_5_4,	XT_5_5;
MUL MUL_1_1(.a(X_1_pass), .b(L0_0_I), .p(XT_1_1) );	


MUL MUL_2_1(.a(X_1_pass), .b(L1_0_I), .p(XT_2_1) );	
MUL MUL_2_2(.a(X_2_pass), .b(L1_1_I), .p(XT_2_2) );

MUL MUL_3_1(.a(X_1_pass), .b(L2_0_I), .p(XT_3_1) );	
MUL MUL_3_2(.a(X_2_pass), .b(L2_1_I), .p(XT_3_2) );
MUL MUL_3_3(.a(X_3_pass), .b(L2_2_I), .p(XT_3_3) );


MUL MUL_4_1(.a(X_1_pass), .b(L3_0_I), .p(XT_4_1) );	
MUL MUL_4_2(.a(X_2_pass), .b(L3_1_I), .p(XT_4_2) );
MUL MUL_4_3(.a(X_3_pass), .b(L3_2_I), .p(XT_4_3) );
MUL MUL_4_4(.a(X_4_pass), .b(L3_3_I), .p(XT_4_4) );


MUL MUL_5_1(.a(X_1_pass), .b(L4_0_I), .p(XT_5_1) );	
MUL MUL_5_2(.a(X_2_pass), .b(L4_1_I), .p(XT_5_2) );
MUL MUL_5_3(.a(X_3_pass), .b(L4_2_I), .p(XT_5_3) );
MUL MUL_5_4(.a(X_4_pass), .b(L4_3_I), .p(XT_5_4) );
MUL MUL_5_5(.a(X_5_pass), .b(L4_4_I), .p(XT_5_5) );

wire	signed	[63:0]	XT_1,	XT_2,	XT_3,	XT_4,	XT_5;
assign	XT_1=XT_1_1+XT_2_1+XT_3_1+XT_4_1+XT_5_1;
assign	XT_2=XT_2_1+XT_2_2+XT_3_2+XT_4_2+XT_5_2;
assign	XT_3=XT_3_1+XT_3_2+XT_3_3+XT_4_3+XT_5_3;
assign	XT_4=XT_4_1+XT_4_2+XT_4_3+XT_4_4+XT_5_4;
assign	XT_5=XT_5_1+XT_5_2+XT_5_3+XT_5_4+XT_5_5;*/
////////////////////////////////////////////////////////////////////
/*X乘以L*X乘以L------>分子*/
////////////////////////////////////////////////////////////////////
wire	signed	[127:0]	FZ1_1,	
								FZ2_1,	FZ2_2,	
								FZ3_1,	FZ3_2,	FZ3_3,	
								FZ4_1,	FZ4_2,	FZ4_3,	FZ4_4,	
								FZ5_1,	FZ5_2,	FZ5_3,	FZ5_4,	FZ5_5;
MUL_64 MUL_64_1_1 (.a(XT_1), 	.b(XT_1), 	.p(FZ1_1) );


MUL_64 MUL_64_2_1 (.a(XT_2), 	.b(XT_1), 	.p(FZ2_1) );
MUL_64 MUL_64_2_2 (.a(XT_2), 	.b(XT_2), 	.p(FZ2_2) );


MUL_64 MUL_64_3_1 (.a(XT_3), 	.b(XT_1), 	.p(FZ3_1) );
MUL_64 MUL_64_3_2 (.a(XT_3), 	.b(XT_2), 	.p(FZ3_2) );
MUL_64 MUL_64_3_3 (.a(XT_3), 	.b(XT_3), 	.p(FZ3_3) );


MUL_64 MUL_64_4_1 (.a(XT_4), 	.b(XT_1), 	.p(FZ4_1) );
MUL_64 MUL_64_4_2 (.a(XT_4), 	.b(XT_2), 	.p(FZ4_2) );
MUL_64 MUL_64_4_3 (.a(XT_4), 	.b(XT_3), 	.p(FZ4_3) );
MUL_64 MUL_64_4_4 (.a(XT_4), 	.b(XT_4), 	.p(FZ4_4) );


MUL_64 MUL_64_5_1 (.a(XT_5), 	.b(XT_1), 	.p(FZ5_1) );
MUL_64 MUL_64_5_2 (.a(XT_5), 	.b(XT_2), 	.p(FZ5_2) );
MUL_64 MUL_64_5_3 (.a(XT_5), 	.b(XT_3), 	.p(FZ5_3) );
MUL_64 MUL_64_5_4 (.a(XT_5), 	.b(XT_4), 	.p(FZ5_4) );
MUL_64 MUL_64_5_5 (.a(XT_5), 	.b(XT_5), 	.p(FZ5_5) );
////////////////////////////////////////////////////////////////////
/*X乘以L*X+1------>分母*/
////////////////////////////////////////////////////////////////////
wire	signed	[127:0]	FM,	FM_1,	FM_2,	FM_3,	FM_4,	FM_5;
MUL64_32 MUL64_32_1 (.a(XT_1), 	.b(X_1_pass), 	.p(FM_1) );
MUL64_32 MUL64_32_2 (.a(XT_2), 	.b(X_2_pass), 	.p(FM_2) );
MUL64_32 MUL64_32_3 (.a(XT_3), 	.b(X_3_pass), 	.p(FM_3) );
MUL64_32 MUL64_32_4 (.a(XT_4), 	.b(X_4_pass), 	.p(FM_4) );
MUL64_32 MUL64_32_5 (.a(XT_5), 	.b(X_5_pass), 	.p(FM_5) );
assign	FM=FM_1+FM_2+FM_3+FM_4+FM_5+127'sh80000_0000_0000_0000_0000_0;
////////////////////////////////////////////////////////////////////
/*分子除以分母*/
////////////////////////////////////////////////////////////////////
wire	signed	[63:0]	DIV1_1,	
								DIV2_1,	DIV2_2,	
								DIV3_1,	DIV3_2,	DIV3_3,	
								DIV4_1,	DIV4_2,	DIV4_3,	DIV4_4,	
								DIV5_1,	DIV5_2,	DIV5_3,	DIV5_4,	DIV5_5,
								DI;
assign	DIV1_1={FZ1_1[127],FZ1_1[112:50]},
			DIV2_1={FZ2_1[127],FZ2_1[112:50]},DIV2_2={FZ2_2[127],FZ2_2[112:50]},
			DIV3_1={FZ3_1[127],FZ3_1[112:50]},DIV3_2={FZ3_2[127],FZ3_2[112:50]},DIV3_3={FZ3_3[127],FZ3_3[112:50]},
			DIV4_1={FZ4_1[127],FZ4_1[112:50]},DIV4_2={FZ4_2[127],FZ4_2[112:50]},DIV4_3={FZ4_3[127],FZ4_3[112:50]},DIV4_4={FZ4_4[127],FZ4_4[112:50]},
			DIV5_1={FZ5_1[127],FZ5_1[112:50]},DIV5_2={FZ5_2[127],FZ5_2[112:50]},DIV5_3={FZ5_3[127],FZ5_3[112:50]},DIV5_4={FZ5_4[127],FZ5_4[112:50]},DIV5_5={FZ5_5[127],FZ5_5[112:50]},
			DI={FM[127],FM[87:25]};	
wire	signed	[95:0]	QUO1_1,	
								QUO2_1,	QUO2_2,
								QUO3_1,	QUO3_2,	QUO3_3,
								QUO4_1,	QUO4_2,	QUO4_3,	QUO4_4,
								QUO5_1,	QUO5_2,	QUO5_3,	QUO5_4,	QUO5_5;
divider divider1_1 (.aclk(clk),.s_axis_divisor_tvalid(1'b1),.s_axis_divisor_tdata(DI),.s_axis_dividend_tvalid(1'b1),.s_axis_dividend_tdata(DIV1_1),.m_axis_dout_tvalid(), .m_axis_dout_tdata(QUO1_1) );


divider divider2_1 (.aclk(clk),.s_axis_divisor_tvalid(1'b1),.s_axis_divisor_tdata(DI),.s_axis_dividend_tvalid(1'b1),.s_axis_dividend_tdata(DIV2_1),.m_axis_dout_tvalid(), .m_axis_dout_tdata(QUO2_1) );
divider divider2_2 (.aclk(clk),.s_axis_divisor_tvalid(1'b1),.s_axis_divisor_tdata(DI),.s_axis_dividend_tvalid(1'b1),.s_axis_dividend_tdata(DIV2_2),.m_axis_dout_tvalid(), .m_axis_dout_tdata(QUO2_2) );

divider divider3_1 (.aclk(clk),.s_axis_divisor_tvalid(1'b1),.s_axis_divisor_tdata(DI),.s_axis_dividend_tvalid(1'b1),.s_axis_dividend_tdata(DIV3_1),.m_axis_dout_tvalid(), .m_axis_dout_tdata(QUO3_1) );
divider divider3_2 (.aclk(clk),.s_axis_divisor_tvalid(1'b1),.s_axis_divisor_tdata(DI),.s_axis_dividend_tvalid(1'b1),.s_axis_dividend_tdata(DIV3_2),.m_axis_dout_tvalid(), .m_axis_dout_tdata(QUO3_2) );
divider divider3_3 (.aclk(clk),.s_axis_divisor_tvalid(1'b1),.s_axis_divisor_tdata(DI),.s_axis_dividend_tvalid(1'b1),.s_axis_dividend_tdata(DIV3_3),.m_axis_dout_tvalid(), .m_axis_dout_tdata(QUO3_3) );


divider divider4_1 (.aclk(clk),.s_axis_divisor_tvalid(1'b1),.s_axis_divisor_tdata(DI),.s_axis_dividend_tvalid(1'b1),.s_axis_dividend_tdata(DIV4_1),.m_axis_dout_tvalid(), .m_axis_dout_tdata(QUO4_1) );
divider divider4_2 (.aclk(clk),.s_axis_divisor_tvalid(1'b1),.s_axis_divisor_tdata(DI),.s_axis_dividend_tvalid(1'b1),.s_axis_dividend_tdata(DIV4_2),.m_axis_dout_tvalid(), .m_axis_dout_tdata(QUO4_2) );
divider divider4_3 (.aclk(clk),.s_axis_divisor_tvalid(1'b1),.s_axis_divisor_tdata(DI),.s_axis_dividend_tvalid(1'b1),.s_axis_dividend_tdata(DIV4_3),.m_axis_dout_tvalid(), .m_axis_dout_tdata(QUO4_3) );
divider divider4_4 (.aclk(clk),.s_axis_divisor_tvalid(1'b1),.s_axis_divisor_tdata(DI),.s_axis_dividend_tvalid(1'b1),.s_axis_dividend_tdata(DIV4_4),.m_axis_dout_tvalid(), .m_axis_dout_tdata(QUO4_4) );


divider divider5_1 (.aclk(clk),.s_axis_divisor_tvalid(1'b1),.s_axis_divisor_tdata(DI),.s_axis_dividend_tvalid(1'b1),.s_axis_dividend_tdata(DIV5_1),.m_axis_dout_tvalid(), .m_axis_dout_tdata(QUO5_1) );
divider divider5_2 (.aclk(clk),.s_axis_divisor_tvalid(1'b1),.s_axis_divisor_tdata(DI),.s_axis_dividend_tvalid(1'b1),.s_axis_dividend_tdata(DIV5_2),.m_axis_dout_tvalid(), .m_axis_dout_tdata(QUO5_2) );
divider divider5_3 (.aclk(clk),.s_axis_divisor_tvalid(1'b1),.s_axis_divisor_tdata(DI),.s_axis_dividend_tvalid(1'b1),.s_axis_dividend_tdata(DIV5_3),.m_axis_dout_tvalid(), .m_axis_dout_tdata(QUO5_3) );
divider divider5_4 (.aclk(clk),.s_axis_divisor_tvalid(1'b1),.s_axis_divisor_tdata(DI),.s_axis_dividend_tvalid(1'b1),.s_axis_dividend_tdata(DIV5_4),.m_axis_dout_tvalid(), .m_axis_dout_tdata(QUO5_4) );
divider divider5_5 (.aclk(clk),.s_axis_divisor_tvalid(1'b1),.s_axis_divisor_tdata(DI),.s_axis_dividend_tvalid(1'b1),.s_axis_dividend_tdata(DIV5_5),.m_axis_dout_tvalid(), .m_axis_dout_tdata(QUO5_5) );
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////除法完成
////////////////////////////////////////////////////////////////////
/*双向通道*/
////////////////////////////////////////////////////////////////////
reg	flag_out_reg;
assign	flag_out=flag_out_reg;
reg	[1:0]	flag_in_posedge;
always@(posedge clk or	negedge	rst)
	begin
		if(!rst)
			flag_in_posedge<=2'b11;
		else
			flag_in_posedge<={flag_in_posedge[0],flag_in};
	end
////////////////////////////////////////////////////////////////////
/*控制时间取值*/
////////////////////////////////////////////////////////////////////
reg	signed	[31:0]	QUO_REG1_1,	
								QUO_REG2_1,	QUO_REG2_2,	
								QUO_REG3_1,	QUO_REG3_2,	QUO_REG3_3,	
								QUO_REG4_1,	QUO_REG4_2,	QUO_REG4_3,	QUO_REG4_4,
								QUO_REG5_1,	QUO_REG5_2,	QUO_REG5_3,	QUO_REG5_4,	QUO_REG5_5;
reg	[10:0]		cnt;
////////////////////////////////////////////////////////////////////
/*计数器*/
////////////////////////////////////////////////////////////////////
always@(posedge	clk)
	begin
		if((flag_in_posedge==2'b10))
			begin
				flag_out_reg<=0;		
				cnt<=0;
			end
		else	if(cnt==99)
			 flag_out_reg<=1;
		else	if(cnt==100)
			cnt<=cnt;
		else
			cnt<=cnt+1'b1;
	end
always@(posedge	clk	or	negedge	rst)
	begin
		if(!rst||cnt==0)	
			begin
					QUO_REG1_1<=0; 	
					QUO_REG2_1<=0; 	QUO_REG2_2<=0; 	
					QUO_REG3_1<=0; 	QUO_REG3_2<=0; 	QUO_REG3_3<=0; 	
					QUO_REG4_1<=0; 	QUO_REG4_2<=0; 	QUO_REG4_3<=0; 	QUO_REG4_4<=0; 	
					QUO_REG5_1<=0; 	QUO_REG5_2<=0; 	QUO_REG5_3<=0; 	QUO_REG5_4<=0; 	QUO_REG5_5<=0;	
			end
		else	if(cnt==97)
			begin
					QUO_REG1_1<=QUO1_1[31:0]; 	
					QUO_REG2_1<=QUO2_1[31:0]; 	QUO_REG2_2<=QUO2_2[31:0]; 	
					QUO_REG3_1<=QUO3_1[31:0]; 	QUO_REG3_2<=QUO3_2[31:0]; 	QUO_REG3_3<=QUO3_3[31:0]; 	
					QUO_REG4_1<=QUO4_1[31:0]; 	QUO_REG4_2<=QUO4_2[31:0]; 	QUO_REG4_3<=QUO4_3[31:0]; 	QUO_REG4_4<=QUO4_4[31:0]; 
					QUO_REG5_1<=QUO5_1[31:0]; 	QUO_REG5_2<=QUO5_2[31:0]; 	QUO_REG5_3<=QUO5_3[31:0]; 	QUO_REG5_4<=QUO5_4[31:0]; 	QUO_REG5_5<=QUO5_5[31:0];	
					
					/*QUO_REG1_1<=XT_1_1[31:0]; 	QUO_REG1_2<=XT_1_2[31:0]; 	QUO_REG1_3<=XT_1_3[31:0]; 	QUO_REG1_4<=XT_1_4[31:0]; 	QUO_REG1_5<=XT_1_5[31:0]; 
					QUO_REG2_1<=XT_2_1[31:0]; 	QUO_REG2_2<=XT_2_2[31:0]; 	QUO_REG2_3<=XT_2_3[31:0]; 	QUO_REG2_4<=XT_2_4[31:0]; 	QUO_REG2_5<=XT_2_5[31:0]; 
					QUO_REG3_1<=XT_3_1[31:0]; 	QUO_REG3_2<=XT_3_2[31:0]; 	QUO_REG3_3<=XT_3_3[31:0]; 	QUO_REG3_4<=XT_3_4[31:0]; 	QUO_REG3_5<=XT_3_5[31:0]; 
					QUO_REG4_1<=XT_4_1[31:0]; 	QUO_REG4_2<=XT_4_2[31:0]; 	QUO_REG4_3<=XT_4_3[31:0]; 	QUO_REG4_4<=XT_4_4[31:0]; 	QUO_REG4_5<=XT_4_5[31:0]; 
					QUO_REG5_1<=XT_5_1[31:0]; 	QUO_REG5_2<=XT_5_2[31:0]; 	QUO_REG5_3<=XT_5_3[31:0]; 	QUO_REG5_4<=XT_5_4[31:0]; 	QUO_REG5_5<=XT_5_5[31:0];	*/
			end
		else	if(cnt==98)
			begin
					  if(QUO_REG1_1[25] == 1 && QUO_REG1_1[31] == 0)    QUO_REG1_1[31:26] <= 6'b111111; 
					  

					  if(QUO_REG2_1[25] == 1 && QUO_REG2_1[31] == 0)    QUO_REG2_1[31:26] <= 6'b111111; 
					  if(QUO_REG2_2[25] == 1 && QUO_REG2_2[31] == 0)    QUO_REG2_2[31:26] <= 6'b111111;    
					  
                 
					  if(QUO_REG3_1[25] == 1 && QUO_REG3_1[31] == 0)    QUO_REG3_1[31:26] <= 6'b111111; 
					  if(QUO_REG3_2[25] == 1 && QUO_REG3_2[31] == 0)    QUO_REG3_2[31:26] <= 6'b111111;    
					  if(QUO_REG3_3[25] == 1 && QUO_REG3_3[31] == 0)    QUO_REG3_3[31:26] <= 6'b111111;  
					  
					  
					  if(QUO_REG4_1[25] == 1 && QUO_REG4_1[31] == 0)    QUO_REG4_1[31:26] <= 6'b111111; 
					  if(QUO_REG4_2[25] == 1 && QUO_REG4_2[31] == 0)    QUO_REG4_2[31:26] <= 6'b111111;    
					  if(QUO_REG4_3[25] == 1 && QUO_REG4_3[31] == 0)    QUO_REG4_3[31:26] <= 6'b111111;  
					  if(QUO_REG4_4[25] == 1 && QUO_REG4_4[31] == 0)  	 QUO_REG4_4[31:26] <= 6'b111111;  
					  
					  if(QUO_REG5_1[25] == 1 && QUO_REG5_1[31] == 0)    QUO_REG5_1[31:26] <= 6'b111111; 
					  if(QUO_REG5_2[25] == 1 && QUO_REG5_2[31] == 0)    QUO_REG5_2[31:26] <= 6'b111111;    
					  if(QUO_REG5_3[25] == 1 && QUO_REG5_3[31] == 0)    QUO_REG5_3[31:26] <= 6'b111111;  
					  if(QUO_REG5_4[25] == 1 && QUO_REG5_4[31] == 0)  	 QUO_REG5_4[31:26] <= 6'b111111;  
					  if(QUO_REG5_5[25] == 1 && QUO_REG5_5[31] == 0)    QUO_REG5_5[31:26] <= 6'b111111; 
					 
			end
		end
assign			L0_0_O=QUO_REG1_1,		
					L1_0_O=QUO_REG2_1,		L1_1_O=QUO_REG2_2,		
					L2_0_O=QUO_REG3_1,		L2_1_O=QUO_REG3_2,		L2_2_O=QUO_REG3_3,		
					L3_0_O=QUO_REG4_1,		L3_1_O=QUO_REG4_2,		L3_2_O=QUO_REG4_3,		L3_3_O=QUO_REG4_4,		
					L4_0_O=QUO_REG5_1,		L4_1_O=QUO_REG5_2,		L4_2_O=QUO_REG5_3,		L4_3_O=QUO_REG5_4,		L4_4_O=QUO_REG5_5;
endmodule
