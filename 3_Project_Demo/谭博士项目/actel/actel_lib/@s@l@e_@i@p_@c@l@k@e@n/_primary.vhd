library verilog;
use verilog.vl_types.all;
entity SLE_IP_CLKEN is
    port(
        IPCLKn          : out    vl_logic;
        IPENn           : out    vl_logic;
        CLK             : in     vl_logic;
        EN              : in     vl_logic
    );
end SLE_IP_CLKEN;
