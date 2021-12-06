module mother_board (
    ctrl_bus_if.central ctrl_bus,
    output  logic       mem_enab,
    output  logic[31:0] write_data, data_addr
);
    mem_bus_if #(.ADDR_WIDTH(32), .DATA_WIDTH(32)) mem_bus();
    assign data_addr	= mem_bus.addr;
	assign mem_enab		= mem_bus.enab;

    cpu     cpu(.*);
    memory  memory(.*);
    
endmodule