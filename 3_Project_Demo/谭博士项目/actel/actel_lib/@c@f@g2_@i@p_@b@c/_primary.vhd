library verilog;
use verilog.vl_types.all;
entity CFG2_IP_BC is
    port(
        IPB             : out    vl_logic;
        IPC             : out    vl_logic;
        B               : in     vl_logic;
        C               : in     vl_logic
    );
end CFG2_IP_BC;
