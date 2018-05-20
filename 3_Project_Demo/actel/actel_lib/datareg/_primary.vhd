library verilog;
use verilog.vl_types.all;
entity datareg is
    port(
        clk             : in     vl_logic;
        d               : in     vl_logic;
        e               : in     vl_logic;
        arst_b          : in     vl_logic;
        srst_b          : in     vl_logic;
        lat             : in     vl_logic;
        pwrdwn_b        : in     vl_logic;
        q               : out    vl_logic
    );
end datareg;
