library verilog;
use verilog.vl_types.all;
entity DFI1E0 is
    port(
        E               : in     vl_logic;
        CLK             : in     vl_logic;
        QN              : out    vl_logic;
        D               : in     vl_logic
    );
end DFI1E0;
