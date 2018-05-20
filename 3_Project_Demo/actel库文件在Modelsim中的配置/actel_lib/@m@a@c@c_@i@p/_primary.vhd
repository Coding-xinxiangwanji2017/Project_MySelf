library verilog;
use verilog.vl_types.all;
entity MACC_IP is
    port(
        A_CLK           : in     vl_logic_vector(1 downto 0);
        A               : in     vl_logic_vector(17 downto 0);
        A_EN            : in     vl_logic_vector(1 downto 0);
        A_ARST_N        : in     vl_logic_vector(1 downto 0);
        A_SRST_N        : in     vl_logic_vector(1 downto 0);
        A_BYPASS        : in     vl_logic_vector(1 downto 0);
        B_CLK           : in     vl_logic_vector(1 downto 0);
        B               : in     vl_logic_vector(17 downto 0);
        B_EN            : in     vl_logic_vector(1 downto 0);
        B_ARST_N        : in     vl_logic_vector(1 downto 0);
        B_SRST_N        : in     vl_logic_vector(1 downto 0);
        B_BYPASS        : in     vl_logic_vector(1 downto 0);
        C_CLK           : in     vl_logic_vector(1 downto 0);
        C               : in     vl_logic_vector(43 downto 0);
        CARRYIN         : in     vl_logic;
        C_EN            : in     vl_logic_vector(1 downto 0);
        C_ARST_N        : in     vl_logic_vector(1 downto 0);
        C_SRST_N        : in     vl_logic_vector(1 downto 0);
        C_BYPASS        : in     vl_logic_vector(1 downto 0);
        CDIN            : in     vl_logic_vector(43 downto 0);
        SUB_CLK         : in     vl_logic;
        SUB             : in     vl_logic;
        SUB_EN          : in     vl_logic;
        SUB_AL_N        : in     vl_logic;
        SUB_SL_N        : in     vl_logic;
        SUB_BYPASS      : in     vl_logic;
        SUB_AD          : in     vl_logic;
        SUB_SD_N        : in     vl_logic;
        ARSHFT17_CLK    : in     vl_logic;
        ARSHFT17        : in     vl_logic;
        ARSHFT17_EN     : in     vl_logic;
        ARSHFT17_AL_N   : in     vl_logic;
        ARSHFT17_SL_N   : in     vl_logic;
        ARSHFT17_BYPASS : in     vl_logic;
        ARSHFT17_AD     : in     vl_logic;
        ARSHFT17_SD_N   : in     vl_logic;
        FDBKSEL_CLK     : in     vl_logic;
        FDBKSEL         : in     vl_logic;
        FDBKSEL_EN      : in     vl_logic;
        FDBKSEL_AL_N    : in     vl_logic;
        FDBKSEL_SL_N    : in     vl_logic;
        FDBKSEL_BYPASS  : in     vl_logic;
        FDBKSEL_AD      : in     vl_logic;
        FDBKSEL_SD_N    : in     vl_logic;
        CDSEL_CLK       : in     vl_logic;
        CDSEL           : in     vl_logic;
        CDSEL_EN        : in     vl_logic;
        CDSEL_AL_N      : in     vl_logic;
        CDSEL_SL_N      : in     vl_logic;
        CDSEL_BYPASS    : in     vl_logic;
        CDSEL_AD        : in     vl_logic;
        CDSEL_SD_N      : in     vl_logic;
        P_CLK           : in     vl_logic_vector(1 downto 0);
        P_EN            : in     vl_logic_vector(1 downto 0);
        P_ARST_N        : in     vl_logic_vector(1 downto 0);
        P_SRST_N        : in     vl_logic_vector(1 downto 0);
        P_BYPASS        : in     vl_logic_vector(1 downto 0);
        SIMD            : in     vl_logic;
        DOTP            : in     vl_logic;
        OVFL_CARRYOUT_SEL: in     vl_logic;
        P               : out    vl_logic_vector(43 downto 0);
        OVFL_CARRYOUT   : out    vl_logic;
        CDOUT           : out    vl_logic_vector(43 downto 0)
    );
end MACC_IP;
