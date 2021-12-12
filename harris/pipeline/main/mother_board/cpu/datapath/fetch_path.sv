module fetch_path (
	ctrl_bus_if.central	ctrl_bus,
	mem_bus_if.central	imem_bus,
	input	logic[31:0]	pc_br_M,
	output	logic[31:0]	inst_F, pc_plus4_F
);
	logic[31:0]	pc_F, pc;
	assign	imem_bus.addr	= pc_F;
	assign	inst_F			= imem_bus.data;
	assign	pc_plus4_F		= pc_F + 32'b100;
	mux2	#(.N(32))	pc_sel(.sel(), .src0(pc_plus4_F), .src1(pc_br_M), .out(pc));
	ff		#(.N(32))	pc_reg(.ctrl_bus, .in(pc), .out(pc_F));
endmodule