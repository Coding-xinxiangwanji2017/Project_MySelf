`timescale 1 ns/100 ps
// Version: v11.5 SP2 11.5.2.6


module PLL_12P5_input_PLL_12P5_input_0_FCCC(
       LOCK,
       CLK0,
       GL0,
       GL1,
       GL2,
       GL3
    );
output LOCK;
input  CLK0;
output GL0;
output GL1;
output GL2;
output GL3;

    wire gnd_net, vcc_net, GL0_net, GL1_net, GL2_net, GL3_net;
    
    CLKINT GL3_INST (.A(GL3_net), .Y(GL3));
    CLKINT GL1_INST (.A(GL1_net), .Y(GL1));
    VCC vcc_inst (.Y(vcc_net));
    GND gnd_inst (.Y(gnd_net));
    CLKINT GL2_INST (.A(GL2_net), .Y(GL2));
    CLKINT GL0_INST (.A(GL0_net), .Y(GL0));
    CCC #( .INIT(210'h00000078B0000045564003F0BC2B09C202329DF00808080800103)
        , .VCOFREQUENCY(800.000) )  CCC_INST (.Y0(), .Y1(), .Y2(), .Y3(
        ), .PRDATA({nc0, nc1, nc2, nc3, nc4, nc5, nc6, nc7}), .LOCK(
        LOCK), .BUSY(), .CLK0(CLK0), .CLK1(vcc_net), .CLK2(vcc_net), 
        .CLK3(vcc_net), .NGMUX0_SEL(gnd_net), .NGMUX1_SEL(gnd_net), 
        .NGMUX2_SEL(gnd_net), .NGMUX3_SEL(gnd_net), .NGMUX0_HOLD_N(
        vcc_net), .NGMUX1_HOLD_N(vcc_net), .NGMUX2_HOLD_N(vcc_net), 
        .NGMUX3_HOLD_N(vcc_net), .NGMUX0_ARST_N(vcc_net), 
        .NGMUX1_ARST_N(vcc_net), .NGMUX2_ARST_N(vcc_net), 
        .NGMUX3_ARST_N(vcc_net), .PLL_BYPASS_N(vcc_net), .PLL_ARST_N(
        vcc_net), .PLL_POWERDOWN_N(vcc_net), .GPD0_ARST_N(vcc_net), 
        .GPD1_ARST_N(vcc_net), .GPD2_ARST_N(vcc_net), .GPD3_ARST_N(
        vcc_net), .PRESET_N(gnd_net), .PCLK(vcc_net), .PSEL(vcc_net), 
        .PENABLE(vcc_net), .PWRITE(vcc_net), .PADDR({vcc_net, vcc_net, 
        vcc_net, vcc_net, vcc_net, vcc_net}), .PWDATA({vcc_net, 
        vcc_net, vcc_net, vcc_net, vcc_net, vcc_net, vcc_net, vcc_net})
        , .CLK0_PAD(gnd_net), .CLK1_PAD(gnd_net), .CLK2_PAD(gnd_net), 
        .CLK3_PAD(gnd_net), .GL0(GL0_net), .GL1(GL1_net), .GL2(GL2_net)
        , .GL3(GL3_net), .RCOSC_25_50MHZ(gnd_net), .RCOSC_1MHZ(gnd_net)
        , .XTLOSC(gnd_net));
    
endmodule
