library verilog;
use verilog.vl_types.all;
entity DLN0P1C1 is
    port(
        PRE             : in     vl_logic;
        CLR             : in     vl_logic;
        G               : in     vl_logic;
        Q               : out    vl_logic;
        D               : in     vl_logic
    );
end DLN0P1C1;
