LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL; -- Two very useful
use IEEE.STD_LOGIC_UNSIGNED.ALL; -- IEEE libraries

ENTITY remapper IS


    PORT
    (

        clock   : IN    STD_LOGIC;
        
        r1      : IN    STD_LOGIC_VECTOR(11 DOWNTO 0);
        r2      : IN    STD_LOGIC_VECTOR(11 DOWNTO 0);
        r3      : IN    STD_LOGIC_VECTOR(11 DOWNTO 0);
        r4      : IN    STD_LOGIC_VECTOR(11 DOWNTO 0);

        g1      : IN    STD_LOGIC_VECTOR(11 DOWNTO 0);
        g2      : IN    STD_LOGIC_VECTOR(11 DOWNTO 0);
        g3      : IN    STD_LOGIC_VECTOR(11 DOWNTO 0);
        g4      : IN    STD_LOGIC_VECTOR(11 DOWNTO 0);
        
        b1      : IN    STD_LOGIC_VECTOR(11 DOWNTO 0);
        b2      : IN    STD_LOGIC_VECTOR(11 DOWNTO 0);
        b3      : IN    STD_LOGIC_VECTOR(11 DOWNTO 0);
        b4      : IN    STD_LOGIC_VECTOR(11 DOWNTO 0);

        
        hsync   : IN    STD_LOGIC;
        vsync   : IN    STD_LOGIC;
        
        
        -- p1      : OUT   STD_LOGIC_VECTOR(6 DOWNTO 0);
        -- p2      : OUT   STD_LOGIC_VECTOR(6 DOWNTO 0);
        -- p3      : OUT   STD_LOGIC_VECTOR(6 DOWNTO 0);
        -- p4      : OUT   STD_LOGIC_VECTOR(6 DOWNTO 0);

       -- pardata : OUT   STD_LOGIC_VECTOR(55 downto 0)

        pardata_l   :   OUT   STD_LOGIC_VECTOR(90 downto 0);
        pardata_h   :   OUT   STD_LOGIC_VECTOR(104 downto 0);
        -- c       : OUT   STD_LOGIC_VECTOR(6 downto 0)

        pardata : OUT   STD_LOGIC_VECTOR(55 downto 0)
    );
    
END remapper;

ARCHITECTURE a OF remapper IS



        signal p1      : STD_LOGIC_VECTOR(41 DOWNTO 0);
        signal p2      : STD_LOGIC_VECTOR(41 DOWNTO 0);
        signal p3      : STD_LOGIC_VECTOR(41 DOWNTO 0);
        signal p4      : STD_LOGIC_VECTOR(41 DOWNTO 0);

        signal c      : STD_LOGIC_VECTOR(6 DOWNTO 0);
        signal n      : STD_LOGIC_VECTOR(6 DOWNTO 0);

        signal matrix : STD_LOGIC_VECTOR(55 downto 0);

        signal matrixl : STD_LOGIC_VECTOR(90 downto 0);
        signal matrixh : STD_LOGIC_VECTOR(104 downto 0);


       -- signal count : integer range 0 to 100 := 0;
       constant w      : integer := 8;  -- 8 output lines

begin

