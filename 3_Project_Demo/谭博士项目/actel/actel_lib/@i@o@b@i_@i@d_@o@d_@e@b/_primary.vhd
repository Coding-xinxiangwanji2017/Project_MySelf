library verilog;
use verilog.vl_types.all;
entity IOBI_ID_OD_EB is
    port(
        E               : in     vl_logic;
        DOUT            : out    vl_logic;
        OCLK            : in     vl_logic;
        CLR             : in     vl_logic;
        DR              : in     vl_logic;
        DF              : in     vl_logic;
        YR              : out    vl_logic;
        YF              : out    vl_logic;
        ICLK            : in     vl_logic;
        YIN             : in     vl_logic;
        EOUT            : out    vl_logic
    );
end IOBI_ID_OD_EB;
