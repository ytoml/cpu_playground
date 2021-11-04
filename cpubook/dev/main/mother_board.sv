module mother_board(
	ctrl_bus_if.master	ctrl_bus,
	io_bus_if.master	io_bus,
);
	logic[3:0]	addr;
	logic[7:0]	data;

	mem_bus_if #(.ADDR_WIDTH(4), .DATA_WIDTH(8)) mem_bus();
	assign mem_bus.addr	= addr;
	assign mem_bus.data	= data;

	cpu cpu(.ctrl_bus, .io_bus, .mem_bus);
	rom rom(.mem_bus);

endmodule