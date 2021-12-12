module datapath(
	ctrl_bus_if.central ctrl_bus,
	mem_bus_if.central  imem_bus,
	mem_bus_if.central  dmem_bus,
	output  logic	   zero,
	input   logic	   mem_to_reg,
	input   logic	   pc_src, alu_srcB,
	input   logic	   reg_dst, reg_write,
	input   logic	   jmp,
	input   logic[2:0]  alu_ctrl_sig,
	output  logic[31:0] write_data
);
	logic[31:0] pc_F, pc_plus4_F, inst_F;
	logic[31:0]	inst_D, pc_plus4_D, imm_D, rs_out_D, write_data_D; 
	logic[31:0] pc_plus4_E, rt_out_E, alu_inA_E, alu_inB_E, alu_out_E, imm_E, write_data_E;
	logic[4:0]  rt_E, rd_E, reg_id_E;
	logic		zero_E;
	logic[31:0]	alu_out_M, read_data_M;
	logic[4:0]	reg_id_M;
	logic		zero_M;
	logic[31:0]	alu_out_W, read_data_W, reg_id_W, result_W;

	fetch_path			fetch_path(.*);
	ff		#(.N(32))	pcreg_FD(.ctrl_bus, .in(pc_plus4_F), .out(pc_plus4_D));
	ff		#(.N(32))	ireg(.ctrl_bus, .in(inst_F), .out(inst_D));

	decode_path			decode_path(.*);
	ff		#(.N(32))	pcreg_DE(.ctrl_bus, .in(pc_plus4_D), .out(pc_plus4_E));
	ff		#(.N(32))	imm_reg_DE(.ctrl_bus, .in(imm_D), .out(imm_E));
	ff		#(.N(32))	rs_buf_DE(.ctrl_bus, .in(rs_out_D), .out(alu_inA_E));
	ff		#(.N(32))	rt_buf_DE(.ctrl_bus, .in(rt_out_D), .out(write_data_E));
	ff		#(.N(5))	rt_dst_DE(.ctrl_bus, .in(inst_D[20:16]), .out(rt_E));
	ff		#(.N(5))	rd_dst_DE(.ctrl_bus, .in(inst_D[15:11]), .out(rd_E));

	execute_path		execute_path(.*);
	ff		#(.N(32))	alu_out_EM(.ctrl_bus, .in(alu_out_E), .out(alu_out_M));
	ff		#(.N(32))	write_data_EM(.ctrl_bus, .in(write_data_E), .out(write_data_M));
	ff		#(.N(32))	br_reg_EM(.ctrl_bus, .in(pc_br_E), .out(pc_br_M));
	ff		#(.N(1))	zero_EM(.ctrl_bus, .in(zero_E), .out(zero_M));
	ff		#(.N(5))	reg_dst_EM(.ctrl_bus, .in(reg_id_E), .out(reg_id_M));

	memory_path		memory_path(.*);
	assign	zero		= zero_M;	
	assign	write_data	= write_data_M;
	ff		#(.N(32))	alu_out_MW(.ctrl_bus, .in(alu_out_M), .out(alu_out_W));
	ff		#(.N(32))	read_data_MW(.ctrl_bus, .in(read_data_M), .out(read_data_W));
	ff		#(.N(5))	reg_dst_MW(.ctrl_bus, .in(reg_id_M), .out(reg_id_W));

	writeback_path	writeback_path(.*);
endmodule