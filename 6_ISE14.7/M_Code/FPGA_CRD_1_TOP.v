 module FPGA_CRD_1_TOP(
    x,
    y,
    clk,
    rst
    );
input   signed [31:0]   x;
input   signed [31:0]	y;
input   clk;
input   rst;
reg	flag_5;//求逆完成标志位
wire	flag_out_pass;
reg	[1:0]	flag_out_posedge;//单周期计算标志位输出通道
reg	flag_in;//单周期赋值结束标志位
wire	flag_in_pass;
assign	flag_in_pass=flag_in;
reg	[2:0]	state_1;//求逆状态机
reg	[1:0]	flag_1_posedge;
reg	signed [31:0]	x_reg_1	[174:0];
reg	signed [31:0]	x_reg_2	[174:0];
reg	signed [31:0]	x_reg_3	[174:0];
reg	signed [31:0]	x_reg_4	[174:0];
reg	signed [31:0]	x_reg_5	[174:0];
reg	signed [31:0]	y_reg		[174:0];
reg  signed [31:0]	danwei_0	;
reg  signed [31:0]	danwei_1	[1:0];
reg  signed [31:0]	danwei_2	[2:0];
reg  signed [31:0]	danwei_3	[3:0];
reg  signed [31:0]	danwei_4	[4:0];
reg	flag_4;//计数增加完成标志位
reg	[10:0]	N;
wire	signed [31:0]	L0_0_O,
							L1_0_O,L1_1_O,
							L2_0_O,L2_1_O,L2_2_O,
							L3_0_O,L3_1_O,L3_2_O,L3_3_O,
							L4_0_O,L4_1_O,L4_2_O,L4_3_O,L4_4_O;
reg	signed [31:0]	X_1,X_2,X_3,X_4,X_5;
wire	signed [31:0]	X_1_pass,X_2_pass,X_3_pass,X_4_pass,X_5_pass;
wire	signed [31:0]	L0_0_I,
							L1_0_I,L1_1_I,
							L2_0_I,L2_1_I,L2_2_I,
							L3_0_I,L3_1_I,L3_2_I,L3_3_I,
							L4_0_I,L4_1_I,L4_2_I,L4_3_I,L4_4_I;

////////////////////////////////////////////////////////////////////
/*计数器in_cnt,设置标志位*/
////////////////////////////////////////////////////////////////////
reg	[12:0]		in_cnt;
reg	flag_1;
always @(posedge clk or negedge rst ) 
	begin	
		if(!rst)	
			begin
				in_cnt	<=	11'b0;
				flag_1	<=1;
			end
		else	if(in_cnt==1050)
			begin
				flag_1	<=	0;
				in_cnt	<=1052;
			end
		else	if(flag_1)
			in_cnt<=in_cnt	+1;
			
	end
////////////////////////////////////////////////////////////////////
/*从端口将数据储存到寄存器*/
////////////////////////////////////////////////////////////////////

always @(posedge clk	)
	begin	
		if(flag_1)
		begin
			if(in_cnt < 175)
				begin
					x_reg_1[in_cnt]	<=	32'b0;
					x_reg_2[in_cnt]	<=	32'b0;
					x_reg_3[in_cnt]	<=	32'b0;
					x_reg_4[in_cnt]	<=	32'b0;
					x_reg_5[in_cnt]	<=	32'b0;
					//y_reg[in_cnt]	<=	32'b0;
				end
			else	if(in_cnt>175&& in_cnt<351)
				begin
					x_reg_1[in_cnt-176]	<=	x;
					//y_reg[in_cnt-176]	<=	y;
					
				end
			else	if(in_cnt>350&& in_cnt<526)
				 x_reg_2[in_cnt-351]	<=	x;
			else	if(in_cnt>525&& in_cnt<701)
				 x_reg_3[in_cnt-526]	<=	x;
			else	if(in_cnt>700&& in_cnt<876)
				 x_reg_4[in_cnt-701]	<=	x;
			else	if(in_cnt>875&& in_cnt<1051)
				 x_reg_5[in_cnt-876]	<=	x;
		end
	end

