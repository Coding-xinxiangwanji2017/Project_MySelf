library verilog;
use verilog.vl_types.all;
entity IOPAD_VDD is
    port(
        OIN_P           : in     vl_logic;
        EIN_P           : in     vl_logic;
        IOUT_VDD        : in     vl_logic;
        OIN_VDD         : out    vl_logic;
        EIN_VDD         : out    vl_logic;
        IOUT_IN         : out    vl_logic
    );
end IOPAD_VDD;
