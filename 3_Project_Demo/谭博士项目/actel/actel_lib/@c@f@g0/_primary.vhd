library verilog;
use verilog.vl_types.all;
entity CFG0 is
    generic(
        INIT            : vl_logic := Hi0;
        LUT_FUNCTION    : string  := ""
    );
    port(
        Y               : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of INIT : constant is 1;
    attribute mti_svvh_generic_type of LUT_FUNCTION : constant is 1;
end CFG0;
