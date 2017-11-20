-------------------------------------------------------------------------------------
-- FILE NAME : sip_fmc116.vhd
--
-- AUTHOR    : StellarIP (c) 4DSP
--
-- COMPANY   : 4DSP
--
-- ITEM      : 1
--
-- UNITS     : Entity       - sip_fmc116
--             architecture - arch_sip_fmc116
--
-- LANGUAGE  : VHDL
--
-------------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------------
-- DESCRIPTION
-- ===========
--
-- sip_fmc116
-- Notes: sip_fmc116
-------------------------------------------------------------------------------------
--  Disclaimer: LIMITED WARRANTY AND DISCLAIMER. These designs are
--              provided to you as is.  4DSP specifically disclaims any
--              implied warranties of merchantability, non-infringement, or
--              fitness for a particular purpose. 4DSP does not warrant that
--              the functions contained in these designs will meet your
--              requirements, or that the operation of these designs will be
--              uninterrupted or error free, or that defects in the Designs
--              will be corrected. Furthermore, 4DSP does not warrant or
--              make any representations regarding use or the results of the
--              use of the designs in terms of correctness, accuracy,
--              reliability, or otherwise.
--
--              LIMITATION OF LIABILITY. In no event will 4DSP or its
--              licensors be liable for any loss of data, lost profits, cost
--              or procurement of substitute goods or services, or for any
--              special, incidental, consequential, or indirect damages
--              arising from the use or operation of the designs or
--              accompanying documentation, however caused and on any theory
--              of liability. This limitation will apply even if 4DSP
--              has been advised of the possibility of such damage. This
--              limitation shall apply not-withstanding the failure of the
--              essential purpose of any limited remedies herein.
--
----------------------------------------------
--
-------------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------------
--library declaration
-------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all ;
use ieee.std_logic_arith.all ;
use ieee.std_logic_unsigned.all ;
use ieee.std_logic_misc.all ;

