library verilog;
use verilog.vl_types.all;
entity IOBI_IB_ORE_ERE is
    port(
        Y               : out    vl_logic;
        DOUT            : out    vl_logic;
        EOUT            : out    vl_logic;
        YIN             : in     vl_logic;
        D               : in     vl_logic;
        OCLK            : in     vl_logic;
        OCE             : in     vl_logic;
        E               : in     vl_logic
    );
end IOBI_IB_ORE_ERE;
