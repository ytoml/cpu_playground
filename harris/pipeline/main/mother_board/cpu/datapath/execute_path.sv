module execute_path(
	input	logic[31:0]	pc_plus4_E, alu_inA_E, write_data_E, imm_E,
	input	logic[5:0]	rt_E, rd_E,
	input	logic[2:0]	alu_ctrl_sig,
	output	logic[31:0]	alu_out_E,
	output	logic[4:0]	reg_id_E,
	output	logic		zero_E
);
	logic[31:0]	alu_inB_E, br_offset;
	assign	br_offset	= { imm_E[29:0], 2'b00 };
	assign	pc_br_E		= pc_plus4_E + br_offset;
	mux2	#(.N(32))	alu_srcB_sel(.sel(), .src0(write_data_E), .src1(imm_E), .out(alu_inB_E));
	mux2	#(.N(5))	r(eg_dst_sel(.sel(), .src0(rt_E), .src1(rd_E), .out(reg_id_E));
	alu	 #(.N(32))	alu(.srcA(alu_inA_E), .srcB(alu_inB_E), .alu_ctrl_sig, .alu_out(alu_out_E), .zero(zero_E));
endmodule
