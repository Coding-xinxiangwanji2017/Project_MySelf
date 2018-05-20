library verilog;
use verilog.vl_types.all;
entity DFI0 is
    port(
        CLK             : in     vl_logic;
        QN              : out    vl_logic;
        D               : in     vl_logic
    );
end DFI0;
