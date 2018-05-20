library verilog;
use verilog.vl_types.all;
entity CLKDIVDLY1_SDF is
    port(
        CLK             : in     vl_logic;
        DLYY0           : in     vl_logic;
        DLYY1           : in     vl_logic;
        DLYY2           : in     vl_logic;
        DLYY3           : in     vl_logic;
        DLYY4           : in     vl_logic;
        DLYGL0          : in     vl_logic;
        DLYGL1          : in     vl_logic;
        DLYGL2          : in     vl_logic;
        DLYGL3          : in     vl_logic;
        DLYGL4          : in     vl_logic;
        GL              : out    vl_logic;
        Y               : out    vl_logic
    );
end CLKDIVDLY1_SDF;
