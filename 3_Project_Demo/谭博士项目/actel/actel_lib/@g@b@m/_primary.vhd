library verilog;
use verilog.vl_types.all;
entity GBM is
    port(
        An              : in     vl_logic;
        ENn             : in     vl_logic;
        YEn             : out    vl_logic;
        YWn             : out    vl_logic
    );
end GBM;
