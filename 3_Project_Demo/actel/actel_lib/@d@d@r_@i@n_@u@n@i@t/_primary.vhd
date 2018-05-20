library verilog;
use verilog.vl_types.all;
entity DDR_IN_UNIT is
    port(
        QR              : out    vl_logic;
        QF              : out    vl_logic;
        ADn             : in     vl_logic;
        ALn             : in     vl_logic;
        CLK             : in     vl_logic;
        D               : in     vl_logic;
        SD              : in     vl_logic;
        EN              : in     vl_logic;
        SLn             : in     vl_logic;
        LAT             : in     vl_logic
    );
end DDR_IN_UNIT;
