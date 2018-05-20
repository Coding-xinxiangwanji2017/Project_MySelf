library verilog;
use verilog.vl_types.all;
entity IOPAD_TRI_VCCI is
    port(
        OIN_VDD         : in     vl_logic;
        EIN_VDD         : in     vl_logic;
        PAD_P           : out    vl_logic
    );
end IOPAD_TRI_VCCI;
