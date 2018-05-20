library verilog;
use verilog.vl_types.all;
entity IOTRI_OB_ERE is
    port(
        OCE             : in     vl_logic;
        OCLK            : in     vl_logic;
        EOUT            : out    vl_logic;
        DOUT            : out    vl_logic;
        E               : in     vl_logic;
        D               : in     vl_logic
    );
end IOTRI_OB_ERE;
