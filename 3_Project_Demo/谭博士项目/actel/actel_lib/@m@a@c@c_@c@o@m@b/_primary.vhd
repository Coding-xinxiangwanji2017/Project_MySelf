library verilog;
use verilog.vl_types.all;
entity MACC_COMB is
    port(
        a_comb_b        : in     vl_logic_vector(17 downto 0);
        b_comb_b        : in     vl_logic_vector(17 downto 0);
        c_comb_b        : in     vl_logic_vector(43 downto 0);
        cdin_comb       : in     vl_logic_vector(43 downto 0);
        fdbk_comb       : in     vl_logic_vector(43 downto 0);
        sel0_comb_b     : in     vl_logic;
        sel1_comb_b     : in     vl_logic;
        shft_comb_b     : in     vl_logic;
        sub_comb_b      : in     vl_logic;
        carryin_comb_b  : in     vl_logic;
        mode0           : in     vl_logic;
        mode1           : in     vl_logic;
        mode2           : in     vl_logic;
        p_comb_b        : out    vl_logic_vector(43 downto 0);
        ovfl_ext_comb_b : out    vl_logic;
        cdout           : out    vl_logic_vector(43 downto 0)
    );
end MACC_COMB;
