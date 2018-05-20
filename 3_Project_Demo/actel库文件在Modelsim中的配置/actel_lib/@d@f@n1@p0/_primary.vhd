library verilog;
use verilog.vl_types.all;
entity DFN1P0 is
    port(
        Q               : out    vl_logic;
        D               : in     vl_logic;
        CLK             : in     vl_logic;
        PRE             : in     vl_logic
    );
end DFN1P0;
