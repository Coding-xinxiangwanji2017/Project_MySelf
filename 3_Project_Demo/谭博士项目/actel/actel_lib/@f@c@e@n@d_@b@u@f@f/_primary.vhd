library verilog;
use verilog.vl_types.all;
entity FCEND_BUFF is
    port(
        CO              : out    vl_logic;
        FCI             : in     vl_logic
    );
end FCEND_BUFF;
