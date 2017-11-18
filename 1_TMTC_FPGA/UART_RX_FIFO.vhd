LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY altera_mf;
USE altera_mf.all;

ENTITY UART_RX_FIFO IS
    port (
		aclr		: IN STD_LOGIC ;
		clock		: IN STD_LOGIC ;
		data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		rdreq		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		almost_full		: OUT STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		usedw		: OUT STD_LOGIC_VECTOR (10 DOWNTO 0)
	);
END UART_RX_FIFO;


ARCHITECTURE SYN OF uart_rx_fifo IS

	SIGNAL sub_wire0	: STD_LOGIC ;
	SIGNAL sub_wire1	: STD_LOGIC_VECTOR (10 DOWNTO 0);
	SIGNAL sub_wire2	: STD_LOGIC_VECTOR (7 DOWNTO 0);



	COMPONENT scfifo
	GENERIC (
		add_ram_output_register		: STRING;
		almost_full_value		: NATURAL;
		intended_device_family		: STRING;
		lpm_numwords		: NATURAL;
		lpm_showahead		: STRING;
		lpm_type		: STRING;
		lpm_width		: NATURAL;
		lpm_widthu		: NATURAL;
		overflow_checking		: STRING;
		underflow_checking		: STRING;
		use_eab		: STRING
	);
	PORT (
			aclr	: IN STD_LOGIC ;
			almost_full	: OUT STD_LOGIC ;
			clock	: IN STD_LOGIC ;
			data	: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			rdreq	: IN STD_LOGIC ;
			usedw	: OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
			q	: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			wrreq	: IN STD_LOGIC 
	);
	END COMPONENT;

BEGIN
	almost_full    <= sub_wire0;
	usedw    <= sub_wire1(10 DOWNTO 0);
	q    <= sub_wire2(7 DOWNTO 0);

	scfifo_component : scfifo
	GENERIC MAP (
		add_ram_output_register => "OFF",
		almost_full_value => 1024,
		intended_device_family => "Cyclone IV E",
		lpm_numwords => 2048,
		lpm_showahead => "ON",
		lpm_type => "scfifo",
		lpm_width => 8,
		lpm_widthu => 11,
		overflow_checking => "ON",
		underflow_checking => "ON",
		use_eab => "ON"
	)
	PORT MAP (
		aclr => aclr,
		clock => clock,
		data => data,
		rdreq => rdreq,
		wrreq => wrreq,
		almost_full => sub_wire0,
		usedw => sub_wire1,
		q => sub_wire2
	);



END SYN;

