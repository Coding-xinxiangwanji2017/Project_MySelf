library verilog;
use verilog.vl_types.all;
entity DFN0E1 is
    port(
        E               : in     vl_logic;
        CLK             : in     vl_logic;
        Q               : out    vl_logic;
        D               : in     vl_logic
    );
end DFN0E1;
