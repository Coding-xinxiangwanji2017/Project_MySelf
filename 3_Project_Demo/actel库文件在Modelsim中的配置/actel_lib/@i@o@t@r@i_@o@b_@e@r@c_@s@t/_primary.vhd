library verilog;
use verilog.vl_types.all;
entity IOTRI_OB_ERC_ST is
    port(
        CLR             : in     vl_logic;
        CLK             : in     vl_logic;
        EOUT            : out    vl_logic;
        DOUT            : out    vl_logic;
        E               : in     vl_logic;
        D               : in     vl_logic
    );
end IOTRI_OB_ERC_ST;
