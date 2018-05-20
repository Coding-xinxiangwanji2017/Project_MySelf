library verilog;
use verilog.vl_types.all;
entity DLN1 is
    port(
        Q               : out    vl_logic;
        D               : in     vl_logic;
        G               : in     vl_logic
    );
end DLN1;
