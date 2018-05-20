library verilog;
use verilog.vl_types.all;
entity IOINFF is
    port(
        Q               : out    vl_logic;
        ADn             : in     vl_logic;
        ALn             : in     vl_logic;
        CLK             : in     vl_logic;
        D               : in     vl_logic;
        LAT             : in     vl_logic;
        SD              : in     vl_logic;
        EN              : in     vl_logic;
        SLn             : in     vl_logic
    );
end IOINFF;
