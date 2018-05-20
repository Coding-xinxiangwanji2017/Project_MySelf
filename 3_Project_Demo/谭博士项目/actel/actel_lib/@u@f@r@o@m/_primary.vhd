library verilog;
use verilog.vl_types.all;
entity UFROM is
    generic(
        MEMORYFILE      : string  := "";
        DATA_X          : integer := 1;
        ACT_PROGFILE    : string  := ""
    );
    port(
        ADDR6           : in     vl_logic;
        ADDR5           : in     vl_logic;
        ADDR4           : in     vl_logic;
        ADDR3           : in     vl_logic;
        ADDR2           : in     vl_logic;
        ADDR1           : in     vl_logic;
        ADDR0           : in     vl_logic;
        CLK             : in     vl_logic;
        DO7             : out    vl_logic;
        DO6             : out    vl_logic;
        DO5             : out    vl_logic;
        DO4             : out    vl_logic;
        DO3             : out    vl_logic;
        DO2             : out    vl_logic;
        DO1             : out    vl_logic;
        DO0             : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of MEMORYFILE : constant is 1;
    attribute mti_svvh_generic_type of DATA_X : constant is 1;
    attribute mti_svvh_generic_type of ACT_PROGFILE : constant is 1;
end UFROM;
