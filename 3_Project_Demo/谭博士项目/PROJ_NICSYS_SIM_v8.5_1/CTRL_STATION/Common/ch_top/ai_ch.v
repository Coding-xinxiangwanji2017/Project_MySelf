`define CMD_NUM  3
////////////////////////////////////
module         ai_ch(
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
                  spi_low   , 
                  led_ctrl  ,
                  test
									);


/////////////////
input            clk       ;
input            rst_n     ;
////////////////////////
input  [11:0]    im_paraddr;
input            i_parwren ;
input  [7:0]     im_pardata;
input  [11:0]    im_rdaddr ; 
output [7:0]     om_rddata ;
input            i_rdren   ; 
output [1:0]     led_ctrl  ;
reg    [7:0]     om_rddata ;                           
reg    [7:0]     ch_type   ;
////////////////////
parameter SPI_SPEED = 128;// 一个字节所需的时间    SPI速率为{ 1/（（128*（1/50M））/8）=3.125M} AD7794SPI最高支持5M
parameter INITIAL   = 4'b0001; 
parameter PROCESS   = 4'b0010;
parameter DIAG      = 4'b0100; 
parameter step1     = 4'd1;
parameter step2     = 4'd2;
parameter step3     = 4'd3;
parameter step4     = 4'd4;
parameter step5     = 4'd5;
parameter step6     = 4'd6;
parameter step7     = 4'd7;
parameter step8     = 4'd8;
parameter step9     = 4'd9;
parameter step10    = 4'd10;
parameter step11    = 4'd11;
parameter step12    = 4'd12;
parameter step13    = 4'd13;
parameter step14    = 4'd14;
parameter step15    = 4'd15;
parameter PACK_GAP  = 24'd5000; //包间隔
parameter DIAG_EN   = 8'h01;
parameter CH_EN     = 8'h01;
parameter SAMPLE_TIMES = 10;
parameter UP_LOW    = 1'b1;   //诊断数据越限标志
////////////////////////////////
parameter NONE      = 8'h00;
parameter AVERAGE   = 8'h01;
parameter IIR       = 8'h02;
parameter FIR       = 8'h03;

parameter CH_ADD    = 12'd0 ;
parameter CH_I      = 8'h0  ; 
parameter CH_V      = 8'h2  ;
parameter precise_data=16'hc000;
parameter    LED_ON      = 2'b00        ;
parameter    LED_OFF     = 2'b01        ;
parameter    LED_BLINK   = 2'b10        ;

//input [7:0]   data_in;
reg [23:0]  config1;
reg [23:0]  config2;
reg [23:0]  config3;
reg [23:0]  k      ;
reg [23:0]  b      ;
reg [15:0]  high_limit;
reg [15:0]  low_limit ; 
//output[23:0]  diag_data;
//output[23:0]  sample_data;
output[7:0]   test           ;
output        spi_low        ;  //一直给低，使能
reg  [7:0]    diag_en        ;  
reg  [7:0]    diag_cycle     ;

reg  [7:0]    diag_threshold; //诊断阈值 
reg  [7:0]    filter_type   ;
reg  [7:0]    filter_factor ;

 reg        diag_result  ;
 reg [15:0] process_data ; //最终16位数据 高16位 
 wire           out_high_flag; //越高限标志位
 wire           out_low_flag ;  //越低限标志位
/////////////////////////////////
//output            in_rdy   ; //flah??????
//output            out_rdy  ; //flash???byte??
///////////////////////////
output            spi_clk  ; 
input             spi_miso ;
output            spi_mosi ;
//output            spi_cs   ;
reg   [23:0]      sample_data_temp;  
reg   [7:0]       ch_en;  
////////////////////////
///////////////////////
assign led_ctrl = (ch_en==CH_EN)?(diag_result?LED_BLINK:LED_ON):LED_OFF;
always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        om_rddata <= 'd0;
    else if(i_rdren)
      begin
        case(im_rdaddr)
           CH_ADD          :om_rddata<=     ch_en            ;//CH_EN
           CH_ADD + 01     :om_rddata<=     diag_en          ;   
           CH_ADD + 02     :om_rddata <=     8'hzz           ;//MODE                     
           CH_ADD + 03     :om_rddata<=     diag_cycle       ;
           CH_ADD + 04     :om_rddata <=     8'hzz           ;
           CH_ADD + 05     :om_rddata<=     ch_type          ;//CH-V-I                   
           CH_ADD + 06     :om_rddata <=    8'hzz            ;                           
           CH_ADD + 07     :om_rddata<=     filter_type      ;
           CH_ADD + 08     :om_rddata<=     filter_factor    ;
           CH_ADD + 09     :om_rddata<=     diag_threshold   ;
           CH_ADD + 10     :om_rddata <=    8'hzz            ;
           CH_ADD + 11     :om_rddata<=     low_limit[7:0]   ;
           CH_ADD + 12     :om_rddata<=     low_limit[15:8]  ;
           CH_ADD + 13     :om_rddata<=     high_limit[7:0]  ; 
           CH_ADD + 14     :om_rddata<=     high_limit[15:8] ;
           CH_ADD/16+2048  :om_rddata<=     k[7:0]           ;
           CH_ADD/16+2048+1:om_rddata<=     k[15:8]          ;
           CH_ADD/16+2048+2:om_rddata<=     k[23:16]         ;
           CH_ADD/16+2048+3:om_rddata <=    8'hzz            ;
           CH_ADD/16+2048+4:om_rddata<=     b[7:0]           ;
           CH_ADD/16+2048+5:om_rddata<=     b[15:8]          ;
           CH_ADD/16+2048+6:om_rddata<=     b[23:16]         ;
           CH_ADD/16+2048+7:om_rddata <=    8'hzz            ;
           CH_ADD/32+2176   : om_rddata <= process_data[7:0] ;
           CH_ADD/32+2176 +1: om_rddata <= process_data[15:8];
           CH_ADD/32+2176 +2: om_rddata <= {4'd0,out_low_flag,out_high_flag,1'b0,diag_result};
           CH_ADD/32+2176 +3: om_rddata <= 'd0;
           default:om_rddata <= 8'hzz;
        endcase
    end
end


always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        begin
        	ch_type        <= 'd0;
            k              <= 'd0;
            b              <= 'd0;
            high_limit     <= 'd0;
            low_limit      <= 'd0; 
            diag_en        <= 'd0; 
            diag_cycle     <= 'd0;
            diag_threshold <= 'd0;//诊断阈值 
            filter_type    <= 'd0;
            filter_factor  <= 'd0;
            ch_en          <= 'd0;
        end
    else if(i_parwren)
        begin
            case(im_paraddr)
                CH_ADD          :ch_en            <= im_pardata ;//CH_EN
                CH_ADD + 01     :diag_en          <= im_pardata ;   
                CH_ADD + 02     :                               ;//MODE                     
                CH_ADD + 03     :diag_cycle       <= im_pardata ;
                CH_ADD + 04     :                               ;
                CH_ADD + 05     :ch_type          <= im_pardata ;//CH-V-I                   
                CH_ADD + 06     :                               ;                           
                CH_ADD + 07     :filter_type      <= im_pardata ;
                CH_ADD + 08     :filter_factor    <= im_pardata ;
                CH_ADD + 09     :diag_threshold   <= im_pardata ;
                CH_ADD + 10     :;
                CH_ADD + 11     :low_limit[7:0]   <= im_pardata ;
                CH_ADD + 12     :low_limit[15:8]  <= im_pardata ;
                CH_ADD + 13     :high_limit[7:0]  <= im_pardata ; 
                CH_ADD + 14     :high_limit[15:8] <= im_pardata ;
                CH_ADD/16+2048  :k[7:0]           <= im_pardata ;
                CH_ADD/16+2048+1:k[15:8]          <= im_pardata ;
                CH_ADD/16+2048+2:k[23:16]         <= im_pardata ;
                CH_ADD/16+2048+3:;
                CH_ADD/16+2048+4:b[7:0]           <= im_pardata ;
                CH_ADD/16+2048+5:b[15:8]          <= im_pardata ;
                CH_ADD/16+2048+6:b[23:16]         <= im_pardata ;
                CH_ADD/16+2048+7:;
            default:;
            endcase
        end
end

always @ ( * )
case (ch_type)
      CH_I :
         begin
             config1 = 24'h100090;
             config2 = 24'h080003;
             config3 = 24'h002810;
         end
      CH_V :  
         begin          
            config1 = 24'h100091; 
            config2 = 24'h080003; 
            config3 = 24'h100092; 
         end              
     default:
        begin          
            config1 = 24'h0; 
            config2 = 24'h0; 
            config3 = 24'h0; 
        end              
endcase





///////////////////////////
wire  [47:0]      temp2;
reg   [47:0]      temp1;
assign temp2= b[23]?(sample_data_temp*k - {10'd0,b[22:0],15'd0}):(sample_data_temp*k + {10'd0,b[22:0],15'd0});
always @ ( * )begin
  if(b[23]&(sample_data_temp*k < {10'd0,b[22:0],15'd0}))
   temp1 = 48'd0;
  else if((sample_data_temp*k + {10'd0,b[22:0],15'd0})>{1'd0,24'hFFFFFF,23'd0}) //
   temp1 = {1'd0,24'hFFFFFF,23'd0};
  else
   temp1 = temp2;
end
assign out_high_flag = (process_data > high_limit); //
assign out_low_flag  = (process_data < low_limit);//
///////////////////////
reg       in_rdy   ;//???????
reg       out_rdy  ;//接收完成信号
reg       spi_clk  ;
reg       spi_mosi ;
reg       spi_cs   ;
reg [23:0]diag_data;
reg [23:0]sample_data;
///////////////////////2016.3.12
reg   [15:0]  max; //均值滤波用最大值
reg   [15:0]  min; //均值滤波用最小值
reg   [3:0]   sample_times;//均值滤波用采样次数
reg   [19:0]  sum; //采样总和
reg   [15:0]  up;  //采集数据越上限
reg   [15:0]  low; //采集数据越下限
reg           sample_finish;
//////////////////////
reg   [7:0]   data_out ; // 输出数据


reg [3:0]              main_state;
reg [3:0]              branch_state;
///////////////////////////////////////
reg [7:0]              spi_freq;//0??
reg [7:0]              spi_data;
///////////////////////////////////////////////////    
reg                    frame_start    ; //SPI发包的起始信号
reg                    frame_busy     ; 
reg [3:0]              frame_Bynum    ; ///发送的字节数，至少为1个 【0】
reg [3:0]              send_cmdnum    ; ///每包发送的命令数
reg [3:0]              recv_datnum    ; ///接收的字节数的个数（spi为全双工，recv_datnum为接收几个字节数的个数）
reg [3:0]              frame_Bynum_cnt; // 接收的字节个数计数器
reg [3:0]              frame_state    ; 
reg                    operate_finish ; 
/////////////////////////////////////
reg [7:0]              sen_cmd[(`CMD_NUM):0];//发几个命令
wire[31:0]             diag_cycle_temp;//诊断周期

