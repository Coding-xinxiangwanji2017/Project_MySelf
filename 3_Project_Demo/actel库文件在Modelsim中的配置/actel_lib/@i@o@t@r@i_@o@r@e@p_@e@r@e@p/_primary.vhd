library verilog;
use verilog.vl_types.all;
entity IOTRI_OREP_EREP is
    port(
        DOUT            : out    vl_logic;
        EOUT            : out    vl_logic;
        D               : in     vl_logic;
        OCLK            : in     vl_logic;
        OCE             : in     vl_logic;
        PRE             : in     vl_logic;
        E               : in     vl_logic
    );
end IOTRI_OREP_EREP;
