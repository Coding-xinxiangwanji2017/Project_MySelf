library verilog;
use verilog.vl_types.all;
entity IOIN_IR is
    port(
        ICLK            : in     vl_logic;
        Y               : out    vl_logic;
        YIN             : in     vl_logic
    );
end IOIN_IR;
