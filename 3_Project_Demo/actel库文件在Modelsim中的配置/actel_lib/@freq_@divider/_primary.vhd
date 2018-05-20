library verilog;
use verilog.vl_types.all;
entity Freq_Divider is
    generic(
        DIV_LENGTH      : integer := 2;
        DIV_FORMAT      : integer := 0;
        RESET_POLARITY  : integer := 1
    );
    port(
        CLKIN           : in     vl_logic;
        CLKOUT          : out    vl_logic;
        DIV             : in     vl_logic_vector;
        SYNC_RESET      : in     vl_logic;
        ASYNC_RESET     : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DIV_LENGTH : constant is 1;
    attribute mti_svvh_generic_type of DIV_FORMAT : constant is 1;
    attribute mti_svvh_generic_type of RESET_POLARITY : constant is 1;
end Freq_Divider;
