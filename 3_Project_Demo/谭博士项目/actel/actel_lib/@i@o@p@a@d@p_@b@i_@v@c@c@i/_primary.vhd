library verilog;
use verilog.vl_types.all;
entity IOPADP_BI_VCCI is
    port(
        PAD_P           : inout  vl_logic;
        IOUT_VDD        : out    vl_logic;
        N2PIN_P         : in     vl_logic;
        OIN_VDD         : in     vl_logic;
        EIN_VDD         : in     vl_logic
    );
end IOPADP_BI_VCCI;
