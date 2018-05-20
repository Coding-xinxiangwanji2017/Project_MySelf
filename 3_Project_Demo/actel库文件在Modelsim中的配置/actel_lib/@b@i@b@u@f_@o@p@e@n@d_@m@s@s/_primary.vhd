library verilog;
use verilog.vl_types.all;
entity BIBUF_OPEND_MSS is
    generic(
        ACT_PIN         : string  := "";
        ACT_CONFIG      : integer := 0
    );
    port(
        Y               : out    vl_logic;
        E               : in     vl_logic;
        PAD             : inout  vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ACT_PIN : constant is 1;
    attribute mti_svvh_generic_type of ACT_CONFIG : constant is 1;
end BIBUF_OPEND_MSS;
