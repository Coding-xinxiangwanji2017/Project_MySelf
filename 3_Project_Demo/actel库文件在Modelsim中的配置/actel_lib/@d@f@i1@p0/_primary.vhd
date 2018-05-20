library verilog;
use verilog.vl_types.all;
entity DFI1P0 is
    port(
        PRE             : in     vl_logic;
        CLK             : in     vl_logic;
        QN              : out    vl_logic;
        D               : in     vl_logic
    );
end DFI1P0;
