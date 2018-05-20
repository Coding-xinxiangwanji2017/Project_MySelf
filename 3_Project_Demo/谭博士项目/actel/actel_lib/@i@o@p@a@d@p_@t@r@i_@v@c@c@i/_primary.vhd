library verilog;
use verilog.vl_types.all;
entity IOPADP_TRI_VCCI is
    port(
        PAD_P           : out    vl_logic;
        OIN_VDD         : in     vl_logic;
        EIN_VDD         : in     vl_logic
    );
end IOPADP_TRI_VCCI;
