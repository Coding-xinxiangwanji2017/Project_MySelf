module mii_mac_rx(
       input   wire          i_clk         ,
       input   wire          i_rstn        ,  
       
       input   wire          i_rxdv        ,
       input   wire [1:0]    im_rxdata     ,   
       input   wire [47:0]   w_dmac_addr   ,
       //input   wire [7:0]    im_np_addr    ,
              
       output                o_wren        ,
       output       [10:0]   o_wraddr      ,
       output       [7:0]    o_wrdata      ,
       
       output                o_data_ready  
            
       );

parameter  LO        = 1'd0,
           HI        = 1'd1;


parameter  TYPE_PROTOCOL = 16'h008A ;
parameter  ALDATA_NUM    = 11'd138 ;

//parameter [47:0]  w_dmac_addr = {40'hff_ff_ff_ff_ff,im_np_addr};



parameter  IDLE_DLL      = 4'd0,
           DMAC          = 4'd1,
           SMAC          = 4'd2,
           TYPE          = 4'd3,
           AL_DATA       = 4'd4,
           FINISH        = 4'd5,
           FINISH_ADD    = 4'd6;

                             
wire        w_mac_start         ;   
wire        w_d_flag            ;
wire        w_d_sync            ;
wire [7:0]  w_d_data            ;

reg [3:0]   curr_state          ;
reg [3:0]   next_state          ;


reg         dmac_flag           ;
reg         smac_flag           ;
reg         type_flag           ;
reg         aldata_flag         ;
reg         finish_flag         ;

reg [2:0]   cnt_dmac            ; 
reg [2:0]   cnt_smac            ;
reg [2:0]   cnt_type            ;
reg [10:0]  cnt_aldata          ;

    
reg [47:0]  r_dmac_recv         ;
reg         chk_dmac_err        ;

reg         chk_type_pre        ;
reg         chk_type            ;
reg         chk_type_err        ;
reg [15:0]  type_chk            ; 

reg [7:0]   aldata1             ;
reg [7:0]   aldata2             ;
reg [7:0]   address             ;

rmii   u_rmii(	
        .i_clk_50m           (i_clk      ),		
        .i_rstn              (i_rstn     ),	
                                         
        .i_rxdv              (i_rxdv     ),			
        .im_rxdata           (im_rxdata  ),		
        
        .o_d_flag            (w_d_flag   ),
        .o_d_sync            (w_d_sync   ),
        .om_data             (w_d_data   ),
        .o_mac_start         (w_mac_start)
        );


always @(posedge i_clk or negedge i_rstn)
if(!i_rstn)
    curr_state <= IDLE_DLL     ;
else 
    curr_state <= next_state   ;

