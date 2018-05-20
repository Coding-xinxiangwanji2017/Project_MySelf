//*********************************************************************************/
//--------------------------------------------
//  SYN * SD * DA * SA * TP * DATA * CRC
//--------------------------------------------
//   7  * 1  * 6  * 6  * 2  * 1024 *  4
//--------------------------------------------
//****************************************************************************/

module mii_mac_tx(
                input    wire             i_rst_n                ,    //systerm reset  
                input    wire             i_sclk50               ,    //systerm clk 80M         
		            input    wire             i_start                ,			//单元板黑屏使能
                
                input    wire [47:0]      im_source_addr         ,		//Source Address
                input    wire [47:0]      im_destin_addr         ,		//Destination Address
//                input    wire [15:0]      im_func_code           ,
                input    wire [15:0]      im_type_code           ,
//                input    wire [31:0]      im_frame_totalnum      ,
//                input    wire [15:0]      im_frame_totalcount    ,
//                input    wire [15:0]      im_frame_num           ,
//                input    wire [15:0]      im_frame_total_length  ,
                input    wire [15:0]      im_frame_data_length   ,
                                          
//                input    wire [31:0]      im_crc1_out            ,
        
                output   wire             o_ram_rden             ,
                output   wire [7:0]      om_ram_raddr           ,
                input    wire [7:0]       im_ram_rdata           ,
                                                                 
                output   wire             o_tx_en                ,
//                output   wire [7:0]       om_tx_tmp              ,         
                output   wire [1:0]       om_tx_data         
		);

reg [3:0]       current_state   /*synthesis syn_keep=1 */;
reg [3:0]       next_state               ;

parameter       STATE_IDLE           =4'd00 ;
parameter       STATE_PREAMBLE       =4'd01 ;
parameter       STATE_SFD            =4'd02 ;
parameter       STATE_HEAD           =4'd03 ;
parameter       STATE_CTRL           =4'd04 ;
parameter       STATE_DATA           =4'd05 ;
parameter       STATE_CRC1           =4'd06 ;
parameter       STATE_CRC2           =4'd07 ;
parameter       STATE_FCS            =4'd08 ;
parameter       STATE_SWITCHNEXT     =4'd09 ;
//////////////////////////////////////////////
parameter       LENGTH               ='d136 ;         //add by lch

parameter    CONT_DELAY = 500;	//5000000
reg [4:0]       preamble_counter            ;
reg [4:0]       framehead_counter           ;
reg [4:0]       datahead_counter            ;
reg [10:0]      datalength_counter          ;
reg [2:0]       crc1_counter                ;
reg [31:0] 		delay_counter;


// reg [7:0]       txd8                        ;
reg [1:0]       txd2                        ;
// reg [1:0]       count_d1                    ;

/////////////////////////////////////////////////

/////////////////////////////////////////////////
reg [7:0]       ram_rdata_reg;

always @ (posedge i_sclk50 or negedge i_rst_n)
    begin
        if (~i_rst_n)
            begin
                ram_rdata_reg       <= 8'd0 ;
            end
        else 
            begin
                ram_rdata_reg       <= im_ram_rdata   ;
            end
    end   
/////////////////////////////////////////////////


/////////////////////////////////////////////////

/////////////////////////////////////////////////
wire            count_en                    ;
reg             tx_en_reg                   ;

assign          count_en = (current_state != STATE_IDLE || current_state != STATE_SWITCHNEXT) ;

always @ (posedge i_sclk50 or negedge i_rst_n)
    begin
        if (~i_rst_n)
            tx_en_reg       <= 1'b0 ;
        else if(next_state == STATE_IDLE || next_state == STATE_SWITCHNEXT )
            tx_en_reg       <= 1'b0 ;
        else 
            tx_en_reg       <= count_en   ;
    end    

//assign          o_tx_en     = tx_en_reg   ;

//add by lzk
reg tx_en_reg1;
always @ (posedge i_sclk50 or negedge i_rst_n)
    begin
        if (~i_rst_n)
            tx_en_reg1       <= 1'b0 ;
        else 
            tx_en_reg1       <= tx_en_reg  ;
    end  

