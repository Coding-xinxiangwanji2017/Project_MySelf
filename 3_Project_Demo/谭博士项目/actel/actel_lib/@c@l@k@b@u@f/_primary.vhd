library verilog;
use verilog.vl_types.all;
entity CLKBUF is
    generic(
        IOSTD           : string  := ""
    );
    port(
        Y               : out    vl_logic;
        PAD             : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IOSTD : constant is 1;
end CLKBUF;
