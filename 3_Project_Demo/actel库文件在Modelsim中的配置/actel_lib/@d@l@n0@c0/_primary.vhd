library verilog;
use verilog.vl_types.all;
entity DLN0C0 is
    port(
        CLR             : in     vl_logic;
        G               : in     vl_logic;
        Q               : out    vl_logic;
        D               : in     vl_logic
    );
end DLN0C0;
