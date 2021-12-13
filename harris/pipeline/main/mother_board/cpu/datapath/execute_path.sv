module execute_path(
	input	logic[31:0]	rs_out_E, rt_out_E, write_data_E, imm_E,
	input	logic[31:0]	alu_out_M, result_W, // フォワーディングされるデータ
	input	logic[5:0]	rs_E, rt_E, rd_E,
	input	logic[2:0]	alu_ctrl_sig_E,
	input	logic		alu_srcB_E, reg_dst_E,
	input	logic[1:0]	forwardA_E, forwardB_E,
	output	logic[31:0]	write_data_E, alu_out_E,
	output	logic[4:0]	reg_id_E
);
	logic[31:0]	alu_inB_E;

	mux4	#(.N(32))	forwardA_sel(.sel(forwardA_E), .src0(rs_out_E), .src1(result_W), .src2(alu_out_M), .src3(32'bx), .out(alu_in_A));
	mux4	#(.N(32))	forwardB_sel(.sel(forwardB_E), .src0(rt_out_E), .src1(result_W), .src2(alu_out_M), .src3(32'bx), .out(write_data_E));
	mux2	#(.N(32))	alu_srcB_sel(.sel(alu_srcB_E), .src0(write_data_E), .src1(imm_E), .out(alu_inB_E));
	mux2	#(.N(5))	reg_dst_sel(.sel(reg_dst_E), .src0(rt_E), .src1(rd_E), .out(reg_id_E));
	alu	 #(.N(32))	alu(.srcA(alu_inA), .srcB(alu_inB), .alu_ctrl_sig(alu_ctrl_sig_E), .alu_out(alu_out_E)); // 分岐判定を decode ステージで行っているため、 zero は使用しない
endmodule
