library verilog;
use verilog.vl_types.all;
entity RAM4K9 is
    generic(
        MEMORYFILE      : string  := "";
        WARNING_MSGS_ON : integer := 1
    );
    port(
        ADDRA11         : in     vl_logic;
        ADDRA10         : in     vl_logic;
        ADDRA9          : in     vl_logic;
        ADDRA8          : in     vl_logic;
        ADDRA7          : in     vl_logic;
        ADDRA6          : in     vl_logic;
        ADDRA5          : in     vl_logic;
        ADDRA4          : in     vl_logic;
        ADDRA3          : in     vl_logic;
        ADDRA2          : in     vl_logic;
        ADDRA1          : in     vl_logic;
        ADDRA0          : in     vl_logic;
        DINA8           : in     vl_logic;
        DINA7           : in     vl_logic;
        DINA6           : in     vl_logic;
        DINA5           : in     vl_logic;
        DINA4           : in     vl_logic;
        DINA3           : in     vl_logic;
        DINA2           : in     vl_logic;
        DINA1           : in     vl_logic;
        DINA0           : in     vl_logic;
        DOUTA8          : out    vl_logic;
        DOUTA7          : out    vl_logic;
        DOUTA6          : out    vl_logic;
        DOUTA5          : out    vl_logic;
        DOUTA4          : out    vl_logic;
        DOUTA3          : out    vl_logic;
        DOUTA2          : out    vl_logic;
        DOUTA1          : out    vl_logic;
        DOUTA0          : out    vl_logic;
        WIDTHA1         : in     vl_logic;
        WIDTHA0         : in     vl_logic;
        PIPEA           : in     vl_logic;
        WMODEA          : in     vl_logic;
        BLKA            : in     vl_logic;
        WENA            : in     vl_logic;
        CLKA            : in     vl_logic;
        ADDRB11         : in     vl_logic;
        ADDRB10         : in     vl_logic;
        ADDRB9          : in     vl_logic;
        ADDRB8          : in     vl_logic;
        ADDRB7          : in     vl_logic;
        ADDRB6          : in     vl_logic;
        ADDRB5          : in     vl_logic;
        ADDRB4          : in     vl_logic;
        ADDRB3          : in     vl_logic;
        ADDRB2          : in     vl_logic;
        ADDRB1          : in     vl_logic;
        ADDRB0          : in     vl_logic;
        DINB8           : in     vl_logic;
        DINB7           : in     vl_logic;
        DINB6           : in     vl_logic;
        DINB5           : in     vl_logic;
        DINB4           : in     vl_logic;
        DINB3           : in     vl_logic;
        DINB2           : in     vl_logic;
        DINB1           : in     vl_logic;
        DINB0           : in     vl_logic;
        DOUTB8          : out    vl_logic;
        DOUTB7          : out    vl_logic;
        DOUTB6          : out    vl_logic;
        DOUTB5          : out    vl_logic;
        DOUTB4          : out    vl_logic;
        DOUTB3          : out    vl_logic;
        DOUTB2          : out    vl_logic;
        DOUTB1          : out    vl_logic;
        DOUTB0          : out    vl_logic;
        WIDTHB1         : in     vl_logic;
        WIDTHB0         : in     vl_logic;
        PIPEB           : in     vl_logic;
        WMODEB          : in     vl_logic;
        BLKB            : in     vl_logic;
        WENB            : in     vl_logic;
        CLKB            : in     vl_logic;
        RESET           : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of MEMORYFILE : constant is 1;
    attribute mti_svvh_generic_type of WARNING_MSGS_ON : constant is 1;
end RAM4K9;
