library verilog;
use verilog.vl_types.all;
entity FCINIT_BUFF_CC is
    port(
        P               : out    vl_logic;
        UB              : out    vl_logic;
        FCO             : out    vl_logic;
        A               : in     vl_logic;
        CC              : in     vl_logic
    );
end FCINIT_BUFF_CC;
