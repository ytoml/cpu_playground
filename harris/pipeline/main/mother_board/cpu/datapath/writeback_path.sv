module writeback_path (
	input	logic[31:0]	alu_out_W, read_data_W,
	input	logic		mem_to_reg_W,
	output	logic[31:0]	result_W
);
	mux2	#(.N(32))	res_sel(.sel(mem_to_reg_W), .src0(alu_out_W), .src1(read_data_W), .out(result_W));
endmodule