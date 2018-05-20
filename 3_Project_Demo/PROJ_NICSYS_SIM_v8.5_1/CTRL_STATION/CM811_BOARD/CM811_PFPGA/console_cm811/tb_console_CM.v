//tb_console_CM
module tb_console_CM;

	reg 				 clk;
	reg 				 rst;
	
	reg	       	 i_console_en;
	reg [02:0]   im_mode_reg;
  //与初始化模块接口                  	
	reg 				 i_ini_ok;
	//与诊断表RAM接口
	wire [10:0]   om_diag_ram_addr;
	reg [7:0] 	 im_diag_ram_dout;
	//维护下行命令RAM对外接口
	reg 				 i_cdcb_a_wren;
	reg [10:0]	 im_cdcb_a_addr;
	reg	[7:0] 	 im_cdcb_a_din;
	wire [7:0]  	 om_cdcb_a_dout;
	//维护上行命令RAM对外接口
	reg 				 i_cucb_a_wren;
	reg [10:0]	 im_cucb_a_addr;
	reg	[7:0] 	 im_cucb_a_din;
	wire [7:0]  	 om_cucb_a_dout;
	//维护上行数据RAM对外接口
	reg					 i_cudb_a_wren;
	reg [12:0] 	 im_cudb_a_addr;
	reg [7:0]    im_cudb_a_din;
	wire	[7:0]		 om_cudb_a_dout;
	//维护下行数据RAM对外接口
	reg				   i_cddb_a_wren;
	reg [12:0]   im_cddb_a_addr;
	reg [7:0] 	 im_cddb_a_din;	
	wire [7:0] 	 om_cddb_a_dout;
	//下装下行ram对外接口
	reg          i_ddb_a_wren;
	reg [10:0]   im_ddb_a_addr;
	reg [7:0]    im_ddb_a_din;
	wire [7:0]    om_ddb_a_dout;
	//下装上行ram对外接口
	reg          i_dub_a_wren;
	reg [10:0]   im_dub_a_addr;
	reg [7:0]    im_dub_a_din;
	wire [7:0]    om_dub_a_dout;

	//eeprom wr_ctrl
	wire          o_e2prom_rden;
  wire          o_e2prom_wren;
  wire [16:00]  om_e2prom_addr;
  wire [16:00]  om_e2prom_wr_len;
  reg          im_e2prom_ready;
  wire [07:00]  om_e2prom_wdata;
  wire          o_e2prom_wr_dv;
  wire          om_e2prom_wr_last;
  reg [07:00]  im_e2prom_rd_data;
  reg          i_e2prom_rd_valid;
  reg          i_e2prom_rd_last;
  reg          i_status_reg_en;
  reg [07:00]  im_status_reg;
	
	wire [12:0]   om_ch1_addr;
	reg [7:0] 	 im_ch1_rdata;
	wire [12:0]   om_ch2_addr;
	reg [7:0] 	 im_ch2_rdata;
	wire [12:0]   om_ch3_addr;
	reg [7:0] 	 im_ch3_rdata;
	wire [12:0]   om_ch4_addr;
	reg [7:0]    im_ch4_rdata;
	wire [12:0]   om_ch5_addr;
	reg [7:0] 	 im_ch5_rdata;
	wire [12:0]   om_ch6_addr;
	reg [7:0] 	 im_ch6_rdata;

	reg          i_flag_wr_ddb;




	initial begin
		rst = 1;
		clk = 1;
		#40.1
		rst = 0;
		#100
		$stop;
	
	
	end

always #10 clk = ~clk;



console_CM console_CM(

 .clk(clk),
 .rst(rst),
 
 .i_console_en(i_console_en),
 .im_mode_reg(im_mode_reg),
              	
 .i_ini_ok(i_ini_ok),
 
 .om_diag_ram_addr(),
 .im_diag_ram_dout(),
 
 .i_cdcb_a_wren(),
 .im_cdcb_a_addr(),
 .im_cdcb_a_din(),
 .om_cdcb_a_dout(),
 
 .i_cucb_a_wren(),
 .im_cucb_a_addr(),
 .im_cucb_a_din(),
 .om_cucb_a_dout(),
 
 .i_cudb_a_wren(),
 .im_cudb_a_addr(),
 .im_cudb_a_din(),
 .om_cudb_a_dout(),
 
 .i_cddb_a_wren(),
 .im_cddb_a_addr(),
 .im_cddb_a_din(),	
 .om_cddb_a_dout(),
 
 .i_ddb_a_wren(),
 .im_ddb_a_addr(),
 .im_ddb_a_din(),
 .om_ddb_a_dout(),
 
 .i_dub_a_wren(),
 .im_dub_a_addr(),
 .im_dub_a_din(),
 .om_dub_a_dout(),
 
 .o_e2prom_rden(),
 .o_e2prom_wren(),
 .om_e2prom_addr(),
 .om_e2prom_wr_len(),
 .im_e2prom_ready(),
 .om_e2prom_wdata(),
 .o_e2prom_wr_dv(),
 .om_e2prom_wr_last(),
 .im_e2prom_rd_data(),
 .i_e2prom_rd_valid(),
 .i_e2prom_rd_last(),
 .i_status_reg_en(),
 .im_status_reg(),
 
 .om_ch1_addr(),
 .im_ch1_rdata(),
 .om_ch2_addr(),
 .im_ch2_rdata(),
 .om_ch3_addr(),
 .im_ch3_rdata(),
 .om_ch4_addr(),
 .im_ch4_rdata(),
 .om_ch5_addr(),
 .im_ch5_rdata(),
 .om_ch6_addr(),
 .im_ch6_rdata(),
 
 .i_flag_wr_ddb()
	
);



endmodule