module memory_path(
	mem_bus_if.central	dmem_bus,
	input	logic[31:0]	alu_out_M, write_data_M,
	output	logic[31:0] read_data_M
);
	assign	dmem_bus.addr	= alu_out_M;
	assign	read_data_M		= dmem_bus.data;
endmodule