library verilog;
use verilog.vl_types.all;
entity DFI1E1C0 is
    port(
        CLR             : in     vl_logic;
        E               : in     vl_logic;
        CLK             : in     vl_logic;
        QN              : out    vl_logic;
        D               : in     vl_logic
    );
end DFI1E1C0;