-- ============================================================
-- CNX file retrieval info
-- ============================================================
-- Retrieval info: PRIVATE: AlmostEmpty NUMERIC "0"
-- Retrieval info: PRIVATE: AlmostEmptyThr NUMERIC "-1"
-- Retrieval info: PRIVATE: AlmostFull NUMERIC "1"
-- Retrieval info: PRIVATE: AlmostFullThr NUMERIC "1024"
-- Retrieval info: PRIVATE: CLOCKS_ARE_SYNCHRONIZED NUMERIC "1"
-- Retrieval info: PRIVATE: Clock NUMERIC "0"
-- Retrieval info: PRIVATE: Depth NUMERIC "2048"
-- Retrieval info: PRIVATE: Empty NUMERIC "0"
-- Retrieval info: PRIVATE: Full NUMERIC "0"
-- Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone IV E"
-- Retrieval info: PRIVATE: LE_BasedFIFO NUMERIC "0"
-- Retrieval info: PRIVATE: LegacyRREQ NUMERIC "0"
-- Retrieval info: PRIVATE: MAX_DEPTH_BY_9 NUMERIC "0"
-- Retrieval info: PRIVATE: OVERFLOW_CHECKING NUMERIC "0"
-- Retrieval info: PRIVATE: Optimize NUMERIC "0"
-- Retrieval info: PRIVATE: RAM_BLOCK_TYPE NUMERIC "0"
-- Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "0"
-- Retrieval info: PRIVATE: UNDERFLOW_CHECKING NUMERIC "0"
-- Retrieval info: PRIVATE: UsedW NUMERIC "1"
-- Retrieval info: PRIVATE: Width NUMERIC "8"
-- Retrieval info: PRIVATE: dc_aclr NUMERIC "0"
-- Retrieval info: PRIVATE: diff_widths NUMERIC "0"
-- Retrieval info: PRIVATE: msb_usedw NUMERIC "0"
-- Retrieval info: PRIVATE: output_width NUMERIC "8"
-- Retrieval info: PRIVATE: rsEmpty NUMERIC "1"
-- Retrieval info: PRIVATE: rsFull NUMERIC "0"
-- Retrieval info: PRIVATE: rsUsedW NUMERIC "0"
-- Retrieval info: PRIVATE: sc_aclr NUMERIC "1"
-- Retrieval info: PRIVATE: sc_sclr NUMERIC "0"
-- Retrieval info: PRIVATE: wsEmpty NUMERIC "0"
-- Retrieval info: PRIVATE: wsFull NUMERIC "1"
-- Retrieval info: PRIVATE: wsUsedW NUMERIC "0"
-- Retrieval info: LIBRARY: altera_mf altera_mf.altera_mf_components.all
-- Retrieval info: CONSTANT: ADD_RAM_OUTPUT_REGISTER STRING "OFF"
-- Retrieval info: CONSTANT: ALMOST_FULL_VALUE NUMERIC "1024"
-- Retrieval info: CONSTANT: INTENDED_DEVICE_FAMILY STRING "Cyclone IV E"
-- Retrieval info: CONSTANT: LPM_NUMWORDS NUMERIC "2048"
-- Retrieval info: CONSTANT: LPM_SHOWAHEAD STRING "ON"
-- Retrieval info: CONSTANT: LPM_TYPE STRING "scfifo"
-- Retrieval info: CONSTANT: LPM_WIDTH NUMERIC "8"
-- Retrieval info: CONSTANT: LPM_WIDTHU NUMERIC "11"
-- Retrieval info: CONSTANT: OVERFLOW_CHECKING STRING "ON"
-- Retrieval info: CONSTANT: UNDERFLOW_CHECKING STRING "ON"
-- Retrieval info: CONSTANT: USE_EAB STRING "ON"
-- Retrieval info: USED_PORT: aclr 0 0 0 0 INPUT NODEFVAL "aclr"
-- Retrieval info: USED_PORT: almost_full 0 0 0 0 OUTPUT NODEFVAL "almost_full"
-- Retrieval info: USED_PORT: clock 0 0 0 0 INPUT NODEFVAL "clock"
-- Retrieval info: USED_PORT: data 0 0 8 0 INPUT NODEFVAL "data[7..0]"
-- Retrieval info: USED_PORT: q 0 0 8 0 OUTPUT NODEFVAL "q[7..0]"
-- Retrieval info: USED_PORT: rdreq 0 0 0 0 INPUT NODEFVAL "rdreq"
-- Retrieval info: USED_PORT: usedw 0 0 11 0 OUTPUT NODEFVAL "usedw[10..0]"
-- Retrieval info: USED_PORT: wrreq 0 0 0 0 INPUT NODEFVAL "wrreq"
-- Retrieval info: CONNECT: @aclr 0 0 0 0 aclr 0 0 0 0
-- Retrieval info: CONNECT: @clock 0 0 0 0 clock 0 0 0 0
-- Retrieval info: CONNECT: @data 0 0 8 0 data 0 0 8 0
-- Retrieval info: CONNECT: @rdreq 0 0 0 0 rdreq 0 0 0 0
-- Retrieval info: CONNECT: @wrreq 0 0 0 0 wrreq 0 0 0 0
-- Retrieval info: CONNECT: almost_full 0 0 0 0 @almost_full 0 0 0 0
-- Retrieval info: CONNECT: q 0 0 8 0 @q 0 0 8 0
-- Retrieval info: CONNECT: usedw 0 0 11 0 @usedw 0 0 11 0
-- Retrieval info: GEN_FILE: TYPE_NORMAL UART_RX_FIFO.vhd TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL UART_RX_FIFO.inc TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL UART_RX_FIFO.cmp TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL UART_RX_FIFO.bsf TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL UART_RX_FIFO_inst.vhd TRUE
-- Retrieval info: LIB_FILE: altera_mf
