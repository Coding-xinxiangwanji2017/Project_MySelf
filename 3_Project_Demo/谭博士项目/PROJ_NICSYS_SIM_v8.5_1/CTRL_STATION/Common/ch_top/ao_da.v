`define CMD_NUM 3
////////////////////////////////////
module         AO_DA(
                  clk       ,
                  rst_n     ,
                  i_parwren , 
                  im_paraddr,
                  im_pardata,
                  
                  i_rdren   ,   
                  im_rdaddr , 
                  om_rddata ,


                  fault     ,                  
                  

                  AO_data   ,                
                  spi_clk   ,
                  spi_miso  ,
                  spi_mosi  ,
                  spi_cs   
								);


input        clk  ;
input        rst_n;
//input  [7:0] data_in;
////////
reg [15:0]  config1;
reg [23:0]  k      ;
reg [23:0]  b      ;

reg [15:0]  ctrl_data     ;
output reg[15:0] AO_data  ;
reg [15:0]   temp_ao_data ;
////////////////////////////
input  [11:0]    im_paraddr;
input            i_parwren ;
input  [7:0]     im_pardata;
input  [11:0]    im_rdaddr ; 
output reg[7:0]  om_rddata ;
input            i_rdren   ; 
 
input            fault     ;
////////////////////
parameter SPI_SPEED = 128     ;//??8?b????????
parameter INITIAL   = 4'b0001 ;
parameter PROCESS   = 4'b0010 ;
parameter DIAG      = 4'b0100 ;
parameter step1     = 4'd1    ;
parameter step2     = 4'd2    ;
parameter step3     = 4'd3    ;
parameter step4     = 4'd4    ;
parameter step5     = 4'd5    ;
parameter step6     = 4'd6    ;
parameter step7     = 4'd7    ;
parameter step8     = 4'd8    ;
parameter step9     = 4'd9    ;
parameter step10    = 4'd10   ;
parameter step11    = 4'd11   ;
parameter step12    = 4'd12   ;
parameter step13    = 4'd13   ;
parameter step14    = 4'd14   ;
parameter step15    = 4'd15   ;
parameter PACK_GAP  = 32'd5000;
parameter AO_MIN    = 8'h00   ;
parameter AO_MAX    = 8'h01   ;
parameter AO_KEEP   = 8'h02   ;
parameter AO_SET    = 8'h03   ;
parameter CH_ADD    = 12'd0 ;
parameter CH_I      =  8'd0 ;
parameter CH_V      =  8'd2 ;
parameter CH_EN     = 8'h01;
////////////////////////


reg    [7:0]     safe_type ;
reg    [15:0]    safe_value;
reg    [7:0]     out_range ;
reg    [7:0]     ch_type   ;
reg    [1:0]     temp_fault;
reg  [7:0]       ch_en     ;       
always @ (posedge clk or negedge rst_n)
begin
	   if(!rst_n)
	   	  temp_fault        <= 0;
	   else 
	   	  temp_fault        <= {temp_fault[0],fault};
end
always @ (posedge clk or negedge rst_n)
begin
	   if(!rst_n)
	   	  temp_ao_data        <= 0;
	   else if(temp_fault == 2'b01)
	   	  temp_ao_data        <= ctrl_data;
end
always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        om_rddata <= 'd0;
    else if(i_rdren)
      begin
        case(im_rdaddr)
                CH_ADD          :om_rddata<=  ch_en                ;//CH_EN
                CH_ADD + 01     :om_rddata <= 8'hzz                ;   
                CH_ADD + 02     :om_rddata <= 8'hzz                ;//MODE                     
                CH_ADD + 03     :om_rddata <= 8'hzz                ;
                CH_ADD + 04     :om_rddata <= 8'hzz                ;
                CH_ADD + 05     :om_rddata<=   ch_type             ;//CH-V-I     
                CH_ADD + 06     :om_rddata <= 8'hzz  ;         
                CH_ADD + 07     :om_rddata<=   safe_type           ;    //safe_type                       
                CH_ADD + 08     :om_rddata<=   safe_value[7:0]     ; //safe_value
                CH_ADD + 09     :om_rddata<=   safe_value[15:8]    ; //safe_value
                CH_ADD + 10     :om_rddata <= 8'hzz                ;//
                CH_ADD + 11     :om_rddata <= 8'hzz                ;
                CH_ADD + 12     :om_rddata<=   out_range           ;//out of rangge
                CH_ADD + 13     :om_rddata <= 8'hzz                ;
                CH_ADD + 14     :om_rddata <= 8'hzz                ; 
                CH_ADD + 15     :om_rddata <= 8'hzz                ;
                CH_ADD/16+2048  :om_rddata<=   k[7:0]              ;
                CH_ADD/16+2048+1:om_rddata<=   k[15:8]             ;
                CH_ADD/16+2048+2:om_rddata<=   k[23:16]            ;
                CH_ADD/16+2048+3:om_rddata <= 8'hzz                ; 
                CH_ADD/16+2048+4:om_rddata<=   b[7:0]              ;
                CH_ADD/16+2048+5:om_rddata<=   b[15:8]             ;
                CH_ADD/16+2048+6:om_rddata<=   b[23:16]            ;
                CH_ADD/16+2048+7:om_rddata <= 8'hzz                ; 
                CH_ADD/32+2176  :om_rddata<=   ctrl_data[7:0]      ;
                CH_ADD/32+2176+1:om_rddata<=   ctrl_data[15:8]     ;
           default:om_rddata <= 8'hzz;
        endcase
    end
end

always @ (posedge clk or negedge rst_n)
begin
	   if(!rst_n)
	   	  AO_data        <= 0;
	   else begin
	   	if(temp_fault[1])
	   	  begin
	   	  	case(safe_type)
	   	  		AO_MIN   :AO_data <= 'd0;
                AO_MAX   :AO_data <= 'hFFFF;
                AO_KEEP  :AO_data <= temp_ao_data;
                AO_SET   :AO_data <= safe_value;
	   	  		default  :AO_data <= AO_data;
	   	  	endcase
	   	end
	   	else
	   	  AO_data       <= ctrl_data;
	  end
end
always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        begin
            k              <= 'd0;
            b              <= 'd0; 
            ch_type        <= 'd0;
            safe_type      <= 'd0;
            safe_value     <= 'd0;
            out_range      <= 'd0;
            ctrl_data      <= 'd0;
            ch_en          <= 'd0;
        end
    else if(i_parwren)
        begin
            case(im_paraddr)
                CH_ADD          :ch_en           <= im_pardata ;//CH_EN
                CH_ADD + 01     :;   
                CH_ADD + 02     :                               ;//MODE                     
                CH_ADD + 03     :;
                CH_ADD + 04     :;
                CH_ADD + 05     :ch_type          <= im_pardata ;//CH-V-I       
                CH_ADD + 06     :;        
                CH_ADD + 07     :safe_type        <= im_pardata                 ;    //safe_type                       
                CH_ADD + 08     :safe_value[7:0]  <= im_pardata; //safe_value
                CH_ADD + 09     :safe_value[15:8] <= im_pardata; //safe_value
                CH_ADD + 10     :;//
                CH_ADD + 11     :;
                CH_ADD + 12     :out_range        <= im_pardata;//out of rangge
                CH_ADD + 13     :;
                CH_ADD + 14     :; 
                CH_ADD + 15     :;
                CH_ADD/16+2048  :k[7:0]           <= im_pardata ;
                CH_ADD/16+2048+1:k[15:8]          <= im_pardata ;
                CH_ADD/16+2048+2:k[23:16]         <= im_pardata ;
                CH_ADD/16+2048+3:;
                CH_ADD/16+2048+4:b[7:0]           <= im_pardata ;
                CH_ADD/16+2048+5:b[15:8]          <= im_pardata ;
                CH_ADD/16+2048+6:b[23:16]         <= im_pardata ;
                CH_ADD/16+2048+7:;
                CH_ADD/32+2176  :ctrl_data[7:0]   <= im_pardata ;
                CH_ADD/32+2176+1:ctrl_data[15:8]  <= im_pardata ;
            default:;
            endcase
        end
end

always @ ( * )
case (ch_type)
      CH_I :
         begin
             config1 = (out_range == 'h00)?24'h557007:24'h557007;
         end
      CH_V :  
         begin          
             config1 = (out_range == 'h01)?24'h557001:24'h557001; 
         end              
     default:
        begin          
            config1 = 0; 
        end              
endcase



/////////////////////////////////
reg                        in_rdy  ;//flah??????
reg                        out_rdy ;//flash???byte??
///////////////////////////////////
output                    spi_clk  ;
input                     spi_miso ;
output                    spi_mosi ;
output  reg                  spi_cs   ;
/////////


reg                       spi_clk  ;
reg                       spi_mosi ;

///////////////////////
wire  [39:0]              temp2;
reg   [39:0]              temp1;
assign temp2= b[23]?(AO_data*k - {2'd0,b[22:0],15'd0}):(AO_data*k + {2'd0,b[22:0],15'd0});
always @ ( * )begin
  if(b[23]&(AO_data*k < {2'd0,b[22:0],15'd0}))
   temp1 <= 48'd0;
  else if((AO_data*k + {2'd0,b[22:0],15'd0})>{1'd0,16'hFFFF,23'd0})
   temp1 <= {1'd0,16'hFFFF,23'd0};
  else
   temp1 <= temp2;
end
////////////////////
reg   [7:0]               data_out ;
reg   [23:0]              AO_data_temp;

reg [3:0]              main_state;
reg [3:0]              branch_state;
///////////////////////////////////////
reg [7:0]              spi_freq;///0??
reg [7:0]              spi_data;
///////////////////////////////////////////////////    
reg                    frame_start    ; 
reg                    frame_busy     ;
reg [3:0]              frame_Bynum    ;///0?1?
reg [3:0]              send_cmdnum    ;///0?1?
reg [3:0]              recv_datnum    ;///0?0?
reg [3:0]              frame_Bynum_cnt;
reg [3:0]              frame_state    ;
reg                    operate_finish ;
/////////////////////////////////////
reg [7:0]              sen_cmd[(`CMD_NUM):0];
///////////////////////////////////////
reg [23:0]              cnt       ;
reg                     load_timer;

