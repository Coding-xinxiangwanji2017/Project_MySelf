
module rmii(
        input   wire         i_rstn     ,		
        input   wire         i_clk_50m  ,		
                                        
        input   wire         i_rxdv     ,			
        input   wire [1:0]   im_rxdata  ,		
                                
        output  reg          o_d_flag   ,
        output  reg          o_d_sync   ,
        output  wire [7:0]   om_data    ,
        output  reg          o_mac_start,
        output  wire [19:0]  om_tout    ,
        output  wire         o_crc_en
		);

reg	 [1:0]	rxdv_sync  ;
reg         rmii_den   ;
reg	 [1:0]	rmii_data  ; 
reg	 [7:0]	shift_data ;
reg	 [1:0]	d_count    ;

assign	om_tout=20'h0;
assign  o_crc_en =  (o_d_flag&o_d_sync)?1'b1:1'b0 ;  

//********************************************
//		处理使能信号
//********************************************

always	@(posedge i_clk_50m) begin
	rxdv_sync<={rxdv_sync[0],i_rxdv};
	rmii_data<=im_rxdata;
	end

always	@(rxdv_sync)
	if (rxdv_sync==2'b00)
		rmii_den<=0;
	else
		rmii_den<=1;

//********************************************
//		处理同步标志
//********************************************
always	@(posedge i_clk_50m)
	if (rmii_den==0)
		shift_data<=0;
	else
		shift_data<={rmii_data,shift_data[7:2]};

always	@(rmii_den or o_d_flag or shift_data)
	if (rmii_den==1 && o_d_flag==0 && shift_data==8'hd5)
		o_mac_start<=1;
	else
		o_mac_start<=0;

always	@(posedge i_clk_50m or negedge i_rstn)
	if (i_rstn==0)
		d_count<=0;
	else if (o_mac_start==1)
		d_count<=0;
	else
		d_count<=d_count+1'd1;

always	@(posedge i_clk_50m or negedge i_rstn)
	if (i_rstn==0)
		o_d_sync<=0;
	else if (o_mac_start==0 && d_count==2)
		o_d_sync<=1;
	else
		o_d_sync<=0;

always	@(posedge i_clk_50m or negedge i_rstn)
	if (i_rstn==0)
		o_d_flag<=0;
	else if (o_mac_start==1)
		o_d_flag<=1;
	else if (rmii_den==0)
		o_d_flag<=0;

assign	om_data=shift_data;

endmodule
