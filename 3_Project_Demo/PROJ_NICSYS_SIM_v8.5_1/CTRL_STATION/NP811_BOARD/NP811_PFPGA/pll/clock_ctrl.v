`timescale 1ns/100ps

module clock_ctrl(
    input  wire         sys_clk_in      ,
    output wire         clk_50m         ,
    output wire         clk_10m         ,
    output wire         clk_12p5m       ,
    output wire         clk_12p5m_90    ,
    output wire         clk_12p5m_180   ,
    output wire         clk_12p5m_270   ,
    output wire         clk_100m        ,
    output wire         clk_100m_90     ,
    output wire         clk_100m_180    ,
    output wire         clk_100m_270    ,
    output wire         glb_rst_n       
    );

reg          rst_50m_n       ;
reg          rst_10m_n       ;
reg          rst_12p5m_n     ;    
reg          rst_12p5m_90_n  ;  
reg          rst_12p5m_180_n ;    
reg          rst_12p5m_270_n ;    
reg          rst_100m_n      ;    
reg          rst_100m_90_n   ;
reg          rst_100m_180_n  ;
reg          rst_100m_270_n  ;
         
wire         w_lock_50m        ;
wire         w_lock_12p5m      ;
wire         w_lock_100m       ;
wire         w_sys_rst_n       ;
reg  [01:00] r_rst_50m_n       ;
reg  [01:00] r_rst_10m_n       ;
reg  [01:00] r_rst_12p5m_n     ;
reg  [01:00] r_rst_12p5m_90_n  ;
reg  [01:00] r_rst_12p5m_180_n ;
reg  [01:00] r_rst_12p5m_270_n ;
reg  [01:00] r_rst_100m_n      ;
reg  [01:00] r_rst_100m_90_n   ;
reg  [01:00] r_rst_100m_180_n  ;
reg  [01:00] r_rst_100m_270_n  ;

PLL_50M_input u_PLL_50M(
    .CLK0      (sys_clk_in    ),
    .GL0       (clk_10m       ),
    .GL1       (clk_50m       ),
    .LOCK      (w_lock_50m    )
);

PLL_12P5_input u_PLL_12P5(
    .CLK0      (clk_50m       ),
    .GL0       (clk_12p5m     ),
    .GL1       (),//clk_12p5m_90  ),
    .GL2       (clk_12p5m_90  ),//clk_12p5m_180 ),
    .GL3       (),//clk_12p5m_270 ),
    .LOCK      (w_lock_12p5m  )
);

assign clk_12p5m_180 = ~clk_12p5m   ;
assign clk_12p5m_270 = ~clk_12p5m_90;

PLL_100M_input u_PLL_100M(
    .CLK0      (clk_50m       ),
    .GL0       (clk_100m      ),
    .GL1       (clk_100m_90   ),
    .GL2       (clk_100m_180  ),
    .GL3       (clk_100m_270  ),
    .LOCK      (w_lock_100m   )
);

assign glb_rst_n = rst_50m_n & rst_12p5m_n & rst_100m_n;

assign w_sys_rst_n = w_lock_50m & w_lock_12p5m & w_lock_100m;

always @ (posedge clk_50m or negedge w_sys_rst_n)
begin
  if(!w_sys_rst_n)
    begin
      rst_50m_n <= 1'b0;
      r_rst_50m_n <= 2'd0;
    end
  else
    begin
      rst_50m_n <= r_rst_50m_n[0];
      r_rst_50m_n[0] <= r_rst_50m_n[1];
      r_rst_50m_n[1] <= 1'b1;
    end
end

always @ (posedge clk_10m or negedge w_sys_rst_n)
begin
  if(!w_sys_rst_n)
    begin
      rst_10m_n <= 1'b0;
      r_rst_10m_n <= 2'd0;
    end
  else
    begin
      rst_10m_n <= r_rst_10m_n[0];
      r_rst_10m_n[0] <= r_rst_10m_n[1];
      r_rst_10m_n[1] <= 1'b1;
    end
end

always @ (posedge clk_12p5m or negedge w_sys_rst_n)
begin
  if(!w_sys_rst_n)
    begin
      rst_12p5m_n <= 1'b0;
      r_rst_12p5m_n <= 2'd0;
    end
  else
    begin
      rst_12p5m_n <= r_rst_12p5m_n[0];
      r_rst_12p5m_n[0] <= r_rst_12p5m_n[1];
      r_rst_12p5m_n[1] <= 1'b1;
    end
end

always @ (posedge clk_12p5m_90 or negedge w_sys_rst_n)
begin
  if(!w_sys_rst_n)
    begin
      rst_12p5m_90_n <= 1'b0;
      r_rst_12p5m_90_n <= 2'd0;
    end
  else
    begin
      rst_12p5m_90_n <= r_rst_12p5m_90_n[0];
      r_rst_12p5m_90_n[0] <= r_rst_12p5m_90_n[1];
      r_rst_12p5m_90_n[1] <= 1'b1;
    end
end

always @ (posedge clk_12p5m_180 or negedge w_sys_rst_n)
begin
  if(!w_sys_rst_n)
    begin
      rst_12p5m_180_n <= 1'b0;
      r_rst_12p5m_180_n <= 2'd0;
    end
  else
    begin
      rst_12p5m_180_n <= r_rst_12p5m_180_n[0];
      r_rst_12p5m_180_n[0] <= r_rst_12p5m_180_n[1];
      r_rst_12p5m_180_n[1] <= 1'b1;
    end
end

always @ (posedge clk_12p5m_270 or negedge w_sys_rst_n)
begin
  if(!w_sys_rst_n)
    begin
      rst_12p5m_270_n <= 1'b0;
      r_rst_12p5m_270_n <= 2'd0;
    end
  else
    begin
      rst_12p5m_270_n <= r_rst_12p5m_270_n[0];
      r_rst_12p5m_270_n[0] <= r_rst_12p5m_270_n[1];
      r_rst_12p5m_270_n[1] <= 1'b1;
    end
end

always @ (posedge clk_100m or negedge w_sys_rst_n)
begin
  if(!w_sys_rst_n)
    begin
      rst_100m_n <= 1'b0;
      r_rst_100m_n <= 2'd0;
    end
  else
    begin
      rst_100m_n <= r_rst_100m_n[0];
      r_rst_100m_n[0] <= r_rst_100m_n[1];
      r_rst_100m_n[1] <= 1'b1;
    end
end

always @ (posedge clk_100m_90 or negedge w_sys_rst_n)
begin
  if(!w_sys_rst_n)
    begin
      rst_100m_90_n <= 1'b0;
      r_rst_100m_90_n <= 2'd0;
    end
  else
    begin
      rst_100m_90_n <= r_rst_100m_90_n[0];
      r_rst_100m_90_n[0] <= r_rst_100m_90_n[1];
      r_rst_100m_90_n[1] <= 1'b1;
    end
end

always @ (posedge clk_100m_180 or negedge w_sys_rst_n)
begin
  if(!w_sys_rst_n)
    begin
      rst_100m_180_n <= 1'b0;
      r_rst_100m_180_n <= 2'd0;
    end
  else
    begin
      rst_100m_180_n <= r_rst_100m_180_n[0];
      r_rst_100m_180_n[0] <= r_rst_100m_180_n[1];
      r_rst_100m_180_n[1] <= 1'b1;
    end
end

always @ (posedge clk_100m_270 or negedge w_sys_rst_n)
begin
  if(!w_sys_rst_n)
    begin
      rst_100m_270_n <= 1'b0;
      r_rst_100m_270_n <= 2'd0;
    end
  else
    begin
      rst_100m_270_n <= r_rst_100m_270_n[0];
      r_rst_100m_270_n[0] <= r_rst_100m_270_n[1];
      r_rst_100m_270_n[1] <= 1'b1;
    end
end




endmodule

