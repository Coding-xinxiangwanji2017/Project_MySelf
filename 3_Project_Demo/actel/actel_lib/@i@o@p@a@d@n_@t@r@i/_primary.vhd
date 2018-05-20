library verilog;
use verilog.vl_types.all;
entity IOPADN_TRI is
    port(
        PAD_P           : out    vl_logic;
        OIN_P           : in     vl_logic;
        EIN_P           : in     vl_logic
    );
end IOPADN_TRI;