-------------------------------------------------------------------------------------
--Entity Declaration
-------------------------------------------------------------------------------------
entity sip_fmc116 is
generic (
  GLOBAL_START_ADDR_GEN                    : std_logic_vector(27 downto 0);
  GLOBAL_STOP_ADDR_GEN                     : std_logic_vector(27 downto 0);
  PRIVATE_START_ADDR_GEN                   : std_logic_vector(27 downto 0);
  PRIVATE_STOP_ADDR_GEN                    : std_logic_vector(27 downto 0)
);
port (
--Wormhole 'clk' of type 'clkin':
   clk_clkin                               : in    std_logic_vector(31 downto 0);

--Wormhole 'rst' of type 'rst_in':
   rst_rstin                               : in    std_logic_vector(31 downto 0);

--Wormhole 'cmdclk_in' of type 'cmdclk_in':
   cmdclk_in_cmdclk                        : in    std_logic;

--Wormhole 'cmd_in' of type 'cmd_in':
   cmd_in_cmdin                            : in    std_logic_vector(63 downto 0);
   cmd_in_cmdin_val                        : in    std_logic;

--Wormhole 'cmd_out' of type 'cmd_out':
   cmd_out_cmdout                          : out   std_logic_vector(63 downto 0);
   cmd_out_cmdout_val                      : out   std_logic;

--Wormhole 'adc0' of type 'wh_out':
   adc0_out_stop                           : in    std_logic;
   adc0_out_dval                           : out   std_logic;
   adc0_out_data                           : out   std_logic_vector(63 downto 0);

--Wormhole 'adc1' of type 'wh_out':
   adc1_out_stop                           : in    std_logic;
   adc1_out_dval                           : out   std_logic;
   adc1_out_data                           : out   std_logic_vector(63 downto 0);

--Wormhole 'adc2' of type 'wh_out':
   adc2_out_stop                           : in    std_logic;
   adc2_out_dval                           : out   std_logic;
   adc2_out_data                           : out   std_logic_vector(63 downto 0);

--Wormhole 'adc3' of type 'wh_out':
   adc3_out_stop                           : in    std_logic;
   adc3_out_dval                           : out   std_logic;
   adc3_out_data                           : out   std_logic_vector(63 downto 0);

--Wormhole 'adc4' of type 'wh_out':
   adc4_out_stop                           : in    std_logic;
   adc4_out_dval                           : out   std_logic;
   adc4_out_data                           : out   std_logic_vector(63 downto 0);

--Wormhole 'adc5' of type 'wh_out':
   adc5_out_stop                           : in    std_logic;
   adc5_out_dval                           : out   std_logic;
   adc5_out_data                           : out   std_logic_vector(63 downto 0);

--Wormhole 'adc6' of type 'wh_out':
   adc6_out_stop                           : in    std_logic;
   adc6_out_dval                           : out   std_logic;
   adc6_out_data                           : out   std_logic_vector(63 downto 0);

--Wormhole 'adc7' of type 'wh_out':
   adc7_out_stop                           : in    std_logic;
   adc7_out_dval                           : out   std_logic;
   adc7_out_data                           : out   std_logic_vector(63 downto 0);

--Wormhole 'adc8' of type 'wh_out':
   adc8_out_stop                           : in    std_logic;
   adc8_out_dval                           : out   std_logic;
   adc8_out_data                           : out   std_logic_vector(63 downto 0);

--Wormhole 'adc9' of type 'wh_out':
   adc9_out_stop                           : in    std_logic;
   adc9_out_dval                           : out   std_logic;
   adc9_out_data                           : out   std_logic_vector(63 downto 0);

--Wormhole 'adc10' of type 'wh_out':
   adc10_out_stop                           : in    std_logic;
   adc10_out_dval                           : out   std_logic;
   adc10_out_data                           : out   std_logic_vector(63 downto 0);

--Wormhole 'adc11' of type 'wh_out':
   adc11_out_stop                           : in    std_logic;
   adc11_out_dval                           : out   std_logic;
   adc11_out_data                           : out   std_logic_vector(63 downto 0);

--Wormhole 'adc12' of type 'wh_out':
   adc12_out_stop                           : in    std_logic;
   adc12_out_dval                           : out   std_logic;
   adc12_out_data                           : out   std_logic_vector(63 downto 0);

--Wormhole 'adc13' of type 'wh_out':
   adc13_out_stop                           : in    std_logic;
   adc13_out_dval                           : out   std_logic;
   adc13_out_data                           : out   std_logic_vector(63 downto 0);

--Wormhole 'adc14' of type 'wh_out':
   adc14_out_stop                           : in    std_logic;
   adc14_out_dval                           : out   std_logic;
   adc14_out_data                           : out   std_logic_vector(63 downto 0);

--Wormhole 'adc15' of type 'wh_out':
   adc15_out_stop                           : in    std_logic;
   adc15_out_dval                           : out   std_logic;
   adc15_out_data                           : out   std_logic_vector(63 downto 0);

--Wormhole 'ext_fmc116' of type 'ext_fmc116':
   ctrl                                     : inout std_logic_vector(7 downto 0);

   clk_to_fpga_p                            : in    std_logic;
   clk_to_fpga_n                            : in    std_logic;
   ext_trigger_p                            : in    std_logic;
   ext_trigger_n                            : in    std_logic;

   dco_p                                    : in    std_logic_vector(3 downto 0);
   dco_n                                    : in    std_logic_vector(3 downto 0);
   frame_p                                  : in    std_logic_vector(3 downto 0);
   frame_n                                  : in    std_logic_vector(3 downto 0);
   outa_p                                   : in    std_logic_vector(15 downto 0);
   outa_n                                   : in    std_logic_vector(15 downto 0);
   outb_p                                   : in    std_logic_vector(15 downto 0);
   outb_n                                   : in    std_logic_vector(15 downto 0);

   pg_m2c                                   : in    std_logic;
   prsnt_m2c_l                              : in    std_logic

);
end entity sip_fmc116;

-------------------------------------------------------------------------------------
--Architecture declaration
-------------------------------------------------------------------------------------
architecture arch_sip_fmc116 of sip_fmc116 is

