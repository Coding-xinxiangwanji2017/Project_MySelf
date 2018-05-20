library verilog;
use verilog.vl_types.all;
entity DFI1 is
    port(
        CLK             : in     vl_logic;
        QN              : out    vl_logic;
        D               : in     vl_logic
    );
end DFI1;
