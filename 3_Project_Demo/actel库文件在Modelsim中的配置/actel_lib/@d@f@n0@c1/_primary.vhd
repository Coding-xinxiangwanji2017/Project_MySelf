library verilog;
use verilog.vl_types.all;
entity DFN0C1 is
    port(
        CLR             : in     vl_logic;
        CLK             : in     vl_logic;
        Q               : out    vl_logic;
        D               : in     vl_logic
    );
end DFN0C1;
