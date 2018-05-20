library verilog;
use verilog.vl_types.all;
entity IOPADN_IN_VDDI is
    port(
        IOUT_VDD        : out    vl_logic;
        PAD_P           : in     vl_logic
    );
end IOPADN_IN_VDDI;