always @( * ) 
begin
    dmac_flag             = LO      ;
    smac_flag             = LO      ; 
    type_flag             = LO      ;
    aldata_flag           = LO      ; 
    finish_flag           = LO      ;
    chk_type_pre          = LO      ;
    
    
    case(curr_state)
    IDLE_DLL     :begin
                      if(w_mac_start)
                          next_state = DMAC     ;
                      else
                          next_state = IDLE_DLL ;                 
                  end
                 
    DMAC         :begin
                      dmac_flag = HI ;
                      if(w_d_flag)
                          if(w_d_sync && cnt_dmac==3'd5)
                              next_state = SMAC ;                   
                          else                      
                              next_state = DMAC ;    
                      else
                          next_state =  IDLE_DLL;
                  end
                 
    SMAC         :begin
                      smac_flag = HI ;   
                      if(w_d_flag)  
                          if(!chk_dmac_err)
                              if(w_d_sync && cnt_smac==3'd5)
                                  next_state = TYPE ;
                              else                      
                                  next_state = SMAC ;  
                          else
                              next_state =  FINISH;   
                      else
                          next_state =  IDLE_DLL;                     
                  end  
                 
    TYPE         :begin
                      type_flag = HI ;
                      if(w_d_flag)  
                          if(w_d_sync && cnt_type==3'd1)
                              begin
                                  next_state = AL_DATA ;
                                  chk_type_pre  = HI   ;   
                              end                         
                          else
                              next_state = TYPE        ;  
                      else                                   
                          next_state =  IDLE_DLL;        
                  end  
                       
    AL_DATA      :begin   
    	                aldata_flag = HI ;   
    	                if(w_d_flag)    	  
    	                    if(!chk_type_err)                  
    	                        if(w_d_sync && cnt_aldata==ALDATA_NUM)
                                    next_state = FINISH ;
                                else                         
                                    next_state = AL_DATA  ;   
                            else   
                                next_state = FINISH;                        
                        else                                    
                            next_state =  IDLE_DLL;                                  
    	            end      
    	                     	                      
    FINISH       :begin     
    	                next_state = FINISH_ADD;
    	                if((!chk_dmac_err) && (!chk_type_err))  
    	                    finish_flag  = HI ;          	                            	                      
    	            end	   
    FINISH_ADD   :begin     
    	                next_state = IDLE_DLL ;	
    	                if((!chk_dmac_err) && (!chk_type_err))  
    	                    finish_flag  = HI ;    	                                            	                      
                  end	    	               	            
    default      :;
    endcase
end

assign o_wren        = aldata_flag;
assign o_wraddr      = cnt_aldata ;
assign o_wrdata      = w_d_data    ;
assign o_data_ready  = finish_flag;


always @(posedge i_clk or negedge i_rstn)
if(!i_rstn)                                  
    cnt_dmac <= 3'd0 ;                       
else if(!dmac_flag)                          
    cnt_dmac <= 3'd0 ;                       
else if(w_d_sync)                            
    cnt_dmac <= cnt_dmac + 1'd1 ;            
                                             
always @(posedge i_clk or negedge i_rstn)
if(!i_rstn)                                  
    cnt_smac <= 3'd0 ;                       
else if(!smac_flag)                          
    cnt_smac <= 3'd0 ;                       
else if(w_d_sync)                            
    cnt_smac <= cnt_smac + 1'd1 ;            
                                             
always @(posedge i_clk or negedge i_rstn)
if(!i_rstn)                                  
    cnt_type <= 3'd0 ;                       
else if(!type_flag)                          
    cnt_type <= 3'd0 ;                       
else if(w_d_sync)                            
    cnt_type <= cnt_type + 1'd1 ;        
    
always @(posedge i_clk or negedge i_rstn)
if(!i_rstn)
    cnt_aldata <= 11'd0 ;
else if(!aldata_flag)
    cnt_aldata <= 11'd0 ;
else if(w_d_sync) 
    cnt_aldata <= cnt_aldata + 1'd1 ;       

always @(posedge i_clk or negedge i_rstn)
if(!i_rstn)
    r_dmac_recv <= 48'h0 ;
else if(w_mac_start)
    r_dmac_recv <= 48'h0 ;
else if((dmac_flag == HI)&&(w_d_sync==1'd1))
    r_dmac_recv <= {r_dmac_recv[39:0],w_d_data};

always @(posedge i_clk or negedge i_rstn)
if(!i_rstn)
    chk_dmac_err <= 1'd0 ;
else if(w_mac_start)
    chk_dmac_err <= 1'd0 ; 
else if((smac_flag == HI)&&(r_dmac_recv!=w_dmac_addr))
    chk_dmac_err <= 1'd1 ;
   
always @(posedge i_clk or negedge i_rstn)
if(!i_rstn)
    type_chk <= 16'd0 ;
else if((type_flag==1'd1)&&(w_d_sync==1'd1))
    type_chk <= {type_chk[7:0],w_d_data} ;
    
always @(posedge i_clk or negedge i_rstn)
if(!i_rstn) 
    chk_type <= 1'd0 ;
else 
    chk_type <= chk_type_pre ;

always @(posedge i_clk or negedge i_rstn)
if(!i_rstn)
    chk_type_err <= 1'd0 ;
else if(w_mac_start)
    chk_type_err <= 1'd0 ; 
else if((chk_type==1'd1)&&(type_chk!=TYPE_PROTOCOL))
    chk_type_err <= 1'd1 ;
                
endmodule                                            