////////////////////////////////////////////////////////////////////
/*生成单位矩阵*/
////////////////////////////////////////////////////////////////////
reg	[1:0]	flag_4_posedge;
always@(posedge clk or	negedge	rst)
	begin
		if(!rst)
			flag_4_posedge<=2'b00;
		else	
			flag_4_posedge<={flag_4_posedge[0],flag_4};
	end
always @(posedge clk ) 
	begin	
		if(in_cnt ==10	&&	flag_1)	
			begin
				danwei_0	<=	32'b0000_0010_0000_0000_0000_0000_0000_0000;
				
				danwei_1[0]	<=	32'b0;
				danwei_1[1]	<=	32'b0000_0010_0000_0000_0000_0000_0000_0000;
				
				danwei_2[0]	<=	32'b0;
				danwei_2[1]	<=	32'b0;
				danwei_2[2]	<=	32'b0000_0010_0000_0000_0000_0000_0000_0000;
				
				danwei_3[0]	<=	32'b0;
				danwei_3[1]	<=	32'b0;
				danwei_3[2]	<=	32'b0;
				danwei_3[3]	<=	32'b0000_0010_0000_0000_0000_0000_0000_0000;
				
				danwei_4[0]	<=	32'b0;
				danwei_4[1]	<=	32'b0;
				danwei_4[2]	<=	32'b0;
				danwei_4[3]	<=	32'b0;
				danwei_4[4]	<=	32'b0000_0010_0000_0000_0000_0000_0000_0000;
			end
		else if(flag_4_posedge==2'b01&&(N<176))
			begin
				danwei_0<=danwei_0-L0_0_O;		
				
				danwei_1[0]<=danwei_1[0]-L1_0_O;		
				danwei_1[1]<=danwei_1[1]-L1_1_O;		
				
				danwei_2[0]<=danwei_2[0]-L2_0_O;		
				danwei_2[1]<=danwei_2[1]-L2_1_O;		
				danwei_2[2]<=danwei_2[2]-L2_2_O;		
				
				danwei_3[0]<=danwei_3[0]-L3_0_O;		
				danwei_3[1]<=danwei_3[1]-L3_1_O;		
				danwei_3[2]<=danwei_3[2]-L3_2_O;		
				danwei_3[3]<=danwei_3[3]-L3_3_O;		
				
				danwei_4[0]<=danwei_4[0]-L4_0_O;		
				danwei_4[1]<=danwei_4[1]-L4_1_O;		
				danwei_4[2]<=danwei_4[2]-L4_2_O;		
				danwei_4[3]<=danwei_4[3]-L4_3_O;		
				danwei_4[4]<=danwei_4[4]-L4_4_O;
			/*danwei_0<=18664104;
			danwei_1[0]<=-8914755;
			danwei_1[1]<=24732447;
			
			danwei_2[0]<=-4126348;
			danwei_2[1]<=-5270553;
			danwei_2[2]<=27999909;
			
			danwei_3[0]<=-7066962;
			danwei_3[1]<=-8691875;
			danwei_3[2]<=-6796152;
			danwei_3[3]<=21118289;
			
			danwei_4[0]<=-6416122;
			danwei_4[1]<=-1999738;
			danwei_4[2]<=473952;
			danwei_4[3]<=-1621119;
			danwei_4[4]<=22754307;*/
				
			end
							  /*$monitor ($time , ," step3 N%d\n	danwei_0 %d\n  danwei_1[0] %d\n danwei_1[1] %d\ndanwei_2[0] %d\n danwei_2[1] %d\n	danwei_2[2] %d\n danwei_3[0] %d\ndanwei_3[1] %d\n danwei_3[2] %d\n\n\n", 
                                     N,danwei_0, danwei_1[0], danwei_1[1], danwei_2[0], danwei_2[1], danwei_2[2],  danwei_3[0], danwei_3[1], danwei_3[2]);
	end*/
end
///////////////////////////////////////////////////////////////////////////////////////////////////////第一步结束：初始寄存器变量赋值完成

assign			X_1_pass=X_1,				X_2_pass=X_2,				X_3_pass=X_3,				X_4_pass=X_4,				X_5_pass=X_5;
assign			L0_0_I=danwei_0,				
					L1_0_I=danwei_1[0],		L1_1_I=danwei_1[1],		
					L2_0_I=danwei_2[0],		L2_1_I=danwei_2[1],		L2_2_I=danwei_2[2],	
					L3_0_I=danwei_3[0],		L3_1_I=danwei_3[1],		L3_2_I=danwei_3[2],		L3_3_I=danwei_3[3],		
					L4_0_I=danwei_4[0],		L4_1_I=danwei_4[1],		L4_2_I=danwei_4[2],		L4_3_I=danwei_4[3],		L4_4_I=danwei_4[4];
////////////////////////////////////////////////////////////////////
/*求逆状态机*/
////////////////////////////////////////////////////////////////////

always@(posedge clk or	negedge	rst)
	begin
		if(!rst)
			flag_out_posedge<=2'b00;
		else
			flag_out_posedge<={flag_out_posedge[0],flag_out_pass};
	end
always@(posedge clk or	negedge	rst)
	begin
		if(!rst)
			flag_1_posedge<=2'b11;
		else
			flag_1_posedge<={flag_1_posedge[0],flag_1};
	end
always @(posedge clk or	negedge	rst) 
	begin
		if(!rst)
			state_1<=3'b000;
		else
			case(state_1)
				3'b000:if(flag_1_posedge==2'b10)
							begin
								
								N<=0;
								flag_5<=0;
								state_1<=3'b1;
							end
				3'b001:if(flag_out_posedge==2'b01)
							begin
								N<=N+1;
								if(N>173)
									state_1<=3'b010;
								else
									state_1<=state_1;
							end
				3'b010:if((N>174)&&(!flag_4))	
							begin
								flag_5<=1;
								N<=180;
							end
		
			endcase
	end
