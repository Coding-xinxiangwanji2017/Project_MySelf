library verilog;
use verilog.vl_types.all;
entity VRPSM is
    port(
        PUB             : in     vl_logic;
        VRPU            : in     vl_logic;
        VRINITSTATE     : in     vl_logic;
        RTCPSMMATCH     : in     vl_logic;
        FPGAGOOD        : out    vl_logic;
        PUCORE          : out    vl_logic
    );
end VRPSM;
