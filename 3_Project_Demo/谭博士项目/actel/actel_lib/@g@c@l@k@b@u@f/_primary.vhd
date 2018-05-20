library verilog;
use verilog.vl_types.all;
entity GCLKBUF is
    generic(
        IOSTD           : string  := ""
    );
    port(
        PAD             : in     vl_logic;
        EN              : in     vl_logic;
        Y               : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IOSTD : constant is 1;
end GCLKBUF;
