UART_RX_FIFO_inst : UART_RX_FIFO PORT MAP (
		aclr	 => aclr_sig,
		clock	 => clock_sig,
		data	 => data_sig,
		rdreq	 => rdreq_sig,
		wrreq	 => wrreq_sig,
		almost_full	 => almost_full_sig,
		q	 => q_sig,
		usedw	 => usedw_sig
	);
