library verilog;
use verilog.vl_types.all;
entity CCC_RF_MUX is
    port(
        CLK0_PAD        : in     vl_logic;
        CLK1_PAD        : in     vl_logic;
        CLK2_PAD        : in     vl_logic;
        CLK3_PAD        : in     vl_logic;
        CLK0            : in     vl_logic;
        CLK1            : in     vl_logic;
        CLK2            : in     vl_logic;
        CLK3            : in     vl_logic;
        RCOSC_25_50MHZ  : in     vl_logic;
        RCOSC_1MHZ      : in     vl_logic;
        XTLOSC          : in     vl_logic;
        GPDCLK0         : in     vl_logic;
        GPDCLK1         : in     vl_logic;
        GPDCLK2         : in     vl_logic;
        GPDCLK3         : in     vl_logic;
        SEL             : in     vl_logic_vector(3 downto 0);
        INV             : in     vl_logic;
        CLKOUT          : out    vl_logic
    );
end CCC_RF_MUX;
