library verilog;
use verilog.vl_types.all;
entity OA1B is
    port(
        Y               : out    vl_logic;
        C               : in     vl_logic;
        A               : in     vl_logic;
        B               : in     vl_logic
    );
end OA1B;