reg [31:0]              delay_cnt ;  


wire                    timer_out ;

      
always @ (posedge clk or negedge rst_n)
begin
	   if(!rst_n) begin
	   	  cnt        <= 'd0;
	   end
	   else begin
	   	  if(!load_timer)begin
	   	     cnt        <= 'd0;
	   	  end
	   	  else begin
	   	  if(cnt < delay_cnt)
	   	     cnt        <= cnt + 'd1;
	   	   end
	   end
end
assign  timer_out = (cnt == delay_cnt)& load_timer;  

//assign timer_out = load_timer? ((cnt >= delay_cnt)? 1:0):0;
////////////////////
always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
          main_state    <= INITIAL;
          branch_state  <= step1  ;
          recv_datnum  <= 'd0     ;
    	  send_cmdnum  <= 'd0     ;
    	  frame_Bynum  <= 'd0     ;
    	  frame_start  <= 1'b0    ;
    	  load_timer   <= 1'b0    ;
          delay_cnt    <= 32'd0   ;
    end
    else begin
    	if(ch_en == CH_EN)begin
    	  case(main_state)
    	  	  INITIAL:begin
    	  	          case(branch_state)
    	  	          	step1:begin
    	  	          		      sen_cmd[0]   <= 8'h56;
    	  	          		      sen_cmd[1]   <= 8'h00;
    	  	          		      sen_cmd[2]   <= 8'h01;
    	  	          	      	  recv_datnum  <= 'd0  ;
    	  	          		      send_cmdnum  <= 'd2  ;
    	  	          		      frame_Bynum  <= 'd2  ;
    	  	          		      frame_start  <= 1'b1 ;
    	  	          	      	branch_state <= step2  ;
    	  	          	      	delay_cnt    <= PACK_GAP;
    	  	          	      	load_timer   <= 1'b0;
    	  	          end
    	  	          	step2:begin
    	  	          		    frame_start  <= 1'b0;
    	  	          		     load_timer   <= 1'b1;
    	  	          	       if(timer_out&(!frame_busy))begin
                                main_state   <= PROCESS;
    	  	          	      	branch_state <= step1;
    	  	          	       end  
    	  	          end
    	  	            
    	  	          default:begin
    	  	          	      main_state    <= INITIAL;
                              branch_state  <= step1  ;
                              recv_datnum  <= 'd0     ;
                              send_cmdnum  <= 'd0     ;
                              frame_Bynum  <= 'd0     ;
                              frame_start  <= 1'b0    ;
                              load_timer   <= 1'b0    ;
                              delay_cnt    <= 32'd0   ;
    	  	                  end
    	  	          endcase
    	  	  end
    	  	  PROCESS:begin
    	  	  	      case(branch_state)
    	  	          	step1:begin
    	  	          		      sen_cmd[0]   <= 8'h55;
    	  	          		      sen_cmd[1]   <= config1[15:8];
    	  	          		      sen_cmd[2]   <= config1[7:0];
    	  	          	      	  recv_datnum  <= 'd0;
    	  	          		      send_cmdnum  <= 'd2;
    	  	          		      frame_Bynum  <= 'd2;
    	  	          		      frame_start  <= 1'b1;
    	  	          	      	branch_state <= step2;
    	  	          	      	delay_cnt    <= PACK_GAP;
    	  	          	      	load_timer   <= 1'b0;
    	  	          end
    	  	          	step2:begin
    	  	          		     frame_start  <= 1'b0;
    	  	          		     load_timer   <= 1'b1;
                                 branch_state <= step2;
    	  	          	       if(timer_out&(!frame_busy))begin
    	  	          	       	load_timer   <= 1'b0;
                                AO_data_temp <=temp1[38:23];
    	  	          	      	branch_state <= step3;
    	  	          	      	delay_cnt    <= PACK_GAP;
    	  	          	      end   
    	  	          end
    	  	           step3:begin
    	  	          		    frame_start  <= 1'b0;
    	  	          		     load_timer   <= 1'b1;
                                 branch_state <= step3;
    	  	          	       if(timer_out&(!frame_busy))begin
                                 sen_cmd[0]   <= 8'h01;
    	  	          		      sen_cmd[1]   <= AO_data_temp[15:8];
    	  	          		      sen_cmd[2]   <= AO_data_temp[7:0];
    	  	          	      	recv_datnum  <= 'd0;
    	  	          		      send_cmdnum  <= 'd2;
    	  	          		      frame_Bynum  <= 'd2;
    	  	          		      frame_start  <= 1'b1;
    	  	          	      	branch_state <= step4;
    	  	          	      	delay_cnt    <= PACK_GAP;
    	  	          	      	load_timer   <= 1'b0;
    	  	          	      end   
    	  	          end 
    	  	             step4:begin
    	  	          		    frame_start  <= 1'b0;
    	  	          		    load_timer   <= 1'b1;
                                branch_state <= step4;
    	  	          	       if(timer_out&(!frame_busy))begin
    	  	          	      	branch_state <= step1;
    	  	          	      	delay_cnt    <= PACK_GAP;
    	  	          	      	load_timer   <= 1'b0;
    	  	          	      end   
    	  	          end 
    	  	          default:
    	  	                begin                    
                              main_state    <= INITIAL;
                              branch_state  <= step1  ;
                              recv_datnum  <= 'd0     ;
                              send_cmdnum  <= 'd0     ;
                              frame_Bynum  <= 'd0     ;
                              frame_start  <= 1'b0    ;
                              load_timer   <= 1'b0    ;
                              delay_cnt    <= 32'd0   ;
                            end                      
    	  	          endcase
    	  	 end
    	  default:begin                     
                  main_state    <= INITIAL;  
                  branch_state  <= step1  ;  
                  recv_datnum  <= 'd0     ;  
                  send_cmdnum  <= 'd0     ;  
                  frame_Bynum  <= 'd0     ;  
                  frame_start  <= 1'b0    ;  
                  load_timer   <= 1'b0    ;  
                  delay_cnt    <= 32'd0   ;                         
    	  end
    	endcase
       end
     else begin
     	         main_state    <= INITIAL;  
                  branch_state  <= step1  ;  
                  recv_datnum  <= 'd0     ;  
                  send_cmdnum  <= 'd0     ;  
                  frame_Bynum  <= 'd0     ;  
                  frame_start  <= 1'b0    ;  
                  load_timer   <= 1'b0    ;  
                  delay_cnt    <= 32'd0   ;  
    end
    end
