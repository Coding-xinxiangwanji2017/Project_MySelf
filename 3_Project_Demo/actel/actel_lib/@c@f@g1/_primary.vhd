library verilog;
use verilog.vl_types.all;
entity CFG1 is
    generic(
        INIT            : vl_logic_vector(1 downto 0) := (Hi0, Hi0);
        LUT_FUNCTION    : string  := ""
    );
    port(
        Y               : out    vl_logic;
        A               : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of INIT : constant is 2;
    attribute mti_svvh_generic_type of LUT_FUNCTION : constant is 1;
end CFG1;
