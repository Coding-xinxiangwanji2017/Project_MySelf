library verilog;
use verilog.vl_types.all;
entity UNGMUXHW1 is
    port(
        GL              : out    vl_logic;
        GLC             : out    vl_logic;
        CLK0            : in     vl_logic;
        CLK1            : in     vl_logic;
        SEL0            : in     vl_logic;
        SEL1            : in     vl_logic
    );
end UNGMUXHW1;
