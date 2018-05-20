library verilog;
use verilog.vl_types.all;
entity Odd_Divider is
    generic(
        DIV_LENGTH      : integer := 2
    );
    port(
        CLKIN           : in     vl_logic;
        CLKOUT          : out    vl_logic;
        SYNC_RESET      : in     vl_logic;
        ASYNC_RESET     : in     vl_logic;
        DIV             : in     vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DIV_LENGTH : constant is 1;
end Odd_Divider;
