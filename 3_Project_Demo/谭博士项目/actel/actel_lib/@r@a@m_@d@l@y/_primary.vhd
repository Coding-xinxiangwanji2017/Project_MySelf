library verilog;
use verilog.vl_types.all;
entity RAM_DLY is
    port(
        \IN\            : in     vl_logic_vector(17 downto 0);
        \OUT\           : out    vl_logic_vector(17 downto 0)
    );
end RAM_DLY;
