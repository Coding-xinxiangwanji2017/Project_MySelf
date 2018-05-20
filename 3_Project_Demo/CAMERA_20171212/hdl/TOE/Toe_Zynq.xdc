##############################################################################
# Reference clock (100MHz)
#net "RefClk" LOC = "Y6";
#net "RefClk" IOSTANDARD = LVCMOS25;
#net "RefClk" TNM_net = "RefClk";
#timespec "TS_CLK" = PERIOD "RefClk" 10 ns HIGH 50 %;
#net "RefClk" CLOCK_DEDICATED_ROUTE = FALSE;
set_property PACKAGE_PIN Y6 [get_ports RefClk]
set_property IOSTANDARD LVCMOS25  [get_ports RefClk]
set_property DRIVE 8  [get_ports RefClk]
set_property SLEW FAST  [get_ports RefClk]

##############################################################################
# Kin0FPGA��Zynq�Ļ�����

set_property PACKAGE_PIN H17 [get_ports FPGA0_Rx]

set_property PACKAGE_PIN F16 [get_ports {FPGA0_RxData[0]}]
set_property PACKAGE_PIN E16 [get_ports {FPGA0_RxData[1]}]
set_property PACKAGE_PIN D16 [get_ports {FPGA0_RxData[2]}]
set_property PACKAGE_PIN D17 [get_ports {FPGA0_RxData[3]}]
set_property PACKAGE_PIN E15 [get_ports {FPGA0_RxData[4]}]
set_property PACKAGE_PIN D15 [get_ports {FPGA0_RxData[5]}]
set_property PACKAGE_PIN G15 [get_ports {FPGA0_RxData[6]}]
set_property PACKAGE_PIN G16 [get_ports {FPGA0_RxData[7]}]

set_property PACKAGE_PIN F18 [get_ports {FPGA0_RxChan[0]}]
set_property PACKAGE_PIN E18 [get_ports {FPGA0_RxChan[1]}]
set_property PACKAGE_PIN G17 [get_ports {FPGA0_RxChan[2]}]

set_property PACKAGE_PIN F17 [get_ports {FPGA0_TxFull[0]}]
set_property PACKAGE_PIN C15 [get_ports {FPGA0_TxFull[1]}]

set_property PACKAGE_PIN B15 [get_ports {FPGA0_Tx}]

set_property PACKAGE_PIN B16 [get_ports {FPGA0_TxData[0]}]
set_property PACKAGE_PIN B17 [get_ports {FPGA0_TxData[1]}]
set_property PACKAGE_PIN A17 [get_ports {FPGA0_TxData[2]}]
set_property PACKAGE_PIN A18 [get_ports {FPGA0_TxData[3]}]
set_property PACKAGE_PIN A19 [get_ports {FPGA0_TxData[4]}]
set_property PACKAGE_PIN C17 [get_ports {FPGA0_TxData[5]}]
set_property PACKAGE_PIN C18 [get_ports {FPGA0_TxData[6]}]
set_property PACKAGE_PIN D18 [get_ports {FPGA0_TxData[7]}]

set_property PACKAGE_PIN C19 [get_ports {FPGA0_TxChan[0]}]
set_property PACKAGE_PIN B19 [get_ports {FPGA0_TxChan[1]}]
set_property PACKAGE_PIN B20 [get_ports {FPGA0_TxChan[2]}]

set_property PACKAGE_PIN D20 [get_ports {FPGA0_RxFull[0]}]
set_property PACKAGE_PIN C20 [get_ports {FPGA0_RxFull[1]}]

set_property PACKAGE_PIN A16 [get_ports {FPGA0_CLK}]
set_property PACKAGE_PIN K21 [get_ports {FPGA1_CLK}]

set_property PACKAGE_PIN H15 [get_ports {FPGA1_Rx}]

