




--******************************************************************************************
--    Test Module
--******************************************************************************************
component print_fun is
   generic(
      FILE_NAME      : String;
      data_width     : Integer;
      pirnt_format   : String);
   port(
      Rst            : in  std_logic;
      Clk            : in  std_logic;
      din            : in  std_logic_vector( data_width -1 downto 0);
      din_v          : in  std_logic
    );
end component;
--******************************************************************************************










--******************************************************************************************
--    Test Module
--******************************************************************************************
U_M_Print : print_fun 
   generic map(
      FILE_NAME    => "tf_CC_Output_0.txt",
      data_width   => 2 ,
      pirnt_format => "%b"
      )
   port map(
      Rst          =>  Rst_Sys ,
      Clk          =>  Clk_Sys,
      din          =>  CC_ARRAY_D_Inv( 1 downto 0 )   ,
      din_v        =>  CC_ARRAY_D_Inv_V(0)
   );   
--******************************************************************************************










--******************************************************************************************
--    Test Module                                                                           
--******************************************************************************************
component print_fun_bit is                                                                      
   generic(                                                                                 
      FILE_NAME      : String);                                                             
   port(                                                                                    
      Rst            : in  std_logic;                                                       
      Clk            : in  std_logic;                                                       
      din            : in  std_logic;                       
      din_v          : in  std_logic                                                        
    );                                                                                      
end component;                                                                              
--******************************************************************************************




--******************************************************************************************
--    Test Module
--******************************************************************************************
U_M_Print : print_fun_bit 
   generic map(
      FILE_NAME    => "tf_CC_input_0.txt"
      )
   port map(
      Rst          =>  Rst_Sys ,
      Clk          =>  Clk_Sys,
      din          =>  i_CC_In_D(0),
      din_v        =>  i_CC_In_V(0) 
   );   
--******************************************************************************************  



    process (Rst_Sys, Clk_Sys)
    begin
        if (Rst_Sys = '1') then
             Reg_Comb         <= ( others =>'0' );
        elsif rising_edge(Clk_Sys) then
            if Vi_Sw_Data_V_D1(0) = '1'   then

                case i_ASM_Switch_Mode is
                when "001"  =>
                	      Reg_Comb         <= Vi_Sw_Data_D1( 63 downto   8) & Reg_shift_1;
                when "010"  =>
                	      Reg_Comb         <= Vi_Sw_Data_D1( 63 downto  16) & Reg_shift_2;
                when "011"  =>
                	      Reg_Comb         <= Vi_Sw_Data_D1( 63 downto  24) & Reg_shift_3;
                when "100"  =>
                	      Reg_Comb         <= Vi_Sw_Data_D1( 63 downto  32) & Reg_shift_4;
                when "101"  =>
                	      Reg_Comb         <= Vi_Sw_Data_D1( 63 downto  40) & Reg_shift_5;
                when "110"  =>
                	      Reg_Comb         <= Vi_Sw_Data_D1( 63 downto  48) & Reg_shift_6;
                when "111"  =>
                	       Reg_Comb        <= Vi_Sw_Data_D1( 63 downto  56) & Reg_Shift_7;
                when others  =>
                	       Reg_Comb        <= Vi_Sw_Data_D1 ;
                end case;

           end if;

        end if;
    end process;
    
    
    
    
    
    
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY EncoderV2    IS
PORT(
    CH_AB           :   IN  STD_LOGIC_VECTOR (1 downto 0);
    clk             :   IN  STD_LOGIC;
    nReset          :   IN  STD_LOGIC;
    up_dwn, Mag     :   OUT STD_LOGIC);

    END EncoderV2;

ARCHITECTURE a OF EncoderV2 IS  --  
TYPE STATE_TYPE IS ( START, s00, s01, s11, s10);
SIGNAL state:   STATE_TYPE;

BEGIN
PROCESS (clk, nReset)
BEGIN
    IF nReset = '0' THEN                        --    asynch Reset to zero
        state   <=  START;
    ELSIF clk'EVENT AND clk = '1' THEN          --  triggers on PGT
        CASE state IS 
            WHEN START =>
                    IF CH_AB ="00" THEN
                                state   <= s00;
                                Mag <='0';
                    ELSIF CH_AB="01" THEN
                                state   <= s01;
                                Mag <='0';
                    ELSIF CH_AB= "11" THEN
                                state   <= s11;
                                Mag <='0';
                    ELSIF CH_AB= "10" THEN
                                state   <= s10;
                                Mag <='0';
                    ELSE  state <= START;
                    END IF;

            WHEN s00 =>                 --  S10 <- S00 -> S01
                    IF CH_AB= "00" THEN
                                state   <= s00;
                                Mag <='0';
                    ELSIF CH_AB= "10" THEN
                                state   <= s10;
                                up_dwn  <= '0';
                                Mag <='1';
                    ELSIF CH_AB= "01" THEN
                                state   <= s01;
                                up_dwn  <='1';
                                Mag <='1';
                    ELSE  state <= START;
                    END IF;

            WHEN s01 =>                 --  S00 <- S01 -> S11
                    IF CH_AB= "01" THEN
                                state   <= s01;
                                Mag <='0';
                    ELSIF CH_AB= "00" THEN
                                state   <= s00;
                                up_dwn  <= '0';
                                Mag <='1';
                    ELSIF CH_AB= "11" THEN
                                state   <= s11;
                                up_dwn  <='1';
                                Mag <='1';
                    ELSE state <= START;
                    END IF;

            WHEN s11 =>                 --  S01 <- S11 ->S10
                    IF CH_AB= "11" THEN
                                state   <= s11;
                                Mag <='0';
                    ELSIF CH_AB= "01" THEN
                                state   <= s01;
                                up_dwn  <= '0';
                                Mag <='1';
                    ELSIF CH_AB= "10" THEN
                                state   <= s10;
                                up_dwn  <='1';
                                Mag <='1';
                    ELSE state <= START;
                    END IF;

            WHEN s10 =>                 --  S11 <- S10 -> S00
                    IF CH_AB= "10" THEN
                                state   <= s10;
                                Mag <='0';
                    ELSIF CH_AB= "11" THEN
                                state   <= s11;
                                up_dwn  <= '0';
                                Mag <='1';
                    ELSIF CH_AB= "00" THEN
                                state   <= s00;
                                up_dwn  <='1';
                                Mag <='1';
                    ELSE state <= START;
                    END IF;





            END CASE;
        END IF;
    END PROCESS;
END a;