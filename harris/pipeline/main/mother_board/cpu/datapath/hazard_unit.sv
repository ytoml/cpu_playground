module hazard_unit(
	input	logic		branch,
	input	logic[4:0]	rs_D, rt_D,
	input	logic[4:0]	rs_E, rt_E, rd_E,
	input	logic		mem_to_reg_E, mem_to_reg_M,
	input	logic[4:0]	reg_id_M, reg_id_W,
	input	logic		reg_write_E, reg_write_M, reg_write_W,
	output	logic		pc_enab, enab_FD, flush_DE,
	output	logic		forwardA_D, forwardB_D,
	output	logic[1:0]	forwardA_E, forwardB_E
);
	// ALU へのフォワーディング
	always_comb begin
		// ゼロレジスタは0に結線されており、前の命令の実行結果を持ってくると挙動が変わってしまうためフォワーディングしない
		// メモリステージの実行結果の方が新しく、次の命令で使うべき値であるため、 _M の suffix の信号を優先する
		if 		(rs_E != 5'b0 && rs_E == reg_id_M && reg_write_M)	forwardA_E = 2'b10;
		else if (rs_E != 5'b0 && rs_E == reg_id_W && reg_write_W)	forwardA_E = 2'b01;
		else														forwardA_E = 2'b00;
	end

	always_comb begin
		if		(rt_E != 5'b0 && rt_E == reg_id_M && reg_write_M)	forwardB_E = 2'b10;
		else if (rt_E != 5'b0 && rt_E == reg_id_W && reg_write_W)	forwardB_E = 2'b01;
		else														forwardB_E = 2'b00;
	end

	// 早期分岐決定用のフォワーディング
	// mem_to_reg_M が 1 の時はフォワーディングはされるものの、 decode ステージは lw への依存のためにストールしている(つまりフォワーディングが空振りする)ことに注意
	always_comb begin
		if 		(rs_D != 5'b0 && rs_D == reg_id_M && reg_write_M)	forwardA_D = 1'b1;
		else														forwardA_D = 1'b0;
	end

	always_comb begin
		if		(rt_D != 5'b0 && rt_D == reg_id_M && reg_write_M)	forwardB_D = 1'b1;
		else														forwardB_D = 1'b0;
	end

	// lw 命令時のストール
	logic	lw_stall, br_stall, stall, enab;
	
	always_comb begin
		// ソースが lw の書き戻し先と同じ時にストール(mem_to_reg は lw でのみ 1 になる)
		if (rs_D == rt_E || rt_D == rt_E)	lw_stall = mem_to_reg_E;
		else								lw_stall = 1'b0;
	end

	assign	br_stall	= branch & 
	(
		(reg_write_E	& ((reg_id_E == rs_D ? 1'b1 : 1'b0) | (reg_id_E == rt_D ? 1'b1 : 1'b0))) | 
		(mem_to_reg_M	& ((reg_id_M == rs_D ? 1'b1 : 1'b0) | (reg_id_M == rt_D ? 1'b1 : 1'b0)))
	);
	assign	stall		= lw_stall | br_stall;
	assign	enab		= ~stall;
	assign	pc_enab		= enab;
	assign	enab_FD		= enab;
	assign	flush_DE	= stall;
endmodule