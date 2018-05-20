library verilog;
use verilog.vl_types.all;
entity CCC_GPD1 is
    port(
        CLKIN           : in     vl_logic;
        DIV             : in     vl_logic_vector(7 downto 0);
        RESET           : in     vl_logic;
        SYNC_RESET      : in     vl_logic;
        NOPIPERSTSYNC   : in     vl_logic;
        CLKOUT          : out    vl_logic
    );
end CCC_GPD1;
