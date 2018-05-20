`define CMD_NUM 3
////////////////////////////////////
module         AO_AD(
                  clk       ,
                  rst_n     ,
                  i_parwren , 
                  im_paraddr,
                  im_pardata,
                  i_rdren   ,   
                  im_rdaddr , 
                  om_rddata , 


                  spi_clk   ,
                  spi_miso  ,
                  spi_mosi  ,

				  spi_cs_low,	
                  led_ctrl  ,
                  ao_data   
	
        		);



////////
input            clk       ;
input            rst_n     ;
input  [15:0]    ao_data   ;   
output           spi_cs_low;
input  [11:0]    im_paraddr;
input            i_parwren ;
input  [7:0]     im_pardata;
input  [11:0]    im_rdaddr ; 
output [7:0]     om_rddata ;
input            i_rdren   ; 
output [1:0]     led_ctrl  ;

reg  [7:0]       ch_en     ;
reg [15:0]       config1   ;


reg [23:0]  k      ;
reg [23:0]  b      ;
reg [4:0]   diag_5times;
//////////////////////
////////////////////
parameter SPI_SPEED = 128;//??8?b????????
parameter INITIAL   = 4'b0001;
parameter PROCESS   = 4'b0010;
parameter DIAG      = 4'b0100;
parameter step1     = 4'd1;
parameter step2     = 4'd2;
parameter step3     = 4'd3;
parameter step4     = 4'd4;
parameter step5     = 4'd5;
parameter step6     = 4'd6;
parameter step7     = 4'd7 ;
parameter step8     = 4'd8 ;
parameter step9     = 4'd9 ;
parameter step10    = 4'd10;
parameter step11    = 4'd11;
parameter step12    = 4'd12;
parameter step13    = 4'd13;
parameter step14    = 4'd14;
parameter step15    = 4'd15;
parameter PACK_GAP  = 32'd5000;
parameter DIAG_EN   = 8'h01;
parameter SAMPLE_TIMES = 10;
parameter UP_LOW    = 1'b1;
parameter CH_ADD    = 12'd0;
parameter CH_I      =  8'd0 ;
parameter CH_V      =  8'd1 ;
parameter CH_EN     = 8'h01;
parameter    LED_ON      = 2'b00        ;
parameter    LED_OFF     = 2'b01        ;
parameter    LED_BLINK   = 2'b10        ;
////////////////////////
reg   [7:0]   diag_cycle    ;
reg   [7:0]   diag_en       ;
reg   [7:0]   diag_threshold;

wire          diag_result    ;
wire   [31:0]diag_cycle_temp ;

reg   [15:0]  max         ;
reg   [15:0]  min         ;
reg   [3:0]   sample_times;
reg   [19:0]  sum         ;
reg   [15:0]  up          ;
reg   [15:0]  low         ;
reg    [7:0]  om_rddata   ;
reg    [7:0]  ch_type     ;  
always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        om_rddata <= 'd0;
    else if(i_rdren)
      begin
        case(im_rdaddr)
           CH_ADD          :om_rddata <= 8'hzz         ; //CH_EN
           CH_ADD + 01     :om_rddata<= diag_en        ;   
           CH_ADD + 02     :om_rddata <= 8'hzz         ;//MODE                     
           CH_ADD + 03     :om_rddata<= diag_cycle     ;
           CH_ADD + 04     :om_rddata <= 8'hzz         ;
           CH_ADD + 05     :om_rddata<= ch_type        ;//CH-V-I  
           CH_ADD + 06     :om_rddata <= 8'hzz         ;                   
           CH_ADD + 07     :om_rddata <= 8'hzz         ;//safe_type                       
           CH_ADD + 08     :om_rddata <= 8'hzz         ; //safe_calue
           CH_ADD + 09     :om_rddata <= 8'hzz         ; //safe_calue
           CH_ADD + 10     :om_rddata<= diag_threshold ;//
           CH_ADD + 11     :om_rddata <= 8'hzz         ;
           CH_ADD + 12     :om_rddata <= 8'hzz         ;//out of rangge
           CH_ADD + 13     :om_rddata <= 8'hzz         ;
           CH_ADD + 14     :om_rddata <= 8'hzz         ; 
           CH_ADD + 15     :om_rddata <= 8'hzz         ;
           CH_ADD/16+2112  :om_rddata<= k[7:0]         ;
           CH_ADD/16+2112+1:om_rddata<= k[15:8]        ;
           CH_ADD/16+2112+2:om_rddata<= k[23:16]       ;
           CH_ADD/16+2112+3:om_rddata <= 8'hzz         ;
           CH_ADD/16+2112+4:om_rddata<= b[7:0]         ;
           CH_ADD/16+2112+5:om_rddata<= b[15:8]        ;
           CH_ADD/16+2112+6:om_rddata<= b[23:16]       ;
           CH_ADD/32+2240   : om_rddata <= ao_data[7:0];
           CH_ADD/32+2240 +1: om_rddata <= ao_data[15:8];
           CH_ADD/32+2240 +2: om_rddata <= {7'd0,diag_result};
           CH_ADD/32+2240 +3: om_rddata <= 'd0;
           default:om_rddata <= 8'hzz;
        endcase
    end
end


always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        begin
            k              <= 'd0;
            b              <= 'd0; 
            diag_en        <= 'd0; 
            diag_cycle     <= 'd0;
            diag_threshold <= 'd0;//Õï¶ÏãÐÖµ 
            ch_type        <= 'd0;
            ch_en          <= 'd0;
        end
    else if(i_parwren)
        begin
            case(im_paraddr)
                CH_ADD          :ch_en            <= im_pardata;//CH_EN
                CH_ADD + 01     :diag_en          <= im_pardata ;   
                CH_ADD + 02     :                               ;//MODE                     
                CH_ADD + 03     :diag_cycle       <= im_pardata ;
                CH_ADD + 04     :                               ;
                CH_ADD + 05     :ch_type          <= im_pardata ;//CH-V-I  
                CH_ADD + 06     :    ;               
                CH_ADD + 07     :                               ;    //safe_type                       
                CH_ADD + 08     :; //safe_calue
                CH_ADD + 09     :; //safe_calue
                CH_ADD + 10     :diag_threshold   <= im_pardata ;//
                CH_ADD + 11     :;
                CH_ADD + 12     :;//out of rangge
                CH_ADD + 13     :;
                CH_ADD + 14     :; 
                CH_ADD + 15     :;
                CH_ADD/16+2112  :k[7:0]           <= im_pardata ;
                CH_ADD/16+2112+1:k[15:8]          <= im_pardata ;
                CH_ADD/16+2112+2:k[23:16]         <= im_pardata ;
                CH_ADD/16+2112+3:;
                CH_ADD/16+2112+4:b[7:0]           <= im_pardata ;
                CH_ADD/16+2112+5:b[15:8]          <= im_pardata ;
                CH_ADD/16+2112+6:b[23:16]         <= im_pardata ;
                CH_ADD/16+2112+7:;
            default:;
            endcase
        end
end

always @ ( * )
case (ch_type)
      CH_I :
             config1 = 24'h100090;
      CH_V :          
            config1 = 24'h100091;             
     default:       
            config1 = 0;  
endcase

/////////////////////////////////2016.3.12
assign led_ctrl = (ch_en==CH_EN)?(diag_result?LED_BLINK:LED_ON):LED_OFF;
 //////////////////////////////   
//output[23:0]  sample_data;
assign diag_result     = &diag_5times     ;
assign diag_cycle_temp = diag_cycle*500000;

/////////////////////////////////
//output                    in_rdy   ;//flah??????
//output                    out_rdy  ;//flash???byte??
reg   [23:0]              sample_data_temp;
/////////////
wire  [39:0]              temp2;
reg   [39:0]              temp1;
assign temp2= b[23]?(sample_data_temp*k - {2'd0,b[22:0],15'd0}):(sample_data_temp*k + {2'd0,b[22:0],15'd0});
always @ ( * )begin
  if(b[23]&(sample_data_temp*k < {2'd0,b[22:0],15'd0}))
   temp1 = 48'd0;
  else if((sample_data_temp*k + {2'd0,b[22:0],15'd0})>{1'd0,16'hFFFF,23'd0})
   temp1 = {1'd0,16'hFFFF,23'd0};
  else
   temp1 = temp2;
end
assign  spi_cs_low = 1'b0;
///////////////////////////////////
output                    spi_clk  ;
input                     spi_miso ;
output                    spi_mosi ;
//output                  spi_cs   ;
/////////

reg                       in_rdy   ;
reg                       out_rdy  ;
reg                       spi_clk  ;
reg                       spi_mosi ;
reg                       spi_cs   ;
//reg [23:0]diag_data;
//reg [23:0]sample_data;
///////////////////////

reg   [7:0]               data_out ;


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
always @ ( * )begin
case(diag_threshold)
      8'd0:begin            //5%
                 up  =  16'd32768 + {2'd0,ao_data[15:2]} + {3'd0,ao_data[15:3]} +{4'd0,ao_data[15:4]} +{5'd0,ao_data[15:5]} +
                                    {6'd0,ao_data[15:6]} + {7'd0,ao_data[15:7]} +{8'd0,ao_data[15:8]} +{10'd0,ao_data[15:10]} +
                                    {11'd0,ao_data[15:11]} + {12'd0,ao_data[15:12]} +{13'd0,ao_data[15:13]} +{15'd0,ao_data[15]};
                 low =  16'd32768 + {2'd0,ao_data[15:2]} + {3'd0,ao_data[15:3]} +{4'd0,ao_data[15:4]} +{7'd0,ao_data[15:7]} +
                                    {8'd0,ao_data[15:8]} + {10'd0,ao_data[15:10]} +{12'd0,ao_data[15:12]} +{14'd0,ao_data[15:14]} +
                                    {15'd0,ao_data[15]};
           end
default:begin
          up  = 16'hFFFF;
          low = 16'h0000;
        end
endcase
end
///////////////////////////////////////
reg [23:0]              cnt;
reg                     load_timer;
reg [31:0]              delay_cnt; 
reg                     a1;
reg                     spi_miso1;
wire                    timer_out;

always @ (posedge clk)
begin
    a1 <= spi_miso;
    spi_miso1 <= a1;
end         
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
assign  timer_out = (cnt == delay_cnt) & load_timer;  

//assign timer_out = load_timer? ((cnt >= delay_cnt)? 1:0):0;
////////////////////
always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
          main_state         <= INITIAL;
          branch_state       <= step1;
          recv_datnum        <= 'd0;
    	  send_cmdnum      <= 'd0;
    	  frame_Bynum      <= 0;
    	  frame_start      <= 1'b0;
    	  load_timer       <= 1'b0;
          sample_data_temp <=0;
          delay_cnt        <= 'd0;
          max              <= 0;
          min              <= 16'hFFFF;
          sample_times     <= 0;
          sum              <= 0;
          diag_5times      <= 0;
    end
    else begin
    	if(ch_en == CH_EN)begin
    	  case(main_state)
    	  	  INITIAL:begin
    	  	          case(branch_state)
    	  	          	step1:begin
    	  	          		      sen_cmd[0]   <= 8'hFF;
    	  	          		      sen_cmd[1]   <= 8'hFF;
    	  	          		      sen_cmd[2]   <= 8'hFF;
    	  	          		      sen_cmd[3]   <= 8'hFF;
    	  	          	      	recv_datnum    <= 'd0;
    	  	          		      send_cmdnum  <= 'd3;
    	  	          		      frame_Bynum  <= 'd3;
    	  	          		      frame_start  <= 1'b1;
    	  	          	      	branch_state   <= step2;
    	  	          	      	delay_cnt      <= PACK_GAP;
    	  	          	      	load_timer     <= 1'b0;
    	  	          end
    	  	          	step2:begin
    	  	          		    frame_start  <= 1'b0;
    	  	          		     load_timer   <= 1'b1;
    	  	          	       if(timer_out&(!frame_busy)&(diag_en == DIAG_EN))begin
                                main_state   <= PROCESS;
    	  	          	      	branch_state <= step1;
                                max          <= 0;
                                min          <= 16'hFFFF;
                                sample_times <= 0;
                                sum          <= 0;
    	  	          	       end
    	  	          end
    	  	            
    	  	          default:begin
    	  	          	 main_state         <= INITIAL;
                         branch_state       <= step1;
                         recv_datnum        <= 'd0;
    	                 send_cmdnum      <= 'd0;
    	                 frame_Bynum      <= 0;
    	                 frame_start      <= 1'b0;
    	                 load_timer       <= 1'b0;
                         sample_data_temp <=0;
                         delay_cnt        <= 'd0;
                         max              <= 0;
                         min              <= 16'hFFFF;
                         sample_times     <= 0;
                         sum              <= 0;
                         diag_5times      <= 0;
    	  	          end
    	  	          endcase
    	  	  end
    	  	  PROCESS:begin
    	  	  	      case(branch_state)
    	  	          	step1:begin
    	  	          		      sen_cmd[0]   <= 8'h10;
    	  	          		      sen_cmd[1]   <= config1[15:8];
    	  	          		      sen_cmd[2]   <= config1[7:0];
    	  	          	      	  recv_datnum  <='d0;
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
                                   sen_cmd[0]   <= 8'h08;
    	  	          		       sen_cmd[1]   <= 8'h00;
    	  	          		       sen_cmd[2]   <= 8'h01;
    	  	          	      	   recv_datnum  <= 'd0;
    	  	          		      send_cmdnum   <= 'd2;
    	  	          		      frame_Bynum   <= 'd2;
    	  	          		      frame_start   <= 1'b1;
    	  	          	      	  branch_state  <= step3;
    	  	          	      	  delay_cnt     <= PACK_GAP;
    	  	          	      end   
    	  	          end
    	  	           
    	  	          step3:begin
    	  	          		     frame_start  <= 1'b0;
    	  	          		     load_timer   <= 1'b1;
                                 branch_state <= step3;
    	  	          	       if(timer_out&(!frame_busy)&(!spi_miso1))begin
                                sen_cmd[0]   <= 8'h58;
    	  	          		    sen_cmd[1]   <= 8'hFF;
    	  	          		    sen_cmd[2]   <= 8'hFF;
    	  	          		      // sen_cmd[3]   <= 8'hFF;
    	  	          	      	recv_datnum  <= 'd2;
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
                                   branch_state <= step4;
                                   load_timer   <= 1'b0;
    	  	          		     if(frame_busy)begin
    	  	          		     //	  if((out_rdy)&(frame_Bynum_cnt == send_cmdnum-2))
    	  	          		     //    sample_data_temp[23:16]<= data_out;
    	  	          		        if((out_rdy)&(frame_Bynum_cnt == send_cmdnum-1))
    	  	          		         sample_data_temp[15:8] <= data_out;
    	  	          		        else if((out_rdy)&(frame_Bynum_cnt == send_cmdnum))
    	  	          		         sample_data_temp[7:0]  <= data_out;
    	  	          		    end
    	  	          		    else if(operate_finish == 1'b1)begin
                                        delay_cnt    <= PACK_GAP;
    	  	          	                load_timer   <= 1'b0;
    	  	          		            branch_state   <= step5;
                                        sample_times <= sample_times + 1;
    	  	          		         end 
    	  	          end 
    	  	          step5:begin
                        load_timer   <= 1'b1;
                        if(timer_out)begin
//                         sample_data<=temp1[38:23];
                           sum        <=sum + temp1[38:23];
                           load_timer <= 1'b0;
                           if(max<temp1[38:23])
                            max      <= temp1[38:23];
                           if(min>temp1[38:23])
                            min      <= temp1[38:23];
                           if(sample_times == SAMPLE_TIMES)begin
    	  	          	   branch_state   <= step6; 
                           delay_cnt    <= diag_cycle_temp;
                           end
                           else begin
                            branch_state   <= step1;
                          end
                        end
    	  	          end
                      step6:begin
                        branch_state <= step7;
                        sample_times <= 0;
                        sum          <= (sum - min - max)>>3;
                        end
                      step7:begin
                        branch_state <= step8;
                        diag_5times  <={diag_5times[4:1],(sum[15:0]>up)|(sum[15:0]<low)};
                        //if((sum[15:0]>up)|(sum[15:0]<low))
                        //  diag_result <= UP_LOW;
                        // else
                        //  diag_result <= 'b0;
                      end
                      step8:begin
                           load_timer   <= 1'b1;
    	  	          	if(timer_out)begin
                           sum          <= 0;
                           max          <= 0;
                           min          <= 16'hFFFF;
                         if(diag_en == DIAG_EN)begin
    	  	          	  branch_state   <= step1;
    	  	              load_timer   <= 1'b0;
                          end
                          else
                          diag_5times  <= 0;
                      end
    	  	          end
    	  	          default:branch_state  <= step1;
    	  	          endcase
    	  	 end
    	  default:begin
    	  	          	 main_state         <= INITIAL;
                         branch_state       <= step1;
                         recv_datnum        <= 'd0;
    	                 send_cmdnum      <= 'd0;
    	                 frame_Bynum      <= 0;
    	                 frame_start      <= 1'b0;
    	                 load_timer       <= 1'b0;
                         sample_data_temp <=0;
                         delay_cnt        <= 'd0;
                         max              <= 0;
                         min              <= 16'hFFFF;
                         sample_times     <= 0;
                         sum              <= 0;
                         diag_5times      <= 0;
    	  	          end
    	endcase
        end
       else begin
       	                 main_state         <= INITIAL;
                         branch_state       <= step1;
                         recv_datnum        <= 'd0;
    	                 send_cmdnum      <= 'd0;
    	                 frame_Bynum      <= 0;
    	                 frame_start      <= 1'b0;
    	                 load_timer       <= 1'b0;
                         sample_data_temp <=0;
                         delay_cnt        <= 'd0;
                         max              <= 0;
                         min              <= 16'hFFFF;
                         sample_times     <= 0;
                         sum              <= 0;
                         diag_5times      <= 0;
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
	   		              frame_Bynum_cnt<= 'd0     ;
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
                         frame_Bynum_cnt<= 'd0  ;
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
                          spi_data  <= sen_cmd[frame_Bynum_cnt[3:0]+ 'd1];
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
		 //spi_mosi <= (frame_Bynum_cnt != frame_Bynum)?(frame_start? sen_cmd[0][7]:spi_data[7]):1'b1;
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
		//else if(frame_Bynum_cnt == frame_Bynum)
		// begin
		// spi_mosi <= 1'b1;
		// in_rdy   <= 1'b0;
	//	 end
	//	else if(frame_busy)
	//	 spi_mosi <= spi_mosi;
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