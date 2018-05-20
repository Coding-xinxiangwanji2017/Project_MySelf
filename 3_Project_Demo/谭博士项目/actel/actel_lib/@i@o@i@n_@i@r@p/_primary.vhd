library verilog;
use verilog.vl_types.all;
entity IOIN_IRP is
    port(
        PRE             : in     vl_logic;
        ICLK            : in     vl_logic;
        Y               : out    vl_logic;
        YIN             : in     vl_logic
    );
end IOIN_IRP;
