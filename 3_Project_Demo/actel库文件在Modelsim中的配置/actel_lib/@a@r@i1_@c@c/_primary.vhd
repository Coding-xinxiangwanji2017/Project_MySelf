library verilog;
use verilog.vl_types.all;
entity ARI1_CC is
    generic(
        INIT            : vl_logic_vector(19 downto 0) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0)
    );
    port(
        Y               : out    vl_logic;
        S               : out    vl_logic;
        P               : out    vl_logic;
        UB              : out    vl_logic;
        FCO             : out    vl_logic;
        FCI             : in     vl_logic;
        A               : in     vl_logic;
        B               : in     vl_logic;
        C               : in     vl_logic;
        D               : in     vl_logic;
        CC              : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of INIT : constant is 2;
end ARI1_CC;