-------------------------------------------------------------------------------------
--Constants declaration
-------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------
--Signal declaration
-------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------
--Components declarations
-------------------------------------------------------------------------------------
component fmc116_if is
generic (
  START_ADDR       : std_logic_vector(27 downto 0) := x"0000000";
  STOP_ADDR        : std_logic_vector(27 downto 0) := x"00000FF"
);
port (
  -- Global signals
  rst              : in    std_logic;
  clk              : in    std_logic;

  -- Command Interface
  clk_cmd          : in    std_logic;
  in_cmd_val       : in    std_logic;
  in_cmd           : in    std_logic_vector(63 downto 0);
  out_cmd_val      : out   std_logic;
  out_cmd          : out   std_logic_vector(63 downto 0);
  out_cmd_busy     : out   std_logic;

  --Output ports for ADC data
  adc0_out_stop    : in    std_logic;
  adc0_out_dval    : out   std_logic;
  adc0_out_data    : out   std_logic_vector(63 downto 0);
  adc1_out_stop    : in    std_logic;
  adc1_out_dval    : out   std_logic;
  adc1_out_data    : out   std_logic_vector(63 downto 0);
  adc2_out_stop    : in    std_logic;
  adc2_out_dval    : out   std_logic;
  adc2_out_data    : out   std_logic_vector(63 downto 0);
  adc3_out_stop    : in    std_logic;
  adc3_out_dval    : out   std_logic;
  adc3_out_data    : out   std_logic_vector(63 downto 0);
  adc4_out_stop    : in    std_logic;
  adc4_out_dval    : out   std_logic;
  adc4_out_data    : out   std_logic_vector(63 downto 0);
  adc5_out_stop    : in    std_logic;
  adc5_out_dval    : out   std_logic;
  adc5_out_data    : out   std_logic_vector(63 downto 0);
  adc6_out_stop    : in    std_logic;
  adc6_out_dval    : out   std_logic;
  adc6_out_data    : out   std_logic_vector(63 downto 0);
  adc7_out_stop    : in    std_logic;
  adc7_out_dval    : out   std_logic;
  adc7_out_data    : out   std_logic_vector(63 downto 0);
  adc8_out_stop    : in    std_logic;
  adc8_out_dval    : out   std_logic;
  adc8_out_data    : out   std_logic_vector(63 downto 0);
  adc9_out_stop    : in    std_logic;
  adc9_out_dval    : out   std_logic;
  adc9_out_data    : out   std_logic_vector(63 downto 0);
  adc10_out_stop   : in    std_logic;
  adc10_out_dval   : out   std_logic;
  adc10_out_data   : out   std_logic_vector(63 downto 0);
  adc11_out_stop   : in    std_logic;
  adc11_out_dval   : out   std_logic;
  adc11_out_data   : out   std_logic_vector(63 downto 0);
  adc12_out_stop   : in    std_logic;
  adc12_out_dval   : out   std_logic;
  adc12_out_data   : out   std_logic_vector(63 downto 0);
  adc13_out_stop   : in    std_logic;
  adc13_out_dval   : out   std_logic;
  adc13_out_data   : out   std_logic_vector(63 downto 0);
  adc14_out_stop   : in    std_logic;
  adc14_out_dval   : out   std_logic;
  adc14_out_data   : out   std_logic_vector(63 downto 0);
  adc15_out_stop   : in    std_logic;
  adc15_out_dval   : out   std_logic;
  adc15_out_data   : out   std_logic_vector(63 downto 0);

  --External signals
  ctrl             : inout std_logic_vector(7 downto 0);

  clk_to_fpga_p    : in    std_logic;
  clk_to_fpga_n    : in    std_logic;
  ext_trigger_p    : in    std_logic;
  ext_trigger_n    : in    std_logic;

  dco_p            : in    std_logic_vector(3 downto 0);
  dco_n            : in    std_logic_vector(3 downto 0);
  frame_p          : in    std_logic_vector(3 downto 0);
  frame_n          : in    std_logic_vector(3 downto 0);
  outa_p           : in    std_logic_vector(15 downto 0);
  outa_n           : in    std_logic_vector(15 downto 0);
  outb_p           : in    std_logic_vector(15 downto 0);
  outb_n           : in    std_logic_vector(15 downto 0);

  pg_m2c           : in    std_logic;
  prsnt_m2c_l      : in    std_logic

);
end component;



