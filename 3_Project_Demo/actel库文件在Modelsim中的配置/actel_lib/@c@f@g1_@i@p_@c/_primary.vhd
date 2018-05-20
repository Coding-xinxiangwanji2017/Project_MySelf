library verilog;
use verilog.vl_types.all;
entity CFG1_IP_C is
    port(
        IPC             : out    vl_logic;
        C               : in     vl_logic
    );
end CFG1_IP_C;
