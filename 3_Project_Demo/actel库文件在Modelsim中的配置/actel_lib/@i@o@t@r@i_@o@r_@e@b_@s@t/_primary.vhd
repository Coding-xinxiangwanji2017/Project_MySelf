library verilog;
use verilog.vl_types.all;
entity IOTRI_OR_EB_ST is
    port(
        CLK             : in     vl_logic;
        DOUT            : out    vl_logic;
        EOUT            : out    vl_logic;
        D               : in     vl_logic;
        E               : in     vl_logic
    );
end IOTRI_OR_EB_ST;
