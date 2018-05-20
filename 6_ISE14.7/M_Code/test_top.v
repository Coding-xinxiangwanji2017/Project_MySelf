`timescale 1ns / 1ps
module test_top(
);
	reg  [31:0]	x_t;
	reg  [31:0]	y_t;
	parameter NoOfY =44799999; 
	reg memx [0:27999];											//29000=875*32
	reg memy [0:NoOfY];											//44800000=8000*32*175
	reg clk;
	reg rst;
	wire	[31:0]	x_t_pass;
	wire	[31:0]	y_t_pass;
	wire	clk_pass;
	wire	rst_pass;
assign	x_t_pass	=	x_t;
assign	y_t_pass	=	y_t;
assign	clk_pass	=	clk;
assign	rst_pass	=	rst;	
	FPGA_CRD_1_TOP instance_name (
    .x(x_t_pass), 
    .y(y_t_pass), 
    .clk(clk_pass), 
    .rst(rst_pass)
    );
	 
always #(50) clk <= ~clk;									//产生时钟信号
////////////////////////////////////////////////////////////////////
/*初始化*/
////////////////////////////////////////////////////////////////////	
initial 
	begin
			clk = 0;														//初始化输入值
			rst = 0;
			#100;															//等待100ns，直到全局复位完成
			rst = 1; 
			$readmemb("1x_Target32.txt",memx);					//将1x_Target32.txt的数据载入memx，875*32
			$readmemb("1y_Target32.txt",memy);					//将1y_Target32.txt的数据载入memy，1400000*32
	end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*计数器cnt,设置标志位*/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		
reg	[12:0]	cnt;
reg	flag;
always @(posedge clk or negedge rst) 
	begin	
		if(!rst)	
			begin
				cnt	<=	13'b0;
				flag	<=1;
			end
		else	if(cnt==1050)
			begin
				cnt	<=	13'd1051;
				flag	<=	0;
			end
		else	if(cnt<1050)
			cnt	<=	cnt	+	1;	
	end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*将寄存器中的875*32个X数据送到接口*/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
always@(posedge clk or negedge rst)	
	begin
	   if(!rst)
			begin
				x_t <= 32'b0;
			end
		 else if(174<cnt< 1050	&&	flag) 
					begin								//875=175*5
						 x_t[31:0] <= {memx[32*(cnt-175)],memx[32*(cnt-175)+1],memx[32*(cnt-175)+2],memx[32*(cnt-175)+3],			
											memx[32*(cnt-175)+4],memx[32*(cnt-175)+5],memx[32*(cnt-175)+6],memx[32*(cnt-175)+7],
											memx[32*(cnt-175)+8],memx[32*(cnt-175)+9],memx[32*(cnt-175)+10],memx[32*(cnt-175)+11],
											memx[32*(cnt-175)+12],memx[32*(cnt-175)+13],memx[32*(cnt-175)+14],memx[32*(cnt-175)+15],
											memx[32*(cnt-175)+16],memx[32*(cnt-175)+17],memx[32*(cnt-175)+18],memx[32*(cnt-175)+19],
											memx[32*(cnt-175)+20],memx[32*(cnt-175)+21],memx[32*(cnt-175)+22],memx[32*(cnt-175)+23],
											memx[32*(cnt-175)+24],memx[32*(cnt-175)+25],memx[32*(cnt-175)+26],memx[32*(cnt-175)+27],
											memx[32*(cnt-175)+28],memx[32*(cnt-175)+29],memx[32*(cnt-175)+30],memx[32*(cnt-175)+31]};
					end
	end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*将寄存器中的175*32个Y数据送到接口*/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
reg	[15:0]	cnt_y;
reg	flag_qiuni;
always @(posedge clk or negedge rst) 
	begin	
		if(!rst)
			begin
				cnt_y	<=	16'b0;
				flag_qiuni<=0;
			end
		else	if(cnt_y>16'd19800)
			begin
				cnt_y<=cnt_y;
				flag_qiuni<=1;
			end
		else	if(cnt_y<=16'd19800)
				cnt_y<=cnt_y+1;	
	end
/*reg	[1:0]	flag_qiuni_posedge;
always@(posedge clk or	negedge	rst)
	begin
		if(!rst)
			flag_qiuni_posedge<=2'b00;
		else	
			flag_qiuni_posedge<={flag_qiuni_posedge[0],flag_qiuni};
	end*/
reg	[9:0]	cnt_dc_qiur;
reg	[14:0]	N;
always @(posedge clk or negedge rst) 
	begin	
		if(!rst)
			begin
				cnt_dc_qiur	<=	10'b0;
				N<=0;
			end
		else	if(cnt_dc_qiur==10'd360&&flag_qiuni&&N<=15'd7999)
			begin
				cnt_dc_qiur<=0;
				N<=N+1;
			end
		else	if(cnt_dc_qiur<10'd360&&flag_qiuni&&N<=15'd7999)
				cnt_dc_qiur<=cnt_dc_qiur+1;	
		else
			N<=N;
	end	

always@(posedge clk or negedge rst)	
	begin
	   if(!rst)
			begin
				y_t <= 32'b0;
			end
		 else  if((N<=15'd7999)&&(cnt_dc_qiur>=0)&&(cnt_dc_qiur<=174)&&flag_qiuni)
								 y_t[31:0] <= {memy[32*(N*175+cnt_dc_qiur)],memy[32*(N*175+cnt_dc_qiur)+1],memy[32*(N*175+cnt_dc_qiur)+2],memy[32*(N*175+cnt_dc_qiur)+3],
													memy[32*(N*175+cnt_dc_qiur)+4],memy[32*(N*175+cnt_dc_qiur)+5],memy[32*(N*175+cnt_dc_qiur)+6],memy[32*(N*175+cnt_dc_qiur)+7],
													memy[32*(N*175+cnt_dc_qiur)+8],memy[32*(N*175+cnt_dc_qiur)+9],memy[32*(N*175+cnt_dc_qiur)+10],memy[32*(N*175+cnt_dc_qiur)+11],
													memy[32*(N*175+cnt_dc_qiur)+12],memy[32*(N*175+cnt_dc_qiur)+13],memy[32*(N*175+cnt_dc_qiur)+14],memy[32*(N*175+cnt_dc_qiur)+15],
													memy[32*(N*175+cnt_dc_qiur)+16],memy[32*(N*175+cnt_dc_qiur)+17],memy[32*(N*175+cnt_dc_qiur)+18],memy[32*(N*175+cnt_dc_qiur)+19],
													memy[32*(N*175+cnt_dc_qiur)+20],memy[32*(N*175+cnt_dc_qiur)+21],memy[32*(N*175+cnt_dc_qiur)+22],memy[32*(N*175+cnt_dc_qiur)+23],
													memy[32*(N*175+cnt_dc_qiur)+24],memy[32*(N*175+cnt_dc_qiur)+25],memy[32*(N*175+cnt_dc_qiur)+26],memy[32*(N*175+cnt_dc_qiur)+27],
													memy[32*(N*175+cnt_dc_qiur)+28],memy[32*(N*175+cnt_dc_qiur)+29],memy[32*(N*175+cnt_dc_qiur)+30],memy[32*(N*175+cnt_dc_qiur)+31]};							
	end
endmodule 