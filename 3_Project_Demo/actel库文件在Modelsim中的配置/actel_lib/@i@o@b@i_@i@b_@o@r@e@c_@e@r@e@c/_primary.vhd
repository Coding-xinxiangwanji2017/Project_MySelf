library verilog;
use verilog.vl_types.all;
entity IOBI_IB_OREC_EREC is
    port(
        DOUT            : out    vl_logic;
        EOUT            : out    vl_logic;
        Y               : out    vl_logic;
        D               : in     vl_logic;
        OCLK            : in     vl_logic;
        CLR             : in     vl_logic;
        OCE             : in     vl_logic;
        E               : in     vl_logic;
        YIN             : in     vl_logic
    );
end IOBI_IB_OREC_EREC;