end


always @ (posedge clk or negedge rst_n)
begin
	if(!rst_n)begin
	   spi_freq       <= 8'h0;
	   frame_state    <= 4'b0001;
	   frame_Bynum_cnt<= 'd0;
	   spi_cs         <= 1'b1;
	   frame_busy     <= 1'b0;
	   spi_data       <= 8'hFF;
	   operate_finish <= 1'b0;
	end
	else 
	begin
	   case(frame_state)
	   	4'b0001:begin
	   		          if(frame_start)
	   		              begin
	   		              spi_freq       <= 8'h1      ;
	   		              frame_state    <= 4'b0010   ;
	   		              frame_Bynum_cnt<= 32'd0     ;
	   		              spi_cs         <= 1'b0      ;
	   		              frame_busy     <= 1'b1      ;
	   		              spi_data       <= sen_cmd[0];
	   		              operate_finish <= 1'b0      ;
	   		              end
	   		          else begin
	   		              spi_cs         <= 1'b1       ;
	   		              frame_busy     <= 1'b0       ;
	   		              spi_data       <= sen_cmd[0] ;
	   		              operate_finish <= 1'b0       ;
	   		          end
	   		      end
	    4'b0010:begin	   		      
	   		      if(spi_freq == SPI_SPEED) begin
                     spi_freq <= 8'h1;  
                     frame_state    <= 4'b0010   ;                   
                     if(frame_Bynum_cnt == frame_Bynum) begin
                         frame_state    <= 4'b0001;
                         frame_Bynum_cnt<= 32'd0  ;
                         spi_cs         <= 1'b1   ;
                         frame_busy     <= 1'b0   ;
                         spi_freq       <= 8'h0   ;
                         spi_data       <= sen_cmd[0] ;
                          operate_finish <= 1'b1  ;
                       end
                      else
                      frame_Bynum_cnt<= frame_Bynum_cnt + 32'd1;
              end
              else begin
                 spi_freq <= spi_freq + 8'h1;
                 frame_state    <= 4'b0010   ; 
                 if((send_cmdnum  > frame_Bynum_cnt)&(spi_freq == SPI_SPEED - 1 )&(frame_Bynum_cnt != frame_Bynum))
                          spi_data  <= sen_cmd[frame_Bynum_cnt[3:0]+ 1'd1];
                     else if((spi_freq == SPI_SPEED - 1 )&(frame_Bynum_cnt != frame_Bynum))
                          spi_data  <= 8'hFF;
                     else
                          spi_data  <= spi_data;
	   		      end	 
	   		      end  		   	
	   	default:frame_state<= 4'b0001;
	   endcase
	end
end

always @ (posedge clk or negedge rst_n)
begin
	if(!rst_n)begin
	   spi_mosi <= 1'b1;
	   in_rdy   <= 1'b0;
	  end
	else begin
		if((frame_start)|((spi_freq == 8*SPI_SPEED/8)&(frame_busy == 1'b1)))
		 begin
		 spi_mosi <= ((frame_Bynum_cnt != frame_Bynum)|(frame_start))?(frame_start? sen_cmd[0][7]:spi_data[7]):1'b1;
		 in_rdy   <= 1'b0;
		 end
		else if((spi_freq == 1*SPI_SPEED/8)&(frame_busy == 1'b1))
		 begin
		 spi_mosi <= spi_data[6];
		 in_rdy   <= 1'b0;
		 end
		else if((spi_freq == 2*SPI_SPEED/8)&(frame_busy == 1'b1))
		 begin
		 spi_mosi <= spi_data[5];
		 in_rdy   <= 1'b0;
		 end	
		else if((spi_freq == 3*SPI_SPEED/8)&(frame_busy == 1'b1))
		 begin
		 spi_mosi <= spi_data[4];
		 in_rdy   <= 1'b0;
		 end		
		else if((spi_freq == 4*SPI_SPEED/8)&(frame_busy == 1'b1))
		 begin
		 spi_mosi <= spi_data[3];
		 in_rdy   <= 1'b0;
		 end	
		else if((spi_freq == 5*SPI_SPEED/8)&(frame_busy == 1'b1))
		 begin
		 spi_mosi <= spi_data[2];
		 if((send_cmdnum  <= frame_Bynum_cnt)&(frame_Bynum_cnt!=frame_Bynum))
		 in_rdy   <= 1'b1;
		 end	
		else if((spi_freq == 6*SPI_SPEED/8)&(frame_busy == 1'b1))
		 begin
		 spi_mosi <= spi_data[1];
     in_rdy   <= 1'b0;
		 end	
		else if((spi_freq == 7*SPI_SPEED/8)&(frame_busy == 1'b1))
		 begin
		 spi_mosi <= spi_data[0];
		 in_rdy   <= 1'b0;
		 end	
		//  else if(frame_Bynum_cnt == frame_Bynum)
		//  begin
		//  spi_mosi <= 1'b1;
		//  in_rdy   <= 1'b0;
	    //  end
	    //  else if(frame_busy)
	    //  spi_mosi <= spi_mosi;
		 else if(!frame_busy)
		 begin
		 spi_mosi <= 1'b1;
		 in_rdy   <= 1'b0;
		 end
		end
end
always @ (posedge clk or negedge rst_n)
begin
	if(!rst_n)begin
	   data_out <= 8'hFF;
	   out_rdy     <= 1'b0;
	 end
	else begin
		if(((spi_freq == SPI_SPEED/16)&(frame_busy == 1'b1)))begin
		 data_out[7] <= spi_miso;
		 out_rdy     <= 1'b0;
		end
		else if((spi_freq == 1*SPI_SPEED/8+SPI_SPEED/16)&(frame_busy == 1'b1))begin
     data_out[6] <= spi_miso;
    out_rdy     <= 1'b0;
		end
		else if((spi_freq == 2*SPI_SPEED/8+SPI_SPEED/16)&(frame_busy == 1'b1))begin
     data_out[5] <= spi_miso;
     out_rdy     <= 1'b0;
		end	
		else if((spi_freq == 3*SPI_SPEED/8+SPI_SPEED/16)&(frame_busy == 1'b1))begin
     data_out[4] <= spi_miso;		
     out_rdy     <= 1'b0;
		end
		else if((spi_freq == 4*SPI_SPEED/8+SPI_SPEED/16)&(frame_busy == 1'b1))begin
     data_out[3] <= spi_miso;	
     out_rdy     <= 1'b0;
		end	
		else if((spi_freq == 5*SPI_SPEED/8+SPI_SPEED/16)&(frame_busy == 1'b1))begin
     data_out[2] <= spi_miso;
     out_rdy     <= 1'b0;
		end		
		else if((spi_freq == 6*SPI_SPEED/8+SPI_SPEED/16)&(frame_busy == 1'b1))begin
     data_out[1] <= spi_miso;
     out_rdy     <= 1'b0;
		end		
		else if((spi_freq == 7*SPI_SPEED/8+SPI_SPEED/16)&(frame_busy == 1'b1))begin
     data_out[0] <= spi_miso;
     if(frame_Bynum+1-recv_datnum <= frame_Bynum_cnt)	
     out_rdy     <= 1'b1;
		end	
		else if(!frame_busy) begin
		 data_out    <= 8'hFF;
		 out_rdy     <= 1'b0;
		end
		else begin
		 data_out    <= data_out;
		 out_rdy     <= 1'b0;
		end
  end
end

always @ (posedge clk or negedge rst_n)
begin
	if(!rst_n)
	   spi_clk <= 1'b1;
	else begin
		if(frame_start)
		 spi_clk <= 1'b0;
		else if((spi_freq == 8*SPI_SPEED/8)&(frame_busy == 1'b1))
		 spi_clk <= (frame_Bynum_cnt == frame_Bynum)? 1'b1:1'b0;
		else if((spi_freq == SPI_SPEED/16)&(frame_busy == 1'b1))
		 spi_clk <= 1'b1;
		else if((spi_freq == 1*SPI_SPEED/8)&(frame_busy == 1'b1))
		 spi_clk <= 1'b0;
		else if((spi_freq == 1*SPI_SPEED/8+SPI_SPEED/16)&(frame_busy == 1'b1))
		spi_clk <= 1'b1;
		else if((spi_freq == 2*SPI_SPEED/8)&(frame_busy == 1'b1))
		 spi_clk <= 1'b0;
		else if((spi_freq == 2*SPI_SPEED/8+SPI_SPEED/16)&(frame_busy == 1'b1))
		spi_clk <= 1'b1;
		else if((spi_freq == 3*SPI_SPEED/8)&(frame_busy == 1'b1))
		 spi_clk <= 1'b0;
		else if((spi_freq == 3*SPI_SPEED/8+SPI_SPEED/16)&(frame_busy == 1'b1))
		spi_clk <= 1'b1;
		else if((spi_freq == 4*SPI_SPEED/8)&(frame_busy == 1'b1))
		 spi_clk <= 1'b0;
		else if((spi_freq == 4*SPI_SPEED/8+SPI_SPEED/16)&(frame_busy == 1'b1))
		spi_clk <= 1'b1;
		else if((spi_freq == 5*SPI_SPEED/8)&(frame_busy == 1'b1))
		 spi_clk <= 1'b0;
		else if((spi_freq == 5*SPI_SPEED/8+SPI_SPEED/16)&(frame_busy == 1'b1))	
		spi_clk <= 1'b1;
		else if((spi_freq == 6*SPI_SPEED/8)&(frame_busy == 1'b1))	
		 spi_clk <= 1'b0;
		else if((spi_freq == 6*SPI_SPEED/8+SPI_SPEED/16)&(frame_busy == 1'b1))
		spi_clk <= 1'b1;
		else if((spi_freq == 7*SPI_SPEED/8)&(frame_busy == 1'b1))
		 spi_clk <= 1'b0;
		else if((spi_freq == 7*SPI_SPEED/8+SPI_SPEED/16)&(frame_busy == 1'b1))
		spi_clk <= 1'b1;
		else
		spi_clk <= spi_clk;
  end
end


endmodule                 