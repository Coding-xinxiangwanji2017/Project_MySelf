library verilog;
use verilog.vl_types.all;
entity ABI_DIVQ is
    port(
        vco_in          : in     vl_logic;
        reset_reg       : in     vl_logic;
        DIVQ2           : in     vl_logic;
        DIVQ1           : in     vl_logic;
        DIVQ0           : in     vl_logic;
        divq_out        : out    vl_logic
    );
end ABI_DIVQ;
