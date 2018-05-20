library verilog;
use verilog.vl_types.all;
entity IOPADN_VCCA is
    port(
        IOUT_IN         : out    vl_logic;
        EIN_VDD         : out    vl_logic;
        OIN_VDD         : out    vl_logic;
        OIN_P           : in     vl_logic;
        EIN_P           : in     vl_logic;
        IOUT_VDD        : in     vl_logic
    );
end IOPADN_VCCA;
