`timescale 1 ns/100 ps
// Version: v11.5 SP3 11.5.3.10


module RAM_4096_8_DP_RAM_4096_8_DP_0_DPSRAM(
       A_DIN,
       A_DOUT,
       B_DIN,
       B_DOUT,
       A_ADDR,
       B_ADDR,
       A_CLK,
       B_CLK,
       A_WEN,
       B_WEN
    );
input  [7:0] A_DIN;
output [7:0] A_DOUT;
input  [7:0] B_DIN;
output [7:0] B_DOUT;
input  [11:0] A_ADDR;
input  [11:0] B_ADDR;
input  A_CLK;
input  B_CLK;
input  A_WEN;
input  B_WEN;

    wire VCC, GND, ADLIB_VCC;
    wire GND_power_net1;
    wire VCC_power_net1;
    assign GND = GND_power_net1;
    assign VCC = VCC_power_net1;
    assign ADLIB_VCC = VCC_power_net1;
    
    RAM1K18 RAM_4096_8_DP_RAM_4096_8_DP_0_DPSRAM_R0C1 (.A_DOUT({nc0, 
        nc1, nc2, nc3, nc4, nc5, nc6, nc7, nc8, nc9, nc10, nc11, nc12, 
        nc13, A_DOUT[7], A_DOUT[6], A_DOUT[5], A_DOUT[4]}), .B_DOUT({
        nc14, nc15, nc16, nc17, nc18, nc19, nc20, nc21, nc22, nc23, 
        nc24, nc25, nc26, nc27, B_DOUT[7], B_DOUT[6], B_DOUT[5], 
        B_DOUT[4]}), .BUSY(), .A_CLK(A_CLK), .A_DOUT_CLK(VCC), 
        .A_ARST_N(VCC), .A_DOUT_EN(VCC), .A_BLK({VCC, VCC, VCC}), 
        .A_DOUT_ARST_N(VCC), .A_DOUT_SRST_N(VCC), .A_DIN({GND, GND, 
        GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, 
        A_DIN[7], A_DIN[6], A_DIN[5], A_DIN[4]}), .A_ADDR({A_ADDR[11], 
        A_ADDR[10], A_ADDR[9], A_ADDR[8], A_ADDR[7], A_ADDR[6], 
        A_ADDR[5], A_ADDR[4], A_ADDR[3], A_ADDR[2], A_ADDR[1], 
        A_ADDR[0], GND, GND}), .A_WEN({GND, A_WEN}), .B_CLK(B_CLK), 
        .B_DOUT_CLK(VCC), .B_ARST_N(VCC), .B_DOUT_EN(VCC), .B_BLK({VCC, 
        VCC, VCC}), .B_DOUT_ARST_N(VCC), .B_DOUT_SRST_N(VCC), .B_DIN({
        GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, B_DIN[7], B_DIN[6], B_DIN[5], B_DIN[4]}), .B_ADDR({
        B_ADDR[11], B_ADDR[10], B_ADDR[9], B_ADDR[8], B_ADDR[7], 
        B_ADDR[6], B_ADDR[5], B_ADDR[4], B_ADDR[3], B_ADDR[2], 
        B_ADDR[1], B_ADDR[0], GND, GND}), .B_WEN({GND, B_WEN}), .A_EN(
        VCC), .A_DOUT_LAT(VCC), .A_WIDTH({GND, VCC, GND}), .A_WMODE(
        GND), .B_EN(VCC), .B_DOUT_LAT(VCC), .B_WIDTH({GND, VCC, GND}), 
        .B_WMODE(GND), .SII_LOCK(GND));
    RAM1K18 RAM_4096_8_DP_RAM_4096_8_DP_0_DPSRAM_R0C0 (.A_DOUT({nc28, 
        nc29, nc30, nc31, nc32, nc33, nc34, nc35, nc36, nc37, nc38, 
        nc39, nc40, nc41, A_DOUT[3], A_DOUT[2], A_DOUT[1], A_DOUT[0]}), 
        .B_DOUT({nc42, nc43, nc44, nc45, nc46, nc47, nc48, nc49, nc50, 
        nc51, nc52, nc53, nc54, nc55, B_DOUT[3], B_DOUT[2], B_DOUT[1], 
        B_DOUT[0]}), .BUSY(), .A_CLK(A_CLK), .A_DOUT_CLK(VCC), 
        .A_ARST_N(VCC), .A_DOUT_EN(VCC), .A_BLK({VCC, VCC, VCC}), 
        .A_DOUT_ARST_N(VCC), .A_DOUT_SRST_N(VCC), .A_DIN({GND, GND, 
        GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, 
        A_DIN[3], A_DIN[2], A_DIN[1], A_DIN[0]}), .A_ADDR({A_ADDR[11], 
        A_ADDR[10], A_ADDR[9], A_ADDR[8], A_ADDR[7], A_ADDR[6], 
        A_ADDR[5], A_ADDR[4], A_ADDR[3], A_ADDR[2], A_ADDR[1], 
        A_ADDR[0], GND, GND}), .A_WEN({GND, A_WEN}), .B_CLK(B_CLK), 
        .B_DOUT_CLK(VCC), .B_ARST_N(VCC), .B_DOUT_EN(VCC), .B_BLK({VCC, 
        VCC, VCC}), .B_DOUT_ARST_N(VCC), .B_DOUT_SRST_N(VCC), .B_DIN({
        GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, B_DIN[3], B_DIN[2], B_DIN[1], B_DIN[0]}), .B_ADDR({
        B_ADDR[11], B_ADDR[10], B_ADDR[9], B_ADDR[8], B_ADDR[7], 
        B_ADDR[6], B_ADDR[5], B_ADDR[4], B_ADDR[3], B_ADDR[2], 
        B_ADDR[1], B_ADDR[0], GND, GND}), .B_WEN({GND, B_WEN}), .A_EN(
        VCC), .A_DOUT_LAT(VCC), .A_WIDTH({GND, VCC, GND}), .A_WMODE(
        GND), .B_EN(VCC), .B_DOUT_LAT(VCC), .B_WIDTH({GND, VCC, GND}), 
        .B_WMODE(GND), .SII_LOCK(GND));
    GND GND_power_inst1 (.Y(GND_power_net1));
    VCC VCC_power_inst1 (.Y(VCC_power_net1));
    
endmodule
