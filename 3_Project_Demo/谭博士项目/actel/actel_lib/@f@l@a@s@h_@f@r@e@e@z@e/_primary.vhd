library verilog;
use verilog.vl_types.all;
entity FLASH_FREEZE is
    port(
        FF_TO_START     : out    vl_logic;
        FF_DONE         : out    vl_logic
    );
end FLASH_FREEZE;
