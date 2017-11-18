-- WARNING: Do NOT edit the input and output ports in this file in a text
-- editor if you plan to continue editing the block that represents it in
-- the Block Editor! File corruption is VERY likely to occur.

-- Copyright (C) 1991-2008 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions
-- and other software and tools, and its AMPP partner logic
-- functions, and any output files from any of the foregoing
-- (including device programming or simulation files), and any
-- associated documentation or information are expressly subject
-- to the terms and conditions of the Altera Program License

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY gen_int IS
	-- {{ALTERA_IO_BEGIN}} DO NOT REMOVE THIS LINE!
	PORT
	(

		clk  :in   std_logic;
		clk_1k :in std_logic;
		reset :in   std_logic;
		DPRU_ASK :in   std_logic;
		cs_clrint :in  std_logic;
		INT    :OUT  std_logic
	);

END gen_int;
ARCHITECTURE gen_int_architecture OF gen_int IS


signal  DPRU_ASK_Vector  :std_logic_vector(1 downto 0);
signal  Int_State_vector : std_logic_vector(1 downto 0);
signal  clk_1k_vector  :std_logic_vector(1 downto 0);

begin

process(clk)

variable  counter_500   :integer range 0 to 500;
variable  frame_count_signal  :std_logic_vector(15 downto 0);

begin

	if rising_edge(clk)  then


		DPRU_ASK_Vector(0)<=DPRU_ASK;
		DPRU_ASK_Vector(1)<=DPRU_ASK_Vector(0);
		clk_1k_vector(0)<=clk_1k;
		clk_1k_vector(1)<=clk_1k_vector(0);


        if(RESET='0') then --��λ�źţ�����Ч
            counter_500:=0;
			DPRU_ASK_Vector<="00";
			INT<='1';
			Int_State_vector<="00";
        end if;

        case Int_State_vector is
			when "00" =>
				counter_500:=0;
				INT<='1';
                if(DPRU_ASK_Vector="01") then   -- rising_edge
					Int_State_vector<="01";
                end if;

			when "01"  =>
                if(clk_1k_vector="01") then
					counter_500:= counter_500+1;
                elsif(DPRU_ASK_Vector="01")  then
					counter_500:=0;
                end if;

                if(counter_500=400) then
					INT<='0';
					Int_State_vector<="10";
                end if;

			when "10"  =>
                if(cs_clrint='0') then
					INT<='1';
					Int_State_vector<="11";
                end if;

			when "11"  =>
                if(DPRU_ASK_Vector="01") then
					Int_State_vector<="00";
                end if;

			when others =>
				Int_State_vector<="00";

		end case;

	end if;

end process;
END gen_int_architecture;
