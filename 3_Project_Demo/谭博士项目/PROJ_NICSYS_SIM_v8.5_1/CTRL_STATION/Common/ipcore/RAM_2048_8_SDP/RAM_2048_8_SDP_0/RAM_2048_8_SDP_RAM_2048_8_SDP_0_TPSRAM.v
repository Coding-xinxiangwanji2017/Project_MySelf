`timescale 1 ns/100 ps
// Version: v11.5 SP2 11.5.2.6


module RAM_2048_8_SDP_RAM_2048_8_SDP_0_TPSRAM(
       WD,
       RD,
       WADDR,
       RADDR,
       WEN,
       REN,
       WCLK,
       RCLK
    );
input  [7:0] WD;
output [7:0] RD;
input  [10:0] WADDR;
input  [10:0] RADDR;
input  WEN;
input  REN;
input  WCLK;
input  RCLK;

    wire VCC, GND, ADLIB_VCC;
    wire GND_power_net1;
    wire VCC_power_net1;
    assign GND = GND_power_net1;
    assign VCC = VCC_power_net1;
    assign ADLIB_VCC = VCC_power_net1;
    
    RAM1K18 #( .MEMORYFILE("RAM_2048_8_SDP_RAM_2048_8_SDP_0_TPSRAM_R0C0.mem")
         )  RAM_2048_8_SDP_RAM_2048_8_SDP_0_TPSRAM_R0C0 (.A_DOUT({nc0, 
        nc1, nc2, nc3, nc4, nc5, nc6, nc7, nc8, nc9, RD[7], RD[6], 
        RD[5], RD[4], RD[3], RD[2], RD[1], RD[0]}), .B_DOUT({nc10, 
        nc11, nc12, nc13, nc14, nc15, nc16, nc17, nc18, nc19, nc20, 
        nc21, nc22, nc23, nc24, nc25, nc26, nc27}), .BUSY(), .A_CLK(
        RCLK), .A_DOUT_CLK(VCC), .A_ARST_N(VCC), .A_DOUT_EN(VCC), 
        .A_BLK({REN, VCC, VCC}), .A_DOUT_ARST_N(VCC), .A_DOUT_SRST_N(
        VCC), .A_DIN({GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, GND, GND, GND, GND, GND}), .A_ADDR({RADDR[10], 
        RADDR[9], RADDR[8], RADDR[7], RADDR[6], RADDR[5], RADDR[4], 
        RADDR[3], RADDR[2], RADDR[1], RADDR[0], GND, GND, GND}), 
        .A_WEN({GND, GND}), .B_CLK(WCLK), .B_DOUT_CLK(VCC), .B_ARST_N(
        VCC), .B_DOUT_EN(VCC), .B_BLK({WEN, VCC, VCC}), .B_DOUT_ARST_N(
        GND), .B_DOUT_SRST_N(VCC), .B_DIN({GND, GND, GND, GND, GND, 
        GND, GND, GND, GND, GND, WD[7], WD[6], WD[5], WD[4], WD[3], 
        WD[2], WD[1], WD[0]}), .B_ADDR({WADDR[10], WADDR[9], WADDR[8], 
        WADDR[7], WADDR[6], WADDR[5], WADDR[4], WADDR[3], WADDR[2], 
        WADDR[1], WADDR[0], GND, GND, GND}), .B_WEN({GND, VCC}), .A_EN(
        VCC), .A_DOUT_LAT(VCC), .A_WIDTH({GND, VCC, VCC}), .A_WMODE(
        GND), .B_EN(VCC), .B_DOUT_LAT(VCC), .B_WIDTH({GND, VCC, VCC}), 
        .B_WMODE(GND), .SII_LOCK(GND));
    GND GND_power_inst1 (.Y(GND_power_net1));
    VCC VCC_power_inst1 (.Y(VCC_power_net1));
    
endmodule