reg	[1:0]	flag_5_posedge;
wire	flag_5_pass;
assign	flag_5_pass=flag_5;
always@(posedge clk or	negedge	rst)
	begin
		if(!rst)
			flag_5_posedge<=2'b00;
		else	
			flag_5_posedge<={flag_5_posedge[0],flag_5};
	end
reg	flag_4_dapai;
always@(posedge clk or	negedge	rst)
	begin
		if(!rst)
			flag_4_dapai<=0;
		else	if(flag_4_posedge==2'b01)
			flag_4_dapai<=flag_4;
		else
			flag_4_dapai<=0;
	end
always @(posedge clk or negedge	rst)
	begin
		if(!rst)
			flag_4<=0;
		else	if(flag_1_posedge==2'b10||flag_out_posedge==2'b01)
			begin
				flag_4<=1;
				flag_in<=1;
			end
		else	if(flag_4_dapai)
			begin
				flag_4<=0;
				flag_in<=0;
			end
	end
////////////////////////////////////////////////////////////////////
/*单周期完成后将X的赋值刷新*/
////////////////////////////////////////////////////////////////////
always @(posedge clk ) 
	begin
		if((flag_4_posedge==2'b01)&&(N<175))
			begin
				X_1<=x_reg_1[N];
				X_2<=x_reg_2[N];
				X_3<=x_reg_3[N];
				X_4<=x_reg_4[N];
				X_5<=x_reg_5[N];
			end
	end
	
Inverse	Inverse(
					.clk(clk),
					.rst(rst),
					.flag_out(flag_out_pass),
					.flag_in(flag_in_pass),
//					.flag_5(flag_5_pass),
					.X_1_pass(X_1_pass),	.X_2_pass(X_2_pass),	.X_3_pass(X_3_pass),	.X_4_pass(X_4_pass),	.X_5_pass(X_5_pass),
					
					.L0_0_I(L0_0_I),		
					.L1_0_I(L1_0_I),		.L1_1_I(L1_1_I),		
					.L2_0_I(L2_0_I),		.L2_1_I(L2_1_I),		.L2_2_I(L2_2_I),		
					.L3_0_I(L3_0_I),		.L3_1_I(L3_1_I),		.L3_2_I(L3_2_I),		.L3_3_I(L3_3_I),		
					.L4_0_I(L4_0_I),		.L4_1_I(L4_1_I),		.L4_2_I(L4_2_I),		.L4_3_I(L4_3_I),		.L4_4_I(L4_4_I),
					
					.L0_0_O(L0_0_O),		
					.L1_0_O(L1_0_O),		.L1_1_O(L1_1_O),		
					.L2_0_O(L2_0_O),		.L2_1_O(L2_1_O),		.L2_2_O(L2_2_O),		
					.L3_0_O(L3_0_O),		.L3_1_O(L3_1_O),		.L3_2_O(L3_2_O),		.L3_3_O(L3_3_O),		
					.L4_0_O(L4_0_O),		.L4_1_O(L4_1_O),		.L4_2_O(L4_2_O),		.L4_3_O(L4_3_O),		.L4_4_O(L4_4_O)
					);
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////第二阶段求逆结束
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////第三阶段求最终结果
////////////////////////////////////////////////////////////////////
/*求逆结束标志位flag_qiuni_top*/
////////////////////////////////////////////////////////////////////
reg	[15:0]	cnt_y_top;
reg	flag_qiuni_top;
always @(posedge clk or negedge rst) 
	begin	
		if(!rst)
			begin
				cnt_y_top	<=	16'b0;
				flag_qiuni_top<=0;
			end
		else	if(cnt_y_top>16'd19800)
			begin
				cnt_y_top<=cnt_y_top;
				flag_qiuni_top<=1;
			end
		else	if(cnt_y_top<=16'd19800)
				cnt_y_top<=cnt_y_top+1;	
	end
/*reg	[1:0]	flag_qiuni_posedge;
always@(posedge clk or	negedge	rst)
	begin
		if(!rst)
			flag_qiuni_posedge<=2'b00;
		else	
			flag_qiuni_posedge<={flag_qiuni_posedge[0],flag_qiuni};
	end*/
reg	[9:0]	cnt_dc_qiur_top;//计算一次Y：1*175需要的时间
reg	[14:0]	N_top;
always @(posedge clk or negedge rst) 
	begin	
		if(!rst)
			begin
				cnt_dc_qiur_top	<=	10'b0;
				N_top<=1;
			end
		else	if(cnt_dc_qiur_top==10'd360&&flag_qiuni_top&&N_top<=15'd8000)
			begin
				cnt_dc_qiur_top<=0;
				N_top<=N_top+1;
			end
		else	if(cnt_dc_qiur_top<10'd360&&flag_qiuni_top&&N_top<=15'd8000)
				cnt_dc_qiur_top<=cnt_dc_qiur_top+1;	
		else
			N_top<=N_top;
	end
////////////////////////////////////////////////////////////////////
/*计数器cnt_dc*/
////////////////////////////////////////////////////////////////////
reg	[9:0]	cnt_dc;
always @(posedge clk	)
	begin	
		if((N_top<=15'd8000)&&flag_qiuni_top)
					cnt_dc<=cnt_dc_qiur_top;
					
	end
////////////////////////////////////////////////////////////////////
/*计算xy,将X送入端口*/
////////////////////////////////////////////////////////////////////
reg	signed	[118:0]	Y	[174:0];
reg	signed	[31:0]	y_f,x_1_f,x_2_f,x_3_f,x_4_f,x_5_f;
wire	signed	[31:0]	y_f_pass,x_1_f_pass,x_2_f_pass,x_3_f_pass,x_4_f_pass,x_5_f_pass;
wire	signed	[63:0]	xy_1_f_pass,xy_2_f_pass,xy_3_f_pass,xy_4_f_pass,xy_5_f_pass;
reg	signed	[68:0]	xy_1_f,xy_2_f,xy_3_f,xy_4_f,xy_5_f;
assign	y_f_pass=y;
assign	x_1_f_pass=x_1_f;
assign	x_2_f_pass=x_2_f;
assign	x_3_f_pass=x_3_f;
assign	x_4_f_pass=x_4_f;
assign	x_5_f_pass=x_5_f;
always @(posedge clk)
	begin
	if((N_top<=15'd8000)&&(cnt_dc_qiur_top>=0)&&(cnt_dc_qiur_top<=174)&&flag_qiuni_top)
			begin
				x_1_f<=x_reg_1[cnt_dc_qiur_top];
				x_2_f<=x_reg_2[cnt_dc_qiur_top];
				x_3_f<=x_reg_3[cnt_dc_qiur_top];
				x_4_f<=x_reg_4[cnt_dc_qiur_top];
				x_5_f<=x_reg_5[cnt_dc_qiur_top];	
			end
	end
////////////////////////////////////////////////////////////////////
/*计数器cnt_dc打拍*/
////////////////////////////////////////////////////////////////////
reg	[9:0]	cnt_dc_1;
always @(posedge clk)
	begin	
		if((N_top<=15'd8000)&&flag_qiuni_top)
					cnt_dc_1<=cnt_dc;
					
	end
////////////////////////////////////////////////////////////////////
/*计算xy,累加*/
////////////////////////////////////////////////////////////////////
always @(posedge clk	or	negedge	rst)
	begin
	if(!rst)
		begin
			xy_1_f<=0;
			xy_2_f<=0;
			xy_3_f<=0;
			xy_4_f<=0;
			xy_5_f<=0;
		end
	
	else if((N_top<=15'd8000)&&(cnt_dc>=0)&&(cnt_dc<=174)&&flag_qiuni_top)
			begin
				xy_1_f<=xy_1_f+xy_1_f_pass;
				xy_2_f<=xy_2_f+xy_2_f_pass;
				xy_3_f<=xy_3_f+xy_3_f_pass;
				xy_4_f<=xy_4_f+xy_4_f_pass;
				xy_5_f<=xy_5_f+xy_5_f_pass;
				y_reg[cnt_dc]<=y;	
//				y_f<=y;
				Y[cnt_dc]<={y,87'b0};
				
			end
	else	
		begin
			xy_1_f<=0;
			xy_2_f<=0;
			xy_3_f<=0;
			xy_4_f<=0;
			xy_5_f<=0;
		end
	end
////////////////////////////////////////////////////////////////////
/*计算alfa*/
////////////////////////////////////////////////////////////////////
reg signed [89:0]  alfa1,alfa2,alfa3,alfa4,alfa5;
always @(posedge clk	or	negedge	rst)
	begin
	if(!rst)
		begin
			alfa1<=0;
			alfa2<=0;
			alfa3<=0;
			alfa4<=0;
			alfa5<=0;
		end
	
	else if((N_top<=15'd8000)&&(cnt_dc==175)&&flag_qiuni_top)
			begin
				 alfa1 <= danwei_0*xy_1_f + danwei_1[0]*xy_2_f + danwei_2[0]*xy_3_f + danwei_3[0]*xy_4_f + danwei_4[0]*xy_5_f;
             alfa2 <= danwei_1[0]*xy_1_f + danwei_1[1]*xy_2_f + danwei_2[1]*xy_3_f + danwei_3[1]*xy_4_f + danwei_4[1]*xy_5_f;
				 alfa3 <= danwei_2[0]*xy_1_f + danwei_2[1]*xy_2_f + danwei_2[2]*xy_3_f + danwei_3[2]*xy_4_f + danwei_4[2]*xy_5_f;
				 alfa4 <= danwei_3[0]*xy_1_f + danwei_3[1]*xy_2_f + danwei_3[2]*xy_3_f + danwei_3[3]*xy_4_f + danwei_4[3]*xy_5_f;
				 alfa5 <= danwei_4[0]*xy_1_f + danwei_4[1]*xy_2_f + danwei_4[2]*xy_3_f + danwei_4[3]*xy_4_f + danwei_4[4]*xy_5_f;
			end
	else if((N_top<=15'd8000)&&(cnt_dc>175)&&(cnt_dc<350)&&flag_qiuni_top)
			begin
				 alfa1 <= alfa1;
             alfa2 <= alfa2;
				 alfa3 <= alfa3;
             alfa4 <= alfa4;
				 alfa5 <= alfa5;
			end
	else	
		begin
			alfa1<=0;
			alfa2<=0;
			alfa3<=0;
			alfa4<=0;
			alfa5<=0;
		end		
	end
	
////////////////////////////////////////////////////////////////////
/*计算alfa*x,*/
////////////////////////////////////////////////////////////////////
reg	signed	[118:0]	sum	[174:0];
always @(posedge clk	)
	begin
	if((N_top<=15'd8000)&&(cnt_dc>=176)&&(cnt_dc<=350)&&flag_qiuni_top)
				sum[cnt_dc-176]<=x_reg_1[cnt_dc-176]*alfa1+x_reg_2[cnt_dc-176]*alfa2+x_reg_3[cnt_dc-176]*alfa3+x_reg_4[cnt_dc-176]*alfa4+x_reg_5[cnt_dc-176]*alfa5;
	end
/*reg	[9:0]	cnt_dc_2;
always @(posedge clk	or	rst)
	begin	
		if(!rst)
				cnt_dc_2<=	10'd0;
		else	if((N_top<=13'd7999)&&flag_qiuni_top)
					cnt_dc_2<=cnt_dc_1;
					
	end*/
////////////////////////////////////////////////////////////////////
/*计算R*/
////////////////////////////////////////////////////////////////////
reg	signed	[124:0]	sum_final;
always @(posedge clk	or	negedge	rst)
	begin
	if(!rst)
		begin
		sum_final<=0;
		end
		else if((N_top<=15'd8000)&&(cnt_dc>=177)&&(cnt_dc_1<=351)&&flag_qiuni_top)
			begin
					if( sum[cnt_dc-177] > Y[cnt_dc-177] ) 
						sum_final <= sum_final + (sum[cnt_dc-177] - Y[cnt_dc-177]);//sumH3相当于Ry
					else
						sum_final <= sum_final + (Y[cnt_dc-177] - sum[cnt_dc-177]);
			end
		else
			sum_final<=0;
	end
MUL_xy MUL_xy_1 (.a(y_f_pass), .b(x_1_f_pass),	.p(xy_1_f_pass));	
MUL_xy MUL_xy_2 (.a(y_f_pass), .b(x_2_f_pass),	.p(xy_2_f_pass));
MUL_xy MUL_xy_3 (.a(y_f_pass), .b(x_3_f_pass),	.p(xy_3_f_pass));
MUL_xy MUL_xy_4 (.a(y_f_pass), .b(x_4_f_pass),	.p(xy_4_f_pass));
MUL_xy MUL_xy_5 (.a(y_f_pass), .b(x_5_f_pass),	.p(xy_5_f_pass));

/*MUL_xaf MUL_xaf_1 (.a(af1_g_pass), .b(x_1_g_pass),	.p(xy_1_g_pass));	
MUL_xaf MUL_xaf_2 (.a(af2_g_pass), .b(x_2_g_pass),	.p(xy_2_g_pass));
MUL_xaf MUL_xaf_3 (.a(af3_g_pass), .b(x_3_g_pass),	.p(xy_3_g_pass));
MUL_xaf MUL_xaf_4 (.a(af4_g_pass), .b(x_4_g_pass),	.p(xy_4_g_pass));
MUL_xaf MUL_xaf_5 (.a(af5_g_pass), .b(x_5_g_pass),	.p(xy_5_g_pass));*/
endmodule
