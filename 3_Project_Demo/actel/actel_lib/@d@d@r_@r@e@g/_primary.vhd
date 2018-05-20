library verilog;
use verilog.vl_types.all;
entity DDR_REG is
    port(
        D               : in     vl_logic;
        CLK             : in     vl_logic;
        CLR             : in     vl_logic;
        QR              : out    vl_logic;
        QF              : out    vl_logic
    );
end DDR_REG;
