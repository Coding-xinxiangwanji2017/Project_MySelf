library verilog;
use verilog.vl_types.all;
entity SLE_IP_CLK is
    port(
        IPCLKn          : out    vl_logic;
        CLK             : in     vl_logic
    );
end SLE_IP_CLK;
