library verilog;
use verilog.vl_types.all;
entity SLE_IP_EN is
    port(
        IPENn           : out    vl_logic;
        EN              : in     vl_logic
    );
end SLE_IP_EN;
