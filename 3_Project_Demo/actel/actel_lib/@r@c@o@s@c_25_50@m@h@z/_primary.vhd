library verilog;
use verilog.vl_types.all;
entity RCOSC_25_50MHZ is
    generic(
        FREQUENCY       : real    := 5.000000e+001
    );
    port(
        CLKOUT          : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of FREQUENCY : constant is 2;
end RCOSC_25_50MHZ;
