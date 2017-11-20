----------------------------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_arith.all;
  use ieee.std_logic_misc.all;
  use ieee.std_logic_unsigned.all;
library unisim;
  use unisim.vcomponents.all;

entity fmc116_ltc2656_ctrl is
generic (
  START_ADDR      : std_logic_vector(27 downto 0) := x"0000000";
  STOP_ADDR       : std_logic_vector(27 downto 0) := x"00000FF";
  PRESEL          : std_logic_vector(7 downto 0) := x"00"
);
port (
  rst             : in  std_logic;
  clk             : in  std_logic;
  serial_clk      : in  std_logic;
  sclk_ext        : in  std_logic;
  -- Sequence interface
  init_ena        : in  std_logic;
  init_done       : out std_logic;
  -- Command Interface
  clk_cmd         : in  std_logic;
  in_cmd_val      : in  std_logic;
  in_cmd          : in  std_logic_vector(63 downto 0);
  out_cmd_val     : out std_logic;
  out_cmd         : out std_logic_vector(63 downto 0);
  in_cmd_busy     : out std_logic;
  -- Direct control
  dac_n_reset     : out std_logic;
  -- SPI control
  spi_n_oe        : out std_logic;
  spi_n_cs        : out std_logic;
  spi_sclk        : out std_logic;
  spi_sdo         : out std_logic;
  spi_sdi         : in  std_logic
);
end fmc116_ltc2656_ctrl;

architecture fmc116_ltc2656_ctrl_syn of fmc116_ltc2656_ctrl is

component fmc11x_stellar_cmd is
generic
(
   start_addr                    :std_logic_vector(27 downto 0):=x"0000000";
   stop_addr                     :std_logic_vector(27 downto 0):=x"0000010"
   );

port (
   reset            : in  std_logic;
   -- Command interface
   clk_cmd          : in  std_logic;                    --cmd_in and cmd_out are synchronous to this clock;
   out_cmd          : out std_logic_vector(63 downto 0);
   out_cmd_val      : out std_logic;
   in_cmd           : in  std_logic_vector(63 downto 0);
   in_cmd_val       : in  std_logic;
   -- Register interface
   clk_reg          : in  std_logic;                    --register interface is synchronous to this clock
   out_reg          : out std_logic_vector(31 downto 0);--caries the out register data
   out_reg_val      : out std_logic;                    --the out_reg has valid data  (pulse)
   out_reg_val_ack  : out std_logic;                    --the out_reg has valid data and expects and acknowledge back  (pulse)
   out_reg_addr     : out std_logic_vector(27 downto 0);--out register address
   in_reg           : in  std_logic_vector(31 downto 0);--requested register data is placed on this bus
   in_reg_val       : in  std_logic;                    --pulse to indicate requested register is valid
   in_reg_req       : out std_logic;                    --pulse to request data
   in_reg_addr      : out std_logic_vector(27 downto 0);--requested address
   --write acknowledge interface
   wr_ack           : in  std_logic;                      --pulse to indicate write is done
   -- Mailbox interface
   mbx_in_reg       : in  std_logic_vector(31 downto 0);--value of the mailbox to send
   mbx_in_val       : in  std_logic                     --pulse to indicate mailbox is valid
);
end component;

component pulse2pulse
port (
  rst      : in  std_logic;
  in_clk   : in  std_logic;
  out_clk  : in  std_logic;
  pulsein  : in  std_logic;
  pulseout : out std_logic;
  inbusy   : out std_logic
);
end component;

component ltc2656_init_mem is
port (
  clka  : in  std_logic;
  addra : in  std_logic_vector(3 downto 0);
  douta : out std_logic_vector(23 downto 0)
);
end component;

constant ADDR_GLOBAL  : std_logic_vector(27 downto 0) := x"0000100";
constant ADDR_MAX_WR  : std_logic_vector(27 downto 0) := x"00000FF";
constant ADDR_MAX_RD  : std_logic_vector(27 downto 0) := x"00000FF";

type sh_states is (idle, instruct, data_io, data_valid);
signal sh_state       : sh_states;

--signal sclk_prebuf    : std_logic;
--signal serial_clk     : std_logic;
--signal sclk_ext       : std_logic;

signal out_reg_val    : std_logic;
signal out_reg_addr   : std_logic_vector(27 downto 0);
signal out_reg        : std_logic_vector(31 downto 0);

