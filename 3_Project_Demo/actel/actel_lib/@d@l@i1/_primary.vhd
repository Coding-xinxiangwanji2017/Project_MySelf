library verilog;
use verilog.vl_types.all;
entity DLI1 is
    port(
        G               : in     vl_logic;
        QN              : out    vl_logic;
        D               : in     vl_logic
    );
end DLI1;
