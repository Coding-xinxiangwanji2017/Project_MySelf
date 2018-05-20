library verilog;
use verilog.vl_types.all;
entity UJTAG is
    port(
        UIREG           : out    vl_logic_vector(7 downto 0);
        URSTB           : out    vl_logic;
        UDRCK           : out    vl_logic;
        UTDI            : out    vl_logic;
        UDRCAP          : out    vl_logic;
        UDRSH           : out    vl_logic;
        UDRUPD          : out    vl_logic;
        UTDO            : in     vl_logic;
        TRSTB           : in     vl_logic;
        TDO             : out    vl_logic;
        TDI             : in     vl_logic;
        TMS             : in     vl_logic;
        TCK             : in     vl_logic
    );
end UJTAG;