signal out_reg_val_ack                   : std_logic;
signal wr_ack                            : std_logic;
signal serial_val_ack                    : std_logic;
signal serial_val_ack_sclk               : std_logic;
signal busy_del1                         : std_logic;
signal busy_del2                         : std_logic;
signal init_done_sclk_del                : std_logic;
signal wr_cmd_ack                        : std_logic;
signal wr_ack_requested                  : std_logic;

signal in_reg_req     : std_logic;
signal in_reg_addr    : std_logic_vector(27 downto 0);
signal in_reg_val     : std_logic;
signal in_reg         : std_logic_vector(31 downto 0);

signal done_sclk      : std_logic;
signal init_done_sclk : std_logic;
signal init_done_tmp  : std_logic;
signal init_done_prev : std_logic;

signal init           : std_logic;
signal init_tmp       : std_logic;
signal init_reg       : std_logic;

signal inst_val       : std_logic;
signal inst_reg_val   : std_logic;
signal inst_rw        : std_logic;
signal inst_reg       : std_logic_vector(7 downto 0);
signal data_reg       : std_logic_vector(15 downto 0);

signal sh_counter     : integer;
signal shifting       : std_logic;
signal read_n_write   : std_logic;
signal ncs_int        : std_logic;
signal busy           : std_logic;
signal sdi            : std_logic;

