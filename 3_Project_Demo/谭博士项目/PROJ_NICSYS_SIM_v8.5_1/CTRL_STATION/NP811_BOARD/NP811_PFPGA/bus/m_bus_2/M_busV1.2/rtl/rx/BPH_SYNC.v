
module BPH_SYNC(
input           clk     ,        // clock input
input           reset   ,        // reset input
input           clk90   ,        // clock 90 input
input           clk180  ,        // clock 90 input
input           clk270  ,        // clock 90 input
input           datain  ,        // data inputs
input           lock    ,        // phase lock       
output [3:0]    debug   ,        // debug port       
output reg[9:0] sdataout         // data out                           
);                                   
//-----------------------------------------------------------------------------------------------------//
//                                      parameter definition                                           //
//-----------------------------------------------------------------------------------------------------//



//-----------------------------------------------------------------------------------------------------//
//                                      reg/wire definition                                            //
//-----------------------------------------------------------------------------------------------------//
wire                aa0        ;        
wire                bb0        ;        
wire                cc0        ;        
wire                dd0        ;        
reg                 usea       ;                            
reg                 useb       ;        
reg                 usec       ;        
reg                 used       ;        
reg                 useaint    ;        
reg                 usebint    ;        
reg                 usecint    ;        
reg                 usedint    ;        
wire[1:0]           useChannel ;        
reg [1:0]           ctrlint    ;        



wire                sdataa     ;           
wire                sdatab     ;           
wire                sdatac     ;           
wire                sdatad     ;           
wire                rData      ;           
reg                 rStart     ;           
reg                 reRx       ;           
reg                 dataNRZ    ;           

reg [1:0]           az         ;           
reg [1:0]           bz         ;           
reg [1:0]           cz         ;           
reg [1:0]           dz         ;           
reg                 aap        ; 
reg                 bbp        ; 
reg                 ccp        ; 
reg                 ddp        ; 
reg                 az2        ; 
reg                 bz2        ; 
reg                 cz2        ; 
reg                 dz2        ;           
reg                 aan        ; 
reg                 bbn        ; 
reg                 ccn        ; 
reg                 ddn        ;                                 
reg                 pipe_ce0   ; 
reg                 preRx      ;                                         

//-----------------------------------------------------------------------------------------------------//
//                                      statement                                                      //
//-----------------------------------------------------------------------------------------------------//

assign sdataa = aa0 && useaint;
assign sdatab = bb0 && usebint;
assign sdatac = cc0 && usecint;
assign sdatad = dd0 && usedint;
assign rData = sdataa | sdatab | sdatac | sdatad;

