library verilog;
use verilog.vl_types.all;
entity XTLOSC is
    generic(
        FREQUENCY       : real    := 2.000000e+001;
        MODE            : vl_logic_vector(1 downto 0) := (Hi1, Hi1)
    );
    port(
        XTL             : in     vl_logic;
        CLKOUT          : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of FREQUENCY : constant is 2;
    attribute mti_svvh_generic_type of MODE : constant is 2;
end XTLOSC;
