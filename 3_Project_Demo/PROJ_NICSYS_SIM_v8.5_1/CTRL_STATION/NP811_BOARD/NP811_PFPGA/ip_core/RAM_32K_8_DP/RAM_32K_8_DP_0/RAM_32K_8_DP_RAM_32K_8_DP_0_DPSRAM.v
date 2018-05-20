`timescale 1 ns/100 ps
// Version: v11.5 SP3 11.5.3.10


module RAM_32K_8_DP_RAM_32K_8_DP_0_DPSRAM(
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
input  [14:0] A_ADDR;
input  [14:0] B_ADDR;
input  A_CLK;
input  B_CLK;
input  A_WEN;
input  B_WEN;

    wire \QBX_TEMPR0[0] , \QBX_TEMPR1[0] , \QBX_TEMPR0[1] , 
        \QBX_TEMPR1[1] , \QBX_TEMPR0[2] , \QBX_TEMPR1[2] , 
        \QBX_TEMPR0[3] , \QBX_TEMPR1[3] , \QBX_TEMPR0[4] , 
        \QBX_TEMPR1[4] , \QBX_TEMPR0[5] , \QBX_TEMPR1[5] , 
        \QBX_TEMPR0[6] , \QBX_TEMPR1[6] , \QBX_TEMPR0[7] , 
        \QBX_TEMPR1[7] , \QAX_TEMPR0[0] , \QAX_TEMPR1[0] , 
        \QAX_TEMPR0[1] , \QAX_TEMPR1[1] , \QAX_TEMPR0[2] , 
        \QAX_TEMPR1[2] , \QAX_TEMPR0[3] , \QAX_TEMPR1[3] , 
        \QAX_TEMPR0[4] , \QAX_TEMPR1[4] , \QAX_TEMPR0[5] , 
        \QAX_TEMPR1[5] , \QAX_TEMPR0[6] , \QAX_TEMPR1[6] , 
        \QAX_TEMPR0[7] , \QAX_TEMPR1[7] , \BLKX0[0] , \BLKY0[0] , VCC, 
        GND, ADLIB_VCC;
    wire GND_power_net1;
    wire VCC_power_net1;
    assign GND = GND_power_net1;
    assign VCC = VCC_power_net1;
    assign ADLIB_VCC = VCC_power_net1;
    
    OR2 \OR2_A_DOUT[6]  (.A(\QAX_TEMPR0[6] ), .B(\QAX_TEMPR1[6] ), .Y(
        A_DOUT[6]));
    RAM1K18 RAM_32K_8_DP_RAM_32K_8_DP_0_DPSRAM_R0C6 (.A_DOUT({nc0, nc1, 
        nc2, nc3, nc4, nc5, nc6, nc7, nc8, nc9, nc10, nc11, nc12, nc13, 
        nc14, nc15, nc16, \QAX_TEMPR0[6] }), .B_DOUT({nc17, nc18, nc19, 
        nc20, nc21, nc22, nc23, nc24, nc25, nc26, nc27, nc28, nc29, 
        nc30, nc31, nc32, nc33, \QBX_TEMPR0[6] }), .BUSY(), .A_CLK(
        A_CLK), .A_DOUT_CLK(VCC), .A_ARST_N(VCC), .A_DOUT_EN(VCC), 
        .A_BLK({VCC, VCC, \BLKX0[0] }), .A_DOUT_ARST_N(VCC), 
        .A_DOUT_SRST_N(VCC), .A_DIN({GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, A_DIN[6]}), 
        .A_ADDR({A_ADDR[13], A_ADDR[12], A_ADDR[11], A_ADDR[10], 
        A_ADDR[9], A_ADDR[8], A_ADDR[7], A_ADDR[6], A_ADDR[5], 
        A_ADDR[4], A_ADDR[3], A_ADDR[2], A_ADDR[1], A_ADDR[0]}), 
        .A_WEN({GND, A_WEN}), .B_CLK(B_CLK), .B_DOUT_CLK(VCC), 
        .B_ARST_N(VCC), .B_DOUT_EN(VCC), .B_BLK({VCC, VCC, \BLKY0[0] })
        , .B_DOUT_ARST_N(VCC), .B_DOUT_SRST_N(VCC), .B_DIN({GND, GND, 
        GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, B_DIN[6]}), .B_ADDR({B_ADDR[13], B_ADDR[12], 
        B_ADDR[11], B_ADDR[10], B_ADDR[9], B_ADDR[8], B_ADDR[7], 
        B_ADDR[6], B_ADDR[5], B_ADDR[4], B_ADDR[3], B_ADDR[2], 
        B_ADDR[1], B_ADDR[0]}), .B_WEN({GND, B_WEN}), .A_EN(VCC), 
        .A_DOUT_LAT(VCC), .A_WIDTH({GND, GND, GND}), .A_WMODE(GND), 
        .B_EN(VCC), .B_DOUT_LAT(VCC), .B_WIDTH({GND, GND, GND}), 
        .B_WMODE(GND), .SII_LOCK(GND));
    OR2 \OR2_B_DOUT[6]  (.A(\QBX_TEMPR0[6] ), .B(\QBX_TEMPR1[6] ), .Y(
        B_DOUT[6]));
    RAM1K18 RAM_32K_8_DP_RAM_32K_8_DP_0_DPSRAM_R1C5 (.A_DOUT({nc34, 
        nc35, nc36, nc37, nc38, nc39, nc40, nc41, nc42, nc43, nc44, 
        nc45, nc46, nc47, nc48, nc49, nc50, \QAX_TEMPR1[5] }), .B_DOUT({
        nc51, nc52, nc53, nc54, nc55, nc56, nc57, nc58, nc59, nc60, 
        nc61, nc62, nc63, nc64, nc65, nc66, nc67, \QBX_TEMPR1[5] }), 
        .BUSY(), .A_CLK(A_CLK), .A_DOUT_CLK(VCC), .A_ARST_N(VCC), 
        .A_DOUT_EN(VCC), .A_BLK({VCC, VCC, A_ADDR[14]}), 
        .A_DOUT_ARST_N(VCC), .A_DOUT_SRST_N(VCC), .A_DIN({GND, GND, 
        GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, A_DIN[5]}), .A_ADDR({A_ADDR[13], A_ADDR[12], 
        A_ADDR[11], A_ADDR[10], A_ADDR[9], A_ADDR[8], A_ADDR[7], 
        A_ADDR[6], A_ADDR[5], A_ADDR[4], A_ADDR[3], A_ADDR[2], 
        A_ADDR[1], A_ADDR[0]}), .A_WEN({GND, A_WEN}), .B_CLK(B_CLK), 
        .B_DOUT_CLK(VCC), .B_ARST_N(VCC), .B_DOUT_EN(VCC), .B_BLK({VCC, 
        VCC, B_ADDR[14]}), .B_DOUT_ARST_N(VCC), .B_DOUT_SRST_N(VCC), 
        .B_DIN({GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, GND, GND, GND, B_DIN[5]}), .B_ADDR({B_ADDR[13], 
        B_ADDR[12], B_ADDR[11], B_ADDR[10], B_ADDR[9], B_ADDR[8], 
        B_ADDR[7], B_ADDR[6], B_ADDR[5], B_ADDR[4], B_ADDR[3], 
        B_ADDR[2], B_ADDR[1], B_ADDR[0]}), .B_WEN({GND, B_WEN}), .A_EN(
        VCC), .A_DOUT_LAT(VCC), .A_WIDTH({GND, GND, GND}), .A_WMODE(
        GND), .B_EN(VCC), .B_DOUT_LAT(VCC), .B_WIDTH({GND, GND, GND}), 
        .B_WMODE(GND), .SII_LOCK(GND));
    OR2 \OR2_B_DOUT[0]  (.A(\QBX_TEMPR0[0] ), .B(\QBX_TEMPR1[0] ), .Y(
        B_DOUT[0]));
    OR2 \OR2_A_DOUT[0]  (.A(\QAX_TEMPR0[0] ), .B(\QAX_TEMPR1[0] ), .Y(
        A_DOUT[0]));
    INV \INVBLKX0[0]  (.A(A_ADDR[14]), .Y(\BLKX0[0] ));
    RAM1K18 RAM_32K_8_DP_RAM_32K_8_DP_0_DPSRAM_R0C1 (.A_DOUT({nc68, 
        nc69, nc70, nc71, nc72, nc73, nc74, nc75, nc76, nc77, nc78, 
        nc79, nc80, nc81, nc82, nc83, nc84, \QAX_TEMPR0[1] }), .B_DOUT({
        nc85, nc86, nc87, nc88, nc89, nc90, nc91, nc92, nc93, nc94, 
        nc95, nc96, nc97, nc98, nc99, nc100, nc101, \QBX_TEMPR0[1] }), 
        .BUSY(), .A_CLK(A_CLK), .A_DOUT_CLK(VCC), .A_ARST_N(VCC), 
        .A_DOUT_EN(VCC), .A_BLK({VCC, VCC, \BLKX0[0] }), 
        .A_DOUT_ARST_N(VCC), .A_DOUT_SRST_N(VCC), .A_DIN({GND, GND, 
        GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, A_DIN[1]}), .A_ADDR({A_ADDR[13], A_ADDR[12], 
        A_ADDR[11], A_ADDR[10], A_ADDR[9], A_ADDR[8], A_ADDR[7], 
        A_ADDR[6], A_ADDR[5], A_ADDR[4], A_ADDR[3], A_ADDR[2], 
        A_ADDR[1], A_ADDR[0]}), .A_WEN({GND, A_WEN}), .B_CLK(B_CLK), 
        .B_DOUT_CLK(VCC), .B_ARST_N(VCC), .B_DOUT_EN(VCC), .B_BLK({VCC, 
        VCC, \BLKY0[0] }), .B_DOUT_ARST_N(VCC), .B_DOUT_SRST_N(VCC), 
        .B_DIN({GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, GND, GND, GND, B_DIN[1]}), .B_ADDR({B_ADDR[13], 
        B_ADDR[12], B_ADDR[11], B_ADDR[10], B_ADDR[9], B_ADDR[8], 
        B_ADDR[7], B_ADDR[6], B_ADDR[5], B_ADDR[4], B_ADDR[3], 
        B_ADDR[2], B_ADDR[1], B_ADDR[0]}), .B_WEN({GND, B_WEN}), .A_EN(
        VCC), .A_DOUT_LAT(VCC), .A_WIDTH({GND, GND, GND}), .A_WMODE(
        GND), .B_EN(VCC), .B_DOUT_LAT(VCC), .B_WIDTH({GND, GND, GND}), 
        .B_WMODE(GND), .SII_LOCK(GND));
    RAM1K18 RAM_32K_8_DP_RAM_32K_8_DP_0_DPSRAM_R0C4 (.A_DOUT({nc102, 
        nc103, nc104, nc105, nc106, nc107, nc108, nc109, nc110, nc111, 
        nc112, nc113, nc114, nc115, nc116, nc117, nc118, 
        \QAX_TEMPR0[4] }), .B_DOUT({nc119, nc120, nc121, nc122, nc123, 
        nc124, nc125, nc126, nc127, nc128, nc129, nc130, nc131, nc132, 
        nc133, nc134, nc135, \QBX_TEMPR0[4] }), .BUSY(), .A_CLK(A_CLK), 
        .A_DOUT_CLK(VCC), .A_ARST_N(VCC), .A_DOUT_EN(VCC), .A_BLK({VCC, 
        VCC, \BLKX0[0] }), .A_DOUT_ARST_N(VCC), .A_DOUT_SRST_N(VCC), 
        .A_DIN({GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, GND, GND, GND, A_DIN[4]}), .A_ADDR({A_ADDR[13], 
        A_ADDR[12], A_ADDR[11], A_ADDR[10], A_ADDR[9], A_ADDR[8], 
        A_ADDR[7], A_ADDR[6], A_ADDR[5], A_ADDR[4], A_ADDR[3], 
        A_ADDR[2], A_ADDR[1], A_ADDR[0]}), .A_WEN({GND, A_WEN}), 
        .B_CLK(B_CLK), .B_DOUT_CLK(VCC), .B_ARST_N(VCC), .B_DOUT_EN(
        VCC), .B_BLK({VCC, VCC, \BLKY0[0] }), .B_DOUT_ARST_N(VCC), 
        .B_DOUT_SRST_N(VCC), .B_DIN({GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, B_DIN[4]}), 
        .B_ADDR({B_ADDR[13], B_ADDR[12], B_ADDR[11], B_ADDR[10], 
        B_ADDR[9], B_ADDR[8], B_ADDR[7], B_ADDR[6], B_ADDR[5], 
        B_ADDR[4], B_ADDR[3], B_ADDR[2], B_ADDR[1], B_ADDR[0]}), 
        .B_WEN({GND, B_WEN}), .A_EN(VCC), .A_DOUT_LAT(VCC), .A_WIDTH({
        GND, GND, GND}), .A_WMODE(GND), .B_EN(VCC), .B_DOUT_LAT(VCC), 
        .B_WIDTH({GND, GND, GND}), .B_WMODE(GND), .SII_LOCK(GND));
    RAM1K18 RAM_32K_8_DP_RAM_32K_8_DP_0_DPSRAM_R0C3 (.A_DOUT({nc136, 
        nc137, nc138, nc139, nc140, nc141, nc142, nc143, nc144, nc145, 
        nc146, nc147, nc148, nc149, nc150, nc151, nc152, 
        \QAX_TEMPR0[3] }), .B_DOUT({nc153, nc154, nc155, nc156, nc157, 
        nc158, nc159, nc160, nc161, nc162, nc163, nc164, nc165, nc166, 
        nc167, nc168, nc169, \QBX_TEMPR0[3] }), .BUSY(), .A_CLK(A_CLK), 
        .A_DOUT_CLK(VCC), .A_ARST_N(VCC), .A_DOUT_EN(VCC), .A_BLK({VCC, 
        VCC, \BLKX0[0] }), .A_DOUT_ARST_N(VCC), .A_DOUT_SRST_N(VCC), 
        .A_DIN({GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, GND, GND, GND, A_DIN[3]}), .A_ADDR({A_ADDR[13], 
        A_ADDR[12], A_ADDR[11], A_ADDR[10], A_ADDR[9], A_ADDR[8], 
        A_ADDR[7], A_ADDR[6], A_ADDR[5], A_ADDR[4], A_ADDR[3], 
        A_ADDR[2], A_ADDR[1], A_ADDR[0]}), .A_WEN({GND, A_WEN}), 
        .B_CLK(B_CLK), .B_DOUT_CLK(VCC), .B_ARST_N(VCC), .B_DOUT_EN(
        VCC), .B_BLK({VCC, VCC, \BLKY0[0] }), .B_DOUT_ARST_N(VCC), 
        .B_DOUT_SRST_N(VCC), .B_DIN({GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, B_DIN[3]}), 
        .B_ADDR({B_ADDR[13], B_ADDR[12], B_ADDR[11], B_ADDR[10], 
        B_ADDR[9], B_ADDR[8], B_ADDR[7], B_ADDR[6], B_ADDR[5], 
        B_ADDR[4], B_ADDR[3], B_ADDR[2], B_ADDR[1], B_ADDR[0]}), 
        .B_WEN({GND, B_WEN}), .A_EN(VCC), .A_DOUT_LAT(VCC), .A_WIDTH({
        GND, GND, GND}), .A_WMODE(GND), .B_EN(VCC), .B_DOUT_LAT(VCC), 
        .B_WIDTH({GND, GND, GND}), .B_WMODE(GND), .SII_LOCK(GND));
    OR2 \OR2_B_DOUT[5]  (.A(\QBX_TEMPR0[5] ), .B(\QBX_TEMPR1[5] ), .Y(
        B_DOUT[5]));
    OR2 \OR2_A_DOUT[5]  (.A(\QAX_TEMPR0[5] ), .B(\QAX_TEMPR1[5] ), .Y(
        A_DOUT[5]));
    RAM1K18 RAM_32K_8_DP_RAM_32K_8_DP_0_DPSRAM_R1C0 (.A_DOUT({nc170, 
        nc171, nc172, nc173, nc174, nc175, nc176, nc177, nc178, nc179, 
        nc180, nc181, nc182, nc183, nc184, nc185, nc186, 
        \QAX_TEMPR1[0] }), .B_DOUT({nc187, nc188, nc189, nc190, nc191, 
        nc192, nc193, nc194, nc195, nc196, nc197, nc198, nc199, nc200, 
        nc201, nc202, nc203, \QBX_TEMPR1[0] }), .BUSY(), .A_CLK(A_CLK), 
        .A_DOUT_CLK(VCC), .A_ARST_N(VCC), .A_DOUT_EN(VCC), .A_BLK({VCC, 
        VCC, A_ADDR[14]}), .A_DOUT_ARST_N(VCC), .A_DOUT_SRST_N(VCC), 
        .A_DIN({GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, GND, GND, GND, A_DIN[0]}), .A_ADDR({A_ADDR[13], 
        A_ADDR[12], A_ADDR[11], A_ADDR[10], A_ADDR[9], A_ADDR[8], 
        A_ADDR[7], A_ADDR[6], A_ADDR[5], A_ADDR[4], A_ADDR[3], 
        A_ADDR[2], A_ADDR[1], A_ADDR[0]}), .A_WEN({GND, A_WEN}), 
        .B_CLK(B_CLK), .B_DOUT_CLK(VCC), .B_ARST_N(VCC), .B_DOUT_EN(
        VCC), .B_BLK({VCC, VCC, B_ADDR[14]}), .B_DOUT_ARST_N(VCC), 
        .B_DOUT_SRST_N(VCC), .B_DIN({GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, B_DIN[0]}), 
        .B_ADDR({B_ADDR[13], B_ADDR[12], B_ADDR[11], B_ADDR[10], 
        B_ADDR[9], B_ADDR[8], B_ADDR[7], B_ADDR[6], B_ADDR[5], 
        B_ADDR[4], B_ADDR[3], B_ADDR[2], B_ADDR[1], B_ADDR[0]}), 
        .B_WEN({GND, B_WEN}), .A_EN(VCC), .A_DOUT_LAT(VCC), .A_WIDTH({
        GND, GND, GND}), .A_WMODE(GND), .B_EN(VCC), .B_DOUT_LAT(VCC), 
        .B_WIDTH({GND, GND, GND}), .B_WMODE(GND), .SII_LOCK(GND));
    OR2 \OR2_B_DOUT[2]  (.A(\QBX_TEMPR0[2] ), .B(\QBX_TEMPR1[2] ), .Y(
        B_DOUT[2]));
    OR2 \OR2_A_DOUT[2]  (.A(\QAX_TEMPR0[2] ), .B(\QAX_TEMPR1[2] ), .Y(
        A_DOUT[2]));
    RAM1K18 RAM_32K_8_DP_RAM_32K_8_DP_0_DPSRAM_R1C1 (.A_DOUT({nc204, 
        nc205, nc206, nc207, nc208, nc209, nc210, nc211, nc212, nc213, 
        nc214, nc215, nc216, nc217, nc218, nc219, nc220, 
        \QAX_TEMPR1[1] }), .B_DOUT({nc221, nc222, nc223, nc224, nc225, 
        nc226, nc227, nc228, nc229, nc230, nc231, nc232, nc233, nc234, 
        nc235, nc236, nc237, \QBX_TEMPR1[1] }), .BUSY(), .A_CLK(A_CLK), 
        .A_DOUT_CLK(VCC), .A_ARST_N(VCC), .A_DOUT_EN(VCC), .A_BLK({VCC, 
        VCC, A_ADDR[14]}), .A_DOUT_ARST_N(VCC), .A_DOUT_SRST_N(VCC), 
        .A_DIN({GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, GND, GND, GND, A_DIN[1]}), .A_ADDR({A_ADDR[13], 
        A_ADDR[12], A_ADDR[11], A_ADDR[10], A_ADDR[9], A_ADDR[8], 
        A_ADDR[7], A_ADDR[6], A_ADDR[5], A_ADDR[4], A_ADDR[3], 
        A_ADDR[2], A_ADDR[1], A_ADDR[0]}), .A_WEN({GND, A_WEN}), 
        .B_CLK(B_CLK), .B_DOUT_CLK(VCC), .B_ARST_N(VCC), .B_DOUT_EN(
        VCC), .B_BLK({VCC, VCC, B_ADDR[14]}), .B_DOUT_ARST_N(VCC), 
        .B_DOUT_SRST_N(VCC), .B_DIN({GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, B_DIN[1]}), 
        .B_ADDR({B_ADDR[13], B_ADDR[12], B_ADDR[11], B_ADDR[10], 
        B_ADDR[9], B_ADDR[8], B_ADDR[7], B_ADDR[6], B_ADDR[5], 
        B_ADDR[4], B_ADDR[3], B_ADDR[2], B_ADDR[1], B_ADDR[0]}), 
        .B_WEN({GND, B_WEN}), .A_EN(VCC), .A_DOUT_LAT(VCC), .A_WIDTH({
        GND, GND, GND}), .A_WMODE(GND), .B_EN(VCC), .B_DOUT_LAT(VCC), 
        .B_WIDTH({GND, GND, GND}), .B_WMODE(GND), .SII_LOCK(GND));
    RAM1K18 RAM_32K_8_DP_RAM_32K_8_DP_0_DPSRAM_R1C6 (.A_DOUT({nc238, 
        nc239, nc240, nc241, nc242, nc243, nc244, nc245, nc246, nc247, 
        nc248, nc249, nc250, nc251, nc252, nc253, nc254, 
        \QAX_TEMPR1[6] }), .B_DOUT({nc255, nc256, nc257, nc258, nc259, 
        nc260, nc261, nc262, nc263, nc264, nc265, nc266, nc267, nc268, 
        nc269, nc270, nc271, \QBX_TEMPR1[6] }), .BUSY(), .A_CLK(A_CLK), 
        .A_DOUT_CLK(VCC), .A_ARST_N(VCC), .A_DOUT_EN(VCC), .A_BLK({VCC, 
        VCC, A_ADDR[14]}), .A_DOUT_ARST_N(VCC), .A_DOUT_SRST_N(VCC), 
        .A_DIN({GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, GND, GND, GND, A_DIN[6]}), .A_ADDR({A_ADDR[13], 
        A_ADDR[12], A_ADDR[11], A_ADDR[10], A_ADDR[9], A_ADDR[8], 
        A_ADDR[7], A_ADDR[6], A_ADDR[5], A_ADDR[4], A_ADDR[3], 
        A_ADDR[2], A_ADDR[1], A_ADDR[0]}), .A_WEN({GND, A_WEN}), 
        .B_CLK(B_CLK), .B_DOUT_CLK(VCC), .B_ARST_N(VCC), .B_DOUT_EN(
        VCC), .B_BLK({VCC, VCC, B_ADDR[14]}), .B_DOUT_ARST_N(VCC), 
        .B_DOUT_SRST_N(VCC), .B_DIN({GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, B_DIN[6]}), 
        .B_ADDR({B_ADDR[13], B_ADDR[12], B_ADDR[11], B_ADDR[10], 
        B_ADDR[9], B_ADDR[8], B_ADDR[7], B_ADDR[6], B_ADDR[5], 
        B_ADDR[4], B_ADDR[3], B_ADDR[2], B_ADDR[1], B_ADDR[0]}), 
        .B_WEN({GND, B_WEN}), .A_EN(VCC), .A_DOUT_LAT(VCC), .A_WIDTH({
        GND, GND, GND}), .A_WMODE(GND), .B_EN(VCC), .B_DOUT_LAT(VCC), 
        .B_WIDTH({GND, GND, GND}), .B_WMODE(GND), .SII_LOCK(GND));
    RAM1K18 RAM_32K_8_DP_RAM_32K_8_DP_0_DPSRAM_R0C0 (.A_DOUT({nc272, 
        nc273, nc274, nc275, nc276, nc277, nc278, nc279, nc280, nc281, 
        nc282, nc283, nc284, nc285, nc286, nc287, nc288, 
        \QAX_TEMPR0[0] }), .B_DOUT({nc289, nc290, nc291, nc292, nc293, 
        nc294, nc295, nc296, nc297, nc298, nc299, nc300, nc301, nc302, 
        nc303, nc304, nc305, \QBX_TEMPR0[0] }), .BUSY(), .A_CLK(A_CLK), 
        .A_DOUT_CLK(VCC), .A_ARST_N(VCC), .A_DOUT_EN(VCC), .A_BLK({VCC, 
        VCC, \BLKX0[0] }), .A_DOUT_ARST_N(VCC), .A_DOUT_SRST_N(VCC), 
        .A_DIN({GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, GND, GND, GND, A_DIN[0]}), .A_ADDR({A_ADDR[13], 
        A_ADDR[12], A_ADDR[11], A_ADDR[10], A_ADDR[9], A_ADDR[8], 
        A_ADDR[7], A_ADDR[6], A_ADDR[5], A_ADDR[4], A_ADDR[3], 
        A_ADDR[2], A_ADDR[1], A_ADDR[0]}), .A_WEN({GND, A_WEN}), 
        .B_CLK(B_CLK), .B_DOUT_CLK(VCC), .B_ARST_N(VCC), .B_DOUT_EN(
        VCC), .B_BLK({VCC, VCC, \BLKY0[0] }), .B_DOUT_ARST_N(VCC), 
        .B_DOUT_SRST_N(VCC), .B_DIN({GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, B_DIN[0]}), 
        .B_ADDR({B_ADDR[13], B_ADDR[12], B_ADDR[11], B_ADDR[10], 
        B_ADDR[9], B_ADDR[8], B_ADDR[7], B_ADDR[6], B_ADDR[5], 
        B_ADDR[4], B_ADDR[3], B_ADDR[2], B_ADDR[1], B_ADDR[0]}), 
        .B_WEN({GND, B_WEN}), .A_EN(VCC), .A_DOUT_LAT(VCC), .A_WIDTH({
        GND, GND, GND}), .A_WMODE(GND), .B_EN(VCC), .B_DOUT_LAT(VCC), 
        .B_WIDTH({GND, GND, GND}), .B_WMODE(GND), .SII_LOCK(GND));
    OR2 \OR2_B_DOUT[7]  (.A(\QBX_TEMPR0[7] ), .B(\QBX_TEMPR1[7] ), .Y(
        B_DOUT[7]));
    OR2 \OR2_A_DOUT[7]  (.A(\QAX_TEMPR0[7] ), .B(\QAX_TEMPR1[7] ), .Y(
        A_DOUT[7]));
    OR2 \OR2_B_DOUT[3]  (.A(\QBX_TEMPR0[3] ), .B(\QBX_TEMPR1[3] ), .Y(
        B_DOUT[3]));
    OR2 \OR2_A_DOUT[3]  (.A(\QAX_TEMPR0[3] ), .B(\QAX_TEMPR1[3] ), .Y(
        A_DOUT[3]));
    RAM1K18 RAM_32K_8_DP_RAM_32K_8_DP_0_DPSRAM_R0C5 (.A_DOUT({nc306, 
        nc307, nc308, nc309, nc310, nc311, nc312, nc313, nc314, nc315, 
        nc316, nc317, nc318, nc319, nc320, nc321, nc322, 
        \QAX_TEMPR0[5] }), .B_DOUT({nc323, nc324, nc325, nc326, nc327, 
        nc328, nc329, nc330, nc331, nc332, nc333, nc334, nc335, nc336, 
        nc337, nc338, nc339, \QBX_TEMPR0[5] }), .BUSY(), .A_CLK(A_CLK), 
        .A_DOUT_CLK(VCC), .A_ARST_N(VCC), .A_DOUT_EN(VCC), .A_BLK({VCC, 
        VCC, \BLKX0[0] }), .A_DOUT_ARST_N(VCC), .A_DOUT_SRST_N(VCC), 
        .A_DIN({GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, GND, GND, GND, A_DIN[5]}), .A_ADDR({A_ADDR[13], 
        A_ADDR[12], A_ADDR[11], A_ADDR[10], A_ADDR[9], A_ADDR[8], 
        A_ADDR[7], A_ADDR[6], A_ADDR[5], A_ADDR[4], A_ADDR[3], 
        A_ADDR[2], A_ADDR[1], A_ADDR[0]}), .A_WEN({GND, A_WEN}), 
        .B_CLK(B_CLK), .B_DOUT_CLK(VCC), .B_ARST_N(VCC), .B_DOUT_EN(
        VCC), .B_BLK({VCC, VCC, \BLKY0[0] }), .B_DOUT_ARST_N(VCC), 
        .B_DOUT_SRST_N(VCC), .B_DIN({GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, B_DIN[5]}), 
        .B_ADDR({B_ADDR[13], B_ADDR[12], B_ADDR[11], B_ADDR[10], 
        B_ADDR[9], B_ADDR[8], B_ADDR[7], B_ADDR[6], B_ADDR[5], 
        B_ADDR[4], B_ADDR[3], B_ADDR[2], B_ADDR[1], B_ADDR[0]}), 
        .B_WEN({GND, B_WEN}), .A_EN(VCC), .A_DOUT_LAT(VCC), .A_WIDTH({
        GND, GND, GND}), .A_WMODE(GND), .B_EN(VCC), .B_DOUT_LAT(VCC), 
        .B_WIDTH({GND, GND, GND}), .B_WMODE(GND), .SII_LOCK(GND));
    RAM1K18 RAM_32K_8_DP_RAM_32K_8_DP_0_DPSRAM_R0C7 (.A_DOUT({nc340, 
        nc341, nc342, nc343, nc344, nc345, nc346, nc347, nc348, nc349, 
        nc350, nc351, nc352, nc353, nc354, nc355, nc356, 
        \QAX_TEMPR0[7] }), .B_DOUT({nc357, nc358, nc359, nc360, nc361, 
        nc362, nc363, nc364, nc365, nc366, nc367, nc368, nc369, nc370, 
        nc371, nc372, nc373, \QBX_TEMPR0[7] }), .BUSY(), .A_CLK(A_CLK), 
        .A_DOUT_CLK(VCC), .A_ARST_N(VCC), .A_DOUT_EN(VCC), .A_BLK({VCC, 
        VCC, \BLKX0[0] }), .A_DOUT_ARST_N(VCC), .A_DOUT_SRST_N(VCC), 
        .A_DIN({GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, GND, GND, GND, A_DIN[7]}), .A_ADDR({A_ADDR[13], 
        A_ADDR[12], A_ADDR[11], A_ADDR[10], A_ADDR[9], A_ADDR[8], 
        A_ADDR[7], A_ADDR[6], A_ADDR[5], A_ADDR[4], A_ADDR[3], 
        A_ADDR[2], A_ADDR[1], A_ADDR[0]}), .A_WEN({GND, A_WEN}), 
        .B_CLK(B_CLK), .B_DOUT_CLK(VCC), .B_ARST_N(VCC), .B_DOUT_EN(
        VCC), .B_BLK({VCC, VCC, \BLKY0[0] }), .B_DOUT_ARST_N(VCC), 
        .B_DOUT_SRST_N(VCC), .B_DIN({GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, B_DIN[7]}), 
        .B_ADDR({B_ADDR[13], B_ADDR[12], B_ADDR[11], B_ADDR[10], 
        B_ADDR[9], B_ADDR[8], B_ADDR[7], B_ADDR[6], B_ADDR[5], 
        B_ADDR[4], B_ADDR[3], B_ADDR[2], B_ADDR[1], B_ADDR[0]}), 
        .B_WEN({GND, B_WEN}), .A_EN(VCC), .A_DOUT_LAT(VCC), .A_WIDTH({
        GND, GND, GND}), .A_WMODE(GND), .B_EN(VCC), .B_DOUT_LAT(VCC), 
        .B_WIDTH({GND, GND, GND}), .B_WMODE(GND), .SII_LOCK(GND));
    INV \INVBLKY0[0]  (.A(B_ADDR[14]), .Y(\BLKY0[0] ));
    OR2 \OR2_A_DOUT[1]  (.A(\QAX_TEMPR0[1] ), .B(\QAX_TEMPR1[1] ), .Y(
        A_DOUT[1]));
    RAM1K18 RAM_32K_8_DP_RAM_32K_8_DP_0_DPSRAM_R1C7 (.A_DOUT({nc374, 
        nc375, nc376, nc377, nc378, nc379, nc380, nc381, nc382, nc383, 
        nc384, nc385, nc386, nc387, nc388, nc389, nc390, 
        \QAX_TEMPR1[7] }), .B_DOUT({nc391, nc392, nc393, nc394, nc395, 
        nc396, nc397, nc398, nc399, nc400, nc401, nc402, nc403, nc404, 
        nc405, nc406, nc407, \QBX_TEMPR1[7] }), .BUSY(), .A_CLK(A_CLK), 
        .A_DOUT_CLK(VCC), .A_ARST_N(VCC), .A_DOUT_EN(VCC), .A_BLK({VCC, 
        VCC, A_ADDR[14]}), .A_DOUT_ARST_N(VCC), .A_DOUT_SRST_N(VCC), 
        .A_DIN({GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, GND, GND, GND, A_DIN[7]}), .A_ADDR({A_ADDR[13], 
        A_ADDR[12], A_ADDR[11], A_ADDR[10], A_ADDR[9], A_ADDR[8], 
        A_ADDR[7], A_ADDR[6], A_ADDR[5], A_ADDR[4], A_ADDR[3], 
        A_ADDR[2], A_ADDR[1], A_ADDR[0]}), .A_WEN({GND, A_WEN}), 
        .B_CLK(B_CLK), .B_DOUT_CLK(VCC), .B_ARST_N(VCC), .B_DOUT_EN(
        VCC), .B_BLK({VCC, VCC, B_ADDR[14]}), .B_DOUT_ARST_N(VCC), 
        .B_DOUT_SRST_N(VCC), .B_DIN({GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, B_DIN[7]}), 
        .B_ADDR({B_ADDR[13], B_ADDR[12], B_ADDR[11], B_ADDR[10], 
        B_ADDR[9], B_ADDR[8], B_ADDR[7], B_ADDR[6], B_ADDR[5], 
        B_ADDR[4], B_ADDR[3], B_ADDR[2], B_ADDR[1], B_ADDR[0]}), 
        .B_WEN({GND, B_WEN}), .A_EN(VCC), .A_DOUT_LAT(VCC), .A_WIDTH({
        GND, GND, GND}), .A_WMODE(GND), .B_EN(VCC), .B_DOUT_LAT(VCC), 
        .B_WIDTH({GND, GND, GND}), .B_WMODE(GND), .SII_LOCK(GND));
    RAM1K18 RAM_32K_8_DP_RAM_32K_8_DP_0_DPSRAM_R1C4 (.A_DOUT({nc408, 
        nc409, nc410, nc411, nc412, nc413, nc414, nc415, nc416, nc417, 
        nc418, nc419, nc420, nc421, nc422, nc423, nc424, 
        \QAX_TEMPR1[4] }), .B_DOUT({nc425, nc426, nc427, nc428, nc429, 
        nc430, nc431, nc432, nc433, nc434, nc435, nc436, nc437, nc438, 
        nc439, nc440, nc441, \QBX_TEMPR1[4] }), .BUSY(), .A_CLK(A_CLK), 
        .A_DOUT_CLK(VCC), .A_ARST_N(VCC), .A_DOUT_EN(VCC), .A_BLK({VCC, 
        VCC, A_ADDR[14]}), .A_DOUT_ARST_N(VCC), .A_DOUT_SRST_N(VCC), 
        .A_DIN({GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, GND, GND, GND, A_DIN[4]}), .A_ADDR({A_ADDR[13], 
        A_ADDR[12], A_ADDR[11], A_ADDR[10], A_ADDR[9], A_ADDR[8], 
        A_ADDR[7], A_ADDR[6], A_ADDR[5], A_ADDR[4], A_ADDR[3], 
        A_ADDR[2], A_ADDR[1], A_ADDR[0]}), .A_WEN({GND, A_WEN}), 
        .B_CLK(B_CLK), .B_DOUT_CLK(VCC), .B_ARST_N(VCC), .B_DOUT_EN(
        VCC), .B_BLK({VCC, VCC, B_ADDR[14]}), .B_DOUT_ARST_N(VCC), 
        .B_DOUT_SRST_N(VCC), .B_DIN({GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, B_DIN[4]}), 
        .B_ADDR({B_ADDR[13], B_ADDR[12], B_ADDR[11], B_ADDR[10], 
        B_ADDR[9], B_ADDR[8], B_ADDR[7], B_ADDR[6], B_ADDR[5], 
        B_ADDR[4], B_ADDR[3], B_ADDR[2], B_ADDR[1], B_ADDR[0]}), 
        .B_WEN({GND, B_WEN}), .A_EN(VCC), .A_DOUT_LAT(VCC), .A_WIDTH({
        GND, GND, GND}), .A_WMODE(GND), .B_EN(VCC), .B_DOUT_LAT(VCC), 
        .B_WIDTH({GND, GND, GND}), .B_WMODE(GND), .SII_LOCK(GND));
    OR2 \OR2_B_DOUT[1]  (.A(\QBX_TEMPR0[1] ), .B(\QBX_TEMPR1[1] ), .Y(
        B_DOUT[1]));
    RAM1K18 RAM_32K_8_DP_RAM_32K_8_DP_0_DPSRAM_R1C3 (.A_DOUT({nc442, 
        nc443, nc444, nc445, nc446, nc447, nc448, nc449, nc450, nc451, 
        nc452, nc453, nc454, nc455, nc456, nc457, nc458, 
        \QAX_TEMPR1[3] }), .B_DOUT({nc459, nc460, nc461, nc462, nc463, 
        nc464, nc465, nc466, nc467, nc468, nc469, nc470, nc471, nc472, 
        nc473, nc474, nc475, \QBX_TEMPR1[3] }), .BUSY(), .A_CLK(A_CLK), 
        .A_DOUT_CLK(VCC), .A_ARST_N(VCC), .A_DOUT_EN(VCC), .A_BLK({VCC, 
        VCC, A_ADDR[14]}), .A_DOUT_ARST_N(VCC), .A_DOUT_SRST_N(VCC), 
        .A_DIN({GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, GND, GND, GND, A_DIN[3]}), .A_ADDR({A_ADDR[13], 
        A_ADDR[12], A_ADDR[11], A_ADDR[10], A_ADDR[9], A_ADDR[8], 
        A_ADDR[7], A_ADDR[6], A_ADDR[5], A_ADDR[4], A_ADDR[3], 
        A_ADDR[2], A_ADDR[1], A_ADDR[0]}), .A_WEN({GND, A_WEN}), 
        .B_CLK(B_CLK), .B_DOUT_CLK(VCC), .B_ARST_N(VCC), .B_DOUT_EN(
        VCC), .B_BLK({VCC, VCC, B_ADDR[14]}), .B_DOUT_ARST_N(VCC), 
        .B_DOUT_SRST_N(VCC), .B_DIN({GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, B_DIN[3]}), 
        .B_ADDR({B_ADDR[13], B_ADDR[12], B_ADDR[11], B_ADDR[10], 
        B_ADDR[9], B_ADDR[8], B_ADDR[7], B_ADDR[6], B_ADDR[5], 
        B_ADDR[4], B_ADDR[3], B_ADDR[2], B_ADDR[1], B_ADDR[0]}), 
        .B_WEN({GND, B_WEN}), .A_EN(VCC), .A_DOUT_LAT(VCC), .A_WIDTH({
        GND, GND, GND}), .A_WMODE(GND), .B_EN(VCC), .B_DOUT_LAT(VCC), 
        .B_WIDTH({GND, GND, GND}), .B_WMODE(GND), .SII_LOCK(GND));
    OR2 \OR2_B_DOUT[4]  (.A(\QBX_TEMPR0[4] ), .B(\QBX_TEMPR1[4] ), .Y(
        B_DOUT[4]));
    OR2 \OR2_A_DOUT[4]  (.A(\QAX_TEMPR0[4] ), .B(\QAX_TEMPR1[4] ), .Y(
        A_DOUT[4]));
    RAM1K18 RAM_32K_8_DP_RAM_32K_8_DP_0_DPSRAM_R0C2 (.A_DOUT({nc476, 
        nc477, nc478, nc479, nc480, nc481, nc482, nc483, nc484, nc485, 
        nc486, nc487, nc488, nc489, nc490, nc491, nc492, 
        \QAX_TEMPR0[2] }), .B_DOUT({nc493, nc494, nc495, nc496, nc497, 
        nc498, nc499, nc500, nc501, nc502, nc503, nc504, nc505, nc506, 
        nc507, nc508, nc509, \QBX_TEMPR0[2] }), .BUSY(), .A_CLK(A_CLK), 
        .A_DOUT_CLK(VCC), .A_ARST_N(VCC), .A_DOUT_EN(VCC), .A_BLK({VCC, 
        VCC, \BLKX0[0] }), .A_DOUT_ARST_N(VCC), .A_DOUT_SRST_N(VCC), 
        .A_DIN({GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, GND, GND, GND, A_DIN[2]}), .A_ADDR({A_ADDR[13], 
        A_ADDR[12], A_ADDR[11], A_ADDR[10], A_ADDR[9], A_ADDR[8], 
        A_ADDR[7], A_ADDR[6], A_ADDR[5], A_ADDR[4], A_ADDR[3], 
        A_ADDR[2], A_ADDR[1], A_ADDR[0]}), .A_WEN({GND, A_WEN}), 
        .B_CLK(B_CLK), .B_DOUT_CLK(VCC), .B_ARST_N(VCC), .B_DOUT_EN(
        VCC), .B_BLK({VCC, VCC, \BLKY0[0] }), .B_DOUT_ARST_N(VCC), 
        .B_DOUT_SRST_N(VCC), .B_DIN({GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, B_DIN[2]}), 
        .B_ADDR({B_ADDR[13], B_ADDR[12], B_ADDR[11], B_ADDR[10], 
        B_ADDR[9], B_ADDR[8], B_ADDR[7], B_ADDR[6], B_ADDR[5], 
        B_ADDR[4], B_ADDR[3], B_ADDR[2], B_ADDR[1], B_ADDR[0]}), 
        .B_WEN({GND, B_WEN}), .A_EN(VCC), .A_DOUT_LAT(VCC), .A_WIDTH({
        GND, GND, GND}), .A_WMODE(GND), .B_EN(VCC), .B_DOUT_LAT(VCC), 
        .B_WIDTH({GND, GND, GND}), .B_WMODE(GND), .SII_LOCK(GND));
    RAM1K18 RAM_32K_8_DP_RAM_32K_8_DP_0_DPSRAM_R1C2 (.A_DOUT({nc510, 
        nc511, nc512, nc513, nc514, nc515, nc516, nc517, nc518, nc519, 
        nc520, nc521, nc522, nc523, nc524, nc525, nc526, 
        \QAX_TEMPR1[2] }), .B_DOUT({nc527, nc528, nc529, nc530, nc531, 
        nc532, nc533, nc534, nc535, nc536, nc537, nc538, nc539, nc540, 
        nc541, nc542, nc543, \QBX_TEMPR1[2] }), .BUSY(), .A_CLK(A_CLK), 
        .A_DOUT_CLK(VCC), .A_ARST_N(VCC), .A_DOUT_EN(VCC), .A_BLK({VCC, 
        VCC, A_ADDR[14]}), .A_DOUT_ARST_N(VCC), .A_DOUT_SRST_N(VCC), 
        .A_DIN({GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, GND, GND, GND, A_DIN[2]}), .A_ADDR({A_ADDR[13], 
        A_ADDR[12], A_ADDR[11], A_ADDR[10], A_ADDR[9], A_ADDR[8], 
        A_ADDR[7], A_ADDR[6], A_ADDR[5], A_ADDR[4], A_ADDR[3], 
        A_ADDR[2], A_ADDR[1], A_ADDR[0]}), .A_WEN({GND, A_WEN}), 
        .B_CLK(B_CLK), .B_DOUT_CLK(VCC), .B_ARST_N(VCC), .B_DOUT_EN(
        VCC), .B_BLK({VCC, VCC, B_ADDR[14]}), .B_DOUT_ARST_N(VCC), 
        .B_DOUT_SRST_N(VCC), .B_DIN({GND, GND, GND, GND, GND, GND, GND, 
        GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, B_DIN[2]}), 
        .B_ADDR({B_ADDR[13], B_ADDR[12], B_ADDR[11], B_ADDR[10], 
        B_ADDR[9], B_ADDR[8], B_ADDR[7], B_ADDR[6], B_ADDR[5], 
        B_ADDR[4], B_ADDR[3], B_ADDR[2], B_ADDR[1], B_ADDR[0]}), 
        .B_WEN({GND, B_WEN}), .A_EN(VCC), .A_DOUT_LAT(VCC), .A_WIDTH({
        GND, GND, GND}), .A_WMODE(GND), .B_EN(VCC), .B_DOUT_LAT(VCC), 
        .B_WIDTH({GND, GND, GND}), .B_WMODE(GND), .SII_LOCK(GND));
    GND GND_power_inst1 (.Y(GND_power_net1));
    VCC VCC_power_inst1 (.Y(VCC_power_net1));
    
endmodule
