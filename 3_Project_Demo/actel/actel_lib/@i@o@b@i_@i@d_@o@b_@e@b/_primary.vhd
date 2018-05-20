library verilog;
use verilog.vl_types.all;
entity IOBI_ID_OB_EB is
    port(
        D               : in     vl_logic;
        CLR             : in     vl_logic;
        E               : in     vl_logic;
        ICLK            : in     vl_logic;
        YIN             : in     vl_logic;
        DOUT            : out    vl_logic;
        EOUT            : out    vl_logic;
        YR              : out    vl_logic;
        YF              : out    vl_logic
    );
end IOBI_ID_OB_EB;