SRL16E saa0(.clk(clk), .reset(reset), .addr(ctrlint), .D(az2), .Q(aa0));
SRL16E sbb0(.clk(clk), .reset(reset), .addr(ctrlint), .D(bz2), .Q(bb0));
SRL16E scc0(.clk(clk), .reset(reset), .addr(ctrlint), .D(cz2), .Q(cc0));
SRL16E sdd0(.clk(clk), .reset(reset), .addr(ctrlint), .D(dz2), .Q(dd0));

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        ctrlint  <= 2'b10   ;
        useaint  <= 1'b0    ; 
        usebint  <= 1'b0    ; 
        usecint  <= 1'b0    ; 
        usedint  <= 1'b0    ;
        usea     <= 1'b0    ;
        useb     <= 1'b0    ;    
        usec     <= 1'b0    ;
        used     <= 1'b0    ;
        pipe_ce0 <= 1'b0    ; 
        sdataout <= 10'h3FF ;
        aap      <= 1'b0    ;
        bbp      <= 1'b0    ; 
        ccp      <= 1'b0    ; 
        ddp      <= 1'b0    ;
        aan      <= 1'b0    ;                   
        bbn      <= 1'b0    ; 
        ccn      <= 1'b0    ; 
        ddn      <= 1'b0    ;
        az2      <= 1'b0    ; 
        bz2      <= 1'b0    ; 
        cz2      <= 1'b0    ;
        dz2      <= 1'b0    ;
        dataNRZ  <= 1'b0    ;
    end
    else begin
        az2 <= az[1]                  ; 
        bz2 <= bz[1]                  ; 
        cz2 <= cz[1]                  ; 
        dz2 <= dz[1]                  ;
        aap <= (az2 ^ az[1]) & ~az[1] ;                   
        bbp <= (bz2 ^ bz[1]) & ~bz[1] ;
        ccp <= (cz2 ^ cz[1]) & ~cz[1] ;
        ddp <= (dz2 ^ dz[1]) & ~dz[1] ;
        aan <= (az2 ^ az[1]) & az[1]  ;                        
        bbn <= (bz2 ^ bz[1]) & bz[1]  ;
        ccn <= (cz2 ^ cz[1]) & cz[1]  ;
        ddn <= (dz2 ^ dz[1]) & dz[1]  ;
        if(!lock) begin
            usea <= (bbp & ~ccp & ~ddp & aap) | (bbn & ~ccn & ~ddn & aan)   ;
            useb <= (ccp & ~ddp & aap & bbp) | (ccn & ~ddn & aan & bbn)     ;
            usec <= (ddp & aap & bbp & ccp) | (ddn & aan & bbn & ccn)       ;
            used <= (aap & ~bbp & ~ccp & ~ddp) | (aan & ~bbn & ~ccn & ~ddn) ;
        end
        if (usea | useb | usec | used) begin
            pipe_ce0 <= 1'b1 ;
            useaint <= usea  ;
            usebint <= useb  ;
            usecint <= usec  ;
            usedint <= used  ;
        end
        if (pipe_ce0)
            sdataout <= {sdataout[8:0], dataNRZ};
        else
            sdataout <= 10'h3FF  ;
        rStart   <= pipe_ce0 ;
        if(rStart == 1'b0 && pipe_ce0 == 1'b1)
            dataNRZ  <= 1'b0     ;
        else
            dataNRZ <= preRx ^ (sdataa | sdatab | sdatac | sdatad);
        preRx   <= sdataa | sdatab | sdatac | sdatad              ;
        if (usedint & usea)                          
            ctrlint <= ctrlint - 1 ;
        else if (useaint & used)                  
            ctrlint <= ctrlint + 1 ;    
    end
end
always @(posedge clk or posedge reset) begin: ff_az0
    if(reset) 
        az[0] <= 1'b1  ;
    else 
        az[0] <= datain;
end

always @(posedge clk or posedge reset) begin: ff_az1
    if(reset) 
        az[1] <= 1'b1 ;
    else 
        az[1] <= az[0];
end

always @(posedge clk90 or posedge reset) begin: ff_bz0
    if(reset) 
        bz[0] <= 1'b1  ;
    else 
        bz[0] <= datain;
end

always @(posedge clk or posedge reset) begin: ff_bz1
    if(reset) 
        bz[1] <= 1'b1 ;
    else 
        bz[1] <= bz[0];
end

always @(posedge clk180 or posedge reset) begin: ff_cz0
    if(reset) 
        cz[0] <= 1'b1  ;
    else 
        cz[0] <= datain;
end

always @(posedge clk or posedge reset) begin: ff_cz1
    if(reset) 
        cz[1] <= 0    ;
    else 
        cz[1] <= cz[0];
end

always @(posedge clk270 or posedge reset) begin: ff_dz0
    if(reset) 
        dz[0] <= 0     ;
    else 
        dz[0] <= datain;
end

always @(posedge clk or posedge reset) begin: ff_dz1
    if(reset) 
        dz[1] <= 0    ;
    else 
        dz[1] <= dz[0];
end

assign useChannel = ({usea,useb,usec,used} == 4'h1) ? 2'b01 : 
                    ({usea,useb,usec,used} == 4'h2) ? 2'b10 : 
                    ({usea,useb,usec,used} == 4'h4) ? 2'b11 : 2'b00;
                                        

wire t0,t1;
assign {t1,t0} = (useChannel == 2'b01) ? {clk,az2}   :
                 (useChannel == 2'b10) ? {clk90,bz2} :
                 (useChannel == 2'b11) ? {clk180,cz2}: {clk270,dz2};
            
assign debug =   {useChannel,  
                  t1        ,
                  t0        
                 }          ;
endmodule
