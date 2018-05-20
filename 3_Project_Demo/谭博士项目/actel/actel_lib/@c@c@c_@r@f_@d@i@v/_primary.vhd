library verilog;
use verilog.vl_types.all;
entity CCC_RF_DIV is
    port(
        CLKIN           : in     vl_logic;
        DIV             : in     vl_logic_vector(7 downto 0);
        ARST_N          : in     vl_logic;
        CLKOUT          : out    vl_logic
    );
end CCC_RF_DIV;
