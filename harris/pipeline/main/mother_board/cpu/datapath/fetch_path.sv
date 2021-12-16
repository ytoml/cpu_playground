module fetch_path (
	ctrl_bus_if.central	ctrl_bus,
	mem_bus_if.central	imem_bus,
	input	logic[31:0]	pc_br_D, pc_jmp_D,
	input	logic		pc_src_D, jmp,
	input	logic		pc_enab,
	output	logic[31:0]	inst_F, pc_plus4_F
);
	logic[31:0]	pc_F, pc, pc_br_next;

	assign	imem_bus.addr	= pc_F;
	assign	inst_F			= imem_bus.data;
	assign	pc_plus4_F		= pc_F + 32'b100;
	mux2	#(.N(32))	pc_br_sel(.sel(pc_src_D), .src0(pc_plus4_F), .src1(pc_br_D), .out(pc_br_next));
	mux2	#(.N(32))	pc_jmp_sel(.self(jmp), .src0(pc_br_next), src1(pc_jmp_D). out(pc));
	enab_ff	#(.N(32))	pc_reg(.ctrl_bus, .enab(pc_enab), .in(pc), .out(pc_F));
endmodule