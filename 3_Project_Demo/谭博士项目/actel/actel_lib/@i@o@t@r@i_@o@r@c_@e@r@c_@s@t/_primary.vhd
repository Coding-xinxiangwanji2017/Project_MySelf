library verilog;
use verilog.vl_types.all;
entity IOTRI_ORC_ERC_ST is
    port(
        DOUT            : out    vl_logic;
        EOUT            : out    vl_logic;
        D               : in     vl_logic;
        CLK             : in     vl_logic;
        CLR             : in     vl_logic;
        E               : in     vl_logic
    );
end IOTRI_ORC_ERC_ST;
