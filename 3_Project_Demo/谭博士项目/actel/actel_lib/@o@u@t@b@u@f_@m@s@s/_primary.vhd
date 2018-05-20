library verilog;
use verilog.vl_types.all;
entity OUTBUF_MSS is
    generic(
        ACT_PIN         : string  := "";
        ACT_CONFIG      : integer := 0
    );
    port(
        PAD             : out    vl_logic;
        D               : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ACT_PIN : constant is 1;
    attribute mti_svvh_generic_type of ACT_CONFIG : constant is 1;
end OUTBUF_MSS;
