library verilog;
use verilog.vl_types.all;
entity DLI1P1C1 is
    port(
        PRE             : in     vl_logic;
        CLR             : in     vl_logic;
        G               : in     vl_logic;
        QN              : out    vl_logic;
        D               : in     vl_logic
    );
end DLI1P1C1;
