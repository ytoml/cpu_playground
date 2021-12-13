module decode_path (
	ctrl_bus_if.central	ctrl_bus,
	input	logic[31:0]	inst_D, result_W,
	input	logic[4:0]	reg_id_W,
	input	logic		reg_write_W,
	input	logic		branch,
	output	logic[31:0]	rs_out_D, rt_out_D, imm_D, pc_br_D,
	output	logic		pc_src_D
);
	// 分岐予測失敗時のストールを軽減するためにソースオペランド(rs, rt)の等値判定をここで行っておく
	logic	src_eq;

	regfile			regfile(
		.ctrl_bus, .reg_write(reg_write_W),
		.rs(inst_D[25:21]), .rt(inst_D[20:16]), .rd(reg_id_W),
		.reg_in(result_W), .rs_data(rs_out_D), .rt_data(rt_out_D)
	);
	sign_ext		sign_ext(.half(inst_D[15:0]), .full(imm_D));
	assign	src_eq		= rs_out_D == rt_out_D ? 1'b1 : 1'b0;
	assign	pc_src_D	= branch && src_eq;
	assign	br_offset	= { imm_D[29:0], 2'b00 };
	assign	pc_br_D		= pc_plus4_D + br_offset;
endmodule