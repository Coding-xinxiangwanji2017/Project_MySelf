`timescale 1 ns/100 ps
// Version: v11.5 SP2 11.5.2.6


module RAM_8K_8_DP_RAM_8K_8_DP_0_DPSRAM(
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
input  [12:0] A_ADDR;
input  [12:0] B_ADDR;
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
    
    RAM1K18 #( .MEMORYFILE("RAM_8K_8_DP_RAM_8K_8_DP_0_DPSRAM_R0C2.mem")
         )  RAM_8K_8_DP_RAM_8K_8_DP_0_DPSRAM_R0C2 (.A_DOUT({nc0, nc1, 
        nc2, nc3, nc4, nc5, nc6, nc7, nc8, nc9, nc10, nc11, nc12, nc13, 
        nc14, nc15, A_DOUT[5], A_DOUT[4]}), .B_DOUT({nc16, nc17, nc18, 
        nc19, nc20, nc21, nc22, nc23, nc24, nc25, nc26, nc27, nc28, 
        nc29, nc30, nc31, B_DOUT[5], B_DOUT[4]}), .BUSY(), .A_CLK(
        A_CLK), .A_DOUT_CLK(VCC), .A_ARST_N(VCC), .A_DOUT_EN(VCC), 
        .A_BLK({VCC, VCC, VCC}), .A_DOUT_ARST_N(VCC), .A_DOUT_SRST_N(
        VCC), .A_DIN({GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, GND, GND, GND, A_DIN[5], A_DIN[4]}), .A_ADDR({
        A_ADDR[12], A_ADDR[11], A_ADDR[10], A_ADDR[9], A_ADDR[8], 
        A_ADDR[7], A_ADDR[6], A_ADDR[5], A_ADDR[4], A_ADDR[3], 
        A_ADDR[2], A_ADDR[1], A_ADDR[0], GND}), .A_WEN({GND, A_WEN}), 
        .B_CLK(B_CLK), .B_DOUT_CLK(VCC), .B_ARST_N(VCC), .B_DOUT_EN(
        VCC), .B_BLK({VCC, VCC, VCC}), .B_DOUT_ARST_N(VCC), 
        .B_DOUT_SRST_N(VCC), .B_DIN({GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, GND, GND, GND, GND, GND, GND, B_DIN[5], 
        B_DIN[4]}), .B_ADDR({B_ADDR[12], B_ADDR[11], B_ADDR[10], 
        B_ADDR[9], B_ADDR[8], B_ADDR[7], B_ADDR[6], B_ADDR[5], 
        B_ADDR[4], B_ADDR[3], B_ADDR[2], B_ADDR[1], B_ADDR[0], GND}), 
        .B_WEN({GND, B_WEN}), .A_EN(VCC), .A_DOUT_LAT(VCC), .A_WIDTH({
        GND, GND, VCC}), .A_WMODE(GND), .B_EN(VCC), .B_DOUT_LAT(VCC), 
        .B_WIDTH({GND, GND, VCC}), .B_WMODE(GND), .SII_LOCK(GND));
    RAM1K18 #( .MEMORYFILE("RAM_8K_8_DP_RAM_8K_8_DP_0_DPSRAM_R0C3.mem")
         )  RAM_8K_8_DP_RAM_8K_8_DP_0_DPSRAM_R0C3 (.A_DOUT({nc32, nc33, 
        nc34, nc35, nc36, nc37, nc38, nc39, nc40, nc41, nc42, nc43, 
        nc44, nc45, nc46, nc47, A_DOUT[7], A_DOUT[6]}), .B_DOUT({nc48, 
        nc49, nc50, nc51, nc52, nc53, nc54, nc55, nc56, nc57, nc58, 
        nc59, nc60, nc61, nc62, nc63, B_DOUT[7], B_DOUT[6]}), .BUSY(), 
        .A_CLK(A_CLK), .A_DOUT_CLK(VCC), .A_ARST_N(VCC), .A_DOUT_EN(
        VCC), .A_BLK({VCC, VCC, VCC}), .A_DOUT_ARST_N(VCC), 
        .A_DOUT_SRST_N(VCC), .A_DIN({GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, GND, GND, GND, GND, GND, GND, A_DIN[7], 
        A_DIN[6]}), .A_ADDR({A_ADDR[12], A_ADDR[11], A_ADDR[10], 
        A_ADDR[9], A_ADDR[8], A_ADDR[7], A_ADDR[6], A_ADDR[5], 
        A_ADDR[4], A_ADDR[3], A_ADDR[2], A_ADDR[1], A_ADDR[0], GND}), 
        .A_WEN({GND, A_WEN}), .B_CLK(B_CLK), .B_DOUT_CLK(VCC), 
        .B_ARST_N(VCC), .B_DOUT_EN(VCC), .B_BLK({VCC, VCC, VCC}), 
        .B_DOUT_ARST_N(VCC), .B_DOUT_SRST_N(VCC), .B_DIN({GND, GND, 
        GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, B_DIN[7], B_DIN[6]}), .B_ADDR({B_ADDR[12], 
        B_ADDR[11], B_ADDR[10], B_ADDR[9], B_ADDR[8], B_ADDR[7], 
        B_ADDR[6], B_ADDR[5], B_ADDR[4], B_ADDR[3], B_ADDR[2], 
        B_ADDR[1], B_ADDR[0], GND}), .B_WEN({GND, B_WEN}), .A_EN(VCC), 
        .A_DOUT_LAT(VCC), .A_WIDTH({GND, GND, VCC}), .A_WMODE(GND), 
        .B_EN(VCC), .B_DOUT_LAT(VCC), .B_WIDTH({GND, GND, VCC}), 
        .B_WMODE(GND), .SII_LOCK(GND));
    RAM1K18 #( .MEMORYFILE("RAM_8K_8_DP_RAM_8K_8_DP_0_DPSRAM_R0C1.mem")
         )  RAM_8K_8_DP_RAM_8K_8_DP_0_DPSRAM_R0C1 (.A_DOUT({nc64, nc65, 
        nc66, nc67, nc68, nc69, nc70, nc71, nc72, nc73, nc74, nc75, 
        nc76, nc77, nc78, nc79, A_DOUT[3], A_DOUT[2]}), .B_DOUT({nc80, 
        nc81, nc82, nc83, nc84, nc85, nc86, nc87, nc88, nc89, nc90, 
        nc91, nc92, nc93, nc94, nc95, B_DOUT[3], B_DOUT[2]}), .BUSY(), 
        .A_CLK(A_CLK), .A_DOUT_CLK(VCC), .A_ARST_N(VCC), .A_DOUT_EN(
        VCC), .A_BLK({VCC, VCC, VCC}), .A_DOUT_ARST_N(VCC), 
        .A_DOUT_SRST_N(VCC), .A_DIN({GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, GND, GND, GND, GND, GND, GND, A_DIN[3], 
        A_DIN[2]}), .A_ADDR({A_ADDR[12], A_ADDR[11], A_ADDR[10], 
        A_ADDR[9], A_ADDR[8], A_ADDR[7], A_ADDR[6], A_ADDR[5], 
        A_ADDR[4], A_ADDR[3], A_ADDR[2], A_ADDR[1], A_ADDR[0], GND}), 
        .A_WEN({GND, A_WEN}), .B_CLK(B_CLK), .B_DOUT_CLK(VCC), 
        .B_ARST_N(VCC), .B_DOUT_EN(VCC), .B_BLK({VCC, VCC, VCC}), 
        .B_DOUT_ARST_N(VCC), .B_DOUT_SRST_N(VCC), .B_DIN({GND, GND, 
        GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, B_DIN[3], B_DIN[2]}), .B_ADDR({B_ADDR[12], 
        B_ADDR[11], B_ADDR[10], B_ADDR[9], B_ADDR[8], B_ADDR[7], 
        B_ADDR[6], B_ADDR[5], B_ADDR[4], B_ADDR[3], B_ADDR[2], 
        B_ADDR[1], B_ADDR[0], GND}), .B_WEN({GND, B_WEN}), .A_EN(VCC), 
        .A_DOUT_LAT(VCC), .A_WIDTH({GND, GND, VCC}), .A_WMODE(GND), 
        .B_EN(VCC), .B_DOUT_LAT(VCC), .B_WIDTH({GND, GND, VCC}), 
        .B_WMODE(GND), .SII_LOCK(GND));
    RAM1K18 #( .MEMORYFILE("RAM_8K_8_DP_RAM_8K_8_DP_0_DPSRAM_R0C0.mem")
         )  RAM_8K_8_DP_RAM_8K_8_DP_0_DPSRAM_R0C0 (.A_DOUT({nc96, nc97, 
        nc98, nc99, nc100, nc101, nc102, nc103, nc104, nc105, nc106, 
        nc107, nc108, nc109, nc110, nc111, A_DOUT[1], A_DOUT[0]}), 
        .B_DOUT({nc112, nc113, nc114, nc115, nc116, nc117, nc118, 
        nc119, nc120, nc121, nc122, nc123, nc124, nc125, nc126, nc127, 
        B_DOUT[1], B_DOUT[0]}), .BUSY(), .A_CLK(A_CLK), .A_DOUT_CLK(
        VCC), .A_ARST_N(VCC), .A_DOUT_EN(VCC), .A_BLK({VCC, VCC, VCC}), 
        .A_DOUT_ARST_N(VCC), .A_DOUT_SRST_N(VCC), .A_DIN({GND, GND, 
        GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, A_DIN[1], A_DIN[0]}), .A_ADDR({A_ADDR[12], 
        A_ADDR[11], A_ADDR[10], A_ADDR[9], A_ADDR[8], A_ADDR[7], 
        A_ADDR[6], A_ADDR[5], A_ADDR[4], A_ADDR[3], A_ADDR[2], 
        A_ADDR[1], A_ADDR[0], GND}), .A_WEN({GND, A_WEN}), .B_CLK(
        B_CLK), .B_DOUT_CLK(VCC), .B_ARST_N(VCC), .B_DOUT_EN(VCC), 
        .B_BLK({VCC, VCC, VCC}), .B_DOUT_ARST_N(VCC), .B_DOUT_SRST_N(
        VCC), .B_DIN({GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, GND, GND, GND, B_DIN[1], B_DIN[0]}), .B_ADDR({
        B_ADDR[12], B_ADDR[11], B_ADDR[10], B_ADDR[9], B_ADDR[8], 
        B_ADDR[7], B_ADDR[6], B_ADDR[5], B_ADDR[4], B_ADDR[3], 
        B_ADDR[2], B_ADDR[1], B_ADDR[0], GND}), .B_WEN({GND, B_WEN}), 
        .A_EN(VCC), .A_DOUT_LAT(VCC), .A_WIDTH({GND, GND, VCC}), 
        .A_WMODE(GND), .B_EN(VCC), .B_DOUT_LAT(VCC), .B_WIDTH({GND, 
        GND, VCC}), .B_WMODE(GND), .SII_LOCK(GND));
    GND GND_power_inst1 (.Y(GND_power_net1));
    VCC VCC_power_inst1 (.Y(VCC_power_net1));
    
endmodule
