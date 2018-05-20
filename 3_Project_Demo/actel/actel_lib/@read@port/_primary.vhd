library verilog;
use verilog.vl_types.all;
entity ReadPort is
    port(
        MEM             : in     vl_logic_vector(17 downto 0);
        ADDR            : in     vl_logic_vector(3 downto 0);
        WIDTH           : in     vl_logic_vector(2 downto 0);
        BLK             : in     vl_logic;
        DOUT            : out    vl_logic_vector(17 downto 0)
    );
end ReadPort;
