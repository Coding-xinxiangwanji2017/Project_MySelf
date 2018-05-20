library verilog;
use verilog.vl_types.all;
entity IOPAD_BI_VDDI is
    port(
        OIN_VDD         : in     vl_logic;
        EIN_VDD         : in     vl_logic;
        PAD_P           : inout  vl_logic;
        IOUT_VDD        : out    vl_logic
    );
end IOPAD_BI_VDDI;
