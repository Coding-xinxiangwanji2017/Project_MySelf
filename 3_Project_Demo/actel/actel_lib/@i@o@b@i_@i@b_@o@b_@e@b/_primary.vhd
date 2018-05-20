library verilog;
use verilog.vl_types.all;
entity IOBI_IB_OB_EB is
    port(
        D               : in     vl_logic;
        E               : in     vl_logic;
        YIN             : in     vl_logic;
        DOUT            : out    vl_logic;
        EOUT            : out    vl_logic;
        Y               : out    vl_logic
    );
end IOBI_IB_OB_EB;
