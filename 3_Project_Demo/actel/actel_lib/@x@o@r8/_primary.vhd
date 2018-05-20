library verilog;
use verilog.vl_types.all;
entity XOR8 is
    port(
        Y               : out    vl_logic;
        A               : in     vl_logic;
        B               : in     vl_logic;
        C               : in     vl_logic;
        D               : in     vl_logic;
        E               : in     vl_logic;
        F               : in     vl_logic;
        G               : in     vl_logic;
        H               : in     vl_logic
    );
end XOR8;