//assign diag_cycle_temp = {18'd0,diag_cycle[7:0],6'd0}+{16'd0,diag_cycle[7:0],8'd0}+{15'd0,diag_cycle[7:0],9'd0}+{13'd0,diag_cycle[7:0],11'd0}+
//                         {10'd0,diag_cycle[7:0],14'd0}+{6'd0,diag_cycle[7:0],18'd0}+{5'd0,diag_cycle[7:0],19'd0}+{2'd0,diag_cycle[7:0],22'd0};//100ms
assign diag_cycle_temp = diag_cycle*50000; // 1ms~255ms [diag_cycle=01-FF]
always @ ( * )begin
case(diag_threshold)
      8'd0:begin            //1%
                 up  =  16'd328 + precise_data; //
                 low =  precise_data -  16'd328;
           end
      8'd1:begin            //2%
                 up  =  16'd656 + precise_data; //
                 low =  precise_data -  16'd656;
           end
      8'd2:begin            //3%
                 up  =  16'd983 + precise_data; //
                 low =  precise_data -  16'd983;
           end
      8'd3:begin            //4%
                 up  =  16'd1311 + precise_data; //
                 low =  precise_data -  16'd1311;
           end
      8'd4:begin            //5%
                 up  =  16'd1638 + precise_data; //
                 low =  precise_data -  16'd1638;
           end
      8'd5:begin            //6%
                 up  =  16'd1967 + precise_data; //
                 low =  precise_data -  16'd1967;
           end
      8'd6:begin            //7%
                 up  =  16'd2295 + precise_data; //
                 low =  precise_data -  16'd2295;
           end
      8'd7:begin            //8%
                 up  =  16'd2623 + precise_data; //
                 low =  precise_data -  16'd2623;
           end
      8'd8:begin            //9%
                 up  =  16'd2951 + precise_data; //
                 low =  precise_data -  16'd2951;
           end
      8'd9:begin            //10%
                 up  =  16'd3279 + precise_data; //
                 low =  precise_data -  16'd3279;
           end