set_property PACKAGE_PIN J15 [get_ports {FPGA1_RxData[0]}]
set_property PACKAGE_PIN K15 [get_ports {FPGA1_RxData[1]}]
set_property PACKAGE_PIN J16 [get_ports {FPGA1_RxData[2]}]
set_property PACKAGE_PIN J17 [get_ports {FPGA1_RxData[3]}]
set_property PACKAGE_PIN K16 [get_ports {FPGA1_RxData[4]}]
set_property PACKAGE_PIN L16 [get_ports {FPGA1_RxData[5]}]
set_property PACKAGE_PIN L17 [get_ports {FPGA1_RxData[6]}]
set_property PACKAGE_PIN M17 [get_ports {FPGA1_RxData[7]}]
set_property PACKAGE_PIN N17 [get_ports {FPGA1_RxChan[0]}]
set_property PACKAGE_PIN N18 [get_ports {FPGA1_RxChan[1]}]
set_property PACKAGE_PIN M15 [get_ports {FPGA1_RxChan[2]}]
set_property PACKAGE_PIN M16 [get_ports {FPGA1_TxFull[0]}]
set_property PACKAGE_PIN J18 [get_ports {FPGA1_TxFull[1]}]
set_property PACKAGE_PIN K18 [get_ports {FPGA1_Tx}]
set_property PACKAGE_PIN J21 [get_ports {FPGA1_TxData[0]}]
set_property PACKAGE_PIN J22 [get_ports {FPGA1_TxData[1]}]
set_property PACKAGE_PIN J20 [get_ports {FPGA1_TxData[2]}]
set_property PACKAGE_PIN L21 [get_ports {FPGA1_TxData[3]}]
set_property PACKAGE_PIN L22 [get_ports {FPGA1_TxData[4]}]
set_property PACKAGE_PIN K19 [get_ports {FPGA1_TxData[5]}]
set_property PACKAGE_PIN K20 [get_ports {FPGA1_TxData[6]}]
set_property PACKAGE_PIN L18 [get_ports {FPGA1_TxData[7]}]
set_property PACKAGE_PIN L19 [get_ports {FPGA1_TxChan[0]}]
set_property PACKAGE_PIN M19 [get_ports {FPGA1_TxChan[1]}]
set_property PACKAGE_PIN M20 [get_ports {FPGA1_TxChan[2]}]
set_property PACKAGE_PIN N19 [get_ports {FPGA1_RxFull[0]}]
set_property PACKAGE_PIN N20 [get_ports {FPGA1_RxFull[1]}]

