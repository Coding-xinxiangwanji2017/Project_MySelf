library verilog;
use verilog.vl_types.all;
entity TRIBUFF_DIFF is
    generic(
        IOSTD           : string  := ""
    );
    port(
        PADP            : out    vl_logic;
        PADN            : out    vl_logic;
        D               : in     vl_logic;
        E               : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IOSTD : constant is 1;
end TRIBUFF_DIFF;
