library verilog;
use verilog.vl_types.all;
entity FCEND_BUFF_CC is
    port(
        CO              : out    vl_logic;
        P               : out    vl_logic;
        UB              : out    vl_logic;
        FCI             : in     vl_logic;
        CC              : in     vl_logic
    );
end FCEND_BUFF_CC;
