module memory_path(
	mem_bus_if.central	dmem_bus,
	input	logic[31:0]	alu_out_M,
	input	logic		branch_M, zero_M, mem_enab_M,
	output	logic[31:0] read_data_M
);
	assign	dmem_bus.addr	= alu_out_M;
	assign	dmem_bus.enab	= mem_enab_M;
	assign	read_data_M		= dmem_bus.data;
	assign	pc_src_M		= branch_M & zero_M;
endmodule