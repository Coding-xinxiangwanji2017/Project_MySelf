library verilog;
use verilog.vl_types.all;
entity DFI0E1P1 is
    port(
        PRE             : in     vl_logic;
        E               : in     vl_logic;
        CLK             : in     vl_logic;
        QN              : out    vl_logic;
        D               : in     vl_logic
    );
end DFI0E1P1;
