library verilog;
use verilog.vl_types.all;
entity IOIN_IRC_ST is
    port(
        CLR             : in     vl_logic;
        CLK             : in     vl_logic;
        Y               : out    vl_logic;
        YIN             : in     vl_logic
    );
end IOIN_IRC_ST;
