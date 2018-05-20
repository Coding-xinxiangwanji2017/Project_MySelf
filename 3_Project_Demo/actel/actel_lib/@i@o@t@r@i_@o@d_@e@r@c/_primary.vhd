library verilog;
use verilog.vl_types.all;
entity IOTRI_OD_ERC is
    port(
        E               : in     vl_logic;
        EOUT            : out    vl_logic;
        DOUT            : out    vl_logic;
        OCLK            : in     vl_logic;
        CLR             : in     vl_logic;
        DR              : in     vl_logic;
        DF              : in     vl_logic
    );
end IOTRI_OD_ERC;
