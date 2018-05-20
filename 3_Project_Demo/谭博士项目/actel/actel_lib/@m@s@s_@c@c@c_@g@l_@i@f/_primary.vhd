library verilog;
use verilog.vl_types.all;
entity MSS_CCC_GL_IF is
    port(
        PIN2            : in     vl_logic;
        PIN3            : in     vl_logic;
        PIN4            : in     vl_logic;
        PIN1            : out    vl_logic;
        PIN5            : out    vl_logic;
        PIN2INT         : out    vl_logic;
        PIN3INT         : out    vl_logic;
        PIN4INT         : out    vl_logic;
        PIN1INT         : in     vl_logic;
        PIN5INT         : in     vl_logic
    );
end MSS_CCC_GL_IF;
