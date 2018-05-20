library verilog;
use verilog.vl_types.all;
entity IOPADP_BI is
    port(
        PAD_P           : inout  vl_logic;
        IOUT_P          : out    vl_logic;
        N2PIN_P         : in     vl_logic;
        OIN_P           : in     vl_logic;
        EIN_P           : in     vl_logic
    );
end IOPADP_BI;
