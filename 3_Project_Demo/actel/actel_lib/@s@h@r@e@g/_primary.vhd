library verilog;
use verilog.vl_types.all;
entity SHREG is
    port(
        SDOUT           : out    vl_logic;
        SUPDATELATCH    : out    vl_logic_vector(88 downto 0);
        SDIN            : in     vl_logic;
        SCLK            : in     vl_logic;
        SSHIFT          : in     vl_logic;
        SUPDATE         : in     vl_logic
    );
end SHREG;
