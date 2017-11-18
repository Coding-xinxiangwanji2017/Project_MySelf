send_fifo_inst : send_fifo PORT MAP (
		aclr	 => aclr_sig,
		clock	 => clock_sig,
		data	 => data_sig,
		rdreq	 => rdreq_sig,
		wrreq	 => wrreq_sig,
		empty	 => empty_sig,
		q	 => q_sig,
		usedw	 => usedw_sig
	);
