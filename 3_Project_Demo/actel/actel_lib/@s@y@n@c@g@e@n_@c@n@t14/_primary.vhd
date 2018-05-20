library verilog;
use verilog.vl_types.all;
entity SYNCGEN_CNT14 is
    port(
        clkin           : in     vl_logic;
        arst_b          : in     vl_logic;
        en_cnt          : in     vl_logic;
        cnt             : out    vl_logic_vector(13 downto 0)
    );
end SYNCGEN_CNT14;
