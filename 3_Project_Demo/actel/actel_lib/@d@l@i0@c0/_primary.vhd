library verilog;
use verilog.vl_types.all;
entity DLI0C0 is
    port(
        CLR             : in     vl_logic;
        G               : in     vl_logic;
        QN              : out    vl_logic;
        D               : in     vl_logic
    );
end DLI0C0;