signal shift_reg      : std_logic_vector(23+PRESEL'length downto 0);
signal init_address   : std_logic_vector(3 downto 0);
signal init_data      : std_logic_vector(23 downto 0);

signal read_byte_val  : std_logic;
signal data_read_val  : std_logic;
signal data_read      : std_logic_vector(7 downto 0);

begin

----------------------------------------------------------------------------------------------------
-- Generate serial clock (max 20MHz)
----------------------------------------------------------------------------------------------------

--  process (clk)
--    -- Divide by 2^4 = 16, CLKmax = 16 x 20MHz
--    variable clk_div : std_logic_vector(3 downto 0) := (others => '0');
--  begin
--    if (rising_edge(clk)) then
--      clk_div    := clk_div + '1';
--      -- The slave samples the data on the rising edge of SCLK.
--      -- therefore we make sure the external clock is slightly
--      -- after the internal clock.
--      sclk_ext <= clk_div(clk_div'length-1);
--      sclk_prebuf <= sclk_ext;
--    end if;
--  end process;
--
--  bufg_sclk : bufg
--  port map (
--    i => sclk_prebuf,
--    o => serial_clk
--  );

----------------------------------------------------------------------------------------------------
-- Stellar Command Interface
----------------------------------------------------------------------------------------------------

fmc11x_stellar_cmd_inst : fmc11x_stellar_cmd
generic map
(
   start_addr                    =>start_addr,
   stop_addr                     =>stop_addr
   )
port map
(
   reset                         =>rst,
   --command if
   clk_cmd                       =>clk_cmd,
   out_cmd                       =>out_cmd,
   out_cmd_val                   =>out_cmd_val,
   in_cmd                        =>in_cmd,
   in_cmd_val                    =>in_cmd_val,

   --register interface
   clk_reg                       =>clk_cmd,
   out_reg                       =>out_reg,
   out_reg_val                   =>out_reg_val,
   out_reg_val_ack               =>out_reg_val_ack,
   out_reg_addr                  =>out_reg_addr,
   in_reg                        =>in_reg,
   in_reg_val                    =>in_reg_val,
   in_reg_req                    =>in_reg_req,
   in_reg_addr                   =>in_reg_addr,
   wr_ack                        => wr_ack,
   mbx_in_reg                    =>(others=>'0'),
   mbx_in_val                    =>'0'
   );

----------------------------------------------------------------------------------------------------
-- Shoot commands to the state machine
----------------------------------------------------------------------------------------------------

process (rst, clk)
begin
  if (rst = '1') then

    init_done      <= '0';
    init_done_tmp  <= '0';
    init_done_prev <= '0';
    init           <= '0';
    in_reg_val     <= '0';
    in_reg         <= (others => '0');
    inst_val       <= '0';
    inst_rw        <= '0';
    inst_reg       <= (others=> '0');
    data_reg       <= (others=> '0');
    wr_ack         <= '0';
    wr_cmd_ack     <= '0';
    wr_ack_requested <= '0';

  elsif (rising_edge(clk)) then

    init_done      <= init_done_sclk;

    init_done_tmp  <= done_sclk;
    init_done_prev <= init_done_tmp;

    -- Release the init flag on rising edge init done
    if (init_done_tmp = '1' and init_done_prev = '0') then
      init <= '0';
    -- Enable the init flag when enable flag is high, but done flag is low
    elsif (init_ena = '1' and init_done_tmp = '0') then
      init <= '1';
    -- There is one additional status and control register available
    elsif ((out_reg_val = '1' or out_reg_val_ack = '1') and out_reg_addr = ADDR_GLOBAL) then
      init <= out_reg(0);
    end if;

    --Write
    if ((out_reg_val = '1' or out_reg_val_ack = '1') and out_reg_addr = ADDR_GLOBAL) then
        wr_cmd_ack <= '1';
    else
        wr_cmd_ack <= '0';
    end if;
    
     -- only send a write Ack on request:
    if (out_reg_val_ack = '1') then
      wr_ack_requested <= '1';
    elsif(wr_ack = '1') then
      wr_ack_requested <= '0';
    end if;
  
    if (wr_cmd_ack = '1' and wr_ack_requested = '1') then
      wr_ack <= '1';
    elsif(serial_val_ack = '1' and inst_rw = '0' and wr_ack_requested = '1') then
      wr_ack <= '1';
    else 
      wr_ack <= '0';
    end if; 

    -- There is one additional status and control register available
    if (in_reg_req = '1' and in_reg_addr = ADDR_GLOBAL) then
      in_reg_val <= '1';
      in_reg     <= conv_std_logic_vector(0, 27) & '0' & busy & '0' & '0' & init_done_prev;
    -- read from serial if when address is within device range
    elsif (in_reg_addr <= ADDR_MAX_RD) then
      in_reg_val <= data_read_val;
      in_reg     <= conv_std_logic_vector(0, 24) & data_read;
    else
      in_reg_val <= '0';
      in_reg     <= in_reg;
    end if;

    -- Write instruction, only when address is within device range
    if ((out_reg_val = '1' or out_reg_val_ack = '1') and out_reg_addr <= ADDR_MAX_WR) then
      inst_val <= '1';
      inst_rw  <= '0'; -- write
      inst_reg <= out_reg_addr(7 downto 0);
      data_reg <= out_reg(15 downto 0);
    -- Read instruction, only when address is within device range
    elsif (in_reg_req = '1' and in_reg_addr <= ADDR_MAX_RD) then
      inst_val <= '0'; -- NO READ THROUGH SPI SUPPORTED
      inst_rw  <= '1'; -- read
      inst_reg <= in_reg_addr(7 downto 0);
      data_reg <= data_reg;
    -- No instruction
    else
      inst_val <= '0';
      inst_rw  <= inst_rw;
      inst_reg <= inst_reg;
      data_reg <= data_reg;
    end if;

  end if;
end process;

-- Intruction pulse
pulse2pulse_inst0 : pulse2pulse
port map
(
  rst      => rst,
  in_clk   => clk,
  out_clk  => serial_clk,
  pulsein  => inst_val,
  pulseout => inst_reg_val,
  inbusy   => open
);

----------------------------------------------------------------------------------------------------
-- Serial interface state-machine
----------------------------------------------------------------------------------------------------

process (rst, serial_clk)
begin
  if (rst = '1') then

    init_tmp     <= '0';
    init_reg     <= '0';
    sh_state     <= idle;
    sh_counter   <= 0;
    shifting     <= '0';
    read_n_write <= '0';
    ncs_int      <= '1';

  elsif (rising_edge(serial_clk)) then

    -- Double synchonise flag from other clock domain
    init_tmp <= init;
    init_reg <= init_tmp;

    -- Main state machine
    case sh_state is

      when idle =>
        sh_counter <= shift_reg'length-data_reg'length-1; --total length minus data bytes;
        -- Accept every instruction
        if (inst_reg_val = '1' or init_reg = '1') then
          shifting     <= '1';
          read_n_write <= inst_rw and not init_reg; -- force write during init
          ncs_int      <= '0';
          sh_state     <= instruct;
        else
          shifting     <= '0';
          ncs_int      <= '1';
        end if;

      when instruct =>
        if (sh_counter = 0) then
          sh_counter <= data_reg'length-1;
          sh_state   <= data_io;
        else
          sh_counter <= sh_counter - 1;
        end if;

      when data_io =>
        if (sh_counter = 0) then
          sh_counter <= shift_reg'length-data_reg'length-1; --total length minus data bytes;
          shifting   <= '0';
          ncs_int    <= '1';
          if (read_n_write = '1') then
            sh_state <= data_valid;
          else
            sh_state <= idle;
          end if;
        else
          sh_counter <= sh_counter - 1;
        end if;

      when data_valid =>
        sh_state <= idle;

      when others =>
        sh_state <= idle;

    end case;

  end if;
end process;

busy <= '0' when (sh_state = idle and init_reg = '0') else '1';

-- Detect the end of a serial write, don't send an Ack after completing the initialisation.
process (serial_clk)
begin
  if (rising_edge(serial_clk)) then
    busy_del1  <= busy;
    busy_del2 <= busy_del1;
    init_done_sclk_del <= init_done_sclk;
	 
	 if(busy_del2 = '1' and busy_del1 = '0' and init_done_sclk_del = '1' and init_done_sclk = '1') then
		serial_val_ack_sclk <= '1';
   elsif(busy_del2 = '1' and busy_del1 = '0' and init_done_sclk_del = '0' and init_done_sclk = '0') then
		serial_val_ack_sclk <= '1';
	 else
		serial_val_ack_sclk <= '0';
	 end if;
  end if;
end process;

-- Transfer end write pulse to other clock domain
pulse2pulse_inst2 : pulse2pulse
port map
(
  rst      => rst,
  in_clk   => serial_clk,
  out_clk  => clk,
  pulsein  => serial_val_ack_sclk,
  pulseout => serial_val_ack,
  inbusy   => open
);

----------------------------------------------------------------------------------------------------
-- Instruction & data shift register
----------------------------------------------------------------------------------------------------

process (rst, serial_clk)
begin
  if (rst = '1') then

    shift_reg      <= (others => '0');
    init_address   <= (others => '0');
    done_sclk      <= '0';
    init_done_sclk <= '0';
    read_byte_val  <= '0';
    data_read      <= (others => '0');

  elsif (rising_edge(serial_clk)) then

    if (init_reg = '1' and shifting = '0') then
      shift_reg <= PRESEL & init_data(23 downto 0);
      -- Stop when update instruction is reveived (= last instruction)
      if (init_data(23 downto 16) = ADDR_MAX_WR) then
        init_address <= (others => '0');
        done_sclk    <= '1';
      else
        init_address <= init_address + 1;
        done_sclk    <= '0';
      end if;
    elsif (inst_reg_val = '1' and init_reg = '0') then
      shift_reg <= PRESEL & inst_reg & data_reg;
    elsif (shifting = '1') then
      shift_reg <= shift_reg(shift_reg'length-2 downto 0) & sdi;
    end if;

    if (done_sclk = '0') then
      init_done_sclk <= '0';
    elsif (sh_state = idle) then
      init_done_sclk <= '1';
    end if;

    -- Data read from device
    if (sh_state = data_valid) then
      read_byte_val <= '1';
      data_read     <= shift_reg(7 downto 0);
    else
      read_byte_val <= '0';
      data_read     <= data_read;
    end if;

  end if;
end process;

-- Transfer data valid pulse to other clock domain
pulse2pulse_inst1 : pulse2pulse
port map
(
  rst      => rst,
  in_clk   => serial_clk,
  out_clk  => clk,
  pulsein  => read_byte_val,
  pulseout => data_read_val,
  inbusy   => open
);

----------------------------------------------------------------------------------------------------
-- Initialization memory
----------------------------------------------------------------------------------------------------

ltc2656_init_mem_inst : ltc2656_init_mem
port map (
  clka  => serial_clk,
  addra => init_address,
  douta => init_data
);

----------------------------------------------------------------------------------------------------
-- Capture data in on rising edge SCLK
-- therefore freeze the signal on the falling edge of serial clock.
----------------------------------------------------------------------------------------------------
process (serial_clk)
begin
  if (falling_edge(serial_clk)) then
    sdi <= spi_sdi;
  end if;
end process;

----------------------------------------------------------------------------------------------------
-- Connect entity
----------------------------------------------------------------------------------------------------

in_cmd_busy <= busy; -- serial interface busy

spi_n_oe    <= '1' when (sh_state = data_io and read_n_write = '1') else ncs_int;
spi_n_cs    <= ncs_int;
spi_sclk    <= not sclk_ext when ncs_int = '0' else '0';
spi_sdo     <= 'Z' when (sh_state = data_io and read_n_write = '1') else shift_reg(shift_reg'length - 1);

----------------------------------------------------------------------------------------------------
-- End
----------------------------------------------------------------------------------------------------

end fmc116_ltc2656_ctrl_syn;
