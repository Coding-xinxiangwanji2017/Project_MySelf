library verilog;
use verilog.vl_types.all;
entity IP_INTERFACE is
    port(
        IPA             : out    vl_logic;
        IPB             : out    vl_logic;
        IPC             : out    vl_logic;
        A               : in     vl_logic;
        B               : in     vl_logic;
        C               : in     vl_logic
    );
end IP_INTERFACE;
