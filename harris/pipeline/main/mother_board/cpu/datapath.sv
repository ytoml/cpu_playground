module datapath(
	ctrl_bus_if.central ctrl_bus,
	mem_bus_if.central  imem_bus,
	mem_bus_if.central  dmem_bus,
	output  logic		zero,
	input   logic		mem_to_reg,
	input	logic		mem_enab,
	input   logic		pc_src, alu_srcB,
	input   logic		reg_dst, reg_write,
	input   logic		jmp,
	input   logic[2:0]	alu_ctrl_sig,
	output  logic[31:0]	inst, write_data
);
	// ステージごとのデータパス配線
	logic[31:0] pc_F, pc_plus4_F, inst_F;
	logic[31:0]	inst_D, pc_plus4_D, imm_D, rs_out_D, write_data_D; 
	logic[31:0] pc_plus4_E, rs_out_E, rt_out_E, alu_out_E, imm_E, write_data_E;
	logic[4:0]  rt_E, rd_E, reg_id_E;
	logic		zero_E;
	logic[31:0]	alu_out_M, read_data_M;
	logic[4:0]	reg_id_M;
	logic		pc_src_M, zero_M;
	logic[31:0]	alu_out_W, read_data_W, result_W;
	logic[4:0]	reg_id_W;

	// ステージごとの制御シグナル配線(decode ステージからくるものなので、 _D の線は用意せず ff に直接繋ぐ)
	logic		reg_write_E, mem_to_reg_E, mem_enab_E, branch_E, alu_srcB_E, reg_dst_E;
	logic[2:0]	alu_ctrl_sig_E;
	logic		reg_write_M, mem_to_reg_M, mem_enab_M, branch_M;
	logic		reg_write_W, mem_to_reg_W;

	// フォワーディング用の制御シグナル
	logic[1:0]	forwardA_E, forwardB_E;

	// ストール用の制御シグナル
	logic		pc_enab, enab_FD, flush_DE;

	hazard_unit				hazard_unit(.*);

	fetch_path				fetch_path(.*);
	enab_ff		#(.N(32))	pcreg_FD(.ctrl_bus, .enab(enab_FD), .in(pc_plus4_F), .out(pc_plus4_D));
	enab_ff		#(.N(32))	ireg_FD(.ctrl_bus, .enab(enab_FD), .in(inst_F), .out(inst_D));

	decode_path				decode_path(.*);
	assign	inst			= inst_D;
	reset_ff	#(.N(32))	pcreg_DE(.ctrl_bus, .reset(flush_DE), .in(pc_plus4_D), .out(pc_plus4_E));
	reset_ff	#(.N(32))	imm_reg_DE(.ctrl_bus, .reset(flush_DE), .in(imm_D), .out(imm_E));
	reset_ff	#(.N(32))	rs_buf_DE(.ctrl_bus, .reset(flush_DE), .in(rs_out_D), .out(rs_out_E));
	reset_ff	#(.N(32))	rt_buf_DE(.ctrl_bus, .reset(flush_DE), .in(rt_out_D), .out(rt_out_E));
	reset_ff	#(.N(5))	rs_dst_DE(.ctrl_bus, .reset(flush_DE), .in(inst_D[25:21]), .out(rs_E));
	reset_ff	#(.N(5))	rt_dst_DE(.ctrl_bus, .reset(flush_DE), .in(inst_D[20:16]), .out(rt_E));
	reset_ff	#(.N(5))	rd_dst_DE(.ctrl_bus, .reset(flush_DE), .in(inst_D[15:11]), .out(rd_E));
	reset_ff	#(.N(1))	reg_write_DE(.ctrl_bus, .reset(flush_DE), .in(reg_write), .out(reg_write_E));
	reset_ff	#(.N(1))	mem_to_reg_DE(.ctrl_bus, .reset(flush_DE), .in(mem_to_reg), .out(mem_to_reg_E));
	reset_ff	#(.N(1))	mem_enab_DE(.ctrl_bus, .reset(flush_DE), .in(mem_enab), .out(mem_enab_E));
	reset_ff	#(.N(1))	branch_DE(.ctrl_bus, .reset(flush_DE), .in(branch), .out(branch_E));
	reset_ff	#(.N(3))	alu_ctrl_sig_DE(.ctrl_bus, .reset(flush_DE), .in(alu_ctrl_sig), .out(alu_ctrl_sig_E));
	reset_ff	#(.N(1))	alu_srcB_DE(.ctrl_bus, .reset(flush_DE), .in(alu_srcB), .out(alu_srcB_E));
	reset_ff	#(.N(1))	reg_dst_DE(.ctrl_bus, .reset(flush_DE), .in(reg_dst), .out(reg_dst_E));

	execute_path		execute_path(.*);
	ff		#(.N(32))	alu_out_EM(.ctrl_bus, .in(alu_out_E), .out(alu_out_M));
	ff		#(.N(32))	write_data_EM(.ctrl_bus, .in(write_data_E), .out(write_data_M));
	ff		#(.N(32))	br_reg_EM(.ctrl_bus, .in(pc_br_E), .out(pc_br_M));
	ff		#(.N(1))	zero_EM(.ctrl_bus, .in(zero_E), .out(zero_M));
	ff		#(.N(5))	reg_dst_EM(.ctrl_bus, .in(reg_id_E), .out(reg_id_M));
	ff		#(.N(1))	reg_write_EM(.ctrl_bus, .in(reg_write_E), .out(reg_write_M));
	ff		#(.N(1))	mem_to_reg_EM(.ctrl_bus, .in(mem_to_reg_E), .out(mem_to_reg_M));
	ff		#(.N(1))	mem_enab_EM(.ctrl_bus, .in(mem_enab_E), .out(mem_enab_M));
	ff		#(.N(1))	branch_EM(.ctrl_bus, .in(branch_E), .out(branch_M));

	memory_path		memory_path(.*);
	assign	write_data	= write_data_M;
	ff		#(.N(32))	alu_out_MW(.ctrl_bus, .in(alu_out_M), .out(alu_out_W));
	ff		#(.N(32))	read_data_MW(.ctrl_bus, .in(read_data_M), .out(read_data_W));
	ff		#(.N(5))	reg_dst_MW(.ctrl_bus, .in(reg_id_M), .out(reg_id_W));
	ff		#(.N(1))	reg_write_MW(.ctrl_bus, .in(reg_write_M), .out(reg_write_W));
	ff		#(.N(1))	mem_to_reg_MW(.ctrl_bus, .in(mem_to_reg_M), .out(mem_to_reg_W));

	writeback_path	writeback_path(.*);
endmodule