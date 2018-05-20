library verilog;
use verilog.vl_types.all;
entity IOIN_IRP_ST is
    port(
        PRE             : in     vl_logic;
        CLK             : in     vl_logic;
        Y               : out    vl_logic;
        YIN             : in     vl_logic
    );
end IOIN_IRP_ST;
