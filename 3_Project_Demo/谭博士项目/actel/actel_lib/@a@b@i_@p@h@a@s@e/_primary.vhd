library verilog;
use verilog.vl_types.all;
entity ABI_PHASE is
    port(
        pllout4x_in     : in     vl_logic;
        reset_reg       : in     vl_logic;
        out_000         : out    vl_logic;
        out_045         : out    vl_logic;
        out_090         : out    vl_logic;
        out_135         : out    vl_logic;
        out_180         : out    vl_logic;
        out_225         : out    vl_logic;
        out_270         : out    vl_logic;
        out_315         : out    vl_logic
    );
end ABI_PHASE;
