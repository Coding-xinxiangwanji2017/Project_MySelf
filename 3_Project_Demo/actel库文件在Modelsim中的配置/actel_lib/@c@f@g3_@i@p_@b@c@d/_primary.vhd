library verilog;
use verilog.vl_types.all;
entity CFG3_IP_BCD is
    port(
        IPB             : out    vl_logic;
        IPC             : out    vl_logic;
        IPD             : out    vl_logic;
        B               : in     vl_logic;
        C               : in     vl_logic;
        D               : in     vl_logic
    );
end CFG3_IP_BCD;
