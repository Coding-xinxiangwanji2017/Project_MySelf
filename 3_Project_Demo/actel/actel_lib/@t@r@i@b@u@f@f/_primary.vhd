library verilog;
use verilog.vl_types.all;
entity TRIBUFF is
    generic(
        IOSTD           : string  := ""
    );
    port(
        PAD             : out    vl_logic;
        D               : in     vl_logic;
        E               : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IOSTD : constant is 1;
end TRIBUFF;
