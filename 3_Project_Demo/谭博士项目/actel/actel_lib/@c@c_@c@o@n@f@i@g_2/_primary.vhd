library verilog;
use verilog.vl_types.all;
entity CC_CONFIG_2 is
    port(
        CO              : out    vl_logic;
        CC              : out    vl_logic_vector(11 downto 0);
        CI              : in     vl_logic;
        P               : in     vl_logic_vector(11 downto 0);
        UB              : in     vl_logic_vector(11 downto 0)
    );
end CC_CONFIG_2;
