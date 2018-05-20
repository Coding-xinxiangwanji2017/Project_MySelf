library verilog;
use verilog.vl_types.all;
entity IOIN_IR_ST is
    port(
        CLK             : in     vl_logic;
        Y               : out    vl_logic;
        YIN             : in     vl_logic
    );
end IOIN_IR_ST;
