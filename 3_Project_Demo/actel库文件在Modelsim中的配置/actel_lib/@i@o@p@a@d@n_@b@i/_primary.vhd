library verilog;
use verilog.vl_types.all;
entity IOPADN_BI is
    port(
        PAD_P           : inout  vl_logic;
        N2POUT_P        : out    vl_logic;
        OIN_P           : in     vl_logic;
        EIN_P           : in     vl_logic
    );
end IOPADN_BI;
