library verilog;
use verilog.vl_types.all;
entity RSTN_SYNC is
    port(
        rstn_out        : out    vl_logic;
        rstn_in         : in     vl_logic;
        clk             : in     vl_logic
    );
end RSTN_SYNC;
