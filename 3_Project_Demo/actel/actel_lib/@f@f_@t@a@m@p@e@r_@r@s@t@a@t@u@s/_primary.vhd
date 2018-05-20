library verilog;
use verilog.vl_types.all;
entity FF_TAMPER_RSTATUS is
    generic(
        ZEROIZE_CONFIG  : string  := "";
        POWERUP_DIGEST_ERROR_CONFIG: string  := "";
        CLK_ERROR_CONFIG: integer := 0
    );
    port(
        FF_TO_START     : out    vl_logic;
        FF_DONE         : out    vl_logic;
        JTAG_ACTIVE     : out    vl_logic;
        LOCK_TAMPER_DETECT: out    vl_logic;
        MESH_SHORT_ERROR: out    vl_logic;
        CLK_ERROR       : out    vl_logic;
        DETECT_CATEGORY : out    vl_logic_vector(3 downto 0);
        DETECT_ATTEMPT  : out    vl_logic;
        DETECT_FAIL     : out    vl_logic;
        DIGEST_ERROR    : out    vl_logic;
        POWERUP_DIGEST_ERROR: out    vl_logic;
        SC_ROM_DIGEST_ERROR: out    vl_logic;
        TAMPER_CHANGE_STROBE: out    vl_logic;
        RESET_STATUS    : out    vl_logic;
        LOCKDOWN_ALL_N  : in     vl_logic;
        DISABLE_ALL_IOS_N: in     vl_logic;
        RESET_N         : in     vl_logic;
        ZEROIZE_N       : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ZEROIZE_CONFIG : constant is 1;
    attribute mti_svvh_generic_type of POWERUP_DIGEST_ERROR_CONFIG : constant is 1;
    attribute mti_svvh_generic_type of CLK_ERROR_CONFIG : constant is 1;
end FF_TAMPER_RSTATUS;