--  p1(6) <= hsync;
--  p1(5) <= hsync;
--  p1(4) <= hsync;
--  p1(3) <= hsync;
--  p1(2) <= hsync;
--  p1(1) <= hsync;
--  p1(0) <= hsync;
--  
--  
--  p2(6) <= hsync;
--  p2(5) <= '0';
--  p2(4) <= '0';
--  p2(3) <= '0';
--  p2(2) <= '0';
--  p2(1) <= '0';
--  p2(0) <= '0';
--
--  p3(6) <= '0';
--  p3(5) <= '0';
--  p3(4) <= '0';
--  p3(3) <= '0';
--  p3(2) <= '0';
--  p3(1) <= '0';
--  p3(0) <= hsync;
--
--  p4(6) <= '0';
--  p4(5) <= '0';
--  p4(4) <= '0';
--  p4(3) <= hsync;
--  p4(2) <= '0';
--  p4(1) <= '0';
--  p4(0) <= '1';
--  

    
--pixel data    
--    p1(6) <= hsync;
--    p1(5) <= vsync;
--    p1(4 downto 0) <= g1(11 downto 7);
--
--    p2(6) <= hsync;
--    p2(5) <= vsync;
--    p2(4 downto 0) <= g2(11 downto 7);
--
--    p3(6) <= hsync;
--    p3(5) <= vsync;
--    p3(4 downto 0) <= g3(11 downto 7);
--
--    p4(6) <= hsync;
--    p4(5) <= vsync;
--    p4(4 downto 0) <= g4(11 downto 7);

    p1(6 downto 0)   <= ("1100011");                            --1clock line
    p1(13 downto 7)  <= (hsync & vsync & g1(11 downto 7));      --1A line   the only data line used on the handmade release
    p1(20 downto 14) <= (g1(6 downto 0));                       --1B line
    p1(27 downto 21) <= (r1(11 downto 5));                      --1C line
    p1(34 downto 28) <= (r1(4 downto 0) & b1(11 downto 10));    --1d line
    p1(41 downto 35) <= (b1(9 downto 3));                       --1e line
                                                            --1f line not used because of to less LVDS lines on demoboard
                                                            --blue LSB 2 downto 0 not transmitted


    p2(6 downto 0)   <= "1100011";                          --2clock line
    p2(13 downto 7)  <= hsync & vsync & g2(11 downto 7);    --2A line
    p2(20 downto 14) <= g2(6 downto 0);                     --2B line
    p2(27 downto 21) <= (r2(11 downto 5));                      --2C line
    p2(34 downto 28) <= (r2(4 downto 0) & b2(11 downto 10));    --2d line
    p2(41 downto 35) <= b2(9 downto 3);                     --2e line
                                                            --2f line not used
                                                            --blue LSB 2 downto 0 not transmitted


    p3(6 downto 0)   <= "1100011";                          --3clock line
    p3(13 downto 7)  <= (hsync & vsync & g3(11 downto 7));      --3A line
    p3(20 downto 14) <= (g3(6 downto 0));                       --3B line
    p3(27 downto 21) <= r3(11 downto 5);                    --3C line
    p3(34 downto 28) <= r3(4 downto 0) & b3(11 downto 10);  --3d line
    p3(41 downto 35) <= (b3(9 downto 3));                       --3e line
                                                            --3f line not used
                                                            --blue LSB 2 downto 0 not transmitted

    p4(6 downto 0)   <= ("1100011");                            --4clock line
    p4(13 downto 7)  <= hsync & vsync & g4(11 downto 7);    --4A line
    p4(20 downto 14) <= (g4(6 downto 0));                       --4B line
    p4(27 downto 21) <= (r4(11 downto 5));                      --4C line
    p4(34 downto 28) <= r4(4 downto 0) & b4(11 downto 10);  --4d line
    p4(41 downto 35) <= (b4(9 downto 3));                       --4e line
                                                            --4f line not used
                                                            --blue LSB 2 downto 0 not transmitted


    c <= "1100011";
    n <= "0000000";


    --matrix <= p1 & c & p2 & c & p3 & c & p4 & c;
   -- matrix <= not c & not c & not p2 & p4 & not c & not p3 & not p1 & not c  ;


    matrixh <= p3(20 downto 14) & not (p2(41 downto 35)) &  p3(13 downto 7) & not (p3(27 downto 21)) &  p3(41 downto 35)
            & not (p3(6 downto 0)) &  not (p3(34 downto 28)) & n &  p4(27 downto 21) & not (p4(13 downto 7)) &  p4(6 downto 0)
            & p4(20 downto 14) & not (p4(34 downto 28)) & n & p4(41 downto 35);

    matrixl <= p1(27 downto 21) & p1(34 downto 28) &  p1(13 downto 7) &  p1(6 downto 0) & n & p1(41 downto 35) &  p2(27 downto 21) & p1(20 downto 14)
            & not (p2(13 downto 7)) & not (p2(20 downto 14)) & not (p2(6 downto 0)) & p2(34 downto 28) & n;



--dataswap: for count in 0 to 7*w-1 generate
----
--   begin
--
--     pardata(count) <= matrix((count mod w)*7 + 6-count/w);
--
--   end generate dataswap;

dataswaph: for count in 0 to 7*15-1 generate
--
   begin

     pardata_h(count) <= matrixh((count mod 15)*7 + 6-count/15);

   end generate dataswaph;

dataswapl: for count in 0 to 7*13-1 generate
--
   begin

     pardata_l(count) <= matrixl((count mod 13)*7 + 6-count/13);

   end generate dataswapl;



end a;

