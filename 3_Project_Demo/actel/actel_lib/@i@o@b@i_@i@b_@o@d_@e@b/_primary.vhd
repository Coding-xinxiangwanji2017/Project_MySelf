library verilog;
use verilog.vl_types.all;
entity IOBI_IB_OD_EB is
    port(
        DR              : in     vl_logic;
        DF              : in     vl_logic;
        CLR             : in     vl_logic;
        E               : in     vl_logic;
        OCLK            : in     vl_logic;
        YIN             : in     vl_logic;
        DOUT            : out    vl_logic;
        EOUT            : out    vl_logic;
        Y               : out    vl_logic
    );
end IOBI_IB_OD_EB;
