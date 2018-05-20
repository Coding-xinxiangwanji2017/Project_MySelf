library verilog;
use verilog.vl_types.all;
entity IOPAD_IN_VDDI is
    port(
        PAD_P           : in     vl_logic;
        IOUT_VDD        : out    vl_logic
    );
end IOPAD_IN_VDDI;