default:begin
                 up  = 16'hFFFF;
                 low = 16'h0000;
        end
endcase
end

///////////////////////////////////////
reg [15:0]              cnt;
reg                     load_timer;  //spi配置开始计时 

reg [31:0]              delay_cnt;   
//reg                   timer_out1;  //
//reg                   timer_out;
wire                    timer_out;

assign  timer_out = (cnt == delay_cnt) & load_timer;  // load_timer为1时 cnt一直计数，timer_out为包间隔时间 
                                                      //timer_out为1时，load_timer拉低 cnt清0
assign  test = {2'd0,timer_out,frame_busy,branch_state};  
assign  spi_low = 1'b0;
reg     spi_miso_r;
reg     spi_miso1;

always @ (posedge clk)
begin
    spi_miso_r <= spi_miso;
    spi_miso1  <= spi_miso_r;
end

always @ (posedge clk or negedge rst_n)
begin
	   if(!rst_n) begin
	   	  cnt <= 'd0;
	   end
	   else begin
	   	  if(!load_timer)begin
	   	     cnt        <= 'd0;
	   	  end
	   	  else begin    
	   	  if(cnt < delay_cnt)
	   	     cnt  <= cnt + 'd1;
	   	 end
	   end
end

reg [31:0] cnt_delay; // 诊断延时计数器
reg       diag_start;//诊断开始计数

always @ (posedge clk or negedge rst_n)
begin
	 if(!rst_n)
	 cnt_delay <= 32'd0;
	 else  begin
	 if(diag_start) begin
	      if(cnt_delay < diag_cycle_temp)
	      cnt_delay <= cnt_delay +1;
	      else
	      cnt_delay <= cnt_delay ;
	      end
	 else
	    cnt_delay <= 32'd0;
  end	  
end
////////////////////
always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        main_state    <= INITIAL;
        branch_state  <= step1;
        recv_datnum   <= 4'd0;
    	send_cmdnum   <= 4'd0;
    	frame_Bynum   <= 4'd0;
    	frame_start   <= 1'b0;
        load_timer    <= 1'b0;
    	diag_data     <= 0;
        sample_data   <= 0;
        delay_cnt     <= 32'd0;
        max           <= 0;
        min           <= 16'hFFFF;
        sample_times  <= 0;
        sum           <= 0;
        sample_finish <= 0;
        diag_start    <= 0;
        diag_result   <= 0;
    end               
    else begin
    	if(ch_en == CH_EN) begin
    	  case(main_state)
    	  	  INITIAL:begin
    	  	          case(branch_state)
    	  	          	step1:begin
    	  	          		      sen_cmd[0]   <= 8'hFF;
    	  	          		      sen_cmd[1]   <= 8'hFF;
    	  	          		      sen_cmd[2]   <= 8'hFF;
    	  	          		      sen_cmd[3]   <= 8'hFF;
    	  	          	      	  recv_datnum  <= 4'd0;
    	  	          		      send_cmdnum  <= 4'd3;
    	  	          		      frame_Bynum  <= 4'd3;
    	  	          		      frame_start  <= 1'b1;
    	  	          	      	  branch_state <= step2;
    	  	          	      	  delay_cnt    <= PACK_GAP;
    	  	          	      	  load_timer   <= 1'b0;
    	  	          	      	  diag_start   <= 0;
    	  	            end
    	  	          	step2:begin
    	  	          		      frame_start  <= 1'b0;
    	  	          		      load_timer   <= 1'b1;
                              max          <= 0;
                              min          <= 16'hFFFF;
                              sample_times <= 0;
                              sum          <= 0;
                              sample_finish<= 0;
    	  	          	       if(timer_out&(!frame_busy))begin
                              main_state   <= PROCESS;
    	  	          	      	branch_state <= step1;
    	  	          	       end  
    	  	           end 
    	  	          default:begin
                                  main_state    <= INITIAL;
                                  branch_state  <= step1;
                                  recv_datnum   <= 4'd0;
                              	send_cmdnum   <= 4'd0;
                              	frame_Bynum   <= 4'd0;
                              	frame_start   <= 1'b0;
                                  load_timer    <= 1'b0;
                              	  diag_data     <= 0;
                                  sample_data   <= 0;
                                  delay_cnt     <= 32'd0;
                                  max           <= 0;
                                  min           <= 16'hFFFF;
                                  sample_times  <= 0;
                                  sum           <= 0;
                                  sample_finish <= 0;
                                  diag_start    <= 0;
                                  diag_result   <= 0;
                              end               
    	  	          endcase
    	  	  end
    	  	  PROCESS:begin
    	  	  	      case(branch_state)
    	  	          	step1:begin
    	  	          		      sen_cmd[0]    <= 8'h10;
    	  	          		      sen_cmd[1]    <= config1[15:8];
    	  	          		      sen_cmd[2]    <= config1[7:0];
    	  	          	      	  recv_datnum   <= 4'd0;
    	  	          		      send_cmdnum   <= 4'd2;
    	  	          		      frame_Bynum   <= 4'd2;
    	  	          		      frame_start   <= 1'b1;
    	  	          	      	branch_state  <= step2;
    	  	          	      	delay_cnt     <= PACK_GAP;
    	  	          	      	load_timer    <= 1'b0;
                                sample_finish <= 0;
    	  	          end
    	  	           step2:begin 
    	  	          	       if(timer_out&(!frame_busy))begin
                                sen_cmd[0]   <= 8'h08;
    	  	          		    sen_cmd[1]   <= config2[15:8];
    	  	          		    sen_cmd[2]   <= config2[7:0];
    	  	          	      	recv_datnum  <= 4'd0;
    	  	          		    send_cmdnum  <= 4'd2;
    	  	          		    frame_Bynum  <= 4'd2;
    	  	          		    frame_start  <= 1'b1;
    	  	          	       	branch_state <= step3;
    	  	          	      	delay_cnt    <= PACK_GAP;
    	  	          	      	load_timer   <= 1'b0;
    	  	          	       end 
                              else begin
                               frame_start  <= 1'b0;
    	  	          		   load_timer   <= 1'b1;
                              end
    	  	          end 
    	  	             step3:begin
    	  	          	       if(timer_out&(!frame_busy))begin
                                  sen_cmd[0]   <= 8'h28;
    	  	          		      sen_cmd[1]   <= 8'h50;//sen_cmd[1]   <= 8'h20; 20160420gai
    	  	          	      	  recv_datnum  <= 4'd0;
    	  	          		      send_cmdnum  <= 4'd1;
    	  	          		      frame_Bynum  <= 4'd1;
    	  	          		      frame_start  <= 1'b1;
    	  	          	      	  branch_state <= step4;
    	  	          	      	  delay_cnt    <= PACK_GAP;
    	  	          	      	  load_timer   <= 1'b0;
    	  	          	      end 
                                 else begin
                                 frame_start  <= 1'b0;
    	  	          		     load_timer   <= 1'b1;
                              end  
    	  	          end 
    	  	          step4:begin 
    	  	          	       if(timer_out&(!frame_busy)&(!spi_miso1))begin
                                  sen_cmd[0]   <=  8'h58;
    	  	          		          sen_cmd[1]   <=  8'hFF;
    	  	          		          sen_cmd[2]   <=  8'hFF;
    	  	          		          sen_cmd[3]   <=  8'hFF;
    	  	          	      	      recv_datnum  <=  4'd3;
    	  	          		          send_cmdnum  <=  4'd3;
    	  	          		          frame_Bynum  <=  4'd3;
    	  	          		          frame_start  <=  1'b1;
    	  	          	      	      branch_state <=  step5;
    	  	          	      	      delay_cnt    <=  PACK_GAP;
    	  	          	      	      load_timer   <=  1'b0;
    	  	          	       end  
                               else begin
                                       frame_start  <= 1'b0;
    	  	          		           load_timer   <= 1'b1;
                               end 
    	  	               end 
    	  	          step5:begin
    	  	          		         frame_start  <= 1'b0;
                               load_timer   <= 1'b0;
    	  	          		     if(operate_finish == 1'b1)begin
    	  	          		         branch_state   <= step6;
                                     delay_cnt    <= PACK_GAP;
    	  	          	      	     load_timer   <= 1'b0;
    	  	          		     end
    	  	          		     else if(frame_busy)begin
    	  	          		     	        if((out_rdy)&(frame_Bynum_cnt == frame_Bynum-2))begin
    	  	          		                 sample_data_temp[23:16]<= data_out;
    	  	          		              end
    	  	          		              if((out_rdy)&(frame_Bynum_cnt == frame_Bynum-1))begin
    	  	          		                 sample_data_temp[15:8] <= data_out;
    	  	          		              end
    	  	          		                 else if((out_rdy)&(frame_Bynum_cnt == frame_Bynum))begin
    	  	          		                      sample_data_temp[7:0]  <= data_out;
    	  	          		                 end
                              end
                                   else begin
                                      branch_state   <= step5;
                                   end 
    	  	               end 
    	  	          step6:begin
                        sample_data<=temp1[46:23];
                        if(timer_out)begin
                         sample_finish<= 1;
                         delay_cnt    <= PACK_GAP;
    	  	          	   load_timer   <= 1'b0;
                          if((diag_en == DIAG_EN)) begin  
                             if(cnt_delay == diag_cycle_temp) begin
    	  	             	         branch_state <= step7;
    	  	             	         diag_start   <= 0;
    	  	             	     end
    	  	             	     else begin
    	  	             	      diag_start   <= 1;
    	  	             	      branch_state   <= step1;
    	  	             	     end
    	  	              	end     
                          else begin
                            branch_state   <= step1;
                            diag_start   <= 0;
                          end
                        end
                        else
                        load_timer   <= 1'b1;
    	  	          end
    	  	          step7:begin
                                sample_finish<= 0;
    	  	          	        frame_start  <= 1'b1;
    	  	          	      	branch_state <= step8;
    	  	          	      	load_timer   <= 1'b1;
    	  	          	     if(config3[23:16]==8'h10)begin // if(config3[23:16]==8'h10)begin 20160420gai
    	  	                      sen_cmd[0]   <= config3[23:16];
    	  	          		      sen_cmd[1]   <= config3[15:8];
    	  	          		      sen_cmd[2]   <= config3[7:0];
    	  	          	      	  recv_datnum  <= 'd0;
    	  	          		      send_cmdnum  <= 'd2;
    	  	          		      frame_Bynum  <= 'd2;
    	  	          		    end
    	  	          		  else begin
    	  	          		      sen_cmd[0]   <= config3[15:8];
    	  	          		      sen_cmd[1]   <= config3[7:0];
    	  	          	      	  recv_datnum  <= 'd0;
    	  	          		      send_cmdnum  <= 'd1;
    	  	          		      frame_Bynum  <= 'd1;
    	  	          		   end  
    	  	         end
    	  	         step8:begin
    	  	          	       if(timer_out&(!frame_busy)&(!spi_miso1))begin
                                   sen_cmd[0]   <= 8'h58;
    	  	          		       sen_cmd[1]   <= 8'hFF;
    	  	          		       sen_cmd[2]   <= 8'hFF;
    	  	          		       sen_cmd[3]   <= 8'hFF;
    	  	          	      	   recv_datnum  <= 'd3;
    	  	          		       send_cmdnum  <= 'd3;
    	  	          		       frame_Bynum  <= 'd3;
    	  	          		       frame_start  <= 1'b1;
    	  	          	      	   branch_state <= step9;
    	  	          	      	   delay_cnt    <= PACK_GAP;
    	  	          	      	   load_timer   <= 1'b0;
    	  	          	      end  
                               else begin
                                   frame_start  <= 1'b0;
    	  	          		       load_timer   <= 1'b1;
                              end 
    	  	          end 
    	  	         step9:begin
                                   load_timer   <= 1'b0;
    	  	          		       frame_start  <= 1'b0;
                               if(operate_finish == 1'b1)begin
    	  	          		          branch_state   <= step10;
                                      delay_cnt    <= PACK_GAP;
    	  	          	      	      load_timer   <= 1'b0;       
                                      sample_times <= sample_times + 1;
    	  	          		        end
    	  	          		     else if(frame_busy)begin
    	  	          		     	  if((out_rdy)&(frame_Bynum_cnt == frame_Bynum-2))
    	  	          		           sample_data_temp[23:16]<= data_out;
    	  	          		        if((out_rdy)&(frame_Bynum_cnt == frame_Bynum-1))
    	  	          		           sample_data_temp[15:8] <= data_out;
    	  	          		        else if((out_rdy)&(frame_Bynum_cnt == send_cmdnum))
    	  	          		           sample_data_temp[7:0]  <= data_out;
                                     else
                                       branch_state   <= step9; 
    	  	          		     end
    	  	          end 
    	  	         step10:begin
                               load_timer   <= 1'b1;
                               if(timer_out)begin
    	  	          	          diag_data <= temp1[46:23];
                                  sum <= sum + temp1[46:31];
                                 load_timer <= 1'b0;
                                  if(max < temp1[46:31])
                                        max <= temp1[46:31];
                                  if(min > temp1[46:31])
                                        min <= temp1[46:31];
                                  if(sample_times == SAMPLE_TIMES)
    	  	          	               branch_state <= step11; 
                                   else begin
                                     branch_state <= step8; 
                                     delay_cnt <= PACK_GAP;
                              end
                        end
    	  	          end
                   step11:begin
    	  	          	       sample_times <= 0;
                               sum <= (sum - min - max)>>3;
    	  	          	       branch_state <= step12;
                                delay_cnt <= PACK_GAP;
                               load_timer <= 1'b0;
    	  	          end
                   step12:begin
    	  	          	      sample_times <= 0;
                            load_timer   <= 1'b0;
                            branch_state <= step13;
                            if((sum[15:0]>up)|(sum[15:0]<low))
                            diag_result <= UP_LOW;
                            else
                            diag_result <= 8'h00;
    	  	                end
                   step13:begin
                          if(timer_out)begin
    	  	          	    branch_state <= step1;
                             delay_cnt <=PACK_GAP;
    	  	                  load_timer <= 1'b0;
                                   sum <= 0;
                                   max <= 0;
                                   min <= 16'hFFFF;
                          end
                       else
                            load_timer <= 1'b1;
                       end
    	  	       default:begin
                                  main_state    <= INITIAL;
                                  branch_state  <= step1;
                                  recv_datnum   <= 4'd0;
                              	  send_cmdnum   <= 4'd0;
                              	  frame_Bynum   <= 4'd0;
                              	  frame_start   <= 1'b0;
                                  load_timer    <= 1'b0;
                              	  diag_data     <= 0;
                                  sample_data   <= 0;
                                  delay_cnt     <= 32'd0;
                                  max           <= 0;
                                  min           <= 16'hFFFF;
                                  sample_times  <= 0;
                                  sum           <= 0;
                                  sample_finish <= 0;
                                  diag_start    <= 0;
                                  diag_result   <= 0;
                              end               
    	  	         endcase
    	  	 end
    	  default:begin 
    	  	  main_state   <= INITIAL;
    	  	  branch_state  <= step1;
    	  end
    	endcase
    end
      else begin
      	main_state    <= INITIAL;
        branch_state  <= step1;
        recv_datnum   <= 4'd0;
    	send_cmdnum   <= 4'd0;
    	frame_Bynum   <= 4'd0;
    	frame_start   <= 1'b0;
        load_timer    <= 1'b0;
    	diag_data     <= 0;
        sample_data   <= 0;
        delay_cnt     <= 32'd0;
        max           <= 0;
        min           <= 16'hFFFF;
        sample_times  <= 0;
        sum           <= 0;
        sample_finish <= 0;
        diag_start    <= 0;
        diag_result   <= 0;
    end
    end
end

reg    [15:0]  x[7:0];
reg    [15:0]  y[1:0];
reg    [15:0]  y_temp;
always @ (posedge clk or negedge rst_n)begin
	if(!rst_n)begin
    x[0]  <= 0;
    x[1]  <= 0;
    x[2]  <= 0;
    x[3]  <= 0;
    x[4]  <= 0;
    x[5]  <= 0;
    x[6]  <= 0;
    x[7]  <= 0;
    y[0]  <= 0;
    y[1]  <= 0;
end else begin
 if(sample_finish)begin
     x[0]  <= sample_data[23:8] ;
     x[1]  <= x[0]        ;
     x[2]  <= x[1]        ;
     x[3]  <= x[2]        ;
     x[4]  <= x[3]        ;
     x[5]  <= x[4]        ;
     x[6]  <= x[5]        ;
     x[7]  <= x[6]        ;
     y[0]  <= y_temp      ;
     y[1]  <= y[0]        ;
end
end
end

always @ ( * )begin
  case(filter_type)
       NONE    :begin
                  process_data = sample_data[23:8];
                  y_temp       = 0;
                end
       AVERAGE :begin
                case(filter_factor)
                8'd0:
                begin 
                	process_data = (x[7] + x[6] + x[5] + x[4]+ x[3]+ x[2]+ x[1]+ x[0])>>3;
                	y_temp       = 0;
                end
                8'd1:
                begin 
                	process_data = (x[3]+ x[2]+ x[1]+ x[0])>>2;
                	y_temp       = 0;
                end
                8'd2:
                begin 
                	process_data = (x[1]+ x[0])>>1;
                	y_temp       = 0;
                	end
                default:
                begin 
                	process_data = 16'd0;
                	y_temp       = 0;
                end
                endcase
       end
       IIR     :begin
                case(filter_factor)
                8'd0:
                begin 
                	y_temp       = (x[7] + x[6] + x[5] + x[4]+ x[3]+ x[2]+ x[1]+ x[0]);
                	process_data = y[1];
                	end
                8'd1:
                begin 
                	y_temp       = (x[3]+ x[2]+ x[1]+ x[0]);
                	process_data = y[1];
                	end
                8'd2:
                begin 
                	y_temp       = (x[1]+ x[0]);
                	process_data = y[1];
                end
                default:
                begin 
                	y_temp       = 0;
                	process_data = 16'd0;
                	end
                endcase
       end
       FIR     :
                begin
                case(filter_factor)
                default:
                begin 
                	y_temp       = 0;
                	process_data = 16'd0;
                end
                endcase
       end
  default:
  begin 
  	y_temp       = 0;
  	process_data = 16'd0;
  end
endcase
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
                     spi_freq        <= 8'h1;
                     frame_state     <= 4'b0010   ; 
                     frame_Bynum_cnt <= frame_Bynum_cnt + 1'd1; 
                     //end //                
                     if(frame_Bynum_cnt == frame_Bynum) begin
                         frame_state     <= 4'b0001;
                         frame_Bynum_cnt <= 'd0  ;
                         spi_cs          <= 1'b1   ;
                         frame_busy      <= 1'b0   ;
                         spi_freq        <= 8'h0   ;
                         spi_data        <= sen_cmd[0] ;
                         operate_finish  <= 1'b1  ;
                       end
              end
              else begin
                 spi_freq <= spi_freq + 8'h1;
                 frame_state <= 4'b0010;
                 if((send_cmdnum  > frame_Bynum_cnt)&(spi_freq == SPI_SPEED - 1 )&(frame_Bynum_cnt != frame_Bynum))
                          spi_data  <= sen_cmd[frame_Bynum_cnt+ 1'd1];
                     else if((spi_freq == SPI_SPEED - 1 )&(frame_Bynum_cnt != frame_Bynum))
                          //spi_data  <= data_in; 
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
		if((frame_start)|((spi_freq == 8*SPI_SPEED/8)))
		 begin
		 //spi_mosi <= ((frame_Bynum_cnt != frame_Bynum))?(frame_start? sen_cmd[0][7]:spi_data[7]):1'b1;
        spi_mosi <= ((frame_Bynum_cnt != frame_Bynum)|(frame_start))?(frame_start? sen_cmd[0][7]:spi_data[7]):1'b1;
		 in_rdy   <= 1'b0;
		 end
		else if((spi_freq == 1*SPI_SPEED/8))
		 begin
		 spi_mosi <= spi_data[6];
		 in_rdy   <= 1'b0;
		 end
		else if((spi_freq == 2*SPI_SPEED/8))
		 begin
		 spi_mosi <= spi_data[5];
		 in_rdy   <= 1'b0;
		 end	
		else if((spi_freq == 3*SPI_SPEED/8))
		 begin
		 spi_mosi <= spi_data[4];
		 in_rdy   <= 1'b0;
		 end		
		else if((spi_freq == 4*SPI_SPEED/8))
		 begin
		 spi_mosi <= spi_data[3];
		 in_rdy   <= 1'b0;
		 end	
		else if((spi_freq == 5*SPI_SPEED/8))
		 begin
		 spi_mosi <= spi_data[2];
		 if((send_cmdnum  <= frame_Bynum_cnt)&(frame_Bynum_cnt!=frame_Bynum))
		 in_rdy   <= 1'b1;
		 end	
		else if((spi_freq == 6*SPI_SPEED/8))
		 begin
		 spi_mosi <= spi_data[1];
         in_rdy   <= 1'b0;
		 end	
		else if((spi_freq == 7*SPI_SPEED/8))
		 begin
		 spi_mosi <= spi_data[0];
		 in_rdy   <= 1'b0;
		 end	
		 //else if(frame_Bynum_cnt == frame_Bynum)
		 // begin
		 // spi_mosi <= 1'b1;
		 // in_rdy   <= 1'b0;
	   // end
	   //else if(frame_busy)
	   // spi_mosi <= spi_mosi;
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
	   data_out <= 8'hFF; //
	   out_rdy     <= 1'b0;
	 end
	else begin
		if(((spi_freq == SPI_SPEED/16)))begin
		 data_out[7] <= spi_miso;
		 out_rdy     <= 1'b0;
		end
		else if((spi_freq == 1*SPI_SPEED/8+SPI_SPEED/16))begin
        data_out[6] <= spi_miso;
        out_rdy     <= 1'b0;
		end
		else if((spi_freq == 2*SPI_SPEED/8+SPI_SPEED/16))begin
     data_out[5] <= spi_miso;
     out_rdy     <= 1'b0;
		end	
		else if((spi_freq == 3*SPI_SPEED/8+SPI_SPEED/16))begin
     data_out[4] <= spi_miso;		
     out_rdy     <= 1'b0;
		end
		else if((spi_freq == 4*SPI_SPEED/8+SPI_SPEED/16))begin
     data_out[3] <= spi_miso;	
     out_rdy     <= 1'b0;
		end	
		else if((spi_freq == 5*SPI_SPEED/8+SPI_SPEED/16))begin
     data_out[2] <= spi_miso;
     out_rdy     <= 1'b0;
		end		
		else if((spi_freq == 6*SPI_SPEED/8+SPI_SPEED/16))begin
     data_out[1] <= spi_miso;
     out_rdy     <= 1'b0;
		end		
		else if((spi_freq == 7*SPI_SPEED/8+SPI_SPEED/16))begin
     data_out[0] <= spi_miso;
     if((frame_Bynum+1-recv_datnum) <= frame_Bynum_cnt)	
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
		else if((spi_freq == 8*SPI_SPEED/8))
		 spi_clk <= (frame_Bynum_cnt == frame_Bynum)? 1'b1:1'b0;
		else if((spi_freq == SPI_SPEED/16))
		 spi_clk <= 1'b1;
		else if((spi_freq == 1*SPI_SPEED/8))
		 spi_clk <= 1'b0;
		else if((spi_freq == 1*SPI_SPEED/8+SPI_SPEED/16))
		spi_clk <= 1'b1;
		else if((spi_freq == 2*SPI_SPEED/8))
		 spi_clk <= 1'b0;
		else if((spi_freq == 2*SPI_SPEED/8+SPI_SPEED/16))
		spi_clk <= 1'b1;
		else if((spi_freq == 3*SPI_SPEED/8))
		 spi_clk <= 1'b0;
		else if((spi_freq == 3*SPI_SPEED/8+SPI_SPEED/16))
		spi_clk <= 1'b1;
		else if((spi_freq == 4*SPI_SPEED/8))
		 spi_clk <= 1'b0;
		else if((spi_freq == 4*SPI_SPEED/8+SPI_SPEED/16))
		spi_clk <= 1'b1;
		else if((spi_freq == 5*SPI_SPEED/8))
		 spi_clk <= 1'b0;
		else if((spi_freq == 5*SPI_SPEED/8+SPI_SPEED/16))	
		spi_clk <= 1'b1;
		else if((spi_freq == 6*SPI_SPEED/8))	
		 spi_clk <= 1'b0;
		else if((spi_freq == 6*SPI_SPEED/8+SPI_SPEED/16))
		spi_clk <= 1'b1;
		else if((spi_freq == 7*SPI_SPEED/8))
		 spi_clk <= 1'b0;
		else if((spi_freq == 7*SPI_SPEED/8+SPI_SPEED/16))
		spi_clk <= 1'b1;
		else
		spi_clk <= spi_clk;
  end
end


endmodule                 