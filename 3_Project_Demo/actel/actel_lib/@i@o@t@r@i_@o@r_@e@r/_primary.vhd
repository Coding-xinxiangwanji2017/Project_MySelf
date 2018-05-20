library verilog;
use verilog.vl_types.all;
entity IOTRI_OR_ER is
    port(
        EOUT            : out    vl_logic;
        DOUT            : out    vl_logic;
        E               : in     vl_logic;
        OCLK            : in     vl_logic;
        D               : in     vl_logic
    );
end IOTRI_OR_ER;
