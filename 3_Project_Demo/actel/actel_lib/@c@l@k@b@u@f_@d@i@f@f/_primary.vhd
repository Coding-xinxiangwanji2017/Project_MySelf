library verilog;
use verilog.vl_types.all;
entity CLKBUF_DIFF is
    generic(
        IOSTD           : string  := ""
    );
    port(
        PADP            : in     vl_logic;
        PADN            : in     vl_logic;
        Y               : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IOSTD : constant is 1;
end CLKBUF_DIFF;