##############################################################################
## Connections to GigExpedite
set_property PACKAGE_PIN Y9   [get_ports GigEx_Clk]
set_property PACKAGE_PIN AA6  [get_ports {GigEx_TxData[7]}]
set_property PACKAGE_PIN AA7  [get_ports {GigEx_TxData[6]}]
set_property PACKAGE_PIN AA8  [get_ports {GigEx_TxData[5]}]
set_property PACKAGE_PIN AA9  [get_ports {GigEx_TxData[4]}]
set_property PACKAGE_PIN Y10  [get_ports {GigEx_TxData[3]}]
set_property PACKAGE_PIN Y11  [get_ports {GigEx_TxData[2]}]
set_property PACKAGE_PIN AB9  [get_ports {GigEx_TxData[1]}]
set_property PACKAGE_PIN AB10 [get_ports {GigEx_TxData[0]}]
set_property PACKAGE_PIN W6   [get_ports {GigEx_TxChan[2]}]
set_property PACKAGE_PIN W7   [get_ports {GigEx_TxChan[1]}]
set_property PACKAGE_PIN U5   [get_ports {GigEx_TxChan[0]}]
set_property PACKAGE_PIN V9   [get_ports {GigEx_nTx}]
set_property PACKAGE_PIN W5   [get_ports {GigEx_nTxFull[7]}]
set_property PACKAGE_PIN T4   [get_ports {GigEx_nTxFull[6]}]
set_property PACKAGE_PIN T6   [get_ports {GigEx_nTxFull[5]}]
set_property PACKAGE_PIN R6   [get_ports {GigEx_nTxFull[4]}]
set_property PACKAGE_PIN AB4  [get_ports {GigEx_nTxFull[3]}]
set_property PACKAGE_PIN AB5  [get_ports {GigEx_nTxFull[2]}]
set_property PACKAGE_PIN AB1  [get_ports {GigEx_nTxFull[1]}]
set_property PACKAGE_PIN AB2  [get_ports {GigEx_nTxFull[0]}]
set_property PACKAGE_PIN AB11 [get_ports {GigEx_RxData[7]}]
set_property PACKAGE_PIN AA11 [get_ports {GigEx_RxData[6]}]
set_property PACKAGE_PIN AB12 [get_ports {GigEx_RxData[5]}]
set_property PACKAGE_PIN AA12 [get_ports {GigEx_RxData[4]}]
set_property PACKAGE_PIN U9   [get_ports {GigEx_RxData[3]}]
set_property PACKAGE_PIN U10  [get_ports {GigEx_RxData[2]}]
set_property PACKAGE_PIN U11  [get_ports {GigEx_RxData[1]}]
set_property PACKAGE_PIN U12  [get_ports {GigEx_RxData[0]}]
set_property PACKAGE_PIN AA4  [get_ports {GigEx_RxChan[2]}]
set_property PACKAGE_PIN Y4   [get_ports {GigEx_RxChan[1]}]
set_property PACKAGE_PIN AB6  [get_ports {GigEx_RxChan[0]}]
set_property PACKAGE_PIN AB7  [get_ports {GigEx_nRx}]
set_property PACKAGE_PIN U4   [get_ports {GigEx_nRxFull[7]}]
set_property PACKAGE_PIN V5   [get_ports {GigEx_nRxFull[6]}]
set_property PACKAGE_PIN V4   [get_ports {GigEx_nRxFull[5]}]
set_property PACKAGE_PIN U6   [get_ports {GigEx_nRxFull[4]}]
set_property PACKAGE_PIN V7   [get_ports {GigEx_nRxFull[3]}]
set_property PACKAGE_PIN R7   [get_ports {GigEx_nRxFull[2]}]
set_property PACKAGE_PIN V10  [get_ports {GigEx_nRxFull[1]}]
set_property PACKAGE_PIN V8   [get_ports {GigEx_nRxFull[0]}]
set_property PACKAGE_PIN W8   [get_ports {GigEx_nInt}]

set_property IOSTANDARD LVCMOS25  [get_ports GigEx_Clk]
set_property IOSTANDARD LVCMOS25  [get_ports GigEx_RxData[*]]
set_property IOSTANDARD LVCMOS25  [get_ports GigEx_TxData[*]]
set_property IOSTANDARD LVCMOS25  [get_ports GigEx_nTxFull[*]]
set_property IOSTANDARD LVCMOS25  [get_ports GigEx_nRxFull[*]]
set_property IOSTANDARD LVCMOS25  [get_ports GigEx_nTx]
set_property IOSTANDARD LVCMOS25  [get_ports GigEx_nRx]
set_property IOSTANDARD LVCMOS25  [get_ports GigEx_TxChan[*]]
set_property IOSTANDARD LVCMOS25  [get_ports GigEx_RxChan[*]]
set_property IOSTANDARD LVCMOS25  [get_ports GigEx_nInt]

set_property DRIVE 8  [get_ports GigEx_Clk]
set_property DRIVE 8  [get_ports GigEx_TxData[*]]
set_property DRIVE 8  [get_ports GigEx_nRxFull[*]]
set_property DRIVE 8  [get_ports GigEx_nTx]
set_property DRIVE 8  [get_ports GigEx_TxChan[*]]

set_property SLEW FAST  [get_ports GigEx_Clk]
set_property SLEW FAST  [get_ports GigEx_TxData[*]]
set_property SLEW FAST  [get_ports GigEx_nRxFull[*]]
set_property SLEW FAST  [get_ports GigEx_nTx]
set_property SLEW FAST  [get_ports GigEx_TxChan[*]]