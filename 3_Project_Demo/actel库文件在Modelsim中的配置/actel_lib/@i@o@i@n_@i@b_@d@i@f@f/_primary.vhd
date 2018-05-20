library verilog;
use verilog.vl_types.all;
entity IOIN_IB_DIFF is
    port(
        Y               : out    vl_logic;
        YIN             : in     vl_logic
    );
end IOIN_IB_DIFF;
