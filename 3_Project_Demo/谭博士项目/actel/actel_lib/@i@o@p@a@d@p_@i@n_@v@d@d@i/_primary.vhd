library verilog;
use verilog.vl_types.all;
entity IOPADP_IN_VDDI is
    port(
        IOUT_VDD        : out    vl_logic;
        PAD_P           : in     vl_logic;
        N2PIN_P         : in     vl_logic
    );
end IOPADP_IN_VDDI;