begin

-------------------------------------------------------------------------------------
--Components instantiations
-------------------------------------------------------------------------------------
fmc116_if_inst : fmc116_if
generic map
(
  START_ADDR      => PRIVATE_START_ADDR_GEN,
  STOP_ADDR       => PRIVATE_STOP_ADDR_GEN
)
port map (
  rst             => rst_rstin(2),
  clk             => cmdclk_in_cmdclk,

  clk_cmd         => cmdclk_in_cmdclk,
  in_cmd_val      => cmd_in_cmdin_val,
  in_cmd          => cmd_in_cmdin,
  out_cmd_val     => cmd_out_cmdout_val,
  out_cmd         => cmd_out_cmdout,
  out_cmd_busy    => open,

  adc0_out_stop   => adc0_out_stop,
  adc0_out_dval   => adc0_out_dval,
  adc0_out_data   => adc0_out_data,
  adc1_out_stop   => adc1_out_stop,
  adc1_out_dval   => adc1_out_dval,
  adc1_out_data   => adc1_out_data,
  adc2_out_stop   => adc2_out_stop,
  adc2_out_dval   => adc2_out_dval,
  adc2_out_data   => adc2_out_data,
  adc3_out_stop   => adc3_out_stop,
  adc3_out_dval   => adc3_out_dval,
  adc3_out_data   => adc3_out_data,
  adc4_out_stop   => adc4_out_stop,
  adc4_out_dval   => adc4_out_dval,
  adc4_out_data   => adc4_out_data,
  adc5_out_stop   => adc5_out_stop,
  adc5_out_dval   => adc5_out_dval,
  adc5_out_data   => adc5_out_data,
  adc6_out_stop   => adc6_out_stop,
  adc6_out_dval   => adc6_out_dval,
  adc6_out_data   => adc6_out_data,
  adc7_out_stop   => adc7_out_stop,
  adc7_out_dval   => adc7_out_dval,
  adc7_out_data   => adc7_out_data,
  adc8_out_stop   => adc8_out_stop,
  adc8_out_dval   => adc8_out_dval,
  adc8_out_data   => adc8_out_data,
  adc9_out_stop   => adc9_out_stop,
  adc9_out_dval   => adc9_out_dval,
  adc9_out_data   => adc9_out_data,
  adc10_out_stop  => adc10_out_stop,
  adc10_out_dval  => adc10_out_dval,
  adc10_out_data  => adc10_out_data,
  adc11_out_stop  => adc11_out_stop,
  adc11_out_dval  => adc11_out_dval,
  adc11_out_data  => adc11_out_data,
  adc12_out_stop  => adc12_out_stop,
  adc12_out_dval  => adc12_out_dval,
  adc12_out_data  => adc12_out_data,
  adc13_out_stop  => adc13_out_stop,
  adc13_out_dval  => adc13_out_dval,
  adc13_out_data  => adc13_out_data,
  adc14_out_stop  => adc14_out_stop,
  adc14_out_dval  => adc14_out_dval,
  adc14_out_data  => adc14_out_data,
  adc15_out_stop  => adc15_out_stop,
  adc15_out_dval  => adc15_out_dval,
  adc15_out_data  => adc15_out_data,

  ctrl            => ctrl,
  clk_to_fpga_p   => clk_to_fpga_p,
  clk_to_fpga_n   => clk_to_fpga_n,
  ext_trigger_p   => ext_trigger_p,
  ext_trigger_n   => ext_trigger_n,
  dco_p           => dco_p,
  dco_n           => dco_n,
  frame_p         => frame_p,
  frame_n         => frame_n,
  outa_p          => outa_p,
  outa_n          => outa_n,
  outb_p          => outb_p,
  outb_n          => outb_n,
  pg_m2c          => pg_m2c,
  prsnt_m2c_l     => prsnt_m2c_l

);


-------------------------------------------------------------------------------------
--synchronous processes
-------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------
--asynchronous processes
-------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------
--asynchronous mapping
-------------------------------------------------------------------------------------


end architecture arch_sip_fmc116   ; -- of sip_fmc116
