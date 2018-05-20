library verilog;
use verilog.vl_types.all;
entity cntlreg is
    port(
        clk             : in     vl_logic;
        d               : in     vl_logic;
        e               : in     vl_logic;
        al_b            : in     vl_logic;
        sl_b            : in     vl_logic;
        lat             : in     vl_logic;
        ad              : in     vl_logic;
        sd_b            : in     vl_logic;
        pwrdwn_b        : in     vl_logic;
        q               : out    vl_logic
    );
end cntlreg;
