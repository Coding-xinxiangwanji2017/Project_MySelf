library verilog;
use verilog.vl_types.all;
entity IOBI_IRE_OB_ER is
    port(
        DOUT            : out    vl_logic;
        EOUT            : out    vl_logic;
        Y               : out    vl_logic;
        D               : in     vl_logic;
        E               : in     vl_logic;
        OCLK            : in     vl_logic;
        YIN             : in     vl_logic;
        ICLK            : in     vl_logic;
        ICE             : in     vl_logic
    );
end IOBI_IRE_OB_ER;
