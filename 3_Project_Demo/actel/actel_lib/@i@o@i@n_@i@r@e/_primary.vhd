library verilog;
use verilog.vl_types.all;
entity IOIN_IRE is
    port(
        ICE             : in     vl_logic;
        ICLK            : in     vl_logic;
        Y               : out    vl_logic;
        YIN             : in     vl_logic
    );
end IOIN_IRE;
