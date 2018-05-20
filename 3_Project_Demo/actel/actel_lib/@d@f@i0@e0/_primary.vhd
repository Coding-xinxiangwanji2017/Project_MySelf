library verilog;
use verilog.vl_types.all;
entity DFI0E0 is
    port(
        E               : in     vl_logic;
        CLK             : in     vl_logic;
        QN              : out    vl_logic;
        D               : in     vl_logic
    );
end DFI0E0;
