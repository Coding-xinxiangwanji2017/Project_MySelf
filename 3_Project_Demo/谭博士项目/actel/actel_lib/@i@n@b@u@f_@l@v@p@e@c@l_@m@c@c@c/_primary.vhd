library verilog;
use verilog.vl_types.all;
entity INBUF_LVPECL_MCCC is
    generic(
        ACT_PIN         : string  := ""
    );
    port(
        PADP            : in     vl_logic;
        PADN            : in     vl_logic;
        Y               : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ACT_PIN : constant is 1;
end INBUF_LVPECL_MCCC;