assign          o_tx_en     = tx_en_reg1   ;


/////////////////////////////////////////////////
reg [1:0]       count                       ;
always @ (posedge i_sclk50 or negedge i_rst_n)
    begin
        if (~i_rst_n)
            count       <= 2'b00 ;
        else if(count_en)
            count       <= count + 2'd1 ;
        else 
            count       <= 2'b00 ;
    end   
/////////////////////////////////////////////////
always @ (posedge i_sclk50 or negedge i_rst_n)
    begin
        if (~i_rst_n)
            current_state       <= STATE_IDLE;
        else 
            current_state       <= next_state; 
    end         
    
    
reg r_start;   
    
always @ (posedge i_sclk50 or negedge i_rst_n)
    begin
        if (~i_rst_n)
            r_start       <= 1'b0;
        else 
            if(i_start)
                r_start   <= 1'b1; 
            else if(count == 2'd3)
                r_start   <= 1'b0;
    end           

always @ ( * )
    begin
        case (current_state)         
            STATE_IDLE:       
                if (r_start && (count == 2'd3))
                    next_state = STATE_PREAMBLE;
                else
                    next_state = current_state;  
                    
            STATE_PREAMBLE:												//SYN : 7 Byte
                if ((preamble_counter==5'd6) && (count == 2'd3))
//                if ((preamble_counter==5'd7) && (count == 2'd3))
                    next_state = STATE_SFD ;
                else
                    next_state = current_state;
                    
            STATE_SFD:													//SD : 1 Byte
                if(count == 2'd3)
                    next_state = STATE_HEAD ;
                else
                    next_state = current_state;
                    
            STATE_HEAD:													//DA & SA & TY & LE : 12 + 2 + 2Byte
                if((framehead_counter==5'd13) && (count == 2'd3))
//                if((framehead_counter==5'd12) && (count == 2'd3))
//                    next_state = STATE_CTRL ;
                    next_state = STATE_DATA;//STATE_CTRL ;
                else
                    next_state = current_state;

            STATE_CTRL:													//CTRL : 2 Byte
//                if((datahead_counter==5'd19) && (count == 2'd3))
                if((datahead_counter==5'd1) && (count == 2'd3))
                    next_state = STATE_DATA ;
                else
                    next_state = current_state;
   
            STATE_DATA:													//DATA : 1024 Byte
//                if ((datalength_counter==10'd1023) && (count == 2'd3)) 	2014/11/4 16:33:38
                if ((datalength_counter==LENGTH-1) && (count == 2'd3))  //edit by lch   LENGTH->im_frame_data_length
                    next_state = STATE_CRC1;
                else
                    next_state = STATE_DATA;

            STATE_CRC1:													//CRC : 4 Byte
                if((crc1_counter==4'd3) && (count == 2'd3))
//                    next_state = STATE_CRC2 ;		2014/11/4 16:25:18
                    next_state = STATE_SWITCHNEXT ;
                else
                    next_state = current_state;
                    
//            STATE_CRC2:							2014/11/4 16:25:24
//                if((crc2_counter==4'd3) && (count == 2'd3))
//                    next_state = STATE_FCS ;
//                else
//                    next_state = current_state;    
                    
//            STATE_FCS:
//                if ((fcs_counter==4'd3) && (count == 2'd3))
//                    next_state = STATE_SWITCHNEXT;
//                else
//                    next_state = current_state;
                    
            STATE_SWITCHNEXT:
				//if(delay_counter==CONT_DELAY)
                    next_state = STATE_IDLE;   
		//		else
                //    next_state = current_state;
            default:
                next_state = STATE_IDLE;
        endcase
    end       
//////////////////////////////////////////////////   
always @ (posedge i_sclk50 or negedge i_rst_n)
    begin
        if (~i_rst_n)
            preamble_counter    <= 5'h0;
        else if (current_state!=STATE_PREAMBLE)
            preamble_counter    <= 5'h0;
        else if(current_state == STATE_PREAMBLE && count == 2'd3)
            preamble_counter    <= preamble_counter + 1'b1;
    end   
/////////////////////////////////////////////////
always @ (posedge i_sclk50 or negedge i_rst_n)
    begin
        if (~i_rst_n)
            framehead_counter     <= 5'h0;
        else if (current_state == STATE_SFD)//|| STATE_SWITCHNEXT || STATE_IDLE || STATE_CTRL)
            framehead_counter     <= 5'h0;
        else if (current_state == STATE_HEAD && count == 2'd3)
            framehead_counter     <= framehead_counter + 1'b1;
    end
/////////////////////////////////////////////////
always @ (posedge i_sclk50 or negedge i_rst_n)
    begin
        if (~i_rst_n)
            datahead_counter     <= 5'h0;
        else if (current_state == STATE_SFD)//|| STATE_SWITCHNEXT || STATE_IDLE || STATE_DATA)
            datahead_counter     <= 5'h0;
        else if (current_state == STATE_CTRL && count == 2'd3)
            datahead_counter     <= datahead_counter + 1'b1;
    end
/////////////////////////////////////////////////
always @ (posedge i_sclk50 or negedge i_rst_n)
    begin
        if (~i_rst_n)
            datalength_counter     <= 11'h0;
        else if (current_state == STATE_IDLE)// || STATE_SWITCHNEXT || STATE_IDLE || STATE_CRC1)
            datalength_counter     <= 11'h0;    
        else if (current_state == STATE_DATA && count == 2'd3)
            datalength_counter     <= datalength_counter + 1'b1;
    end
/////////////////////////////////////////////////
always @ (posedge i_sclk50 or negedge i_rst_n)
    begin
        if (~i_rst_n)
            crc1_counter     <= 3'h0;
        else if (current_state == STATE_SFD)// || STATE_SWITCHNEXT || STATE_IDLE || STATE_CRC2)
            crc1_counter     <= 3'h0;    
        else if (current_state == STATE_CRC1 && count == 2'd3)
            crc1_counter     <= crc1_counter + 1'b1;
    end 
/////////////////////////////////////////////////

//always @ (posedge i_sclk50 or negedge i_rst_n)
//   begin
//       if (~i_rst_n)
//           delay_counter     <= 32'h0;
//       else if (current_state == STATE_SFD)// || STATE_SWITCHNEXT || STATE_IDLE || STATE_CRC2)
//           delay_counter     <= 32'h0;    
//       else if (current_state == STATE_SWITCHNEXT)
//		begin
//			if(delay_counter==CONT_DELAY)
//				delay_counter     <= 32'h0;
//			else
//				delay_counter     <= delay_counter + 1'b1;
//		end
//       else
//		delay_counter     <= 32'h0; 
//   end 
/////////////////////////////////////////////////
reg [7:0]       txd_tmp;
wire [31:0] final;
wire [31:0] nextCRC32_D8;
reg [7:0] data;
reg [31:0] crc;
always @ (posedge i_sclk50)
begin
 
  if(current_state==STATE_HEAD&& framehead_counter==0)
	begin
		data <= txd_tmp;
		crc <= 32'hffffffff;
	end
  else if((current_state==STATE_HEAD || current_state==STATE_DATA) && count == 2'd0)
	begin
		data <= txd_tmp;
		crc <= nextCRC32_D8;
	end
end

CRC32_D8 inst_CRC32_D8(
    	.Data			(data),
    	.crc			(crc),
    	.nextCRC32_D8	(nextCRC32_D8),
		.final			(final)
    	);
/////////////////////////////////////////////////////////////////////////////


always @ ( * )
    begin
        case (current_state)
            STATE_PREAMBLE:
                txd_tmp = 8'h55;
                
            STATE_SFD:
                txd_tmp = 8'hd5;
                
            STATE_HEAD:
                case (framehead_counter)
                    5'd0:   txd_tmp = im_destin_addr[7:0] 	;                  //im_ttl;
                    5'd1:   txd_tmp = im_destin_addr[15:8]  ;                  //im_base_ring_ctrl;
                    5'd2:   txd_tmp = im_destin_addr[23:16] ;                  //DESTI_MAC_ADDR;
                    5'd3:   txd_tmp = im_destin_addr[31:24] ;                  //DESTI_MAC_ADDR;
                    5'd4:   txd_tmp = im_destin_addr[39:32] ;                  //DESTI_MAC_ADDR;
                    5'd5:   txd_tmp = im_destin_addr[47:40] ;                  //DESTI_MAC_ADDR;
                    5'd6:   txd_tmp = im_source_addr[7:0] 	;                  //DESTI_MAC_ADDR;
                    5'd7:   txd_tmp = im_source_addr[15:8]  ;                  //DESTI_MAC_ADDR;
                    5'd8:   txd_tmp = im_source_addr[23:16] ;                  //im_mac_addr[47:40];  
                    5'd9:   txd_tmp = im_source_addr[31:24] ;                  //im_mac_addr[39:32];  
                    5'd10:  txd_tmp = im_source_addr[39:32] ;                  //im_mac_addr[31:24];  
                    5'd11:  txd_tmp = im_source_addr[47:40] ;                  //im_mac_addr[23:16];  
                    5'd12:  txd_tmp = im_type_code[7:0] ;//8'h52  ;                                 //im_mac_addr[15:8] ;   
                    5'd13:  txd_tmp = im_type_code[15:8];//8'h46  ;                                 //im_mac_addr[7:0]  ;    
                    default:txd_tmp = 8'h00  ;
                endcase
                
            STATE_CTRL:
                case (datahead_counter)
                	  5'd0:  txd_tmp = im_frame_data_length[7:0]    ;//im_mac_addr[31:24];  
                    5'd1:  txd_tmp = im_frame_data_length[15:8]   ;//im_mac_addr[23:16];  
//                    5'd0:   txd_tmp = im_type_code[7:0]            ;//im_ttl;
//                    5'd1:   txd_tmp = im_type_code[15:8]           ;//im_base_ring_ctrl;
//                    5'd2:   txd_tmp = 8'h00                        ;//DESTI_MAC_ADDR;
//                    5'd3:   txd_tmp = 8'h00                        ;//DESTI_MAC_ADDR;
//                    5'd4:   txd_tmp = im_frame_totalnum[7:0]       ;//DESTI_MAC_ADDR;
//                    5'd5:   txd_tmp = im_frame_totalnum[15:8]      ;//DESTI_MAC_ADDR;
//                    5'd6:   txd_tmp = im_frame_totalnum[23:16]     ;//DESTI_MAC_ADDR;
//                    5'd7:   txd_tmp = im_frame_totalnum[31:24]     ;//DESTI_MAC_ADDR;
//                    5'd8:   txd_tmp = im_frame_totalcount[7:0]     ;//im_mac_addr[47:40];  
//                    5'd9:   txd_tmp = im_frame_totalcount[15:8]    ;//im_mac_addr[39:32];  
//                    5'd10:  txd_tmp = im_frame_num[7:0]            ;//im_mac_addr[31:24];  
//                    5'd11:  txd_tmp = im_frame_num[15:8] 	       ;//im_mac_addr[23:16];  
//                    5'd12:  txd_tmp = im_frame_total_length[7:0]   ;//im_mac_addr[15:8] ;   
//                    5'd13:  txd_tmp = im_frame_total_length[15:8]  ;//im_mac_addr[7:0]  ;
//                    5'd14:  txd_tmp = im_frame_data_length[7:0]    ;//im_mac_addr[31:24];  
//                    5'd15:  txd_tmp = im_frame_data_length[15:8]   ;//im_mac_addr[23:16];  
//                    5'd16:  txd_tmp = ctrl_out_reg ;   
//                    5'd17:  txd_tmp = ctrl_out_reg ;
//                    5'd18:  txd_tmp = ctrl_out_reg ;  
//                    5'd19:  txd_tmp = ctrl_out_reg ;  
                    default:txd_tmp = 8'h00  ;
                endcase
                    
            STATE_DATA:
                txd_tmp = ram_rdata_reg ;

            STATE_CRC1:
//                txd_tmp = crc1_out_reg  ;		2014/11/4 16:38:14
   				case(crc1_counter)
	   				3'd0:txd_tmp = final[7:0];//8'h25;
	   				3'd1:txd_tmp = final[15:8];//8'hb6;
	   				3'd2:txd_tmp = final[23:16];//8'h67;
	   				3'd3:txd_tmp = final[31:24];//8'h54;
					//3'd0:txd_tmp = 8'h40;
//	   				3'd1:txd_tmp = 8'hef;
//	   				3'd2:txd_tmp = 8'h8f;
//	   				3'd3:txd_tmp = 8'h61;
	   				//default:txd_tmp = 8'h00  ;
                endcase
//            STATE_CRC2:                 		2014/11/4 16:38:19
//                txd_tmp = crc2_out_reg  ;
//
//            STATE_FCS:						2014/11/4 16:38:24
//                txd_tmp = fcs_out_reg   ;
                
            default:     txd_tmp = 8'h00 ;
        endcase
    end   

assign          om_tx_tmp = txd_tmp;


/////////////////////////////////////////////////
always @ (posedge i_sclk50 or negedge i_rst_n)
    begin
        if(~i_rst_n)
            txd2 <= 2'b00 ;
        else
            case(count)
                2'd0:      txd2 <= txd_tmp[1:0] ;
                2'd1:      txd2 <= txd_tmp[3:2] ;
                2'd2:      txd2 <= txd_tmp[5:4] ;
                2'd3:      txd2 <= txd_tmp[7:6] ;
                default:   txd2 <= 2'b00 ;
            endcase
    end    
    
assign          om_tx_data = txd2 ;
/////////////////////////////////////////////////////////////////////////////

reg             ram_rden                    ;  

//assign          rden_valid = (count== 2'd0 && datahead_counter == 5'd19 && current_state ==STATE_CTRL) || (count== 2'd0 && datalength_counter < 10'd1023 && current_state ==STATE_DATA) ;
assign          rden_valid = (count== 2'd1 && (framehead_counter==5'd13) && current_state ==STATE_HEAD) || (count== 2'd1 && datalength_counter < LENGTH && current_state ==STATE_DATA) ;    //edit by lch      LENGTH-> im_frame_data_length
always @ (posedge i_sclk50 or negedge i_rst_n)
    begin
        if (~i_rst_n)
            ram_rden     <= 1'b0 ;
        else 
            ram_rden     <= rden_valid ;
    end  
    
assign          o_ram_rden   = ram_rden  ;
assign          o_ram_rden   = ram_rden  ;
/////////////////////////////////////////////////    
wire            rdaddr_valid;
//assign          rdaddr_valid = ((count== 2'd3) && (datahead_counter == 5'd19) && (current_state ==STATE_CTRL)) || ((count== 2'd3) && (datalength_counter < 10'd1023) && (current_state ==STATE_DATA)) ;    
assign          rdaddr_valid = (count== 2'd3 && (framehead_counter==5'd13) && current_state ==STATE_HEAD) || ((count== 2'd3) && (datalength_counter < LENGTH) && (current_state ==STATE_DATA)) ; //edit by lch   LENGTH->im_frame_data_length
     
reg [10:0]       ram_raddr;  

always @ (posedge i_sclk50 or negedge i_rst_n)
    begin
        if (~i_rst_n)
            ram_raddr    <= 11'd0 ;
        else if(rdaddr_valid)
            ram_raddr    <= ram_raddr + 1'b1 ;
        else if((current_state == STATE_SFD) || (current_state == STATE_SWITCHNEXT) || (current_state == STATE_IDLE))
            ram_raddr    <= 11'd0 ;
    end 
assign          om_ram_raddr   = ram_raddr[7:0]  ;    

/////////////////////////////////////////////////////////////////////////////
  
endmodule         