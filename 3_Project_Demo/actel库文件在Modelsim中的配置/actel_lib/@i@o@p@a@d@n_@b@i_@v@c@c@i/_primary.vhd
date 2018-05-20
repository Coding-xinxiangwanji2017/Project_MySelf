library verilog;
use verilog.vl_types.all;
entity IOPADN_BI_VCCI is
    port(
        PAD_P           : inout  vl_logic;
        IOUT_VDD        : out    vl_logic;
        OIN_VDD         : in     vl_logic;
        EIN_VDD         : in     vl_logic
    );
end IOPADN_BI_VCCI;
