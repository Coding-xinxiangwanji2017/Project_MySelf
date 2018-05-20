library verilog;
use verilog.vl_types.all;
entity IOPADN_OUT is
    port(
        PAD             : out    vl_logic;
        DB              : in     vl_logic
    );
end IOPADN_OUT;
