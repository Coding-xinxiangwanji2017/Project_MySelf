library verilog;
use verilog.vl_types.all;
entity IOIN_ID is
    port(
        YIN             : in     vl_logic;
        ICLK            : in     vl_logic;
        CLR             : in     vl_logic;
        YR              : out    vl_logic;
        YF              : out    vl_logic
    );
end IOIN_ID;
