`timescale 1 ns/100 ps
// Version: v11.5 SP2 11.5.2.6


module tx_fifo_tx_fifo_0_LSRAM_top(
       WD,
       RD,
       WADDR,
       RADDR,
       WEN,
       REN,
       CLK
    );
input  [7:0] WD;
output [7:0] RD;
input  [11:0] WADDR;
input  [11:0] RADDR;
input  WEN;
input  REN;
input  CLK;

    wire VCC, GND, ADLIB_VCC;
    wire GND_power_net1;
    wire VCC_power_net1;
    assign GND = GND_power_net1;
    assign VCC = VCC_power_net1;
    assign ADLIB_VCC = VCC_power_net1;
    
    RAM1K18 tx_fifo_tx_fifo_0_LSRAM_top_R0C0 (.A_DOUT({nc0, nc1, nc2, 
        nc3, nc4, nc5, nc6, nc7, nc8, nc9, nc10, nc11, nc12, nc13, 
        RD[3], RD[2], RD[1], RD[0]}), .B_DOUT({nc14, nc15, nc16, nc17, 
        nc18, nc19, nc20, nc21, nc22, nc23, nc24, nc25, nc26, nc27, 
        nc28, nc29, nc30, nc31}), .BUSY(), .A_CLK(CLK), .A_DOUT_CLK(
        VCC), .A_ARST_N(VCC), .A_DOUT_EN(VCC), .A_BLK({REN, VCC, VCC}), 
        .A_DOUT_ARST_N(VCC), .A_DOUT_SRST_N(VCC), .A_DIN({GND, GND, 
        GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, GND}), .A_ADDR({RADDR[11], RADDR[10], RADDR[9], 
        RADDR[8], RADDR[7], RADDR[6], RADDR[5], RADDR[4], RADDR[3], 
        RADDR[2], RADDR[1], RADDR[0], GND, GND}), .A_WEN({GND, GND}), 
        .B_CLK(CLK), .B_DOUT_CLK(VCC), .B_ARST_N(VCC), .B_DOUT_EN(VCC), 
        .B_BLK({WEN, VCC, VCC}), .B_DOUT_ARST_N(GND), .B_DOUT_SRST_N(
        VCC), .B_DIN({GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, GND, WD[3], WD[2], WD[1], WD[0]}), .B_ADDR({
        WADDR[11], WADDR[10], WADDR[9], WADDR[8], WADDR[7], WADDR[6], 
        WADDR[5], WADDR[4], WADDR[3], WADDR[2], WADDR[1], WADDR[0], 
        GND, GND}), .B_WEN({GND, VCC}), .A_EN(VCC), .A_DOUT_LAT(VCC), 
        .A_WIDTH({GND, VCC, GND}), .A_WMODE(GND), .B_EN(VCC), 
        .B_DOUT_LAT(VCC), .B_WIDTH({GND, VCC, GND}), .B_WMODE(GND), 
        .SII_LOCK(GND));
    RAM1K18 tx_fifo_tx_fifo_0_LSRAM_top_R0C1 (.A_DOUT({nc32, nc33, 
        nc34, nc35, nc36, nc37, nc38, nc39, nc40, nc41, nc42, nc43, 
        nc44, nc45, RD[7], RD[6], RD[5], RD[4]}), .B_DOUT({nc46, nc47, 
        nc48, nc49, nc50, nc51, nc52, nc53, nc54, nc55, nc56, nc57, 
        nc58, nc59, nc60, nc61, nc62, nc63}), .BUSY(), .A_CLK(CLK), 
        .A_DOUT_CLK(VCC), .A_ARST_N(VCC), .A_DOUT_EN(VCC), .A_BLK({REN, 
        VCC, VCC}), .A_DOUT_ARST_N(VCC), .A_DOUT_SRST_N(VCC), .A_DIN({
        GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, GND, GND, GND}), .A_ADDR({RADDR[11], RADDR[10], 
        RADDR[9], RADDR[8], RADDR[7], RADDR[6], RADDR[5], RADDR[4], 
        RADDR[3], RADDR[2], RADDR[1], RADDR[0], GND, GND}), .A_WEN({
        GND, GND}), .B_CLK(CLK), .B_DOUT_CLK(VCC), .B_ARST_N(VCC), 
        .B_DOUT_EN(VCC), .B_BLK({WEN, VCC, VCC}), .B_DOUT_ARST_N(GND), 
        .B_DOUT_SRST_N(VCC), .B_DIN({GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, GND, GND, GND, GND, WD[7], WD[6], WD[5], WD[4]})
        , .B_ADDR({WADDR[11], WADDR[10], WADDR[9], WADDR[8], WADDR[7], 
        WADDR[6], WADDR[5], WADDR[4], WADDR[3], WADDR[2], WADDR[1], 
        WADDR[0], GND, GND}), .B_WEN({GND, VCC}), .A_EN(VCC), 
        .A_DOUT_LAT(VCC), .A_WIDTH({GND, VCC, GND}), .A_WMODE(GND), 
        .B_EN(VCC), .B_DOUT_LAT(VCC), .B_WIDTH({GND, VCC, GND}), 
        .B_WMODE(GND), .SII_LOCK(GND));
    GND GND_power_inst1 (.Y(GND_power_net1));
    VCC VCC_power_inst1 (.Y(VCC_power_net1));
    
endmodule
