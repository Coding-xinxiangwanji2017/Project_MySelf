library verilog;
use verilog.vl_types.all;
entity DFN1E0P0 is
    port(
        PRE             : in     vl_logic;
        E               : in     vl_logic;
        CLK             : in     vl_logic;
        Q               : out    vl_logic;
        D               : in     vl_logic
    );
end DFN1E0P0;
