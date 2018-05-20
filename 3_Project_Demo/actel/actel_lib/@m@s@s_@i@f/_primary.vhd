library verilog;
use verilog.vl_types.all;
entity MSS_IF is
    port(
        PIN4            : in     vl_logic;
        PIN5            : in     vl_logic;
        PIN6            : in     vl_logic;
        PIN1            : out    vl_logic;
        PIN2            : out    vl_logic;
        PIN3            : out    vl_logic;
        PIN4INT         : out    vl_logic;
        PIN5INT         : out    vl_logic;
        PIN6INT         : out    vl_logic;
        PIN1INT         : in     vl_logic;
        PIN2INT         : in     vl_logic;
        PIN3INT         : in     vl_logic
    );
end MSS_IF;
