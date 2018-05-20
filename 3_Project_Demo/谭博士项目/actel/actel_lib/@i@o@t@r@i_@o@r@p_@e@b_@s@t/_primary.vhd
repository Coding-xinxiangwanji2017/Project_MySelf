library verilog;
use verilog.vl_types.all;
entity IOTRI_ORP_EB_ST is
    port(
        PRE             : in     vl_logic;
        CLK             : in     vl_logic;
        DOUT            : out    vl_logic;
        EOUT            : out    vl_logic;
        D               : in     vl_logic;
        E               : in     vl_logic
    );
end IOTRI_ORP_EB_ST;
