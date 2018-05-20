library verilog;
use verilog.vl_types.all;
entity CCC_NGMUX0 is
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
        VCO0            : in     vl_logic;
        VCO45           : in     vl_logic;
        VCO90           : in     vl_logic;
        VCO135          : in     vl_logic;
        VCO180          : in     vl_logic;
        VCO225          : in     vl_logic;
        VCO270          : in     vl_logic;
        VCO315          : in     vl_logic;
        GPDCLK0         : in     vl_logic;
        GPDCLK1         : in     vl_logic;
        GPDCLK2         : in     vl_logic;
        GPDCLK3         : in     vl_logic;
        SEL             : in     vl_logic_vector(9 downto 0);
        OUT_SEL         : in     vl_logic;
        INV             : in     vl_logic;
        NGMUX_ARST_N    : in     vl_logic;
        NGMUX_SEL       : in     vl_logic;
        NGMUX_HOLD_N    : in     vl_logic;
        Y               : out    vl_logic;
        GL              : out    vl_logic;
        BUSY            : out    vl_logic
    );
end CCC_NGMUX0;
