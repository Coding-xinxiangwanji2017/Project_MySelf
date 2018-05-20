library verilog;
use verilog.vl_types.all;
entity ODT_DYNAMIC is
    generic(
        ODT_BANK        : integer := -1
    );
    port(
        A               : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ODT_BANK : constant is 1;
end ODT_DYNAMIC;
