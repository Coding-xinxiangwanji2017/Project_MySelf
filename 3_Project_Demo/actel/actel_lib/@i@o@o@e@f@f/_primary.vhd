library verilog;
use verilog.vl_types.all;
entity IOOEFF is
    port(
        Q               : out    vl_logic;
        ADn             : in     vl_logic;
        ALn             : in     vl_logic;
        CLK             : in     vl_logic;
        Dn              : in     vl_logic;
        SDR             : in     vl_logic;
        LAT             : in     vl_logic;
        SD              : in     vl_logic;
        EN              : in     vl_logic;
        SLn             : in     vl_logic
    );
end IOOEFF;
